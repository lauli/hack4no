import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

public class OverlayBuilder {

	DataRequester dr = new DataRequester();

	public void createImage(int width, int height, LatLonPos ul, LatLonPos lr, String filename, boolean doAurora,
			boolean doCloud) {

		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB_PRE);

		Graphics2D graph = image.createGraphics();
		// fill with transparent
		Color transparent = new Color(0, 0, 0, 0);
		graph.setColor(transparent);
		graph.fillRect(0, 0, width, height);

		float latDiff = Math.abs(lr.lat - ul.lat);
		float lonDiff = Math.abs(lr.lon - ul.lon);

		int fieldXDim = 3;
		int fieldYDim = 4;
		LatLonPos[][] posField = new LatLonPos[fieldYDim][fieldXDim];
		float[][] cloudiness = new float[fieldYDim][fieldXDim];
		for (int y = 0; y < fieldYDim; y++) {
			for (int x = 0; x < fieldXDim; x++) {
				float xRelDif = (float) (x) / (fieldXDim - 1);
				float yRelDif = (float) (y) / (fieldYDim - 1);

				float lat = ul.lat + yRelDif * latDiff;
				float lon = ul.lon + xRelDif * lonDiff;

				LatLonPos tmpPos = new LatLonPos(lat, lon);
				posField[y][x] = tmpPos;
				System.out.println("cloud data pos: " + y + ":" + x + " (y/x)");
				if (doCloud)
					cloudiness[y][x] = dr.getCurrentCloudOpacity(tmpPos);
			}
		}

		for (int y = 0; y < height; y++) {
			for (int x = 0; x < width; x++) {
				// interpolate
				float transVert = (fieldYDim - 1) / (float) (height);
				float transHori = (fieldXDim - 1) / (float) (width);
				float yF = y * transVert;
				float xF = x * transHori;

				int xI = (int) (xF + 0.5f);
				int yI = (int) (yF + 0.5f);

				float xDiff = xF - xI;
				float yDiff = yF - yI;

				int xIDiff = (xDiff > 0) ? 1 : -1;
				int yIDiff = (yDiff > 0) ? 1 : -1;

				int xI2 = xI;
				int yI2 = yI + yIDiff;

				int xI3 = xI + xIDiff;
				int yI3 = yI;

				// threepoint interpolation
				float cloud = 0;
				if (doCloud) {
					cloud = 0.5f * cloudiness[clap(yI, 0, fieldYDim - 1)][clap(xI, 0, fieldXDim - 1)];
					cloud += 0.25f * cloudiness[clap(yI2, 0, fieldYDim - 1)][clap(xI2, 0, fieldXDim - 1)];
					cloud += 0.25f * cloudiness[clap(yI3, 0, fieldYDim - 1)][clap(xI3, 0, fieldXDim - 1)];
				}

				float aurora = 0;
				if (doAurora) {
					float tmplat = ul.lat + (y / (float)(height - 1f)) * latDiff;
//					System.out.println(tmplat);
					float tmplon = ul.lon + (x / (float)(width - 1f)) * lonDiff;
					//System.out.println(tmplon);
					aurora = dr.getAuroraChance(tmplat, tmplon);
				}
				// System.out.println(aurora);
				aurora = Math.min(1, aurora * 10); // amplyfing

				Color color = new Color(cloud, aurora, 0, 0.5f);
				image.setRGB(x, y, color.getRGB());
			}
		}

		// float aurora = dr.getAuroraChance(lat, lon)*10;
		// float clouds = dr.getCurrentCloudOpacity(lat, lon);

		try {
			// retrieve image
			BufferedImage bi = image;
			File outputfile = new File(filename);

			ImageIO.write(bi, "png", outputfile);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	// public static void main(String[] args) {
	// OverlayBuilder ob = new OverlayBuilder();
	//
	// LatLonPos ul = new LatLonPos(66.94f, -23.95f);
	// LatLonPos lr = new LatLonPos(62.595f, -13.45f);
	//
	// ob.createImage(10,10,ul,lr,"save");
	// }

	public static int clap(int value, int from, int to) {
		return Math.max(from, Math.min(to, value));
	}

}
