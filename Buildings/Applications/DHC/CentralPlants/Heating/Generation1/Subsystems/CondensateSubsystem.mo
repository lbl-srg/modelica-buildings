within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Subsystems;
model CondensateSubsystem
  "Condensate subsystem with a storage tank and parallel pumps"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Integer num=2 "The number of pumps";

  // Nominal Conditions
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  final parameter Modelica.SIunits.MassFlowRate mPum_flow_nominal=m_flow_nominal/num
    "Nominal mass flow rate through 1 pump";

  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)
    "Nominal pressure drop of fully open valve";

  DataCenters.ChillerCooled.Equipment.FlowMachine_y pum_y(m_flow_nominal=
        mPum_flow_nominal,
    dpValve_nominal=dpValve_nominal,
                           num=num)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Sources.Boundary_pT watSou(nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Modelica.Blocks.Interfaces.RealOutput P[num](each final quantity="Power",
      each final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={110,40})));
  Modelica.Blocks.Interfaces.RealInput u[num](
    each final unit="1",
    each max=1,
    each min=0)
    "Continuous input signal for the flow machine"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Fluid.Sensors.MassFlowRate senMasFlo "Mass flow sensor for make up water"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
Modelica.Blocks.Interfaces.RealOutput mMUW_flow(quantity="MassFlowRate", final
      unit="kg/s") "Make up water mass flow rate"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
equation
  connect(pum_y.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(pum_y.P, P) annotation (Line(points={{41,4},{80,4},{80,40},{110,40}},
        color={0,0,127}));
  connect(u, pum_y.u) annotation (Line(points={{-120,60},{10,60},{10,4},{18,4}},
        color={0,0,127}));
  connect(port_a, pum_y.port_a)
    annotation (Line(points={{-100,0},{20,0},{20,0}}, color={0,127,255}));
  connect(watSou.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-70,-30},{-60,-30}}, color={0,127,255}));
  connect(senMasFlo.port_b, pum_y.port_a) annotation (Line(points={{-40,-30},{-30,
          -30},{-30,0},{20,0}}, color={0,127,255}));
  connect(senMasFlo.m_flow, mMUW_flow)
    annotation (Line(points={{-50,-19},{-50,80},{110,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-80,-66},{-8,-80}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,54},{68,42}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,6},{-70,-6}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{70,6},{100,-6}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{12,-48},{68,-60}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-57,6},{57,-6}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={6,-3},
          rotation=90),
        Rectangle(
          extent={{-57,6},{57,-6}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={74,-3},
          rotation=90),
        Rectangle(
          extent={{-30,6},{0,-6}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{20,70},{60,30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{40,70},{40,30},{60,50},{40,70}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{42,56},{54,44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Ellipse(
          extent={{22,-32},{62,-72}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{42,-32},{42,-72},{62,-52},{42,-32}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{44,-46},{56,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Rectangle(
          extent={{-80,70},{-76,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,70},{-8,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,70},{-12,-70}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-80,76},{-8,64}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,70},{-80,-74}}, color={0,0,0}),
        Line(points={{-8,70},{-8,-74}}, color={0,0,0}),
        Ellipse(
          extent={{-76,-64},{-12,-76}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CondensateSubsystem;
