within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case930 "Case 920, but with added overhang and sidefins"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx.Case900(zonHVAC(
        AWin={0,6,0,6}, shaRedFac=0.846*0.915));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case930.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is the case 930 of the BESTEST validation suite.
Case 930 differs from case 920 in that windows on the west and 
east walls have an overhang and side fins.
</p>
<h4>Implementation</h4>
<p>
The shading reduction factor was set to 0.846 for overhang and 0.915 for side fins. These values were calculated based on Table G.6 and
Table G.7 of the ISO13790 standard. 
</p>
</html>", revisions="<html><ul>
<li>
Mar 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case930;