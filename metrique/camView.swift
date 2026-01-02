// Metrique MVP – SwiftUI App mit Kamera, automatischer BKP-Klassifikation via OpenAI und EXIF-Caption-Tagging
// Wichtig: Setze deinen OpenAI API-Key unten ein

import SwiftUI
import Photos
import AVFoundation
import ImageIO
import MobileCoreServices

struct ContentView: View {
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

            Button("📷 Foto aufnehmen") {
                showCamera = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(isProcessing)

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
        let apiKey = "DEIN_OPENAI_API_KEY_HIER"
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!

        let base64Image = imageData.base64EncodedString()
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]

        let json: [String: Any] = [
            "model": "gpt-4-vision-preview",
            "messages": [
                ["role": "system", "content": "Du bist ein Bau-Experte für die Schweiz. Analysiere das Bild und gib mir eine Caption mit BKP-Tags. Formatiere so: #metrique #bkpXYZ Beschreibung"],
                ["role": "user", "content": [
                    ["type": "text", "text": "Bitte klassifiziere das Bild."],
                    ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64Image)"]]
                ]]
            ],
            "max_tokens": 100
        ]

        let body = try! JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {
                self.isProcessing = false
            }
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let content = message["content"] as? String
            else {
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

struct ContentView2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

