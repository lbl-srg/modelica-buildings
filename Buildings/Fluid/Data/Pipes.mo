within Buildings.Fluid.Data;
package Pipes "Package with properties of pipes"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record PEX_DN_6 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 8E-3,
      dIn =  6E-3) "PEX DN 6"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_8 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 10E-3,
      dIn =  8E-3) "PEX DN 8"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_10 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 13E-3,
      dIn =  10E-3) "PEX DN 10"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_15 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 19E-3,
      dIn =  16E-3) "PEX DN 15"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_20 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 23E-3,
      dIn =  20E-3) "PEX DN 20"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_25 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 29E-3,
      dIn =  26E-3) "PEX DN 25"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_32 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 35E-3,
      dIn =  32E-3) "PEX DN 32"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_40 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 41E-3,
      dIn =  38E-3) "PEX DN 40"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_50 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 53E-3,
      dIn =  50E-3) "PEX DN 50"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_65 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 70E-3,
      dIn =  66E-3) "PEX DN 65"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_80 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 85E-3,
      dIn =  81E-3) "PEX DN 80"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_100 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 104E-3,
      dIn =  100E-3) "PEX DN 100"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_125 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 129E-3,
      dIn =  125E-3) "PEX DN 125"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_150 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 154E-3,
      dIn =  150E-3) "PEX DN 150"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_DN_200 = Buildings.Fluid.Data.Pipes.PEX_RADTEST (
      dOut = 204E-3,
      dIn =  200E-3) "PEX DN 200"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip");

  record PEX_RADTEST = Buildings.Fluid.Data.Pipes.Generic (
      dOut =      0.025,
      dIn =        0.020,
      roughness = 0.007E-3,
      d =         983,
      k =         0.35) "PEX from RADTEST Validation Suite"
    annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datPip",
    Documentation(info=
                   "<html>
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
    parameter Modelica.Units.SI.Length dOut(min=0) "Outer diameter";
    parameter Modelica.Units.SI.Length dIn(min=0) "Inner diameter";
    final parameter Modelica.Units.SI.Length s(min=0) = (dOut - dIn)/2
      "Wall thickness";
    parameter Modelica.Units.SI.Length roughness(min=0) "Roughness";
    parameter Modelica.Units.SI.Density d "Mass density";
    parameter Modelica.Units.SI.ThermalConductivity k "Thermal conductivity";
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datPip",
      Documentation(info=
                   "<html>
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
September 2, 2014, by Michael Wetter:<br/>
Corrected wrong entries for inner and outer diameter
of PEX pipes.
</li>
<li>
April 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pipes;
