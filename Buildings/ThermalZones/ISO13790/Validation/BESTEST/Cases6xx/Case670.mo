within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case670 "Case 600, but has single pane window with clear glass"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zonHVAC(
      UWin=7.8,
      gFac=0.864,
      coeFac={0.998,0.137,-0.745,1.21,-0.668}));
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case670.mos"
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
This model is the case 670 of the BESTEST validation suite. Case 670 differs from
case 600 in that it has single pane window with clear glass.
</p>
</html>"));
end Case670;
