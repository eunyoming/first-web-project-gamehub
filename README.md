# 게임허브 프로젝트
팀 - 우리 잘했조

### [ 일정 ]  
★ 8/26 화요일 ~ 최대 9/8 월요일 ★ : 1차 프로젝트 시작  
8/27 수요일 : 필수서류 완성해서 제출  
9/8 월요일 : 1차 프로젝트 발표  

### [사이트 이름]  


### [게임 이름]

강성연 :   
이은경 :  
조유정 :  
임종민 :  
임휘경 :  

- [요구사항 정의서](https://docs.google.com/spreadsheets/d/1Vb5QTPDVeB6gVxtp12Mot73xRhw6XxGCnSMxz1Y8jA8/edit?gid=620976748#gid=620976748)
- [요구사항 명세서](https://docs.google.com/spreadsheets/d/1ouiq9RLToUAMYnVeUvoi-Z9-SQLlKIalfHuCM9MwqF4/edit?gid=279214655#gid=279214655)
- [ERD](https://dbdiagram.io/d/1%EC%B0%A8%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-68a6b41e1e7a611967e7a338)
- [우리팀 구글 드라이브](https://drive.google.com/drive/folders/1vKBWSqz7WYWOdMOg63dX4zhddbEIJ3yi)
- [와이어프레임](https://www.figma.com/design/UQp6LpHVfvkXGwVVh3MMaF/1%EC%B0%A8-%EC%9B%B9%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8-%EC%8B%9C%EC%95%881?node-id=97-565&t=UOYQSvFzzP2ns8Ee-1)

- [프로젝트 때 작성해야하는 문서 예시 링크](https://drive.google.com/drive/folders/1DNjnLAuGBFkFEqewBaIvyhbofPCxrl1P?usp=drive_link)

### [ 우리끼리의 DAO 메서드명 컨벤션 ]
( select )  
- select * from 테이블명  
selectAll테이블명  

- select * from 테이블명 where id = ?  
select테이블명By조건필드명  

( insert )  
insert테이블명  

( delete )  
delete테이블명By조건필드명  

( update )  
update테이블명By조건필드명  

( Connection )  
getConnection();  

( DAO instance )  
// 멤버필드  
private static DAO명 instance;  
// 기본 생성자 막기  
private DAO클래스명(){};  
// DAO getter  
public synchronized static DAO명 getInstance(){};  

[ 주의 ]  
ex) DTO Timestamp createAt → create_at 으로 변경할 것  
* 공통으로 '_(언더바)' 들어가는 경우 : 시간 _at, 시퀀스 _seq, URL _url  
