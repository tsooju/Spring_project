<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- a 태그(get 전송임)로 서버측에 request 요청을 하는 방법은 기분적으로 2까지 있다. 
	1. :  href="${ pageContext.servletContext.contextPath }/test.do"를 직접 작성할  수 있음. 
	2. : href="javascript:location.href="요청url;"
	web.xml 에서 ((( *.do )))라고 지정 되어 있기때문에 항상 .do로 작성 해야 한다. 
	
	추가적으로 요청 url가 함께 서버측으로 전송할 값(parameter)이 있다면 
	쿼리스트링을 추가하면 됨. :  "요청url?전송이름=전송할값&전송이름=전송할값"
  -->
  
<h2><a href="${ pageContext.servletContext.contextPath }/testJSON.do">테스트 JSON</a></h2>
<h2><a href="${ pageContext.servletContext.contextPath }/testJS.do">javaScript ajax</a></h2>
<h2><a href="${ pageContext.servletContext.contextPath }/testJQuery.do">jquery ajax</a></h2>
<h2><a href="${ pageContext.servletContext.contextPath }/testAjaxFile.do">ajax fileup/download</a></h2>

<hr>
<h1>open API 사용 테스트</h1>
<h2><a href="${ pageContext.servletContext.contextPath }/movePOST.do">주소, 우편번호 검색 api</a></h2>
<h2><a href="${ pageContext.servletContext.contextPath }/moveKakao.do">카카오 로그인 api</a></h2>
<h2><a href="${ pageContext.servletContext.contextPath }/moveMap.do">카카오 Map api</a></h2>

</body>
</html>