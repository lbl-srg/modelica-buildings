within Buildings.Electrical.Transmission.BaseClasses;
partial model PartialTwoPortResistance
  "Partial model of a resistive element that links two electrical connectors"
  extends Interfaces.PartialTwoPort;
  extends Modelica.Electrical.Analog.Interfaces.ConditionalHeatPort(T = T_ref);
  parameter Modelica.Units.SI.Resistance R "Resistance at temperature T_ref";
  parameter Modelica.Units.SI.Temperature T_ref=298.15 "Reference temperature";
  parameter Modelica.Units.SI.Temperature M=507.65
    "Temperature constant (R_actual = R*(M + T_heatPort)/(M + T_ref))";
  Modelica.Units.SI.Resistance R_actual
    "Actual resistance = R*(M + T_heatPort)/(M + T_ref) ";
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  assert(R_actual>=0,
   "The value of R_actual must be positive, check reference and actual temperatures.");

  R_actual =R*(M + Modelica.Units.Conversions.to_degC(T_heatPort))/(M +
    Modelica.Units.Conversions.to_degC(T_ref));

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
          textString="R=%R"),
          Line(points={{-90,0},{-70,0}}, color={0,0,0}),
          Line(points={{70,0},{90,0}}, color={0,0,0}),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
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
<i>M</i> is the temperature coefficient of the cable material,
and <i>T<sub>ref</sub></i> is the reference temperature.
The temperature <i>T</i> is the temperature of the heat port
if <code>useHeatPort = true</code>.
</p>
</html>"));
end PartialTwoPortResistance;
