package com.test.first.member.model.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.test.first.common.SearchDate;
import com.test.first.member.model.dao.MemberDao;
import com.test.first.member.model.vo.Member;

@Service("memberService") // 설정하면 xml 에 자동 등록 된다. (id 지정함)
public class MemberServiceImpl implements MemberService {

	@Autowired // 자동 의존성 주입 처리됨(자동 객체 생성됨)
	private MemberDao memberDao;

	@Override
	public Member selectLogin(Member member) {
		return memberDao.selectLogin(member);
	}

	@Override
	public int insertMember(Member member) {
		return memberDao.insertMember(member);
	}

	@Override
	public Member selectMember(String userid) {
		return memberDao.selectMember(userid);
	}

	@Override
	public int selectDupCheckId(String userid) {
		return memberDao.selectDupCheckId(userid);
	}

	@Override
	public int updateMember(Member member) {
		return memberDao.updateMember(member);
	}

	@Override
	public int deleteMember(String userid) {
		return memberDao.deleteMember(userid);
	}

	@Override
	public ArrayList<Member> selectList() {
		return memberDao.selectList();
	}

	@Override
	public int updateLoginOK(Member member) {
		return memberDao.updateLoginOK(member);
	}

	@Override
	public ArrayList<Member> selectSearchUserid(String keyword) {
		return memberDao.selectSearchUserid(keyword);
	}

	@Override
	public ArrayList<Member> selectSearchGender(String keyword) {
		return memberDao.selectSearchGender(keyword);
	}

	@Override
	public ArrayList<Member> selectSearchAge(int age) {
		return memberDao.selectSearchAge(age);
	}

	@Override
	public ArrayList<Member> selectSearchEnrollDate(SearchDate searchDate) {
		return memberDao.selectSearchEnrollDate(searchDate);
	}

	@Override
	public ArrayList<Member> selectSearchLoginOK(String keyword) {
		return memberDao.selectSearchLoginOK(keyword);
	}
}
