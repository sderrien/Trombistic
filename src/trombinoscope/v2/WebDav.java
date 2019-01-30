package trombinoscope.v2;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import org.apache.commons.io.FileUtils;

import com.github.sardine.DavResource;
import com.github.sardine.Sardine;
import com.github.sardine.SardineFactory;

public class WebDav {
public static void main(String[] args) throws IOException {
	   
	Sardine sardine = SardineFactory.begin("sderrien", args[0]);
	byte[] data = FileUtils.readFileToByteArray(new File("/Users/sderrien/Documents/workspace-mars/trombinoscope/src/trombinoscope/WebDav.java"));
	
	
	//sardine.put("https://share-ens.istic.univ-rennes1.fr/2017-2018/l3info/PFO/WebDav.java", data);    
	sardine.put("https://partages-ldap.univ-rennes1.fr/files/partages/Enseignement/ISTIC/M1/Listes/WebDav.java", data);    
}
}