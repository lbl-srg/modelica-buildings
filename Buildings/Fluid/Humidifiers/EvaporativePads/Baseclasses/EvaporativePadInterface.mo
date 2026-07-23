within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses;
block EvaporativePadInterface
  "Interface with performance curves for evaporative pads"

  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v(
    final quantity="Velocity",
    final unit="m/s") "Air velocity"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta(
    final quantity="Efficiency",
    final unit="1") "Saturation efficiency"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  final parameter Real etaDer[size(per.efficiency.v,1)]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.efficiency.v,
    y=per.efficiency.eta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.efficiency.eta,
      strict=false))
    "Derivative for cubic spline of saturation efficiency vs. air velocity";

equation
  eta =min(1,max(0,
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiency(
    per=per.efficiency,
    v=v,
    d=etaDer)));
annotation (defaultComponentName="evaPadInt",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is an interface that implements the performance curves to compute the
saturation efficiency of evaporative pads.
</p>
<p>
The saturation efficiency of evaporative pads in relation to the air velocity is
given by a set of discrete data points using the data record <code>per</code>, which
is an instance of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic</a>. A cubic hermite spline
with linear extrapolation is used to compute the performance at other operating
points.
</p>
<p>
This interface also enforces the saturation efficiency value to be between 0 and 1.
</p>
</html>", revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end EvaporativePadInterface;
