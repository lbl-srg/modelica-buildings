within Districts.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Conversion.DCDCConverter     conDCDC(eta=0.9,
      conversionFactor=0.5,
    ground_1=true)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=120)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,10})));
  Districts.Electrical.DC.Loads.Resistor resistor
    annotation (Placement(transformation(extent={{56,0},{76,20}})));
equation
  connect(sou.term, conDCDC.term_n) annotation (Line(
      points={{-60,10},{-10,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.term_p, resistor.term) annotation (Line(
      points={{10,10},{56,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts DC voltage to DC voltage.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 29, 2013, by Thierry S. Nouidui:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/DC/Conversion/Examples/DCDCConverter.mos"
        "Simulate and plot"));
end DCDCConverter;
