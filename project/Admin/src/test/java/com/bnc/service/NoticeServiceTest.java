package com.bnc.service;

import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.bnc.domain.PaginationVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class NoticeServiceTest {
	@Setter(onMethod_ = {@Autowired})
	NoticeService service;
	
//	@Test
	public void testList() {
		service.selectNoticeList(new PaginationVO());
	}
}
