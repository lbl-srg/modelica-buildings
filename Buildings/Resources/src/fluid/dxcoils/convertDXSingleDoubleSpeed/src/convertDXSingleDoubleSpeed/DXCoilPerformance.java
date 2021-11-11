package convertDXSingleDoubleSpeed;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.StringTokenizer;

import convertDXSingleDoubleSpeed.BiQuadraticCurve;

/**
 * This class represents the performance data for a double stage cooling coils.
 * This call is slightly different from the single speed class.
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, November 20, 2012
 *
 */
public class DXCoilPerformance {

    private String name;
    private String ratTotCooCapacity;
    private String ratSenHeaRatio;
    private String ratCOP;
    private String ratAirFlowRate;
    private String fraAirFlow;
    private ArrayList<String> functionNames = new ArrayList<String>();
    private ArrayList<ICurve> curves = new ArrayList<ICurve>();
    private String dxSingleSpeedSpecificParameters;
    private String stringHeaderBeginOfDXSingleSpeedObject;
    private String stringAnnotationOfDXSingleSpeedObjectBegin;
    private String stringDefinitionOfDXSingleSpeedObject;
    private String stringAnnotationOfDXSingleSpeedObjectEnd;
    private String CurveToString[] = new String[5];
    private String evaporatorFluidTempMin;
    private String evaporatorFluidTempMax;
    private String condenserFluidTempMin;
    private String condenserFluidTempMax;
    private String floFractionMin;
    private String floFractionMax;


    // private final static String LS = System.getProperty("line.separator");

    public DXCoilPerformance() {
    }

    /**
     * This method is used to convert performance data of dx coils data into a String.
     *
     * @return the converted cooling coil data as a string.
     */
    public String toMoRecordString() {

        String format = "%1$-5s %2$-1s %3$-2s %4$-1s\n";
        stringHeaderBeginOfDXSingleSpeedObject = "  record  "
                + replaceTokenCharacter(name) + " =" + "\n"
                + "    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic (";

        stringAnnotationOfDXSingleSpeedObjectBegin = "annotation (Documentation(info=\"<html>"
                + "\n"
                + "Performance data for dx single speed cooling coil model."
                + "\n"
                + "This data corresponds to the following EnergyPlus model:"
                + "\n" + "<pre>";

        stringAnnotationOfDXSingleSpeedObjectEnd = "</pre>" + "\n"
                + "</html>\"))" + ";";

        for (int i = 0; i < curves.size(); i++) {
            ICurve curve = curves.get(i);
            if (curve instanceof QuadraticCurve) {
                QuadraticCurve qCurve = (QuadraticCurve) curve;
                floFractionMin = qCurve.getMinValX();
                floFractionMax = qCurve.getMaxValX();
            }
            else if (curve instanceof BiQuadraticCurve)
            {
                BiQuadraticCurve biqCurve = (BiQuadraticCurve) curve;
                evaporatorFluidTempMin    = biqCurve.getMinValX();
                evaporatorFluidTempMax    = biqCurve.getMaxValX();
                condenserFluidTempMin     = biqCurve.getMinValY();
                condenserFluidTempMax     = biqCurve.getMaxValY();
            }
        }

        for (int i = 0; i < curves.size(); i++) {
            CurveToString[i] = curves.get(i).curveToString();
        }
        dxSingleSpeedSpecificParameters =
                String.format(format, "", "TConInMin", "=        ", "   "
                        + "273.15 + " + condenserFluidTempMin + ",")
                + String.format(format, "", "TConInMax", "=        ", "   "
                        + "273.15 + " + condenserFluidTempMax + ",")
                + String.format(format, "", "TEvaInMin", "=   ", "        "
                        + "273.15 + " + evaporatorFluidTempMin + ",")
                + String.format(format, "", "TEvaInMax", "=   ", "        "
                        + "273.15 + " + evaporatorFluidTempMax + ",")
                + String.format(format, "", "ffMin", "=         ", "      "
                        + floFractionMin + ",")
                + String.format(format, "", "ffMax", "=         ", "      "
                        + floFractionMax + "))})");
        return

        stringHeaderBeginOfDXSingleSpeedObject
                + "per = {" + "\n"
                + "     Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.Generic(" + "\n"
                + "     nomVal = "
                + "Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues(" + "\n"
                + String.format(format, "", "Q_flow_nominal", "=      ", " "
                        + ratTotCooCapacity + ",")
                + String.format(format, "", "COP_nominal", "=     ", "     "
                        + ratCOP + ",")
                + String.format(format, "", "SHR_nominal", "=      ", "    "
                        + ratSenHeaRatio + ",")
                + String.format(format, "", "m_flow_nominal", "=     ", "  "
                        + ratAirFlowRate + "),")
                + "      perCur = " + "\n"
                + "      Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.BaseClasses.Generic( " + "\n"
                + String.format(format, "", "capFunT", "=  ", "           "
                        + CurveToString[0] + ",")
                + String.format(format, "", "capFunFF", "= ", "           "
                        + CurveToString[2] + ",")
                + String.format(format, "", "EIRFunT", "=    ", "         "
                        + CurveToString[1] + ",")
                + String.format(format, "", "EIRFunFF", "=   ", "         "
                        + CurveToString[3] + ",")
                + dxSingleSpeedSpecificParameters
                + "\"" + name + "\""
                + "\n" + stringAnnotationOfDXSingleSpeedObjectBegin + "\n"
                + stringDefinitionOfDXSingleSpeedObject
                + stringAnnotationOfDXSingleSpeedObjectEnd + "\n";
    }
    /**
     * This method gets the name of the cooling coil.
     */
    public String getName() {
        return name;
    }

    /**
     * This method sets the name of the cooling coil.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * This method gets the rated total cooling capacity of the cooling coil.
     */
    public String getRatTotCooCapacity() {
        return ratTotCooCapacity;
    }

    /**
     * This method sets the rated total cooling capacity of the cooling coil.
     */
    public void setRatTotCooCapacity(String ratTotCooCapacity) {
        this.ratTotCooCapacity = ratTotCooCapacity;
    }

    /**
     * This method gets the rated sensible heat ratio of the cooling coil.
     */
    public String getRatSenHeaRatio() {
        return ratSenHeaRatio;
    }

    /**
     * This method sets the rated sensible heat ratio of the cooling coil.
     */
    public void setRatSenHeaRatio(String ratSenHeaRatio) {
        this.ratSenHeaRatio = ratSenHeaRatio;
    }

    /**
     * This method gets the reference COP of the cooling coil.
     */
    public String getRatCOP() {
        return ratCOP;
    }

    /**
     * This method sets the reference COP of the cooling coil.
     */
    public void setRatCOP(String ratCOP) {
        this.ratCOP = ratCOP;
    }

    /**
     * This method gets the rated air flow of the cooling coil.
     */

    public String getRatAirFlowRate() {
        return ratAirFlowRate;
    }

    /**
     * This method sets the rated air flow of the cooling coil.
     */

    public void setRatAirFlowRate(String ratAirFlowRate) {
        this.ratAirFlowRate = ratAirFlowRate;
    }

    /**
     * This method gets the fraction of air flow bypassed around the coil.
     */
    public String getFraAirFlow() {
        return fraAirFlow;
    }

    /**
     * This method sets the fraction of air flow bypassed around the coil.
     */
    public void setFraAirFlow(String fraAirFlow) {
        this.fraAirFlow = fraAirFlow;
    }

    /**
     * This method gets the functions names of the cooling coil.
     */
    public ArrayList<String> getFunctionNames() {
        return functionNames;
    }

    /**
     * This method sets the functions names of the cooling coil.
     */
    public void setFunctionNames(ArrayList<String> functionNames) {
        this.functionNames = functionNames;
    }

    /**
     * This method gets the curves describing the cooling coil.
     */
    public ArrayList<ICurve> getCurves() {
        return curves;
    }

    /**
     * This method sets the curves describing the cooling coil.
     */
    public void setCurves(ArrayList<ICurve> curves) {
        this.curves = curves;
    }

    /**
     * This method gets the comments definition of the cooling coil.
     */
    public String getStringDefinitionOfDXSingleSpeedObject() {
        return stringDefinitionOfDXSingleSpeedObject;
    }

    /**
     * This method sets the comments definition of the cooling coil.
     */
    public void setStringDefinitionOfDXSingleSpeedObject(
            String stringDefinitionOfDXSingleSpeedObject) {
        this.stringDefinitionOfDXSingleSpeedObject = stringDefinitionOfDXSingleSpeedObject;
    }

    /**
     * this method is used to removed token strings from the name of the cooling coil
     * and to print it in a format that can be used in Modelica.
     *
     * @param name
     *            input string.
     * @return name without token strings.
     */
    static String replaceTokenCharacter(String name) {
        String result = "";
        String delimiters = "&-/. ";
        StringTokenizer st = new StringTokenizer(name, delimiters);
        while (st.hasMoreTokens()) {
            result += st.nextToken() + "_";
        }
        return result.substring(0, result.length() - 1);
    }


    /**
     * This method converts a string in a float.
     *
     * @param number
     *            string value.
     *
     * @return float value.
     */
    static float getFloat(String number) {

        float retNumber = 0.0f;
        retNumber = Float.parseFloat(number.trim());
        return retNumber;
    }

    /**
     * This method rounds a double to four decimals.
     *
     * @param d
     *            double value.
     *
     * @return double rounded value.
     */
    static double roundFourDecimals(double d) {
        DecimalFormat fourDForm = new DecimalFormat("#.####");
        return Double.valueOf(fourDForm.format(d));
    }
}
