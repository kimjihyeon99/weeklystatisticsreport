# weeklystatisticsreport

## 인포카 앱에 저장되는 데이터를 활용한 주간 통계 리포트 시스템

**개발기간** : 21.06.21 ~ 21.08.17

**개발자** : [kimjihyeon99](https://github.com/kimjihyeon99), [Kim-AYoung](https://github.com/Kim-AYoung), [ssonghj](https://github.com/ssonghj)

**개발환경** : Intellij(Dart), Flutter

## 0. Introduce

(주)인포카가 제작한 어플리케이션 '인포카'를 기반으로 구현하였습니다. 

백마인턴십을 진행하면서 인포카 앱에 저장되는 데이터를 활용한 주간 통계 리포트 시스템을 주제로 프로젝트를 수행하였습니다. 

### 📌 challege

- ‘INFOCAR’ 앱 내의 모든 정보를 종합적으로 판단 또는 비교할 수 있는 공간이 없습니다. 
- 지난주의 데이터와 이번주의 데이터를 비교하기 위해서는 사용자가 직접 시간 설정 후 각각 확인 해야 합니다.
- 사용자가 '인포카' 앱에 머무는 시간이 짧고, 차량진단 서비스를 위주로 사용합니다. 

### 📌 solution

- ‘INFOCAR’ 앱 내의 흩어져 있는 정보를 한 곳에 가져와 통계를 내어 **시각적으로 보기 편하게** 해줍니다.
- 지난주와 이번주의 데이터 통계 결과를 비교해 보여주어 사용자가 **자신의 차량 이용 패턴을 한 눈에 알 수있도록** 합니다.
- 사용자가 주간 통계 리포트 서비스를 이용함으로써, 사용자의 차량 이용 패턴에 대한 코멘트를 통해 **더 적극적으로 앱을 사용할 수 있도록 유도**합니다. 

## 1. Start 

✅ 주간통계 메뉴를 클릭하면 API에서 정보를 가져오는 동안 로딩화면을 띄웁니다.

<img src="https://user-images.githubusercontent.com/44187194/130928995-4a413162-e624-4f8e-b472-7051fbc50d7e.gif" width="200" height="400"/>

## 2. Using Flow
<p>✅ <b>안전운전 항목</b>은 주행 중 발생하는 급가속, 급감속, 과속, 급회전과 다양한 주행 정보를 기반으로 산정된 일일 안전 점수를 제공합니다.</p>
<p>✅ <b>경제운전 항목</b>은 주행 중 계산한 연비를 점수화하여 산정된 일일 경제 점수를 제공합니다.</p>
<p>✅ <b>운전스타일 경고 횟수 항목</b>은 일일 위험운전행동 발생 횟수를 보여줍니다.</p>
<p>✅ <b>일일 연비 항목</b>은 일일 평균 연비 정보를 보여줍니다.</p>
<p>✅ <b>주행 거리 항목</b>은 일주일 동안 주행한 거리의 합을 나타냅니다.</p>
<p>✅ <b>지출 내역 항목</b>은 차계부에 기록한 내용을 바탕으로한 주간 차트를 제공합니다.</p>
<p>✅ <b>점검 필요 항목</b>은 일주일 내로 모두 사용할 것 같은 소모품들을 나열해줍니다.</p>
<br>

<p>
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130973990-2fd3bf35-12b6-498f-b389-2b893b8f26ef.png">
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130974078-42d9ee46-04fd-4a70-a790-d3a37706a08e.png">
<img width="200" height="400" src="https://user-images.githubusercontent.com/44187194/130974157-9fe27bed-3006-4321-bb4b-a5dd75d99cf9.png">
 </p>
 
 
<p>
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130974167-46f443f0-42f2-4ad1-837b-0babd7b4b707.png">
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130974184-ef471865-13dd-44c0-a93f-4ccae2029ad9.png">
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130974193-0873202d-45b2-4bc4-ae50-414ba12da8b3.png">
<img width="200" height="300" src="https://user-images.githubusercontent.com/44187194/130974201-9512faca-432a-4992-8a1f-1c631dc7090d.png">
</p>

## 3. Editing

