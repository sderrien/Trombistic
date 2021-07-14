package fr.istic.trombistic;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.swing.ImageIcon;
import javax.swing.JLabel;

public class PhotoLabel extends JLabel {
	
	
	public PhotoLabel() {
		setSize(480, 360);
		setIcon(new EmptyIcon(480, 360));
	}
	
	public void setImage(BufferedImage img) {
		ImageIcon icon = new ImageIcon(img);
		Image scaleImage = img.getScaledInstance(480, 360, Image.SCALE_DEFAULT);
		icon.setImage(scaleImage);
		setIcon(icon);
		
	}
	public void setImage(String filename) {
		
		if (new File(filename).exists()) {
			ImageIcon icon = null;
			icon = new ImageIcon(filename);
			Image scaleImage = icon.getImage().getScaledInstance(480, 360, Image.SCALE_DEFAULT);
			icon.setImage(scaleImage);
			setIcon(icon);
		} else {
			System.err.println(filename+" does not exist");
		}
		
	}



}
