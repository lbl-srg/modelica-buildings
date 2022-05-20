within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case980FF
  "Case 900FF, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900FF(
    matExtWal = extWalCase980,
    roof =    roofCase680,
    staRes(
      minT( Min=7.3+273.15, Max=12.5+273.15, Mean=10.4+273.15),
      maxT( Min=48.5+273.15, Max=52.8+273.15, Mean=50.5+273.15),
      meanT(Min=30.5+273.15, Max=33.3+273.15, Mean=31.8+273.15)));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase980 extWalCase980
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,20},{74,34}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680
    "Roof"
    annotation (Placement(transformation(extent={{80,20},{94,34}})));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case980FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 980FF of the BESTEST validation suite.
Case 980FF is a heavy-weight building with increased exterior wall and roof insulation.
The room temperature is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case980FF;
