package convertDXSingleDoubleSpeed;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

/**
 * This class is the parser used to get and store dx single speed cooling coils
 * data from an input file.
 *
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, October 05, 2012
 *
 */
public class Parser {

    /**
     * This is the main routine that finds and stores the DXSingleSpeeds in
     * arrays.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return DXSingleSpeed.
     * @exception FileNotFoundException
     *                when problems occur during file access.
     */

    public ParserResultObject parseFile(String fileName)
            throws FileNotFoundException {

        // define a new Result Object
        ParserResultObject result = new ParserResultObject();

        // read the entire Input file
        BufferedReader reader = new BufferedReader(new FileReader(fileName));

        String line = null;
        // define a list that stores the found DXSingleSpeed objects
        ArrayList<DXSingleSpeed> dxSingleSpeeds = new ArrayList<DXSingleSpeed>();
        DXSingleSpeed currentDXSingleSpeed = null;
        // define a list that stores the found DXDoubleSpeed objects
        ArrayList<DXDoubleSpeed> dxDoubleSpeeds = new ArrayList<DXDoubleSpeed>();
        DXDoubleSpeed currentDXDoubleSpeed = null;
        try {
            // read each lines of the file
            line = reader.readLine();
            String valueBlock = "";
            // skip the first 20 lines of the IDF
            for (int i = 0; i < 21; i++) {
                line = reader.readLine();
            }
            // read and store the information contain in the header file of the IDF file.
            for (int i = 0; i < 32; i++) {
                valueBlock += "    " + reader.readLine().trim() + "\n";
            }
            result.setGloHeaderStr(valueBlock);
           // System.out.println(valueBlock);

            while ((line = reader.readLine()) != null) {
                line = line.trim();

             // all 14 lines including the comments will be concatenated in this
                // variable

                // skip comments line and empty lines
                if (line.startsWith("!") || line.length() == 0) {
                    continue;
                }
                if (line.startsWith("Coil:Cooling:DX:SingleSpeed")) {
                    // read the current DXSingleSpeed
                    currentDXSingleSpeed = readCurrentDXSingleSpeed(line,
                            reader);
                    // add the Current DXSingleSpeed to the list of
                    // DXSingleSpeeds
                    dxSingleSpeeds.add(currentDXSingleSpeed);
                }
                if (line.startsWith("Coil:Cooling:DX:TwoStageWithHumidityControlMode")) {
                    // read the current DXDoubleSpeed
                    currentDXDoubleSpeed = readCurrentDXDoubleSpeed(line,
                            reader);
                    // add the Current DXDoubleSpeed to the list of
                    // DXDoubleSpeeds
                    dxDoubleSpeeds.add(currentDXDoubleSpeed);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        result.setFoundDXSingleSpeeds(dxSingleSpeeds);
        result.setFoundDXDoubleSpeeds(dxDoubleSpeeds);

        return result;
    }

    /**
     * This methods reads the current DXSingleSpeed.
     *
     * @param line
     *            current line in the input file.
     * @param reader
     *            buffered reader.
     * @return current DXSingleSpeed.
     * @exception IOException
     *                when problems occur during file access.
     */
    private DXSingleSpeed readCurrentDXSingleSpeed(String line,
            BufferedReader reader) throws IOException {

        // read the actual content of "Coil:Cooling:DX:SingleSpeed"
        DXSingleSpeed dxSingleSpeed = new DXSingleSpeed();

        // all 14 lines including the comments will be concatenated in this
        // variable
        String valueBlock = "";
        for (int i = 0; i < 14; i++) {
            valueBlock += "    " + reader.readLine().trim() + "\n";
        }
        // store the complete definition of the DXSingleSpeed in a String
        dxSingleSpeed.setStringDefinitionOfDXSingleSpeedObject(line + "\n"
                + valueBlock);

        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        ArrayList<String> dxSingleSpeedParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // get the parameters of the DXSingleSpeed
                dxSingleSpeedParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the parameters of the DXSingleSpeed
        setParametersToDXSingleSpeed(dxSingleSpeed, dxSingleSpeedParameters);

        int numberOfExpectedCurves = dxSingleSpeed.getFunctionNames().size();
        int index = 1;
        // get and add the functions that will be found.
        while (index <= numberOfExpectedCurves) {
            line = reader.readLine();
            if (line.trim().isEmpty() || line.startsWith("!")) {
                continue;
            }
            if (line.trim().startsWith("Curve:Biquadratic")) {
                // define a new BiQuadraticCurve
                BiQuadraticCurve curve = new BiQuadraticCurve();
                // read the parameters of the BiQuadraticCurve
                readBiquadraticCurveParameter(curve, reader);
                // add the BiQuadraticCurve to the list of curves
                dxSingleSpeed.getCurves().add(curve);

            }
            if (line.trim().startsWith("Curve:Quadratic")) {
                // define a new QuadraticCurve
                QuadraticCurve curve = new QuadraticCurve();
                // read the parameters of the QuadraticCurve
                readQuadraticCurveParameter(curve, reader);
                // add the QuadraticCurve to the list of curves
                dxSingleSpeed.getCurves().add(curve);
            }
            index++;
        }
        return dxSingleSpeed;
    }

    /**
     * This methods reads the current DXSingleSpeed.
     *
     * @param line
     *            current line in the input file.
     * @param reader
     *            buffered reader.
     * @return current DXSingleSpeed.
     * @exception IOException
     *                when problems occur during file access.
     */
    private DXCoilPerformance readCurrentDXCoilPerformance(String line,
            BufferedReader reader) throws IOException {

        // read the actual content of "Coil:Cooling:DX:SingleSpeed"
        DXCoilPerformance dxCoilPerformance = new DXCoilPerformance();

        // all 12 lines including the comments will be concatenated in this
        // variable
        String valueBlock = "";
        for (int i = 0; i < 12; i++) {
            valueBlock += "    " + reader.readLine().trim() + "\n";
        }
        // store the complete definition of the DXSingleSpeed in a String
        dxCoilPerformance.setStringDefinitionOfDXSingleSpeedObject(line + "\n"
                + valueBlock);

        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        ArrayList<String> dxCoilPerformanceParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // get the parameters of the DXCoilPerfromance
                dxCoilPerformanceParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the parameters of the DXCoilPerformance
        setParametersToDXCoilPerformance(dxCoilPerformance, dxCoilPerformanceParameters);

        return dxCoilPerformance;
    }



    /**
     * This methods reads the current DXDoubleSpeed.
     *
     * @param line
     *            current line in the input file.
     * @param reader
     *            buffered reader.
     * @return current DXDoubleSpeed.
     * @exception IOException
     *                when problems occur during file access.
     */
    private DXDoubleSpeed readCurrentDXDoubleSpeed(String line,
            BufferedReader reader) throws IOException {

        // read the actual content of "Coil:Cooling:DX:SingleSpeed"
        DXDoubleSpeed dxDoubleSpeed = new DXDoubleSpeed();
        DXCoilPerformance tmpDXCoilPerformance = new DXCoilPerformance();
        ArrayList<DXCoilPerformance> tmpDXCoilPerformances = new ArrayList<DXCoilPerformance>();

        // all 12 lines including the comments will be concatenated in this
        // variable
        String valueBlock = "";
        for (int i = 0; i < 12; i++) {
            valueBlock += "    " + reader.readLine().trim() + "\n";
        }
        // store the complete definition of the DXDoubleSpeed in a String
        dxDoubleSpeed.setStringDefinitionOfDXDoubleSpeedObject(line + "\n"
                + valueBlock);

        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        ArrayList<String> dxDoubleSpeedParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // get the parameters of the DXDoubleSpeed
                dxDoubleSpeedParameters.add(nextToken);
            }
        }
        // set the parameters of the DXDoubleSpeed
        setParametersToDXDoubleSpeed(dxDoubleSpeed, dxDoubleSpeedParameters);

        int index = 1;
        while (index <= 2) {
            line = reader.readLine();
            if (line.trim().isEmpty() || line.startsWith("!")) {
                continue;
            }
            if (line.trim().startsWith("CoilPerformance:DX:Cooling")) {
                tmpDXCoilPerformance = readCurrentDXCoilPerformance(line, reader);
                tmpDXCoilPerformances.add(tmpDXCoilPerformance);

            }
            index++;
        }

        dxDoubleSpeed.setFoundDXCoilPerformances(tmpDXCoilPerformances);

        index = 1;
        int numberOfExpectedCurves = 9;

        // get and add the functions that will be found.
        while (index <= numberOfExpectedCurves) {
            line = reader.readLine();
            if (line.trim().isEmpty() || line.startsWith("!")) {
                continue;
            }
            if (line.trim().startsWith("Curve:Biquadratic")) {
                // define a new BiQuadraticCurve
                BiQuadraticCurve curve = new BiQuadraticCurve();
                // read the parameters of the BiQuadraticCurve
                readBiquadraticCurveParameter(curve, reader);
                // add the BiQuadraticCurve to the list of curves
                dxDoubleSpeed.getCurves().add(curve);
            }
            if (line.trim().startsWith("Curve:Quadratic")) {
                // define a new QuadraticCurve
                QuadraticCurve curve = new QuadraticCurve();
                // read the parameters of the QuadraticCurve
                readQuadraticCurveParameter(curve, reader);
                // add the QuadraticCurve to the list of curves
                dxDoubleSpeed.getCurves().add(curve);
            }
            index++;
        }

        // System.out.println("Number of DXDoubleSpeed Curves "+dxDoubleSpeed.getCurves().size());
        return dxDoubleSpeed;
    }

    /**
     * This methods reads the current quadratic curve.
     *
     * @param curve
     *            current quadratic curve.
     * @param reader
     *            buffered reader.
     * @exception IOException
     *                when problems occur during file access.
     */
    private void readQuadraticCurveParameter(QuadraticCurve curve,
            BufferedReader reader) throws IOException {
        String valueBlock = "";
        // concatenate the parameters of the Quadratic curve in the variable
        // ValueBlock
        for (int i = 0; i < 6; i++) {
            valueBlock += reader.readLine().trim() + "\n";
        }
        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        // define a list containing the parameters of the curve
        ArrayList<String> curveParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // add the parameters of the curve to the list
                curveParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the quadratic curve parameters
        setQuadraticCurveParameters(curve, curveParameters);
    }

    /**
     * This routine calls a method to set the parameters of the quadratic curve.
     *
     * @param curve
     *            current quadratic curve.
     * @param curveParameters
     *            an array containing the curve parameters.
     */
    private void setQuadraticCurveParameters(QuadraticCurve curve,
            ArrayList<String> curveParameters) {

        for (int i = 0; i < curveParameters.size(); i++) {
            // get and add the parameters of each curve
            setQuadraticCurveParameter(i, curveParameters.get(i), curve);
        }
    }

    /**
     * This methods gets and sets the parameters of the quadratic curve.
     *
     * @param index
     *            the current index.
     * @param parameter
     *            the current parameter.
     * @param curve
     *            current quadratic curve.
     */
    void setQuadraticCurveParameter(int index, String parameter,
            QuadraticCurve curve) {

        switch (index) {
        case 0:
            curve.setName(parameter);
            break;
        case 1:
            curve.setCoef1(parameter);
            break;
        case 2:

            curve.setCoef2(parameter);
            break;
        case 3:
            curve.setCoef3(parameter);
            break;

        case 4:
            curve.setMinValX(parameter);
            break;
        case 5:
            curve.setMaxValX(parameter);
            break;

        default:
            break;
        }
    }

    /**
     * This methods reads the current biquadratic curve.
     *
     * @param curve
     *            current biquadratic curve.
     * @param reader
     *            buffered reader.
     * @exception IOException
     *                when problems occur during file access.
     */
    private void readBiquadraticCurveParameter(BiQuadraticCurve curve,
            BufferedReader reader) throws IOException {
        String valueBlock = "";
        // concatenate the parameters of the BiQuadratic curve in the variable
        // ValueBlock
        for (int i = 0; i < 16; i++) {
            valueBlock += reader.readLine().trim() + "\n";
        }
        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        // define a list containing the parameters of the curve
        ArrayList<String> curveParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // add the parameters of the curve to the list
                curveParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the biquadratic curve parameters
        setBiQuadraticCurveParameters(curve, curveParameters);

    }

    /**
     * This routine calls a method to set the parameters of the biquadratic
     * curve.
     *
     * @param curve
     *            current biquadratic curve.
     * @param curveParameters
     *            an array containing the curve parameters.
     */
    private void setBiQuadraticCurveParameters(BiQuadraticCurve curve,
            ArrayList<String> curveParameters) {

        for (int i = 0; i < curveParameters.size(); i++) {
            // get and add the parameters of each curve
            setBiQuadraticCurveParameter(i, curveParameters.get(i), curve);
        }
    }

    /**
     * This methods gets and sets the parameters of the biquadratic curve.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param curve
     *            current biquadratic curve.
     */
    void setBiQuadraticCurveParameter(int index, String parameter,
            BiQuadraticCurve curve) {

        switch (index) {
        case 0:
            curve.setName(parameter);
            break;
        case 1:
            curve.setCoef1(parameter);
            break;
        case 2:
            curve.setCoef2(parameter);
            break;
        case 3:
            curve.setCoef3(parameter);
            break;
        case 4:
            curve.setCoef4(parameter);
            break;
        case 5:
            curve.setCoef5(parameter);
            break;
        case 6:
            curve.setCoef6(parameter);
            break;
        case 7:
            curve.setMinValX(parameter);
            break;
        case 8:
            curve.setMaxValX(parameter);
            break;
        case 9:
            curve.setMinValY(parameter);
            break;
        case 10:
            curve.setMaxValY(parameter);
            break;

        default:
            break;
        }
    }
    /**
     * This routine calls a method to set the parameters of the DXCoilPerformance.
     *
     * @param dxCoilPerformance
     *            an object of type DXCoilPerformance.
     * @param dxSingleSpeedParameters
     *            an array containing the DXCoilPerformances parameters.
     */

    private void setParametersToDXCoilPerformance(DXCoilPerformance dxCoilPerformance,
            ArrayList<String> dxCoilPerformanceParameters) {

        for (int i = 0; i < dxCoilPerformanceParameters.size(); i++) {
            setParameterDXCoilPerformance(i, dxCoilPerformanceParameters.get(i),
                    dxCoilPerformance);
        }

    }

    /**
     * This routine calls a method to set the parameters of the DXSingleSpeed.
     *
     * @param dxSingleSpeed
     *            an object of type DXSingleSpeed.
     * @param dxSingleSpeedParameters
     *            an array containing the DXSingleSpeeds parameters.
     */

    private void setParametersToDXSingleSpeed(DXSingleSpeed dxSingleSpeed,
            ArrayList<String> dxSingleSpeedParameters) {

        for (int i = 0; i < dxSingleSpeedParameters.size(); i++) {
            setParameterDXSingleSpeed(i, dxSingleSpeedParameters.get(i),
                    dxSingleSpeed);
        }

    }

    /**
     * This routine calls a method to set the parameters of the DXDoubleSpeed.
     *
     * @param dxDoubleSpeed
     *            an object of type DXDoubleSpeed.
     * @param dxDoubleSpeedParameters
     *            an array containing the DXDoubleSpeeds parameters.
     */

    private void setParametersToDXDoubleSpeed(DXDoubleSpeed dxDoubleSpeed,
            ArrayList<String> dxDoubleSpeedParameters) {

        for (int i = 0; i < dxDoubleSpeedParameters.size(); i++) {
            setParameterDXDoubleSpeed(i, dxDoubleSpeedParameters.get(i),
                    dxDoubleSpeed);
        }

    }

    /**
     * This methods sets the parameters of the DXSingleSpeed.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param dxSingleSpeed
     *            object of type DXSingleSpeed.
     */
    void setParameterDXSingleSpeed(int index, String parameter,
            DXSingleSpeed dxSingleSpeed) {

        switch (index) {
        case 0:
            dxSingleSpeed.setName(parameter);
            break;
        case 1:
            //;
            break;
        case 2:
            dxSingleSpeed.setRatTotCooCapacity(parameter);
            break;
        case 3:
            dxSingleSpeed.setRatSenHeaRatio(parameter);
            break;
        case 4:
            dxSingleSpeed.setRatCOP(parameter);
            break;
        case 5:
            dxSingleSpeed.setRatAirFlowRate(parameter);
            break;
        case 6:
            dxSingleSpeed.setRatEvaFanPowPerVolFlowRate(parameter);
            break;
        case 7:
            //;
            break;
        case 8:
            //;
            break;
        case 9:
            dxSingleSpeed.getFunctionNames().add(parameter);
            break;
        case 10:
            dxSingleSpeed.getFunctionNames().add(parameter);
            break;
        case 11:
            dxSingleSpeed.getFunctionNames().add(parameter);
            break;
        case 12:
            dxSingleSpeed.getFunctionNames().add(parameter);
            break;
        case 13:
            dxSingleSpeed.getFunctionNames().add(parameter);
            break;
        default:
            break;
        }
    }

    /**
     * This methods sets the parameters of the DXCoilPerformance.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param dxSingleSpeed
     *            object of type DXCoilPerformance.
     */
    void setParameterDXCoilPerformance(int index, String parameter,
            DXCoilPerformance dxCoilPerformance) {

        switch (index) {
        case 0:
            dxCoilPerformance.setName(parameter);
            break;
        case 1:
            dxCoilPerformance.setRatTotCooCapacity(parameter);
            break;
        case 2:
            dxCoilPerformance.setRatSenHeaRatio(parameter);
            break;
        case 3:
            dxCoilPerformance.setRatCOP(parameter);
            break;
        case 4:
            dxCoilPerformance.setRatAirFlowRate(parameter);
            break;
        case 5:
            dxCoilPerformance.setFraAirFlow(parameter);
            break;
        case 6:
            dxCoilPerformance.getFunctionNames().add(parameter);
            break;
        case 7:
            dxCoilPerformance.getFunctionNames().add(parameter);
            break;
        case 8:
            dxCoilPerformance.getFunctionNames().add(parameter);
            break;
        case 9:
            dxCoilPerformance.getFunctionNames().add(parameter);
            break;
        case 10:
            dxCoilPerformance.getFunctionNames().add(parameter);
            break;
        default:
            break;
        }
    }

    /**
     * This methods sets the parameters of the DXDoubleSpeed.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param dxDoubleSpeed
     *            object of type DXDoubleSpeed.
     */
    void setParameterDXDoubleSpeed(int index, String parameter,
            DXDoubleSpeed dxDoubleSpeed) {

        switch (index) {
        case 0:
            dxDoubleSpeed.setName(parameter);
            break;
        case 1:
            //;
            break;
        case 3:
            //;
            break;
        case 4:
            //;
            break;
        case 5:
            //;
            break;
        case 6:
            //;
            break;
        case 7:
            //;
            break;
        case 8:
            //;
        case 9:
            //;
            break;
        default:
            break;
        }
    }
}
