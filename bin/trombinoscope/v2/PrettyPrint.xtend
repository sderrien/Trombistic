package trombinoscope.v2

import java.util.List
import java.io.PrintStream
import java.io.File
import java.util.ArrayList
import java.util.HashSet


class PrettyPrint {
	
	
	int nbcol=-1
	int nbrow=-1	
	var names = new ArrayList<String>();
	var photos = new ArrayList<String>();
	var set = new HashSet<String>;	
	
	def static void main(String[] args) {
		val pp= new PrettyPrint();
		pp.generate(new File(args.get(0)), 0,2);
	}
	
	
	new() {
		
	}  
	
	
	def generate(File file, int sheetId, int startCol) {
		val ssheet = new ExcelModel(file);
		nbcol=0
		while(ssheet.getStringAt(sheetId,1,nbcol)!=null) nbcol++
		nbrow=0
		while(ssheet.getStringAt(sheetId,nbrow,1)!=null) nbrow++
		for(row:0..nbrow-1) {
			val firstName= ssheet.getStringAt(sheetId,row,0)
			val secondName= ssheet.getStringAt(sheetId,row,1)
			names.add(
				firstName+" "+secondName
			);
			photos.add(ExcelModel.buildPhotoName(firstName,secondName));
		}
		for(col:startCol..nbcol-1) {
			val title = ssheet.getStringAt(sheetId,0,col);
			println("New Column  :"+title)
			var cnames = new ArrayList<String>()
			var cphotos = new ArrayList<String>()
			set.clear
			for(row:1..nbrow-1) {
				val key = ssheet.getStringAt(sheetId,row,col);
				if (!set.contains(key)) {
					set.add(key)
					println("\t-Adding key :"+key)	
				}
			}
			for(key:set) {
				cnames.clear
				cphotos.clear
				for(row:0..nbrow-1) {
					val ckey = ssheet.getStringAt(sheetId,row,col);
					if(ckey==null) {
						println('''null at cell («row»,«col»)''')
					}
					if (ckey==key) {
						cnames.add(names.get(row))
						cphotos.add(photos.get(row));
					}
				}
				println("saving "+key+".htm with "+cnames.size+" students")
				writeHTML("./html/"+key+".htm", title+" "+key, cnames,cphotos);
			}
		}
	}
 	def writeHTML(String filename, String title, List<String> studentNames, List<String> photoFilames) {
		
		val ps = new PrintStream(new File(filename)) ;
		ps.append(
		'''
		<html><head><title>«title»</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<body bgcolor="#FFFFFF" text="#000000">
		<h1 align="center">«title»</h1>
		<table align="center" border="1"><tr>
		</tr>
		<tr>''')
		for (i:0..studentNames.size-1) {
			if(i%4==0) ps.append("</tr><tr>")
			ps.append(
			'''
				<td width="150" height="270"> <p align="center"> 
					<object data="photos/«photoFilames.get(i)»" height="200">  
					<img src="photos/«photoFilames.get(i)»" height="200" onerror="this.onerror=null; this.src='photos/NoPhoto.jpg'" > 
					</object>
					</p>
					<p align="center"> «studentNames.get(i)» </p>
				</td>
			''');
		}
		ps.append(
		'''
		</tr>
		''')
	ps.close
	
	}
}