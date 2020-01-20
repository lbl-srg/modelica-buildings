within Buildings.Examples.DistrictReservoirNetworks.Networks;
model SwitchBoxEnergyTransferStation
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
        origin={60,-60})));
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
  Agents.Controls.ReverseFlowSwitchBox con "Controller for pumps"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealInput mFHPDHW "in kg/s"
    annotation (Placement(transformation(extent={{-144,48},{-120,72}}),
        iconTransformation(extent={{-144,48},{-120,72}})));
  Modelica.Blocks.Interfaces.RealInput mFFC "in kg/s"
    annotation (Placement(transformation(extent={{-144,28},{-120,52}}),
        iconTransformation(extent={{-144,28},{-120,52}})));
  Modelica.Blocks.Interfaces.RealInput mFHPSH "in kg/s"
    annotation (Placement(transformation(extent={{-144,68},{-120,92}}),
        iconTransformation(extent={{-144,68},{-120,92}})));
  TJunction splSup3(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  TJunction splSup4(
    redeclare package Medium = MediumInSwitch,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,0})));
  Examples.BaseClasses.Pump_m_flow             pum1(
    redeclare package Medium = MediumInSwitch,
    final m_flow_nominal=m_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,0})));
  Examples.BaseClasses.Pump_m_flow             pum2(
    redeclare package Medium = MediumInSwitch,
    final m_flow_nominal=m_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-40})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W") "Pump electricity consumption"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
equation
  connect(port_b1, splSup1.port_2)
    annotation (Line(points={{-60,100},{-60,70}}, color={0,127,255}));
  connect(mFFC, con.massFlowFC) annotation (Line(points={{-132,40},{-110,40},{
          -110,-48},{-102,-48}}, color={0,0,127}));
  connect(mFHPDHW, con.massFlowHPDHW) annotation (Line(points={{-132,60},{-108,
          60},{-108,-40},{-102,-40}}, color={0,0,127}));
  connect(mFHPSH, con.massFlowHPSH) annotation (Line(points={{-132,80},{-106,80},
          {-106,-32},{-102,-32}}, color={0,0,127}));
  connect(splSup1.port_1, splSup3.port_2)
    annotation (Line(points={{-60,50},{-60,10}}, color={0,127,255}));
  connect(splSup2.port_2, port_b2)
    annotation (Line(points={{60,-70},{60,-100}}, color={0,127,255}));
  connect(splSup3.port_1, port_a1)
    annotation (Line(points={{-60,-10},{-60,-101}}, color={0,127,255}));
  connect(splSup4.port_2, splSup2.port_1)
    annotation (Line(points={{60,-10},{60,-50}}, color={0,127,255}));
  connect(splSup4.port_1, port_a2)
    annotation (Line(points={{60,10},{60,99}}, color={0,127,255}));
  connect(splSup3.port_3, pum1.port_a)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(pum1.port_b, splSup4.port_3)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(splSup1.port_3, pum2.port_a)
    annotation (Line(points={{-50,60},{20,60},{20,-30}}, color={0,127,255}));
  connect(pum2.port_b, splSup2.port_3)
    annotation (Line(points={{20,-50},{20,-60},{50,-60}}, color={0,127,255}));
  connect(con.massFlow, pum1.m_flow_in)
    annotation (Line(points={{-79,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(con.massFlow, pum2.m_flow_in)
    annotation (Line(points={{-79,-40},{8,-40}}, color={0,0,127}));
  connect(add.y, PPum)
    annotation (Line(points={{109,0},{130,0}}, color={0,0,127}));
  connect(pum1.P, add.u1) annotation (Line(points={{11,-9},{40,-9},{40,20},{80,
          20},{80,6},{86,6}}, color={0,0,127}));
  connect(pum2.P, add.u2) annotation (Line(points={{11,-51},{10,-51},{10,-54},{
          40,-54},{40,-20},{80,-20},{80,-6},{86,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -120,-100},{120,100}})),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            120,100}})));
end SwitchBoxEnergyTransferStation;
