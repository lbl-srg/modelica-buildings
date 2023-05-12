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
      annualHea(Min=0.863*3.6e9, Max=1.389*3.6e9, Mean=1.109*3.6e9),
      annualCoo(Min=-2.203*3.6e9, Max=-2.613*3.6e9, Mean=-2.401*3.6e9),
      peakHea(Min=3.052*1000, Max=3.882*1000, Mean=3.377*1000),
      peakCoo(Min=-2.556*1000, Max=-3.376*1000, Mean=-2.993*1000)),
   heaCri(LowerLimit=0.22*3.6e9, UpperLimit=1.91*3.6e9),
   cooCri(LowerLimit=-2.24*3.6e9, UpperLimit=-3.14*3.6e9));

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
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
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
All hours, cool = on if zone temperature above 27&deg;C
</li>
<li>
Otherwise, mechanical equipment is off.
</li>
</ul>
</html>"));
end Case940;
