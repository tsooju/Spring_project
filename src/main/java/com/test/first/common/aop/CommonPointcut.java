package com.test.first.common.aop;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

@Aspect // aop 를 의미함
public class CommonPointcut {
	// 포인트컷 설정 메소드들만 따로 모
	
	@Pointcut("execution(* com.test.first..*Impl.*(..))")
	public void serviceAllPointcut() {}
	
	@Pointcut("execution(* com.test.first..*Impl.select*(..))")
	public void getPointcut() {}
	
	@Pointcut("execution(* com.test.first..*Impl.insert*(..))")
	public void setPointcut() {}
	
	
} // class end
