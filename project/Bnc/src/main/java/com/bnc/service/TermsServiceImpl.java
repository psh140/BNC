package com.bnc.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bnc.domain.TermsVO;
import com.bnc.mapper.TermsMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@AllArgsConstructor
@Log4j
public class TermsServiceImpl implements TermsService{
	@Setter(onMethod_ = @Autowired)
	TermsMapper termsmapper;
	
	@Override
	public TermsVO read(String pol_kind) {
		return termsmapper.read(pol_kind);
	}
}
