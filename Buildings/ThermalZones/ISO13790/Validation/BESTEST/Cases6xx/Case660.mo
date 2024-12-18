within Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case660 "Case 600, but with low-emissivity windows with Argon gas"
  extends Buildings.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zonHVAC(
      UWin=1.45,
      gFac=0.44,
      coeFac={1,-0.152,0.51,-0.526}));
 annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case660.mos"
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
This model is the case 660 of the BESTEST validation suite. Case 660 differs from
case 600 in that it has low-emissivity windows with Argon gas.
</p>
</html>"));
end Case660;
