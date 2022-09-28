package fr.istic.trombistic

import java.awt.Graphics
import java.awt.Image
import java.io.File
import javax.swing.ImageIcon
import javax.swing.JLabel
import org.openimaj.image.FImage
import org.openimaj.image.MBFImage
import org.openimaj.image.colour.Transforms
import org.openimaj.image.processing.face.detection.DetectedFace
import org.openimaj.image.processing.face.detection.FaceDetector
import org.openimaj.image.processing.face.detection.HaarCascadeDetector
import org.openimaj.image.ImageUtilities
import java.util.List
import org.openimaj.math.geometry.shape.Rectangle
import java.awt.Color
import java.awt.Toolkit
import javax.imageio.ImageIO
import java.awt.image.BufferedImage
import java.awt.Graphics2D

class PhotoLabel extends JLabel {
	
	String photo
	int labelWidth
	int labelHeight
	int user_offset_x
	BufferedImage scaledImage

	Rectangle boundaries
	Rectangle cropped
	
	float user_scale =1

	new(int w, int h) {
		this.labelWidth = w
		this.labelHeight = h
		user_offset_x =0
		setSize(w, h)
		setIcon(new EmptyIcon(w, h))
	}

	def extractFaceBoundaries() {
		val MBFImage image = ImageUtilities.readMBF(new File(photo))
		val FaceDetector<DetectedFace, FImage> fd = new HaarCascadeDetector(200)
		val List<DetectedFace> faces = fd.detectFaces(Transforms.calculateIntensity(image))
		if (!faces.empty) {
			faces.head.getBounds()
		} else {
			new Rectangle(0,0,image.width-1,image.height-1)
		}
	}

def static BufferedImage toBufferedImage(Image img)
{
    if (img instanceof BufferedImage)
    {
        return img;
    }

    // Create a buffered image with transparency
    val BufferedImage bimage = new BufferedImage(img.getWidth(null), img.getHeight(null), BufferedImage.TYPE_INT_ARGB);

    // Draw the image on to the buffered image
    val bGr = bimage.createGraphics();
    bGr.drawImage(img, 0, 0, null);
    

    // Return the buffered image
    return bimage;
}

	def void setImage(String filename) {
		photo = filename
		updateImage
	}

	override void paint(Graphics g) {
		val g2d =  g as Graphics2D;
		super.paint(g)
		val photoFile = new File(photo)
		if (photoFile.exists) {
			val BufferedImage img = ImageIO.read(photoFile);
			val viewScale = (labelWidth+0.0f)/img.width
			scaledImage = img
			.getScaledInstance(
					labelWidth, 
					(viewScale*img.height).intValue, 
					Image::SCALE_DEFAULT
			).toBufferedImage;
			
			g2d.drawImage(scaledImage, 0, 0, this)
			val img_offset_x =  (user_offset_x/200.0*scaledImage.width).intValue
			g2d.color = (new Color(0, 255, 0));
			
			g2d.drawRect(img_offset_x,0,scaledImage.width-2*img_offset_x,scaledImage.height)
		} else {
			g2d.setPaint(new Color(150, 150, 150));
			g2d.fillRect(0,0,labelWidth,labelHeight)
		}
			
	}
	
	def setOffset(int i) {
		user_offset_x=i
		println('''Change offset ''')
		updateImage
	}
	
	def setScale(int i) {
		user_scale = i/100.0f
		println('''Change scale ''')
		updateImage
	}
	
	def updateImage() {
		println('''Update Image ''')
		val photoFile = new File(photo)
		if (photoFile.exists) {
			val BufferedImage img = ImageIO.read(photoFile);
			println('''Image «img.width»x«img.height» [«photo»]''')
			val img_offset_x =  (user_offset_x/200.0*img.width).intValue
			val BufferedImage cropped = img.getSubimage(img_offset_x, 0, img.width-2*img_offset_x, img.height);
			scaledImage = cropped
			.getScaledInstance(
					(user_scale*cropped.width).intValue, 
					(user_scale*cropped.height).intValue, 
					Image::SCALE_DEFAULT
			).toBufferedImage;
			println('''Image «scaledImage.width»x«scaledImage.height» [«photo»]''')
			val newfileName = photo.replace(".png","_scaled.png")
			ImageIO.write(scaledImage,"png", new File(newfileName))
		} else {
			scaledImage = null
		}
		repaint
		
	}
	
}
