package com.test.first.member.model.dao;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.test.first.common.SearchDate;
import com.test.first.member.model.vo.Member;

@Repository("memberDao") // 설정하면 xml 에 자동 등록 된다. id를 지정함
public class MemberDao {
	// MyBatis mapper file 의 query문을 dao가 실행함.
	// root-context.xml 생성된 객체를 연결하여 사용함.
	@Autowired
	private SqlSessionTemplate session;

	public Member selectLogin(Member member) {
		// mybatis 사용하면 이렇게 간단하게 만들고 끝난다.
		return session.selectOne("memberMapper.selectLogin", member);
	}

	public int insertMember(Member member) {
		return session.insert("memberMapper.insertMember", member);
	}

	public Member selectMember(String userid) {
		return session.selectOne("memberMapper.selectMember", userid);
	}

	public int selectDupCheckId(String userid) {
		return session.selectOne("memberMapper.selectCheckId", userid);
	}

	public int updateMember(Member member) {
		return session.update("memberMapper.updateMember", member);
	}

	public int deleteMember(String userid) {
		return session.delete("memberMapper.deleteMember", userid);
	}
	
	public ArrayList<Member> selectList() {
		List<Member> list = session.selectList("memberMapper.selectList");
		return (ArrayList<Member>)list;  // 이 과 같이 형변환 한다. 
	}
	
	public int updateLoginOK(Member member) {
		return session.update("memberMapper.updateLoginOK", member);
	}
	
	//검색 처리용 메소드==========================================
	public ArrayList<Member> selectSearchUserid(String keyword) {
		List<Member> list = session.selectList("memberMapper.selectSearchUserid", keyword);
		return (ArrayList<Member>)list;
	}
	public ArrayList<Member> selectSearchGender(String keyword) {
		List<Member> list = session.selectList("memberMapper.selectSearchGender", keyword);
		return (ArrayList<Member>)list;
	}
	public ArrayList<Member> selectSearchAge(int age) {
		List<Member> list = session.selectList("memberMapper.selectSearchAge", age);
		return (ArrayList<Member>)list;
	}
	public ArrayList<Member> selectSearchEnrollDate(SearchDate searchDate) {
		List<Member> list = session.selectList("memberMapper.selectSearchEnrollDate", searchDate);
		return (ArrayList<Member>)list;
	}
	public ArrayList<Member> selectSearchLoginOK(String keyword) {
		List<Member> list = session.selectList("memberMapper.selectSearchLoginOK", keyword);
		return (ArrayList<Member>)list;
	}
	
	
	
	
}
