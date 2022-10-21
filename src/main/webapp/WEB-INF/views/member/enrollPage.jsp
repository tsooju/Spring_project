<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style type="text/css">
table th {
	background-color: #99ffff; 
	
}

table#outer {
	border: 2px solid navy;
}
</style>

<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.6.1.min.js"></script>
<script type="text/javascript">

//아이디 중복체크 확인을 위한 Ajax 실행 처리용 함수
//Ajax(Asynchronous Javascript And Xml)
//Ajax 는 페이지를 바꾸지 않고, 서버와 통신하는 기술이다. 
//(서버측에 서비스 요청하고 결과받음)

function dupCheck() {
	// 입력된 아이디가 중복되지 않았는지 확인 : jQuery.ajax() 사용
	// jQuery는 $ 모양으로 줄일 수 있음. 
	// jQuery.ajax(); ==>> $.ajax(); 라고 사용할 수 있음.
	$.ajax({
		url: "idchk.do", 
		type: "post", //전송방식
		data: { userid: $("#userid").val() }, // id가 user란 태그를 찾아라란 뜻
		success: function(data){  // 서버로 전송이 성공했을 때 작동될 작업을 적는다.
			console.log("success : " + data);
			if(data == "ok") {
				alert("사용가능한 아이디입니다.");
				$("#upwd1").focus();
			}else {
				alert("이미 사용중인 아이디입니다.\n다시 입력하세요.");
				$("#userid").select();
			}
		}, 
		error: function( jqXHR, textStatus, errorThrown ) {
			console.log("error : " + jqXHR + ", " + textStatus + ", " + errorThrown);
		}
	});
	
	return false; // 클릭 이벤트 전달을 막음 
}

function validate() {
	// 전송보내기 전(submit 버튼 클릭시) 입력값 유요한 값인지 검사
	
	// 암호와 암호확인이 일치하는지 확인하는 작업
	var pwd1 = document.getElementById("upwd1").value;
	var pwd2 = document.getElementById("upwd2").value;
	
	if(pwd1 !== pwd2){
		alert("암호와 암호 확인의 값이 일치하지 않습니다.\n" + "다시 입력하세요")
		document.getElementById("upwd1").select();
		return false; // 전송 안함.
	}
	
	return true; // 전송함
}
</script>
</head>
<body>
	<h1 align="center">회원가입</h1>
	<br>
	<form action="enroll.do" method="post" onsubmit="return validate();"><!-- return true면 전송하고 아니면 반대 -->
		<!-- post : 회원정보가 안보이게 하기 -->
		<table id="outer" align="center" width="500" cellspacing="5"
			cellpadding="0">
			<tr>
				<th colspan="2">회원 정보를 입력해주세요(* 표시는 필수입력 항목입니다.)</th>
			</tr>
			<tr>
				<th width="120">* 이 름</th>
				<td><input type="text" name="username" required></td>
			</tr>
			<tr>
				<th width="120">* 아이디</th>
				<td><input type="text" name="userid"  id="userid" required>
				<!--required : 필수 입력항목  --> &nbsp; &nbsp; <input type="button"
					value="중복체크" onclick="return dupCheck();">
				<!-- "return dupCheck();" 중복체크 --></td>
			</tr>
			<tr>
				<th width="120">* 암 호</th>
				<td><input type="password" name="userpwd" id="upwd1" required></td>
			</tr>
			<tr>
				<th width="120">* 암호확인</th>
				<td><input type="password" id="upwd2"></td>
				<!-- 확인하는 부분은 이름 사용안함 -->
			</tr>
			<tr>
				<th width="120">* 성 별</th>
				<td><input type="radio" name="gender" value="M"> 남자 <input
					type="radio" name="gender" value="F"> 여자</td>
			</tr>
			<tr>
				<th width="120">* 나 이</th>
				<td><input type="number" name="age" value="19" min="19"
					max="100" required>
				<!--19세 이상만 가입가능 설정  --></td>
			</tr>
			<tr>
				<th width="120">* 전화번호</th>
				<td><input type="tel" name="phone" required
					placeholder="-빼고 입력"></td>
			</tr>
			<tr>
				<th width="120">* 이메일</th>
				<td><input type="email" name="email"  required></td>
			</tr>
			<tr>
				<th width="120">취 미</th>
				<td>
					<table width="350">
						<tr>
							<td><input type="checkbox" name="hobby" value="game">게임</td>
							<td><input type="checkbox" name="hobby" value="reading">독서</td>
							<td><input type="checkbox" name="hobby" value="climb">등산</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="hobby" value="sports">운동</td>
							<td><input type="checkbox" name="hobby" value="music">음악듣기</td>
							<td><input type="checkbox" name="hobby" value="movie">영화보기</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="hobby" value="travel">여행</td>
							<td><input type="checkbox" name="hobby" value="cook">요리</td>
							<td><input type="checkbox" name="hobby" value="other"
								checked>기타</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<th width="120">추가사항</th>
				<td><textarea rows="5" cols="50" name="etc"></textarea></td>
			</tr>
			<tr>
				<th colspan="2">
					<input type="submit" value="가입하기">&nbsp;
					<input type="reset" value="작성취소">&nbsp;
					<a href="main.do">시작페이지로 이동</a>
				</th>
			</tr>
		</table>
	</form>




	<hr style="clear: both;">
	<!--  <<==혹시해서 위에서 적용되 있을 수 있는 스타일 지우기 -->
	<c:import url="/WEB-INF/views/common/footer.jsp" />
	<!-- <<==다른 위치의 파일을 불러와서 포함시키는 기능이다. -->
</body>
</html>