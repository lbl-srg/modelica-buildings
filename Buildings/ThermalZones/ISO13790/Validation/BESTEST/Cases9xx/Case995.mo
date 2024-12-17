within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case995 "Case 900, but with single heating and cooling setpoint and increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(
    zonHVAC(UWal=0.15, URoo=0.1),
    TSetHea(table=[0.0,273.15 + 19.9]),
    TSetCoo(table=[0.0,273.15 + 20.1]));
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case995.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
May 3, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is the case 995 of the BESTEST validation suite. Case 995 differs from
case 900 in that it has increased exterior wall and roof insulation and it has
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
end Case995;
