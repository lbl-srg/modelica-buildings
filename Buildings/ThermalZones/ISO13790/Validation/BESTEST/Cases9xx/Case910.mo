within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case910 "Case 900, but the window has an overhang"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(zonHVAC(
        shaRedFac=0.84));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case910.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the case 910 of the BESTEST validation suite.
Case 910 differs from case 900 in that the south-oriented window has an overhang of 1 meter.
</p>
<h4>Implementation</h4>
<p>
The shading reduction factor was set to 0.84. This value was calculated based on Table G.6 of the ISO13790 standard. 
</p>
</html>", revisions="<html><ul>
<li>
May 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case910;
