<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>testJQueryView</title>
<script type="text/javascript" src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>
<h1>jQuery 로 ajax 테스트</h1>
<hr>
		<h2>1. 서버로 전송값 없고, 결과로 문자열 받아 출력 : get 방식</h2>
		<p id="p1" style="width: 300px; height: 50px; border: 1px solid red;"></p>
		<button id="test1">테스트</button>
		
		<script type="text/javascript">
				$(function(){
						//jQuery('selector').method([args]);  ==> 이런형태로 작성한다. 
						$('#test1').click(function(){
							// controller 로 서비스 요청하고 , 
							// 결과로 문자열을 받는 경우에는 2까지를 사용할 수 있다.
							// 1. jQuery.get() 사용할 수 있음 
							//		- ("요청url", {전송값}, function(data){요청 성공시 리턴값 받아 처리할 함수})
							
							// get() 요청
							$.get("test1.do", function(data){
								$('#p1').text(data);
							});
							
							// ajax() 요청
							$.ajax({
								url: "test1.do", 
								type: "get", /* get은 생략해도 됨 */
								success: function(data){
									$('#p1').text($('#p1').text() + ", " + data);
								}
							});
						}); // click
				}); /* document ready 축약형  */
		</script>
		<hr>
		
		<h2>2. 서버로 전송값 있고, 결과로 문자열 받아 출력</h2>
		이름 : <input type="text" id="name"><br>
		나이 : <input type="number" id="age"><br>
		
		<p id="p2" style="width: 300px; height: 50px; border: 1px solid red;"></p>
		<button id="test2">테스트</button>
		
		<script type="text/javascript">
				$(function(){
					//  서비스 요청시 post 정송일 때는 
					// jQuery.post() 또는 jQuery.ajax() 사용할 수 있음. 
					// 메소드 안 인자의 사용형식은 같음 
					
					$('#test2').on('click', function(){
						// $.post({settings}); ==> 해도 되고
						$.ajax({
							url: "test2.do",
							data: {name: $('#name').val(), age: $('#age').val()},
							type: "post",
							success: function(result){
								if(result == "ok"){
									$('#p2').html("<h5>" + result + "</h5>");
								}else{
									alert("서버측 실패 답변 : " + result);
								}
							},
							error: function(request, status, errorData){
								console.log("error code : " + request.status + "\nMessage: " + request.responseText + "\nError : " + errorData);
							}
							
						});
						
					}); // id가 test2를 찾아서 클릭 되었을 때 처리되는 함수를 실행 시킴 (on click)
				
				}); // document.ready
		
		</script>
		<hr>
		
		<h2>3. 서버로 전송값 없고, 결과로 json 객체 하나 받아 출력: post 방식</h2>
		<p id="p3" style="width: 300px; height: 130px; border: 1px solid red;"></p>
		<button id="test3">테스트</button>
		
		<script type="text/javascript">
				$(function(){
					$('#test3').on('click', function(){
						$.ajax({
							url: "test3.do",
							type: "post", // json을 받을 때는 post 지정해야 함. 
							dataType: "json", // 전송받는 값의 종류 지정 (기본 : "text")
							success: function(jsonData){
								// json 객체 한 개를 받을 때는 바로 출력 처리할 수 있음.
								console.log("jsonData : " + jsonData);
								
								// 응답온 값에 인코딩된 글자가 있으면, 
								// 자바스크립트가 제공하는 decodeURIComponent(응답값)
								// 사용해서 반드시 디코딩 처리 해야 함. 
								// 참고 : 디코딩시 '+'가 공백으로 변환 안 될수도 있음
								// 				=> replace ('원래문자', '바꿀문자')
								
								$('#p3').html("<b>최신 공지글</b><br>" + "번호 : " + jsonData.noticeno
														+ "<br>제목 : " + decodeURIComponent( jsonData.noticetitle).replace(/\+/gi, ' ')
														+ "<br>작성자 : " + jsonData.noticewriter
														+ "<br>날짜 : " + jsonData.noticedate
														+ "<br>내용 : " +decodeURIComponent(jsonData.noticecontent).replace(/\+/gi, ' '));
							},	
							error: function(request, status, errorData){
								console.log("error code : " + request.status + "\nMessage: " + request.responseText + "\nError : " + errorData);
							}
						}); // ajax
					});  // on 이 event 처리에 권장하는 메소드임.
				}); // document.ready
		</script>
		<hr>
		
		<h2>4. 서버로 전송값 있고, 결과로 json 배열 받아 출력 : post 방식</h2>
		<label>검색 제목 키워드 입력 : 
		<input type="search" id="keyword"></label><br>
		<div id="p4" style="width: 500px; height: 500px; border: 1px solid red;">
			<table id="tblist" border="1" cellspacing="0">
				<tr bgcolor="gray">
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>날짜</th>
				</tr>
			</table>
		</div>
		<button id="test4">테스트</button>
		
		<script type="text/javascript">
				$(function(){
					$('#test4').on('click', function(){
						$.ajax({
							url: "test4.do",
							type: "post",
							data: {keyword: $('#keyword').val() },
							dataType: "json",
							success: function(dataObj){
								// json 배열을 담은 객체를 리턴받은 경우
								// object => string => parsing : json
								console.log(dataObj); // [object, Object]
								
								// 받은 객체를 문자열로 바꾸기 
								var objStr= JSON.stringify(dataObj);
								
								// 객체문자열을 다시 json 객체로 parsing 해줘야 한다. 
								var jsonObj =JSON.parse(objStr);
								
								// 출력용 대상 태그 객체를 준비를 할 필요 있다. : table에 행을 추가 하는 방식으로 한다. 
								var output = $('#p4 > #tblist').html();
								
								// 객체별 행을 추가하는 문자열 만들기
								for(var i in jsonObj.list) {
									output += "<tr><td>" + jsonObj.list[i].noticeno
												+ "</td><td>" + decodeURIComponent(jsonObj.list[i].noticetitle).replace(/\+/gi, " ")
												+ "</td><td>" + jsonObj.list[i].noticewriter
												+ "</td><td>" + jsonObj.list[i].noticedate
												+ "</td></tr>";
								}
								
								//테이블에 적용
								$('#p4 > #tblist').html(output);
							},
							error: function(request, status, errorData){
								console.log("error code : " + request.status + "\nMessage: " + request.responseText + "\nError : " + errorData);
							}
						}); // ajax
					}); // on click
				}); // document.ready
		
		</script>
		<hr>
		
		<h2>5. 서버로 json 객체를 보내기</h2>
		<div>
				<fieldset>
					<legend>새 공지글 등록하세요</legend>
					제목 : <input type="text" id="title"><br>
					작성자 : <input type="text" id="writer" value="admin"><br>
					내용 : <textarea rows="5" cols="30" id="content"></textarea>
				</fieldset>
		</div>
		<button id="test5">테스트</button>
		<script type="text/javascript">
				$(function(){
					$('#test5').on('click', function(){
						// 자바스크립트에서 json 객체 만들기
						//var job = {name: '홍길동', age: 30};  이렇게 만들어줄 수도 있지만 ...
						
						var job = new Object();  // 이렇게 해도  json 객체임. 
						job.title = $('#title').val(); //jquery  방식
						job.writer = document.getElementById('writer').value; // 자바스크립트 방식
						job.content = $('#content').val();
						
						$.ajax({
							url: "test5.do",
							type: "post",
							data: JSON.stringify(job), //json 은 String 형이기 때문에 꼭 이렇게 작성해야 함. 
							contentType: "application/json; charset=utf-8",
							success: function(result){
								alert("요청 성공 : " + result);
							},
							error: function(request, status, errorData){
								console.log("error code : " + request.status + "\nMessage: " + request.responseText + "\nError : " + errorData);
							}
						}); // ajax
					});// on click
				}); // document.ready
		</script>
		<hr>
		
		<h2>6. 서버로 json 배열 보내기</h2>
		<div>
				<fieldset>
					<legend>공지글 여러 개 한번에 등록하기</legend>
					제목 : <input type="text" id="ntitle"><br>
					작성자 : <input type="text" id="nwriter" value="admin"><br>
					내용 : <textarea rows="5" cols="30" id="ncontent"></textarea>
				</fieldset>
				<input type="button" id="addBtn" value="추가하기">
		</div>
		<p id="p6" style="width: 400px; height: 150px; border: 1px solid red;"></p>
		<button id="test6">테스트</button>
		
		<script type="text/javascript">
				$(function(){
					// var jarr = new Array(5); // index 이용할 수 있음
					// jarr[0] = {name: '홍길동', age: 25};
					
					// var jarr = new Array(); //Stack 구조가 됨. index가 없다는 뜻
					//저장 : push(), 꺼내기 : pop() 사용함
					// jarr.push({name: '홍길동', age: 25});
					
					// 배열 초기화
					/* var jarr = [{name: '홍길동', age: 25},
											{name: '김춘추', age: 35},
											{name: '이순신', age: 45}]; */
											
					var jarr = new Array();
					var pStr = $('#p6').html();
					
		
					$('#addBtn').on('click', function(){
						var njob = new Object();
						njob.ntitle = $('#ntitle').val();
						njob.nwriter = $('#nwriter').val();
						njob.ncontent = $('#ncontent').val();
						
						jarr.push(njob);
						
						pStr += JSON.stringify(njob);
						$('#p6').html(pStr + "<br>");
						
						$('#ntitle').val("");
						$('#ncontent').val("");
					}); // addBtn click
					
					$('#test6').on('click', function(){
					$.ajax({
						url: "test6.do",
						type: "post",
						data: JSON.stringify(jarr), //json 은 String 형이기 때문에 꼭 이렇게 작성해야 함. 
						contentType: "application/json; charset=utf-8",
						success: function(result){
							alert("전송 성공 : " + result);
						},
						error: function(request, status, errorData){
							console.log("error code : " + request.status + "\nMessage: " + request.responseText + "\nError : " + errorData);
						}
					}); // ajax
				});
			});
		</script>
		<hr>
		
		<h2>7. 서버로 전송값 없고, 결과로 문자열 받아 출력 : get 방식</h2>
		<p id="p7" style="width: 300px; height: 50px; border: 1px solid red;"></p>
		<button id="test7">테스트</button>
		
		<script type="text/javascript"></script>
		<hr>
		
</body>
</html>