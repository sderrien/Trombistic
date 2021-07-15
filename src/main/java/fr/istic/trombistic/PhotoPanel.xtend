package fr.istic.trombistic

import javax.swing.JPanel
import java.awt.FlowLayout
import javax.swing.BorderFactory
import java.awt.Dimension
import java.awt.image.BufferedImage
import javax.swing.JLayer
import javax.swing.JLabel
import javax.swing.JButton
import java.awt.event.ActionEvent
import javax.swing.BoxLayout
import javax.swing.border.TitledBorder
import java.io.File
import javax.swing.JOptionPane

class PhotoPanel extends JPanel {

	PhotoLabel photo
	JButton shootButton
	JButton assignButton

	TrombisticControl ctrl

	TitledBorder paneBorder

	def disableShootButton() {
		shootButton.visible = false
	}

	def enableShootButton() {
		shootButton.visible = true
	}

	new(TrombisticControl ctrl) {
		super()
		setSize(400, 400)
		paneBorder = BorderFactory::createTitledBorder("Photo")
		setBorder(paneBorder)
		layout = new FlowLayout(FlowLayout::CENTER)
		photo = new PhotoLabel()
		add(photo)
		shootButton = new JButton("Shoot picture")
		assignButton = new JButton("Import picture")
		add(shootButton)
		add(assignButton)
		disableShootButton
		this.ctrl = ctrl
		ctrl.setPhotoPanel(this)

		shootButton.addActionListener([ActionEvent e|ctrl.shootPicture])
		assignButton.addActionListener([ActionEvent e|ctrl.importPicture])
	}

	def getPhotoLabel() {
		photo
	}

	def setImage(String string) {
		if ((new File(string).exists())) {
			paneBorder.title = string
			photo.image = string
		} else {
			photo.image = "./src/main/java/fr/istic/trombistic/aucun.png"
		}

	}

}
