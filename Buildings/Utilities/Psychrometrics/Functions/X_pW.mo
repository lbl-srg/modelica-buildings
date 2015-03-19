within Buildings.Utilities.Psychrometrics.Functions;
function X_pW "Humidity ratio for given water vapor pressure"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p_w(displayUnit="Pa",
                                      min=0.003,
                                      nominal=1000) "Water vapor pressure";
  input Modelica.SIunits.Pressure p=101325 "Total pressure";
  output Modelica.SIunits.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Species concentration at dry bulb temperature";

protected
  Modelica.SIunits.MassFraction x_w(nominal=0.01)
    "Water mass fraction per mass of dry air";
algorithm
  x_w := 0.62198*p_w/(p - p_w);
  X_w := x_w/(1 + x_w);
  annotation (
    smoothOrder=99,
    Inline=true,
    Documentation(info="<html>
<p>
Function to compute the humidity ratio for a given water vapor partial pressure.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2013 by Michael Wetter:<br/>
Added attributes to variable <code>p_w</code>.
</li>
<li>
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>HumidityRatio_pWat</code> to <code>X_pW</code>.
</li>
<li>
April 14, 2009 by Michael Wetter:<br/>
Converted model to block because <code>RealInput</code> are obsolete in Modelica 3.0.
</li>
<li>
August 7, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end X_pW;
