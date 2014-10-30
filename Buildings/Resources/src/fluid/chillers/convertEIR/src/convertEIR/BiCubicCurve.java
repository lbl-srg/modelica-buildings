package convertEIR;

/**
 * This method implements a bicubic curve.
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

public class BiCubicCurve implements ICurve {
    private String coef1;
    private String coef2;
    private String coef3;
    private String coef4;
    private String coef5;
    private String coef6;
    private String coef7;
    private String coef8;
    private String coef9;
    private String coef10;
    private String minValX;
    private String maxValX;
    private String minValY;
    private String maxValY;

    /**
     * This method sets the first coefficient of the curve.
     */
    public void setCoef1(String parameter) {
        this.coef1 = parameter;
    }

    /**
     * This method sets the second coefficient of the curve.
     */
    public void setCoef2(String parameter) {
        this.coef2 = parameter;
    }

    /**
     * This method sets the third coefficient of the curve.
     */
    public void setCoef3(String parameter) {
        this.coef3 = parameter;
    }

    /**
     * This method sets the fourth coefficient of the curve.
     */
    public void setCoef4(String parameter) {
        this.coef4 = parameter;
    }

    /**
     * This method sets the fifth coefficient of the curve.
     */
    public void setCoef5(String parameter) {
        this.coef5 = parameter;
    }

    /**
     * This method sets the sixth coefficient of the curve.
     */
    public void setCoef6(String parameter) {
        this.coef6 = parameter;
    }

    /**
     * This method sets the seventh coefficient of the curve.
     */
    public void setCoef7(String parameter) {
        this.coef7 = parameter;
    }

    /**
     * This method sets the eight coefficient of the curve.
     */
    public void setCoef8(String parameter) {
        this.coef8 = parameter;
    }

    /**
     * This method sets the ninth coefficient of the curve.
     */
    public void setCoef9(String parameter) {
        this.coef9 = parameter;
    }

    /**
     * This method sets the tenth coefficient of the curve.
     */
    public void setCoef10(String parameter) {
        this.coef10 = parameter;
    }

    /**
     * This method sets the minimum x-value of the curve.
     */
    public void setMinValX(String parameter) {
        this.minValX = parameter;

    }

    /**
     * This method gets the minimum x-value of the curve.
     */
    public String getMinValX() {
        return this.minValX;
    }

    /**
     * This method sets the maximum x-value of the curve.
     */
    public void setMaxValX(String parameter) {
        this.maxValX = parameter;

    }

    /**
     * This method gets the maximum x-value of the curve.
     */
    public String getMaxValX() {
        return this.maxValX;
    }

    /**
     * This method sets the minimum y-value of the curve.
     */
    public void setMinValY(String parameter) {
        this.minValY = parameter;

    }

    /**
     * This method gets the minimum y-value of the curve.
     */
    public String getMinValY() {
        return this.minValY;
    }

    /**
     * This method sets the maximum y-value of the curve.
     */
    public void setMaxValY(String parameter) {
        this.maxValY = parameter;

    }

    /**
     * This method gets the maximum y-value of the curve.
     */
    public String getMaxValY() {
        return this.maxValY;
    }

    /**
     * This method sets the name of the curve.
     */
    public void setName(String parameter) {

    }

    /**
     * This method concatenates the coefficients of the curve into a string.
     *
     * @return string containing the coefficients of the curve.
     */
    public String curveToString() {
        return "{" + coef1 + "," + coef2 + "," + coef3 + "," + coef4 + ","
                + coef5 + "," + coef6 + "," + coef7 + "," + coef8 + "," + coef9
                + "," + coef10 + "}";
    }
}
