import java.util.Random;

public class DataRequesterTest {
	public static void main(String[] args) {
		DataRequester req = new DataRequester();
		
		//test 1
		//Weatherdata wData = req.getWeatherData("60.10", "9.58");
		//System.out.println(wData.getProduct().get(0).getTime().get(0).getFrom().toString());
		
		//test 2
		//req.getCurrentCloudOpacity("60.10", "9.58");
		
		//test 3
//		for (int i = 0; i < 10; i++){
//			int lat = 50+i*3;
//			int lon = 70;
//			System.out.println(lat+":"+lon+": "+ req.getAuroraChance(lat, lon));
//		}
		
		//find the lights
		System.out.println("Searching polar lights");
		Random rnd = new Random();
		for (int i = 0; i < 100000; i++){
			int lat = rnd.nextInt(180)-90;
			int lon = rnd.nextInt(360);
			float strength = req.getAuroraChance(lat, lon);
			if (strength > 20)
				System.out.println(lat+":"+lon+": "+ strength);
		}
	}
	
}
