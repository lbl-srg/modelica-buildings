within Districts.Electrical.Transmission.Base;
partial model PartialTwoPortInductance
  extends Interfaces.PartialTwoPort;
  parameter Modelica.SIunits.Inductance L(start=1) "Inductance";
equation

  terminal_p.i = - terminal_n.i;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-144,97},{156,57}},
            lineColor={0,0,0},
          textString="%name"),
          Text(
            extent={{-142,-30},{144,-62}},
            lineColor={0,0,0},
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
          rotation=180)}));
end PartialTwoPortInductance;
