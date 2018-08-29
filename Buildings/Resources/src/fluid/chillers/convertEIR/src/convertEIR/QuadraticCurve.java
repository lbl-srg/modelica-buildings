package convertEIR;

/**
 * This method implements a quadratic curve.
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
public class QuadraticCurve implements ICurve {
    private String coef1;
    private String coef2;
    private String coef3;
    private String minValX;
    private String maxValX;

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
        return "{" + coef1 + "," + coef2 + "," + coef3 + "}";
    }

}
