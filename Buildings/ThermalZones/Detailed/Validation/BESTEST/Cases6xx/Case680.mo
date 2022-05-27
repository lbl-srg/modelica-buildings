within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case680
  "Case 600, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
    matExtWal = extWalCase680,
    roof =    roofCase680,
    staRes(
     annualHea(Min=1.732*3.6e9, Max=2.286*3.6e9, Mean=2.056*3.6e9),
     annualCoo(Min=-5.932*3.6e9, Max=-6.529*3.6e9, Mean=-6.264*3.6e9),
     peakHea(Min=1.778*1000, Max=2.126*1000, Mean=1.984*1000),
     peakCoo(Min=-5.761*1000, Max=-7.051*1000, Mean=-6.446*1000)));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase680 extWalCase680
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,60},{74,74}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680
    "Roof"
    annotation (Placement(transformation(extent={{80,60},{94,74}})));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case680.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the case 680 of the BESTEST validation suite. Case 680 differs from
case 600 in that it has increased exterior wall and roof insulation.
</p>
</html>"));
end Case680;
