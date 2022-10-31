within Buildings.Fluid.CHPs.BaseClasses;
block EfficiencyCurve "Efficiency curve described by a fifth order polynomial,
  function of three input variables"
  extends Modelica.Blocks.Icons.Block;

  parameter Real a[27] "Polynomial coefficients";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PNet(
    final unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s") "Water mass flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta(
    final unit="1") "Efficiency"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Real y(unit="1") "Efficiency";
  constant Real etaSma=0.01 "Value for eta if y is zero";

equation
  y = Buildings.Fluid.CHPs.BaseClasses.Functions.polynomialtrivariate(
    a=a,
    x1=PNet,
    x2=mWat_flow,
    x3=TWatIn - 273.15)
    "Efficiency calculated as a function of power, water flow rate and water inlet temperature";
  eta = Buildings.Utilities.Math.Functions.smoothMax(
    x1=y,
    x2=etaSma,
    deltaX=etaSma/2)
    "Corrected efficiency, ensuring that efficiency is not zero";

annotation (
  defaultComponentName="effCur",
  Documentation(info="<html>
<p>
The block computes the efficiency as a polynomial function of three input variables.
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
<p>
where
<i>x<sub>1</sub></i> is the net power output,
<i>x<sub>2</sub></i> is the water mass flow rate,
<i>x<sub>3</sub></i> is the water inlet temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>June 1, 2019, by Tea Zakula:<br/>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-90,-76},{68,-76}},
                                      color={192,192,192}),
        Line(points={{-80,-80},{-79.2,-50.6},{-78.4,-37},{-77.6,-28},{-76.8,-21.3},
              {-75.2,-11.4},{-72.8,-1.31},{-69.5,8.08},{-64.7,17.9},{-57.5,28},
              {-47,38.1},{-31.8,48.1},{-10.1,58},{22.1,68},{68.7,78.1},{80,80}}),
        Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Icon(graphics={Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="polynomial()")}));
end EfficiencyCurve;
