package com.bnc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.AdminVO;
import com.bnc.mapper.AuthMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Service
@AllArgsConstructor
@Log4j
public class AuthServiceImpl implements AuthService{
	@Setter(onMethod_ = @Autowired)
	AuthMapper mapper;

	@Override
	public boolean adminLoginSelect(AdminVO admin) {
		log.info("받은 아이디 : " + admin.getAdmin_id());
		log.info("받은 비번 : " + admin.getAdmin_password());
		
		return mapper.adminLoginSelect(admin) == 1;
	}
}
