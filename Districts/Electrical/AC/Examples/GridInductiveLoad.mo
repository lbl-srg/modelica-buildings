within Districts.Electrical.AC.Examples;
model GridInductiveLoad
  "Model of an inductive load connected to the electrical grid"
  import Districts;
  extends Modelica.Icons.Example;
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
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Inductor inductor(L=
       0.18385) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-24})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor resistor(
      R_ref=92.416) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-54})));
  Districts.Electrical.AC.Sensors.PowerSensor
                      powSen2 "Power sensor"            annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,6})));
  Districts.Electrical.AC.Interfaces.SinglePhasePlug sPhasePlug1
    "Single phase connector"
    annotation (Placement(transformation(extent={{40,26},{60,46}})));
equation
  connect(grid.sPhasePlug, loa.sPhasePlug) annotation (Line(
      points={{-50.1,40},{-50,40},{-50,-20}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(inductor.pin_n,resistor. pin_p) annotation (Line(
      points={{50,-34},{50,-44}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(powSen2.currentN,inductor. pin_p) annotation (Line(
      points={{50,-4},{50,-14}},
      color={85,170,255},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(grid1.sPhasePlug, sPhasePlug1) annotation (Line(
      points={{29.9,40},{30,40},{30,36},{50,36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(powSen2.voltageP, powSen2.currentP) annotation (Line(
      points={{40,6},{40,16},{50,16}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSen2.voltageN, resistor.pin_n) annotation (Line(
      points={{60,6},{70,6},{70,-64},{50,-64}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSen2.currentP, sPhasePlug1.p[1]) annotation (Line(
      points={{50,16},{50,24},{70,24},{70,36},{50,36}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sPhasePlug1.n, resistor.pin_n) annotation (Line(
      points={{50,36},{86,36},{86,-64},{50,-64},{50,-64}},
      color={85,170,255},
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
