<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>testAjaxFileView</title>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.6.1.min.js"></script>
<script type="text/javascript">
function uploadFile(){
	var form = $('#fileForm')[0];  // form tag 의 id 를 찾으면 뒤에 index [안에서] 순번을 작성해 줘야 한다. 
	// form tag  안에 모든 입력 정보를 담을 FormData  객체 생성해야 함. 
	var formData = new FormData(form); // 일반 태그와 다른점이다. 
	
	$.ajax({
		url: 'testFileUp.do',
		processData: false, // multipart 방식으로 전송하려면 processData를 false로 해야 한다.
		contentType: false, // false 지정하면 multipart 전송가능한다,
		data: formData,
		type: "post",
		success: function(data, jqXHR, textStatus){
			alert('파일업로드 성공 : ' + data);
		},
		error: function(jqXHR, testStatus, errorTrown){
			console.log(jqXHR + ", " + testStatus + ", " + errorTrown);
		}
	});
}
/* ***************************************************************************************  */
function uploadFile2(){
	// 자바스크립트 ajax 로 파일업로드 처리
	var form = document.getElementById('fileForm2');
	var formData = new FormData(form);
	
	var xhrequest; // 브라우저별로 ajax를 위한 객체 생성
	if(window.XMLHttpRequest){
		xhrequest = new XMLHttpRequest();
	}else{ //IE5, IE6
		xhrequest = new ActiveXObject("Microsoft.XMLHTTP");
	}
	
	// ajax  요청
	// 1. 요청 처리에 대한 상태코드가 변경되면, 작동할 내용을 미리 지정함.
	xhrequest.onreadystatechange = function(){
		if(xhrequest.readyState == 4 && xhrequest.status == 200) {// 오류없이 작동 된다는 의미로 4번이다.  success은 200
			alert(xhrequest.responseText);
		} // 요청이 성공하면 alert 창에 응답온 문자를 출력해라로 지정하는 것이다. 
	};  // 자바스크립트에서 ajax를 요청 코드
	
	//2. url 요청하고, 전송값 보내기
	xhrequest.open("POST", "testFileUp.do", true); //비동기 여부는 true 한다. 
	xhrequest.send(formData);
}
/* ***************************************************************************************  */
function fileDown(){
	//a tag(파일명) 클릭하면 다운받을 파일명을 서버로 전송함. 
	var downFile = $('#fdown').text();
	
	$.ajax({
		url: "filedown.do",
		type: "get",
		data: { "fname": downFile },
		xhrFields: {
			responseType: 'blob'
		}, // response 데이터를 바이너리로 처리하는 작업을 해야 함. 
		success: function(data){
			console.log("완료!");
			// 전송온 데이터를 Blob 객체로 만들기
			var blob = new Blob([data]);
			//클라이언트쪽에 파일 저장 : 다운로드 
			if(navigator.msSaveBlob){
				return navigator.msSaveBlob(blob, downFile);
			}else{
				var link = document.createElement('a');
				link.href = window.URL.createObjectURL(blob);
				link.download = downFile;
				link.click();
			}
		},
		error: function(jqXHR, testStatus, errorTrown){
			console.log(jqXHR + ", " + testStatus + ", " + errorTrown);
		}
	}); // ajax
}
/* ***************************************************************************************  */
function fileDown2(){
	// javascript ajax 로 파일다운로드 처리
	var filedownURL = "filedown.do";
	var downfile = document.getElementById('fdown2').innerHTML;
	// if(window.XMLHttpRequest || "XMLHttpRequest" in window){ 해당 객체가 있다면 }
	// 해당 객체가 없다면으로 조건 처리할 수도 있을 것.
	if(!(window.ActiveXObject || "ActiveXObject" in window)){
		// chrome, firefox, opera, safari, IE7 이상
		var link = document.createElement('a');
		link.href = filedownURL + "?fname=" + downfile;
		link.target = '_blank'; // 생략해도 됨.
		link.download = downfile || filedownURL;
		
		// link.click(); 과 같은 동작 처리 코드임
		var event = document.createEvent("MouseEvents");
	    event.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
	    link.dispatchEvent(event);
	    (window.URL || window.webkitURL).revokeObjectURL(link.href);
	}else{ //IE5, IE6
		var _window = window.open(fileURL, downfile);
        _window.document.close();
        _window.document.execCommand('SaveAs', true, fileName || fileURL)
        _window.close();
        removeiframe();
	}
}


</script>

</head>
<body>
<h1>Ajax 로 파일 업로드 / 다운로드 처리(form 전송)</h1>
<hr>
<h2>jQuery 기반 Ajax 파일업로드</h2>
<form id="fileForm">
		메세지 : <input type="text" name="message"> <br>
		첨부파일 : <input type="file" name="upfile"> <br>
		<input type="button" value="업로드" onclick="uploadFile();">
</form>
<!-- ================================================================= -->

<hr>
<h2>javascript 기반 Ajax 파일업로드</h2>
<form id="fileForm2">
		메세지 : <input type="text" name="message"> <br>
		첨부파일 : <input type="file" name="upfile"> <br>
		<input type="button" value="업로드" onclick="uploadFile2();">
</form>
<!-- ================================================================= -->

<hr style="">
<h2>jQuery 기반 Ajax 파일다운로드</h2>
<a id="fdown" onclick="fileDown();">sample.txt</a><br>


 <hr>
<h2>javascript 기반 Ajax 파일다운로드</h2>
<a id="fdown2" onclick="fileDown2();">sample.txt</a> <br>

</body>
</html>