package com.bnc.mapper;

import com.bnc.domain.TermsVO;

public interface TermsMapper {

	public TermsVO read(String pol_kind);
	
	public void modify(TermsVO terms);
}
