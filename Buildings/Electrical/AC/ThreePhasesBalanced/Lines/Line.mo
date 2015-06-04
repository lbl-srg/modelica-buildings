within Buildings.Electrical.AC.ThreePhasesBalanced.Lines;
model Line "Model of an electrical line"
  extends Buildings.Electrical.AC.OnePhase.Lines.Line(
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p,
    V_nominal(start=480),
    redeclare TwoPortRLC line(
     R=R,
     L=L,
     C=C,
      V_nominal=V_nominal));

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
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a cable for three-phase balanced AC systems. The model is based on
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC\">
Buildings.Electrical.AC.ThreePhasesBalanced.Lines.TwoPortRLC</a>
and provides functionalities to parametrize the values of <i>R</i>, <i>L</i> and <i>C</i> either
using commercial cables or using default values.
</p>
<p>
See model
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Lines.Line\">
Buildings.Electrical.AC.OnePhase.Lines.Line</a> for more
information.
</p>
</html>"));
end Line;
