package fr.istic.trombistic

import com.github.sarxos.webcam.Webcam
import com.github.sarxos.webcam.WebcamResolution
import java.awt.Graphics2D
import java.awt.Image
import java.awt.Toolkit
import java.awt.image.BufferedImage
import java.io.File
import java.io.IOException
import java.io.PrintStream
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.StandardCopyOption
import java.text.Normalizer
import javax.imageio.ImageIO
import javax.swing.ImageIcon
import javax.swing.JFileChooser
import javax.swing.JOptionPane
import java.io.InputStream

class TrombisticControl {
	TrombisticMain mainFrame
	Webcam webcam
	File workingPath
	File excelFile;
	int sheetId;
	ExcelModel model;
	int selectedRow = -1;

	PhotoPanel photoPanel
	ExcelViewPanel excelView

	new(TrombisticMain mainFrame) {
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
			JOptionPane::showMessageDialog(mainFrame, "Pas de webcam connectée !")
		}
	}

	def static String removeAccent(String source) {
		var String src = source.replace(" ", "-")
		return Normalizer::normalize(src, Normalizer::Form::NFD).replaceAll("[̀-ͯ]", "")
	}

	def String buildSelectedPhotoFilePath() {
		return workingPath + File.separator + "photos" + File.separator +
			buildPhotoFileName(model.getStringAt(sheetId, selectedRow, 0), model.getStringAt(sheetId, selectedRow, 1))
	}

	def String buildPhotoFileName(String firstName, String secondName) {
		return ('''«removeAccent(firstName)»_«removeAccent(secondName)».png'''.toString).replace("'", "-")
	}

	def exportHTML() {
		var PrettyPrint pp = new PrettyPrint()
		var File photoFolder;
		var File outFolder;
		try {
			outFolder = new File(workingPath.absolutePath + File.separator + "html")
			if (!outFolder.exists) {
				outFolder.mkdirs()
			}
			photoFolder = new File(outFolder.absolutePath + File.separator + "photos")
			if (!photoFolder.exists) {
				photoFolder.mkdirs()
			}
		} catch (Exception e) {
			JOptionPane::showMessageDialog(mainFrame, '''
				Error (exception «e.toString») : could not open/create folder «workingPath.absolutePath + File.separator + "html" +File.separator + "photos"»  
				«e.message»
			''')
			return;
		}
		try {
			println("Found " + model.getNumberOfUsefulRows(0) + " useful rows")

			for (i : 0 ..< model.getNumberOfUsefulRows(0)) {
				val srcImage = workingPath + File.separator + "photos" + File.separator +
					buildPhotoFileName(model.getFirstName(i), model.getSecondName(i))
				if (new File(srcImage).exists) {
					val dstImage = photoFolder.absolutePath + File.separator +
						buildPhotoFileName(model.getFirstName(i), model.getSecondName(i))
					val Path original = Paths.get(srcImage);
					val Path copy = Paths.get(dstImage);
					try {
						Files.copy(original, copy, StandardCopyOption.REPLACE_EXISTING);
					} catch (Exception e) {
						dumpException(e)
						JOptionPane::
							showMessageDialog(mainFrame, '''Error «e.toString»\nCould not copy «original» to «copy».''')
						return
					}
				}
			}

			try {
				val name = "aucun.png";
				// val InputStream is = this.class.getResourceAsStream("images"+File.separator +name);
				// this is the path within the jar file
				var InputStream input = this.class.getResourceAsStream("/resources/" + name);
				if (input === null) {
					// this is how we load file within editor (eg eclipse)
					input = this.class.getClassLoader().getResourceAsStream(name);
				}

				if (input !== null) {
					copy(input, photoFolder.absolutePath + File.separator + name)

				}
			} catch (Exception e) {
				JOptionPane::showMessageDialog(mainFrame, '''Erreur dans la copie du fichier aucun.png.''')
				dumpException(e)
			}
			try {
				pp.generate(outFolder, model, sheetId, 3)
				JOptionPane::showMessageDialog(mainFrame, '''Sauvegarde du fichier HTML réussie.''')
			} catch (Exception e) {
				dumpException(e)
			}
		} catch (Exception e) {
			dumpException(e)
			JOptionPane::showMessageDialog(mainFrame, '''
				Error (execption «e.toString») during HTML export :
				«e.message»
			''')

		}

	}

	def dumpException(Exception e) {
		val ps = new PrintStream("trombistic_" + this.hashCode + ".log");
		ps.append('''Error «e.toString» : «e.message»''')
		for (elt : e.stackTrace) {
			ps.append(elt + "\n")
		}
		ps.close

	}

	def loadExcelCommand() {
		var JFileChooser fileChooser = new JFileChooser("./")
		fileChooser.setName("Select Excel file (.xls)")
		val excelFilter = new FileTypeFilter(".xls", "Excel files ");
		for (f : fileChooser.choosableFileFilters)
			fileChooser.removeChoosableFileFilter(f)
		fileChooser.addChoosableFileFilter(excelFilter);
		fileChooser.showOpenDialog(mainFrame)
		excelFile = fileChooser.getSelectedFile()
		loadExcel(excelFile)
		mainFrame.repaint
	}

	def loadExcel(File excelFile) {
		if (excelFile !== null && excelFile.exists) {
			model = new ExcelModel(excelFile)
			try {
				excelView.updateTable(model, sheetId);
			} catch (RuntimeException exception) {
				JOptionPane::showMessageDialog(mainFrame, '''Error «exception.message»'''.toString)
			}
			workingPath = new File(excelFile.absolutePath).parentFile
			val photoPath = new File(workingPath + File.separator + "photos")
			if (!photoPath.exists) {
				photoPath.mkdirs
			}
			mainFrame.repaint
		}
	}

	def public static boolean copy(InputStream source, String destination) {
		val boolean succeess = true;

		System.out.println("Copying ->" + source + "\n\tto ->" + destination);

		try {
			Files.copy(source, Paths.get(destination), StandardCopyOption.REPLACE_EXISTING);
		} catch (IOException ex) {
//            logger.log(Level.WARNING, "", ex);
//            succeess = false;
		}

		return succeess;

	}

	def reloadExcel() {
		if (excelFile !== null) {
			loadExcel(excelFile)
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
