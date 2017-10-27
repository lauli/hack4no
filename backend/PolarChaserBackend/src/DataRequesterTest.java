import WeatherapiGenXml.Weatherdata;

public class DataRequesterTest {
	public static void main(String[] args) {
		DataRequester req = new DataRequester();
		
		//test 1
		//Weatherdata wData = req.getWeatherData("60.10", "9.58");
		//System.out.println(wData.getProduct().get(0).getTime().get(0).getFrom().toString());
		
		//test 2
		req.getCurrentCloudOpacity("60.10", "9.58");
	}
	
}
