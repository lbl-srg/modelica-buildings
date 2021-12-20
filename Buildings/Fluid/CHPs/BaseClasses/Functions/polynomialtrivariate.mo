within Buildings.Fluid.CHPs.BaseClasses.Functions;
function polynomialtrivariate
  "Polynominal function used for efficiency calculation"
  extends Modelica.Icons.Function;

  input Real x1 "Independent variable";
  input Real x2 "Independent variable";
  input Real x3 "Independent variable";
  input Real a[27] "Coefficients";
  output Real y "Result";

protected
 Real x1Sq = x1^2;
 Real x2Sq = x2^2;
 Real x3Sq = x3^2;

algorithm
  y := a[1] + a[2]*x1Sq + a[3]*x1
            + a[4]*x2Sq + a[5]*x2
            + a[6]*x3Sq + a[7]*x3
            + a[8]*x1Sq*x2Sq + a[9]*x1*x2 + a[10]*x1*x2Sq + a[11]*x1Sq*x2
            + a[12]*x1Sq*x3Sq + a[13]*x1*x3 + a[14]*x1*x3Sq + a[15]*x1Sq*x3
            + a[16]*x2Sq*x3Sq + a[17]*x2*x3 + a[18]*x2*x3Sq + a[19]*x2Sq*x3
            + a[20]*x1Sq*x2Sq*x3Sq + a[21]*x1Sq*x2Sq*x3 + a[22]*x1Sq*x2*x3Sq + a[23]*x1*x2Sq*x3Sq
            + a[24]*x1Sq*x2*x3 + a[25]*x1*x2Sq*x3 + a[26]*x1*x2*x3Sq
            + a[27]*x1*x2*x3;

annotation (Documentation(info="<html>
<p>
This function computes a trivariate fifth order polynomial.
The polynomial has the form
</p>
<p style=\"font-style:italic;\">
y = a<sub>1</sub>
+ a<sub>2</sub> x<sub>1</sub><sup>2</sup>
+ a<sub>3</sub> x<sub>1</sub>
+ a<sub>4</sub> x<sub>2</sub><sup>2</sup>
+ a<sub>5</sub> x<sub>2</sub>
+ a<sub>6</sub> x<sub>3</sub><sup>2</sup>
+ a<sub>7</sub> x<sub>3</sub>
+ a<sub>8</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub><sup>2</sup>
+ a<sub>9</sub> x<sub>1</sub> x<sub>2</sub>
<br/>
+ a<sub>10</sub> x<sub>1</sub> x<sub>2</sub><sup>2</sup>
+ a<sub>11</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub>
+ a<sub>12</sub> x<sub>1</sub><sup>2</sup> x<sub>3</sub><sup>2</sup>
+ a<sub>13</sub> x<sub>1</sub> x<sub>3</sub>
+ a<sub>14</sub> x<sub>1</sub> x<sub>3</sub><sup>2</sup>
+ a<sub>15</sub> x<sub>1</sub><sup>2</sup> x<sub>3</sub>
+ a<sub>16</sub> x<sub>2</sub><sup>2</sup> x<sub>3</sub><sup>2</sup>
+ a<sub>17</sub> x<sub>2</sub> x<sub>3</sub>
+ a<sub>18</sub> x<sub>2</sub> x<sub>3</sub><sup>2</sup>
<br/>
+ a<sub>19</sub> x<sub>2</sub><sup>2</sup> x<sub>3</sub>
+ a<sub>20</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub><sup>2</sup> x<sub>3</sub><sup>2</sup>
+ a<sub>21</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub><sup>2</sup> x<sub>3</sub>
+ a<sub>22</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub> x<sub>3</sub><sup>2</sup>
+ a<sub>23</sub> x<sub>1</sub> x<sub>2</sub><sup>2</sup> x<sub>3</sub><sup>2</sup>
+ a<sub>24</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub> x<sub>3</sub>
+ a<sub>25</sub> x<sub>1</sub> x<sub>2</sub><sup>2</sup> x<sub>3</sub>
+ a<sub>26</sub> x<sub>1</sub> x<sub>2</sub> x<sub>3</sub><sup>2</sup>
+ a<sub>27</sub> x<sub>1</sub> x<sub>2</sub> x<sub>3</sub>
</p>
</html>",
revisions="<html>
<ul>
<li>
March 10, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end polynomialtrivariate;
