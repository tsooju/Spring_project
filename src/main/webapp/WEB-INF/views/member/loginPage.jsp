<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<style type="text/css">
h1 {
		font-size: 48pt;
		color: navy;
}
div {
		width: 500px;
		height: 200px;
		border: 2px solid navy;
		position: relative; /* 본래 표시될 위치기준 상대적 위치로 지정  */
		left: 400px;
}
div form {
		font-size: 16px;
		color: navy;
		font-weight: bold;
		margin: 10px;
		padding: 10px;
}

div#loginForm form input.pos {
		position: absolute; /* 절대좌표로 위치 지정  */
		left: 120px;
		width: 300px;
		height: 25px;	
}

div#loginForm form input[type-submit] {	
		margin: 10px;
		width: 250px;
		height: 40px;
		position: absolute;
		left: 120px;
		background: navy;
		color: white;
		font-size: 16px;
		font-weight: bold;
		}

</style>

</head>
<body>

<h1 align="center">first login</h1>
<div id="loginForm"><!--style 주기 위한 id 만듦  -->
<form action="login.do" method="post">
<label>아이디 : <input type="text"  name="userid" class="pos"></label> <br>
<label>암호 : <input type="password"  name="userpwd" class="pos"></label> <br>
<input type="submit"  value="login">
</form>
</div>

</body>
</html>