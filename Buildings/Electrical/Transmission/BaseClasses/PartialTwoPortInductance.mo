within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialTwoPortInductance
  "Partial model of an inductive element that links two electrical connectors"
  extends Interfaces.PartialTwoPort;
  parameter Modelica.Units.SI.Inductance L "Inductance"
    annotation (Evaluate=true);
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  terminal_p.i = - terminal_n.i;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-142,-30},{144,-62}},
            textColor={0,0,0},
          textString="L=%L"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
        Ellipse(
          extent={{14,14},{42,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,0},{44,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(
          points={{0,0},{12,1.46953e-15}},
          color={0,0,0},
          origin={-42,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
          color={0,0,0},
          origin={52,0},
          rotation=180)}),
    Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
Partial model of an inductance that links two generalized electrical connectors.
</p>
</html>"));
end PartialTwoPortInductance;
