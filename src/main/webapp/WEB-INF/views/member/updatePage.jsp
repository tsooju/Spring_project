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
<script type="text/javascript">
	function validate() {
		// 암호 확인의 포커스가 사라질 때 암호와 암호확인 일치하는지 검사

		// 암호와 암호확인이 일치하는지 확인하는 작업
		var pwd1 = document.getElementById("upwd1").value;
		var pwd2 = document.getElementById("upwd2").value;

		if (pwd1 !== pwd2) {
			alert("암호와 암호 확인의 값이 일치하지 않습니다.\n" + "다시 입력하세요")
			document.getElementById("upwd1").select();
		}
	}
</script>
</head>
<body>
	<h1 align="center">회원 정보 수정</h1>
	<br>
	<form action="mupdate.do" method="post">
		<input type="hidden" name="origin_userpwd" value="${ member.userpwd }">

		<table id="outer" align="center" width="500" cellspacing="5"
			cellpadding="0">
			<tr>
				<th width="120">이 름</th>
				<td><input type="text" name="username"
					value="${ member.username }" readonly></td>
				<!-- EL 에서 사용하는 member는 membercontroller에 있는 model의 member다. -->
			</tr>
			<tr>
				<th width="120">아이디</th>
				<td><input type="text" name="userid" id="userid"
					value="${ member.userid }" readonly>
			</tr>
			<tr>
				<th width="120">암 호</th>
				<td><input type="password" name="userpwd" id="upwd1" value=""></td>
			</tr>
			<tr>
				<th width="120">암호확인</th>
				<td><input type="password" id="upwd2" onblur="validate();"></td>
				<!-- 확인하는 부분은 이름 사용안함 -->
			</tr>
			<tr>
				<th width="120">성 별</th>
				<td><c:if test="${ member.gender eq 'M' }">
						<input type="radio" name="gender" value="M" checked> 남자 
						<input type="radio" name="gender" value="F"> 여자
					</c:if> <c:if test="${ member.gender eq 'F' }">
						<input type="radio" name="gender" value="M" checked> 남자 
						<input type="radio" name="gender" value="F"> 여자
					</c:if></td>
			</tr>
			<tr>
				<th width="120">나 이</th>
				<td><input type="number" name="age" value="${ member.age }"
					min="19" max="100"> <!--19세 이상만 가입가능 설정  --></td>
			</tr>
			<tr>
				<th width="120">전화번호</th>
				<td><input type="tel" name="phone" placeholder="-빼고 입력"
					value="${ member.phone }"></td>
			</tr>
			<tr>
				<th width="120">이메일</th>
				<td><input type="email" name="email" value="${ member.email }"></td>
			</tr>
			<tr>
				<th width="120">취 미</th>
				<td>
					<!-- 취미 문자열을 각각의 문자열로 분리하면서, 취미 checkbox에 적용할 변수 9개를 만듦
					hobby : "game,sport,movie" => ["game", "sport", "movie"] --> <c:forTokens
						items="${ member.hobby }" delims="," var="hb">
						<c:if test="${ hb eq  'game' }">
							<c:set var="chk1" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'reading' }">
							<c:set var="chk2" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'climb' }">
							<c:set var="chk3" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'sports' }">
							<c:set var="chk4" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'music' }">
							<c:set var="chk5" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'movie' }">
							<c:set var="chk6" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'travel' }">
							<c:set var="chk7" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'cook' }">
							<c:set var="chk8" value="checked" />
						</c:if>
						<c:if test="${ hb eq  'other' }">
							<c:set var="chk9" value="checked" />
						</c:if>
					</c:forTokens> <!-- 만든 9개의 변수값을 체크 박스에 적용함 -->
					<table width="350">
						<tr>
							<td><input type="checkbox" name="hobby" value="game"
								${ chk1 }>게임</td>
							<td><input type="checkbox" name="hobby" value="reading"
								${ chk2 }>독서</td>
							<td><input type="checkbox" name="hobby" value="climb"
								${ chk3 }>등산</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="hobby" value="sports"
								${ chk4 }>운동</td>
							<td><input type="checkbox" name="hobby" value="music"
								${ chk5 }>음악듣기</td>
							<td><input type="checkbox" name="hobby" value="movie"
								${ chk6 }>영화보기</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="hobby" value="travel"
								${ chk7 }>여행</td>
							<td><input type="checkbox" name="hobby" value="cook"
								${ chk8 }>요리</td>
							<td><input type="checkbox" name="hobby" value="other"
								${ chk9 }>기타</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<th width="120">추가사항</th>
				<td><textarea rows="5" cols="50" name="etc">${ member.etc }</textarea></td>
			</tr>
			<tr>
				<th colspan="2"><input type="submit" value="수정하기">&nbsp;
					<input type="reset" value="수정취소">&nbsp; <!-- (-1)하면 바로 전페이지로 간다. (-2)하면 전전페이지로 이동한다. -->
					<a href="javascript:history.go(-1);">이전페이지로 이동</a>&nbsp; <a
					href="main.do">시작페이지로 이동</a></th>
			</tr>
		</table>
	</form>

	<hr style="clear: both;">
	<!--  <<==혹시해서 위에서 적용되 있을 수 있는 스타일 지우기 -->
	<c:import url="/WEB-INF/views/common/footer.jsp" />
	<!-- <<==다른 위치의 파일을 불러와서 포함시키는 기능이다. -->


</body>
</html>