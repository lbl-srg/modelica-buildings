within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Examples;
model ShaGFunction
  "Verifies the SHA-1 encryption of a single borehole"
  extends Modelica.Icons.Example;

  //Input
  parameter String strIn=
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction(
    1,
    {{0,0}},
    150,
    4,
    0.075,
    1e-6,
    12,
    26,
    50,
    exp(5)) "SHA1-encrypted g-function inputs";

  //Expected output (SHA1-encryption of '1.000e+0000.000e+0000.000e+0001.500e+0024.000e+0007.500e-0021.000e-0061.200e+0012.600e+0015.000e+0011.484e+002')
  parameter String strEx=
    "5d0475f93c93232dfe2452bb34acabd6b9fd28e5"
    "Expected string output";

  //Comparison result
  Boolean cmp "Comparison result";

equation
  cmp = Modelica.Utilities.Strings.isEqual(strIn,strEx,false);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Examples/ShaGFunction.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses a typical single borehole to test the SHA1-encryption of the
arguments required to determine the borehole's thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShaGFunction;
