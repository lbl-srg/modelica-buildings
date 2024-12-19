within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case980 "Case 900, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(zonHVAC(
        UWal=0.15, URoo=0.1))
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case980.mos"
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
This model is the case 980 of the BESTEST validation suite. Case 980 differs from
case 900 in that it has increased exterior wall and roof insulation.
</p>
</html>"));
end Case980;
