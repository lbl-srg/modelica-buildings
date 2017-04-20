within Buildings.HeatTransfer.Windows.BaseClasses.Examples;
model WindowRadiationElectrochromic
  "Test model for window radiation for an electrochromic window"
  extends WindowRadiation(redeclare
      Data.GlazingSystems.DoubleElectrochromicAir13Clear glaSys);
  Modelica.Blocks.Sources.Ramp uSta(duration=86400, startTime=5*86400)
    "Window control signal"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(uSta.y, winRad.uSta) annotation (Line(points={{81,-70},{92,-70},{92,-6},
          {74.8,-6},{74.8,-1.6}}, color={0,0,127}));

  annotation (
experiment(Tolerance=1e-6, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Windows/BaseClasses/Examples/WindowRadiationElectrochromic.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the implementation of the electrochromic window.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end WindowRadiationElectrochromic;
