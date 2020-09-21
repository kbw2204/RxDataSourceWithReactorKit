안녕하세요! 오랫만의 포스팅 입니다. 오늘은 리팩토링을 하면서 알게 된 ReactorKit + RxDataSource 깔끔하게 사용한 방법에 대해 포스팅 해볼까 합니다.



> 혹시 ReactorKit을 모르신다면 -> [리액터킷 포스팅](https://apple-apeach.tistory.com/16)
>
> RxDataSource는 여기 있습니당 -> [RxDataSource 사용 포스팅](https://apple-apeach.tistory.com/27)



사용법은 RxDataSource를 사용하는 것이기 때문에 UITableView, UICollectionView 에서 사용할 수 있고, 사용법은 똑같습니다. 저는 UITableView를 기준으로 설명해보도록 할게요~ cell을 편하게 구성하기 위해 ReusableKit을 추가 사용하도록 하겠습니다.



우선 cell에 들어갈 data를 정의해주기 위한 CellDataModel를 만들어 줄게요.

여러개의 cell에 들어가지 않을 data도 있을 수 있으니 해당 부분은 옵셔널 처리를 해서  정의해주겠습니다.

<script src="https://gist.github.com/c12fd7dc9e3f74e020c8eaf123ea9011.js"></script>



### 기존 RxDataSource 사용시

SectionModel<header, cellDataModel>를 사용해서 dataSource를 만들어 줬었습니다. 

<script src="https://gist.github.com/kbw2204/bf563eb1fed0390fa5fcdf6e3bd734d9.js"></script>

하지만  이렇게 cell을 만들어 주면 viewController에서 cell의 UI 요소들에게 data를 바인딩 해줘야 했어요. 이를 수정해주기 위해 SectionModel의 Items 부분을 CellDataModel로 해주지 않고, cellViewModel로 변경해 줄 거에요. reactorKit에서의 viewReactor는 ViewModel의 개념이기 때문에 ViewReactor를 가져와 주면 되겠죠?



### ReactorKit을 적용 (Cell 하나 사용시)

우선 Cell의 ViewReactor를 정의해줄게요. 만약 Action이 있다면 기존 방법처럼 정의해주면 되지만, Action이 없다면 noAction으로 정의해줍시다.

<script src="https://gist.github.com/cc66e2c765dc3565e2b8e50a6665f229.js"></script>

State의 자료형을 CellDataModel로 정의해 준 이유는 Cell 부분에서 reactor를 통해 Cell에서 UI 요소들에게 data를 바인딩 시켜 주기 위해 정의해주었습니다. 현재는 View에 대한 모델만 가지고 있기 때문에 State의 자료형을 CellDataModel로 바로 주었지만, 만약 다른 State값들이 있다면 State값에 따로 displayData: CellDataModel 같은 state값을 줘서 관리해주어도 됩니당.



그럼 CellReactor를 정의해주었으니 Cell에 적용시켜줘야겠죠??

<script src="https://gist.github.com/fac35091582357679911cef782ae7391.js"></script>

이렇게 구현을 해 준 이유는 cell의 data를 viewModel 역할을 하고 있는 cellReactor로 가져오고, 이를 cell에서 가져와서 바인딩 해주는 흐름을 만들어 줄려고 이렇게 구현을 하였습니다.

<img src="https://github.com/kbw2204/gifEmoticon/blob/master/gif/어질.gif?raw=true" width="25%">

zz.. 그럼 viewController의 dataSource 부분이 어떤식으로 변하는지 리팩토링 해보겠습니다.

<script src="https://gist.github.com/b8af5017005a8309db1f890956db32fa.js"></script>

<img src="https://github.com/kbw2204/gifEmoticon/blob/master/gif/잘했어요.gif?raw=true" width="25%">

SectionModel의 Items 부분에 cellReactor를 넣어주고 cell의 reactor에 model인 reactor를 넣어주면 됩니다. 좀 깔끔해졌죠..? (하지만 파일수가... 많아졌어요..)



그러나 만약 Cell을 2개 이상 써야할 땐 어떻할까요..? SectionModel을 여러개 만들 수도 없고.. 여기서 고민에 빠졌었습니다. =_=..



### ReactorKit 적용 (Cell 2개 이상 사용시)

SectionModel의 Items에 들어갈 CellReactor들을 enum으로 만들어서 이 enum 값을 Items로 사용해주면 됩니다. 그리고 switch 문으로 cell 마다 reactor를 넣어주면 되죠.



우선 viewController도 reacotrKit을 사용할 것이기 때문에 viewReactor가 있어야겠죠? viewReactor를 만들어 주고 거기에서 enum을 만들어 주도록 하겠습니당

<script src="https://gist.github.com/kbw2204/551e12eb6799e30da523c30b8714906e.js"></script>

요런식으로 enum으로 cellViewReactor들을 정의해주고, 나중에 case let 을 사용해서 사용해주면 됩니다!

> 혹시 case ..(..) 이 부분이 이해가 안되시는 분은 **"열거형 케이스 패턴"** 을 공부해보시면 됩니다! 이부분은 추후 포스팅 해보도록 하겠습니다 ㅠㅠ..



그럼 viewController의 dataSource부분은 이런식으로 리팩토링 해주시면 됩니다.

<script src="https://gist.github.com/kbw2204/575a50b547d8dc054cded3d5c4868783.js"></script>

SectionModel의 Items 부분에 enum을 넣어줬기 때문에 model인 sectionItems를 switch문으로 구분해주었고, case let을 사용해서 해당 자료형(cellReactor) 값을 reactor로써 가져와서 사용하였습니다.



이렇게 만든 dataSource를 tableView에 바인딩 해주면 되는데, 아직 뿌려줄 data가 없죠..? 뿌려줄 데이터를 viewController의 ViewModel 역할을 하고 있는 ViewReactor의 State값에 작성해줍시당



<script src="https://gist.github.com/fe1ffb5a672886e51b31e619fc7cd794.js"></script>

rxDataSource는 기본적으로 section 단위로 뿌려주기 때문에 [TableViewSectionModel] 로 작성해줘야 합니당



그런데 저 자료형 꼴로 뿌려줄 데이터를 작성해주기 애매하더라구요 =_=.. 그래서 작성하기 편하라고 추가로 cellType이라는 enum과 sections을 만들어주는 configSections() 메소드를 추가 작성해줬어요.



<script src="https://gist.github.com/93575767ed86385e1e646c8361991e6e.js"></script>

좀 더 이쁘게 넣어주고 싶었는데.. 고민해서 나온 결과가 이거에요 ㅠ _ㅜ..

displayData라는 변수에 넣고싶은 cell을 넣어주고.. for으로 sections에 추가해주는식으로 해서 작성해봤어요..



이렇게 만들어 준 sections을 state값인 sections에 init 부분에서 넣어주면 됩니당.. 그럼 우선 넣어줄 데이터는 끝.. 



액션을 추가해주지 않은 ViewReactor 전체 코드입니다.

<script src="https://gist.github.com/30bdf7ca93a6231a7d0b265f00d0cc55.js"></script>

<img src="https://github.com/kbw2204/gifEmoticon/blob/master/gif/좌절.gif?raw=true" width="25%">

뭔가 많네요.. 그럼 마지막으로 viewController의 tableView에 뿌려줄 data 값을 바인딩 해주면 끝입니다.

이런식으로..

<script src="https://gist.github.com/kbw2204/a38a016cc500c9ae29d68ea8b0c5ebf6.js"></script>

그리고 빌드를 해보면 대략 요렇게 나옵니다 ㅋ..

<img src=".img/실행화면.png" alt="실행화면" style="zoom:33%;" />

추가적으로 cell을 선택하는 Action을 reactorKit 에 맞춰서 작성해 줄 수도 있어요.

ViewReactor 부분에 cell을 선택하는 action과 muation, state값을 정해주고

<script src="https://gist.github.com/0a8ab5867b41e2e043f2fc936db22941.js"></script>

viewController의 bind 메소드에 추가 작성을 해주시면 됩니다.

<script src="https://gist.github.com/kbw2204/038c13716c0b05a6bfce6d0e0411b94c.js"></script>

추가로 cell도 reactorKit을 적용하고 있기 때문에 이런 방식으로 action을 추가해 줄 수 있습니다.



오늘은 ReactorKit + RxDataSource를 사용해서 깔끔..? 하게 사용해보는 리팩토링 과정을 포스팅 해봤습니다. 작성해보고 나니 깔끔한 것 같지는 않네요 ㅠㅠ.. 그래도 이 코드를 구현하는데 나름 고민을 많이 했었기 때문에 저도 정리를 하고, 다른 분들에게 도움이 되면 좋으니깐 이렇게 포스팅을 해보았습니다.



요즘은 이력서 작성하고 코딩테스트 준비하느냐 포스팅을 많이 못썻네요.. 빨리 현재 개발하고 있는 커플 디데이 앱이 런칭 됬으면 좋겠어요.. 그럼 오늘 하루도 고생하셨고 코로나 조심하시고 좋은하루 되세용

<img src="https://github.com/kbw2204/gifEmoticon/blob/master/gif/그럼이만...gif?raw=true" width="25%">

그럼 이만..



[예제 프로젝트 repo]()



> 추가로 혹시 iOS 앱 개발이 아직 미숙하다고 느끼시고 이 강의를 안들어 보신 분은 edWith - 부스트코스 iOS 강의를 꼭 들어보시는걸 추천드려요. 카카오톡 오픈톡방에 iOS 부스트코스 오픈톡방도 있으니 한번쯤 들어오셔서 swift 질문도 하고 정보도 공유하면 좋을 것 같아요.

- [Naver - Edwith - 부스트코스 iOS](https://www.edwith.org/boostcourse-ios)

- [부스트코스 iOS 카카오톡 오픈톡방](https://open.kakao.com/o/gZ6pX4gb)

