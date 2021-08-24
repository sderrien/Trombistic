package fr.istic.trombistic

import org.opencv.core.Mat
import org.opencv.core.MatOfByte
import org.opencv.core.MatOfRect
import org.opencv.core.Rect
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc
import org.opencv.objdetect.CascadeClassifier
import org.opencv.objdetect.Objdetect
import java.awt.Image
import java.io.ByteArrayInputStream

class FaceDetection {
	def static Mat loadImage(String imagePath) {
		var Imgcodecs imageCodecs = new Imgcodecs()
		return Imgcodecs.imread(imagePath)
	}    

	def static void saveImage(Mat imageMatrix, String targetPath) {
		var Imgcodecs imgcodecs = new Imgcodecs()
		Imgcodecs.imwrite(targetPath, imageMatrix)
	} 

	def static Rect detectFace(String sourceImagePath) {
		var Mat loadedImage = loadImage(sourceImagePath)
		var MatOfRect facesDetected = new MatOfRect()
		var CascadeClassifier cascadeClassifier = new CascadeClassifier()
		var int minFaceSize = Math.round(loadedImage.rows() * 0.1f)
		cascadeClassifier.load("./src/main/java/fr/istic/trombistic/haar_face_detect.xml")
		cascadeClassifier.detectMultiScale(loadedImage, facesDetected, 1.1, 3, Objdetect.CASCADE_SCALE_IMAGE,
			new Size(minFaceSize, minFaceSize), new Size())
		facesDetected.toArray().head
	}
}
