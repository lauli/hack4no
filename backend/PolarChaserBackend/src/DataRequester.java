import java.io.*;
import java.net.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.List;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlList;
import javax.xml.datatype.XMLGregorianCalendar;

import org.omg.CosNaming.IstringHelper;

import WeatherapiGenXml.Cloudiness;
import WeatherapiGenXml.TimeType;
import WeatherapiGenXml.Weatherdata;

public class DataRequester {

	XmlParser<Weatherdata> weatherXmlParser = new XmlParser<>(Weatherdata.class);

	/**
	 * https://stackoverflow.com/questions/1485708/how-do-i-do-a-http-get-in-java
	 * 
	 * @param urlToRead
	 * @return
	 * @throws Exception
	 */
	private static InputStream getXMLStream(String urlToRead) {
		try {
			URL url;
			url = new URL(urlToRead);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			return conn.getInputStream();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 
	 * @param lat
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @param lon
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @return
	 */
	public Weatherdata getWeatherData(String lat, String lon) {
		String url = "http://api.met.no/weatherapi/locationforecast/1.9/?lat=" + lat + ";lon=" + lon + ";";
		System.out.println("requsting: " + url.toString());
		InputStream stream = getXMLStream(url);
		Weatherdata data = weatherXmlParser.unmarshall(stream);
		return data;
	}

	/**
	 * 
	 * @param lat dot separated floating point number with two decimal numbers e.g. "10.21"
	 * @param lon dot separated floating point number with two decimal numbers e.g. "10.21"
	 * @return cloud opacity between 0 and 400.
	 */
	@SuppressWarnings("deprecation")
	public float getCurrentCloudOpacity(String lat, String lon){
		Weatherdata wData = getWeatherData(lat, lon);
		
		

		//get current time
		ZonedDateTime nowInZulu = ZonedDateTime.now(ZoneOffset.UTC);
		//add one hour. there is no forecast for the current our
		nowInZulu = nowInZulu.plusHours(1);			
		
		System.out.println(nowInZulu);
		List<TimeType> dayForecast = wData.getProduct().get(0).getTime();

		float cloudiness = 0;
		
		for (TimeType t : dayForecast){
			//has correct time. should not have to care about month as this is a 9 day forecast
			if (t.getFrom().getDay() == nowInZulu.getDayOfMonth() 
					&& t.getFrom().getHour() == nowInZulu.getHour()){
				List<JAXBElement<?>> l = t.getLocation().get(0).getGroundCoverAndPressureAndMaximumPrecipitation();
				
				for ( JAXBElement<?> x : l){
					//System.out.println(x.getName());
					String name = x.getName().toString();
					switch(name){
						case "fog":
						case "lowClouds":
						case "mediumClouds":
						case "highClouds":
							Cloudiness cloud = (Cloudiness) x.getValue();
							//System.out.println(cloud.getId()+" "+cloud.getPercent());
							cloudiness += Float.parseFloat(cloud.getPercent());
							break;
						default:
							; //do nothing
					}
				}
			}
		}

	return cloudiness;
}

}
