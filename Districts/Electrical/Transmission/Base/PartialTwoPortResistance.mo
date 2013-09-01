within Districts.Electrical.Transmission.Base;
partial model PartialTwoPortResistance
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter Modelica.SIunits.Temperature T_ref=300.15 "Reference temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
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
          textString="R=%R"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialTwoPortResistance;
