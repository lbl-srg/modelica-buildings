within Districts.Electrical.DC.Loads.Examples;
model VariableLoad
  extends Modelica.Icons.Example;
  Conductor loa1(P_nominal=50,
    V_nominal=12,
    linear=false) "Load"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Sources.ConstantVoltage sou(V=12) "Voltage source"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Electrical.Analog.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Conductor loa2(P_nominal=50, mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    V_nominal=12) "Load"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp varLoad_y(
    height=0.8,
    duration=0.5,
    startTime=0.3,
    offset=0)
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Conductor loa3(P_nominal=50, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    V_nominal=12) "Load"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp varLoad_P(
    duration=0.5,
    startTime=0.3,
    height=120,
    offset=-20)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  Lines.TwoPortResistance res(R=0.1) "Resistance"
    annotation (Placement(transformation(extent={{-32,40},{-12,60}})));
  Sensors.GeneralizedSensor sen
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(gro.p, sou.n)  annotation (Line(
      points={{-80,18},{-80,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, loa2.terminal)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,10},{-4.44089e-16,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_y.y, loa2.y)  annotation (Line(
      points={{39,10},{20,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, loa3.terminal)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,-30},{-4.44089e-16,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad_P.y, loa3.Pow)  annotation (Line(
      points={{39,-30},{20,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.terminal, res.terminal_n)
                                      annotation (Line(
      points={{-60,30},{-40,30},{-40,50},{-32,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(res.terminal_p, sen.terminal_n) annotation (Line(
      points={{-12,50},{0,50}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, loa1.terminal) annotation (Line(
      points={{20,50},{40,50}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/Electrical/DC/Loads/Examples/VariableLoad.mos"
        "Simulate and plot"));
end VariableLoad;
