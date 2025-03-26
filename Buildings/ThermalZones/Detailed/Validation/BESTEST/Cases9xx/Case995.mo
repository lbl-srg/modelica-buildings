within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case995
  "Case 900, but with single heating and cooling setpoint and increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900(
    redeclare BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 20.1]),
    redeclare BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 19.9]),
    matExtWal = extWalCase980,
    roof =    roofCase680,
    staRes(
     annualHea(Min=0.755*3.6e9, Max=1.330*3.6e9, Mean=0.974*3.6e9),
     annualCoo(Min=-6.771*3.6e9, Max=-7.482*3.6e9, Mean=-7.145*3.6e9),
     peakHea(Min=1.370*1000, Max=1.711*1000, Mean=1.564*1000),
     peakCoo(Min=-3.315*1000, Max=-4.224*1000, Mean=-3.986*1000)),
   heaCri(lowerLimit=-0.15*3.6e9, upperLimit=2.02*3.6e9),
   cooCri(lowerLimit=-6.58*3.6e9, upperLimit=-8.41*3.6e9));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase980 extWalCase980(
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Rough)
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,20},{74,34}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680
    "Roof"
    annotation (Placement(transformation(extent={{80,20},{94,34}})));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case995.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the case 995 of the BESTEST validation suite. Case 995 differs from
case 900 in that it has single heating and cooling setpoint and increased exterior wall
and roof insulation.
</p>
<ul>
<li>
Heat = on if zone temperature is below 20&deg;C
</li>
<li>
Cool = on if zone temperature is above 20&deg;C
</li>
</ul>
</html>"));
end Case995;
