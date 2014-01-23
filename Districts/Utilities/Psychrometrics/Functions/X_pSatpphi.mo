within Districts.Utilities.Psychrometrics.Functions;
function X_pSatpphi "Humidity ratio for given water vapor pressure"
  input Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";
  input Modelica.SIunits.Pressure p "Pressure of the fluid";
  input Real phi(min=0, max=1) "Relative humidity";
  output Modelica.SIunits.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Water vapor concentration per total mass of air";

protected
  constant Real k = 0.621964713077499 "Ratio of molar masses";
algorithm
  X_w := phi*k/(k*phi+p/pSat-phi);

  annotation (
    smoothOrder=99,
    Inline=true,
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
Function to compute the water vapor concentration based on
saturation pressure, absolute pressure and relative humidity.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end X_pSatpphi;
