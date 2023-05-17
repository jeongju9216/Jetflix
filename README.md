# Jetflix
<img src="https://github.com/jeongju9216/Jetflix/assets/89075274/4832b0ae-dfe7-4331-8e8e-2af5f8464221" width="250" height="250"/>  
  
Netflix 클론 코딩(https://youtu.be/LWGr9fQR498)

기존에는 클론 코딩의 효과에 대해 의아함이 있었지만, 클론 코딩을 하면서 스킬이 늘고 다른 프로젝트에 응용할 수 있다는 점을 깨달았습니다.
이번 넷플릭스 클론 코딩도 이와 같은 목표로 시작합니다.  
  
1차에는 영상을 따라 구현하고, 2차에는 개선점을 고민하고 리팩토링합니다.  
블로그 포스팅에는 이런 과정에서 느낀점을 작성했습니다.  
PR 탭에서 에피소드별로 확인할 수 있습니다.  

<br></br>

바로 이동하기  
#### [1. 구현](https://github.com/jeongju9216/Jetflix/blob/main/README.md#구현)  
#### [2. 리팩토링](https://github.com/jeongju9216/Jetflix/blob/main/README.md#리팩토링)

<br></br>

# 구현
## 1. 기초 UI 구현 (에피소드 1, 2, 3, 4)  
블로그 포스팅: https://jeong9216.tistory.com/619  
- TabBar 생성
- ViewController 파일 생성 및 TabBar 등록
- HomeVC에 TableView 추가
- Table HeaderView 추가
- 네비게이션바 설정
- 위로 스크롤 시 네비게이션바가 숨겨지도록 설정

## 2. 네트워크 통신 (에피소드 5, 6)
블로그 포스팅: https://jeong9216.tistory.com/620  
- 네트워크 통신
- Protocol과 Enum을 이용해 Mixed Type 파싱
- completionHandler -> async/await 변경
- Domain, Data 레이어 추가
- Repository 구현

## 3. 이미지 표시 (에피소드 7, 8, 9, 10)  
블로그 포스팅: https://jeong9216.tistory.com/621  
- 홈 TableHeaderView UI 변경
- CollectionView 등록
- 킹피셔로 UIImageView에 URL로 이미지 로드
- SearchController 구현

## 4. CoreData 사용 (에피소드 11, 12, 13, 14)
블로그 포스팅: https://jeong9216.tistory.com/622  
- Youtube Data API 사용
- WebView를 이용해 Youtube 영상 재생
- CollectionView UIContextMenuConfiguration 구현
- CoreData를 이용한 엔티티 save, fetch, delete

<br></br>

# 리팩토링
## 1. ViewModel 개선
블로그 포스팅: https://jeong9216.tistory.com/623  
- MVC 구조를 MVVM으로 변경
- Enum을 이용해 ViewModelActions 정의
- Enum을 이용해 API 콜 메서드 정리

## 2. UseCase 구현
블로그 포스팅: https://jeong9216.tistory.com/624  
- UseCase를 구현하여 ViewModel과 Repository의 연결을 끊음
- UseCase는 변화가 적도록 Save, Get, Delete 등 동작을 기준으로 분리 구현함
- ContentUseCase는 ContentUseCaseProtocol을 채택해서 ContentRepositoryProtocol을 필수로 가지도록 구현
