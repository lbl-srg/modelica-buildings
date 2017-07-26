within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case940 "Case 900, but with heating schedule"
  extends Case900(
    TSetHea(table=[      0, 273.15 + 10;
                    7*3600, 273.15 + 10;
                    7*3600, 273.15 + 20;
                   23*3600, 273.15 + 20;
                   23*3600,273.15 + 10;
                   24*3600,273.15 + 10]),
    staRes(
      annualHea(Min=0.793*3.6e9, Max=1.411*3.6e9, Mean=1.160*3.6e9),
      annualCoo(Min=-2.079*3.6e9, Max=-3.241*3.6e9, Mean=-2.578*3.6e9),
      peakHea(Min=3.980*1000, Max=6.428*1000, Mean=5.494*1000),
      peakCoo(Min=-2.886*1000, Max=-3.871*1000, Mean=-1.340*1000)));

    annotation (
       __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case940.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
July 16, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 26, 2012, by Rainer Czetina and Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used for the basic test case 940 of the BESTEST validation suite.
Case940 is the same as Case900, but with the following modifications:
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
end Case940;
