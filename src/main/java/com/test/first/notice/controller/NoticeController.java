package com.test.first.notice.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.test.first.common.SearchDate;
import com.test.first.member.model.vo.Member;
import com.test.first.notice.model.service.NoticeService;
import com.test.first.notice.model.vo.Notice;

@Controller
public class NoticeController {
	
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	@Autowired
	private NoticeService noticeService;
	
	//====================================================================
	// 뷰 페이지 이동 처리용 메소드
	
	// 새 공지글 등록 페이지로 이동
	@RequestMapping("movewrite.do")
	public String moveWritePage() {
		return "notice/noticeWriteForm";
	}
	
	//공지글 수정페이지로 이동
	@RequestMapping("nmoveup.do")
	public String moveUpdatePage(
			@RequestParam("noticeno") int noticeno, Model model) {
		// 수정페이지에 출력할 해당 공지글 다시 조회함. 
		Notice notice = noticeService.selectNotice(noticeno);
		
		if(notice != null) {
			model.addAttribute("notice", notice);
			return "notice/noticeUpdateForm";
		}else {
			model.addAttribute("message", noticeno + "번 공지글 수정페이지로 이동 실패!");
			return "common/error";
		}
	}
	//========================================================================
	
	
	@RequestMapping(value="ntop3.do", method=RequestMethod.POST)
	@ResponseBody
	public String noticeNewTop3Method() throws UnsupportedEncodingException {
		// 최근 공지글 3개 조회해 옴
		ArrayList<Notice> list = noticeService.selectNewTop3();
		
		logger.info("ntop3.do : " + list.size());
		
		// 여기서 전송을 위한 json 객체를 준비 해야 한다.
		JSONObject sendJson = new JSONObject();
		
		// list 를 옮길 json 배열 객체를 따로 준비한다. 
		JSONArray jarr = new JSONArray();
		
		//리턴 받은 list를 jarr 배열에 옮기기 (복사)
		for(Notice notice : list) {
			// notice 객체의 각 필드값 저장할 json 객체 생성함. 
			JSONObject jobj = new JSONObject();
			
			jobj.put("noticeno", notice.getNoticeno());
			//한글에 대해서는 인코딩에서 json 에 담도록 함
			//한글이 깨지지 않음
			
			jobj.put("noticetitle", URLEncoder.encode(notice.getNoticetitle(), "utf-8"));
			
			//날짜는 반드시 toString() 으로 문자열로 바꿔서 json에 담아야 한다. 
			// date는 그대로 json으로 보내면 에러 난다.
			jobj.put("noticedate", notice.getNoticedate().toString());
			
			jarr.add(jobj); // jobj 를 jarr에 저장
		}
		
		// 전송용 객체에 jarr을 담아주는 작업하기
		sendJson.put("list", jarr);
		
		//json 을 json string 으로 바꿔서 전송함. 
		
		return sendJson.toJSONString(); // ==>> 뷰리졸버로 리턴함
		//ajax 로 리턴은 여러가지 방법으로 리턴 할 수 있음 : response 객체 이용
		//1. 출력스트림으로 응답하는 방법 : (아이디 중복체크에서 사용)
		//2. 뷰리졸버로 리턴하는 방법 : response body 에 값을 저장함. 
	}
	
	
	//공지사항 전체 목록보기 요청 처리용
	@RequestMapping("nlist.do")
	public String noticeListMethod(Model model) {
		ArrayList<Notice> list = noticeService.selectAll();
		if(list.size() > 0) {
			model.addAttribute("list", list);
			return "notice/noticeListView";
		}else {
			model.addAttribute("message", "등록된 공지사항 정보가 없습니다");
			return "common/error";
		}
	}
	
	// 공지글 제목 검색용
	@RequestMapping(value="nsearchTitle.do", method=RequestMethod.POST)
	public String noticeSearchTitleMethod(@RequestParam("keyword") String keyword, Model model) {
		ArrayList<Notice> list = noticeService.selectSearchTitle(keyword);
		if(list.size() > 0) {
			model.addAttribute("list", list);
			return "notice/noticeListView";
		}else {
			model.addAttribute("message", keyword + "로 검색된 공지글 정보가 없습니다");
			return "common/error";
		}
		
	}
	
	// 공지글 작성자 검색용
	@RequestMapping(value="nsearchWriter.do", method=RequestMethod.POST)
	public String noticeSearchWriterMethod(@RequestParam("keyword") String keyword, Model model) {
		ArrayList<Notice> list = noticeService.selectSearchWriter(keyword);
		if(list.size() > 0) {
			model.addAttribute("list", list);
			return "notice/noticeListView";
		}else {
			model.addAttribute("message", keyword + "로 검색된 공지글 정보가 없습니다");
			return "common/error";
		}
		
	}
	
	// 공지글 등록날짜 검색용
	@RequestMapping(value="nsearchDate.do", method=RequestMethod.POST)
	public String noticeSearchDateMethod(SearchDate date, Model model) {
		ArrayList<Notice> list = noticeService.selectSearchDate(date);
		if(list.size() > 0) {
			model.addAttribute("list", list);
			return "notice/noticeListView";
		}else {
			model.addAttribute("message", "해당 날짜에 등록된 공지글 정보가 없습니다");
			return "common/error";
		}
		
	}
	
	
	// 공지글 상세보기 요청 처리 메소드
	@RequestMapping("ndetail.do")
	public String noticeDetailMethod(@RequestParam("noticeno") int noticeno, Model model, HttpSession session) {
		// 관리자용 상세보기 페이지와 일반 회원 상세보기 페이지 구분함
		// 매개변수에 HttpSession 추가함
		
		Notice notice = noticeService.selectNotice(noticeno);
		if(notice != null) {
			model.addAttribute("notice", notice);
			
			Member loginMember = (Member)session.getAttribute("loginMember");
			if(loginMember != null && loginMember.getAdmin().equals("Y")) {
				//관리자가 상세보기를 요청했을 때
				return "notice/noticeAdminDetailView";
			}else {
				return "notice/noticeDetailView";
			}
		}else {
			model.addAttribute("message", notice + "번 공지글 상세보기 실패");
			return "common/error";
		}
	}
	
	// 공지글 삭제 요청 처리용
	@RequestMapping("ndel.do")
	public String noticeDeleteMethod(
			@RequestParam("noticeno") int noticeno, 
			@RequestParam(name="rfile", required=false) String renameFileName,
			Model model, HttpServletRequest request) {
		
		if(noticeService.deleteNotice(noticeno) > 0) {
			//첨부된 파일이 있는 공지일때는 저장 폴더에 있는 
			//첨부파일도 삭제함
			if(renameFileName != null) {
				new File(request.getSession().getServletContext().getRealPath("resources/notice_upfiles")
						+ "\\" + renameFileName).delete();
			}
			return "redirect:nlist.do";
		}else {
			model.addAttribute("message", noticeno + "번 공지 삭제 실패!");
			return "common/error";
		}
	}
	
	// 파일업로드 기능이 있는 공지글 등록 요청 처리용
	@RequestMapping(value="ninsert.do", method=RequestMethod.POST)
	public String noticeInsertMethod(Notice notice, 
															Model model, 
															HttpServletRequest request, 
															@RequestParam(name="upfile", required=false) MultipartFile mfile) {
		
		
		
		// 업로드된 파일 저장 폴더 지정(session 객체만든다. 이것은  tomcat이 란 뜻, getServletContext는 구동되는 앱)
		String savePath = request.getSession().getServletContext().getRealPath("resources/notice_upfiles");
		
		// 첨부파일이 있을 때만 업로드된 파일을 지정된 폴더로 옮기기
		//if 는 첨부파일이 있다면...
		if(!mfile.isEmpty()) {
			// 전송온 파일 이름 추출함
			String fileName = mfile.getOriginalFilename();
			
			//다른 공지글의 첨부파일과
			//파일명이 중복되어서 오버라이딩되는 것을 막기 위해
			//파일명을 변경해서 폴더에 저장하는 방식을 사용할 수 있음 
			//변경 파일명 : 년월시분초.확장자
			if(fileName != null && fileName.length() > 0) {
				//바꿀 파일명에 대한 문자열 만들기
				//공지글 등록 요청시점에 날짜시간정보를 이용해서 만들기
				SimpleDateFormat sdf = 
						new SimpleDateFormat("yyyyMMddHHmmss");
				
				//변경할 파일이름 만들기 
				String renameFileName = 
						sdf.format(new java.sql.Date(System.currentTimeMillis()));
				
				//원본 파일의 확장자를 추출해서 변경 파일명에 붙여주는 작업
				renameFileName += "." + fileName.substring(fileName.lastIndexOf(".") + 1);
				
				//파일 객체 만들기
				File originFile = new File(savePath + "\\" + fileName);
				File renameFile = new File(savePath + "\\" + renameFileName);
				
				//업로드된 파일 저장시키고, 바로 이름바꾸기 실행함.
				try {
					mfile.transferTo(renameFile);
				} catch (Exception e) {
					e.printStackTrace();
					model.addAttribute("message", "전송파일 저장 실패");
					return "common/error";
				} 
				
				// notice 객체에 첨부파일명 기록 저장하기
				 notice.setOriginal_filepath(fileName);
				 notice.setRename_filepath(renameFileName);
			}
			
		} // 첨부파일이 있을 때만 
		if(noticeService.insertNotice(notice) > 0) {
			return "redirect:nlist.do";
		}else {
			model.addAttribute("message", "새 공지글 등록 실패");
			return "common/error";
		}
	}
	
	//첨부파일 다운로드 요청 처리용
	@RequestMapping("nfdown.do")
	public ModelAndView fileDownMethod(ModelAndView mv, 
																		HttpServletRequest request, 
																		@RequestParam("ofile") String originalFileName, 
																		@RequestParam("rfile") String renameFileName) {
		// 공지사항 첨부파일 저장 폴더 경로 지정
		String savePath = request.getSession().getServletContext().getRealPath("resources/notice_upfiles");
		
		//저장폴더에서 읽을 파일에 대한 파일 객체를 생성함. 
		//파일 객체 만들기
		File renameFile = new File(savePath + "\\" + renameFileName);
		
		//originFile은 파일다운시 내보낼 파일 객체 생성
		File originFile = new File(originalFileName);
		
		mv.setViewName("filedown"); // 등록된 파일다운로드 처리용 뷰클래스의 id명을 뷰네임으로 지정한 것. 
		mv.addObject("renameFile", renameFile);
		mv.addObject("originFile", originFile);
		
		return mv;
	}
	
	//공지글 수정 요청 처리용
	@RequestMapping(value="nupdate.do", method=RequestMethod.POST)
	public String noticeUpdateMethod(Notice notice, Model model, 
			@RequestParam(name="delFlag", required=false) String delFlag, 
			@RequestParam(name="upfile", required=false) MultipartFile mfile, 
			HttpServletRequest request) {
		// 공지사항 첨부파일 저장 폴더 경로 지정
		String savePath = request.getSession().getServletContext().getRealPath("resources/notice_upfiles");
		
		//첨부파일 수정 처리된 경우============================================
		//1. 원래 첨부파일이 있는데 삭제를 선택한 경우
		if(notice.getOriginal_filepath() != null && delFlag != null && delFlag.equals("yes")) {
			// 저장 폴더에서 파일을 삭제함
			new File(savePath + "\\" + notice.getRename_filepath()).delete(); 
			// notice 의 파일정보도 제거함. 
			notice.setOriginal_filepath(null);
			notice.setRename_filepath(null);
			
		}
		
		//2. 새로운 첨부파일이 있을 경우 : 공지글 첨부파일은 1개만 가능한 경우
		if(!mfile.isEmpty()) {
			// 저장 폴더의 이전 파일은 삭제하기
			if(notice.getOriginal_filepath() != null) {
				// 저장 폴더에서 파일을 삭제함
				new File(savePath + "\\" + notice.getRename_filepath()).delete(); 
				// notice 의 파일정보도 제거함. 
				notice.setOriginal_filepath(null);
				notice.setRename_filepath(null);
			}
			
			//이전 첨부파일이 없을 경우 : =========================
			
			
			
			// 전송온 파일 이름 추출함
			String fileName = mfile.getOriginalFilename();
			
			//다른 공지글의 첨부파일과
			//파일명이 중복되어서 오버라이딩되는 것을 막기 위해
			//파일명을 변경해서 폴더에 저장하는 방식을 사용할 수 있음 
			//변경 파일명 : 년월시분초.확장자
			if(fileName != null && fileName.length() > 0) {
				//바꿀 파일명에 대한 문자열 만들기
				//공지글 등록 요청시점에 날짜시간정보를 이용해서 만들기
				SimpleDateFormat sdf = 
						new SimpleDateFormat("yyyyMMddHHmmss");
				
				//변경할 파일이름 만들기 
				String renameFileName = 
						sdf.format(new java.sql.Date(System.currentTimeMillis()));
				
				//원본 파일의 확장자를 추출해서 변경 파일명에 붙여주는 작업
				renameFileName += "." + fileName.substring(fileName.lastIndexOf(".") + 1);
				
				//파일 객체 만들기
				File originFile = new File(savePath + "\\" + fileName);
				File renameFile = new File(savePath + "\\" + renameFileName);
				
				//업로드된 파일 저장시키고, 바로 이름바꾸기 실행함.
				try {
					mfile.transferTo(renameFile);
				} catch (Exception e) {
					e.printStackTrace();
					model.addAttribute("message", "전송파일 저장 실패");
					return "common/error";
				}
				
				// notice 객체에 첨부파일명 기록 저장하기
				 notice.setOriginal_filepath(fileName);
				 notice.setRename_filepath(renameFileName);
			} // 이름 바꾸기해서 저장 처리
			
		} // 새로운 첨부파일이 있을 경우에만
		
		//=============================================================
		
		
		if(noticeService.updateNotice(notice) > 0) {
			return "redirect:nlist.do";
		}else {
			model.addAttribute("message", notice.getNoticeno() + "번 공지 수정 실패!");
			return "common/error";
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
} // class end
