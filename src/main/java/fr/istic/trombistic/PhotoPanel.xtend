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

class PhotoPanel extends JPanel {
	
	PhotoLabel photo
	JButton shootButton
	
	TrombisticControl ctrl
	
	def disableShootButton() {
		shootButton.visible = false
	}
	
	def enableShootButton() {
		shootButton.visible=true
	}

	new(TrombisticControl ctrl) {
		super()
		setSize(400,400)
		setBorder(BorderFactory::createTitledBorder("Photo"))
		layout = new FlowLayout(FlowLayout::CENTER)
		photo = new PhotoLabel()
		//photo.image = "./src/main/java/fr/istic/trombistic/aucun.png"
		add(photo)
		shootButton = new JButton("Shoot picture")
		add(shootButton)
		disableShootButton
		this.ctrl=ctrl
		ctrl.setPhotoPanel(this)
		
		shootButton.addActionListener([ ActionEvent e | ctrl.shootPicture])
	}
	
	def getPhotoLabel() {
		photo
	}
	
	def setImage(String string) {
		photo.image = string
	}
	
	
}