within Buildings.Fluid.Movers.BaseClasses;
partial model PrescribedFlowMachine
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
      final show_V_flow = false,
      final m_flow_nominal = max(pressure.V_flow)*rho_nominal,
      preSou(final control_m_flow=false));

  extends Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface(
    V_flow_max(start=V_flow_nominal),
    final rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default));

  // Models
protected
  Modelica.Blocks.Sources.RealExpression dpMac(y=-dpMachine)
    "Pressure drop of the pump or fan"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + WFlo) if  addPowerToMedium
    "Heat and work input into medium"
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
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-48,-60},{-72,-100},{72,-100},{48,-60},{-48,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-100,46},{100,-46}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{2,70},{2,-66},{72,4},{2,70}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,72},{0,-68},{74,4},{0,72}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{16,18},{46,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=dynamicBalance,
          fillColor={0,100,199})}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
<p>This is the base model for fans and pumps that take as 
input a control signal in the form of the pump speed <code>Nrpm</code>
or the normalized pump speed <code>y=Nrpm/N_nominal</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 25, 2011, by Michael Wetter:<br>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PrescribedFlowMachine;
