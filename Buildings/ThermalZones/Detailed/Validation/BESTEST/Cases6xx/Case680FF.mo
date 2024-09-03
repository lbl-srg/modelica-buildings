within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case680FF
  "Case 600FF, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF(
    matExtWal = extWalCase680,
    roof =    roofCase680,
    redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResultsFreeFloating staRes(
      minT( Min=-8.1+273.15, Max=-5.7+273.15, Mean=-6.9+273.15),
      maxT( Min=69.8+273.15, Max=78.5+273.15, Mean=73.0+273.15),
      meanT(Min=30.2+273.15, Max=33.3+273.15, Mean=31.8+273.15)));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase680 extWalCase680(
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,60},{74,74}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680(
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Roof"
    annotation (Placement(transformation(extent={{80,60},{94,74}})));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case680FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 680FF of the BESTEST validation suite.
Case 680FF is a light-weight building with increased exterior wall and roof insulation.
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
end Case680FF;
