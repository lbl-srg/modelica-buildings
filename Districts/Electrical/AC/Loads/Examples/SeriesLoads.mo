within Districts.Electrical.AC.Loads.Examples;
model SeriesLoads
  "Example that illustrates the use of the load models at constant voltage"
  extends Modelica.Icons.Example;
  VariableInductorResistor varIndRes(P_nominal=1e3)
    "Variable inductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-16,-10})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.Ramp ramp(duration=1)
    annotation (Placement(transformation(extent={{38,-40},{18,-20}})));
  InductorResistor indRes(                pf=0.8, P_nominal=1e3)
    "Constant inductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-10,70})));
  VariableCapacitorResistor varConRes(P_nominal=1e3)
    "Variable conductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-16,-50})));
  CapacitorResistor conRes(                pf=0.9, P_nominal=1e3)
    "Constant conductor and resistor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-10,30})));
  Sources.ConstantVoltage                                               sou(
    f=60,
    V=120,
    phi=0) "Voltage source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,-10})));
  SeriesConnection seriesConnection1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
  SeriesConnection seriesConnection2(measureP=true)
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,50})));
equation
  connect(ramp.y, varIndRes.y) annotation (Line(
      points={{17,-30},{8.5,-30},{8.5,-10},{-6,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varConRes.y, ramp.y) annotation (Line(
      points={{-6,-50},{8,-50},{8,-30},{17,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gro.pin, sou.n) annotation (Line(
      points={{-90,-40},{-90,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, seriesConnection1.sPhasePlug) annotation (Line(
      points={{-90,4.44089e-16},{-90,50},{-60,50},{-60,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(sou.sPhasePlug, seriesConnection2.sPhasePlug) annotation (Line(
      points={{-90,4.44089e-16},{-90,50},{-50,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(indRes.sPhasePlug, seriesConnection2.seriesLoads[1]) annotation (Line(
      points={{-20,70},{-20,52},{-30,52},{-30,49}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conRes.sPhasePlug, seriesConnection2.seriesLoads[2]) annotation (Line(
      points={{-20,30},{-20,48},{-30,48},{-30,51}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(seriesConnection1.seriesLoads[1], varConRes.sPhasePlug) annotation (
      Line(
      points={{-40,-31},{-34,-31},{-34,-50},{-26,-50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(seriesConnection1.seriesLoads[2], varIndRes.sPhasePlug) annotation (
      Line(
      points={{-40,-29},{-34,-29},{-34,-10},{-26,-10}},
      color={0,0,0},
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
          "Resources/Scripts/Dymola/Electrical/AC/Loads/Examples/SeriesLoads.mos"
        "Simulate and plot"));
end SeriesLoads;
