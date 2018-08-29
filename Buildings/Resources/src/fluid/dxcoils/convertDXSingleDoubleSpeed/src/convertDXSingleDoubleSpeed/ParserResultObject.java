package convertDXSingleDoubleSpeed;

import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * This class records and prints all dx single speed cooling coils found in an input file.
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, November 20, 2012
 *
 */
public class ParserResultObject {

    private ArrayList<DXSingleSpeed> dxSingleSpeeds;
    private ArrayList<DXDoubleSpeed> dxDoubleSpeeds;
    private String gloHeaderStr;

    public ParserResultObject() {
    }

    /**
     * This method sets the found dx single speed coils in an array.
     *
     * @param foundDXSingleSpeeds
     *            array list of DXSingleSpeeds.
     */

    public void setFoundDXSingleSpeeds(ArrayList<DXSingleSpeed> foundDXSingleSpeeds) {

        dxSingleSpeeds = foundDXSingleSpeeds;
    }

    /**
     * This method sets the found dx double speed coils in an array.
     *
     * @param foundDXDoubleSpeeds
     *            array list of DXDoubleSpeeds.
     */

    public void setFoundDXDoubleSpeeds(ArrayList<DXDoubleSpeed> foundDXDoubleSpeeds) {

        dxDoubleSpeeds = foundDXDoubleSpeeds;
    }
    /**
     * This method prints the date.
     */
    private String getDateTime() {
        DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm");
        Date date = new Date();
        return dateFormat.format(date);
    }
    /**
     * This method finds duplicated DXSingleSpeed in the input file and print them
     * in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void dxSingleSpeedsDuplicates(String fileName) throws IOException {
        // This method prints all the duplicated DXSingleSpeeds in the output
        // file.

        // concatenate the recorded DXSingleSpeeds in a string
        ArrayList<String> recordedDXSingleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXSingleSpeed> dxSingleSpeedIterator = dxSingleSpeeds.iterator(); dxSingleSpeedIterator
                .hasNext();) {
            recordedDXSingleSpeedsStrings.add(dxSingleSpeedIterator.next()
                    .toMoRecordString());
        }

        ArrayList<String> duplicates = new ArrayList<String>();
        duplicates = saveDuplicates(recordedDXSingleSpeedsStrings);

        // define the header of the output file
        String fileHeader = "There are "
                + String.format("%s", duplicates.size()) + " duplicate(s) "
                + "in the input file. The duplicate(s) is(are) :" + "\n" + "\n";

        String recordedDuplicatesStrings = "";

        // concatenate the recorded DXSingleSpeed in a string
        for (Iterator<String> it = duplicates.iterator(); it.hasNext();) {
            recordedDuplicatesStrings += it.next() + "\n";
        }

        // print the header + DXSingleSpeed + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        fw.write(fileHeader + recordedDuplicatesStrings);
        fw.close();
    }

    /**
     * This method finds duplicated DXDoubleSpeed in the input file and print them
     * in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void dxDoubleSpeedsDuplicates(String fileName) throws IOException {
        // This method prints all the duplicated DXDoubleSpeeds in the output
        // file.

        // concatenate the recorded DXDoubleSpeeds in a string
        ArrayList<String> recordedDXDoubleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXDoubleSpeed> dxDoubleSpeedIterator = dxDoubleSpeeds.iterator(); dxDoubleSpeedIterator
                .hasNext();) {
            recordedDXDoubleSpeedsStrings.add(dxDoubleSpeedIterator.next()
                    .toMoRecordString());
        }

        ArrayList<String> duplicates = new ArrayList<String>();
        duplicates = saveDuplicates(recordedDXDoubleSpeedsStrings);

        // define the header of the output file
        String fileHeader = "There are "
                + String.format("%s", duplicates.size()) + " duplicate(s) "
                + "in the input file. The duplicate(s) is(are) :" + "\n" + "\n";

        String recordedDuplicatesStrings = "";

        // concatenate the recorded DXDoubleSpeed in a string
        for (Iterator<String> it = duplicates.iterator(); it.hasNext();) {
            recordedDuplicatesStrings += it.next() + "\n";
        }

        // print the header + DXDoubleSpeed + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        fw.write(fileHeader + recordedDuplicatesStrings);
        fw.close();
    }

    /**
     * This method prints all DXSingleSpeed in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void toMoDXSingleSpeedsFile(String fileName) throws IOException {
        // This method prints all the DXSinglsSpeeds objects in the output file.

    	// defines package annotation
    	String packageAnnotation = "annotation(preferredView=" + "\"" + "info" + "\""
                + ",\n Documentation(info=\"<html>\n"
                + "<p>\nPackage with performance data for DX coils."
                + "\n</p>\n</html>\","
                + " revisions=\"<html>\n"
                + "<p>\nGenerated on "
                + getDateTime()
                + " by "
                + System.getProperty("user.name")
                + "\n</p>\n</html>\"));"
                + "\n";

        // define the header of the output file
        // Date date = new Date();
        String fileHeader = "within Buildings.Fluid.HeatExchangers.DXCoils.Data;"
                + "\n"


                + "package SingleSpeed \"Performance data for SingleSpeed DXCoils\""
                + "\n"
                + "  extends Modelica.Icons.MaterialPropertiesPackage;\n"
				/*
				 * + " annotation(\n  preferredView=" + "\"" + "info" + "\"" +
				 * ",\n  Documentation(info=\"<html>\n<p>\n" +
				 * "Package with performance data for DX coils." +
				 * "\n</p>\n</html>\",\n" + " revisions=\"<html>\n" +
				 * "<p>\nGenerated on " + getDateTime() + " by " +
				 * System.getProperty("user.name") + "\n</p>\n</html>\"));" +
				 * "\n"
				 */
                + "  "
                + "record Generic \"Generic data record for SingleSpeed DXCoils\""
                + "\n"
                + "    "
                + "extends Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil(final nSta=1);"
                + "\n"
                + "annotation(\n"
                + "defaultComponentName=\"datCoi\",\n"
        		+ "defaultComponentPrefixes=\"parameter\",\n"
                + "Documentation(info=\"<html>"
                + "\n<p>\n"
                + "This record is used as a template for performance data"
                + "\n"
                + "for SingleSpeed DXCoils"
                + "\n"
                + "<a href="
                + "\\"
                + "\"Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed"
                + "\\"
                + "\">"
                + "\n"
                + "Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed</a>."
                + "\n</p>\n"
                + "</html>\", revisions=\"<html>"
                + "\n"
                + "<ul>"
                + "\n"
                + "<li>"
                + "\n"
                + "November 20, 2012 by Thierry S. Nouidui:<br/>"
                + "\n"
                + "First implementation."
                + "\n"
                + "</li>"
                + "\n"
                + "</ul>"
                + "\n"
                + "</html>\"));"
                + "\n"
                + "  end Generic;"
                + "\n" + "\n";

        // store the recorded DXSingleSpeed in a string array
        ArrayList<String> recordedDXSingleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXSingleSpeed> dxSingleSpeedIterator = dxSingleSpeeds.iterator(); dxSingleSpeedIterator
                .hasNext();) {
            recordedDXSingleSpeedsStrings.add(dxSingleSpeedIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedDXSingleSpeedsStrings = new ArrayList<String>();
        rmDuplicatesRecordedDXSingleSpeedsStrings = removeDuplicates(recordedDXSingleSpeedsStrings);

        if (rmDuplicatesRecordedDXSingleSpeedsStrings.size() != dxSingleSpeeds
                .size()) {
            System.out
                    .println("the input file has duplicated DXSingleSpeeds. These duplicates will be automatically removed and listed in the .txt output files");
        }

        // concatenate the cleaned recorded DXSingleSpeeds in a string
        String cleanRecordedDXSingleSpeeds = "";

        for (Iterator<String> itr = rmDuplicatesRecordedDXSingleSpeedsStrings
                .iterator(); itr.hasNext();) {
            cleanRecordedDXSingleSpeeds += itr.next() + "\n";
        }

        // define the footer of the output file
        String fileFooter = "end SingleSpeed;";

        // print the header + DXSingleSpeed + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        // Some E+ fields have string such as Lennox SCA240H4B Stage 1&2.
        // The & sign needs to be converted to &amp; as it is inside an html section.
        cleanRecordedDXSingleSpeeds = cleanRecordedDXSingleSpeeds.replaceAll("&", "&amp;");
        fw.write(fileHeader + cleanRecordedDXSingleSpeeds + packageAnnotation + fileFooter);
        fw.close();
    }

    /**
     * This method prints all DXDoubleSpeed in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void toMoDXDoubleSpeedsFile(String fileName) throws IOException {
        // This method prints all the DXSinglsSpeeds objects in the output file.

    	// defines package annotation
    	String packageAnnotation = "annotation(preferredView=" + "\"" + "info" + "\""
                + ",\n Documentation(info=\"<html>\n"
                + "<p>\nPackage with performance data for DX coils."
                + "\n</p>\n</html>\","
                + " revisions=\"<html>\n"
                + "<p>\nGenerated on "
                + getDateTime()
                + " by "
                + System.getProperty("user.name")
                + "\n</p>\n</html>\"));"
                + "\n";

        // define the header of the output file
        // Date date = new Date();
        String fileHeader = "within Buildings.Fluid.HeatExchangers.DXCoils.Data;"
                + "\n"

                + "package DoubleSpeed \"Performance data for DoubleSpeed DXCoils\""
                + "\n"
                + "  extends Modelica.Icons.MaterialPropertiesPackage;\n"
				/*
				 * + " annotation(\n preferredView=" + "\"" + "info" + "\"" +
				 * ",\n  Documentation(info=\"<html>\n<p>\n" +
				 * "Package with performance data for DX coils." +
				 * "\n</p>\n</html>\",\n" + " revisions=\"<html>\n" +
				 * "<p>\nGenerated on " + getDateTime() + " by " +
				 * System.getProperty("user.name") + "\n</p>\n</html>\"));" +
				 * "\n"
				 */
                + "  "
                + "record Generic \"Generic data record for DoubleSpeed DXCoils\""
                + "\n"
                + "    "
                + "extends Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.DXCoil(final nSta=2);"
                + "\n"
                + "annotation(\n"
                + "defaultComponentName=\"datCoi\",\n"
        		+ "defaultComponentPrefixes=\"parameter\",\n"
                + "Documentation(info=\"<html>"
                + "\n<p>\n"
                + "This record is used as a template for performance data"
                + "\n"
                + "for the double speed DX coils"
                + "\n"
                + "<a href="
                + "\\"
                + "\"Buildings.Fluid.HeatExchangers.DXCoils.DoubleSpeed"
                + "\\"
                + "\">"
                + "\n"
                + "Buildings.Fluid.HeatExchangers.DXCoils.DoubleSpeed</a>."
                + "\n</p>\n"
                + "</html>\", revisions=\"<html>"
                + "\n"
                + "<ul>"
                + "\n"
                + "<li>"
                + "\n"
                + "November 20, 2012 by Thierry S. Nouidui:<br/>"
                + "\n"
                + "First implementation."
                + "\n"
                + "</li>"
                + "\n"
                + "</ul>"
                + "\n"
                + "</html>\"));"
                + "\n"
                + "  end Generic;"
                + "\n" + "\n";

        // store the recorded DXDoubleSpeed in a string array
        ArrayList<String> recordedDXDoubleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXDoubleSpeed> dxDoubleSpeedIterator = dxDoubleSpeeds.iterator(); dxDoubleSpeedIterator
                .hasNext();) {
            recordedDXDoubleSpeedsStrings.add(dxDoubleSpeedIterator.next()
                    .toMoRecordString());

        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedDXDoubleSpeedsStrings = new ArrayList<String>();
        rmDuplicatesRecordedDXDoubleSpeedsStrings = removeDuplicates(recordedDXDoubleSpeedsStrings);

        if (rmDuplicatesRecordedDXDoubleSpeedsStrings.size() != dxDoubleSpeeds
                .size()) {
            System.out
                    .println("the input file has duplicated DXDoubleSpeeds. These duplicates will be automatically removed and listed in the .txt output files");
        }

        // concatenate the cleaned recorded DXDoubleSpeeds in a string
        String cleanRecordedDXDoubleSpeeds = "";

        for (Iterator<String> itr = rmDuplicatesRecordedDXDoubleSpeedsStrings
                .iterator(); itr.hasNext();) {
            cleanRecordedDXDoubleSpeeds += itr.next() + "\n";
        }

        // define the footer of the output file
        String fileFooter = "end DoubleSpeed;";

        // print the header + DXSingleSpeed + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        // Some E+ fields have string such as Lennox SCA240H4B Stage 1&2.
        // The & sign needs to be converted to &amp; as it is inside an html section.
        cleanRecordedDXDoubleSpeeds = cleanRecordedDXDoubleSpeeds.replaceAll("&", "&amp;");
        fw.write(fileHeader + cleanRecordedDXDoubleSpeeds + packageAnnotation + fileFooter);
        fw.close();

    }

    /**
     * This method returns the number of duplicated DXSingleSpeed found in an
     * input file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return number of duplicates.
     *
     */
    public double cardinalDXSingleSpeedsDuplicatesFile(String fileName) {
        // this method returns the cardinality of the duplicated DXSingleSpeed coils data

        double value;
        // store the recorded DXSingleSpeeds in a string array
        ArrayList<String> recordedDXSingleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXSingleSpeed> dxSingleSpeedIterator = dxSingleSpeeds.iterator(); dxSingleSpeedIterator
                .hasNext();) {
            recordedDXSingleSpeedsStrings.add(dxSingleSpeedIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedDXSingleSpeedsStrings = new ArrayList<String>();
        rmDuplicatesRecordedDXSingleSpeedsStrings = removeDuplicates(recordedDXSingleSpeedsStrings);

        // System.out.println
        // ("size of the dxSingleSpeeds after removing the duplicates " +
        // rmDuplicatesRecordedDXSingleSpeedsStrings.size());
        value = rmDuplicatesRecordedDXSingleSpeedsStrings.size()
                - dxSingleSpeeds.size();

        return value;
    }

    /**
     * This method returns the number of duplicated DXDoubleSpeed found in an
     * input file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return number of duplicates.
     *
     */
    public double cardinalDXDoubleSpeedsDuplicatesFile(String fileName) {
        // this method returns the cardinality of the duplicated DXDoubleSpeed coils data

        double value;
        // store the recorded DXDoubleSpeeds in a string array
        ArrayList<String> recordedDXDoubleSpeedsStrings = new ArrayList<String>();

        for (Iterator<DXDoubleSpeed> dxDoubleSpeedIterator = dxDoubleSpeeds.iterator(); dxDoubleSpeedIterator
                .hasNext();) {
            recordedDXDoubleSpeedsStrings.add(dxDoubleSpeedIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedDXDoubleSpeedsStrings = new ArrayList<String>();
        rmDuplicatesRecordedDXDoubleSpeedsStrings = removeDuplicates(recordedDXDoubleSpeedsStrings);

        // System.out.println
        // ("size of the dxDoubleSpeeds after removing the duplicates " +
        // rmDuplicatesRecordedDXDoubleSpeedsStrings.size());
        value = rmDuplicatesRecordedDXDoubleSpeedsStrings.size()
                - dxDoubleSpeeds.size();

        return value;
    }



    /**
     * This method saves duplicates found in an array list.
     *
     * @param arlList
     *            array list with duplicated entries.
     * @return new array list with found duplicates.
     */
    public static ArrayList<String> saveDuplicates(ArrayList<String> arlList) {
        // this functions save all duplicated in an Array.

        Set<String> set = new HashSet<String>();
        List<String> newList = new ArrayList<String>();
        List<String> newListDuplicates = new ArrayList<String>();
        for (Iterator<String> iter = arlList.iterator(); iter.hasNext();) {
            String element = iter.next();
            if (set.add(element))
                newList.add(element);
            else {
                newListDuplicates.add(element);
            }
        }
        arlList.clear();
        arlList.addAll(newListDuplicates);
        return arlList;
    }

    /**
     * This method removes duplicates from an array list.
     *
     * @param arlList
     *            array list with duplicated entries.
     * @return new array list without duplicates.
     */
    public static ArrayList<String> removeDuplicates(ArrayList<String> arlList) {
        // This function removes all duplicates from an Array.

        Set<String> set = new HashSet<String>();
        List<String> newList = new ArrayList<String>();
        for (Iterator<String> iter = arlList.iterator(); iter.hasNext();) {
            String element = iter.next();
            if (set.add(element)) {
                newList.add(element);
            }
        }
        arlList.clear();
        arlList.addAll(newList);
        return arlList;
    }
    // private final static String LS = System.getProperty("line.separator");

    /**
     * This method gets the comments header for all cooling coils.
     */
    public String getGloHeaderStr() {
        return gloHeaderStr;
    }

    /**
     * This method sets the comments header for all cooling coils.
     */
    public void setGloHeaderStr(String gloHeaderStr) {
        this.gloHeaderStr = gloHeaderStr;
    }
}
