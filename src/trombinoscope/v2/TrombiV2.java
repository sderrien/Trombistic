package trombinoscope.v2;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.Normalizer;

import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.DefaultListModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import org.apache.commons.io.FileUtils;

import com.github.sardine.Sardine;
import com.github.sardine.SardineFactory;
import com.github.sarxos.webcam.Webcam;
import com.github.sarxos.webcam.WebcamResolution;

public class TrombiV2 {

	private static String PHOTOS_PATH = "./html/photos/";
	private static String WEBDAV_URL = "https://partages-ldap.univ-rennes1.fr/files/partages/Enseignement/ISTIC/M1/Listes/";
	protected static final int SHEETID = 0;
	
	static File file ;
	private static void createAndShowGUI(String filename) {
		JFrame frame = new JFrame("Trombinoscope ISTIC");
		frame.setSize(1000, 1000);
		//frame.setResizable(false);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		frame.setLayout(new BoxLayout(frame,BoxLayout.Y_AXIS));
		
		JPanel contentPane = new JPanel();
		contentPane.setLayout(new BoxLayout(contentPane,BoxLayout.Y_AXIS));
		
		frame.setContentPane(contentPane);
		
		JPanel topPane = new JPanel(new FlowLayout(FlowLayout.CENTER));
		contentPane.add(topPane);
		JPanel bottomPane = new JPanel(new FlowLayout(FlowLayout.CENTER));
		
		contentPane.add(bottomPane);
		if(filename==null) {
			JFileChooser fileChooser = new JFileChooser();
			fileChooser.setName("Select Excel file (.xls)");
			int result = fileChooser.showOpenDialog(contentPane);
			if (result == JFileChooser.APPROVE_OPTION) {
				file = fileChooser.getSelectedFile();
			} 
		} else {
			file = new File(filename);
		}
		ExcelTableViewer tableViewer = new ExcelTableViewer(file);
		topPane.add(tableViewer);
		JPanel rightPanel= new JPanel(new FlowLayout());
		rightPanel.setBorder(BorderFactory.createTitledBorder("Photo étudiant"));
		PhotoLabel photo = new PhotoLabel();
		rightPanel.add(photo);
		topPane.add(rightPanel);
		photo.setImage("");
		JButton b0= new JButton("Take\npicture");
		bottomPane.add(b0);
//		JButton b1= new JButton("Export excel");
//		bottomPane.add(b1);
		JButton b2= new JButton("Reload\n"+file.getAbsolutePath());
		bottomPane.add(b2);
		JButton b3= new JButton("Generate\n HTML");
		bottomPane.add(b3);

		JButton b4= new JButton("Choose dir");
		bottomPane.add(b4);
		JTextField label = new JTextField(PHOTOS_PATH);
		bottomPane.add(label);
		label.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				PHOTOS_PATH = label.getText();
			}
		}
		);
//		JButton b5= new JButton("Upload (Webdav)");
//		bottomPane.add(b5);
//		JTextField url = new JTextField(WEBDAV_URL);
//		bottomPane.add(url);
//		label.addActionListener(new ActionListener() {
//			@Override
//			public void actionPerformed(ActionEvent e) {
//				WEBDAV_URL = label.getText();
//			}
//		}
//		);
//
//		b5.addActionListener(new ActionListener() {
//			
//
//			@Override
//			public void actionPerformed(ActionEvent e) {
//				
//				
//				    JPanel panel = new JPanel(new BorderLayout(5, 5));
//
//				    JPanel label = new JPanel(new GridLayout(0, 1, 2, 2));
//				    label.add(new JLabel("login", SwingConstants.RIGHT));
//				    label.add(new JLabel("Password", SwingConstants.RIGHT));
//				    panel.add(label, BorderLayout.WEST);
//
//				    JPanel controls = new JPanel(new GridLayout(0, 1, 2, 2));
//				    JTextField username = new JTextField();
//				    controls.add(username);
//				    JPasswordField password = new JPasswordField();
//				    controls.add(password);
//				    panel.add(controls, BorderLayout.CENTER);
//
//				    int res = JOptionPane.showConfirmDialog(
//				            frame, panel, "login", JOptionPane.OK_CANCEL_OPTION);
//				    if (res==JOptionPane.OK_OPTION) {
//				    	
//				    	Sardine sardine = SardineFactory.begin(username.getText(), password.getText());
//				    	//byte[] data = FileUtils.readFileToByteArray(new File("/Users/sderrien/Documents/workspace-mars/trombinoscope/src/trombinoscope/WebDav.java"));
//				    	
//				    	
//				    	//sardine.put("https://share-ens.istic.univ-rennes1.fr/2017-2018/l3info/PFO/WebDav.java", data);    
//				    	//sardine.put("https://partages-ldap.univ-rennes1.fr/files/partages/Enseignement/ISTIC/M1/Listes/WebDav.java", data);    
//				    	
//				    }
//				    
//				   
//				}			
//		});

		b2.addActionListener(new ActionListener() {
			

			@Override
			public void actionPerformed(ActionEvent e) {
				try {
					tableViewer.updateTable(file,SHEETID);
					frame.repaint();
				} catch (Exception ex) {
					JOptionPane.showMessageDialog(contentPane, "Error while reading file "+file.getAbsolutePath()+"\n"+ex.getMessage(), "Error",
					        JOptionPane.ERROR_MESSAGE);
				}
//				JFileChooser fileChooser = new JFileChooser();
//				fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
//				int result = fileChooser.showOpenDialog(b2);
//				if (result == JFileChooser.APPROVE_OPTION) {
//					file = fileChooser.getSelectedFile();
//					System.out.println("Selected file: " + file.getAbsolutePath());
//					if (file.exists()) {
//					}
//					frame.repaint();
//				
//				} 
			}
		});
		
		b4.addActionListener(new ActionListener() {
			

			@Override
			public void actionPerformed(ActionEvent e) {
				JFileChooser fileChooser = new JFileChooser();
				fileChooser.setCurrentDirectory(new File(System.getProperty("user.home")));
				fileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				int result = fileChooser.showOpenDialog(b4);
				if (result == JFileChooser.APPROVE_OPTION) {
					File folder = fileChooser.getSelectedFile();
					System.out.println("Selected folder: " + folder.getAbsolutePath());
					if (folder.exists() && folder.isDirectory()) {
						PHOTOS_PATH= folder.getAbsolutePath()+File.separator;
						label.setText(PHOTOS_PATH);
					}
					frame.repaint();
				
				} 
			}
		});

		b3.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				PrettyPrint pp = new PrettyPrint(); 
				pp.generate(file, SHEETID, 2);
			}
		});

		b0.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				String argx = null;
				try {
					argx = PHOTOS_PATH + buildPhotoName(tableViewer); 
					if (new File(argx).exists()) {
						JOptionPane.showConfirmDialog(photo, "File " + argx + " will be overwritten, proceed ?");
					}
					Webcam webcam = Webcam.getDefault();
					if (webcam!=null) {
						if (!webcam.isOpen()) {
							webcam.setViewSize(WebcamResolution.VGA.getSize());
							webcam.open();
						}
						BufferedImage image = webcam.getImage();
						try {
							ImageIO.write(image, "PNG", new File(argx));
							System.out.format("File %s has been saved\n", argx);
							photo.setImage(argx);
							frame.repaint();
						} catch (IOException e2) {
							JOptionPane.showMessageDialog(photo, "Could not save file "+argx);
						}
					} else {
						JOptionPane.showMessageDialog(photo, "No webcam available");
					}
				} catch (Exception e1) {
					JOptionPane.showMessageDialog(photo, "No name selected "+e1.getMessage());
					e1.printStackTrace();
				}

			}
		});

		tableViewer.addListSelectionListener(new ListSelectionListener() {
			@Override
			public void valueChanged(ListSelectionEvent e) {

				try {
					String photoFileName = PHOTOS_PATH + buildPhotoName(tableViewer);
					photo.setImage(photoFileName);
					System.out.println("photo  file  " + photoFileName);
				} catch (Exception e1) {
					
				}

			}
		});
		frame.pack();
		frame.setVisible(true);
	}

	public static void main(String[] args) {
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				if (args.length==0)
					createAndShowGUI(null);
				else
					createAndShowGUI(args[0]);
			}
		});
	}

	public static String removeAccent(String source) {
		String src = source.replace(" ", "-");
		return Normalizer.normalize(src, Normalizer.Form.NFD).replaceAll("[\u0300-\u036F]", "");
	}

	public static String buildPhotoName(ExcelTableViewer tableViewer) {
		
		int row = tableViewer.getSelectedRow();
			return (removeAccent((String) tableViewer.getCellAt(row, 0)) + "_" + removeAccent((String) tableViewer.getCellAt(row, 1)) + ".png").replace("'", "-");
	}

}
