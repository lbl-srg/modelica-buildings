within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case680 "Case 600, but with increased exterior wall and roof insulation"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zonHVAC(UWal=
         0.15, URoo=0.1));
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case680.mos"
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
This model is the case 680 of the BESTEST validation suite. Case 680 differs from
case 600 in that it has increased exterior wall and roof insulation.
</p>
</html>"));
end Case680;
