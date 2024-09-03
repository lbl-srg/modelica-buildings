within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function shaGFunction
  "Returns a SHA1 encryption of the formatted arguments for the g-function generation"
  extends Modelica.Icons.Function;
  input Integer nBor "Number of boreholes";
  input Modelica.Units.SI.Position cooBor[nBor,2] "Coordinates of boreholes";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.ThermalDiffusivity aSoi
    "Ground thermal diffusivity used in g-function evaluation";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nClu "Number of clusters for g-function calculation";
  input Integer nTimSho "Number of time steps in short time region";
  input Integer nTimLon "Number of time steps in long time region";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";

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
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nSeg, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nClu, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nTimSho, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(nTimLon, format=formatStrGen));
  sha := Buildings.Utilities.Cryptographics.sha(sha + String(ttsMax, format=formatStrGen));
  for i in 1:nBor loop
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(cooBor[i, 1], format=formatStrCoo));
    sha := Buildings.Utilities.Cryptographics.sha(sha + String(cooBor[i, 2], format=formatStrCoo));
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
June 9, 2022, by Massimo Cimmino:<br/>
Added the number of clusters to the encryption.
</li>
<li>
November 1, 2019 by Michael Wetter:<br/>
Declared string as a constant due to JModelica's tigther type checking.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1230\">#1230</a>.
</li>
<li>
September 11, 2018, by Michael Wetter:<br/>
Refactored implementation to avoid buffer overflow.
</li>
<li>
September 11, 2018 by Damien Picard:<br/>
Split long strings into small strings to avoid buffer overflow.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1018\">#1018</a>.
</li>
<li>
June 22, 2018 by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end shaGFunction;
