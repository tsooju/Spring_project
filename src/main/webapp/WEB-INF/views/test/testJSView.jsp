<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>testJSView</title>

<!-- servlet-context.xml 파일에 webapp/resources 가 위치 설정되어 있는 
		리소스(images, css, js, python, multi 등) 사용시
		하위폴더명/파일명.확장자 - 로 표시하고 사용해도 된다. 
		 -->
<script type="text/javascript" src="${ pageContext.servletContext.contextPath  }/resources/js/ajaxByJavascript.js"></script>
<!-- 또는 절대경로로 표기해서 사용해도 된다.  -->
<script type="text/javascript" src="${ pageContext.servletContext.contextPath  }/resources/js/jquery-3.6.1.min.js"></script>


<script type="text/javascript">
	// html tag에 on이벤트 속성으로 동작 실행함수를 연결할 수도 있지만, 
	// on이벤트명="실행할 함수명();"
	// 이벤트 설정을 태그에 직접 작성하지 않고, 자바스크립드  쪽에서 연결할 수도 있음. 
			//  => 페이지가 로딩이 완료되면 작동되게 하는 방식을 사용한다. (window.onload)

function test(){
				alert("페이지 로딩 완료");
			}
			
			
// 문서 읽어들이기가 완료 되면 : 
window.onload = function(){
	/* alert("페이지 준비 완료됨."); */
	
	// 주로 html 태그에 이벤트 연동 설정을 함
	document.getElementById("test1").onclick = function(){
		checkNativeBrowser();
	}; // test1 onclick event
	
	document.getElementById("test2").onclick = function(){
		console.log("리턴 정보 : " + typeof(createXHRequest())); // typeof은 자료형을 확인하는 함수
	}; // test2 onclick event
	

}; // window.onload
			
			
</script>
</head>

<!-- <body onload="test();"> -->
<body>
<h1>javascript  로 ajax 다루기</h1>
<hr>
<h2>1. 브라우저의 XMLHttpRequest 지원 여부 확인</h2>
<button id="test1">Using Test</button>


<h2>2. XMLHttpRequest 객체 생성 확인</h2>
<button id="test2">확인</button>



















</body>
</html>