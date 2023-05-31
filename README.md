# HighwayInfo
> 고속도로 교통정보
개발기간: 2023.03.02 ~ 2023.05.22 (총 12주)

<br>


### 앱 다운받기
<img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/9069258e-c3c9-42cc-aedc-ee89c26746c5" width="200" height="200">


<br>


### 개발환경
![iOS badge](https://img.shields.io/badge/iOS-14.0%2B-9cf) ![](https://img.shields.io/badge/RxSwift-6.5.0-ff69b4) ![](https://img.shields.io/badge/Swift-5.7-blue) ![](https://img.shields.io/badge/CocoaPods-1.11.2-orange)


<br>


### 프로젝트 소개
- 실시간 돌발정보를 제공합니다.
- 고속도로 휴게시설(휴게소, 주유소) 정보를 제공합니다.
- 지도에 내가 이용하는 고속도로를 표시합니다.
- 경로 중 이용 가능한 휴게소의 대표메뉴, 편의시설, 브랜드매장 정보를 제공합니다.


<br>


### 프로젝트 주요 기능
> 실시간 고속도로 교통사고 소식을 알려드려요!

<img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/e592c718-697f-4500-915a-098cd5fa0b81" width="250" height="500"><img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/c700142a-7987-4905-8025-51f02d5bc727" width="250" height="500">

> 도착지를 검색하고 내가 이용하는 고속도로를 확인해보세요!

<img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/f873c129-f814-4d46-b282-a157aace3cc2" width="250" height="500"><img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/04eed4fa-e31d-4c4d-9531-75b7eeacbf9e" width="250" height="500"><img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/cec448e8-f390-45a0-9a80-d26476b17576" width="250" height="500">

> 휴게소의 편의시설, 음식, 유가정보를 제공합니다.

<img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/58c2cfde-1176-417e-9cdc-7ab3aa507d89" width="250" height="500"><img src="https://github.com/na-young-kwon/HighwayInfo/assets/74536728/f78c25d3-33f8-43d9-a28b-d8ddce25bd52" width="250" height="490">


<br>


## 아키텍처

### MVVM
-  화면을 그리는 코드와 데이터를 처리하는 코드를 분리 구성하여 앱을 구성했습니다.
-  뷰: 화면을 그리는 역할을 담당합니다.
- 뷰 모델: 사용자의 입력을 받아 그에 맞는 이벤트를 처리하고, 모델의 read, update, delete을 담당합니다.
- 모델: 데이터 구조를 정의합니다.

### 클린 아키텍처
- 프레젠테이션, 도메인, 데이터 레이어로 구성했습니다.
- 내부레이어에서 외부레이어의  종속성을 가지지 않도록 구현했습니다.
- 레파지토리 프로토콜을 통해 의존성 역전 원칙을 준수하도록 하였습니다.
- 각 레이어의 역할을 분리해 테스트가 용이한 구조가 되었습니다.

### 코디네이터
- 뷰 컨트롤러의 네비게이션 flow를 제어하기 위해 코디네이터 패턴을 도입하였습니다.
- 기존 뷰 컨트롤러가 가지던 화면전환 책임을 분리하여 독립적인 클래스를 만들었습니다.

### Input/Output Modeling
- 화면에서 일어나는 이벤트를 Input에 정의하고, 뷰로 넘겨줄 데이터들을 Output에 정의해주었습니다.
- transform 메서드로 이벤트나 데이터를 처리해 Output으로 반환하도록 구현했습니다.

<br>

## 구현내용

### View
- 탭뷰를 사용하여 홈 / 검색 화면을 전환할 수 있도록 구현했습니다.
- 주소검색 테이블뷰를 구현했습니다.
- TMapPolyline으로 예상 경로를 지도에 나타냅니다.
- 지나는 고속도로를 지도에 표시합니다.

### Cache
- NSCache를 이용해 메모리 캐시를 구현했습니다.
- 앱을 사용하는 동안 동일한 고속도로 휴게소 조회시 메모리에 저장된 정보를 보여줍니다.

### DiffableDataSource
- 컬렉션뷰를 위한 데이터를 관리 및 UI 업데이트를 위해 디퍼블 데이터소스를 활용했습니다.
- 데이터가 달라진 부분을 추적하여 자연스럽게 화면을 업데이트 합니다.

### CoreLocation
- 사용자의 현재위치 조회를 위해 CoreLoccation을 사용했습니다.
- 좌표값을 주로소 바꾸로 현재위치로부터 목적지 까지의 경로를 구합니다.

### 네트워크
- Tmap, 한국도로공사, ITS국가교통정보센터, 경기도 교통 정보 센터 등 공공 데이터를 활용했습니다.
- CodingKeys 프로토콜을 사용하여 API 명세에 맞도록 타입 구현했습니다.
- API통신 결과를 이용하기 위해 JSONDecoder 사용했습니다.

