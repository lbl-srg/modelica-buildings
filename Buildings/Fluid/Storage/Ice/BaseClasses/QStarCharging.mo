within Buildings.Fluid.Storage.Ice.BaseClasses;
model QStarCharging "Calculator for q* under charging mode"

  parameter Real coeff[6] "Coefficients for qstar curve";
  parameter Real dt "Time step of curve fitting data";

  Modelica.Blocks.Interfaces.RealInput fraCha(unit="1")
    "Fraction of charge in ice tank"
    annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));

  Modelica.Blocks.Interfaces.RealInput lmtdSta(unit="1") "Normalized LMTD"
   annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
     iconTransformation(extent={{-140,-60},{ -100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1")
    "Normalized heat transfer rate" annotation (Placement(transformation(extent=
           {{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,10}})));

equation
  qNor*dt = Buildings.Utilities.Math.Functions.smoothMax(
    x1 = 0,
    x2 = Buildings.Utilities.Math.Functions.polynomial(fraCha, coeff[1:3]) +
         Buildings.Utilities.Math.Functions.polynomial(fraCha, coeff[4:6])*lmtdSta,
         deltaX = 1E-7);

  annotation (defaultComponentName = "qSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This block calculates the <span style=\"font-family: Courier New;\">q*</span>,
which is the normalized instantaneous heat transfer rate between the chilled water
and the ice in the thermal storage tank as follows.
</p>

<p align=\"center\">
<i>
q<sup>*</sup> &Delta;t = C<sub>1</sub> + C<sub>2</sub>x + C<sub>3</sub> x<sup>2</sup> + [C<sub>4</sub> + C<sub>5</sub>x + C<sub>6</sub> x<sup>2</sup>]&Delta;T<sub>lmtd<sup>*</sup>
</i>
</p>

<p>where <span style=\"font-family: Courier New;\">&Delta;t</span> is the time step of the data samples used for the curve fitting,
<span style=\"font-family: Courier New;\">C<sub>1-6</span></sub> are the curve fit coefficients,
<span style=\"font-family: Courier New;\">x</span> is the fraction of charging, also known as the state-of-charge,
and <span style=\"font-family: Courier New;\">T<sub>lmtd<sup>*</span></sup> is the normalized LMTD
calculated from <a href=\"mdoelica://IceStorage.BaseClasses.LMTDStar\">IceStorage.BaseClasses.LMTDStar</a>.
</p>

<p>
Note that different sets of <code>C</code> should be calibrated for charging and discharging.
</p>

</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end QStarCharging;
