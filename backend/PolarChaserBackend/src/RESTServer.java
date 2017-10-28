import static spark.Spark.*;


public class RESTServer {

		static boolean lock = false; //not save .. late minute
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
			if (lock)
				return "";
			lock = true;
			System.out.println("got GET: "+req.url());
			LatLonPos ul = new LatLonPos(Float.parseFloat(req.params("ULlat")),
					Float.parseFloat(req.params("ULlon")));
			LatLonPos lr = new LatLonPos(Float.parseFloat(req.params("LRlat")),
					Float.parseFloat(req.params("LRlon")));
			float ratio = Float.parseFloat(req.params("ratio"));
			
			String filename = System.currentTimeMillis()+".png";
			String url = "overlay/"+filename;
			String path = "resources\\public\\overlay\\";
			
			ob.createImage(50, 100, ul, lr, path+filename,true,true);			
			System.out.println("done");
			lock = false;
			return url;
		});
		
		get("/overlayA/UL/:ULlat/:ULlon/LR/:LRlat/:LRlon/ratio/:ratio", (req, res) -> {
			if (lock)
				return "";
			lock = true;
			System.out.println("got GET: "+req.url());
			LatLonPos ul = new LatLonPos(Float.parseFloat(req.params("ULlat")),
					Float.parseFloat(req.params("ULlon")));
			LatLonPos lr = new LatLonPos(Float.parseFloat(req.params("LRlat")),
					Float.parseFloat(req.params("LRlon")));
			float ratio = Float.parseFloat(req.params("ratio"));
			
			String filename = System.currentTimeMillis()+".png";
			String url = "overlay/"+filename;
			String path = "resources\\public\\overlay\\";
			
			ob.createImage(50, 100, ul, lr, path+filename,true,false);			
			System.out.println("done");
			lock = false;
			return url;
		});
		
		get("/overlayC/UL/:ULlat/:ULlon/LR/:LRlat/:LRlon/ratio/:ratio", (req, res) -> {
			if (lock)
				return "";
			lock = true;
			System.out.println("got GET: "+req.url());
			LatLonPos ul = new LatLonPos(Float.parseFloat(req.params("ULlat")),
					Float.parseFloat(req.params("ULlon")));
			LatLonPos lr = new LatLonPos(Float.parseFloat(req.params("LRlat")),
					Float.parseFloat(req.params("LRlon")));
			float ratio = Float.parseFloat(req.params("ratio"));
			
			String filename = System.currentTimeMillis()+".png";
			String url = "overlay/"+filename;
			String path = "resources\\public\\overlay\\";
			
			ob.createImage(50, 100, ul, lr, path+filename,false,true);			
			System.out.println("done");
			lock = false;
			return url;
		});
		//to test: http://localhost:5537/overlay/UL/66.94/-23.95/LR/63.595/-13.45/ratio/3

	}

}
