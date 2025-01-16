within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case940 "Case 900, but with heating schedule"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(TSetHea(
        table=[0,273.15 + 10; 7*3600,273.15 + 10; 8*3600,273.15 + 20; 23*3600,
          273.15 + 20; 23*3600,273.15 + 10; 24*3600,273.15 + 10],
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case940.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 940 of the BESTEST validation suite.
Case940 is the same as Case900, but with the following modifications:
</p>
<ul>
<li>
From 23h00 hours to 07h00 hours, heat = on if zone temperature is below 10&deg;C
</li>
<li>
From 07h00 hours to 08h00 hours, the thermostat setpoint shall vary linearly with
time from 10 &deg;C to 20 &deg;C.
If the zone temperature is less than the thermostat setpoint for a subhourly
time step, heat shall be added to the zone such that the zone temperature at the
end of each subhourly time step shall correspond to the thermostat setpoint that
occurs at the end of each subhourly time step.
</li>
<li>
From 08h00 hours to 23h00 hours, heat = on if zone temperature is below 20&deg;C
</li>
<li>
All hours, cool = on if zone temperature above 27&deg;C
</li>
<li>
Otherwise, mechanical equipment is off.
</li>
</ul>
</html>", revisions="<html><ul>
<li>
Mar 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case940;
