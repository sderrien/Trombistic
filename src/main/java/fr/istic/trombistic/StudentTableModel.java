package fr.istic.trombistic;

import javax.swing.table.AbstractTableModel;

public class StudentTableModel extends AbstractTableModel {
	Object donnees[][];
	String titres[];

	public StudentTableModel(Object donnees[][], String titres[]) {
		this.donnees = donnees;
		this.titres = titres;
	}

	public int getColumnCount() {
		return donnees[0].length;
	}

	public Object getValueAt(int parm1, int parm2) {
		return donnees[parm1][parm2];
	}

	public int getRowCount() {
		return donnees.length;
	}

	public String getColumnName(int col) {
		return titres[col];
	}
}