within Buildings.HeatTransfer.Sources;
model FixedHeatFlow "Fixed heat flow boundary condition"
  parameter Modelica.SIunits.HeatFlowRate Q_flow "Fixed heat flow rate at port";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
            -10},{110,10}})));
equation
  port.Q_flow = -Q_flow;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Text(
          extent={{-150,100},{150,60}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-150,-55},{150,-85}},
          lineColor={0,0,0},
          textString="Q_flow=%Q_flow"),
        Line(
          points={{-100,-20},{48,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-100,20},{46,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{90,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-100,40},{0,-36}},
          lineColor={0,0,0},
          textString="Q_flow=const."),
        Line(
          points={{-48,-20},{60,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-48,20},{60,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{60,0},{60,40},{90,20},{60,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,-40},{60,0},{90,-20},{60,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The constant amount of heat
flow rate Q_flow is given as a parameter. The heat flows into the
component to which the component FixedHeatFlow is connected,
if parameter Q_flow is positive.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</html>",
       revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br/>
First implementation based on <a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a>.
</li>
</ul>
</html>"));
end FixedHeatFlow;
