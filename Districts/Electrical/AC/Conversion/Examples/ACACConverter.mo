within Districts.Electrical.AC.Conversion.Examples;
model ACACConverter "Test model AC to AC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
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
        origin={50,10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro1
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Districts.Electrical.AC.Conversion.ACACConverter
    conACAC(conversionFactor=0.5, eta=0.9)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.Sources.ConstantVoltage                       sou(
    f=60,
    V=120,
    phi=0)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-60,10})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug plug1
    "Single phase connector side 2"
    annotation (Placement(transformation(extent={{6,0},{26,20}})));
equation
  connect(res.pin_n, gro1.pin)         annotation (Line(
      points={{50,1.33227e-15},{50,-40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(conACAC.plug2, plug1) annotation (Line(
      points={{10,10},{16,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, conACAC.plug1) annotation (Line(
      points={{-50,10},{-10,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(gro.pin, sou.n) annotation (Line(
      points={{-70,4.44089e-16},{-70,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(plug1.p[1], res.pin_p) annotation (Line(
      points={{16,10},{16,50},{50,50},{50,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(plug1.n, gro1.pin) annotation (Line(
      points={{16,10},{16,-40},{50,-40}},
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
