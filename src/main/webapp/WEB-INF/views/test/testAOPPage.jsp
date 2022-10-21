<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>testAOPPage</title>
<script type="text/javascript"
	src="${ pageContext.servletContext.contextPath }/resources/js/jquery-3.6.1.min.js"></script>
</head>
<body>
	<h1>Spring framework 특징</h1>
	<ul>
		<li>POJO(Plain Object Java Object) 기반으로 구성된다</li>
		<li>DI(Dependency Injection : 의존성 주입)</li>
		<!-- 객체 생성은 자동으로 해준다는 뜻 -->
		<li>트렌잭션 지원 : 필요할 경우 xml 로 설정할 수 있다.</li>
		<li>IOC(Invert Of Controll : 제어권 반전)</li>
		<li>AOP(Aspect Oriented Programming : 관점 지향 프로그램)</li>
	</ul>
	<hr>
	<h2>AOP란?</h2>
	<p>
		<b>Aspect 에 대한 Advice를 Target Object 의 Join point 에 해당하는 pointcut에
			weaving 되게 설정하는 것.</b><br> 주로 비즈니스 로직을 처리하는 클래스(Service, Repository
		: 즉 Dao)에 적용됨. <br>
	</p>
	<h4>OOP 에서는 클래스별로 중복되는 공통 기능을 하나의 클래스로 분리하여 작성하고, 사용이 필요한 클래스는 코드를
		가진 클래스를 상속받거나 또는 의존관계(사용이 필요한 다른 클래스의 메소드를 객체 생성해서 호출하는 방식)를 맺는다.</h4>
	<h4>스프링에서는 AOP로 해결함.</h4>
	<h4>스프링에서의 AOP는 분리한 공통 기능을 직접적으로 호출하지 않는다. 하지 않아도 실행되는 의미. 분리한 공통
		기능의 호출을 관점(Aspect)으로 다룬다. 즉, 각 모듈(클래스)에 호출 코드를 횡단 관점이라고 하고, AOP에서는 횡단
		관점까지 분리하는 것이 목표이다. =>> 즉, 모듈에 분리된 공통 기능에 대한 호출 코드를 완전히 제거하는 것이 스프링
		AOP란 것이다.</h4>
	<ol>
		<li><h5>Join Point</h5>
			<ul>
				<li>메소드가 실행되는 지점을 의미함.</li>
				<li>클래스의 객체(인스턴스) 생성 시점, 메소드 호출 시점, 
						예외발생 시점 등 특정 작업(기능 == 메소드)</li>
				<li>Advice를 적용할 수 있는 시점임. </li>
			</ul></li>

		<li><h5>Advice</h5>
			<ul>
				<li>Join Point 에서 구동될 메소드를 의미함.</li>
				<li>Join Point 에 삽입되어서 동작될 코드(기능/행위)를 말함.</li>
				<li>Before Advice, After returning Advice(리턴될 때), 
						After throwing Advice, After Advice(끝나고 나면),
						Around Advice(전과 후를 한번에 적용) 가 있음</li>
			</ul></li>
		<li><h5>Pointcut</h5>
			<ul>
				<li>Join Point 의 부분집합 : 어드바이스가 조인포인트에 
						위빙(코드가 위치에 들어가도록) 되도록 설정해 놓은 것을 말한다. </li>
				<li>실제 어드바이스(실행될 코드)가 적용되는 조인 포인트를 말함 : 
						클래스 또는 메소드로 작성함</li>
				<li>정규 표현식이나 AspectJ 문법을 이용하여 포인트컷을 정의함. </li>
			</ul></li>

		<li><h5>Weaving</h5>
			<ul>
				<li>어드바이스(실제 구동될 공통 코드)를 핵심 로직코드(타겟 메소드)에
						삽입하는 것 </li>
				<li>어드바이스를 위빙하는 방식 3가지 있다.
					<ol>
							<li>컴파일시 위빙하기 : AOP가 적용된 
									클래스가 파일을 새로 생성함.</li>
							<li>클래스가 메모리에 로딩시에 위빙하기 : 로딩한 
									바이트 코드를 AOP가 변경하여 사용함.</li>
							<li>런타임시에 위빙하기 : 프록시를 이용함.
									(메소드 호출시 조인포인트 지원)</li>
					</ol>
				</li>
			</ul></li>

		<li><h5>Target Object</h5>
			<ul>
				<li>핵심 로직을 가진 클래스를 말함 : Service || Dao 클래스</li>
				<li>어드바이스 위빙 대상 객체</li>
				<li>스프링에서는 런타임 프록시를 사용해서 위빙 처리함.</li>
			</ul></li>

		<li><h5>Aspect</h5>
			<ul>
				<li>공통 기능을 분리 작성해 놓은 클래스</li>
				<li>분리 작성된 공통 기능(메소드)</li>
				<li>여러 객체에 공통으로 사용되는 공통 관점 지향</li>
				<li>로깅, 트렌잭션, 보안코드 등이 Aspect 의 좋은 사용 예임</li>
			</ul></li>
	</ol>
</body>
</html>