package fr.istic.trombistic

import java.awt.EventQueue
import java.awt.event.KeyEvent
import javax.swing.ImageIcon
import javax.swing.JFrame
import javax.swing.JMenu
import javax.swing.JMenuBar
import javax.swing.JMenuItem
import com.github.sarxos.webcam.Webcam
import javax.swing.JRadioButtonMenuItem
import javax.swing.ButtonGroup
import javax.swing.BoxLayout
import java.util.ArrayList
import java.awt.event.ActionListener
import java.awt.event.ActionEvent
import javax.swing.JLabel
import javax.swing.JOptionPane
import javax.swing.JFileChooser
import java.util.prefs.Preferences
import java.io.File

class TrombisticMain extends JFrame {

	ArrayList<JRadioButtonMenuItem> webCamButtonItems

	TrombisticControl ctrl
	TrombisticPanel mainPanel

	new() {
		ctrl = new TrombisticControl(this)
		initUI()
		createMenuBar
		
	}

	new(String excelfile) {
		this()
		ctrl.loadExcel(new File(excelfile))
	}

	def private void initUI() {
		setLocationRelativeTo(null)
		setDefaultCloseOperation(EXIT_ON_CLOSE)
		title = ("Trombinoscope ISTIC")
		setLayout(new BoxLayout(contentPane, BoxLayout::Y_AXIS))
		setSize(1000, 800)
	}

	def private void createMenuBar() {

    // Retrieve the user's preference node for this package
    	val prefs = Preferences.userNodeForPackage(this.class);

		var menuBar = new JMenuBar()

		var fileMenu = new JMenu("Fichier")
		fileMenu.setMnemonic(KeyEvent::VK_F)

		var loadMenuItem = new JMenuItem("Charger une liste d'étudiants (excel)")
		loadMenuItem.setMnemonic(KeyEvent::VK_F2)
		fileMenu.add(loadMenuItem)
		loadMenuItem.addActionListener([ActionEvent e|ctrl.loadExcelCommand] as ActionListener)

		var reloadMenuItem = new JMenuItem("Rafraîchir la liste")
		reloadMenuItem.setMnemonic(KeyEvent::VK_F5)
		fileMenu.add(reloadMenuItem)
		reloadMenuItem.addActionListener([ActionEvent e|ctrl.reloadExcel] as ActionListener)

		var saveHTMLItem = new JMenuItem("Exporter le trombinoscope au format HTML")
		saveHTMLItem.addActionListener(null)
		saveHTMLItem.addActionListener([ActionEvent e|ctrl.exportHTML] as ActionListener)
		fileMenu.add(saveHTMLItem)

		var exitMenuItem = new JMenuItem("Quitter")
		exitMenuItem.addActionListener([ ActionEvent e |
			val res = JOptionPane.showConfirmDialog(null, "Êtes-vous sûr ?", "alert", JOptionPane.OK_CANCEL_OPTION);
			if (res == JFileChooser.APPROVE_OPTION) {
				System.exit(0)
			}
		] as ActionListener)
		fileMenu.add(exitMenuItem)

		var optionsMenu = new JMenu("Options")
		fileMenu.setMnemonic(KeyEvent::VK_W)

		val webcams = Webcam.getWebcams()
		if (webcams.empty) {
			JOptionPane.showMessageDialog(null, "Pas de webcam trouvé sur cette machine, vérifier la connection USB", "alert", JOptionPane.OK_OPTION);
			//System.exit(-1)
		}
		val webcamMenu = new JMenu("Sélectionner la webcam à utiliser ");
		optionsMenu.setMnemonic(KeyEvent.VK_O);
		optionsMenu.add(webcamMenu);

		val webcamGroup = new ButtonGroup();

		var first = true
		webCamButtonItems = new ArrayList<JRadioButtonMenuItem>()
		for (w : webcams) {
			val JRadioButtonMenuItem webcamMenuItem = new JRadioButtonMenuItem("Webcam " + w.name, first);
			webcamMenuItem.addActionListener(
				[ActionEvent e|ctrl.webCam = webCamButtonItems.indexOf(webcamMenuItem)] as ActionListener)
			webCamButtonItems += webcamMenuItem
			first = false
			webcamMenu.add(webcamMenuItem);
			webcamGroup.add(webcamMenuItem);
		}

		var helpMenu = new JMenu("Aide")
		helpMenu.setMnemonic(KeyEvent::VK_H)

		var aboutItem = new JMenuItem("About" )
		aboutItem.setMnemonic(KeyEvent::VK_E)
		aboutItem.setToolTipText("A propos de Trombistic")
		aboutItem.addActionListener([ ActionEvent e |
					//val lbl = new JLabel(ctrl.loadInternalImage("trombistic.png"));
	
			val lbl = new JLabel(new ImageIcon("src"+File.separator+"main"+File.separator+"java"+File.separator+"fr"+File.separator+"istic"+File.separator+"trombistic"+File.separator+"trombistic.png"));
			JOptionPane.showMessageDialog(null, lbl, "À propos de Trombistic", JOptionPane.PLAIN_MESSAGE, null);
		] as ActionListener)

		helpMenu.add(aboutItem)

		menuBar.add(fileMenu)
		menuBar.add(optionsMenu)
		menuBar.add(helpMenu)
		setJMenuBar(menuBar)
		mainPanel = new TrombisticPanel(ctrl)
		add(mainPanel)
		pack()

		setVisible(true);
	}

	def static void main(String[] args) {
		if (args.size==0)
		new TrombisticMain()
		else
		new TrombisticMain(args.head)

	}
}
