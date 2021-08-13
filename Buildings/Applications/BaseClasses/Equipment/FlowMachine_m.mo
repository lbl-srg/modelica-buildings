within Buildings.Applications.BaseClasses.Equipment;
model FlowMachine_m "Identical m_flow controlled pumps"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPumpParallel(
    redeclare final Buildings.Fluid.Movers.FlowControlled_m_flow pum(
      each final m_flow_nominal = m_flow_nominal,
      final m_flow_start=yPump_start*m_flow_nominal),
    rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  Modelica.Blocks.Math.Gain gaiM_flow[num](each final k=m_flow_nominal)
    "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{-48,30},{-28,50}})));
equation
  connect(gaiM_flow.y, pum.m_flow_in)
    annotation (Line(points={{-27,40},{0,40},{0,12}}, color={0,0,127}));
  connect(gaiM_flow.u, u)
    annotation (Line(points={{-50,40},{-120,40},{-120,40}}, color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>This model implements a parallel of identical pumps with <code>m_flow</code> being controlled.
The number can be specified by setting a value of <code>num</code>.
The shutoff valves are used to avoid circulating flow among pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowMachine_m;
