within Districts.Electrical.AC.AC3ph.Conversion.Examples;
model AC3ph_AC1ph_Converter
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.AC3ph.Conversion.AC3phAC1phConverter tra(eta=0.9,
      conversionFactor=380/220) "Transformer"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Districts.Electrical.AC.AC3ph.Sources.FixedVoltage V(
    f=50,
    V(displayUnit="V") = 380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.5,
    startTime=0.3)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Districts.Electrical.AC.AC1ph.Loads.LoadRL RL_1(mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=4000)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Districts.Electrical.AC.AC1ph.Loads.LoadRL RL_2(mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=4000)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Districts.Electrical.AC.AC1ph.Loads.LoadRL RL_3(mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=4000)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
equation
  connect(V.terminal, tra.terminal_p)        annotation (Line(
      points={{-60,10},{-40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra.terminal_a, RL_1.terminal)        annotation (Line(
      points={{-20,16},{0,16},{0,30},{20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra.terminal_b, RL_2.terminal)        annotation (Line(
      points={{-20,10},{20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra.terminal_c, RL_3.terminal)        annotation (Line(
      points={{-20,4},{0,4},{0,-10},{20,-10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, RL_1.y) annotation (Line(
      points={{59,10},{50,10},{50,30},{40,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, RL_2.y) annotation (Line(
      points={{59,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, RL_3.y) annotation (Line(
      points={{59,10},{50,10},{50,-10},{40,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end AC3ph_AC1ph_Converter;
