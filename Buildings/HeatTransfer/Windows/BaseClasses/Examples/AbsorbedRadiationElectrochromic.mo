within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model AbsorbedRadiationElectrochromic
  "Test model for absorbed radiation for electrochromic window"
  extends AbsorbedRadiation(redeclare
      Data.GlazingSystems.DoubleElectrochromicAir13Clear glaSys);
  annotation (
experiment(Tolerance=1e-6, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/AbsorbedRadiationElectrochromic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the absorption of electrochromic glass.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorbedRadiationElectrochromic;
