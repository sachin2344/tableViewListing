//
//  ListViewModel.swift
//  DemoProject
//
//  Created by sachin on 28/05/24.
//

import Foundation

final class ListViewModel{
    
    var postsArray: [Post] = []
    var page: Int = 1
    var noMoreData: Bool = false
    
    var eventHandler: ((_ event: Event) -> Void)?
    
    func fetchData(){
        Task{
            do {
                if page == 1{
                    eventHandler?(.loading)
                }
                if !noMoreData{
                    let result = try await ApiService.shared.fetchPosts(page: page)
                    switch result{
                    case .success(let posts):
                        if !posts.isEmpty{
                            self.showUnique(posts: posts)
                        } else{
                            noMoreData = true
                        }
                    case .failure(_):
                        eventHandler?(.errorFetchingPosts)
                    }
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
        }
    }
}

// MARK: - setting up post array
extension ListViewModel{
    
    func showUnique(posts: [Post]) {
        let startTime = DispatchTime.now()

            // for heavy task
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            for post in posts{
                if !postsArray.contains(post){
                    self.postsArray.append(post)
                }
            }
            eventHandler?(.postsLoaded)
        }
        
        let endTime = DispatchTime.now()
        let timeElapsed = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000 // in seconds
        print("Heavy computation for item \(posts) took \(timeElapsed) seconds")
        
    }
    
}

// MARK: - Used for Binding
extension ListViewModel{
    enum Event{
        case loading
        case postsLoaded
        case errorFetchingPosts
    }
}
