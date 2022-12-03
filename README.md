# BookSearch

### Network

NetworkManager 는 URLSession을 통해 데이터를 요청후 결과값을 콜백으로 넘겨주는 하는 기능을 가지고 있습니다. 

```jsx
private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}
```

초기화에 URLSession을 주입 받아 사용합니다. 따라서 유닛테스트에서 MockURLSession을 주입받아 사용할수 있습니다.

검색 화면 상세화면에서 각각의 Network가 있고 모두  NetworkManager를 주입받아 사용합니다.

```jsx
final class SearchNetwork: SearchNetworkProtocol {
    private let network: NetworkManager
    private let endPoint = "https://api.itbook.store/1.0/search/"
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func search(query: String, page: Int, completion: @escaping (Result<SearchList,Error>)-> Void) {
        network.fetchData(url: "\(endPoint)\(query)/\(page)", dataType: SearchList.self, completion: completion)
    }
}
```

에러 타입은 이렇게 정의 되어있고 failure()를 통해 에러가 VM으로 전달됩니다.

```jsx
enum NetworkError: Error {
    case urlError
    case invalid
    case failToDecode(String)
    case dataNil
    case serverError(Int)
}
```

### MVVM

Presentation 레이어에서 mvvm 패턴을 사용했고 

Combine을 활용했습니다.

VC ↔ VM 간에 이벤트 전달 및 처리는

VC - bindViewModel() 함수 

VM - transform() 함수 안에 모두 정의 되어있습니다.

```jsx

//VC
private func bindViewModel() {
        
    let searchText = searchView.textField.textPublisher
    let loadMore = loadMoreSubject.eraseToAnyPublisher()
    let input = SearchViewModel.Input(searchText: searchText, loadMore: loadMore)
    let output = viewModel.transform(input: input)
    
    output.bookList
        .sink {[weak self] books in
                //Do Something
    }.store(in: &cancellables)
    
    output.errorMessage
        .sink {[weak self] errorMessage in
                    //Do Something}
        .store(in: &cancellables)
    
}

//VM 
func transform(input: Input) -> Output {
    input.searchText
            .sink {[weak self] text in
            self?.search(query: text)
        }
        .store(in: &cancellables)
    
    input.loadMore
        .sink { [weak self] in
            self?.loadMore()
        }
        .store(in: &cancellables)
        
    return Output(bookList: bookList.eraseToAnyPublisher(), errorMessage: errorMessage.eraseToAnyPublisher())
}

```
