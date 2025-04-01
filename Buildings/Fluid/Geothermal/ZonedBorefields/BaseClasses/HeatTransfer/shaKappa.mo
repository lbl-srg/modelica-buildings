within Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer;
function shaKappa
  "Returns a SHA1 encryption of the formatted arguments for the thermal response factor generation"
  extends Modelica.Icons.Function;
  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor,2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.ThermalDiffusivity aSoi
    "Ground thermal diffusivity used in g-function evaluation";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of soil";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nZon "Total number of independent bore field zones";
  input Integer[nBor] iZon "Index of the zone corresponding to each borehole";
  input Integer[nZon] nBorPerZon "Number of boreholes per borefield zone";
  input Modelica.Units.SI.Time nu[nTim] "Time vector for the calculation of thermal response factors";
  input Integer nTim "Length of the time vector";
  input Real relTol "Relative tolerance on distance between boreholes";

  output String sha
  "SHA1 encryption of the g-function arguments";

protected
  constant String formatStrGen =  "1.3e" "String format for general parameters";
  constant String formatStrCoo =  ".2f" "String format for coordinate";
algorithm
  sha := Buildings.Utilities.Cryptographics.sha(String(nBor, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(hBor, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(dBor, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(rBor, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(aSoi, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(kSoi, format=formatStrGen));

  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nSeg, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nZon, format=formatStrGen));

  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nTim, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(relTol, format=formatStrGen));
  for i in 1:nBor loop
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(cooBor[i, 1], format=formatStrCoo));
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(cooBor[i, 2], format=formatStrCoo));
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(iZon[i], format=formatStrGen));
  end for;
  for i in 1:nZon loop
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(nBorPerZon[i], format=formatStrGen));
  end for;
  for i in 1:nTim loop
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(nu[i], format=formatStrGen));
  end for;
annotation (
Inline=false,
Documentation(info="<html>
<p>
This function returns the SHA1 encryption of its arguments.
</p>
<h4>Implementation</h4>
<p>
Each argument is formatted in exponential notation
with four significant digits, for example <code>1.234e+001</code>, with no spaces or
other separating characters between each argument value.
To prevent too long strings that can cause buffer overflows,
the sha encoding of each argument is computed and added to the next string that
is parsed.
</p>
<p>
The SHA1 encryption is computed using
<a href=\"modelica://Buildings.Utilities.Cryptographics.sha\">Buildings.Utilities.Cryptographics.sha</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2024, by Michael Wetter:<br/>
First implementation based on
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction</a>.
</li>
</ul>
</html>"));
end shaKappa;
