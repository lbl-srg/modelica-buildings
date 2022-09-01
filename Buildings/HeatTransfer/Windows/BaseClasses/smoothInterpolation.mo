within Buildings.HeatTransfer.Windows.BaseClasses;
function smoothInterpolation "Get interpolated data without triggering events"
  extends Modelica.Icons.Function;

  input Real y[:] "Data array";
  input Real x "x value";
  output Real val "Interpolated value";

protected
  Integer k1 "Integer value of x";
  Integer k2 "=k1+1";
  Real y1d "Slope";
  Real y2d "Slope";
algorithm
  k1 := integer(x);
  k2 := k1 + 1;

  y1d := (y[k2] - y[k1 - 1])/2;
  y2d := (y[k2 + 1] - y[k1])/2;
  val := Modelica.Fluid.Utilities.cubicHermite(
    x,
    k1,
    k2,
    y[k1],
    y[k2],
    y1d,
    y2d);

  annotation (
    smoothOrder=1,
    Inline=false,
    Documentation(info="<html>
<p>
Function to interpolate within a data array without triggerring events.
</p>
</html>", revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed function to be <code>Inline=false</code>, as otherwise
OpenModelica fails to translate
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Examples.AbsorbedRadiation\">
Buildings.HeatTransfer.Windows.BaseClasses.Examples.AbsorbedRadiation</a>.
For
<a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.MixedAirFreeResponse\">
Buildings.ThermalZones.Detailed.Examples.MixedAirFreeResponse</a>,
this change does not affect the computing time.
</li>
<li>
March 4, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothInterpolation;
