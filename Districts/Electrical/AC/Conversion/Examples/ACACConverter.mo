within Districts.Electrical.AC.Conversion.Examples;
model ACACConverter "Test model AC to AC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
//protected
  //fixme. I need to specify a value for the real or imaginary part of resitor.i
public
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor res(
    alpha_ref=100,
    R_ref=1,
    i(re(start=1), im(start=0)),
    T_ref=293.15)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,14})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro1
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Districts.Electrical.AC.Conversion.ACACConverter
    conACAC(conversionFactor=0.5, eta=0.9)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
    f=60,
    V=120,
    phi=0)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-44,10})));
equation
  connect(res.pin_n, gro1.pin)         annotation (Line(
      points={{50,4},{50,-40},{10,-40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(conACAC.pin2_pQS, res.pin_p)            annotation (Line(
      points={{10,20},{10,60},{50,60},{50,24}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(gro1.pin, conACAC.pin2_nQS)          annotation (Line(
      points={{10,-40},{10,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.pin_p, conACAC.pin1_pQS)                         annotation (
      Line(
      points={{-44,20},{-44,60},{-10,60},{-10,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.pin_n, gro.pin)                      annotation (Line(
      points={{-44,0},{-44,-40},{-10,-40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(gro.pin, conACAC.pin1_nQS)          annotation (Line(
      points={{-10,-40},{-10,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts AC voltage to AC voltage.
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
          "Resources/Scripts/Dymola/Electrical/AC/Conversion/Examples/ACACConverter.mos"
        "Simulate and plot"));
end ACACConverter;
