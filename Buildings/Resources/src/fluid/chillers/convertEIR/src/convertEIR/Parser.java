package convertEIR;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.*;

/**
 * This class is the parser used to get and store electric chillers from an
 * input file.
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
public class Parser {

    /**
     * This is the main routine that finds and stores the electric chillers in
     * arrays.
     *
     * @param fileName
     *            the EnergyPlus idf file name.
     * @return ElectricEIR, reformElectricEIR.
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
        // define a list that stores the found ElectricEIR objects
        ArrayList<ElectricEIR> eirs = new ArrayList<ElectricEIR>();
        ElectricEIR currentEir = null;

        // define a list that stores the found ReformulatedElectricEIR objects
        ArrayList<ReformElectricEIR> reformedEirs = new ArrayList<ReformElectricEIR>();
        ReformElectricEIR currentReformElectricEIR = null;

        try {
            // read each lines of the file
            line = reader.readLine();
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                // skip comments line and empty lines
                if (line.startsWith("!") || line.length() == 0) {
                    continue;
                }
                if (line.startsWith("Chiller:Electric:EIR")) {
                    // read the current ReformElectricEIR
                    currentEir = readCurrentElectricEIR(line, reader);
                    // add the Current ReformElectricEIR to the list of
                    // ReformElectricEIR
                    eirs.add(currentEir);
                }

                if (line.startsWith("Chiller:Electric:ReformulatedEIR")) {
                    // read the current ReformElectricEIR
                    currentReformElectricEIR = readCurrentReformElectricEIR(
                            line, reader);
                    // add the Current ReformElectricEIR to the list of
                    // ReformElectricEIR
                    reformedEirs.add(currentReformElectricEIR);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        result.setFoundElectricEIRs(eirs);
        result.setFoundReformElectricEIRs(reformedEirs);
        // System.out.println("Number of found ElectricEIR Objects " +
        // eirs.size());
        // System.out.println("Number of found ReformElectricEIR Objects " +
        // reformedEirs.size());
        return result;
    }

    /**
     * This methods reads the current ElectricEIR.
     *
     * @param line
     *            current line in the input file.
     * @param reader
     *            buffered reader.
     * @return current ElectricEIR.
     * @exception IOException
     *                when problems occur during file access.
     */
    private ElectricEIR readCurrentElectricEIR(String line,
            BufferedReader reader) throws IOException {

        // read the actual content of "Chiller:Electric:EIR"
        ElectricEIR eir = new ElectricEIR();

        // all 24 lines including the comments will be concatenated in this
        // variable
        String valueBlock = "";
        for (int i = 0; i < 24; i++) {
            valueBlock += "    " + reader.readLine().trim() + "\n";
        }
        // store the complete definition of the ElectricEIR in a String
        eir.setStringDefinitionOfElectricEIRObject(line + "\n" + valueBlock);

        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        ArrayList<String> eirParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // get the parameters of the ElectricEIR
                eirParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the parameters of the ElectricEIR
        setParametersToElectricEIR(eir, eirParameters);

        int numberOfExpectedCurves = eir.getFunctionNames().size();
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
                eir.getCurves().add(curve);

            }
            if (line.trim().startsWith("Curve:Quadratic")) {
                // define a new QuadraticCurve
                QuadraticCurve curve = new QuadraticCurve();
                // read the parameters of the QuadraticCurve
                readQuadraticCurveParameter(curve, reader);
                // add the QuadraticCurve to the list of curves
                eir.getCurves().add(curve);
            }
            index++;
        }
        // System.out.println("Number of Electric Curves "+eir.getCurves().size());
        return eir;
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
     * This methods reads the current reformulated ElectricEIR.
     *
     * @param line
     *            current line in the input file.
     * @param reader
     *            buffered reader.
     * @return current reformulated ElectricEIR.
     * @exception IOException
     *                when problems occur during file access.
     */
    private ReformElectricEIR readCurrentReformElectricEIR(String line,
            BufferedReader reader) throws IOException {

        // read the actual content of "Chiller:Electric:ReformulatedEIR"
        ReformElectricEIR reir = new ReformElectricEIR();
        // all 23 lines including the comments will be concatenated in this
        // variable
        String valueBlock = "";
        for (int i = 0; i < 22; i++) {
            valueBlock += "    " + reader.readLine().trim() + "\n";
        }
        reir.setStringDefinitionOfReformElectricEIRObject(line + "\n"
                + valueBlock);

        StringTokenizer tokenizer = new StringTokenizer(valueBlock, ",\"\n\";");
        ArrayList<String> reirParameters = new ArrayList<String>();
        while (tokenizer.hasMoreTokens()) {
            String nextToken = tokenizer.nextToken().trim();
            if (nextToken.endsWith(";")) {
                nextToken = nextToken.substring(0, nextToken.length() - 2);
            }
            if (nextToken.startsWith("!")) {
                continue;
            } else {
                // get the parameters of the ReformElectricEIR
                reirParameters.add(nextToken);
                // System.out.println(nextToken);
            }
        }
        // set the parameters of the ReformElectricEIR
        setParametersToReformElectricEIR(reir, reirParameters);

        int numberOfExpectedCurves = reir.getFunctionNames().size();
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
                reir.getCurves().add(curve);

            }
            if (line.trim().startsWith("Curve:Bicubic")) {
                // define a new BiCubicCurve
                BiCubicCurve curve = new BiCubicCurve();
                // read the parameters of the BiCubicCurve
                readBiCubicCurveParameter(curve, reader);
                // add the BicCubicCurve to the list of curves
                reir.getCurves().add(curve);
            }
            index++;
        }
        // System.out.println("Number of ReformulatedElectric Curves "+
        // reir.getCurves().size());
        return reir;
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
        for (int i = 0; i < 12; i++) {
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
     * This methods reads the current bicubic curve.
     *
     * @param curve
     *            current bicubic curve.
     * @param reader
     *            buffered reader.
     * @exception IOException
     *                when problems occur during file access.
     */
    private void readBiCubicCurveParameter(BiCubicCurve curve,
            BufferedReader reader) throws IOException {
        String valueBlock = "";
        // concatenate the parameters of the Quadratic curve in the variable
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
        // set the bicubic curve parameters
        setBiCubicCurveParameters(curve, curveParameters);
    }

    /**
     * This routine calls a method to set the parameters of the bicubic curve.
     *
     * @param curve
     *            current bicubic curve.
     * @param curveParameters
     *            an array containing the curve parameters.
     */
    private void setBiCubicCurveParameters(BiCubicCurve curve,
            ArrayList<String> curveParameters) {

        for (int i = 0; i < curveParameters.size(); i++) {
            // get and add the parameters of each curve
            setBiCubicCurveParameter(i, curveParameters.get(i), curve);
        }
    }

    /**
     * This methods gets and sets the parameters of the bicubic curve.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param curve
     *            current bicubic curve.
     */
    void setBiCubicCurveParameter(int index, String parameter,
            BiCubicCurve curve) {

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
            curve.setCoef7(parameter);
            break;
        case 8:
            curve.setCoef8(parameter);
            break;
        case 9:
            curve.setCoef9(parameter);
            break;
        case 10:
            curve.setCoef10(parameter);
            break;
        case 11:
            curve.setMinValX(parameter);
            break;
        case 12:
            curve.setMaxValX(parameter);
            break;
        case 13:
            curve.setMinValY(parameter);
            break;
        case 14:
            curve.setMaxValY(parameter);
            break;

        default:
            break;
        }
    }

    /**
     * This routine calls a method to set the parameters of the ElectricEIR.
     *
     * @param eir
     *            an object of type ElectricEIR.
     * @param eirParameters
     *            an array containing the ElectricEIRs parameters.
     */

    private void setParametersToElectricEIR(ElectricEIR eir,
            ArrayList<String> eirParameters) {

        for (int i = 0; i < eirParameters.size(); i++) {
            setParameterEIR(i, eirParameters.get(i), eir);
        }

    }

    /**
     * This routine calls a method to set the parameters of the reformulated
     * ElectricEIR.
     *
     * @param reir
     *            and object of type reformulated ElectricEIR.
     * @param reirParameters
     *            an array containing the reformulated ElectricEIR parameters.
     */

    private void setParametersToReformElectricEIR(ReformElectricEIR reir,
            ArrayList<String> reirParameters) {

        for (int i = 0; i < reirParameters.size(); i++) {
            setParameterReformEIR(i, reirParameters.get(i), reir);
        }

    }

    /**
     * This methods sets the parameters of the ElectricEIR.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param eir
     *            object of type ElectricEIR.
     */
    void setParameterEIR(int index, String parameter, ElectricEIR eir) {

        switch (index) {
        case 0:
            eir.setName(parameter);
            break;
        case 1:
            eir.setRefCapacity(parameter);
            break;
        case 2:
            eir.setRefCop(parameter);
            break;
        case 3:
            eir.setRefLeavingChilledWaterTemp(parameter);
            break;
        case 4:
            eir.setRefEnteringCondenserFluidTemp(parameter);
            break;
        case 5:
            eir.setRefChilledWaterFlowRate(parameter);
            break;
        case 6:
            eir.setRefCondenserWaterFlowRate(parameter);
            break;
        case 7:
            eir.getFunctionNames().add(parameter);
            break;
        case 8:
            eir.getFunctionNames().add(parameter);
            break;
        case 9:
            eir.getFunctionNames().add(parameter);
            break;
        case 10:
            eir.setMinPLR(parameter);
            break;
        case 11:
            eir.setMaxPLR(parameter);
            break;
        case 12:
            eir.setOptPLR(parameter);

        case 13:
            eir.setMinULR(parameter);
            break;
        case 14:
            //
            break;
        case 15:
            //
            break;
        case 16:
            //
            break;
        case 17:
            //
            break;
        case 18:
            //
            break;
        case 19:
            //
        case 20:
            eir.setCompMotorEfficiency(parameter);
            break;
        case 21:
            //
            break;
        case 22:
            //
            break;
        case 23:
            //
            break;
        default:
            break;
        }
    }

    /**
     * This methods sets the parameters of the reformulated ElectricEIR.
     *
     * @param index
     *            current index.
     * @param parameter
     *            current parameter.
     * @param reir
     *            object of type reformulated ElectricEIR.
     */
    void setParameterReformEIR(int index, String parameter,
            ReformElectricEIR reir) {

        switch (index) {
        case 0:
            reir.setName(parameter);
            break;
        case 1:
            reir.setRefCapacity(parameter);
            break;
        case 2:
            reir.setRefCop(parameter);
            break;
        case 3:
            reir.setRefLeavingChilledWaterTemp(parameter);
            break;
        case 4:
            reir.setRefLeavingCondenserFluidTemp(parameter);
            break;
        case 5:
            reir.setRefChilledWaterFlowRate(parameter);
            break;
        case 6:
            reir.setRefCondenserWaterFlowRate(parameter);
            break;
        case 7:
            reir.getFunctionNames().add(parameter);
            break;
        case 8:
            reir.getFunctionNames().add(parameter);
            break;
        case 9:
            reir.getFunctionNames().add(parameter);
            break;
        case 10:
            reir.setMinPLR(parameter);
            break;
        case 11:
            reir.setMaxPLR(parameter);
            break;
        case 12:
            reir.setOptPLR(parameter);

        case 13:
            reir.setMinULR(parameter);
            break;
        case 14:
            //
            break;
        case 15:
            //
            break;
        case 16:
            //
            break;
        case 17:
            //
            break;
        case 18:
            reir.setCompMotorEfficiency(parameter);
            break;
        case 19:
            //
        case 20:
            //
            break;
        case 21:
            //
            break;
        case 22:
            //
            break;
        case 23:
            //
            break;
        default:
            break;
        }
    }
}
