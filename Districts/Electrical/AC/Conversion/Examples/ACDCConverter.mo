within Districts.Electrical.AC.Conversion.Examples;
model ACDCConverter "Test model AC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Modelica.Electrical.Analog.Basic.Resistor res(R=1)      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,10})));
  Modelica.Electrical.Analog.Basic.Ground groDC
  annotation (Placement(transformation(extent={{0,-60},{20,-40}},    rotation=0)));
  Districts.Electrical.AC.Conversion.ACDCConverter
    conACDC(eta=0.9, conversionFactor=0.5)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground groAC
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
protected
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
    final f=60,
    final V=120,
    final phi(displayUnit="rad") = 0) "Voltage source"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,10})));
equation
  connect(res.p, conACDC.pin_pDC)            annotation (Line(
      points={{60,20},{60,60},{10,60},{10,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.n, conACDC.pin_nDC)            annotation (Line(
      points={{60,0},{60,-40},{10,-40},{10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(groDC.p, conACDC.pin_nDC)         annotation (Line(
      points={{10,-40},{10,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(groAC.pin, conACDC.pin_nQS)        annotation (Line(
      points={{-10,-40},{-10,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.pin_p, conACDC.pin_pQS)       annotation (Line(
      points={{-60,20},{-60,60},{-10,60},{-10,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.pin_n, groAC.pin)  annotation (Line(
      points={{-60,0},{-60,-40},{-10,-40}},
      color={85,170,255},
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
