within Buildings.Electrical.Transmission.Base;
partial model PartialTwoPortRLC
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.SIunits.Resistance R(start=1)
    "Resistance at temperature T_ref";
  parameter Modelica.SIunits.Temperature T_ref = 298.15 "Reference temperature";
  parameter Modelica.SIunits.Temperature M = 507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  parameter Modelica.SIunits.Capacitance C(start=0) "Capacity";
  parameter Modelica.SIunits.Inductance L(start=0) "Inductance";
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=220)=100
    "Nominal voltage (V_nominal >= 0)"  annotation(evaluate=true, Dialog(group="Nominal conditions"));
  Modelica.SIunits.Resistance R_actual
    "Actual resistance = R*(M + T_heatPort)/(M + T_ref) ";
equation
  assert(R_actual>=0, "The value of R_actual must be positive, check reference and actual temperatures");

  R_actual = R*(M + Modelica.SIunits.Conversions.to_degC(T_heatPort))/(M + Modelica.SIunits.Conversions.to_degC(T_ref));
  LossPower = 0;

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-148,-28},{138,-60}},
            lineColor={0,0,0},
          textString="R=%R, L=%L"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,32},{70,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{96,1.22003e-14}},
          color={0,0,0},
          origin={64,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-4.17982e-15,16}},
          color={0,0,0},
          origin={22,16},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={30,0},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={30,-4},
          rotation=180),
          Line(
          points={{-6.85214e-44,-8.39117e-60},{-2.40346e-15,16}},
          color={0,0,0},
          origin={22,-4},
          rotation=180),
        Line(
          points={{-66,16},{-60,16},{-58,20},{-54,12},{-50,20},{-46,12},{-42,20},
              {-38,12},{-36,16},{-32,16}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-24,22},{-12,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-12,22},{0,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,22},{12,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,16},{12,4}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Text(
            extent={{-142,-56},{144,-88}},
            lineColor={0,0,0},
          textString="C=%C")}));
end PartialTwoPortRLC;
