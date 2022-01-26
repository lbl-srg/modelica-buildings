within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
model TwoPortInductance "Model of an inductance with two electrical ports"
  extends Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.TwoPort;
  parameter Modelica.Units.SI.Inductance L "Inductance";
  OnePhase.Lines.TwoPortInductance  phase1(
    final L=L/3) "Inductance line 1"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OnePhase.Lines.TwoPortInductance phase2(
    final L=L/3) "Inductance line 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  OnePhase.Lines.TwoPortInductance phase3(
    final L=L/3) "Inductance line 3"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
equation
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

  annotation (
  defaultComponentName="line",
 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
        Rectangle(
          extent={{-72,32},{68,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,14},{42,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Text(
            extent={{-140,-28},{140,-60}},
            textColor={0,0,0},
          textString="L=%L"),
          Line(points={{-92,0},{-72,0}}, color={0,0,0}),
          Line(points={{68,0},{88,0}}, color={0,0,0}),
          Text(
            extent={{-142,80},{138,40}},
            textColor={0,0,0},
          textString="%name"),
          Line(
          points={{0,0},{12,1.46953e-15}},
          color={0,0,0},
          origin={-42,0},
          rotation=180),
        Ellipse(
          extent={{-42,14},{-14,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,14},{14,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,0},{48,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
          color={0,0,0},
          origin={52,0},
          rotation=180)}),
    Documentation(info="<html>
<p>
Inductive model that connects two AC three-phase
unbalanced interfaces. This model can be used to represent a
cable in a three-phase unbalanced AC system.
</p>

<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Lines/twoPortL.png\"/>
</p>

<p>
The model represents the lumped inductances as shown in the figure above.
Assuming that the inductance <i>L</i> is the overall inductance of the cable,
each line has an inductance equal to <i>L/3</i>.
</p>

</html>", revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Added model and documentation.
</li>
</ul>
</html>"));
end TwoPortInductance;
