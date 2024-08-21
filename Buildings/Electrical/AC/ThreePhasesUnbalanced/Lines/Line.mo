within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model Line "Model of an electrical line without neutral cable"
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort(
    terminal_p(phase(v(each nominal = V_nominal))),
    terminal_n(phase(v(each nominal = V_nominal))));
  extends Buildings.Electrical.Transmission.BaseClasses.PartialBaseLine(
  V_nominal(start = 480),
  commercialCable = Buildings.Electrical.Transmission.Functions.selectCable_low(P_nominal, V_nominal));
  OnePhase.Lines.TwoPortRL phase1(
    final useHeatPort=true,
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=modelMode) "Impedance line 1"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortRL phase2(
    final useHeatPort=true,
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=modelMode) "Impedance line 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortRL phase3(
    final useHeatPort=true,
    final T_ref=T_ref,
    final M=M,
    final R=R/3,
    final L=L/3,
    final mode=modelMode) "Impedance line 3"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation

  connect(cableTemp.port, phase1.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,10},{6.66134e-16,10},{6.66134e-16,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cableTemp.port, phase2.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,-20},{0,-20},{0,-10},{4.44089e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cableTemp.port, phase3.heatPort) annotation (Line(
      points={{-40,22},{-26,22},{-26,-50},{0,-50},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
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
      points={{10,30},{20,30},{20,4.44089e-16},{100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase2.terminal_p, terminal_p.phase[2]) annotation (Line(
      points={{10,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(phase3.terminal_p, terminal_p.phase[3]) annotation (Line(
      points={{10,-30},{20,-30},{20,4.44089e-16},{100,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="line",
 Icon(graphics={
        Ellipse(
          extent={{-70,10},{-50,-10}},
          lineColor={0,0,0},
          fillColor={11,193,87},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,10},{60,-10}},
          fillColor={11,193,87},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{50,10},{70,-10}},
          lineColor={0,0,0},
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-70,0},{-90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,10},{60,10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-60,-10},{60,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{96,0},{60,0}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<ul>
<li>
April 5, 2023, by Michael Wetter:<br/>
Set nominal attribute for voltage at terminal.
</li>
<li>
October 6, 2014, by Marco Bonvini:<br/>
Revised documentation and model.
</li>
</ul>
</html>", info="<html>
<p>
This model represents an AC three-phase unbalanced cable without
neutral connection. The model is based on
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC</a>
and provides functionalities to parametrize the values of <i>R</i>, <i>L</i> and <i>C</i>
using either commercial cables or default values.
</p>
</html>"));
end Line;
