package convertEIR;
import java.io.FileNotFoundException;
import java.io.IOException;


/**
 * This program converts chillers performance curves from <code>idf</code>
 * -format for EnergyPlus to <code>mo</code>-format for Modelica.
 * <p>
 *
 * To convert the performance curves, run this program as
 *
 * <pre>
 *      java -jar ConvertEIRData.jar inputFile.idf
 * </pre>
 *
 * where <code>inputFile</code> is an EnergyPlus IDF file in the
 * <code>idf</code>-format. This will produce two <code>.mo</code> files. If
 * duplicates exist in the input file, they will be removed and printed in the
 * <code>.txt</code> output files.
 *
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, October 10, 2010
 */
public class ConvertEIRData {

    /**
     * This is the main routine that starts the program.
     *
     */
    public static void main(String[] args) {

        if (args.length == 0) {
            printUsage();
            System.exit(1);
        }

        String fileName = args[0];

        // if users search for help information
        if (fileName.equals("-h")) {
            printUsage();
            System.exit(0);
        }

        // check the input file name
        if (!fileName.contains(".idf")) {
            System.err
                    .println("Name of performance curves file should end with \".idf\".");
            printUsage();
            System.exit(1);
        }

        // define a new parser object
        Parser parser = new Parser();
        try {
            ParserResultObject result = parser.parseFile(fileName);
            result.toMoElectricEirsFile("ElectricEIR.mo");
            if (result.cardinalElectricEirsDuplicatesFile(fileName) != 0) {
                // the report file will be generated only if they are duplicates
                // existing
                result.electricEirsDuplicates("ElectricEIR_Report.txt");
            }
            ;
            result.toMoReformElectricEirsFile("ElectricReformulatedEIR.mo");
            if (result.cardinalReformElectricEirsDuplicatesFile(fileName) != 0) {
                // the report file will be generated only if they are duplicates
                // existing
                result.reformElectricEirsDuplicates("ReformulatedElectricEIR_Report.txt");
            }
            ;
        } catch (FileNotFoundException e) {
            System.err.println("Expected input file not found.");
            System.err.println(e.getMessage());
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Error in read and write data.");
            System.err.println(e.getMessage());
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Error in read and write data.");
            System.err.println(e.getMessage());
            System.exit(1);
        }

    }

    /**
     * This method prints some help information to start the program.
     */
    static void printUsage() {

        System.out
                .println("To convert performance curves, run this program as");
        System.out.println("java -jar ConvertEIRData.jar inputFile.idf");
    }
}
