package commons;

public class Config {

	//설정 값
	// RECORD_COUNT_PER_PAGE : 한 페이지당 글 개수
	public static final int RECORD_COUNT_PER_PAGE = 10;
	// NAVI_COUNT_PER_PAGE : 한 페이지당 네비 개수
	public static final int NAVI_COUNT_PER_PAGE = 10;
	public static int getRECORD_COUNT_PER_PAGE() {
		return RECORD_COUNT_PER_PAGE;
	}
}
