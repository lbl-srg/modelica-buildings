within Districts.Electrical.QuasiStationary.SinglePhase.Examples;
model GridDCLoad "Model of a DC load connected to the grid"
  extends Modelica.Icons.Example;
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-60,-82},{-40,-62}})));
  Sources.Grid grid(
    V=380,
    f=60,
    phi=0)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Sensors.PowerSensor powSen1 "Power sensor"            annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,20})));
  Conversion.ACDCConverter
    idealACDCConverter1(conversionFactor=12/380, eta=0.9)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=1) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-30})));
  Modelica.Electrical.Analog.Basic.Ground Ground1
  annotation (Placement(transformation(extent={{2,-80},{18,-64}},    rotation=0)));
equation
  connect(grid.pin, powSen1.currentP) annotation (Line(
      points={{-50,40},{-50,30}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen1.voltageP, grid.pin) annotation (Line(
      points={{-40,20},{-40,34},{-50,34},{-50,40}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(idealACDCConverter1.pin_nQS, ground.pin) annotation (Line(
      points={{-50,-40},{-50,-62}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(idealACDCConverter1.pin_pDC, resistor.n) annotation (Line(
      points={{-30,-20},{10,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(resistor.p, idealACDCConverter1.pin_nDC) annotation (Line(
      points={{10,-40},{-30,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(idealACDCConverter1.pin_pQS, powSen1.currentN) annotation (Line(
      points={{-50,-20},{-50,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(resistor.p, Ground1.p) annotation (Line(
      points={{10,-40},{10,-64}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(powSen1.voltageN, ground.pin) annotation (Line(
      points={{-60,20},{-70,20},{-70,-50},{-50,-50},{-50,-62}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),  graphics),
    experiment(StopTime=3600, Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model for inductive load. The circuit on the left hand side
uses an inductive load, whereas the circuit on the right hand side uses a resistor and inductance in
series.
The parameters of the inductor and resistor are such that the real power and the phase angle are
identical (up to the numerical precision of the parameters) for the two systems.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Examples/GridDCLoad.mos"
        "Simulate and plot"));
end GridDCLoad;
