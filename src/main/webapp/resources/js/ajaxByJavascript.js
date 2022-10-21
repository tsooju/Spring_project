/**
 * ajaxByJavascript.js
 * 자바스크립트 사용한 ajax 기능 제공용
 */
 
 // 브라우저에서 XMLHttpRequest 란 객체 지원 여부 확인하는 함수
 function checkNativeBrowser(){
	if(window.XMLHttpRequest){
		// firefox, opera, safari, chrome, IE7 이상 등에 제공 된다. \
		alert("XMLHttpRequest 제공함");
	}else{
		//IE 5, 6 은 ActiveX control을 사용하기 때문에 사용이 다르다.
		alert("XMLHttpRequest 제공 안함, ActiveXObject 지원함. ");
	}
}

// 서버로 요청처리 할 객체 생성함
function createXHRequest(){
	var xhRequest;
	if(window.XMLHttpRequest){
		xhRequest = new XMLHttpRequest();
	}else{
		xhRequest = new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	return xhRequest;
}