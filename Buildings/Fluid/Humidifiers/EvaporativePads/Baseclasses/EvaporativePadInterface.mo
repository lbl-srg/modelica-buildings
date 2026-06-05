within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses;
model EvaporativePadInterface

  parameter Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per
    annotation (Placement(transformation(extent={{60,-80},{80,-58}})));
  final parameter Real etaDer[size(per.efficiency.v,1)]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.efficiency.v,
    y=per.efficiency.eta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.efficiency.eta,
      strict=false));
  final parameter Real dpDer[size(per.pressure.v,1)]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.pressure.v,
    y=per.pressure.dp,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.pressure.dp,
      strict=false));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v "Air velocity"
                                                    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta "Saturation efficiency"
                                                       annotation (Placement(
        transformation(extent={{100,-70},{140,-30}}),iconTransformation(extent={{100,30},
            {140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dp "Pressure drop"
                                                      annotation (Placement(
        transformation(extent={{100,30},{140,70}}),   iconTransformation(extent={{100,-70},
            {140,-30}})));
equation

  eta =
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiency(
    per=per.efficiency,
    v=v,
    d=etaDer);
  dp = Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Pressure(
    per=per.pressure,
    v=v,
    d=dpDer);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is an interface that implements the functions to compute the pressure drop
and saturation efficiency of evaporative pads.
</p>
<p>
The nominal hydraulic characteristic (total pressure rise versus volume flow rate)
is given by a set of data points
using the data record <code>per</code>, which is an instance of
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
A cubic hermite spline with linear extrapolation is used to compute
the performance at other operating points.
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
