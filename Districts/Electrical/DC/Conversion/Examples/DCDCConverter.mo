within Districts.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Conversion.DCDCConverter     conDCDC(eta=0.9,
      conversionFactor=0.5)
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage sou(V=120)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,10})));
  Modelica.Electrical.Analog.Basic.Resistor res(R=1)      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,10})));
  Modelica.Electrical.Analog.Basic.Ground gro1
  annotation (Placement(transformation(extent={{2,-68},{18,-52}},    rotation=0)));
  Modelica.Electrical.Analog.Basic.Ground gro
  annotation (Placement(transformation(extent={{-18,-68},{-2,-52}},  rotation=0)));
equation
  connect(sou.p, conDCDC.pin1_pDC)                   annotation (Line(
      points={{-60,20},{-60,60},{-10,60},{-10,16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, conDCDC.pin1_nDC)                   annotation (Line(
      points={{-60,0},{-60,-40},{-10,-40},{-10,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.pin2_pDC, res.p)            annotation (Line(
      points={{10,16},{10,60},{60,60},{60,20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.pin2_nDC, res.n)            annotation (Line(
      points={{10,-4},{10,-40},{60,-40},{60,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(gro1.p, conDCDC.pin2_nDC)          annotation (Line(
      points={{10,-52},{10,-4}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(gro.p, conDCDC.pin1_nDC)          annotation (Line(
      points={{-10,-52},{-10,-4}},
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
