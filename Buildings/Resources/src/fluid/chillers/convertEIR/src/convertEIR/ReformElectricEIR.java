package convertEIR;

import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * This class represents a chiller from type "reformulated ElectricEIR".
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
public class ReformElectricEIR {

    private String name;
    private String refCapacity;
    private String refCop;
    private String minPLR;
    private String maxPLR;
    private String optPLR;
    private String minULR;
    private ArrayList<String> functionNames = new ArrayList<String>();
    private ArrayList<ICurve> curves = new ArrayList<ICurve>();
    private String refLeavingChilledWaterTemp;
    private String refLeavingCondenserFluidTemp;
    private String refChilledWaterFlowRate;
    private String refCondenserWaterFlowRate;
    private String compMotorEfficiency;
    private String eirSpecificParameters;
    private String stringHeaderBeginOfReformElectricEIRObject;
    private String stringAnnotationOfReformElectricEIRObjectBegin;
    private String stringDefinitionOfReformElectricEIRObject;
    private String stringAnnotationOfReformElectricEIRObjectEnd;
    private String getMinValX;
    private String getMaxValX;
    private String getMinValY;
    private String getMaxValY;
    private String CurveToString[] = new String[3];

    /**
     * This method is used to convert chillers data into a String.
     *
     * @return the converted chillers data as a string.
     */
    public String toMoRecordString() {
        String format = "%1$-5s %2$-1s %3$-2s %4$-1s\n";
        stringHeaderBeginOfReformElectricEIRObject = "  record "
                + replaceTokenCharacter(name)
                + " ="
                + "\n"
                + "    Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic(";

        stringAnnotationOfReformElectricEIRObjectBegin = "annotation(\n"
        		+ "defaultComponentName=\"datChi\",\n"
        		+ "defaultComponentPrefixes=\"parameter\",\n"
        		+ "Documentation(info=\"<html>"
                + "\n"
                + "Performance data for chiller model."
                + "\n"
                + "This data corresponds to the following EnergyPlus model:"
                + "\n" + "<pre>";

        stringAnnotationOfReformElectricEIRObjectEnd = "</pre>" + "\n"
                + "</html>\"))" + ";";

        for (int i = 0; i < curves.size(); i++) {
            ICurve curve = curves.get(i);
            if (curve instanceof BiQuadraticCurve) {
                BiQuadraticCurve biqCurve = (BiQuadraticCurve) curve;
                getMinValX = biqCurve.getMinValX();
                getMaxValX = biqCurve.getMaxValX();
                getMinValY = biqCurve.getMinValY();
                getMaxValY = biqCurve.getMaxValY();

            }
        }
        for (int i = 0; i < curves.size(); i++) {
            CurveToString[i] = curves.get(i).curveToString();
        }

        eirSpecificParameters = String.format(format, "", "mEva_flow_nominal",
                "=", " " + "1000 * " + refChilledWaterFlowRate + ",")
                + String.format(format, "", "mCon_flow_nominal", "=", " "
                        + "1000 * " + refCondenserWaterFlowRate + ",")
                + String.format(format, "", "TEvaLvg_nominal", "=", "   "
                        + "273.15 + " + refLeavingChilledWaterTemp + ",")
                + String.format(format, "", "TConLvg_nominal", "=", "   "
                        + "273.15 + " + refLeavingCondenserFluidTemp + ",")
                + String.format(format, "", "TEvaLvgMin", "=", "        "
                        + "273.15 + " + getMinValX + ",")
                + String.format(format, "", "TEvaLvgMax", "=", "        "
                        + "273.15 + " + getMaxValX + ",")
                + String.format(format, "", "TConLvgMin", "=", "        "
                        + "273.15 + " + getMinValY + ",")
                + String.format(format, "", "TConLvgMax", "=", "        "
                        + "273.15 + " + getMaxValY + ",");

        return

        stringHeaderBeginOfReformElectricEIRObject
                + "\n"
                + String.format(format, "", "QEva_flow_nominal", "=", "-"
                        + refCapacity + ",")
                + String.format(format, "", "COP_nominal", "=", "       "
                        + refCop + ",")
                + String.format(format, "", "PLRMin", "=", "            "
                        + minPLR + ",")
                + String.format(format, "", "PLRMinUnl", "=", "         "
                        + minULR + ",")
                + String.format(format, "", "PLRMax", "=", "            "
                        + maxPLR + ",")
                + eirSpecificParameters
                + String.format(format, "", "capFunT", "=", "           "
                        + CurveToString[0] + ",")
                + String.format(format, "", "EIRFunT", "=", "           "
                        + CurveToString[1] + ",")
                + String.format(format, "", "EIRFunPLR", "=", "         "
                        + CurveToString[2] + ",")
                + String.format(format, "", "etaMotor", "=", "          "
                        + compMotorEfficiency + ")") + "\"" + name + "\""
                + "\n" + stringAnnotationOfReformElectricEIRObjectBegin + "\n"
                + stringDefinitionOfReformElectricEIRObject
                + stringAnnotationOfReformElectricEIRObjectEnd + "\n";

    }

    /**
     * This method gets the reference capacity of the chiller.
     */
    public String getRefCapacity() {
        return refCapacity;
    }

    /**
     * This method sets the reference capacity of the chiller.
     */
    public void setRefCapacity(String refCapacity) {
        this.refCapacity = refCapacity;
    }

    /**
     * This method gets the functions names of the chiller.
     */
    public ArrayList<String> getFunctionNames() {
        return functionNames;
    }

    /**
     * This method sets the functions names of the chiller.
     */
    public void setFunctionNames(ArrayList<String> functionNames) {
        this.functionNames = functionNames;
    }

    /**
     * This method gets the curves describing the chiller.
     */
    public ArrayList<ICurve> getCurves() {
        return curves;
    }

    /**
     * This method sets the curves describing the chiller.
     */
    public void setCurves(ArrayList<ICurve> curves) {
        this.curves = curves;
    }

    /**
     * This method gets the name of the chiller.
     */
    public String getName() {
        return name;
    }

    /**
     * This method sets the name of the chiller.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * This method gets the reference COP of the chiller.
     */
    public void setRefCop(String refCop) {
        this.refCop = refCop;

    }

    /**
     * This method sets the reference COP of the chiller.
     */
    public void getRefCop(String refCop) {
        this.refCop = refCop;
    }

    /**
     * This method sets the reference leaving chilled water temperature of the
     * chiller.
     */
    public void setRefLeavingChilledWaterTemp(String parameter) {
        this.refLeavingChilledWaterTemp = parameter;

    }

    /**
     * This method sets the reference leaving condenser water temperature of the
     * chiller.
     */
    public void setRefLeavingCondenserFluidTemp(String parameter) {
        this.refLeavingCondenserFluidTemp = parameter;

    }

    /**
     * This method sets the reference chilled water flow rate of the chiller.
     */
    public void setRefChilledWaterFlowRate(String parameter) {
        this.refChilledWaterFlowRate = parameter;
    }

    /**
     * This method sets the condenser water flow rate of the chiller.
     */
    public void setRefCondenserWaterFlowRate(String parameter) {
        this.refCondenserWaterFlowRate = parameter;

    }

    /**
     * This method gets the compressor efficiency of the chiller.
     */
    public String getCompMotorEfficiency() {
        return compMotorEfficiency;
    }

    /**
     * This method sets the compressor efficiency of the chiller.
     */
    public void setCompMotorEfficiency(String compMotorEfficiency) {
        this.compMotorEfficiency = compMotorEfficiency;
    }

    /**
     * This method gets the minimum part load ratio of the chiller.
     */
    public String getMinPLR() {
        return minPLR;
    }

    /**
     * This method sets the minimum part load ratio of the chiller.
     */
    public void setMinPLR(String minPLR) {
        this.minPLR = minPLR;
    }

    /**
     * This method gets the maximum part load ratio of the chiller.
     */
    public String getMaxPLR() {
        return maxPLR;
    }

    /**
     * This method gets the maximum part load ratio of the chiller.
     */
    public void setMaxPLR(String maxPLR) {
        this.maxPLR = maxPLR;
    }

    /**
     * This method gets the optimum part load ratio of the chiller.
     */
    public String getOptPLR() {
        return optPLR;
    }

    /**
     * This method gets the optimum part load ratio of the chiller.
     */
    public void setOptPLR(String optPLR) {
        this.optPLR = optPLR;
    }

    /**
     * This method gets the minimum unloading ratio of the chiller.
     */
    public String getMinULR() {
        return minULR;
    }

    /**
     * This method sets the minimum unloading ratio of the chiller.
     */
    public void setMinULR(String minULR) {
        this.minULR = minULR;
    }

    /**
     * This method gets the comments definition of the chiller.
     */

    public String getStringDefinitionOfReformElectricEIRObject() {
        return stringDefinitionOfReformElectricEIRObject;
    }

    /**
     * This method sets the comments definition of the chiller.
     */
    public void setStringDefinitionOfReformElectricEIRObject(
            String stringDefinitionOfReformElectricEIRObject) {
        this.stringDefinitionOfReformElectricEIRObject = stringDefinitionOfReformElectricEIRObject;
    }

    /**
     * this method is used to removed token strings from the name of the chiller
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

}
