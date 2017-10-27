import java.io.*;
import java.net.*;

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
	 * @param lat dot separated floating point number with two decimal numbers e.g. "10.21"
	 * @param lon dot separated floating point number with two decimal numbers e.g. "10.21"
	 * @return
	 */
	public Weatherdata getWeatherData(String lat, String lon){
		String url = "http://api.met.no/weatherapi/locationforecast/1.9/?lat="+lat+";lon="+lon+";";
		InputStream stream = getXMLStream(url);
		Weatherdata data = weatherXmlParser.unmarshall(stream);
		return data;
	}

}
