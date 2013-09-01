within Districts.Electrical.Transmission.Base;
partial model PartialTwoPortRL
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter Modelica.SIunits.Temperature T_ref=300.15 "Reference temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
  parameter Modelica.SIunits.Inductance L(start=1) "Inductance";
  Modelica.SIunits.Resistance R_actual
    "Actual resistance = R*(1 + alpha*(T_heatPort - T_ref))";
equation
  assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps, "Temperature outside scope of model!");

  R_actual = R*(1 + alpha*(T_heatPort - T_ref));
  LossPower = 0;

  terminal_p.i = - terminal_n.i;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-142,-30},{144,-62}},
            lineColor={0,0,0},
          textString="R=%R, L=%L"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
          color={0,0,0},
          origin={-54,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{6,7.34764e-16}},
          color={0,0,0},
          origin={-6,0},
          rotation=180),
        Ellipse(
          extent={{-6,10},{14,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,10},{34,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,10},{54,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,0},{56,-16}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
          color={0,0,0},
          origin={64,0},
          rotation=180),
        Rectangle(
          extent={{-54,6},{-12,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255}),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{6,7.34764e-16}},
          color={0,0,0},
          origin={-6,0},
          rotation=180)}));
end PartialTwoPortRL;
