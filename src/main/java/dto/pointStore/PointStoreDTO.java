package dto.pointStore;

import java.sql.Timestamp;

public class PointStoreDTO {
    private int seq;
    private String itemName;
    private int price;
    private String url;
    private String contents;
    private int stock;
    private java.sql.Timestamp created_At;
    private java.sql.Timestamp updated_At;
    // Getters and Setters
    
	public PointStoreDTO(int seq, String itemName, int price, String url, String contents, int stock,
			Timestamp created_At, Timestamp updated_At) {
		super();
		this.seq = seq;
		this.itemName = itemName;
		this.price = price;
		this.url = url;
		this.contents = contents;
		this.stock = stock;
		this.created_At = created_At;
		this.updated_At = updated_At;
	}
    
	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public java.sql.Timestamp getCreated_At() {
		return created_At;
	}
	public void setCreated_At(java.sql.Timestamp created_At) {
		this.created_At = created_At;
	}
	public java.sql.Timestamp getUpdated_At() {
		return updated_At;
	}
	public void setUpdated_At(java.sql.Timestamp updated_At) {
		this.updated_At = updated_At;
	}
    
    
    
}
