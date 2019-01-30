package trombinoscope.v2;

import com.google.common.base.Objects;
import java.io.File;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.InputOutput;
import org.eclipse.xtext.xbase.lib.IntegerRange;
import trombinoscope.v2.ExcelModel;

@SuppressWarnings("all")
public class PrettyPrint {
  private int nbcol = (-1);
  
  private int nbrow = (-1);
  
  private ArrayList<String> names = new ArrayList<String>();
  
  private ArrayList<String> photos = new ArrayList<String>();
  
  private HashSet<String> set = new HashSet<String>();
  
  public static void main(final String[] args) {
    final PrettyPrint pp = new PrettyPrint();
    String _get = args[0];
    File _file = new File(_get);
    pp.generate(_file, 0, 2);
  }
  
  public PrettyPrint() {
  }
  
  public void generate(final File file, final int sheetId, final int startCol) {
    final ExcelModel ssheet = new ExcelModel(file);
    this.nbcol = 0;
    while ((!Objects.equal(ssheet.getStringAt(sheetId, 1, this.nbcol), null))) {
      this.nbcol++;
    }
    this.nbrow = 0;
    while ((!Objects.equal(ssheet.getStringAt(sheetId, this.nbrow, 1), null))) {
      this.nbrow++;
    }
    IntegerRange _upTo = new IntegerRange(0, (this.nbrow - 1));
    for (final Integer row : _upTo) {
      {
        final String firstName = ssheet.getStringAt(sheetId, (row).intValue(), 0);
        final String secondName = ssheet.getStringAt(sheetId, (row).intValue(), 1);
        this.names.add(
          ((firstName + " ") + secondName));
        this.photos.add(ExcelModel.buildPhotoName(firstName, secondName));
      }
    }
    IntegerRange _upTo_1 = new IntegerRange(startCol, (this.nbcol - 1));
    for (final Integer col : _upTo_1) {
      {
        final String title = ssheet.getStringAt(sheetId, 0, (col).intValue());
        InputOutput.<String>println(("New Column  :" + title));
        ArrayList<String> cnames = new ArrayList<String>();
        ArrayList<String> cphotos = new ArrayList<String>();
        this.set.clear();
        IntegerRange _upTo_2 = new IntegerRange(1, (this.nbrow - 1));
        for (final Integer row_1 : _upTo_2) {
          {
            final String key = ssheet.getStringAt(sheetId, (row_1).intValue(), (col).intValue());
            boolean _contains = this.set.contains(key);
            boolean _not = (!_contains);
            if (_not) {
              this.set.add(key);
              InputOutput.<String>println(("\t-Adding key :" + key));
            }
          }
        }
        for (final String key : this.set) {
          {
            cnames.clear();
            cphotos.clear();
            IntegerRange _upTo_3 = new IntegerRange(0, (this.nbrow - 1));
            for (final Integer row_2 : _upTo_3) {
              {
                final String ckey = ssheet.getStringAt(sheetId, (row_2).intValue(), (col).intValue());
                boolean _equals = Objects.equal(ckey, null);
                if (_equals) {
                  StringConcatenation _builder = new StringConcatenation();
                  _builder.append("null at cell (");
                  _builder.append(row_2);
                  _builder.append(",");
                  _builder.append(col);
                  _builder.append(")");
                  InputOutput.<String>println(_builder.toString());
                }
                boolean _equals_1 = Objects.equal(ckey, key);
                if (_equals_1) {
                  cnames.add(this.names.get((row_2).intValue()));
                  cphotos.add(this.photos.get((row_2).intValue()));
                }
              }
            }
            int _size = cnames.size();
            String _plus = ((("saving " + key) + ".htm with ") + Integer.valueOf(_size));
            String _plus_1 = (_plus + " students");
            InputOutput.<String>println(_plus_1);
            this.writeHTML((("./html/" + key) + ".htm"), ((title + " ") + key), cnames, cphotos);
          }
        }
      }
    }
  }
  
  public void writeHTML(final String filename, final String title, final List<String> studentNames, final List<String> photoFilames) {
    try {
      File _file = new File(filename);
      final PrintStream ps = new PrintStream(_file);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("<html><head><title>");
      _builder.append(title);
      _builder.append("</title>");
      _builder.newLineIfNotEmpty();
      _builder.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
      _builder.newLine();
      _builder.append("<body bgcolor=\"#FFFFFF\" text=\"#000000\">");
      _builder.newLine();
      _builder.append("<h1 align=\"center\">");
      _builder.append(title);
      _builder.append("</h1>");
      _builder.newLineIfNotEmpty();
      _builder.append("<table align=\"center\" border=\"1\"><tr>");
      _builder.newLine();
      _builder.append("</tr>");
      _builder.newLine();
      _builder.append("<tr>");
      ps.append(_builder);
      int _size = studentNames.size();
      int _minus = (_size - 1);
      IntegerRange _upTo = new IntegerRange(0, _minus);
      for (final Integer i : _upTo) {
        {
          if ((((i).intValue() % 4) == 0)) {
            ps.append("</tr><tr>");
          }
          StringConcatenation _builder_1 = new StringConcatenation();
          _builder_1.append("<td width=\"150\" height=\"270\"> <p align=\"center\"> ");
          _builder_1.newLine();
          _builder_1.append("\t");
          _builder_1.append("<object data=\"photos/");
          String _get = photoFilames.get((i).intValue());
          _builder_1.append(_get, "\t");
          _builder_1.append("\" height=\"200\">  ");
          _builder_1.newLineIfNotEmpty();
          _builder_1.append("\t");
          _builder_1.append("<img src=\"photos/");
          String _get_1 = photoFilames.get((i).intValue());
          _builder_1.append(_get_1, "\t");
          _builder_1.append("\" height=\"200\" onerror=\"this.onerror=null; this.src=\'photos/NoPhoto.jpg\'\" > ");
          _builder_1.newLineIfNotEmpty();
          _builder_1.append("\t");
          _builder_1.append("</object>");
          _builder_1.newLine();
          _builder_1.append("\t");
          _builder_1.append("</p>");
          _builder_1.newLine();
          _builder_1.append("\t");
          _builder_1.append("<p align=\"center\"> ");
          String _get_2 = studentNames.get((i).intValue());
          _builder_1.append(_get_2, "\t");
          _builder_1.append(" </p>");
          _builder_1.newLineIfNotEmpty();
          _builder_1.append("</td>");
          _builder_1.newLine();
          ps.append(_builder_1);
        }
      }
      StringConcatenation _builder_1 = new StringConcatenation();
      _builder_1.append("</tr>");
      _builder_1.newLine();
      ps.append(_builder_1);
      ps.close();
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}
