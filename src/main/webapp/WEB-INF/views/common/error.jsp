<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  isErrorPage="true"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
<!-- error message print page -->
<%-- jsp  내장객체 exception 는 isErrorPage 속성이 true 일때만 사용할 수 있음.  --%>
<%-- 에러 발생은 다른 jsp에서 넘어오는 에러와 서버측 컨트럴러의 메소드에서 
			리턴하는 에러로 구분을 할 수 있음. --%>
<h1>에러 페이지</h1>
<!-- 다른 jsp에서 exception이 넘어온 경우의 처리 -->
<c:set var="e" value="<%= exception %>"/>
<c:if test="${ !empty e }"> <!-- if(e != null) 과 같음 -->
	<h3>jsp 페이지 오류 발생 : ${ message }</h3>
</c:if>
<!-- 서버측에서 서비스 요청에 대한 에러메세지 리턴한 경우의 처리 -->
<c:if test="${ empty e }"> <!-- if(e == null) 과 같음 -->
	<h3>컨트럴러 요청 실패 메세지 : ${ message }</h3>
</c:if>
<hr>
<!-- jspl의 절대경로 표기법 : / == /context root명 
		context : application을 의미함. 
		context root : first/src/main/webapp 을 의미함. 
		root 에서 출발시키는 경로를 웹에서 절대경로라고 한다. 
		-->
<!-- ========================================================== -->		
<!-- jsp 페이지에서 콘트롤러를 요청할 때는 반드시 context root 에서 실행시키도록 해야함.    -->
<!-- ========================================================== -->

<c:url var="movemain"  value="/main.do" />
<a href="${ movemain }">시작페이지로 이동</a>
<!-- 상대경로 : 현재 문서를 기준으로 대상까지의 경로
		같은 폴더에 있으면 : 파일명.확장자, 폴더명/파일명.확장자
		다른 폴더에 있으면 : ./(현재 폴더), ../(한단계 위로)  -->


</body>
</html>














