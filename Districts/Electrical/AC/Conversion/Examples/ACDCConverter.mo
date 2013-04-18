within Districts.Electrical.AC.Conversion.Examples;
model ACDCConverter "Test model AC to DC converter"
  import Districts;
  extends Modelica.Icons.Example;

  Districts.Electrical.DC.Loads.Resistor    res(R=1)      annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={60,10})));
  Modelica.Electrical.Analog.Basic.Ground groDC
  annotation (Placement(transformation(extent={{12,-24},{32,-4}},    rotation=0)));
  Districts.Electrical.AC.Conversion.ACDCConverter
    conACDC(eta=0.9, conversionFactor=0.5)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro
    annotation (Placement(transformation(extent={{-82,-20},{-62,0}})));
  Districts.Electrical.AC.Sources.ConstantVoltage                       sou(
    f=60,
    V=120,
    phi=0)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-62,10})));
  Districts.Electrical.DC.Interfaces.DCplug dCplug1
    annotation (Placement(transformation(extent={{12,0},{32,20}})));
equation
  connect(gro.pin, sou.n) annotation (Line(
      points={{-72,0},{-72,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, conACDC.plug1) annotation (Line(
      points={{-52,10},{-10,10}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conACDC.dCplug, res.dcPlug) annotation (Line(
      points={{10,10},{50,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conACDC.dCplug, dCplug1) annotation (Line(
      points={{10,10},{22,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dCplug1.n, groDC.p) annotation (Line(
      points={{22,10},{22,-4}},
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
