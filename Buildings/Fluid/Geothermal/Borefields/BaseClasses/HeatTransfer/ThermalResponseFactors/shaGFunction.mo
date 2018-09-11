within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function shaGFunction
  "Returns a SHA1 encryption of the formatted arguments for the g-function generation"
  extends Modelica.Icons.Function;
  input Integer nBor "Number of boreholes";
  input Modelica.SIunits.Position cooBor[nBor, 2] "Coordinates of boreholes";
  input Modelica.SIunits.Height hBor "Borehole length";
  input Modelica.SIunits.Height dBor "Borehole buried depth";
  input Modelica.SIunits.Radius rBor "Borehole radius";
  input Modelica.SIunits.ThermalDiffusivity aSoi "Ground thermal diffusivity used in g-function evaluation";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nTimSho "Number of time steps in short time region";
  input Integer nTimLon "Number of time steps in long time region";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";

  output String sha
  "SHA1 encryption of the g-function arguments";

protected
  String strGen "String containing the general parameters";
  String formatStrGen =  "1.3e" "String format for general parameters";
  String strCoo[10] "Array of strings for coordinates";
  String formatStrCoo =  ".2f" "String format for coordinate";
  Integer maxStrLen = 500 "Maxium string length";
  Integer i_strCoo;
  String tmpSha;
algorithm
  strGen := String(nBor, format=formatStrGen);
  strGen := strGen
    + String(hBor, format=formatStrGen)
    + String(dBor, format=formatStrGen)
    + String(rBor, format=formatStrGen)
    + String(aSoi, format=formatStrGen)
    + String(nSeg, format=formatStrGen)
    + String(nTimSho, format=formatStrGen)
    + String(nTimLon, format=formatStrGen)
    + String(ttsMax, format=formatStrGen);

  i_strCoo := 1;
  strCoo[1] :="";
  for i in 1:nBor loop
    // Splits long string into smaller strings
    if Modelica.Utilities.Strings.length(strCoo[i_strCoo]) > maxStrLen then
       i_strCoo :=i_strCoo + 1;
       strCoo[i_strCoo]:="";
    end if;
    strCoo[i_strCoo] := strCoo[i_strCoo]
     + String(cooBor[i, 1], format=formatStrCoo)
     + String(cooBor[i, 2], format=formatStrCoo);
  end for;

  // Create a sha for each string and concatenate them
  tmpSha := Buildings.Utilities.Cryptographics.sha(strGen);
  for i in 1:i_strCoo loop
    tmpSha :=tmpSha + Buildings.Utilities.Cryptographics.sha(strCoo[i]);
  end for;

  // Create a sha from tmpSha
  sha := Buildings.Utilities.Cryptographics.sha(tmpSha);


annotation (
Documentation(info="<html>
<p>
This function concatenates the various arguments required to generate the borefield's
thermal response into a single input string. Each argument is formatted in exponential notation
with four significant digits, for example <code>1.234e+001</code>, with no spaces or
other separating characters between each argument value. Because a borefield has a variable
number of boreholes, and because the (x,y) coordinates of each borehole are taken into
account, the total length of this input string is variable.
</p>
<p>
Once the input string has been put together, the SHA1 encryption of this string
is computed using
<a href=\"modelica://Buildings.Utilities.Cryptographics.sha\">Buildings.Utilities.Cryptographics.sha</a>
and returned by this function.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2018 by Damien Picard<br/>
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
