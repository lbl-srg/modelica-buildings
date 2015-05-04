within Buildings.Obsolete.Fluid.Movers.BaseClasses;
partial model PrescribedFlowMachine
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.FlowMachineInterface(
    V_flow_max(start=V_flow_nominal),
    final rho_default = Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default));

  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.PartialFlowMachine(
      final m_flow_nominal = max(pressure.V_flow)*rho_default,
      preSou(final control_m_flow=false));

  // Models
protected
  Modelica.Blocks.Sources.RealExpression dpMac(y=-dpMachine)
    "Pressure drop of the pump or fan"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + WFlo) if
       addPowerToMedium "Heat and work input into medium"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
 VMachine_flow = -port_b.m_flow/rho;
 rho = rho_in;

  connect(preSou.dp_in, dpMac.y) annotation (Line(
      points={{36,8},{36,30},{21,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PToMedium_flow.y, prePow.Q_flow) annotation (Line(
      points={{-79,20},{-70,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>This is the base model for fans and pumps that take as
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed <code>y=Nrpm/N_nominal</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedFlowMachine;
