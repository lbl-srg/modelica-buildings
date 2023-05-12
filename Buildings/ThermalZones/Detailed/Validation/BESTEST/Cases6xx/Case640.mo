within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case640 "Case 600, but with heating schedule"
  extends Case600(
    TSetHea(table=[      0, 273.15 + 10;
                    7*3600, 273.15 + 10;
                    8*3600, 273.15 + 20;
                   23*3600, 273.15 + 20;
                   23*3600,273.15 + 10;
                   24*3600,273.15 + 10]),
  staRes(
    annualHea(Min=2.403*3.6e9, Max=2.682*3.6e9, Mean=2.612*3.6e9),
    annualCoo(Min=-5.237*3.6e9, Max=-5.893*3.6e9, Mean=-5.636*3.6e9),
    peakHea(Min = 4.039*1000, Max = 4.658*1000, Mean = 4.369 * 1000),
    peakCoo(Min= -5.365*1000, Max = -6.429*1000, Mean= -5.973 * 1000)),
   heaCri(LowerLimit=1.58*3.6e9, UpperLimit=3.76*3.6e9),
   cooCri(LowerLimit=-4.44*3.6e9, UpperLimit=-6.86*3.6e9));

    annotation (
              __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case640.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),    Documentation(revisions="<html>
<ul>
<li>
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
<li>
May 12, 2022, by Jianjun Hu:<br/>
Changed the heating setpoint schedule.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>      
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
From 0700 hours to 0800 hours, the thermostat set point shall vary linearly with
time from 10 &deg;C to 20 &deg;C.
If the zone temperature is less than the thermostat set point for a subhourly
time step, heat shall be added to the zone such that the zone temperature at the
end of each subhourly time step shall correspond to the thermostat set point that
occurs at the end of each subhourly time step.
</li>
<li>
From 0800 hours to 2300 hours, heat = on if zone temperature is below 20&deg;C
</li>
<li>
All hours, cool = on if zone temperature above 27&deg;C
</li>
<li>
Otherwise, mechanical equipment is off.
</li>
</ul>
</html>"));
end Case640;
