within Buildings.Electrical.Transmission.Base;
partial model PartialTwoPortResistance
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref" annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature T_ref = 298.15 "Reference temperature"
                                                                                annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature M = 507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))" annotation(Evaluate=true);
  Modelica.SIunits.Resistance R_actual
    "Actual resistance = R*(M + T_heatPort)/(M + T_ref) ";
equation
  assert(R_actual>=0, "The value of R_actual must be positive, check reference and actual temperatures");

  R_actual = R*(M + Modelica.SIunits.Conversions.to_degC(T_heatPort))/(M + Modelica.SIunits.Conversions.to_degC(T_ref));

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
