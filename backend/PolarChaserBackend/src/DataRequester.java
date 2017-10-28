import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.List;

import javax.xml.bind.JAXBElement;

import WeatherapiGenXml.Cloudiness;
import WeatherapiGenXml.TimeType;
import WeatherapiGenXml.Weatherdata;

public class DataRequester {

	XmlParser<Weatherdata> weatherXmlParser = new XmlParser<>(Weatherdata.class);
	/**
	 * Stores the aurora probability data from 0 to 100, [latitude][longitude]
	 */
	private int[][] auroraMap;
	private long lastUpdate = 0;

	/**
	 * https://stackoverflow.com/questions/1485708/how-do-i-do-a-http-get-in-java
	 * 
	 * @param urlToRead
	 * @return
	 * @throws Exception
	 */
	private static InputStream getStreamFromUrl(String urlToRead) {
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

	private int[][] getFreshAuroraData() throws IOException {
		String url = "http://services.swpc.noaa.gov/text/aurora-nowcast-map.txt";
		InputStream stream = getStreamFromUrl(url);
		BufferedReader rd = new BufferedReader(new InputStreamReader(stream));

		int[][] data = new int[512][/* 1024 */];
		int index = 0;

		String line;
		while ((line = rd.readLine()) != null) {
			if (line.startsWith("#"))
				continue;
			data[index++] = Arrays.stream(line.trim().split("\\s+")).mapToInt(Integer::parseInt).toArray();
		}
		return data;
	}

	public float getAuroraChance(float lat, float lon) {
		try {
			if (lastUpdate < System.currentTimeMillis() - 5 * 60 * 1000){ //5 min 
				auroraMap = getFreshAuroraData();
				lastUpdate = System.currentTimeMillis();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (auroraMap == null) {
			return 0;
		}

		// clamp lat and lon
		lat = Float.min(90, Float.max(-90, lat));
		lon = Float.min(360, Float.max(0, lon));

		int latIndex = (int) (((lat + 90) / 180) * (auroraMap.length-1));
		int lonIndex = (int) ((lon / 360) * (auroraMap[0].length-1));
		
//		System.out.println(latIndex + ":" + lonIndex);

		// TODO: interpolate
		return auroraMap[latIndex][lonIndex]/100f;

	}

	/**
	 * docu
	 * http://api.met.no/weatherapi/locationforecast/1.9/documentation#schema
	 * 
	 * @param lat
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @param lon
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @return
	 */
	public Weatherdata getWeatherData(float lat, float lon) {
		String latStr = String.format("%.2f", lat);
		String lonStr = String.format("%.2f", lon);
		
		String url = "http://api.met.no/weatherapi/locationforecast/1.9/?lat=" 
				+ latStr + ";lon=" + lonStr + ";";
		System.out.println("requsting: " + url.toString());
		InputStream stream = getStreamFromUrl(url);
		Weatherdata data = weatherXmlParser.unmarshall(stream);
		return data;
	}

	/**
	 * 
	 * @param lat
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @param lon
	 *            dot separated floating point number with two decimal numbers
	 *            e.g. "10.21"
	 * @return cloud opacity between 0 and 1.
	 */
	public float getCurrentCloudOpacity(float lat, float lon) {
		Weatherdata wData = getWeatherData(lat, lon);

		// get current time
		ZonedDateTime nowInZulu = ZonedDateTime.now(ZoneOffset.UTC);
		// add one hour. there is no forecast for the current our
		nowInZulu = nowInZulu.plusHours(1);

		System.out.println(nowInZulu);
		List<TimeType> dayForecast = wData.getProduct().get(0).getTime();

		float cloudiness = 0;

		for (TimeType t : dayForecast) {
			// has correct time. should not have to care about month as this is
			// a 9 day forecast
			if (t.getFrom().getDay() == nowInZulu.getDayOfMonth() && t.getFrom().getHour() == nowInZulu.getHour()) {
				List<JAXBElement<?>> l = t.getLocation().get(0).getGroundCoverAndPressureAndMaximumPrecipitation();

				for (JAXBElement<?> x : l) {
					// System.out.println(x.getName());
					String name = x.getName().toString();
					switch (name) {
					case "fog":
					case "lowClouds":
					case "mediumClouds":
					case "highClouds":
						Cloudiness cloud = (Cloudiness) x.getValue();
						// System.out.println(cloud.getId()+"
						// "+cloud.getPercent());
						cloudiness = Math.max(cloudiness,
								Float.parseFloat(cloud.getPercent()));
						break;
					default:
						; // do nothing
					}
				}
			}
		}

		return cloudiness/100;
	}

}
