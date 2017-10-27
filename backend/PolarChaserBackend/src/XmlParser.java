
import java.io.InputStream;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

//to generate from xsd 
//"C:\Program Files (x86)\Java\jdk1.8.0_121\bin\xjc" -p WeatherapiGenXml schema.xsd

/**
 * Wrapper for JAXB unmarshaller (xml parser)
 * @author Jan
 *
 * @param <T> target root class
 */
public class XmlParser<T> {
	private JAXBContext context;
	private Unmarshaller unmarshaller;
	
	public XmlParser( Class<T> rootClass){
		try {
			context = JAXBContext.newInstance(rootClass);
			unmarshaller = context.createUnmarshaller();
		} catch (JAXBException e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("unchecked")
	public T unmarshall( InputStream xmlString){
		T root = null;
		try {
			root = (T) unmarshaller.unmarshal(xmlString);
		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return root;
	}

	
}
