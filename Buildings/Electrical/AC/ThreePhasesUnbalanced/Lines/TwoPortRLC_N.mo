within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortRLC_N
  "Model of an RLC element with two electrical ports and neutral line cable"
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort;
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort_N(
    terminal_p(phase(v(each nominal = V_nominal))),
    terminal_n(phase(v(each nominal = V_nominal))));

  parameter Modelica.Units.SI.Resistance R "Resistance at temperature T_ref";
  parameter Modelica.Units.SI.Resistance Rn
    "Resistance of neutral cable at temperature T_ref";
  parameter Modelica.Units.SI.Capacitance C "Capacity";
  parameter Modelica.Units.SI.Capacitance Cn "Capacityof neutral cable";
  parameter Modelica.Units.SI.Inductance L "Inductance";
  parameter Modelica.Units.SI.Inductance Ln "Inductance of neutral cable";
  parameter Modelica.Units.SI.Temperature T_ref=298.15 "Reference temperature"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature M=507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Voltage Vc1_start[2]=V_nominal/sqrt(3)*{1,0}
    "Initial voltage phasor of the capacitance located in the middle of phase 1"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Modelica.Units.SI.Voltage Vc2_start[2]=V_nominal/sqrt(3)*{-1/2,-
      sqrt(3)/2}
    "Initial voltage phasor of the capacitance located in the middle of phase 1"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Modelica.Units.SI.Voltage Vc3_start[2]=V_nominal/sqrt(3)*{-1/2,+
      sqrt(3)/2}
    "Initial voltage phasor of the capacitance located in the middle of phase 1"
    annotation (Dialog(enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic)));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.FixedZ_dynamic)=
    Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Type of model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modeling assumption"));
  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=480)
    "Nominal voltage (V_nominal >= 0)"
    annotation (Evaluate=true, Dialog(group="Nominal conditions"));
  OnePhase.Lines.TwoPortRLC phase1(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final C=C/3,
    final mode=mode,
    final V_nominal = V_nominal/sqrt(3),
    final useHeatPort=useHeatPort,
    Vc_start=Vc1_start) "Impedance line 1"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortRLC phase2(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final C=C/3,
    final mode=mode,
    final V_nominal = V_nominal/sqrt(3),
    final useHeatPort=useHeatPort,
    Vc_start=Vc2_start) "Impedance line 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortRLC phase3(
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final C=C/3,
    final mode=mode,
    final V_nominal = V_nominal/sqrt(3),
    final useHeatPort=useHeatPort,
    Vc_start=Vc3_start) "Impedance line 3"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  OnePhase.Lines.TwoPortRLC neutral(
    final T_ref=T_ref,
    final M=M,
    final mode=mode,
    final V_nominal=V_nominal/sqrt(3),
    final useHeatPort=useHeatPort,
    final R=Rn,
    final C=Cn,
    final L=Ln,
    Vc_start=-Vc1_start - Vc2_start - Vc3_start) "Neutral line RLC model"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
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
      points={{0,-40},{-32,-40},{-32,-72},{0,-72},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(phase2.heatPort, heatPort) annotation (Line(
      points={{4.44089e-16,-10},{4.44089e-16,-16},{-32,-16},{-32,-72},{
          4.44089e-16,-72},{4.44089e-16,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(neutral.terminal_p, terminal_p.phase[4]) annotation (Line(
      points={{10,-54},{20,-54},{20,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(neutral.terminal_n, terminal_n.phase[4]) annotation (Line(
      points={{-10,-54},{-20,-54},{-20,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(neutral.heatPort, heatPort) annotation (Line(
      points={{0,-64},{0,-100}},
      color={191,0,0},
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
          points={{-6.85214e-44,-8.39117e-60},{96,1.22003e-14}},
          color={0,0,0},
          origin={62,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-4.17982e-15,16}},
          color={0,0,0},
          origin={20,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={28,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={28,-4},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-2.40346e-15,16}},
          color={0,0,0},
          origin={20,-4},
          rotation=180),
        Line(
          points={{-68,16},{-62,16},{-60,20},{-56,12},{-52,20},{-48,12},{-44,20},
              {-40,12},{-38,16},{-34,16}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-26,22},{-14,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,22},{-2,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-2,22},{10,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,16},{10,4}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
            extent={{-144,-56},{142,-88}},
            textColor={0,0,0},
          textString="C=%C"),
          Text(
            extent={{-142,80},{138,40}},
            textColor={0,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
RLC line model (T-model) that connects two AC three-phase
unbalanced interfaces with neutral line. This model can be used to represent a
cable in a three-phase unbalanced AC system.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortRLC_N.png\"/>
</p>

<p>
The model represents the lumped impedances as shown in the figure above.
Assuming that the overall cable has a resistance <i>R</i>, an inductance
<i>L</i>, and a capacitance <i>C</i>, each line has an inductance equal
to <i>L/3</i>, a resistance equal to <i>R/3</i> and a capacity equal to
<i>C/3</i>.
</p>
<p>
The resistance, capacitance and inductance of the neutral cable are defined separately using the parameters
<code>Rn</code> <code>Cn</code>, and <code>Ln</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2023, by Michael Wetter:<br/>
Set nominal attribute for voltage at terminal.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected wrong annotation to avoid an error in the pedantic model check
in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
March 9, 2015, by Marco Bonvini:<br/>
Added parameter for start value of the voltage.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Added model and user guide
</li>
</ul>
</html>"));
end TwoPortRLC_N;
