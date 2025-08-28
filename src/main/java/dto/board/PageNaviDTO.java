package dto.board;

public class PageNaviDTO {
	private int startNavi = 0;;
	private int endNavi = 0;;
	private boolean jumpPrev;
	private boolean needPrev;
	private boolean jumpNext;
	private boolean needNext;
	private int currentPage = 0;
	private int pageTotalCount = 0;
	
	public int getStartNavi() {
		return startNavi;
	}
	public int getEndNavi() {
		return endNavi;
	}
	public boolean isJumpPrev() {
		return jumpPrev;
	}
	public boolean isNeedPrev() {
		return needPrev;
	}
	public boolean isJumpNext() {
		return jumpNext;
	}
	public boolean isNeedNext() {
		return needNext;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public int getPageTotalCount() {
		return pageTotalCount;
	}
	public PageNaviDTO(int startNavi, int endNavi, boolean jumpPrev, boolean needPrev, boolean jumpNext,
			boolean needNext, int currentPage, int pageTotalCount) {
		this.startNavi = startNavi;
		this.endNavi = endNavi;
		this.jumpPrev = jumpPrev;
		this.needPrev = needPrev;
		this.jumpNext = jumpNext;
		this.needNext = needNext;
		this.currentPage = currentPage;
		this.pageTotalCount = pageTotalCount;
	};
}
