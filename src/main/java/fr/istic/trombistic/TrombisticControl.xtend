package fr.istic.trombistic

import com.github.sarxos.webcam.Webcam
import java.io.File 
import java.text.Normalizer
import javax.swing.JOptionPane
import java.awt.image.BufferedImage
import javax.imageio.ImageIO
import java.io.IOException
import javax.swing.JFileChooser
import com.github.sarxos.webcam.WebcamResolution
import java.nio.file.Paths
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.StandardCopyOption

class TrombisticControl {
	TrombisticFrame mainFrame
	Webcam webcam
	File workingPath
	File excelFile;
	int sheetId;
	ExcelModel model;
	int selectedRow = -1;

	PhotoPanel photoPanel
	ExcelViewPanel excelView

	new(TrombisticFrame mainFrame) {
		this.mainFrame = mainFrame
		sheetId = 0
		excelFile = null
		workingPath = new File("./")
	}

	def setWebCam(int id) {
		photoPanel.disableShootButton
		if (id >= 0) {
			webcam = Webcam.webcams.get(id)
			webcam.setViewSize(WebcamResolution::VGA.getSize())
			webcam.open()
			if (webcam !== null) {
				photoPanel.enableShootButton
			}
		}
	}

	def setStudent(int i) {
		selectedRow = i + 1
		val photoFileNane = buildSelectedPhotoFilePath()
		photoPanel.setImage(photoFileNane)
		mainFrame.repaint
	}

	def shootPicture() {
		if (!workingPath.exists) {
			workingPath.mkdirs()
		}
		if (selectedRow < 0) {
			JOptionPane::showMessageDialog(mainFrame, '''Please select an row first'''.toString)
			return
		}
		val photoFileNane = buildSelectedPhotoFilePath()
		if (new File(photoFileNane).exists()) {
			JOptionPane::showConfirmDialog(mainFrame,
				'''File «photoFileNane» will be overwritten, proceed ?'''.toString)
		}
		if (webcam !== null && webcam.isOpen()) {
			var BufferedImage image = webcam.getImage()
			mainFrame.repaint()
			try {
				ImageIO::write(image, "PNG", new File(photoFileNane))
				System::err.format("File %s has been saved\n", photoFileNane)
			} catch (IOException e2) {
				JOptionPane::showMessageDialog(mainFrame, '''Could not save file «photoFileNane»'''.toString)
			}
			photoPanel.setImage(photoFileNane)
		} else {
			JOptionPane::showMessageDialog(mainFrame, "No webcam available")
		}
	}

	def static String removeAccent(String source) {
		var String src = source.replace(" ", "-")
		return Normalizer::normalize(src, Normalizer::Form::NFD).replaceAll("[̀-ͯ]", "")
	}

	def String buildSelectedPhotoFilePath() {
		return workingPath + File.separator + "photos"+ File.separator  + buildPhotoFileName(model.getStringAt(sheetId,selectedRow, 0),model.getStringAt(sheetId,selectedRow, 1))
	}

	def String buildPhotoFileName(String firstName, String secondName) {
		return ('''«removeAccent(firstName)»_«removeAccent(secondName)».png'''.
			toString).replace("'", "-")
	}

	
	def exportHTML() {
		var PrettyPrint pp = new PrettyPrint()
		val outFolder = new File(workingPath.absolutePath+File.separator+"html")
		if (!outFolder.exists) {
			outFolder.mkdirs()
		}
		val photoFolder = new File( outFolder.absolutePath + File.separator + "photos")
		if (!photoFolder.exists) {
			photoFolder.mkdirs()
		}
		println("Found "+model.getNumberOfUsefulRows(0)+" useful rows")
		for (i:0..<model.getNumberOfUsefulRows(0)) {
			val srcImage = workingPath + File.separator  + "photos"+ File.separator + buildPhotoFileName(model.getFirstName(i),model.getSecondName(i))
			if (new File(srcImage).exists) {
				val dstImage = photoFolder.absolutePath + File.separator + buildPhotoFileName(model.getFirstName(i),model.getSecondName(i))
				val Path original = Paths.get(srcImage);
    			val Path copy = Paths.get(dstImage);
    			Files.copy(original, copy, StandardCopyOption.REPLACE_EXISTING);
			}
		}
		pp.generate(outFolder, model, sheetId, 3)
		JOptionPane::showMessageDialog(mainFrame, '''Export successful.''')
		
	}

	def loadExcelCommand() {
		var JFileChooser fileChooser = new JFileChooser("./")
		fileChooser.setName("Select Excel 97 file (.xls)")
		val excel97Filter = new FileTypeFilter(".xls", "Excel 97 files ");
		fileChooser.addChoosableFileFilter(excel97Filter);
		fileChooser.showOpenDialog(mainFrame)
		excelFile = fileChooser.getSelectedFile()
		loadExcel(excelFile)
		mainFrame.repaint
	}

	def loadExcel(File excelFile) {
		if (excelFile !== null && excelFile.exists) {
			model = new ExcelModel(excelFile)
			excelView.updateTable(model, sheetId);
			workingPath = new File(excelFile.absolutePath).parentFile
			mainFrame.repaint
		} 
	}

	def reloadExcel() {
		if (excelFile !== null) {
			model = new ExcelModel(excelFile)
			excelView.updateTable(model, sheetId);
			mainFrame.repaint
		} else {
			JOptionPane::showMessageDialog(mainFrame, '''Please select an Excel file first''')
		}
	}

	def setPhotoPanel(PhotoPanel label) {
		photoPanel = label
	}
	
	def setExcelViewPanel(ExcelViewPanel label) {
		this.excelView = label
	}

	def importPicture() {
		if (!workingPath.exists) {
			workingPath.mkdirs()
		}
		if (selectedRow < 0) {
			JOptionPane::showMessageDialog(mainFrame, '''Please select an row first'''.toString)
			return
		}
		val photoFileNane = buildSelectedPhotoFilePath()
		if (new File(photoFileNane).exists()) {
			JOptionPane::showConfirmDialog(mainFrame,
				'''File «photoFileNane» will be overwritten, proceed ?'''.toString)
		}
		var JFileChooser fileChooser = new JFileChooser("./")
		fileChooser.setName("Select picture file (jpg,png)")
		val pngFilter = new FileTypeFilter(".png,", "PNG file");
		val jpgFilter = new FileTypeFilter(".jpg,", "JPEG file");
		fileChooser.addChoosableFileFilter(pngFilter);
		fileChooser.addChoosableFileFilter(jpgFilter);
		 fileChooser.showOpenDialog(mainFrame)
		val inFile = fileChooser.getSelectedFile()
		if (inFile !== null) {
			try {
				val image = ImageIO::read(inFile)
				ImageIO::write(image, "PNG", new File(photoFileNane))
 				if ((new File(photoFileNane).exists())) { 
					photoPanel.setImage(photoFileNane)
 				} else {
					JOptionPane::showMessageDialog(mainFrame, '''Hmm something unexpected happened.''')
 				}
			} catch (IOException e2) {
				JOptionPane::showMessageDialog(mainFrame, '''Could not read/save file «photoFileNane»'''.toString)
			}
		}
		mainFrame.repaint
	}

}
