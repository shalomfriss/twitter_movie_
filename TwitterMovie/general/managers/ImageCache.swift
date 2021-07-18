//
//  ImageCache.swift
//  TwitterMovie
//
//  Created by Shalom Friss on 7/17/21.
//

import UIKit
import Foundation
public class ImageCache {
    
    public static let publicCache   = ImageCache()
    private var cachedImages        = [URL: UIImage]()
    private var loadingResponses    = [URL: [(UIImage?) -> Swift.Void]]()
    
    final func load(url: URL, completion: @escaping (UIImage?) -> Swift.Void) {
        
        //Check for the cached image
        if let cachedImage = cachedImages[url] {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        //Append the completion response
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        //Run the data task
        let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            
            //Check for an error
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            //cache the image and execute all response blocks
            self.cachedImages[url] = image
            for block in blocks {
                DispatchQueue.main.async {
                    block(image)
                }
                return
            }
        }
        task.resume()
        
    }
        
}
