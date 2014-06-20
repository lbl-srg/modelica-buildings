within Buildings.HeatTransfer.Windows.BaseClasses;
function smoothInterpolation "Get interpolated data without triggering events"
  input Real y[:] "Data array";
  input Real x "x value";
  output Real val "Return value";

protected
  Integer k1;
  Integer k2;
  Real y1d;
  Real y2d;
algorithm
  k1 := integer(x);
  k2 := k1 + 1;

  y1d := (y[k1 + 1] - y[k1 - 1])/2;
  y2d := (y[k2 + 1] - y[k2 - 1])/2;
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
    Inline=true,
    Documentation(info="<html>
<p>
Function to interpolate within a data array without triggerring events.
</p>
</html>", revisions="<html>
<ul>
<li>
March 4, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothInterpolation;
