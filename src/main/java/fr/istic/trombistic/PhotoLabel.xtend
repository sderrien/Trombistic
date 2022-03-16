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

class PhotoLabel extends JLabel {
	String photo
	int w
	int h
	int offset_x
	int offset_y
	Image scaledImage

	Rectangle boundaries

	new(int w, int h) {
		this.w = w
		this.h = h
		offset_x = 0
		offset_y = 0
		setSize(w, h)
		setIcon(new EmptyIcon(w, h))
	}

	def void setImage(String filename) {
		try {
		if (new File(filename).exists()) {
			// Add your image here
			photo = filename
			var ImageIcon icon = new ImageIcon(photo)
			var int img_h = icon.getIconHeight()
			var int img_w = icon.getIconWidth()
			val imgAspectRatio = (1.0 * img_w) / img_h
			val targetAspectRatio = (1.0 * w) / h

			val MBFImage image = ImageUtilities.readMBF(new File(photo))
			val FaceDetector<DetectedFace, FImage> fd = new HaarCascadeDetector(200)
			val List<DetectedFace> faces = fd.detectFaces(Transforms.calculateIntensity(image))
			if (!faces.empty) {
				boundaries = faces.head.getBounds()
			} else {
				boundaries = null
			}

			if (imgAspectRatio > targetAspectRatio) {
				var int height = (1 / imgAspectRatio * w) as int
				var int width = w;
				offset_x = 0
				offset_y = (h - height) / 2
				println('''Scale «img_w»x«img_h» for «w»x«h» -> «width»x«height» offset «offset_x»,«offset_y»''')
				scaledImage = icon.getImage().getScaledInstance(w, height, Image::SCALE_DEFAULT)
				if (boundaries !== null) {
					boundaries.scale(((1.0 * w) / img_w).floatValue)
				}
			} else {

				var int width = (1 / imgAspectRatio * h) as int
				var int height = h;
				offset_x = (w - width) / 2
				offset_y = 0

				println('''Scale «img_w»x«img_h» for «w»x«h» -> «width»x«height» offset «offset_x»,«offset_y»''')
				scaledImage = icon.getImage().getScaledInstance(width, height, Image::SCALE_DEFAULT)
				if (boundaries !== null) {
					boundaries.scale(((1.0 * h) / img_h).floatValue)
				}
			}
			icon.setImage(scaledImage)
			setIcon(icon)
		} else {
			var ImageIcon icon = new ImageIcon(photo)
			val imageURL = getClass().getClassLoader().getResource("images" + File.separator + name);
			if (imageURL !== null) {
				val img = Toolkit.getDefaultToolkit().getImage(imageURL);
				icon.setImage(img)
			}
		}
			
		} catch (Exception exception) {
			
		}
	}

	override void paint(Graphics g) {
		// super.paint(g)
		g.drawImage(scaledImage, 0, 0, this)
		if (boundaries !== null) {
			g.setColor(Color.green)
			g.drawRect(boundaries.topLeft.x.intValue, boundaries.topLeft.y.intValue, boundaries.width.intValue,
				boundaries.height.intValue)
		}
	}
}
