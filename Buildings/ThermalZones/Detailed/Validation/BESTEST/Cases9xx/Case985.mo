within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case985
  "Case 900, but with single heating and cooling setpoint"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900(
    redeclare BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 20.1]),
    redeclare BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 19.9]),
    staRes(
     annualHea(Min=2.120*3.6e9, Max=2.801*3.6e9, Mean=2.398*3.6e9),
     annualCoo(Min=-5.880*3.6e9, Max=-7.273*3.6e9, Mean=-6.351*3.6e9),
     peakHea(Min=2.452*1000, Max=2.785*1000, Mean=2.631*1000),
     peakCoo(Min=-3.208*1000, Max=-4.225*1000, Mean=-3.824*1000)),
   heaCri(LowerLimit=1.68*3.6e9, UpperLimit=3.09*3.6e9),
   cooCri(LowerLimit=-5.95*3.6e9, UpperLimit=-7.26*3.6e9));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case985.mos"
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
This model is the case 985 of the BESTEST validation suite. Case 985 differs from
case 900 in that it has single heating and cooling setpoint.
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
end Case985;
