within Districts.Electrical.AC.Examples;
model GridInductiveLoad
  "Model of an inductive load connected to the electrical grid"
  import Districts;
  extends Modelica.Icons.Example;
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Districts.Electrical.AC.Loads.InductorResistor
                      loa(P_nominal=1e3) "Inductive load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,-30})));
  Districts.Electrical.AC.Sources.Grid
               grid(
    V=380,
    f=60,
    phi=0.5235987755983)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Districts.Electrical.AC.Sources.Grid
               grid1(
    V=380,
    f=60,
    phi=0.5235987755983)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Inductor inductor(L=
       0.18385) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-20})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor resistor(
      R_ref=92.416) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-50})));
  Districts.Electrical.AC.Sensors.PowerSensor
                      powSen1 "Power sensor"            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,20})));
  Districts.Electrical.AC.Sensors.PowerSensor
                      powSen2 "Power sensor"            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,20})));
equation
  connect(loa.pin_n, ground.pin) annotation (Line(
      points={{-50,-40},{-50,-70},{6.66134e-16,-70}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(inductor.pin_n, resistor.pin_p) annotation (Line(
      points={{50,-30},{50,-40}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(resistor.pin_n, ground.pin) annotation (Line(
      points={{50,-60},{50,-70},{0,-70}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(grid.pin, powSen1.currentP) annotation (Line(
      points={{-50,40},{-50,30}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen1.currentN, loa.pin_p) annotation (Line(
      points={{-50,10},{-50,-20}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen1.voltageN, ground.pin) annotation (Line(
      points={{-40,20},{-18,20},{-18,-70},{6.66134e-16,-70}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen1.voltageP, grid.pin) annotation (Line(
      points={{-60,20},{-60,34},{-50,34},{-50,40}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen2.currentP, grid1.pin) annotation (Line(
      points={{50,30},{50,40}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen2.voltageP, grid1.pin) annotation (Line(
      points={{40,20},{40,34},{50,34},{50,40}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen2.voltageN, ground.pin) annotation (Line(
      points={{60,20},{70,20},{70,-70},{0,-70}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen2.currentN, inductor.pin_p) annotation (Line(
      points={{50,10},{50,-10}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,80}}),   graphics),
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
January 2, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/Examples/GridInductiveLoad.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end GridInductiveLoad;
