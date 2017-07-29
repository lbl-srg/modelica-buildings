within Buildings.ChillerWSE;
model MassflowControlledPumpParallel
  "Identical m_flow controlled pumps"
  extends Buildings.ChillerWSE.BaseClasses.PartialPumpParallel(
    redeclare Buildings.Fluid.Movers.FlowControlled_m_flow pum(each final
        m_flow_nominal=m_flow_nominal, final m_flow_start=yPump_start),
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default),
    threshold=1e-03*m_flow_nominal);

equation
  connect(u, pum.m_flow_in)
    annotation (Line(points={{-120,40},{0,40},{0,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model implements a parallel of identical pumps with <code>m_flow</code> being controlled. 
The shutoff valves are used to avoid circulating flow among pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end MassflowControlledPumpParallel;
