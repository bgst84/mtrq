// Metrique MVP – SwiftUI App mit Kamera, automatischer BKP-Klassifikation via OpenAI und EXIF-Caption-Tagging
// Wichtig: Setze deinen OpenAI API-Key unten ein

import SwiftUI
import Photos
import AVFoundation
import ImageIO
import MobileCoreServices

struct camView: View {
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var isProcessing = false
    @State private var resultText = ""

    private let testMode = false // für Preview aktivieren

    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Button(action: {
                showCamera = true
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24))
                    Text("📷 Foto aufnehmen")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .shadow(radius: 3)
            }
            .disabled(isProcessing)
            .padding(.horizontal)

            if isProcessing {
                ProgressView("Bild wird analysiert…")
            } else if !resultText.isEmpty {
                Text("Vorgeschlagene Caption:")
                Text(resultText)
                    .font(.caption)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)

                Button("💾 In Fotos speichern") {
                    if let image = image, let data = image.jpegData(compressionQuality: 0.9),
                       let taggedData = writeCaptionToImage(data: data, caption: resultText) {
                        saveToPhotoLibrary(imageData: taggedData)
                        resultText = ""
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .sheet(isPresented: $showCamera) {
            CameraView(image: $image, isPresented: $showCamera, onCapture: { capturedImage in
                if let data = capturedImage.jpegData(compressionQuality: 0.9) {
                    classifyImageWithOpenAI(imageData: data) { tags in
                        self.resultText = tags
                    }
                }
            })
        }
        .onAppear {
            if testMode {
                self.image = UIImage(systemName: "photo")
                self.resultText = "#metrique #bkp211 Schalung Ortbeton"
            }
        }
    }

    func classifyImageWithOpenAI(imageData: Data, completion: @escaping (String) -> Void) {
        isProcessing = true
        let apiKey = Config.openAIKey
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!

        // Compress image to reduce payload size
        let compressedImage = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5)  // Reduced quality
        let base64Image = compressedImage?.base64EncodedString() ?? imageData.base64EncodedString()
        
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let json: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": "Du bist ein Bau-Experte für die Schweiz. Analysiere das Baustellenfoto und antworte nur mit einer einzeiligen Caption im Format: #metrique #bkpXXX [max 5 Stichworte]"],
                ["role": "user", "content": [
                    ["type": "text", "text": "Klassifiziere das Bild."],
                    ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                ]]
            ],
            "max_tokens": 50,
            "temperature": 0.3  // Added temperature for faster, more focused responses
        ]

        let body = try! JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isProcessing = false
            }

            if let error = error {
                print("❌ Fehler bei der Anfrage: \(error.localizedDescription)")
                completion("#metrique Fehler bei der Anfrage")
                return
            }

            guard let data = data else {
                print("❌ Keine Daten erhalten")
                completion("#metrique Keine Daten erhalten")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔎 Antwort von OpenAI:\n\(jsonString)")
            }

            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                print("❌ JSON-Struktur unerwartet")
                completion("#metrique Fehler bei der Klassifikation")
                return
            }

            completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
        }.resume()
    }

    func writeCaptionToImage(data: Data, caption: String) -> Data? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let type = CGImageSourceGetType(source) else { return nil }

        let metadata = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] ?? [:]
        var mutableMetadata = metadata

        var iptc = mutableMetadata[kCGImagePropertyIPTCDictionary as String] as? [String: Any] ?? [:]
        iptc[kCGImagePropertyIPTCCaptionAbstract as String] = caption
        mutableMetadata[kCGImagePropertyIPTCDictionary as String] = iptc

        let dataWithCaption = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(dataWithCaption, type, 1, nil) else { return nil }

        CGImageDestinationAddImageFromSource(destination, source, 0, mutableMetadata as CFDictionary)
        CGImageDestinationFinalize(destination)

        return dataWithCaption as Data
    }

    func saveToPhotoLibrary(imageData: Data) {
        PHPhotoLibrary.shared().performChanges {
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
            creationRequest.creationDate = Date()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isPresented: Bool
    var onCapture: (UIImage) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.onCapture(image)
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

// MARK: - Preview

struct camView_Previews: PreviewProvider {
    static var previews: some View {
        camView()
    }
}
