within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case685
  "Case 600, but with single setpoint for heating and cooling"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
   redeclare BaseClasses.DaySchedule TSetCoo(table=[0.0,273.15 + 20.1]),
   redeclare BaseClasses.DaySchedule TSetHea(table=[0.0,273.15 + 19.9]),
    staRes(
     annualHea(Min=4.532*3.6e9, Max=5.042*3.6e9, Mean=4.763*3.6e9),
     annualCoo(Min=-8.238*3.6e9, Max=-9.130*3.6e9, Mean=-8.886*3.6e9),
     peakHea(Min=3.032*1000, Max=3.374*1000, Mean=3.183*1000),
     peakCoo(Min=-6.071*1000, Max=-7.159*1000, Mean=-6.743*1000)),
   heaCri(lowerLimit=4.08*3.6e9, upperLimit=5.75*3.6e9),
   cooCri(lowerLimit=-7.7*3.6e9, upperLimit=-10.14*3.6e9));

annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case685.mos"
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
This model is the case 685 of the BESTEST validation suite. Case 685 differs from
case 600 in that it has single heating and cooling setpoint.
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
end Case685;
