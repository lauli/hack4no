import static spark.Spark.*;


public class RESTServer {

	public static void main(String[] args) {
		OverlayBuilder ob = new OverlayBuilder();
		
		// Configure Spark
        port(5537);
        //use external dir for files
        String projectDir = System.getProperty("user.dir");
        String staticDir = "/resources/public";
        staticFiles.externalLocation(projectDir + staticDir);
        staticFiles.expireTime(600L);

        
        
		//set up routes
		get("/overlay/UL/:ULlat/:ULlon/LR/:LRlat/:LRlon/ratio/:ratio", (req, res) -> {
			LatLonPos ul = new LatLonPos(Float.parseFloat(req.params("ULlat")),
					Float.parseFloat(req.params("ULlon")));
			LatLonPos lr = new LatLonPos(Float.parseFloat(req.params("LRlat")),
					Float.parseFloat(req.params("LRlon")));
			float ratio = Float.parseFloat(req.params("ratio"));
			
			String filename = "overlay\\"+System.currentTimeMillis()+".png";
			String path = "resources\\public\\";
			
			ob.createImage(10, 10, ul, lr, path+filename);			
			
			return filename;
		});
		//to test: http://localhost:5537/overlay/UL/66.94/-23.95/LR/63.595/-13.45/ratio/3

	}

}
