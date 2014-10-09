within Districts.Electrical.AC.OnePhase.Lines.Examples;
model ACline
  extends Modelica.Icons.Example;
  Sources.FixedVoltage E(      definiteReference=true,
    f=50,
    Phi=0,
    V=220)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Line line2(
    l=2000,
    V_nominal=220,
    P_nominal=1500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  Loads.InductiveLoadP
                 load2(P_nominal=50,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    V_nominal=220)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Loads.InductiveLoadP
                 load1(
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    P_nominal=150)
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Line line1(
    V_nominal=220,
    P_nominal=5000,
    l=2000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
  Loads.InductiveLoadP
                 load3(
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    P_nominal=450)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Line line3(
    l=2000,
    V_nominal=220,
    P_nominal=1500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
  Loads.InductiveLoadP
                 load4(
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    P_nominal=250)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.5,
    startTime=0.3)
    annotation (Placement(transformation(extent={{76,-50},{56,-30}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{42,-30},{22,-10}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{80,-18},{60,2}})));
  Line line4(
    l=2000,
    V_nominal=220,
    P_nominal=1500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-4,40},{16,60}})));
  Loads.InductiveLoadP
                 load5(
    V_nominal=220,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    P_nominal=150)
    annotation (Placement(transformation(extent={{30,40},{50,60}})));
equation
  connect(E.terminal, line2.terminal_n) annotation (Line(
      points={{-80,6.66134e-16},{-54,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, load1.terminal) annotation (Line(
      points={{-34,20},{-10,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, load2.terminal) annotation (Line(
      points={{-34,6.66134e-16},{-10,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line1.terminal_n) annotation (Line(
      points={{-80,6.66134e-16},{-74,6.66134e-16},{-74,20},{-54,20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, load3.terminal) annotation (Line(
      points={{-34,-20},{-10,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, load4.terminal) annotation (Line(
      points={{-34,-20},{-30,-20},{-30,-40},{-10,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(E.terminal, line3.terminal_n) annotation (Line(
      points={{-80,6.66134e-16},{-74,6.66134e-16},{-74,-20},{-54,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, load4.y) annotation (Line(
      points={{55,-40},{10,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, load3.y) annotation (Line(
      points={{23,-20},{10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp.y, feedback.u2) annotation (Line(
      points={{55,-40},{32,-40},{32,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, feedback.u1) annotation (Line(
      points={{59,-8},{50,-8},{50,-20},{40,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line1.terminal_p, line4.terminal_n) annotation (Line(
      points={{-34,20},{-20,20},{-20,50},{-4,50}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_p, load5.terminal) annotation (Line(
      points={{16,50},{30,50}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ACline;
