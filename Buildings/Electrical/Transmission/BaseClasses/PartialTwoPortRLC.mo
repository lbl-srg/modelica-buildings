within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialTwoPortRLC
  "Partial model of an RLC element that links two electrical connectors"
  extends Buildings.Electrical.Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.Units.SI.Resistance R "Resistance at temperature T_ref"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature T_ref=298.15 "Reference temperature";
  parameter Modelica.Units.SI.Temperature M=507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  parameter Modelica.Units.SI.Capacitance C "Capacity";
  parameter Modelica.Units.SI.Inductance L "Inductance";
  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=110)
    "Nominal voltage (V_nominal >= 0)"
    annotation (Dialog(group="Nominal conditions"));
  Modelica.Units.SI.Resistance R_actual
    "Actual resistance = R*(M + T_heatPort)/(M + T_ref) ";
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  assert(R_actual>=0,
   "The value of R_actual must be positive, check reference and actual temperatures");

  R_actual =R*(M + Modelica.Units.Conversions.to_degC(T_heatPort))/(M +
    Modelica.Units.Conversions.to_degC(T_ref));

  annotation (Diagram(graphics={
          Rectangle(extent={{-70,30},{70,-30}}, lineColor={0,0,255}),
          Line(points={{-90,0},{-70,0}}, color={0,0,255}),
          Line(points={{70,0},{90,0}},   color={0,0,255})}), Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                  graphics={
          Text(
            extent={{-148,-28},{138,-60}},
            textColor={0,0,0},
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
          visible = C > 0,
          points={{-6.85214e-44,-8.39117e-60},{-4.17982e-15,16}},
          color={0,0,0},
          origin={22,16},
          rotation=180),
          Line(
          visible = C > 0,
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={30,0},
          rotation=180),
          Line(
          visible = C > 0,
          points={{-6.85214e-44,-8.39117e-60},{16,1.95937e-15}},
          color={0,0,0},
          origin={30,-4},
          rotation=180),
          Line(
          visible = C > 0,
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
            textColor={0,0,0},
          textString="C=%C")}),
    Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
Partial model of a resistance that links two generalized electrical connectors.
</p>
<p>
The model computes a resistance <i>R(T)</i> that varies depending on the temperature <i>T</i> as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R(T) = R<sub>ref</sub> (M + T)/(M + T<sub>ref</sub>),
</p>
<p>
where the resistance <i>R<sub>ref</sub></i> is the reference value of the resistance,
<i>M</i> is the temperature coefficient of the cable material, and
<i>T<sub>ref</sub></i> is the reference temperature.
The temperature <i>T</i> is the temperature of the heat port if <code>useHeatPort = true</code>.
</p>
<p>
The impedance <i>L</i> and the capacity <i>C</i> do not vary with respect to the temperature
and are specified by the user.
</p>
</html>"));
end PartialTwoPortRLC;
