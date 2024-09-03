within Buildings.Utilities.Psychrometrics.Functions;
function pW_X "Water vapor pressure for given humidity ratio"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.MassFraction X_w(
    min=0,
    max=0.99999,
    nominal=0.01) "Species concentration at dry bulb temperature";
  input Modelica.Units.SI.Pressure p=101325 "Total pressure";
  output Modelica.Units.SI.Pressure p_w(displayUnit="Pa")
    "Water vapor pressure";

protected
  Modelica.Units.SI.MassFraction x_w(nominal=0.01)
    "Water mass fraction per mass of dry air";
algorithm
  x_w := X_w/(1 - X_w);
  p_w := p*x_w/(0.62198 + x_w);
  annotation (
    Inline=true,
    smoothOrder=99,
    derivative=BaseClasses.der_pW_X,
    Documentation(info="<html>
<p>
Function to compute the water vapor partial pressure for a given humidity ratio.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
February 17, 2010 by Michael Wetter:<br/>
Renamed block from <code>VaporPressure_X</code> to <code>pW_X</code>.
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
end pW_X;
