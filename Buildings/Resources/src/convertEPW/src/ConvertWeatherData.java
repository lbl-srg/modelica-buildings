import java.util.Scanner;
import java.util.ArrayList;
import java.io.*;
import java.util.Arrays;
/** This program converts a weather file
  * from .epw format for EnergyPlus
  * to .mos format for Modelica.<p>
  *
  * To convert weather data, run this program as
  * <pre>
      java -jar ConvertWeatherData.jar inputFile.epw
    </pre>
  * where <code>inputFile</code> is an EnergyPlus TMY3 file
  * in the <code>epw</code> format.
  * This will produce an <code>mos</code> file.
  *
  *@author <A HREF="mailto:WZuo@lbl.gov">Wangda Zuo</A>, <A HREF="mailto:MWetter@lbl.gov">Michael Wetter</A>.<p>
  *@version 1.0, July 14, 2010
  */
public class ConvertWeatherData{

  /** System dependent line separator */
  private final static String LS = System.getProperty("line.separator");

  /** Transfer weather time
    * from a format in year, month, date, hour and minute
    * to a format in seconds for simulation
    *
    *@param time time(year, month, day, hour, minute) in weather data file
    *@return simulation time in seconds
    */
  static public String getSimulationTime(int[] time, boolean minuteFlag)
  {
    double simtime;

    switch(time[1]){   // Month to days
      case 1: simtime = 0; break;
      case 2: simtime = 31; break;
      case 3: simtime = 59; break;
      case 4: simtime = 90; break;
      case 5: simtime = 120; break;
      case 6: simtime = 151; break;
      case 7: simtime = 181; break;
      case 8: simtime = 212; break;
      case 9: simtime = 243; break;
      case 10: simtime = 273; break;
      case 11: simtime = 304; break;
      case 12: simtime = 334; break;
      default: simtime = 0;
    }

    simtime = 24 * (simtime+(time[2]-1));// days to hours
    simtime = 60 * (simtime+time[3]); // hours to minutes
    simtime = 60 * (simtime+time[4]);// minutes to seconds

    // if sub hourly data ara avaible flag becomes true
    if (minuteFlag) {
      simtime = simtime - 3600;
    }

    return Double.toString(simtime);
  }


  /** Write converted data into .mos file
    *
    *@param filename the name of .mos weather data file
    *@param myArr array where the weather data is stored
    *@exception IOException when problems occur during file access
    */
  static public void write(String filename, ArrayList<String> myArr)
    throws IOException
  {
    FileOutputStream out; // declare a file output object
    PrintStream p; // declare a print stream object

    out = new FileOutputStream(filename);
    p = new PrintStream( out );

    // do not write data at t = 31536000s since we duplicate data at t = 0s
    for(int i=0; i<myArr.lastIndexOf("End of myArr")-1; i++)
        p.println(myArr.get(i));  // write data line by line

    p.close();
  }


  /** Add comments for weather data
    *
    *@param myArr array where the comments is stored
    *@exception IOException when problems occur during file access
    */
  static private ArrayList<String> addcomments(ArrayList<String> myArr)
  {
    myArr.add("#C1 Time in seconds. Beginning of a year is 0s.");
    myArr.add("#C2 Dry bulb temperature in Celsius at indicated time");
    myArr.add("#C3 Dew point temperature in Celsius at indicated time");
    myArr.add("#C4 Relative humidity in percent at indicated time");
    myArr.add("#C5 Atmospheric station pressure in Pa at indicated time");
    myArr.add("#C6 Extraterrestrial horizontal radiation in Wh/m2");
    myArr.add("#C7 Extraterrestrial direct normal radiation in Wh/m2");
    myArr.add("#C8 Horizontal infrared radiation intensity in Wh/m2");
    myArr.add("#C9 Global horizontal radiation in Wh/m2");
    myArr.add("#C10 Direct normal radiation in Wh/m2");
    myArr.add("#C11 Diffuse horizontal radiation in Wh/m2");
    myArr.add("#C12 Averaged global horizontal illuminance in lux during minutes preceding the indicated time");
    myArr.add("#C13 Direct normal illuminance in lux during minutes preceding the indicated time");
    myArr.add("#C14 Diffuse horizontal illuminance in lux  during minutes preceding the indicated time");
    myArr.add("#C15 Zenith luminance in Cd/m2 during minutes preceding the indicated time");
    myArr.add("#C16 Wind direction at indicated time. N=0, E=90, S=180, W=270");
    myArr.add("#C17 Wind speed in m/s at indicated time");
    myArr.add("#C18 Total sky cover at indicated time");
    myArr.add("#C19 Opaque sky cover at indicated time");
    myArr.add("#C20 Visibility in km at indicated time");
    myArr.add("#C21 Ceiling height in m");
    myArr.add("#C22 Present weather observation");
    myArr.add("#C23 Present weather codes");
    myArr.add("#C24 Precipitable water in mm");
    myArr.add("#C25 Aerosol optical depth");
    myArr.add("#C26 Snow depth in cm");
    myArr.add("#C27 Days since last snowfall");
    myArr.add("#C28 Albedo");
    myArr.add("#C29 Liquid precipitation depth in mm at indicated time");
    myArr.add("#C30 Liquid precipitation quantity");

    return myArr;
  }


  /** Check data validity
    *
    *@param inData Inputed data from .epw file
		*@param preData Data read in previous line
		*@param missData Missing value for this field
    *@param lineNum Line number
    */
  static private String checkdata(String inData, String preData, String missData, int lineNum, int i)
  {
		if (inData.equals(missData)) {
			if (lineNum == 9) {
				i = i + 6;
				System.out.println("The data at line 9 column " + i + " in .epw file is missing. You need to fix it before the convert.");
			  System.exit (0);
			}
			else {
				lineNum = lineNum + 32;
				i = i + 1;
				System.out.println("Correct the missing data in line " + lineNum + " column " + i);
				return preData;
			}
		}

		return inData;

	}


  /** Read and convert data from weather file in epw format
    *
    * @param filename the name of .epw weather data file
    * @param myArr the array where the weather data is stored
    * @exception IOException when problems occur during file access
    */
  static public ArrayList<String> convert(String filename, ArrayList<String> myArr)
    throws IOException
  {
    Scanner lineTokenizer;
    Scanner lineTokenizerTemp;
    Scanner console;
    Scanner lineChecker;
    String tmp, tmp2;
    String timeString;
    String[] preData = new String[30];
		String[] missData = new String[30];
    int lineNum;    // line number in .epw file
    int[] time = new int[5];
    int[] timeTemp = new int[5];
    int i;
    boolean minuteFlag;

 		missData[1] = "99.9";
    missData[2] = "99.9";
		missData[3] = "999";
		missData[4] = "999999";
		missData[5] = "9999";
		missData[6] = "9999";
		missData[7] = "9999";
		missData[8] = "9999";
		missData[9] = "9999";
		missData[10] = "9999";
		missData[11] = "999999";
		missData[12] = "999999";
		missData[13] = "999999";
		missData[14] = "9999";
		missData[15] = "999";
		missData[16] = "999";
		missData[17] = "99";
		missData[18] = "99";
		missData[19] = "9999";
		missData[20] = "99999";
		missData[21] = "9";
		missData[22] = "9";
		missData[23] = "999";
		missData[24] = "999";
		missData[25] = "999";
		missData[26] = "99";


    console = new Scanner(new File(filename));
    lineChecker = new Scanner(new File(filename));
    minuteFlag = false;

    // generate Head for .mos file
    myArr.add("#1");

    // read first 8 lines for general information
    for(lineNum=1; lineNum<=8; lineNum++) {
      lineTokenizer = new Scanner(console.nextLine()).useDelimiter(LS);
      lineChecker.nextLine();
      tmp= "#"+lineTokenizer.next();
      myArr.add(tmp);
      lineTokenizer.close(); // discard this line
    }

    // add comments for weather data
    myArr = addcomments(myArr);

    // read weather data
    while (console.hasNextLine()) {
      // scan a line
      lineTokenizer = new Scanner(console.nextLine()).useDelimiter(", *");

      // read year, month, date, hour and minute
      for(i=0; i<=4; i++){
        if(lineTokenizer.hasNext()) {
	     	  time[i] = lineTokenizer.nextInt();
          }
        else {
	        throw new IOException("Expected more entries on line " + lineNum + ".");
        }
      }
      // Check 9 and 10th lines for minutes field
      if(lineNum == 9) {
        // Go to 10th line
        lineChecker.nextLine();
        lineTokenizerTemp = new Scanner(lineChecker.nextLine()).useDelimiter(", *");
        for(i=0; i<=4; i++){
          timeTemp[i] = lineTokenizerTemp.nextInt();
        }
        // Check minutes field if minutes field present flag == True
        if(time[4] > 0 || timeTemp[4] > 0 ) {
          minuteFlag = true;
         }
        else {
          minuteFlag = false;
        }
        lineChecker.close();
        lineTokenizerTemp.close(); 
       }

      // convert the time in seconds
      timeString = getSimulationTime(time,minuteFlag);
      tmp = timeString + "\t";

      // skip the flag for data quality
      if (lineTokenizer.hasNext()) {
        lineTokenizer.next();
      }
      else {
        throw new IOException("Expected more entries on line " + lineNum + ".");
      }

      // check dry bulb temperature, dew point temperature, relative humidity, atmospheric station pressure
	    for(i=1; i<=4; i++){
				if (lineTokenizer.hasNext()) {
					tmp2 = lineTokenizer.next();
					tmp2 = checkdata(tmp2, preData[i], missData[i], lineNum, i);
		      tmp = tmp + tmp2 + "\t";
					preData[i] = tmp2;
		    }
		    else {
		        throw new IOException("Expected more entries on line " + lineNum + ".");
		    }
			}

			// others
      for(i=5; i<=7; i++){
        if (lineTokenizer.hasNext()) {
          tmp = tmp + lineTokenizer.next() + "\t";
        }
        else {
          throw new IOException("Expected more entries on line " + lineNum + ".");
        }
      }

			// check global horizontal radiation
			i = 8;
			if (lineTokenizer.hasNext()) {
				tmp2 = lineTokenizer.next();
				tmp2 = checkdata(tmp2, preData[i], missData[i], lineNum, i);
	      tmp = tmp + tmp2 + "\t";
				preData[i] = tmp2;
	    }
	    else {
	        throw new IOException("Expected more entries on line " + lineNum + ".");
	    }

			// others
			i = 9;
			if (lineTokenizer.hasNext()) {
        tmp = tmp + lineTokenizer.next() + "\t";
      }
      else {
        throw new IOException("Expected more entries on line " + lineNum + ".");
      }

			// check diffuse horizontal radiation
			i = 10;
			if (lineTokenizer.hasNext()) {
				tmp2 = lineTokenizer.next();
				tmp2 = checkdata(tmp2, preData[i], missData[i], lineNum, i);
	      tmp = tmp + tmp2 + "\t";
				preData[i] = tmp2;
	    }
	    else {
	        throw new IOException("Expected more entries on line " + lineNum + ".");
	    }

			// others
      for(i=11; i<=16; i++){
        if (lineTokenizer.hasNext()) {
          tmp = tmp + lineTokenizer.next() + "\t";
        }
        else {
          throw new IOException("Expected more entries on line " + lineNum + ".");
        }
      }

			// check total sky cover, opaque sky cover
			for(i=17; i<=18; i++){
				if (lineTokenizer.hasNext()) {
					tmp2 = lineTokenizer.next();
					tmp2 = checkdata(tmp2, preData[i], missData[i], lineNum, i);
		      tmp = tmp + tmp2 + "\t";
					preData[i] = tmp2;
		    }
		    else {
		        throw new IOException("Expected more entries on line " + lineNum + ".");
		    }
			}

			// others
			i = 19;
			if (lineTokenizer.hasNext()) {
        tmp = tmp + lineTokenizer.next() + "\t";
      }
      else {
        throw new IOException("Expected more entries on line " + lineNum + ".");
      }

			// check cloud ceiling height
			i = 20;
			if (lineTokenizer.hasNext()) {
				tmp2 = lineTokenizer.next();
				tmp2 = checkdata(tmp2, preData[i], missData[i], lineNum, i);
		    if (tmp2.equals("88888") || tmp2.equals("77777") || tmp2.equals("99999"))
		      tmp2 = "2000";
				tmp = tmp + tmp2 + "\t";
				preData[i] = tmp2;
			}
			else {
        throw new IOException("Expected more entries on line " + lineNum + ".");
      }

      // others
      for(i=21; i<=29; i++){
        if (lineTokenizer.hasNext()) {
          tmp = tmp + lineTokenizer.next() + "\t";
        }
        else {
          throw new IOException("Expected more entries on line " + lineNum + ".");
        }
      }

      // Use the data at first recorded time for time equal to 0s
      if (lineNum == 9)	{
				tmp = tmp.replaceFirst(timeString, "0.0");
				myArr.add(tmp);
        tmp = tmp.replaceFirst("0.0", timeString);
			}

      myArr.add(tmp);     // add one line

      lineTokenizer.close(); // discard this line
      lineNum++;

    } // End of While Loop

    // add dimensions of table
    tmp = "double tab1(" + (lineNum-9) + ",30)";
    myArr.add(1, tmp);
    myArr.add("End of myArr"); // add signs for end of file

    return myArr;
  }


  /** This method is used to transfer the weather data file from .epw format for EnergyPlus
    * to .mos for Modelica
    *@param args name of .epw weather data file
    */
  static public void main(String args[]) {
    ArrayList<String> myArr = new ArrayList<String>();
		if(args.length == 0) {
      System.out.println("Expecting data file. To convert weather data, run this program as");
      System.out.println("java -jar ConvertWeatherData.jar inputFile.epw");
      System.exit(1);
    }

    String filename=args[0];

    // if users search for help information
		if(filename.equals("-h"))
    {
      System.out.println("To convert weather data, run this program as");
      System.out.println("java -jar ConvertWeatherData.jar inputFile.epw");
			System.exit(0);
    }

    // check the input file name
    if(!filename.contains(".epw")) {
      System.err.println ("Name of weather data file should end with \".epw\". To convert weather data, run this program as");
      System.out.println("java -jar ConvertWeatherData.jar inputFile.epw");
      System.out.println("or if spaces are present in the name, write name between \"\"");
      System.out.println("java -jar ConvertWeatherData.jar \"inputFile .epw\"");
      System.exit(1);
    }

    try{
      myArr = convert(filename, myArr);
      filename = filename.replace(".epw", ".mos");
      write(filename, myArr);
    }
    catch (Exception e)
    {
      System.err.println ("Error in read and write data.");
      System.exit(1);
     }

    System.exit (0);
  }
}
