package convertDXSingleDoubleSpeed;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import convertDXSingleDoubleSpeed.BiQuadraticCurve;

/**
 * This class represents a cooling coil from type "DXDoubleSpeed".
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
public class DXDoubleSpeed {

    private String name;
    private List<String> sname = new ArrayList<String>();
    private List<String> sratTotCooCapacity = new ArrayList<String>();
    private List<String> sratSenHeaRatio = new ArrayList<String>();
    private List<String> sratCOP = new ArrayList<String>();
    private List<String> sratAirFlowRate = new ArrayList<String>();
    private ArrayList<ICurve> curves = new ArrayList<ICurve>();
    private List<String> dxDoubleSpeedSpecificParameters = new ArrayList<String>();;
    private String stringHeaderBeginOfDXDoubleSpeedObject;
    private String stringAnnotationOfDXDoubleSpeedObjectBegin;
    private String stringDefinitionOfDXDoubleSpeedObject;
    private String stringAnnotationOfDXDoubleSpeedObjectEnd;
    private String CurveToString[] = new String[9];
    private List<String> sevaporatorFluidTempMin = new ArrayList<String>();
    private List<String> sevaporatorFluidTempMax = new ArrayList<String>();
    private List<String> scondenserFluidTempMin = new ArrayList<String>();
    private List<String> scondenserFluidTempMax = new ArrayList<String>();
    private List<String> sfloFractionMin = new ArrayList<String>();
    private List<String> sfloFractionMax = new ArrayList<String>();

    private ArrayList<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformances;

    // private final static String LS = System.getProperty("line.separator");

    public DXDoubleSpeed() {
    }

    /**
     * This method sets the found dx coils performance in an array.
     *
     * @param tmpDXCoilPerformances
     *            array list of DXCoilPerformances.
     */

    public void setFoundDXCoilPerformances(
            ArrayList<convertDXSingleDoubleSpeed.DXCoilPerformance> tmpDXCoilPerformances) {

        dxCoilPerformances = tmpDXCoilPerformances;
    }

    /**
     * This method is used to convert single speed dx coils data into a String.
     *
     * @return the converted cooling coil data as a string.
     */
    public String toMoRecordString() {

        String format = "%1$-5s %2$-1s %3$-2s %4$-1s\n";
        stringHeaderBeginOfDXDoubleSpeedObject = "  record  "
                + replaceTokenCharacter(name)
                + " ="
                + "\n"
                + "    Buildings.Fluid.HeatExchangers.DXCoils.Data.DoubleSpeed.Generic(";

        stringAnnotationOfDXDoubleSpeedObjectBegin = "annotation(\n"
        		+ "defaultComponentName=\"datCoi\",\n"
        		+ "defaultComponentPrefixes=\"parameter\",\n"
        		+ "Documentation(info=\"<html>"
                + "\n"
        		+ "<p>\n"
                + "Performance data for double speed cooling coil model."
                + "\n"
                + "This data corresponds to the following EnergyPlus model:"
                + "</p>\n" + "<pre>";

        stringAnnotationOfDXDoubleSpeedObjectEnd = "</pre>" + "\n"
                + "</html>\"))" + ";";

        // get the single speeds cooling coils data found
        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {

            sname.add(dxCoilPerformanceIterator.next().getName());

        }
        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {
            sratTotCooCapacity.add(dxCoilPerformanceIterator.next()
                    .getRatTotCooCapacity());
        }

        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {

            sratSenHeaRatio.add(dxCoilPerformanceIterator.next()
                    .getRatSenHeaRatio());
        }
        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {

            sratCOP.add(dxCoilPerformanceIterator.next().getRatCOP());
        }
        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {

            sratAirFlowRate.add(dxCoilPerformanceIterator.next()
                    .getRatAirFlowRate());
        }

        for (Iterator<convertDXSingleDoubleSpeed.DXCoilPerformance> dxCoilPerformanceIterator = dxCoilPerformances
                .iterator(); dxCoilPerformanceIterator.hasNext();) {

            sratAirFlowRate.add(dxCoilPerformanceIterator.next()
                    .getRatAirFlowRate());
        }

        for (int i = 0; i < curves.size(); i++) {
            ICurve curve = curves.get(i);
            if (curve instanceof QuadraticCurve) {
                QuadraticCurve qCurve = (QuadraticCurve) curve;
                sfloFractionMin.add(qCurve.getMinValX());
                sfloFractionMax.add(qCurve.getMaxValX());

            } else if (curve instanceof BiQuadraticCurve) {
                BiQuadraticCurve biqCurve = (BiQuadraticCurve) curve;
                sevaporatorFluidTempMin.add(biqCurve.getMinValX());
                sevaporatorFluidTempMax.add(biqCurve.getMaxValX());
                scondenserFluidTempMin.add(biqCurve.getMinValY());
                scondenserFluidTempMax.add(biqCurve.getMaxValY());
            }
        }

        for (int i = 0; i < curves.size(); i++) {
            CurveToString[i] = curves.get(i).curveToString();
        }

        // custom parameters for each first performance data
        dxDoubleSpeedSpecificParameters.add(String.format(format, "",
                "TConInMin", "=        ", "   " + "273.15 + "
                        + scondenserFluidTempMin.get(0) + ",")
                + String.format(format, "", "TConInMax", "=        ", "   "
                        + "273.15 + " + scondenserFluidTempMax.get(0) + ",")
                + String.format(format, "", "TEvaInMin", "=   ", "        "
                        + "273.15 + " + sevaporatorFluidTempMin.get(0) + ",")
                + String.format(format, "", "TEvaInMax", "=   ", "        "
                        + "273.15 + " + sevaporatorFluidTempMax.get(0) + ",")
                + String.format(format, "", "ffMin", "=         ", "      "
                        + sfloFractionMin.get(0) + ",")
                + String.format(format, "", "ffMax", "=         ", "      "
                        + sfloFractionMax.get(0) + ")),"));
        // custom parameters for each first performance data
        dxDoubleSpeedSpecificParameters.add(String.format(format, "",
                "TConInMin", "=        ", "   " + "273.15 + "
                        + scondenserFluidTempMin.get(2) + ",")
                + String.format(format, "", "TConInMax", "=        ", "   "
                        + "273.15 + " + scondenserFluidTempMax.get(2) + ",")
                + String.format(format, "", "TEvaInMin", "=   ", "        "
                        + "273.15 + " + sevaporatorFluidTempMin.get(2) + ",")
                + String.format(format, "", "TEvaInMax", "=   ", "        "
                        + "273.15 + " + sevaporatorFluidTempMax.get(2) + ",")
                + String.format(format, "", "ffMin", "=         ", "      "
                        + sfloFractionMin.get(2) + ",")
                + String.format(format, "", "ffMax", "=         ", "      "
                        + sfloFractionMax.get(2) + "))"));

        return stringHeaderBeginOfDXDoubleSpeedObject
                + "sta = {"
                + "\n"
                + "     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage("
                + "spe = 1200,"
                + "\n"
                + "     nomVal = "
                + "Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues("
                + "\n"
                + String.format(format, "", "Q_flow_nominal", "=      ", " "
                        + "-" + sratTotCooCapacity.get(0) + ",")
                + String.format(format, "", "COP_nominal", "=     ", "     "
                        + sratCOP.get(0) + ",")
                + String.format(format, "", "SHR_nominal", "=      ", "    "
                        + sratSenHeaRatio.get(0) + ",")
                + String.format(format, "", "m_flow_nominal", "=     ", "  "
                        + "1.2*"+ sratAirFlowRate.get(0) + "),")
                + "      perCur = "
                + "\n"
                + "     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve( "
                + "\n"
                + String.format(format, "", "capFunT", "=  ", "           "
                        + CurveToString[0] + ",")
                + String.format(format, "", "capFunFF", "= ", "           "
                        + CurveToString[2] + ",")
                + String.format(format, "", "EIRFunT", "=    ", "         "
                        + CurveToString[1] + ",")
                + String.format(format, "", "EIRFunFF", "=   ", "         "
                        + CurveToString[3] + ",")
                + dxDoubleSpeedSpecificParameters.get(0)
                + "     Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.Stage("
                + "spe = 1200*"
                + sratTotCooCapacity.get(1)
                + "/"
                + sratTotCooCapacity.get(0)
                + ","
                + "\n"
                + "     nomVal = "
                + "Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues("
                + "\n"
                + String.format(format, "", "Q_flow_nominal", "=      ", " "
                        + "-" + sratTotCooCapacity.get(1) + ",")
                + String.format(format, "", "COP_nominal", "=     ", "     "
                        + sratCOP.get(1) + ",")
                + String.format(format, "", "SHR_nominal", "=      ", "    "
                        + sratSenHeaRatio.get(1) + ",")
                + String.format(format, "", "m_flow_nominal", "=     ", "  "
                        + "1.2*" + sratAirFlowRate.get(1) + "),")
                + "      perCur = "
                + "\n"
                + "      "
                + "   Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.PerformanceCurve( "
                + "\n"
                + String.format(format, "", "capFunT", "=  ", "           "
                        + CurveToString[4] + ",")
                + String.format(format, "", "capFunFF", "= ", "           "
                        + CurveToString[6] + ",")
                + String.format(format, "", "EIRFunT", "=    ", "         "
                        + CurveToString[5] + ",")
                + String.format(format, "", "EIRFunFF", "=   ", "         "
                        + CurveToString[7] + ",")
                + dxDoubleSpeedSpecificParameters.get(1) + "})" + "\"" + name
                + "\"" + "\n" + stringAnnotationOfDXDoubleSpeedObjectBegin
                + "\n" + stringDefinitionOfDXDoubleSpeedObject
                + stringAnnotationOfDXDoubleSpeedObjectEnd + "\n";
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
    public String getStringDefinitionOfDXDoubleSpeedObject() {
        return stringDefinitionOfDXDoubleSpeedObject;
    }

    /**
     * This method sets the comments definition of the cooling coil.
     */
    public void setStringDefinitionOfDXDoubleSpeedObject(
            String stringDefinitionOfDXDoubleSpeedObject) {
        this.stringDefinitionOfDXDoubleSpeedObject = stringDefinitionOfDXDoubleSpeedObject;
    }

    /**
     * this method is used to removed token strings from the name of the cooling
     * coil and to print it in a format that can be used in Modelica.
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
