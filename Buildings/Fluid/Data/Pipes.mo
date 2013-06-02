within Buildings.Fluid.Data;
package Pipes "Package with properties of pipes"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record PEX_DN_6 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 8E-3,
      dOut = 6E-3) "PEX DN 6";

  record PEX_DN_8 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 10E-3,
      dOut = 8E-3) "PEX DN 8";

  record PEX_DN_10 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 13E-3,
      dOut = 10E-3) "PEX DN 10";

  record PEX_DN_15 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 19E-3,
      dOut = 16E-3) "PEX DN 15";

  record PEX_DN_20 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 23E-3,
      dOut = 20E-3) "PEX DN 20";

  record PEX_DN_25 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 29E-3,
      dOut = 26E-3) "PEX DN 25";

  record PEX_DN_32 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 35E-3,
      dOut = 32E-3) "PEX DN 32";

  record PEX_DN_40 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 41E-3,
      dOut = 38E-3) "PEX DN 40";

  record PEX_DN_50 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 53E-3,
      dOut = 50E-3) "PEX DN 50";

  record PEX_DN_65 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 70E-3,
      dOut = 66E-3) "PEX DN 65";

  record PEX_DN_80 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 85E-3,
      dOut = 81E-3) "PEX DN 80";

  record PEX_DN_100 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 104E-3,
      dOut = 100E-3) "PEX DN 100";

  record PEX_DN_125 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 129E-3,
      dOut = 125E-3) "PEX DN 125";

  record PEX_DN_150 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 154E-3,
      dOut = 150E-3) "PEX DN 150";

  record PEX_DN_200 = Buildings.Fluid.Data.Pipes.PEX_RADTEST(
      dIn  = 204E-3,
      dOut = 200E-3) "PEX DN 200";

  record PEX_RADTEST = Buildings.Fluid.Data.Pipes.Generic (
      dOut      = 0.025,
      dIn       =  0.020,
      roughness = 0.007E-3,
      d         = 983,
      k         = 0.35) "PEX from RADTEST Validation Suite"
    annotation (Documentation(info="<html>
<p>
PEX pipe from Achermann and Zweifel (2003).
</p>
<h4>References</h4>
<p>
Achermann, Matthias and Gerhard Zweifel.
RADTEST - Radiant Heating and Cooling Test Cases.
A Report of Task 22, Subtask C, Building Energy Analysis Tools
Comparative Evaluation Tests. Luzern, Switzerland. April 2003.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  record Generic "Generic record for pipes"
    extends Modelica.Icons.Record;
    parameter Modelica.SIunits.Length dOut(min=0) "Outer diameter";
    parameter Modelica.SIunits.Length dIn(min=0) "Inner diameter";
    final parameter Modelica.SIunits.Length s(min=0) = (dOut-dIn)/2 "Wall thickness";
    parameter Modelica.SIunits.Length roughness(min=0) "Roughness";
    parameter Modelica.SIunits.Density d "Mass density";
    parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
    annotation (Documentation(info="<html>
<p>
This is a generic record for pipes.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;

    annotation (
preferredView="info",
Documentation(info="<html>
<p>
Package with records for pipes.
The PEX diameters are based on DIN 11850.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pipes;
