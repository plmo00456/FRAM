# 내주변 맛집 찾기 (스프링 부트 프로젝트)

이 프로젝트는 스프링 부트 기반의 웹 어플리케이션입니다. Geolocation API와 카카오맵 API를 이용해 사용자의 현재 위치를 파악하고 주변의 맛집을 추천하는 사이트를 구현하였습니다. 사용자는 회원가입, 로그인 및 SNS 계정 연동을 통해 사이트에 가입하여, 식당 정보 확인 및 식당 후기 작성이 가능합니다.

## 시작하기

이 섹션에서는 프로젝트를 시작하는 방법에 대해 설명합니다.

### 사전 요구 사항

아래의 소프트웨어와 라이브러리가 설치되어 있어야 합니다.

* Java 11 이상
* MySQL or MariaDB

### 설치 및 실행

1. 깃헙에서 프로젝트를 클론 및 프로젝트로 이동

- git clone https://github.com/예시/내주변-맛집-찾기.git
- cd 내주변-맛집-찾기

2. 서버 설정

- `/src/main/resources/` 폴더에 `application-secure.properties` 파일을 생성하고 아래 내용을 입력 및 수정하세요.

  - 데이터 베이스 설정
    ```
    spring.datasource.username=사용자
    spring.datasource.password=비밀번호
    ```

  - SNS API KEY 설정
    ```
    kakao.api.appkey=카카오 API KEY
    naver.api.clientid=네이버 Client KEY
    google.api.clientid=구글 Client KEY
    ```

  - 파일 업로드 경로 및 매핑 설정
    ```
    file.upload.dir=파일 업로드 경로
    file.mapping.dir=/file/
    ```

  - 파일 업로드 경로 및 매핑 설정
    ```
    server.ssl.key-store-password=SSL 패스워드
    ```

- `application.properties` 파일에서 서버 기본 설정을 변경하세요.

3. 프로젝트 빌드 및 실행
    ```sh
    $ git clone https://github.com/plmo00456/FRAM.git
    $ cd FRAM
    $ mvn spring-boot:run
    ```

    빌드 및 실행 후, 브라우저에서 `https://localhost:443`로 접속하여 웹 페이지를 확인할 수 있습니다.

## 기능 소개

* Geolocation API를 이용한 현재 위치 파악: 사용자의 현재 위치를 실시간으로 불러오며, 이를 카카오맵 API와 함께 사용합니다.
* 카카오맵 API를 이용한 맛집 추천: 사용자의 현재 위치를 바탕으로 주변 맛집 정보를 불러와 지도상의 마커와 함께 시각화하여 보여줍니다.
* 회원가입 및 로그인 기능: 사용자는 이메일 등의 계정 정보를 이용하여 회원가입을 하고 로그인할 수 있습니다. 또한 SNS 계정 연동을 통해서도 가입 및 로그인이 가능합니다.
* 식당 정보 확인 및 후기 작성: 로그인한 사용자는 각 식당의 정보를 확인하고, 자신이 방문한 경험에 대한 후기를 작성할 수 있습니다.

## 사용된 기술 및 도구

* 개발언어: Java
* 프레임워크: Spring Boot
* 기타 도구 및 라이브러리: Spring Security, Lucy xss servlet filter, Thymeleaf, JWT, Lombok, Gson, jQuery, Geolocation API, Kakao Map API, Rate Yo, Sweet Alert 등

## 기여

프로젝트에 기여하고 싶으시면 Pull Request를 생성하거나 이슈를 제출하여 프로젝트에 기여해 주세요!

## 라이센스

이 프로젝트는 MIT 라이센스를 따릅니다 - [LICENSE.md](LICENSE.md) 파일에서 상세 사항을 확인하세요.

## 문의

문의사항이 있으시면 아래 연락처로 연락주세요.

* 이메일: park_wj7269@naver.com

