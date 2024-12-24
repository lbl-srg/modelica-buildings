within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case900 "Case 600, but with high thermal mass"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(
      zonHVAC(redeclare replaceable
        Buildings.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas));

 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case900.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900 of the BESTEST validation suite.
Case 900 is a heavy-weight building with room temperature control set to <i>20</i>&deg;C
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south.
</p>
</html>", revisions="<html><ul>
<li>
May 2, 2024, by Alessandro Maccarini:<br/>
Updated according to ASHRAE 140-2020.
</li>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case900;
