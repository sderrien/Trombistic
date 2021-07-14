package fr.istic.trombistic;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.io.File;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

public class ExcelViewPanel extends JPanel {

	private JScrollPane scrollPane;
	ListSelectionListener listener;
	JTable table;

	private TrombisticControl ctrl;
 
	public ExcelViewPanel(TrombisticControl ctrl) {
		super(new GridLayout(1, 0));
		table = new JTable();
		table.setModel(new DefaultTableModel());
		table.setPreferredScrollableViewportSize(new Dimension(500, 300));
		table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		Color light_blue = new Color(205, 235, 255);
		table.getTableHeader().setBackground(light_blue);
		scrollPane = new JScrollPane(table);
		scrollPane.setBackground(light_blue);
		scrollPane.getViewport().setBackground(light_blue);
		add(scrollPane);
		this.ctrl = ctrl;
		ctrl.setExcelViewPanel(this);
		
	}
	
	
	public Object getCellAt(int row, int col) {
		return table.getModel().getValueAt(row, col);
	}

	public Object getActiveCell() {
		return table.getModel().getValueAt(table.getSelectedRow(), table.getSelectedColumn());
	}

	public int getSelectedRow() {
		return table.getSelectedRow();
	}

	public int getSelectedColumns() {
		return table.getSelectedColumn();
	}

	public void addListSelectionListener(ListSelectionListener listener) {
		this.listener = listener;
		table.getSelectionModel().addListSelectionListener(listener);
	}  

	public void updateTable(ExcelModel model, int sheetId)  {
		int nbRows = model.getNumberOfUsefulRows(sheetId);
		int nbCols = model.getNumberOfUsefulColumns(sheetId);
		String[][] donnees = new String[nbRows][nbCols];
		String[] entete = new String[nbCols];

		System.out.println(nbCols + "X" + nbRows);
		for (int col = 0; col < nbCols; col++) {
			entete[col] = model.getStringAt(sheetId, 0, col);
		}
		for (int row = 1; row < nbRows; row++) {
			for (int col = 0; col < nbCols; col++) {
				donnees[row - 1][col] = model.getStringAt(sheetId, row, col);
			}
		}
		StudentTableModel tableModel = new StudentTableModel(donnees, entete);
		table.setModel(tableModel);
		table.repaint();
		this.repaint();
	}

}