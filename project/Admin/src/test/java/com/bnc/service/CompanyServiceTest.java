package com.bnc.service;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class CompanyServiceTest {
	@Setter(onMethod_ = {@Autowired})
	CompanyService service;
	
//	@Test
	public void testCompanyList() {
//		service.getList(new Criteria(1, 5)).forEach(company -> log.info(company));
		service.getList().forEach(company -> log.info(company));
	}
}
