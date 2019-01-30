package trombinoscope.v2;
import javax.swing.*;

import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

import trombinoscope.v2.ExcelModel;

import java.awt.*;
import java.io.File;
import java.text.Normalizer;
 
public class ExcelTableViewer extends JPanel {
   
	
  
	private boolean DEBUG = false;

    public ExcelTableViewer(File file) {
    	this(file,0);
    }
    
    JTable table ;
	private JScrollPane scrollPane;
	ListSelectionListener listener;
    
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
    
    
    public void addListSelectionListener(ListSelectionListener listener)
    {
    	this.listener= listener;
    	table.getSelectionModel().addListSelectionListener(listener);
    }
    
    public void updateTable(File file, int sheetId) {
        ExcelModel model = new ExcelModel(file);
        int nbRows = model.getNumberOfUsefulRows(sheetId);
		int nbCols = model.getNumberOfUsefulColumns(sheetId);
		String[][] donnees = new String[nbRows][nbCols];
        String[] entete = new String[nbCols];

        System.out.println(nbCols+"X"+nbRows);
        for (int col = 0; col < nbCols; col++) {
        	entete[col] = model.getStringAt(sheetId, 0, col);
		}
        for (int row = 1; row < nbRows; row++) {
            for (int col = 0; col < nbCols; col++) {
            	donnees[row-1][col] = model.getStringAt(sheetId, row, col);
    		}
 		}
        
        StudentTableModel tableModel = new StudentTableModel(donnees, entete);
        table.setModel(tableModel);
        table.repaint();
     }
    
    public ExcelTableViewer(File file, int sheetId) {
        super(new GridLayout(1,0));

        table = new JTable();
        table.setModel(new DefaultTableModel());
        table.setPreferredScrollableViewportSize(new Dimension(500, 300));
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        Color light_blue = new Color (205, 235, 255);
        table.getTableHeader().setBackground( light_blue );
        table.getSelectionModel().addListSelectionListener(listener);
        scrollPane = new JScrollPane(table);
        scrollPane.setBackground(light_blue);
        scrollPane.getViewport().setBackground(light_blue);
        add(scrollPane);

        updateTable(file, sheetId);
       
    }
 
    

}