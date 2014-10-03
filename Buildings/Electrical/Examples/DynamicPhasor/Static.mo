within Buildings.Electrical.Examples.DynamicPhasor;
model Static "Example that illustrates the use of static loads"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.FixedVoltage
                                                     source(f=50, V=220)
    "Voltage source"        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                             Load1(
    R=0.516267,
    L=0.3872/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={6,-36})));
  Buildings.Electrical.AC.OnePhase.Lines.Line              line(
    mode=Buildings.Electrical.Types.CableMode.commercial,
    l=100,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu50())
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Impedance
                                             Load2(
    inductive=false,
    R=0.6195198628120355,
    C=1/0.46463869772106686/(2*Modelica.Constants.pi*50))
    annotation (Placement(transformation(extent={{26,-24},{46,-4}})));
  Buildings.Electrical.AC.OnePhase.Lines.Line              line1(
    mode=Buildings.Electrical.Types.CableMode.commercial,
    l=500,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu50())
    annotation (Placement(transformation(extent={{-32,0},{-12,20}})));
  Buildings.Electrical.AC.OnePhase.Lines.Line              line2(
    mode=Buildings.Electrical.Types.CableMode.commercial,
    l=200,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu50())
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive Load3(
    pf=0.8,
    V_nominal=220,
    mode=Buildings.Electrical.Types.Load.VariableZ_y_input,
    P_nominal=-30000)
    annotation (Placement(transformation(extent={{48,0},{68,20}})));
  Modelica.Blocks.Sources.TimeTable timeTable(
    offset=0,
    startTime=0,
    table=[0,0; 0.5,0.8; 0.8,1; 1,1; 1.0001,0; 2,0])
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  Buildings.Electrical.AC.OnePhase.Sensors.GeneralizedSensor s1
    annotation (Placement(transformation(extent={{-34,-46},{-14,-26}})));
  Buildings.Electrical.AC.OnePhase.Sensors.GeneralizedSensor s2
    annotation (Placement(transformation(extent={{-2,-24},{18,-4}})));
  Buildings.Electrical.AC.OnePhase.Sensors.GeneralizedSensor s3
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
equation
  connect(source.terminal, line.terminal_n) annotation (Line(
      points={{-80,10},{-70,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, line1.terminal_n) annotation (Line(
      points={{-50,10},{-32,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line2.terminal_n) annotation (Line(
      points={{-12,10},{-4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(timeTable.y, Load3.y) annotation (Line(
      points={{79,10},{68,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line.terminal_p, s1.terminal_n) annotation (Line(
      points={{-50,10},{-40,10},{-40,-36},{-34,-36}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(s1.terminal_p, Load1.terminal) annotation (Line(
      points={{-14,-36},{-4,-36}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, s2.terminal_n) annotation (Line(
      points={{-12,10},{-6,10},{-6,-14},{-2,-14}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(s2.terminal_p, Load2.terminal) annotation (Line(
      points={{18,-14},{26,-14}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, s3.terminal_n) annotation (Line(
      points={{20,10},{24,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(s3.terminal_p, Load3.terminal) annotation (Line(
      points={{44,10},{48,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.1, Tolerance=1e-06),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model illustrates the use of the load models.
The first two lines are inductive loads, followed by two capacitive loads and a resistive load.
At time equal to <i>1</i> second, all loads consume the same actual power as specified by the
nominal condition. Between <i>t = 0...1</i>, the power is increased from zero to one.
Consequently, the power factor is highest at <i>t=0</i> but decreases to its nominal value
at <i>t=1</i> second.
</p>
</html>",
    revisions="<html>
<ul>
<li>
January 3, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Loads/Examples/DynamicLoads.mos"
        "Simulate and plot"));
end Static;
