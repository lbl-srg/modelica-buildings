within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case920 "Case 900, but with windows on East and West side walls"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(zonHVAC(
        AWin={0,6,0,6}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case920.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the case 920 of the BESTEST validation suite.
Case 920 differs from case 900 in that the west and east facing walls
have a window, but there is no window in the south facing wall.
</p>
</html>", revisions="<html><ul>
<li>
Mar 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case920;
