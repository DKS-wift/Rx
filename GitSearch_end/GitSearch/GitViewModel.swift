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
        let text:PublishSubject<String> = .init()
    }
    
    
    struct Output {
        let dataSource:BehaviorRelay<[RepoModel]> = .init(value: [])
        let filteredDataSource:BehaviorRelay<[RepoModel]> = BehaviorRelay(value: [])
    }
    
    func transform(from input:Input) -> Output {
        let output = Output()
        
        
        getRepos()
            .asObservable()
            .bind(to: output.dataSource,output.filteredDataSource)
            .disposed(by: disposeBag)
        
        input.text
            .withLatestFrom(output.dataSource){($0,$1)}
            .map { (text,dataSource) in
                return text.isEmpty ? dataSource : dataSource.filter({$0.name.lowercased().contains(text)})
            }
            .debug("TEST")
            .bind(to: output.filteredDataSource)
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
