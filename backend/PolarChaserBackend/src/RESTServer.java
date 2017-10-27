import static spark.Spark.*;


public class RESTServer {

	public static void main(String[] args) {
		
		// Configure Spark
        port(4567);
        //use external dir for files
        String projectDir = System.getProperty("user.dir");
        String staticDir = "/resources/public";
        staticFiles.externalLocation(projectDir + staticDir);
        staticFiles.expireTime(600L);

        
        
		//set up routes
		get("/overlay/UL/:ULlat/:ULlon/LR/:LRlat/:LRlon", (req, res) -> {
			
			return "Lat: "+req.params("ULlat")+" Lon:"+req.params("ULlon");
		});

	}

}
