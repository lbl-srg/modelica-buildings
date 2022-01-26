within Buildings.HeatTransfer.Windows.BaseClasses;
model ThermalConductor
  "Lumped thermal element with variable area, transporting heat without storing it"
  extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
  parameter Modelica.Units.SI.ThermalConductance G
    "Constant thermal conductance of material";
  Modelica.Blocks.Interfaces.RealInput u(min=0)
    "Input signal for thermal conductance"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
equation
  Q_flow = u*G*dT;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{-60,50},{60,-52}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-60,50},{-60,-52}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,50},{60,-52}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-113,136},{115,96}},
          textColor={0,0,0},
          textString="G=%G"),
        Text(
          extent={{-105,90},{-64,64}},
          textColor={0,0,0},
          textString="u"),   Text(
          extent={{-50,-84},{48,-132}},
          textColor={0,0,255},
          textString=
               "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),      graphics={
        Line(
          points={{-80,0},{80,0}},
          color={255,0,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-26,-10},{27,-39}},
          textColor={255,0,0},
          textString="Q_flow"),
        Text(
          extent={{-80,50},{80,20}},
          textColor={0,0,0},
          textString="dT = port_a.T - port_b.T")}),
    Documentation(info="<html>
<p>
This is a model for transport of heat without storing it.
It is identical to the thermal conductor from the Modelica Standard Library,
except that it adds an input signal <code>u</code>.
</html>", revisions="<html>
<ul>
<li>
August 18 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalConductor;
