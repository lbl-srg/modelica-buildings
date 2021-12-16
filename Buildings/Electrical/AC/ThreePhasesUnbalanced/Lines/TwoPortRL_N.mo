within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortRL_N
  "Model of a resistive-inductive element with two electrical ports and neutral line cable"
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort_N;
  parameter Modelica.Units.SI.Resistance R "Resistance at temperature T_ref";
  parameter Modelica.Units.SI.Resistance Rn
    "Resistance of neutral cable at temperature T_ref";
  parameter Modelica.Units.SI.Temperature T_ref=298.15 "Reference temperature"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature M=507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Inductance L "Inductance";
  parameter Modelica.Units.SI.Inductance Ln "Inductance of neutral cable";
  parameter Modelica.Units.SI.Current i1_start[2]={0,0}
    "Initial current phasor of phase 1 (positive if entering from terminal p)"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Modelica.Units.SI.Current i2_start[2]={0,0}
    "Initial current phasor of phase 2 (positive if entering from terminal p)"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Modelica.Units.SI.Current i3_start[2]={0,0}
    "Initial current phasor of phase 3 (positive if entering from terminal p)"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.FixedZ_dynamic) = Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Type of model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modeling assumption"));
  OnePhase.Lines.TwoPortRL  phase1(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=mode,
    final useHeatPort=useHeatPort,
    i_start=i1_start) "Impedance line 1"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortRL phase2(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=mode,
    final useHeatPort=useHeatPort,
    i_start=i2_start) "Impedance line 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortRL phase3(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=mode,
    final useHeatPort=useHeatPort,
    i_start=i3_start) "Impedance line 3"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  OnePhase.Lines.TwoPortRL neutral(
    final T_ref=T_ref,
    final M=M,
    final mode=mode,
    final useHeatPort=useHeatPort,
    final R=Rn,
    final L=Ln,
    i_start=-i1_start - i2_start - i3_start) "neutral cable RL model"
    annotation (Placement(transformation(extent={{-10,-66},{10,-46}})));
equation
  // Joule Losses
  LossPower = phase1.LossPower + phase2.LossPower + phase3.LossPower + neutral.LossPower;

  connect(terminal_n.phase[1], phase1.terminal_n) annotation (Line(
      points={{-100,0},{-20,0},{-20,30},{-10,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[2], phase2.terminal_n) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(terminal_n.phase[3], phase3.terminal_n) annotation (Line(
      points={{-100,4.44089e-16},{-20,4.44089e-16},{-20,-30},{-10,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase1.terminal_p, terminal_p.phase[1]) annotation (Line(
      points={{10,30},{20,30},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase2.terminal_p, terminal_p.phase[2]) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase3.terminal_p, terminal_p.phase[3]) annotation (Line(
      points={{10,-30},{20,-30},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));

  connect(phase1.heatPort, heatPort) annotation (Line(
      points={{0,20},{0,14},{-32,14},{-32,-72},{0,-72},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase3.heatPort, heatPort) annotation (Line(
      points={{0,-40},{0,-44},{-32,-44},{-32,-72},{0,-72},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase2.heatPort, heatPort) annotation (Line(
      points={{4.44089e-16,-10},{4.44089e-16,-16},{-32,-16},{-32,-72},{
          4.44089e-16,-72},{4.44089e-16,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(neutral.heatPort, heatPort) annotation (Line(
      points={{0,-66},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(neutral.terminal_p, terminal_p.phase[4]) annotation (Line(
      points={{10,-56},{20,-56},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(neutral.terminal_n, terminal_n.phase[4]) annotation (Line(
      points={{-10,-56},{-20,-56},{-20,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="line",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
          Text(
            extent={{-150,-28},{136,-60}},
            textColor={0,0,0},
          textString="R=%R, L=%L"),
          Line(points={{-92,0},{-72,0}}, color={0,0,0}),
          Line(points={{68,0},{88,0}}, color={0,0,0}),
        Rectangle(
          extent={{-72,32},{68,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{66,8.0824e-15}},
          color={0,0,0},
          origin={52,0},
          rotation=180),
        Line(
          points={{-48,0},{-42,0},{-40,4},{-36,-4},{-32,4},{-28,-4},{-24,4},{-20,
              -4},{-18,0},{-14,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-6,6},{6,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{6,6},{18,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,6},{30,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,0},{30,-12}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
            extent={{-142,80},{138,40}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
Resistive-inductive model that connects two AC three-phase
unbalanced interfaces with neutral line. This model can be used to represent a
cable in a three-phase unbalanced AC system.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortRL_N.png\"/>
</p>

<p>
The model represents the lumped impedances as shown in the figure above.
Assuming that the overall cable has a resistance <i>R</i> and an inductance
<i>L</i>, each line has an inductance equal to <i>L/3</i> and a resistance
equal to <i>R/3</i>.
</p>
<p>
The resistance and the inductance of the neutral cable are defined separately using the parameters
<code>Rn</code> and <code>Ln</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2015, by Marco Bonvini:<br/>
Added parameter for start value of the current.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Added model and user guide
</li>
</ul>
</html>"));
end TwoPortRL_N;
