within Buildings.Fluid.CHPs.BaseClasses;
block EfficiencyCurve "Efficiency curve described by a 2nd order polynomial, 
  function of 3 input variables"
  extends Modelica.Blocks.Icons.Block;
  parameter Real a[27] "Polynomial coefficients";
  Modelica.Blocks.Interfaces.RealInput PNet(unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") "Water flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TWatIn(unit="K")
    "Water inlet temperature" annotation (Placement(transformation(extent={{-140,
            -80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput eta(unit="1") "Efficiency" annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
protected
  Real y(unit="1") "Efficiency";
  constant Real etaSma=0.01 "Value for eta if y is zero";
equation
  y = CHPs.BaseClasses.Functions.polynomialtrivariate(
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
  
  <p>The block computes a 2nd order polynomial, a function of three input variables.
The polynomial has the form
<p align=\"center\" style=\"font-style:italic;\">
y = a<sub>1</sub> 
+ a<sub>2</sub> x<sub>1</sub><sup>2</sup> 
+ a<sub>3</sub> x<sub>1</sub> 
+ a<sub>4</sub> x<sub>2</sub><sup>2</sup> 
+ a<sub>5</sub> x<sub>2</sub>
+ a<sub>6</sub> x<sub>3</sub><sup>2</sup> 
+ a<sub>7</sub> x<sub>3</sub> 
+ a<sub>8</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub><sup>2</sup> 
+ a<sub>9</sub> x<sub>1</sub> x<sub>2</sub> 
<p align=\"center\" style=\"font-style:italic;\">
+ a<sub>10</sub> x<sub>1</sub> x<sub>2</sub><sup>2</sup> 
+ a<sub>11</sub> x<sub>1</sub><sup>2</sup> x<sub>2</sub>
+ a<sub>12</sub> x<sub>1</sub><sup>2</sup> x<sub>3</sub><sup>2</sup> 
+ a<sub>13</sub> x<sub>1</sub> x<sub>3</sub> 
+ a<sub>14</sub> x<sub>1</sub> x<sub>3</sub><sup>2</sup> 
+ a<sub>15</sub> x<sub>1</sub><sup>2</sup> x<sub>3</sub>
+ a<sub>16</sub> x<sub>2</sub><sup>2</sup> x<sub>3</sub><sup>2</sup> 
+ a<sub>17</sub> x<sub>2</sub> x<sub>3</sub> 
+ a<sub>18</sub> x<sub>2</sub> x<sub>3</sub><sup>2</sup> 
<p align=\"center\" style=\"font-style:italic;\">
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
  
</html>", revisions="<html>
<ul>
<li>June 01, 2019, by Tea Zakula:<br/>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(graphics={Text(
          extent={{-90,38},{90,-34}},
          lineColor={160,160,164},
          textString="polynominal()")}));
end EfficiencyCurve;
