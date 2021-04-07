within Buildings.Experimental.DHC.Loads.BaseClasses;
block ConstraintViolation
  "Block that outputs the fraction of time when a constraint is violated"

  parameter Real uMin "Minimum value for input";
  parameter Real uMax "Maximum value for input";
  parameter Integer nu(min=0) = 0
    "Number of input connections"
    annotation (Dialog(connectorSizing=true));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nu]
    "Variables of interest"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1",
    start=0,
    fixed=true)
    "Fraction of time when the constraint is violated"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.SIunits.Time t(final start=0, final fixed=true)
    "Integral of violated time";
protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  Boolean vioMin "Flag, true if minimum is violated";
  Boolean vioMax "Flag, true if maximum is violated";
initial equation
  t0 = time - 1E-6;
equation
  vioMin = Modelica.Math.BooleanVectors.anyTrue({u[i] < uMin for i in 1:nu});
  vioMax = Modelica.Math.BooleanVectors.anyTrue({u[i] > uMax for i in 1:nu});
  if vioMin or vioMax then
    der(t) = 1;
  else
    der(t) = 0;
  end if;
  y = t / (time - t0);

  annotation (
  defaultComponentName="conVio",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                             Ellipse(
          extent={{-10,74},{10,-30}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-14,-48},{12,-74}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-112},{150,-152}},
          textString="%name",
          lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that outputs the running fractional time during which any element
<i>u<sub>i</sub></i> of the input signal
is not within <i>u<sub>min</sub> &le; u<sub>i</sub> &le; u<sub>max</sub></i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ConstraintViolation;
