# 라이푸
> 너 변했어? 나의 라이푸(Life+Poop) 다이어리

![CleanShot 2023-06-29 at 23 10 1](https://github.com/LifePoop/LifePoop_iOS/assets/57667738/95774914-2b55-463c-9014-39fffcf47e91)

- 배변 활동을 간편하게 기록하고 서로의 건강 활동을 응원해주며, 배변 일지를 리포트할 수 있는 앱입니다.
- 차별화된 ‘변 캐릭터’를 만들어, 배변 활동 기록을 조금 더 유쾌하고 편안하게 풀어내자는 방향성을 담고 있습니다.

<br>
<br>

## 기술 및 사용 이유

|Design Pattern & Architecture|Description|
|---|---|
|**MVVM-C**|UI 표시, 데이터 가공, 화면 전환 로직 분리|
|**Clean Architecture**|계층 간 책임 분리, 재사용성 및 유지보수성 향상|

<br>

|Libraries|Description|
|---|---|
|**RxSwift**|비동기 및 반응형 프로그래밍|
|**SnapKit**|Layout Constraint 코드 간결화|
|**lottie-ios**|애니메이션 처리, 사용자 경험 향상|
|**KakaoSDK(Common, Auth, User)**|카카오 공통, 인증, 사용자 API|

<br>

|Tools|Description|
|---|---|
|**Tuist**|워크스페이스 설정 및 모듈화, 의존성 관리|
|**Fastlane, Github Actions**|Testflight 빌드 배포 자동화|
|**SwiftLint**|일관된 코드 스타일 유지|

<br>
<br>

## 클린 아키텍처 기반 모듈화 구조

<img src="https://github.com/LifePoop/LifePoop_iOS/assets/57667738/b4edce23-7863-45f7-927c-eaed32a5ac06" width="70%">

#### Wiki
- **[프로젝트 모듈화 여정](https://github.com/LifePoop/LifePoop_iOS/wiki/1.-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EB%AA%A8%EB%93%88%ED%99%94-%EC%97%AC%EC%A0%95)**
- **[클린 아키텍처 기반 계층 설계 및 모듈 구성](https://github.com/LifePoop/LifePoop_iOS/wiki/2.-%ED%81%B4%EB%A6%B0-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98-%EA%B8%B0%EB%B0%98-%EA%B3%84%EC%B8%B5-%EC%84%A4%EA%B3%84-%EB%B0%8F-%EB%AA%A8%EB%93%88-%EA%B5%AC%EC%84%B1)**
- **[프로젝트 구성 모듈의 책임에 대한 설명](https://github.com/LifePoop/LifePoop_iOS/wiki/3.-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EA%B5%AC%EC%84%B1-%EB%AA%A8%EB%93%88%EC%9D%98-%EC%B1%85%EC%9E%84%EC%97%90-%EB%8C%80%ED%95%9C-%EC%84%A4%EB%AA%85)**

<br>
<br>

## 실행 화면

|온보딩|회원가입|변 기록|변 기록 리포트|
|---|---|---|---|
|![CleanShot 2023-08-20 at 15 55 47](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/a4d8faf3-13df-46f1-a778-95573975ee68)|![CleanShot 2023-08-20 at 15 17 14](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/14f58b1c-1369-421a-bede-8afdc7ef14e7)|![CleanShot 2023-08-20 at 15 35 46](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/2fb75671-9764-46b5-bbc4-e7a33b2aecc3)|![CleanShot 2023-08-20 at 15 22 20](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/bc7e9326-585e-4e7b-8c31-7659c52e5007)|

|설정 - 프로필 수정|설정|친구의 스토리 & 힘주기|친구 목록 - 초대 코드 복사 & 입력|
|---|---|---|---|
|![CleanShot 2023-08-20 at 15 22 54](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/a7e1b3e3-33ec-446c-915b-5fbcddc21bc8)|![CleanShot 2023-08-20 at 15 30 59](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/4c4ac2fd-aec1-4891-8301-524a0830b027)|![CleanShot 2023-08-20 at 16 04 38](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/8f2765eb-6ec7-4d09-a7d7-79983c8842c6)|![CleanShot 2023-08-20 at 15 44 15](https://github.com/sanghyeok-kim/MyGitHubTracker/assets/57667738/55860582-562a-49ab-81d3-3904e600f5ec)|

<br>

<details>
<summary>스크린 샷</summary>


#### 온보딩 & 정보 입력  
![Group 2884](https://github.com/LifePoop/LifePoop_iOS/assets/57667738/cddf5efd-edb8-4d1d-80bc-6b07bffff5f3)

#### 홈 화면 & 변 기록  
![Group 2888](https://github.com/LifePoop/LifePoop_iOS/assets/57667738/bc13231b-5312-414d-b288-bb3649e2b9d0)

#### 친구 목록 & 리포트 화면  
![Group 2886](https://github.com/LifePoop/LifePoop_iOS/assets/57667738/ba616eab-e7c6-4df9-8083-691affe420b9)

#### 설정  
![Group 2887](https://github.com/LifePoop/LifePoop_iOS/assets/57667738/017900b9-d2d6-45a5-a510-b6e2d2e1501a)
</details>

<br>

<details>
<summary>데모 영상</summary>

#### 온보딩
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/3bfc678c-607c-4d4e-a39b-23cf9ce825ba

#### 정보 입력
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/24f30a6a-863a-45aa-9168-38266869db42

#### 변 기록
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/297daab7-0950-43cf-82e6-e44de54de4bd

#### 리포트
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/476a9b88-6cc5-45f7-82b8-7da2aa37c807

#### 설정 - 프로필 정보 수정
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/b56b22a4-3477-4cbb-95aa-eb32b78c0914

#### 설정
https://github.com/LifePoop/LifePoop_iOS/assets/57667738/def55523-1540-4d21-99be-20dcc0fb389e

</details>


<br>
<br>


## iOS Developers

|<img width="200" alt="CleanShot 2023-07-01 at 00 46 37@2x" src="https://github.com/LifePoop/LifePoop_iOS/assets/57667738/f6f4144f-c26d-4bf6-8af7-9abff02a9271">|<img width="200" alt="CleanShot 2023-07-01 at 00 46 23@2x" src="https://github.com/LifePoop/LifePoop_iOS/assets/57667738/69bef9ea-6241-40ef-ad1d-33d29d475241">|
|---|---|
|[Mase](https://github.com/sanghyeok-kim)|[Jed](https://github.com/junu0516)|
