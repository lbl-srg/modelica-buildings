within Districts.Electrical.QuasiStationary.SinglePhase.Loads.Examples;
model SeriesLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  VariableInductorResistor varIndRes(P_nominal=1e3)
    "Variable inductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={10,10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-70,-94},{-50,-74}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource sou(
    f=60,
    V=120,
    phi=0) "Voltage source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,10})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Sensors.PowerSensor powSenVar "Power sensor"       annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,50})));
  InductorResistor indRes(                pf=0.8, P_nominal=1e3)
    "Constant inductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={70,10})));
  Sensors.PowerSensor powSenCon "Power sensor"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
  VariableCapacitorResistor varConRes(P_nominal=1e3)
    "Variable conductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={10,-30})));
  CapacitorResistor conRes(                pf=0.9, P_nominal=1e3)
    "Constant conductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={70,-30})));
equation
  connect(gro.pin, sou.pin_n) annotation (Line(
      points={{-60,-74},{-60,0}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(ramp.y, varIndRes.y) annotation (Line(
      points={{-19,10},{-4.5,10},{-4.5,10},{1.33227e-15,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varIndRes.pin_p, powSenVar.currentN)       annotation (Line(
      points={{10,20},{10,25},{10,25},{10,40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVar.currentP, sou.pin_p)       annotation (Line(
      points={{10,60},{10,70},{-60,70},{-60,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenCon.currentN, indRes.pin_p)    annotation (Line(
      points={{70,40},{70,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenCon.currentP, sou.pin_p)    annotation (Line(
      points={{70,60},{70,70},{-60,70},{-60,20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenCon.voltageN, powSenCon.currentP)       annotation (Line(
      points={{60,50},{52,50},{52,70},{70,70},{70,60}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(powSenVar.voltageN, powSenVar.currentP)             annotation (Line(
      points={{0,50},{-10,50},{-10,70},{10,70},{10,60}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varIndRes.pin_n, varConRes.pin_p) annotation (Line(
      points={{10,1.77636e-15},{10,-20},{10,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(indRes.pin_n, conRes.pin_p) annotation (Line(
      points={{70,1.33227e-015},{70,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varConRes.pin_n, gro.pin) annotation (Line(
      points={{10,-40},{10,-60},{-60,-60},{-60,-74}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(conRes.pin_n, gro.pin) annotation (Line(
      points={{70,-40},{70,-60},{-60,-60},{-60,-74}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varConRes.y, ramp.y) annotation (Line(
      points={{1.33227e-15,-30},{-12,-30},{-12,10},{-19,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(powSenCon.voltageP, conRes.pin_n) annotation (Line(
      points={{80,50},{90,50},{90,-60},{70,-60},{70,-40}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(varConRes.pin_n, powSenVar.voltageP) annotation (Line(
      points={{10,-40},{10,-60},{30,-60},{30,50},{20,50}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model illustrates the use of the load models.
Both circuits have an inductive and capactive load in series.
</p>
</html>",
    revisions="<html>
<ul>
<li>
January 3, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Commands(file=
          "Resources/Scripts/Dymola/Electrical/QuasiStationary/SinglePhase/Loads/Examples/SeriesLoads.mos"
        "Simulate and plot"));
end SeriesLoads;
