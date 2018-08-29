package convertEIR;

import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

/**
 * This class records and prints all electric chillers found in an input file.
 *
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, October 10, 2010
 *
 */
public class ParserResultObject {

    private ArrayList<ElectricEIR> electricEirs;
    private ArrayList<ReformElectricEIR> reformElectricsEirs;

    // private final static String LS = System.getProperty("line.separator");

    public ParserResultObject() {
    }

    /**
     * This method sets the found electric chillers in an array.
     *
     * @param eirs
     *            array list of ElectricEIRs.
     */

    public void setFoundElectricEIRs(ArrayList<ElectricEIR> eirs) {

        electricEirs = eirs;
    }

    /**
     * This method sets the found reformulated electric chillers in an array.
     *
     * @param reformEirs
     *            array list of reformulated ElectricEIR.
     */
    public void setFoundReformElectricEIRs(
            ArrayList<ReformElectricEIR> reformEirs) {

        reformElectricsEirs = reformEirs;
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
     * This method finds duplicated ElectricEIR in the input file and print them
     * in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void electricEirsDuplicates(String fileName) throws IOException {
        // This method prints all the duplicated Electric EIRs in the output
        // file.

        // concatenate the recorded ElectricEIR in a string
        ArrayList<String> recordedElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ElectricEIR> eirIterator = electricEirs.iterator(); eirIterator
                .hasNext();) {
            recordedElectricEirsStrings.add(eirIterator.next()
                    .toMoRecordString());
        }

        ArrayList<String> duplicates = new ArrayList<String>();
        duplicates = saveDuplicates(recordedElectricEirsStrings);

        // define the header of the output file
        String fileHeader = "There are "
                + String.format("%s", duplicates.size()) + " duplicate(s) "
                + "in the input file. The duplicate(s) is(are) :" + "\n" + "\n";

        String recordedDuplicatesStrings = "";

        // concatenate the recorded ElectricEIR in a string
        for (Iterator<String> it = duplicates.iterator(); it.hasNext();) {
            recordedDuplicatesStrings += it.next() + "\n";
        }

        // print the header + ElectricEIR + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        fw.write(fileHeader + recordedDuplicatesStrings);
        fw.close();
    }

    /**
     * This method prints all ElectricEIR in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void toMoElectricEirsFile(String fileName) throws IOException {
        // This method prints all the Electric EIRs in the output file.

    	// defines package annotation
    	String packageAnnotation = "annotation(preferredView=" + "\"" + "info" + "\""
                + ",\n Documentation(info=\"<html>\n"
                + "<p>\nPackage with performance data for chillers."
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
        String fileHeader = "within Buildings.Fluid.Chillers.Data;"
                + "\n"
                + "package ElectricEIR \"Performance data for chiller ElectricEIR\"\n"
                + "  extends Modelica.Icons.MaterialPropertiesPackage;\n"
				/*
				 * + " annotation(preferredView=\"info\",\n" +
				 * " Documentation(info=\"<html>\n" + "<p>\n" +
				 * "Package with performance data for chillers.\n" + "</p>\n" +
				 * "</html>\n\"," + " revisions=\"<html>\n" + "Generated on " +
				 * getDateTime() + " by " + System.getProperty("user.name") +
				 * "</html>\"));" + "\n"
				 */
                + "  "
                + "record Generic \"Generic data record for chiller ElectricEIR\""
                + "\n"
                + "    "
                + "extends Buildings.Fluid.Chillers.Data.BaseClasses.Chiller("
                + "\n"
                + "        "
                + "final nCapFunT=6,"
                + "\n"
                + "        "
                + "final nEIRFunT=6,"
                + "\n"
                + "        "
                + "final nEIRFunPLR=3);"
                + "\n"
                + "    "
                + "parameter Modelica.SIunits.Temperature TConEnt_nominal"
                + "\n"
                + "      "
                + "\"Temperature of fluid entering condenser at nominal condition\";"
                + "\n"
                + "\n"
                +

                "    "
                + "parameter Modelica.SIunits.Temperature TConEntMin"
                + "\n"
                + "      "
                + "\"Minimum value for entering condenser temperature\""
                + "\n"
                + "      "
                + "annotation (Dialog(group=\"Performance curves\"));"
                + "\n"
                + "    "
                + "parameter Modelica.SIunits.Temperature TConEntMax"
                + "\n"
                + "      "
                + "\"Maximum value for entering condenser temperature\""
                + "\n"
                + "      "
                + "annotation (Dialog(group=\"Performance curves\"));"
                + "\n"
                + "\n"
                + "annotation(\n"
                + "defaultComponentName=\"datChi\",\n"
                + "defaultComponentPrefixes=\"parameter\",\n"
                + "Documentation(info=\"<html>"
                + "\n"
                + "<p>"
                + "This record is used as a template for performance data"
                + "\n"
                + "for the chiller model"
                + "\n"
                + "<a href="
                + "\\"
                + "\"Buildings.Fluid.Chillers.ElectricEIR"
                + "\\"
                + "\">"
                + "\n"
                + "Buildings.Fluid.Chillers.ElectricEIR</a>."
                + "\n"
                + "</p>"
                + "\n"
                + "</html>\", revisions=\"<html>"
                + "\n"
                + "<ul>"
                + "\n"
                + "<li>"
                + "\n"
                + "December 19, 2014 by Michael Wetter:<br/>"
                + "\n"
                + "Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>."
                + "\n"
                + "</li>"
                + "<li>"
                + "\n"
                + "September 17, 2010 by Michael Wetter:<br/>"
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

        // store the recorded ElectricEIR in a string array
        ArrayList<String> recordedElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ElectricEIR> eirIterator = electricEirs.iterator(); eirIterator
                .hasNext();) {
            recordedElectricEirsStrings.add(eirIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedElectricEirsStrings = new ArrayList<String>();
        rmDuplicatesRecordedElectricEirsStrings = removeDuplicates(recordedElectricEirsStrings);

        if (rmDuplicatesRecordedElectricEirsStrings.size() != electricEirs
                .size()) {
            System.out
                    .println("the input file has duplicated ElectricEIRs. These duplicates will be automatically removed and listed in the .txt output files");
        }

        // concatenate the cleaned recorded ElectricEIR in a string
        String cleanRecordedElectricEirs = "";

        for (Iterator<String> itr = rmDuplicatesRecordedElectricEirsStrings
                .iterator(); itr.hasNext();) {
            cleanRecordedElectricEirs += itr.next() + "\n";
        }

        // define the footer of the output file
        String fileFooter = "end ElectricEIR;";

        // print the header + ElectricEIR + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        // Some E+ fields have string such as Trane CVHG670-44&86 2490kW/6.5COP
        // The & sign needs to be converted to &amp; as it is inside an html section.
        cleanRecordedElectricEirs = cleanRecordedElectricEirs.replaceAll("&", "&amp;");

        fw.write(fileHeader + cleanRecordedElectricEirs + packageAnnotation + fileFooter);
        fw.close();
    }

    /**
     * This method returns the number of duplicated ElectricEIR found in an
     * input file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return number of duplicates.
     *
     */
    public double cardinalElectricEirsDuplicatesFile(String fileName) {
        // this method returns the cardinality of the duplicated Electric EIRs

        double value;
        // store the recorded ElectricEIR in a string array
        ArrayList<String> recordedElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ElectricEIR> eirIterator = electricEirs.iterator(); eirIterator
                .hasNext();) {
            recordedElectricEirsStrings.add(eirIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedElectricEirsStrings = new ArrayList<String>();
        rmDuplicatesRecordedElectricEirsStrings = removeDuplicates(recordedElectricEirsStrings);

        // System.out.println
        // ("size of the electrisEirs after removing the duplicates " +
        // rmDuplicatesRecordedElectricEirsStrings.size());
        value = rmDuplicatesRecordedElectricEirsStrings.size()
                - electricEirs.size();

        return value;
    }

    /**
     * This method finds duplicated reformulated ElectricEIR in an input file
     * and print them in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void reformElectricEirsDuplicates(String fileName)
            throws IOException {
        // This method prints all the duplicated Reformulated Electric EIRs in
        // the output file.

        // concatenate the recorded ElectricEIR in a string
        ArrayList<String> recordedReformElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ReformElectricEIR> eirIterator = reformElectricsEirs
                .iterator(); eirIterator.hasNext();) {
            recordedReformElectricEirsStrings.add(eirIterator.next()
                    .toMoRecordString());
        }

        ArrayList<String> duplicates = new ArrayList<String>();
        duplicates = saveDuplicates(recordedReformElectricEirsStrings);

        // define the header of the output file
        String fileHeader = "There are "
                + String.format("%s", duplicates.size()) + " duplicate(s) "
                + "in the input file. The duplicate(s) is(are) :" + "\n" + "\n";

        String recordedDuplicatesStrings = "";

        // concatenate the recorded ElectricEIR in a string
        for (Iterator<String> it = duplicates.iterator(); it.hasNext();) {
            recordedDuplicatesStrings += it.next() + "\n";
        }

        // print the header + ElectricEIR + footer in the output file
        OutputStreamWriter fw = new FileWriter(fileName);
        fw.write(fileHeader + recordedDuplicatesStrings);
        fw.close();
    }

    /**
     * This method prints all reformulated ElectricEIR in an output file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @exception IOException
     *                when problems occur during file access.
     */
    public void toMoReformElectricEirsFile(String fileName) throws IOException {
        // This method prints all the Reformulated Electric EIRs in the output
        // file.

    	// defines package annotation
    	String packageAnnotation = "annotation(preferredView=" + "\"" + "info" + "\""
                + ",\n Documentation(info=\"<html>\n"
                + "<p>\nPackage with performance data for chillers."
                + "\n</p>\n</html>\","
                + " revisions=\"<html>\n"
                + "<p>\nGenerated on "
                + getDateTime()
                + " by "
                + System.getProperty("user.name")
                + "\n</p>\n</html>\"));"
                + "\n";
        // defines the header of the output file
        String fileHeader = "within Buildings.Fluid.Chillers.Data;"
                + "\n"
                + "package ElectricReformulatedEIR \"Performance data for chiller ElectricReformulatedEIR\"\n"
                + "  extends Modelica.Icons.MaterialPropertiesPackage;\n"
				/*
				 * + " annotation(preferredView=" + "\"" + "info" + "\"" +
				 * ",\n Documentation(info=\"<html>\n" +
				 * "<p>\nPackage with performance data for chillers." +
				 * "\n</p>\n</html>\"," + " revisions=\"<html>\n" +
				 * "<p>\nGenerated on " + getDateTime() + " by " +
				 * System.getProperty("user.name") + "\n</p>\n</html>\"));" +
				 * "\n"
				 */
                + "  "
                + "record Generic \"Generic data record for chiller ElectricReformulatedEIR\""
                + "\n"
                + "    "
                + "extends Buildings.Fluid.Chillers.Data.BaseClasses.Chiller("
                + "\n"
                + "        "
                + "final nCapFunT=6,"
                + "\n"
                + "        "
                + "final nEIRFunT=6,"
                + "\n"
                + "        "
                + "final nEIRFunPLR=10);"
                + "\n"
                + "    "
                + "parameter Modelica.SIunits.Temperature TConLvg_nominal"
                + "\n"
                + "      "
                + "\"Temperature of fluid leaving condenser at nominal condition\";"
                + "\n"
                + "\n"
                +

                "    "
                + "parameter Modelica.SIunits.Temperature TConLvgMin"
                + "\n"
                + "      "
                + "\"Minimum value for leaving condenser temperature\""
                + "\n"
                + "      "
                + "annotation (Dialog(group=\"Performance curves\"));"
                + "\n"
                + "    "
                + "Modelica.SIunits.Temperature TConLvgMax"
                + "\n"
                + "      "
                + "\"Maximum value for leaving condenser temperature\""
                + "\n"
                + "      "
                + "annotation (Dialog(group=\"Performance curves\"));"
                + "\n"
                + "\n"
                + "annotation(\n"
                + "defaultComponentName=\"datChi\",\n"
                + "defaultComponentPrefixes=\"parameter\",\n"
                + "Documentation(info=\"<html>"
                + "\n"
                + "This record is used as a template for performance data"
                + "\n"
                + "for the chiller model"
                + "\n"
                + "<a href="
                + "\\"
                + "\"Buildings.Fluid.Chillers.ElectricReformulatedEIR"
                + "\\"
                + "\">"
                + "\n"
                + "Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>."
                + "\n"
                + "</html>\", revisions=\"<html>"
                + "\n"
                + "<ul>"
                + "\n"
                + "<li>"
                + "\n"
                + "December 19, 2014 by Michael Wetter:<br/>"
                + "\n"
                + "Added <code>defaultComponentName</code> and <code>defaultComponentPrefixes</code>."
                + "\n"
                + "</li>"
                + "<li>"
                + "\n"
                + "September 17, 2010 by Michael Wetter:<br/>"
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

        // store the recorded ElectricEIR in a string array
        ArrayList<String> recordedReformElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ReformElectricEIR> reformEirIterator = reformElectricsEirs
                .iterator(); reformEirIterator.hasNext();) {
            recordedReformElectricEirsStrings.add(reformEirIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedReformElectricEirsStrings = new ArrayList<String>();
        rmDuplicatesRecordedReformElectricEirsStrings = removeDuplicates(recordedReformElectricEirsStrings);

        if (rmDuplicatesRecordedReformElectricEirsStrings.size() != reformElectricsEirs
                .size()) {
            System.out
                    .println("the input file has duplicated ReformulatedElectricEIRs. These duplicates will be automatically removed and listed in the .txt output files");
        }

        // concatenate the cleaned recorded ElectricEIR in a string
        String cleanRecordedReformElectricEirs = "";

        for (Iterator<String> itr = rmDuplicatesRecordedReformElectricEirsStrings
                .iterator(); itr.hasNext();) {
            cleanRecordedReformElectricEirs += itr.next() + "\n";
        }

        // defines the footer of the output file
        String fileFooter = "end ElectricReformulatedEIR;";

        // print the header + ReformulatedElectricEIR + footer in the output
        // file
        OutputStreamWriter fw = new FileWriter(fileName);

        // Some E+ fields have string such as Trane CVHG670-44&86 2490kW/6.5COP
        // The & sign needs to be converted to &amp; as it is inside an html section.
        cleanRecordedReformElectricEirs = cleanRecordedReformElectricEirs.replaceAll("&", "&amp;");

        fw.write(fileHeader + cleanRecordedReformElectricEirs + packageAnnotation + fileFooter);
        fw.close();
    }

    /**
     * This method returns the number of duplicated reformulated ElectricEIR in
     * an input file.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return number of duplicates.
     */
    public double cardinalReformElectricEirsDuplicatesFile(String fileName) {
        // this function returns the cardinality of the duplicated Reformulated
        // Electric EIRs

        double value;
        // store the recorded ElectricEIR in a string array
        ArrayList<String> recordedReformElectricEirsStrings = new ArrayList<String>();

        for (Iterator<ReformElectricEIR> reformEirIterator = reformElectricsEirs
                .iterator(); reformEirIterator.hasNext();) {
            recordedReformElectricEirsStrings.add(reformEirIterator.next()
                    .toMoRecordString());
        }

        // remove any duplicates in the array;
        ArrayList<String> rmDuplicatesRecordedReformElectricEirsStrings = new ArrayList<String>();
        rmDuplicatesRecordedReformElectricEirsStrings = removeDuplicates(recordedReformElectricEirsStrings);

        // System.out.println
        // ("size of the electrisEirs after removing the duplicates " +
        // rmDuplicatesRecordedElectricEirsStrings.size());
        value = rmDuplicatesRecordedReformElectricEirsStrings.size()
                - reformElectricsEirs.size();

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
}
