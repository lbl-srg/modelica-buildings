within Districts.Electrical.AC.AC1ph.Conversion.Examples;
model ACDCConverter "Test model AC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Loads.Resistor    res(R=1)      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={60,10})));
  Districts.Electrical.AC.AC1ph.Conversion.ACDCConverter conversion(
    eta=0.9,
    conversionFactor=0.5,
    ground_AC=false)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.AC1ph.Sources.FixedVoltage                    sou(
    f=60,
    V=120,
    phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,10})));
equation
  connect(sou.terminal, conversion.terminal_n) annotation (Line(
      points={{-52,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(conversion.terminal_p, res.terminal) annotation (Line(
      points={{10,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to DC voltage.
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
          "Resources/Scripts/Dymola/Electrical/AC/Conversion/Examples/ACDCConverter.mos"
        "Simulate and plot"));
end ACDCConverter;
