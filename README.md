# Jetflix
<img src="https://github.com/jeongju9216/Jetflix/assets/89075274/4832b0ae-dfe7-4331-8e8e-2af5f8464221" width="250" height="250"/>  
  
Netflix 클론 코딩(https://youtu.be/LWGr9fQR498)

기존에는 클론 코딩의 효과에 대해 의아함이 있었지만, 클론 코딩을 하면서 스킬이 늘고 다른 프로젝트에 응용할 수 있다는 점을 깨달았습니다.
이번 넷플릭스 클론 코딩도 이와 같은 목표로 시작합니다.  
  
1차에는 영상을 따라 구현하고, 2차에는 개선점을 고민하고 리팩토링합니다.  
블로그 포스팅에는 이런 과정에서 느낀점을 작성했습니다.  

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

