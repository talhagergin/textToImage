//
//  ImageView.swift
//  textToImage
//
//  Created by Talha Gergin on 9.01.2025.
//

import SwiftUI
import Photos

struct ImageView: View {
    @State private var textClient = textToImageClient()
    @State private var generatedImageURL: String?
    @State private var requestBody: String = ""
    @State private var isButtonDisabled = true
    @State private var isTextFieldDisabled = false
    @State private var isImageDownloaded = false
    @State private var isLoading = false
    private let maxCharacterLimit = 200

    private func getImage(requestBody: String) async {
        isButtonDisabled = true
        isTextFieldDisabled = true
        isLoading = true
        
        do {
            generatedImageURL = try await textClient.postLeaguesByCountry(requestBody: requestBody)
        } catch {
            print(error.localizedDescription)
        }

        isLoading = false
        isButtonDisabled = false
        isTextFieldDisabled = false // Text field'ı tekrar aktif et
    }
    
    func downloadImage(from imageURL: URL) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                if let image = UIImage(data: data) {
                    saveImageToPhotos(image: image)
                }
            }.resume()
    }

    func saveImageToPhotos(image: UIImage) {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if success {
                    print("Image saved to photos successfully.")
                    isImageDownloaded = true
                } else {
                    print("Error saving image to photos: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

    var body: some View {
        VStack {
            Text("Yapay Zeka ile Resim Oluştur")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            TextEditor(text: $requestBody)
                .frame(minHeight: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .disabled(isTextFieldDisabled)
                .onChange(of: requestBody) { newText in
                    if newText.count > maxCharacterLimit {
                        requestBody = String(newText.prefix(maxCharacterLimit))
                    }
                    isButtonDisabled = newText.isEmpty
                }

            Text("\(requestBody.count)/\(maxCharacterLimit)")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
            
            Button(action: {
                Task {
                    await getImage(requestBody: requestBody)
                }
            }) {
                Text("Resmi Oluştur")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isButtonDisabled ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isButtonDisabled)
            .padding(.horizontal)
            
            if isLoading {
                ProgressView("Resim Oluşturuluyor...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            if let imageURL = generatedImageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        EmptyView()
                    case .success(let image):
                        VStack{
                            image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .padding()
                            
                            Button(action: {
                                downloadImage(from: url)
                            }) {
                                HStack{
                                    Image(systemName: "arrow.down.circle.fill")
                                        .font(.title)
                                    Text("İndir")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.green)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                            }
                            .alert(isPresented: $isImageDownloaded) {
                                Alert(
                                    title: Text("Başarılı"),
                                    message: Text("Resim başarıyla galeriye kaydedildi."),
                                    dismissButton: .default(Text("Tamam"))
                                )
                            }
                                
                        }
                    case .failure:
                        Text("Resim yüklenemedi.")
                            .foregroundColor(.red)
                            .padding()
                    @unknown default:
                        Text("Unknown error")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ImageView()
}
