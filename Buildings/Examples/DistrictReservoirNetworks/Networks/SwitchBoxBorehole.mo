within Buildings.Examples.DistrictReservoirNetworks.Networks;
model SwitchBoxBorehole
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  TJunction splSup1(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-60,60})));
  TJunction splSup2(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,20})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        MediumInSwitch)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        MediumInSwitch)
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        MediumInSwitch)
    annotation (Placement(transformation(extent={{-70,-112},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        MediumInSwitch)
    annotation (Placement(transformation(extent={{50,88},{70,110}})));
  replaceable package MediumInSwitch =
      Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealInput massFlow "in kg/s"
    annotation (Placement(transformation(extent={{-146,-20},{-106,20}})));
  Examples.BaseClasses.Pump_m_flow             pumpSwitch(
    redeclare package Medium = MediumInSwitch,
    final m_flow_nominal=m_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-20,20})));
  Examples.BaseClasses.Pump_m_flow             pumpSwitch1(
    redeclare package Medium = MediumInSwitch,
    final m_flow_nominal=m_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-40})));
  TJunction splSup3(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,20})));
  TJunction splSup4(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W") "Pump electricity consumption"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

equation
  connect(port_b1, splSup1.port_2)
    annotation (Line(points={{-60,100},{-60,70}}, color={0,127,255}));
  connect(port_a2, splSup2.port_1)
    annotation (Line(points={{60,99},{60,30}}, color={0,127,255}));
  connect(splSup1.port_1, splSup3.port_2)
    annotation (Line(points={{-60,50},{-60,30}}, color={0,127,255}));
  connect(splSup3.port_3, pumpSwitch.port_a)
    annotation (Line(points={{-50,20},{-30,20}}, color={0,127,255}));
  connect(pumpSwitch.port_b, splSup2.port_3)
    annotation (Line(points={{-10,20},{50,20}}, color={0,127,255}));
  connect(splSup4.port_1, splSup2.port_2)
    annotation (Line(points={{60,-50},{60,10}}, color={0,127,255}));
  connect(splSup4.port_2, port_b2)
    annotation (Line(points={{60,-70},{60,-100}}, color={0,127,255}));
  connect(splSup3.port_1, port_a1)
    annotation (Line(points={{-60,10},{-60,-101}}, color={0,127,255}));
  connect(splSup1.port_3, pumpSwitch1.port_a) annotation (Line(points={{-50,
          60},{20,60},{20,-30}}, color={0,127,255}));
  connect(pumpSwitch1.port_b, splSup4.port_3) annotation (Line(points={{20,
          -50},{20,-60},{50,-60}}, color={0,127,255}));
  connect(massFlow, pumpSwitch.m_flow_in)
    annotation (Line(points={{-126,0},{-20,0},{-20,8}}, color={0,0,127}));
  connect(massFlow, pumpSwitch1.m_flow_in) annotation (Line(points={{-126,0},
          {-20,0},{-20,-40},{8,-40}}, color={0,0,127}));
  connect(pumpSwitch.P, add.u1) annotation (Line(points={{-9,11},{37.5,11},{37.5,
          6},{86,6}}, color={0,0,127}));
  connect(add.u2, pumpSwitch1.P) annotation (Line(points={{86,-6},{40,-6},{40,-58},
          {11,-58},{11,-51}}, color={0,0,127}));
  connect(add.y, PPum)
    annotation (Line(points={{109,0},{130,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -120,-100},{120,100}})),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            120,100}})));
end SwitchBoxBorehole;
