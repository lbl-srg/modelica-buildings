within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case640 "Case 600, but with heating schedule"
  extends Case600(
    TSetHea(table=[      0, 273.15 + 10;
                    7*3600, 273.15 + 10;
                    7*3600, 273.15 + 20;
                   23*3600, 273.15 + 20;
                   23*3600,273.15 + 10;
                   24*3600,273.15 + 10]),
  staRes(
    annualHea(Min=2.751*3.6e9, Max=3.803*3.6e9, Mean=3.207*3.6e9),
    annualCoo(Min=-5.952*3.6e9, Max=-7.811*3.6e9, Mean=-6.592*3.6e9),
    peakHea(Min = 5.232*1000, Max = 6.954*1000, Mean = 6.031 * 1000),
    peakCoo(Min= -5.892*1000, Max = 6.776*1000, Mean= -6.410 * 1000)));

    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case640.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),    Documentation(revisions="<html>
<ul>
<li>
July 15, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 26, 2012, by Sebastian Giglmayr and Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used for the basic test case 640 of the BESTEST validation suite.
Case640 is the same as Case600, but with the following modifications:
</p>
<ul>
<li>
From 2300 hours to 0700 hours, heat = on if zone temperature is below 10&deg;C
</li>
<li>
From 0700 hours to 2300 hours, heat = on if zone temperature is above 20&deg;C
</li>
<li>
All hours, cool = on if zone temperature below 27&deg;C
</li>
<li>
Otherwise, mechanical equipment is off.
</li>
</ul>
</html>"));
end Case640;
