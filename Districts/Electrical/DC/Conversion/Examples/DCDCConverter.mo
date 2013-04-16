within Districts.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Conversion.DCDCConverter     conDCDC(eta=0.9,
      conversionFactor=0.5)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.DC.Sources.ConstantVoltage    sou(V=120)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Electrical.Analog.Basic.Ground gro
  annotation (Placement(transformation(extent={{-88,-34},{-72,-18}}, rotation=0)));
  Districts.Electrical.DC.Loads.Resistor resistor
    annotation (Placement(transformation(extent={{56,0},{76,20}})));
  Districts.Electrical.DC.Interfaces.DCplug dCplug1
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Modelica.Electrical.Analog.Basic.Ground gro1
  annotation (Placement(transformation(extent={{12,-24},{28,-8}},    rotation=0)));
equation
  connect(sou.n, gro.p) annotation (Line(
      points={{-80,10},{-80,-18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.dcPlug, conDCDC.dCplug1) annotation (Line(
      points={{-60,10},{-10,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.dCplug2, dCplug1) annotation (Line(
      points={{10,10},{20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.dCplug2, resistor.dcPlug) annotation (Line(
      points={{10,10},{56,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dCplug1.n, gro1.p) annotation (Line(
      points={{20,10},{20,-8}},
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
