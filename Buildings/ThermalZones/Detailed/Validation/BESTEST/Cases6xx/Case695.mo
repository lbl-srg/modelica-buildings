within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case695
  "Case 600, but with increased exterior wall and roof insulation and single cooling and heating setpoint"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
    redeclare BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 20.1]),
    redeclare BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 19.9]),
    matExtWal = extWalCase680,
    roof =    roofCase680,
    staRes(
     annualHea(Min=2.385*3.6e9, Max=2.892*3.6e9, Mean=2.656*3.6e9),
     annualCoo(Min=-8.386*3.6e9, Max=-9.172*3.6e9, Mean=-8.912*3.6e9),
     peakHea(Min=1.795*1000, Max=2.138*1000, Mean=2.000*1000),
     peakCoo(Min=-6.232*1000, Max=-7.541*1000, Mean=-6.979*1000)),
   heaCri(lowerLimit=1.7*3.6e9, upperLimit=3.81*3.6e9),
   cooCri(lowerLimit=-7.49*3.6e9, upperLimit=-10.58*3.6e9));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase680 extWalCase680
    "Exterior wall"
    annotation (Placement(transformation(extent={{60,60},{74,74}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.RoofCase680 roofCase680
    "Roof"
    annotation (Placement(transformation(extent={{80,60},{94,74}})));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case695.mos"
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
This model is the case 695 of the BESTEST validation suite. Case 695 differs from
case 600 in that it has increased exterior wall and roof insulation and it has
single heating and cooling setpoint.
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
end Case695;
