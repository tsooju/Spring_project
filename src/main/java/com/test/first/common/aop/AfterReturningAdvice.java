package com.test.first.common.aop;



import java.text.SimpleDateFormat;
import java.util.Date;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.test.first.member.model.vo.Member;

@Repository // Dao 적용하는 annotation
@Aspect // aop 등록
public class AfterReturningAdvice {
	// 로그인 메소드에 대한 로그 처리를 목적으로 하는 어드바이스
	// private Logger logger = LoggerFactory.getLogger(AfterReturningAdvice.class());   ==> 아래코드랑 같은 의미
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	// Pointcut 지정 위한 
	@Pointcut("execution(* com.test.first.member.model.dao.MemberDao.selectMember(..))")
	public void loginPointcut() {}
	
	// 타겟오브젝트의 메소드가 실행 후 리턴될 때 작동되는 어드바이스
	@AfterReturning(pointcut="loginPointcut()", returning="returnObj")
	public void loginLog(JoinPoint jp, Object returnObj) { // 2개의 매개변수가 지정되어 있다. 
		// 비즈니스 로직용 메소드가 리턴한 결과데이터를
		// 다른 용도로 처리할 때 사용할 수 있음
		if(returnObj instanceof Member) {
			Member member = (Member) returnObj;
			String dateFormat = new SimpleDateFormat("yyyy-MM-dd (E) hh:mm:ss").format(new Date());
			logger.info(dateFormat + "$" + member.getUserid() + "$ 님이 접속하였습니다.");
			// INFO : com.test.first.common.aop.AfterReturningAdvice - 2022-10-19 (수) 02:59:15$admin$ 님이 접속하였습니다.
			}
		
	}
		
} // class end
