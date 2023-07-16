//
//  GitViewModel.swift
//  GitSearch
//
//  Created by 박의서 on 2023/06/26.
//

import Foundation
import RxSwift
import RxRelay
import Alamofire

class GitViewModel {
    let disposeBag = DisposeBag()
    
    
    
    struct Input {
        let textInput: BehaviorRelay<String> = .init(value: "")
        
        
    }
    
    
    struct Output {
        let dataSource: BehaviorRelay<[RepoModel]> = .init(value: [])
        let filteredSource: BehaviorRelay<[RepoModel]> = .init(value: [])
        
        
    }
    
    func transform(from input:Input) -> Output {
        let output = Output()
        
        getRepos()
            .asObservable()
            .bind(to: output.dataSource, output.filteredSource)
            .disposed(by: disposeBag)
        
        output.filteredSource
            .debug("HELLO")
            .subscribe()
            .disposed(by: disposeBag)
       
        Observable.combineLatest(input.textInput, output.dataSource)
            .map({ text,dataSource in

                return text.isEmpty ? dataSource : dataSource.filter({$0.fullName.contains(text)})
            })
            .bind(to: output.filteredSource)
            .disposed(by: disposeBag)
        
        
        return output
        
    }
    
}

extension GitViewModel {
    
    func getRepos() -> Single<[RepoModel]>{
        
       return Single.create{ single in
            
            AF.request("https://api.github.com/users/kpk0616/starred",
                       method: .get,
                       headers: ["Content-Type":"application/json",
                                 "Accept":"application/json",
                                 "Authorization":"9LTA7HYRJMYH"])
            .validate(statusCode: 200..<300)
            .responseDecodable(of:[RepoModel].self){ data in
                switch data.result {
                    
                case .success(let response):
                    single(.success(response))
                case .failure(let error):
                    single(.failure(error))
                }
                
            }
            
            return Disposables.create()
        }
        
    }
}
