within Buildings.Examples.DistrictReservoirNetworks.Networks;
model SwitchBoxBorehole "Mass flow rate redirection for borefield"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W") "Pump electricity consumption"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,-112},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{50,88},{70,110}})));

  Modelica.Blocks.Interfaces.RealInput massFlow(final unit="kg/s")
   "Mass flow rate"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}})));
protected
  Examples.BaseClasses.Pump_m_flow pum1(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-20,20})));
  Examples.BaseClasses.Pump_m_flow pum2(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-40})));
  TJunction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,60})));
  TJunction splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,20})));
  TJunction splSup3(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,20})));
  TJunction splSup4(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));

protected
  Modelica.Blocks.Math.Add add
    "Adder for pump power consumption"
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));

equation
  connect(port_b1, splSup1.port_2)
    annotation (Line(points={{-60,100},{-60,70}}, color={0,127,255}));
  connect(port_a2, splSup2.port_1)
    annotation (Line(points={{60,99},{60,30}}, color={0,127,255}));
  connect(splSup1.port_1, splSup3.port_2)
    annotation (Line(points={{-60,50},{-60,30}}, color={0,127,255}));
  connect(splSup3.port_3, pum1.port_a)
    annotation (Line(points={{-50,20},{-30,20}}, color={0,127,255}));
  connect(pum1.port_b, splSup2.port_3)
    annotation (Line(points={{-10,20},{50,20}}, color={0,127,255}));
  connect(splSup4.port_1, splSup2.port_2)
    annotation (Line(points={{60,-50},{60,10}}, color={0,127,255}));
  connect(splSup4.port_2, port_b2)
    annotation (Line(points={{60,-70},{60,-100}}, color={0,127,255}));
  connect(splSup3.port_1, port_a1)
    annotation (Line(points={{-60,10},{-60,-101}}, color={0,127,255}));
  connect(splSup1.port_3, pum2.port_a)
    annotation (Line(points={{-50,60},{20,60},{20,-30}}, color={0,127,255}));
  connect(pum2.port_b, splSup4.port_3)
    annotation (Line(points={{20,-50},{20,-60},{50,-60}}, color={0,127,255}));
  connect(massFlow, pum1.m_flow_in)
    annotation (Line(points={{-140,0},{-20,0},{-20,8}}, color={0,0,127}));
  connect(massFlow, pum2.m_flow_in) annotation (Line(points={{-140,0},{-20,0},{-20,
          -40},{8,-40}}, color={0,0,127}));
  connect(pum1.P, add.u1) annotation (Line(points={{-9,11},{37.5,11},{37.5,6},{86,
          6}}, color={0,0,127}));
  connect(add.u2, pum2.P) annotation (Line(points={{86,-6},{40,-6},{40,-58},{11,
          -58},{11,-51}}, color={0,0,127}));
  connect(add.y, PPum)
    annotation (Line(points={{109,0},{130,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -120,-100},{120,100}})),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            120,100}})),
    Documentation(info="<html>
<p>
Model that is used to ensure that the borefield obtain the supply from
the upstream connection of the district loop in the model
<a href=\"Buildings.Examples.DistrictReservoirNetworks.Examples.Bidirectional\">
Buildings.Examples.DistrictReservoirNetworks.Examples.Bidirectional</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBoxBorehole;
