package com.test.first.member.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;

import com.test.first.common.SearchDate;
import com.test.first.member.model.service.MemberService;
import com.test.first.member.model.vo.Member;

@Controller // 설정하면 xml 에 자동 등록 된다.
public class MemberController {
	// 이 controller 안의 메소드들에 구동 상태에 대한 로그 출력용 객체 생성
	// classpath에 log4j.xml file 있다. 여기에 설정된 내용으로 출력 적용됨.
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@Autowired // 자동 의존성 주입 처리됨(자동 객체 생성됨)
	private MemberService memberService;

	@Autowired
	private BCryptPasswordEncoder bcryptPasswordEncoder;

	// ==================================================================
	// 뷰 페이지 이동 처리 메소드
	@RequestMapping("loginPage.do")
	public String moveLoginPage() {
		return "member/loginPage";
	}

	@RequestMapping("enrollPage.do")
	public String moveEnrollPage() {
		return "member/enrollPage";
	}

	@RequestMapping("moveup.do")
	public String moveUpdatePage(@RequestParam("userid") String userid, Model model) {
		Member member = memberService.selectMember(userid);
		if (member != null) {
			model.addAttribute("member", member);
			return "member/updatePage";
		} else {
			model.addAttribute("message", userid + ": 회원 조회 실패!");
			return "common/error";
		}
	}

	// ==================================================================

	// login 처리하려면 login method 만들어줘야 한다.
	// 웹 서비스 요청 하나당 메소드당 하나씩 작성하는 방식임
//	@RequestMapping(value="login.do", method=RequestMethod.POST) // 뒤에 .do 꼭 작성한다. 
//	public String loginMethod(Member member) {
//		logger.info("전달받은 값 확인 : " + member.toString());
//		
//		Member loginMember = memberService.selectLogin(member);
//		
//		logger.info("로그인 결과 확인 : " + loginMember.toString());
//		
//		return "common/main";
//	}

	// 로그인 처리용 메소드
	// value : 본 메소드이 가짜 이름이다.
	// method : 전송반식
//	@RequestMapping(value="login.do", method=RequestMethod.POST)
//	public String loginMethod(HttpServletRequest request, HttpServletResponse response, Model model) {
//		// 1. 서버측으로 전송온 값 꺼내기
//		String userid = request.getParameter("userid");	// main.jsp의  input의 name 작성한다. 다르면 에러 나옴. 
//		String userpwd = request.getParameter("userpwd"); // main.jsp의  input의 name 작성한다. 다르면 에러 나옴. 
//		logger.info("login.do : " + userid + ", " + userpwd);
//		Member member = new Member();		// MyBatis가 제공하는 메소드에 맞취기 위한 작업
//		member.setUserid(userid);
//		member.setUserpwd(userpwd);
//		
//		//2. 서비스 model로 전달하고 결과 받기 (MemberService)
//		Member loginMember = memberService.selectLogin(member); // dao로 전달된다. 그래서 로그인회원의 전체 정보가 닮겨있을것
//		
//		//3. 로그인 성공 여부에 따라서 결과를 처리하는 작업
//		// 내보낼 뷰 변수 따로 다루기
//		String viewName = null;
//		if(loginMember != null) { // 로그인 성공
//			// 로그인 상태 관리 방법 (상태 관리 메카니즘라 한다. : 세션 사용하기)
//			// 로그인 상태관리는 기본 세션을 사용한다.  세션은 세션객체 새로 만들기 해야 한다. 
//			HttpSession loginSession = request.getSession();
//			logger.info("sessionID : " + loginSession.getId()); 	// 로그인 아이디마다 세션 발급 아이디가 다르다. 
//			
//			// 로그인한 회원정보가 view에 보여야 한다. jsp도 서버측에서 실행 된다. 
//			//필요할 경우 생성된 세션 객체 안에 정보를 저장할 수 있음.
//			// 저장방식은 map구조로 저장함 : 키(String), 값(Object)
//			loginSession.setAttribute("loginMember", loginMember); // login한 회원정보를 세션에 저장하기
//			
//			
//			// 로그인 성공시 내보낼 뷰파일명 지정
//			viewName = "common/main";
//		}else { // 로그인 실패
//			model.addAttribute("message", "로그인 실패 : 아이디나 암호 확인하세요! "); // 에러메세지를 모델에 저장
//			viewName = "common/error";
//		}
//		
//		return viewName;
//	}

	// 로그인 처리용 메소드 : 커멘드 객체(command object) 사용
	// 서버로 전송온 parameter 값을 저장한 객체(vo)를 command object 라 한다.
	// 작성 요령 : input name 과 command object의 필드명이 같아야 함. 그래야 작성할 수 있음.
	@RequestMapping(value = "login.do", method = RequestMethod.POST)
	public String loginMethod(Member member, HttpSession loginSession, SessionStatus status, Model model) {
		logger.info("login.do  : " + member);

		// 암호롸 처리된 패스워드 일치 조회는 select 해 온 값으로 비교함.
		// 전달온 회원 아이디로 먼저 회원정보 조회해 옴
		Member loginMember = memberService.selectMember(member.getUserid());

		// 2. 서비스 model로 전달하고 결과 받기 (MemberService)
		// Member loginMember = memberService.selectLogin(member); // dao로 전달된다. 그래서
		// 로그인회원의 전체 정보가 닮겨있을것

		// 3. 로그인 성공 여부에 따라서 결과를 처리하는 작업
		// 내보낼 뷰 변수 따로 다루기
		// 암호화된 패스워드와 전달된 글자타입 패스워드를 비교함. (일치하는지 비교)
		// 이때 matches(글자타입패스워드, 암호화된패스워드)
		String viewName = null;
		if (loginMember != null && this.bcryptPasswordEncoder.matches(member.getUserpwd(), loginMember.getUserpwd())
				&& loginMember.getLogin_ok().equals("Y")) { // 로그인 성공
			// 로그인 상태 관리 방법 (상태 관리 메카니즘라 한다. : 세션 사용하기)

			logger.info("sessionID : " + loginSession.getId()); // 로그인 아이디마다 세션 발급 아이디가 다르다.

			// 로그인한 회원정보가 view에 보여야 한다. jsp도 서버측에서 실행 된다.
			// 필요할 경우 생성된 세션 객체 안에 정보를 저장할 수 있음.
			// 저장방식은 map구조로 저장함 : 키(String), 값(Object)
			loginSession.setAttribute("loginMember", loginMember); // login한 회원정보를 세션에 저장하기
			status.setComplete(); // login 요청 성공이란 멘트를 클라인트에게 보낼 것. (성공 : 200)

			// 로그인 성공시 내보낼 뷰파일명 지정
			viewName = "common/main";
		} else { // 로그인 실패
			model.addAttribute("message", "로그인 실패 : 아이디나 암호 확인하세요! <br>" + "또는 로그인 제한 회원인지 관리자에게 문의하세요."); // 에러메세지를 모델에
																											// 저장
			viewName = "common/error";
		}

		return viewName;
	}

	// 로그아웃 처리
	@RequestMapping("logout.do")
	public String logoutMethod(HttpServletRequest request, Model model) {
		// 로그인할 때 생성된 세션객체를 찾아서 없앰.
		HttpSession session = request.getSession(false);
		// request 기존 세션 있으면 가지고 오고, 없으면 null 을 리턴한다는 것이 false의 의미임.

		if (session != null) {
			// 세션 객체 없앰
			session.invalidate();
			return "common/main";
		} else {
			model.addAttribute("message", "로그인 세션이 존재하지 않습니다.");
			return "common/error";
		}

	}

	// 회원 가입 처리용
	@RequestMapping(value = "enroll.do", method = RequestMethod.POST)
	public String memberInsertMethod(Member member, Model model) {
		// 에러 확인하기 위해 Model을 생성하는 것이다.
		// 메소드 매개변수에 vo 를 지정하면 자동 객체 생성되면서
		// 뷰페이지 form 태그 input의 name 과 vo 필드명이 같으면
		// 자동으로 전송온 값(parameter) 이 꺼내져서 객체에 옮겨 저장된다.
		// 이거를 커멘드 객체(command object)라 부른다.
		logger.info("enroll.do : " + member);

		// 패스워드 암호화 처리 작업
		member.setUserpwd(bcryptPasswordEncoder.encode(member.getUserpwd()));
		// encode 는 암호화 하는 메소드임.
		logger.info("after encode : " + member);
		logger.info("length : " + member.getUserpwd().length());

		if (memberService.insertMember(member) > 0) {
			// 회원 가입 성공
			return "common/main";
		} else {
			// 회원 가입 실패
			model.addAttribute("message", " 회원 가입 실패!");
			return "common/error";
		}
	}

	@RequestMapping("myinfo.do")
	// public String myinfoMethod() {return "폴더명/퓨파일명";}

	// 리턴 타입으로 String, ModelAndView를 사용할 수 있음.
	public ModelAndView myinfoMethod(@RequestParam("userid") String userid, ModelAndView mv) {
		// 서비스로 전송온 값 전달해서, 쿼리 실행 결과 받기
		Member member = memberService.selectMember(userid);

		if (member != null) {
			mv.addObject("member", member);
			mv.setViewName("member/myinfoPage");
		} else {
			mv.addObject("message", userid + ": 회원 정보 조회 실패!");
			mv.setViewName("common/error");
		}

		return mv;
	}

	// =================================================================
	// ajax 통신으로 처리하는 요청 메소드=========================================
	@RequestMapping(value = "idchk.do", method = RequestMethod.POST)
	public void dupIdCheckMethod(@RequestParam("userid") String userid, HttpServletResponse response)
			throws IOException {
		int idCount = memberService.selectDupCheckId(userid);

		String returnValue = null;
		if (idCount == 0) {
			returnValue = "ok";
		} else {
			returnValue = "dup";
		}

		// response 를 이용해서 클라이언트로 네트워크 출력스트림을 만들고 값을 보내기
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		out.append(returnValue);
		out.flush();
		out.close();
	}

	// 회원 정보 수정용 메소드, 수정 성공되면 My Page(myinfoPage.jsp)로 이동하기
	@RequestMapping(value = "mupdate.do", method = RequestMethod.POST)
	public String memberUpdateMethod(Member member, Model model, @RequestParam("origin_userpwd") String originUserpwd) {
		logger.info("mupdate.do : " + member);
		logger.info("origin_userpwd : " + originUserpwd);

		// 새로운 암호가 전송이 왔는지 확인 , 패스워드 암호와 처리함.
		// trim() 사용하면 문자열의 앞뒤에 있는 공백을 삭제 해준다.
		// string 값 비교시 반드시 사용 구문 : (userpwd != null && userpwd.length() >0)
		String userpwd = member.getUserpwd().trim();
		if (userpwd != null && userpwd.length() > 0) {
			// 기존 암호와 다른 값인지 확인 :
			if (!this.bcryptPasswordEncoder.matches(userpwd, originUserpwd)) {
				// member 에 새로운 패스워드를 암호화해서 기록함.
				member.setUserpwd(this.bcryptPasswordEncoder.encode(userpwd));
			}
		} else {
			// 새로운 패스워드 값이 없다면, member의 기존 패스워드를 다시 기록함.
			member.setUserpwd(originUserpwd);
		}
		logger.info("after : " + member);

		if (memberService.updateMember(member) > 0) {
			// 수정이 성공했다면, controller 의 메소드를 직접 호출할 수도 있음.
			// 즉, controller 안에서 다른 controller를 실행 할 수도 있다.
			// 내정보 보기 페이지에 수정된 회원 정보를 다시 조회해서 내보내도록하기 :
			// 무름표(?) : 쿼리스트링 : ?이름=값&이름=값
			return "redirect:myinfo.do?userid=" + member.getUserid();
		} else {
			model.addAttribute("message", member.getUserid() + " : 회원 정보 수정 실패");
			return "common/error";
		}

	} // method end

	// 회원탈퇴 처리 : 회원 정보 삭제
	// 삭제되면 자동 로그아웃 처리
	@RequestMapping("mdel.do")
	public String memberDeleteMethod(@RequestParam("userid") String userid, Model model) {
		if (memberService.deleteMember(userid) > 0) {
			return "redirect:logout.do";
		} else {
			model.addAttribute("message", userid + " : 회원 삭제 실패");
			return "common/error";
		}
	}

	@RequestMapping("mlist.do")
	public String memberListViewMethod(Model model) {
		ArrayList<Member> list = memberService.selectList();
		if (list.size() > 0) {
			model.addAttribute("list", list);
			return "member/memberListView";
		} else {
			model.addAttribute("message", "회원 정보가 존재하지 않습니다!");
			return "common/error";
		}
	}

	@RequestMapping("loginok.do")
	public String changeLoginOKMethod(Member member, Model model) {
		logger.info("loginok.do : " + member.getUserid() + ", " + member.getLogin_ok());

		if (memberService.updateLoginOK(member) > 0) {
			return "redirect:mlist.do";
		} else {
			model.addAttribute("message", "로그인 제한/허용 처리 오류");
			return "common/error";
		}
	}

	// 회원 검색 처리용 메소드
	@RequestMapping(value = "msearch.do", method = RequestMethod.POST)
	public String memberSearchMethod(HttpServletRequest request, Model model) {
		String action = request.getParameter("action");
		String keyword = null, beginDate = null, endDate = null;

		if (action.equals("enrolldate")) {
			beginDate = request.getParameter("begin");
			endDate = request.getParameter("end");
		} else {
			keyword = request.getParameter("keyword");
		}

		// 서비스 메소드 리턴값 받을 리스트 준비
		ArrayList<Member> list = null;
		switch (action) {
		case "id":
			list = memberService.selectSearchUserid(keyword);
			break;
		case "gender":
			list = memberService.selectSearchGender(keyword);
			break;
		case "age":
			list = memberService.selectSearchAge(Integer.parseInt(keyword));
			break;
		case "enrolldate":
			list = memberService.selectSearchEnrollDate(new SearchDate(Date.valueOf(beginDate), Date.valueOf(endDate)));
			break;
		case "loginok":
			list = memberService.selectSearchLoginOK(keyword);
			break;

		}
		if(list.size() > 0) {
			model.addAttribute("list", list);
			return "member/memberListView";
		}else {
			model.addAttribute("message", action + " 검색에 대한 " + keyword + " 결과가 존재하지 않습니다.");
			return "common/error";
		}
	}
	

} // class end
