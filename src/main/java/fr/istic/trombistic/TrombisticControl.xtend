package fr.istic.trombistic

import com.github.sarxos.webcam.Webcam
import java.io.File
import javax.swing.JTable
import java.text.Normalizer
import javax.swing.JOptionPane
import java.awt.image.BufferedImage
import javax.imageio.ImageIO
import java.io.IOException
import javax.swing.JFileChooser
import com.github.sarxos.webcam.WebcamResolution

class TrombisticControl {
	TrombisticFrame mainFrame
	Webcam webcam
	File photoPath
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
		photoPath = new File("./")
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
		val photoFileNane = photoPath.absolutePath + File.separator + buildPhotoName()
		photoPanel.setImage(photoFileNane)
		mainFrame.repaint
	}

	def shootPicture() {
		photoPath.mkdirs()
		if (selectedRow < 0) {
			JOptionPane::showMessageDialog(mainFrame, '''Please select an row first'''.toString)
			return
		}
		val photoFileNane = photoPath + File.separator + buildPhotoName()
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

	def String buildPhotoName() {

		return ('''«removeAccent((model.getStringAt(sheetId,selectedRow, 0)))»_«removeAccent((model.getStringAt(sheetId,selectedRow, 1)))».png'''.
			toString).replace("'", "-")
	}

	def exportHTML() {

		var JFileChooser fileChooser = new JFileChooser("./")
		fileChooser.setName("Select Output folder)")
		fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
		var int result = fileChooser.showOpenDialog(mainFrame)
		if (result === JFileChooser::APPROVE_OPTION) {
			var PrettyPrint pp = new PrettyPrint()
			val outFolder = fileChooser.getSelectedFile()
			pp.generate(outFolder, model, sheetId, 3)
		}
	}

	def loadExcel() {
		var JFileChooser fileChooser = new JFileChooser("./")
		fileChooser.setName("Select Excel file (.xls)")
		val excel97Filter = new FileTypeFilter(".xls", "Excel 97 files ");
		fileChooser.addChoosableFileFilter(excel97Filter);
		var int result = fileChooser.showOpenDialog(mainFrame)
		// if (result === JFileChooser::APPROVE_OPTION) {
		excelFile = fileChooser.getSelectedFile()
		if (excelFile !== null) {
			model = new ExcelModel(excelFile)
			excelView.updateTable(model, sheetId);
			mainFrame.repaint
		}
		mainFrame.repaint
	}

	def reloadExcel() {
		if (excelFile !== null) {
			model = new ExcelModel(excelFile)
			excelView.updateTable(model, sheetId);
			mainFrame.repaint
		} else {
			JOptionPane::showMessageDialog(mainFrame, '''Please opne excel file first''')
		}
	}

	def setPhotoPanel(PhotoPanel label) {
		photoPanel = label
	}

	def setExcelViewPanel(ExcelViewPanel label) {
		this.excelView = label
	}

	def importPicture() {
		photoPath.mkdirs()
		if (selectedRow < 0) {
			JOptionPane::showMessageDialog(mainFrame, '''Please select an row first'''.toString)
			return
		}
		val photoFileNane = photoPath + File.separator + buildPhotoName()
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
		var int result = fileChooser.showOpenDialog(mainFrame)
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
