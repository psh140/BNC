package com.bnc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.MailFormVO;
import com.bnc.mapper.MailFormMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Service
@AllArgsConstructor
@Log4j
public class MailFormServiceImpl implements MailFormService{
	@Setter(onMethod_ = @Autowired)
	MailFormMapper mapper;
	@Override
	public MailFormVO read(String malf_kind) {
		// TODO Auto-generated method stub
		return mapper.read(malf_kind);
	}

}
