within Buildings.Templates.Components.BaseClasses;
model MoverSpeedControlled_y
  extends Buildings.Fluid.Movers.SpeedControlled_y(
    final _m_flow_nominal=m_flow_nominal);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal;
annotation(Documentation(
  info="<html>
<p>
  This is a compiler-friendly version of
  <a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
    Buildings.Fluid.Movers.SpeedControlled_y</a> which facilitates the
  propagation of the mover performance curves by binding
  <code>_m_flow_nominal</code> to a top-level parameter rather than to an
  expression that depends on the performance data record.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2026, by Antoine Gautier:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/4653\">#4653</a>.
</li>
</ul>
</html>"));
end MoverSpeedControlled_y;
