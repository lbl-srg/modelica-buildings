within Buildings.Fluid.Movers.BaseClasses;
partial model PrescribedFlowMachine
  "Partial model for fan or pump with speed (y or Nrpm) as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
      final show_V_flow = false,
      souDyn(final control_m_flow=false),
      souSta(final control_m_flow=false));

  extends Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface(
    V_flow_nominal=m_flow_nominal/rho_nominal,				  
    V_flow_max(start=V_flow_nominal),
    final rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default));

  // Models
protected
  Modelica.Blocks.Sources.RealExpression dpMac(y=-dpMachine)
    "Pressure drop of the pump or fan"
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));
  Modelica.Blocks.Sources.RealExpression QMac_flow(y=Q_flow + dpMachine*
        V_in_flow)
    "Heat input into the medium from the fan or pump (not including flow work)"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
 VMachine_flow = V_in_flow;
 rho = rho_in;

  connect(dpMac.y, souSta.dp_in) annotation (Line(
      points={{-59,32},{66,32},{66,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpMac.y, souDyn.dp_in) annotation (Line(
      points={{-59,32},{16,32},{16,8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(QMac_flow.y, prePow.Q_flow) annotation (Line(
      points={{-59,50},{-50,50},{-50,24},{-80,24},{-80,10},{-68,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QMac_flow.y, souSta.P_in) annotation (Line(
      points={{-59,50},{60,50},{60,-52}},
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
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
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
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PrescribedFlowMachine;
