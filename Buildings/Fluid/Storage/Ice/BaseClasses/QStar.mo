within Buildings.Fluid.Storage.Ice.BaseClasses;
model QStar "Calculator for q* under charging mode"
  extends Modelica.Blocks.Icons.Block;

  parameter Real coeff[6] "Coefficients for qstar curve";
  parameter Real dt "Time step of curve fitting data";

  Modelica.Blocks.Interfaces.BooleanInput active
    "Set to true if this tank mode can be active"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealInput x(unit="1")
    "SOC for charging, or 1-SOC for discharging"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput lmtdSta(unit="1") "Normalized LMTD"
   annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
     iconTransformation(extent={{-140,-80},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1")
    "Normalized heat transfer rate" annotation (Placement(transformation(extent=
           {{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

equation
  if active then
    qNor =Buildings.Utilities.Math.Functions.smoothMax(
      x1=0,
      x2=Buildings.Utilities.Math.Functions.polynomial(x, coeff[1:3]) +
        Buildings.Utilities.Math.Functions.polynomial(x, coeff[4:6])*lmtdSta,
      deltaX=1E-7)/dt;
  else
    qNor = 0;
  end if;

  annotation (defaultComponentName = "qSta",
  Icon(coordinateSystem(preserveAspectRatio = false)),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block calculates the normalized heat transfer rate <i>q*</i> between the chilled water
and the ice in the thermal storage tank using
</p>
<p align=\"center\">
<i>
q<sup>*</sup> &Delta;t = C<sub>1</sub> + C<sub>2</sub>x + C<sub>3</sub> x<sup>2</sup> + [C<sub>4</sub> + C<sub>5</sub>x + C<sub>6</sub> x<sup>2</sup>]&Delta;T<sub>lmtd</sub><sup>*</sup>
</i>
</p>
<p>where <i>&Delta;t</i> is the time step of the data samples used for the curve fitting,
<i>C<sub>1-6</sub></i> are the curve fit coefficients,
<i>x</i> is the fraction of charging, also known as the state-of-charge,
and <i>T<sub>lmtd</sub><sup>*</sup></i> is the normalized LMTD
calculated using <a href=\"mdoelica://Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar\">
Buildings.Fluid.Storage.Ice.BaseClasses.calculateLMTDStar</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 26, 2022, by Michael Wetter:<br/>
Refactored model to new architecture.
</li>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end QStar;
