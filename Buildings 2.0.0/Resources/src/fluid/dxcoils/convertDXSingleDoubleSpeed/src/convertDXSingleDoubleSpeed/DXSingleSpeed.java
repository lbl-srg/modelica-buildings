package convertDXSingleDoubleSpeed;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import convertDXSingleDoubleSpeed.BiQuadraticCurve;

/**
 * This class represents a cooling coil from type "DXSingleSpeedR".
 *
 * <h3>License agreement</h3>
 *
 * The use of this program is subjected to the following <A
 * HREF="../../../../../../../legal.html">license terms</A>.
 *
 * @author <A HREF="mailto:TSNouidui@lbl.gov">Thierry Nouidui</A>
 * @version 1.0, November 20, 2012
 *
 */
public class DXSingleSpeed {

    private String name;
    private String ratTotCooCapacity;
    private String ratSenHeaRatio;
    private String ratCOP;
    private String ratAirFlowRate;
    private String ratEvaFanPowPerVolFlowRate;
    private ArrayList<String> functionNames = new ArrayList<String>();
    private ArrayList<ICurve> curves = new ArrayList<ICurve>();
    private String dxSingleSpeedSpecificParameters;
    private String stringHeaderBeginOfDXSingleSpeedObject;
    private String stringAnnotationOfDXSingleSpeedObjectBegin;
    private String stringDefinitionOfDXSingleSpeedObject;
    private String stringAnnotationOfDXSingleSpeedObjectEnd;
    private String CurveToString[] = new String[5];
    private List<String> evaporatorFluidTempMin = new ArrayList<String>();
    private List<String> evaporatorFluidTempMax = new ArrayList<String>();
    private List<String> condenserFluidTempMin = new ArrayList<String>();
    private List<String> condenserFluidTempMax = new ArrayList<String>();
    //private String floFractionMin;
    //private String floFractionMax;
    private List<String> floFractionMin = new ArrayList<String>();
    private List<String> floFractionMax = new ArrayList<String>();


    // private final static String LS = System.getProperty("line.separator");

    public DXSingleSpeed() {
    }

    /**
     * This method is used to convert single speed dx coils data into a String.
     *
     * @return the converted cooling coil data as a string.
     */
    public String toMoRecordString() {

        String format = "%1$-5s %2$-1s %3$-2s %4$-1s\n";
        stringHeaderBeginOfDXSingleSpeedObject = "  record  "
                + replaceTokenCharacter(name) + " =" + "\n"
                + "    Buildings.Fluid.HeatExchangers.DXCoils.Data.SingleSpeed.Generic(";

        stringAnnotationOfDXSingleSpeedObjectBegin = "annotation(\n"
        		+ "defaultComponentName=\"datCoi\",\n"
        		+ "defaultComponentPrefixes=\"parameter\",\n"
        		+ "Documentation(info=\"<html>"
                + "\n"
        		+ "<p>"
                + "Performance data for DX single speed cooling coil model."
                + "\n"
                + "This data corresponds to the following EnergyPlus model:"
                + "\n</p>\n" + "<pre>";

        stringAnnotationOfDXSingleSpeedObjectEnd = "</pre>" + "\n"
                + "</html>\"))" + ";";

        for (int i = 0; i < curves.size(); i++) {
            ICurve curve = curves.get(i);
            if (curve instanceof QuadraticCurve) {
                QuadraticCurve qCurve = (QuadraticCurve) curve;
                floFractionMin.add(qCurve.getMinValX());
                floFractionMax.add(qCurve.getMaxValX());
            }
            else if (curve instanceof BiQuadraticCurve)
            {
                BiQuadraticCurve biqCurve = (BiQuadraticCurve) curve;
                evaporatorFluidTempMin.add(biqCurve.getMinValX());
                evaporatorFluidTempMax.add(biqCurve.getMaxValX());
                condenserFluidTempMin.add(biqCurve.getMinValY());
                condenserFluidTempMax.add(biqCurve.getMaxValY());
            }
        }

        for (int i = 0; i < curves.size(); i++) {
            CurveToString[i] = curves.get(i).curveToString();
        }
        dxSingleSpeedSpecificParameters =
                String.format(format, "", "TConInMin", "=        ", "   "
                        + "273.15 + " + condenserFluidTempMin.get(0) + ",")
                + String.format(format, "", "TConInMax", "=        ", "   "
                        + "273.15 + " + condenserFluidTempMax.get(0) + ",")
                + String.format(format, "", "TEvaInMin", "=   ", "        "
                        + "273.15 + " + evaporatorFluidTempMin.get(0) + ",")
                + String.format(format, "", "TEvaInMax", "=   ", "        "
                        + "273.15 + " + evaporatorFluidTempMax.get(0) + ",")
                + String.format(format, "", "ffMin", "=         ", "      "
                        + floFractionMin.get(0) + ",")
                + String.format(format, "", "ffMax", "=         ", "      "
                        + floFractionMax.get(0) + "))})");
        return

        stringHeaderBeginOfDXSingleSpeedObject
                + "sta = {" + "\n"
                + "     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage(" + "spe=1800," + "\n"
                + "     nomVal = "
                + "Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues(" + "\n"
                + String.format(format, "", "Q_flow_nominal", "=      ", " "
                        + "-"+ ratTotCooCapacity + ",")
                + String.format(format, "", "COP_nominal", "=     ", "     "
                        + ratCOP + ",")
                + String.format(format, "", "SHR_nominal", "=      ", "    "
                        + ratSenHeaRatio + ",")
                + String.format(format, "", "m_flow_nominal", "=     ", "  "
                        + "1.2*" + ratAirFlowRate + "),")
                + "      perCur = " + "\n"
                + "      Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve(\n"
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
     * This method gets the rated evaporator fan Power per volume flow rate of the cooling coil.
     */
    public String getRatEvaFanPowPerVolFlowRate() {
        return ratEvaFanPowPerVolFlowRate;
    }

    /**
     * This method sets the rated evaporator fan Power per volume flow rate of the cooling coil.
     */
    public void setRatEvaFanPowPerVolFlowRate(String ratEvaFanPowPerVolFlowRate) {
        this.ratEvaFanPowPerVolFlowRate = ratEvaFanPowPerVolFlowRate;
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
