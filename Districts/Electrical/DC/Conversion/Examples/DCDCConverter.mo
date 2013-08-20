within Districts.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.DC.Loads.Resistor resistor(R=0.5, useHeatPort=false)
    annotation (Placement(transformation(extent={{20,22},{40,42}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
  Districts.Electrical.DC.Conversion.DCDCConverter conDCDC(conversionFactor=0.5,
      eta=0.9)
    annotation (Placement(transformation(extent={{-46,22},{-26,42}})));
equation
  connect(sou.terminal, conDCDC.terminal_n) annotation (Line(
      points={{-80,32},{-46,32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.terminal_p, resistor.terminal) annotation (Line(
      points={{-26,32},{20,32}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics), experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts DC voltage to DC voltage.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Conversion/Examples/DCDCConverter.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end DCDCConverter;
