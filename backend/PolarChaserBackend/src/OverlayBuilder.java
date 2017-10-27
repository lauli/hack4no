import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class OverlayBuilder {
	
	DataRequester dr = new DataRequester();

	public void createImage(int width,int height, LatLonPos ul, LatLonPos lr) {
		
		
		BufferedImage off_Image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB_PRE);
		
		Graphics2D graph = off_Image.createGraphics();
		//fill with transparent
		Color transparent = new Color(0, 0, 0, 0);
		graph.setColor(transparent);
		graph.fillRect(0, 0, width, height);
		
		float latDiff = Math.abs(lr.lat - ul.lat);
		float lonDiff = Math.abs(lr.lon - ul.lon);
		for (int y = 0; y < height; y++){
			for (int x = 0; x < width; x++){
				float xRelDif = (float) (x) / width;
				float yRelDif = (float) (y) / height;
				
				float lat = ul.lat + yRelDif * latDiff;
				float lon = ul.lon + xRelDif * lonDiff;
				
				float aurora = dr.getAuroraChance(lat, lon)*10;
				float clouds = dr.getCurrentCloudOpacity(lat, lon);
				
				Color col = new Color(clouds, aurora, 0, 0.5f);
				graph.setColor(col);
				graph.drawLine(x, y, 1, 1);
			}
		}

		try {
			// retrieve image
			BufferedImage bi = off_Image;
			File outputfile = new File("saved.png");

			ImageIO.write(bi, "png", outputfile);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	public static void main(String[] args) {
		OverlayBuilder ob = new OverlayBuilder();

		LatLonPos ul = new LatLonPos(66.94f, -23.95f);
		LatLonPos lr = new LatLonPos(62.595f, -13.45f);
		
		ob.createImage(10,10,ul,lr);
	}

}
