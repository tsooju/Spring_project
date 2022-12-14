<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!--상대경로로 대상 파일의 위치를 지정한 경우  -->
<c:import url="/WEB-INF/views/common/menubar.jsp" />
<hr>
<h2 align="center">${ notice.noticeno } 번 공지글 상세보기 (관리자용)</h2>
<br>
<table align="center" width="500" border="1" cellspacing="0" cellpadding="5">
	<tr><th>제 목</th><td>${ notice.noticetitle }</td></tr>
	<tr><th>작성자</th><td>${ notice.noticewriter }</td></tr>
	<tr><th>날짜</th><td>${ notice.noticedate }</td></tr>
	<tr><th>첨부파일</th>
			<td>
					<!-- 첨부파일이 있다면, 파일명 클릭시 다운로드 실행되게 하고 -->
					<c:if test="${ !empty notice.original_filepath }">
							<c:url var="nfd" value="/nfdown.do">
									<c:param name="ofile" value="${ notice.original_filepath }"/>
									<c:param name="rfile" value="${ notice.rename_filepath }"/>
							</c:url>
							<a href="${ nfd }">${ notice.original_filepath }</a>
					</c:if>
					<c:if test="${ empty notice.original_filepath }">
							&nbsp;
					</c:if>
			</td>
	</tr>
	<tr><th>내 용</th><td>${ notice.noticecontent }</td></tr>
	<tr><th colspan="2">
	
		<button onclick="javasctript:history.go(-1);">목록</button>
		<!-- 수정페이지로 이동 버튼 -->
		<c:url var="movenup" value="/nmoveup.do">
				<c:param name="noticeno" value="${ notice.noticeno }"/>
		</c:url>
		<button onclick="javasctript:location.href='${ movenup }';">수정페이지로 이동</button>
		
		<c:url var="ndel" value="/ndel.do">
					<c:param name="noticeno" value="${ notice.noticeno }"/>
					<c:param name="rfile" value="${ notice.rename_filepath }"/>
			</c:url>
		<button onclick="javasctript:location.href='${ ndel }';">글삭제</button>
	</th></tr>
</table>
<hr>
<c:import url="/WEB-INF/views/common/footer.jsp" />
</body>
</html>