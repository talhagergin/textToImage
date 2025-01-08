//
//  ImageView.swift
//  textToImage
//
//  Created by Talha Gergin on 9.01.2025.
//

import SwiftUI

struct ImageView: View {
    @State private var textClient = textToImageClient()
    @State private var generatedImageURL: String?
    @State public var requestBody: String = "a cat"
    private func getImage(requestBody: String) async{
        do{
            generatedImageURL = try await textClient.postLeaguesByCountry(requestBody: requestBody)
        }catch{
            print(error.localizedDescription)
        }
    }
    var body: some View {
        VStack {
            TextField(
                   "Lütfen oluşturmak istediğiniz resim için metin giriniz.",
                   text: $requestBody
               )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                Task{
                    await getImage(requestBody: requestBody)
                }
            }){
                Text("Resmi Oluştur")
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            }
            
            // Eğer imageURL varsa, resmi göster
                     if let imageURL = generatedImageURL, let url = URL(string: imageURL) {
                         AsyncImage(url: url) { phase in
                             switch phase {
                             case .empty:
                                 ProgressView() // Yükleniyor durumu
                                     .progressViewStyle(CircularProgressViewStyle())
                                     .padding()
                             case .success(let image):
                                 image
                                     .resizable()
                                     .scaledToFit()
                                     .frame(width: 300, height: 300) // Boyutu ihtiyaca göre ayarlayabilirsiniz
                                     .padding()
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
/*
#Preview {
    ImageView()
}
*/
