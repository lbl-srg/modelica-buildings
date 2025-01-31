within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case685
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(TSetCoo(
        table=[0.0,273.15 + 20.1]), TSetHea(table=[0.0,273.15 + 19.9]));
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case685.mos"
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
