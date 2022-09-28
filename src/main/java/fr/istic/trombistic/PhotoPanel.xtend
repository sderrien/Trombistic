package fr.istic.trombistic

import java.awt.Dimension
import java.awt.FlowLayout
import java.awt.Graphics
import java.awt.event.ActionEvent
import java.awt.image.BufferedImage
import java.io.File
import javax.swing.BorderFactory
import javax.swing.BoxLayout
import javax.swing.ImageIcon
import javax.swing.JButton
import javax.swing.JLabel
import javax.swing.JLayer
import javax.swing.JOptionPane
import javax.swing.JPanel
import javax.swing.border.TitledBorder
import java.awt.Color
import java.awt.Image
import javax.swing.JSlider
import java.awt.Component
import javax.swing.event.ChangeListener
import javax.swing.event.ChangeEvent

class PhotoPanel extends JPanel {

	static final String DEFAULT_PHOTO = "./src/main/java/fr/istic/trombistic/aucun.png"
	PhotoLabel photo
	JButton shootButton
	JButton assignButton

	TrombisticControl ctrl

	TitledBorder paneBorder
	
	JSlider marginSlider
	JSlider scaleSlider

	def disableShootButton() {
		shootButton.enabled=false 
	}

	def enableShootButton() {
		shootButton.enabled= true
	}

	new(TrombisticControl ctrl) {
		super()
		setSize(500, 700)
		paneBorder = BorderFactory::createTitledBorder("Photo")
		setAlignmentX(Component.CENTER_ALIGNMENT)
		setBorder(paneBorder)
		layout = new BoxLayout(this,BoxLayout.Y_AXIS)
		val photoPanel = new JPanel();
		photoPanel.setAlignmentX(Component.CENTER_ALIGNMENT) 
		photoPanel.layout = new BoxLayout(photoPanel,BoxLayout.Y_AXIS)

		photo= new PhotoLabel(320,200)

		marginSlider = new JSlider(0,100)
		marginSlider.preferredSize = new Dimension(300,40)
		marginSlider.addChangeListener(new ChangeListener {
			override void stateChanged(ChangeEvent e) {
			    val source = e.getSource() as JSlider
				    if (!source.getValueIsAdjusting()) {
				        val offset = source.getValue();
				        photo.setOffset(offset)
				    }
			    }
		    }
		);
		photoPanel.add(marginSlider)

		scaleSlider = new JSlider(0,100)
		scaleSlider.preferredSize = new Dimension(300,40)
		scaleSlider.addChangeListener(new ChangeListener {
			override void stateChanged(ChangeEvent e) {
			    val source = e.getSource() as JSlider
				    if (!source.getValueIsAdjusting()) {
				        val scale = source.getValue();
				        photo.setScale(scale)
				    }
			    }
		    }
		);
		//photoPanel.add(scaleSlider)

		photoPanel.add(photo)
		add(photoPanel) 
		
		add(photo)
		shootButton = new JButton("Prendre une photo")
		assignButton = new JButton("Importer un fichier image")
		add(shootButton)
		add(assignButton)
		disableShootButton
		this.ctrl = ctrl
		ctrl.setPhotoPanel(this)
		image="undefined"
		shootButton.addActionListener([ActionEvent e|ctrl.shootPicture])
		assignButton.addActionListener([ActionEvent e|ctrl.importPicture])
	}

	def getPhotoLabel() {
		photo
	}

	def setImage(String string) {
		paneBorder.title = string
		photo.image = string
	}

}
