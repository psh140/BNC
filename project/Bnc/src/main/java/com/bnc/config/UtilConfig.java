
package com.bnc.config;

public class UtilConfig {

	public final static String FILE_URL_PATH 		= "/resources";
	public final static String FILE_ROOT_PATH 		= System.getenv("FILE_ROOT_PATH") != null ? System.getenv("FILE_ROOT_PATH") : "/app/resources";
	public final static String FILE_CONTRACT_PATH 	= "/contract";

	public final static String FILE_DOWNLOAD_PATH 	= System.getenv("FILE_DOWNLOAD_PATH") != null ? System.getenv("FILE_DOWNLOAD_PATH") : "/app";

}
