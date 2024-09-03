within Buildings.Electrical.DC.Lines;
model TwoPortResistance "Model of a two port DC resistance"
  extends
    Buildings.Electrical.Transmission.BaseClasses.PartialTwoPortResistance(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
equation
  // Voltage drop on the resistance lumped on connection between terminals
  // p.v[1] and n.v[1]
  terminal_p.v[1] - terminal_n.v[1] = terminal_p.i[1]*R_actual;
  terminal_p.v[2] = terminal_n.v[2];

  // Joule losses
  LossPower = R_actual*terminal_p.i[1]^2;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            textColor={0,0,0},
          textString="%name"),
          Text(
            extent={{-142,-30},{144,-62}},
            textColor={0,0,0},
          textString="R=%R"),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model represents a resistance that connect two DC interfaces. This model can be used
to represent a cable in a DC grid.
</p>
<p>
The model represents the lumped resistance as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/DC/Lines/twoPortR.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2015, by Michael Wetter:<br/>
Removed redeclaration of phase system in <code>Terminal_n</code> and
<code>Terminal_p</code> as it is already declared to the be the same
phase system, and it is not declared to be replaceable.
This avoids a translation error in OpenModelica.
</li>
<li>
January 14, 2015, by Marco Bonvini:<br/>
Added equation that represents Joule losses
</li>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoPortResistance;
