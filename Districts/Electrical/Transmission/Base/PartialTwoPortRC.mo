within Districts.Electrical.Transmission.Base;
partial model PartialTwoPortRC
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter Modelica.SIunits.Temperature T_ref=300.15 "Reference temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alpha=0
    "Temperature coefficient of resistance (R_actual = R*(1 + alpha*(T_heatPort - T_ref))";
  parameter Modelica.SIunits.Capacitance C(start=1e-5) "Capacity";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)=100
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions"));
  Modelica.SIunits.Resistance R_actual
    "Actual resistance = R*(1 + alpha*(T_heatPort - T_ref))";
  Modelica.SIunits.Voltage V(start = V_nominal) "Voltage of the capacitor";

equation
  assert((1 + alpha*(T_heatPort - T_ref)) >= Modelica.Constants.eps, "Temperature outside scope of model!");

  R_actual = R*(1 + alpha*(T_heatPort - T_ref));
  LossPower = 0;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-142,-30},{144,-62}},
            lineColor={0,0,0},
          textString="R=%R, C=%C"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{126,1.543e-14}},
          color={0,0,0},
          origin={64,0},
          rotation=180),
        Rectangle(
          extent={{-54,6},{-12,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{5.97497e-16,6}},
          color={0,0,0},
          origin={0,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={8,-6},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={8,-10},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-1.91362e-15,12}},
          color={0,0,0},
          origin={0,-10},
          rotation=180),
        Rectangle(
          extent={{12,6},{54,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialTwoPortRC;
