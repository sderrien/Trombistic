package fr.istic.trombistic

import javax.swing.JPanel
import javax.swing.BoxLayout
import java.awt.FlowLayout
import javax.swing.event.ListSelectionEvent
import javax.swing.event.ListSelectionListener

class TrombisticPanel extends JPanel {

	JPanel topPane
	JPanel bottomPane

	new(TrombisticControl ctrl) {
		super(new FlowLayout(FlowLayout::CENTER))
		setSize(1000, 800)
		//setLayout(new BoxLayout(this, BoxLayout::Y_AXIS))
		topPane = new JPanel()
		add(topPane)
		bottomPane = new JPanel()
		add(bottomPane)
		val excelView = new ExcelViewPanel(ctrl)
		topPane.add(excelView)
		topPane.add(new PhotoPanel(ctrl))
		excelView.addListSelectionListener(([ ListSelectionEvent e |
			try {
				ctrl.student = (excelView.selectedRow)
			} catch (Exception e1) {
			}
		] as ListSelectionListener))

	}

}
