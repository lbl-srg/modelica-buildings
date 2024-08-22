within Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.Validation;
model ShaKappa "Verifies the SHA-1 encryption of a zoned borefield"
  extends Modelica.Icons.Example;

  //Input
  parameter String strIn=
    Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.shaKappa(
      nBor=3,
      cooBor={{0,0}, {0,5}, {5,0}},
      hBor=150,
      dBor=4,
      rBor=0.075,
      aSoi=1e-6,
      kSoi=2,
      nSeg=4,
      nZon=2,
      iZon={1, 2, 1},
      nBorPerZon={2, 1},
      nu={300, 3600, 86400, 604800, 2592000, 31536000, 315360000},
      nTim=7,
      relTol=0.02) "SHA1-encrypted thermal response factor";

  //Expected output (SHA1-encryption of (1,{{0,0}},150,4,0.075,1e-6,12,1,26,50,exp(5)))
  parameter String strEx=
    "1d813242b2177c5e31011dc1656add40a2a9d178"
    "Expected string output";

  //Comparison result
  Boolean cmp "Comparison result";

equation
  cmp = Modelica.Utilities.Strings.isEqual(strIn,strEx,false);

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/BaseClasses/HeatTransfer/Validation/ShaKappa.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses a zoned borefield parameterization to test the SHA1-encryption of the
arguments required to determine the thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2024, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShaKappa;
