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

class PhotoPanel extends JPanel {

	static final String DEFAULT_PHOTO = "./src/main/java/fr/istic/trombistic/aucun.png"
	PhotoLabel photo
	JButton shootButton
	JButton assignButton

	TrombisticControl ctrl

	TitledBorder paneBorder

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
		
		setBorder(paneBorder)
		layout = new FlowLayout(FlowLayout::CENTER)
		val photoPanel = new JPanel();
		photo= new PhotoLabel(300,500)
		photoPanel.add(photo)
		add(photoPanel)
		
		add(photo)
		shootButton = new JButton("Shoot picture")
		assignButton = new JButton("Import picture")
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
		if ((new File(string).exists())) {
			photo.image = string
		} else {
			photo.image = DEFAULT_PHOTO
		}
	}

}
