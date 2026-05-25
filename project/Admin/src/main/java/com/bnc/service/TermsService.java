package com.bnc.service;

import com.bnc.domain.TermsVO;

public interface TermsService {
	public TermsVO read(String pol_kind);
	
	public void modify(TermsVO terms);
}
