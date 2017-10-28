import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;



public class LightParser
{	
	//Oslo
	//201557, 8383861
	
	public static double[] transformVar = {2.67862588029757009e+05, 4.6383121534928847e+02,
			0.0000000000000000e+00, 1.1657062598929735e+07,
			0.0000000000000000e+00, -1.1154442497461018e+03};
	
	
	/*
	 *	 
	 *
	 */
	
	public static Color getLightPolutionData(double longtitude, double latitude) throws IOException
	{
		File imageTemp = new File("D:\\DataTilHack4No/dataImage1.png");
		BufferedImage image = ImageIO.read(imageTemp);
		
		int h = image.getHeight();
		int w = image.getWidth();
		
		Coord temp = getImagePos(longtitude, latitude, h, w);
		
		int rgb = image.getRGB(temp.heightPos, temp.widthPos);
		Color test = new Color(rgb);
		System.out.println(test);
		return null;
	}
	
	
	//2000-2835
	//TODO 
	public static Coord getImagePos(double longtitude, double latitude, int imageHeight, int imageWidth)
	{
		
		Coord temp = new Coord();
		/**
		 * 
		 * 
		 * 
		 */
		temp.widthPos = (int) ((longtitude - transformVar[3])/transformVar[5]);
		temp.heightPos = (int) ((latitude + transformVar[0])/transformVar[1]);
		
		System.out.println(temp.widthPos +" " + temp.heightPos );
		
		
		return temp;
	}
	
	
	public static void main(String[] args) throws IOException
	{
		Color test = getLightPolutionData(60,11);
	}
	
}
