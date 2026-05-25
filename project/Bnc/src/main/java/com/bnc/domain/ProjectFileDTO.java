package com.bnc.domain;

import lombok.Data;

@Data
public class ProjectFileDTO {

	private int prof_seq;				//시퀀스
	private int prof_proj_number;		//프로젝트 고유 번호
	private String prof_file_path;		//파일 경로
	private String prof_file_name;		//파일 이름
}
