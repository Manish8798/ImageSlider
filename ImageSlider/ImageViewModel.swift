//
//  ImageViewModel.swift
//  ImageSlider
//
//  Created by Manish kumar on 19/12/24.
//

import Foundation

final class ImageViewModel: ObservableObject {
    
    @Published var photoModelResponse: PhotoModel?
    private let accessKey = "QrcBgDtiyyDpr8BTtF1v74c5b4wp-fjEqsjYFd4FEmw"


    func getPhotos() async {
        
        guard let url = URL(string: "https://api.unsplash.com/photos?page=1&per_page=30")
        else {return}
        
        let headers = [
            "Authorization": "Client-ID \(accessKey)"
        ]
        
        let requestManager = RequestManager<PhotoModel>()
        requestManager.get(url: url, headers: headers) { result in
            
            switch result {
            case .success(let (data, statusCode)):
                self.photoModelResponse = data
                debugPrint("RES", data)
                
            case .failure(let error):
                debugPrint("getPhotos Error: \(error)")
            }
        }
    }
}
