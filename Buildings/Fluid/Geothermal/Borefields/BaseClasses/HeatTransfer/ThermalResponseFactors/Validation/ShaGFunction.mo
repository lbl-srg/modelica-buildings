within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
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
    1,
    26,
    50,
    exp(5)) "SHA1-encrypted g-function inputs";

  //Expected output (SHA1-encryption of (1,{{0,0}},150,4,0.075,1e-6,12,1,26,50,exp(5)))
  parameter String strEx=
    "6dc3c2b9dfa5807ce25f7d34dc9e718a1119ce9f"
    "Expected string output";

  //Comparison result
  Boolean cmp "Comparison result";

equation
  cmp = Modelica.Utilities.Strings.isEqual(strIn,strEx,false);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/ShaGFunction.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses a typical single borehole to test the SHA1-encryption of the
arguments required to determine the borehole's thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
June 9, 2022, by Massimo Cimmino:<br/>
Added number of clusters to the function call.
</li>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShaGFunction;
