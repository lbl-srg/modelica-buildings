within Buildings.Examples.DistrictReservoirNetworks.Networks;
model SwitchBoxEnergyTransferStation "Mass flow rate redirection for energy transfer station"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  TJunction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,60})));
  TJunction splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,-48})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-70,-112},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{50,88},{70,110}})));
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);
  Agents.Controls.ReverseFlowSwitchBox con "Controller for pumps"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Interfaces.RealInput mDomHotWat_flow(
    final unit="kg/s")
    "Mass flow rate for domestic hot water" annotation (Placement(
        transformation(extent={{-144,48},{-120,72}}), iconTransformation(extent=
           {{-144,48},{-120,72}})));
  Modelica.Blocks.Interfaces.RealInput mFreCoo_flow(
    final unit="kg/s")
    "Mass flow rate for free cooling" annotation (Placement(transformation(
          extent={{-144,28},{-120,52}}), iconTransformation(extent={{-144,28},{-120,
            52}})));
  Modelica.Blocks.Interfaces.RealInput mSpaHea_flow(
    final unit="kg/s")
    "Mass flow rate for space heating" annotation (Placement(transformation(
          extent={{-144,68},{-120,92}}), iconTransformation(extent={{-144,68},{-120,
            92}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W") "Pump electricity consumption"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
protected
  TJunction splSup3(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  TJunction splSup4(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,0})));
  Examples.BaseClasses.Pump_m_flow pum1(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,0})));
  Examples.BaseClasses.Pump_m_flow pum2(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,60})));
  Modelica.Blocks.Math.Add add "Adder for pump power"
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));

  TJunction splSup8(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,-80})));
  TJunction splSup7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={40,-80})));
  Fluid.Sensors.MassFlowRate senMasFloByPas(
    redeclare package Medium = Medium,
    allowFlowReversal=true)
    "Mass flow rate through bypass of district" annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={0,-80})));
equation
  connect(port_b1, splSup1.port_2)
    annotation (Line(points={{-60,100},{-60,80},{-40,80},{-40,70}},
                                                  color={0,127,255}));
  connect(mFreCoo_flow, con.mFreCoo_flow) annotation (Line(points={{-132,40},{-110,
          40},{-110,-48},{-102,-48}}, color={0,0,127}));
  connect(mDomHotWat_flow, con.mDomHotWat_flow) annotation (Line(points={{-132,60},
          {-108,60},{-108,-40},{-102,-40}}, color={0,0,127}));
  connect(mSpaHea_flow, con.mSpaHea_flow) annotation (Line(points={{-132,80},{-106,
          80},{-106,-32},{-102,-32}}, color={0,0,127}));
  connect(splSup1.port_1, splSup3.port_2)
    annotation (Line(points={{-40,50},{-40,10}}, color={0,127,255}));
  connect(splSup4.port_2, splSup2.port_1)
    annotation (Line(points={{40,-10},{40,-38}}, color={0,127,255}));
  connect(splSup4.port_1, port_a2)
    annotation (Line(points={{40,10},{40,60},{60,60},{60,99}},
                                               color={0,127,255}));
  connect(splSup3.port_3, pum1.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(pum1.port_b, splSup4.port_3)
    annotation (Line(points={{10,0},{22,0},{22,6.66134e-16},{30,6.66134e-16}},
                                             color={0,127,255}));
  connect(splSup1.port_3, pum2.port_a)
    annotation (Line(points={{-30,60},{-10,60}},         color={0,127,255}));
  connect(pum2.port_b, splSup2.port_3)
    annotation (Line(points={{10,60},{20,60},{20,-48},{30,-48}},
                                                          color={0,127,255}));
  connect(con.m_flow, pum1.m_flow_in)
    annotation (Line(points={{-79,-40},{0,-40},{0,-12}}, color={0,0,127}));
  connect(con.m_flow, pum2.m_flow_in) annotation (Line(points={{-79,-40},{-20,
          -40},{-20,40},{0,40},{0,48},{-8.88178e-16,48}}, color={0,0,127}));
  connect(add.y, PPum)
    annotation (Line(points={{109,0},{130,0}}, color={0,0,127}));
  connect(splSup8.port_3, splSup3.port_1)
    annotation (Line(points={{-40,-70},{-40,-10}}, color={0,127,255}));
  connect(port_a1, splSup8.port_1) annotation (Line(points={{-60,-101},{-60,-80},
          {-50,-80}}, color={0,127,255}));
  connect(splSup8.port_2, senMasFloByPas.port_a)
    annotation (Line(points={{-30,-80},{-6,-80}}, color={0,127,255}));
  connect(splSup7.port_3, splSup2.port_2)
    annotation (Line(points={{40,-70},{40,-58}}, color={0,127,255}));
  connect(splSup7.port_2, port_b2)
    annotation (Line(points={{50,-80},{60,-80},{60,-100}}, color={0,127,255}));
  connect(splSup7.port_1, senMasFloByPas.port_b)
    annotation (Line(points={{30,-80},{6,-80}}, color={0,127,255}));
  connect(pum2.P, add.u1)
    annotation (Line(points={{11,51},{80,51},{80,6},{86,6}}, color={0,0,127}));
  connect(pum1.P, add.u2) annotation (Line(points={{11,-9},{26,-9},{26,-20},{80,
          -20},{80,-6},{86,-6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
            -120,-100},{120,100}})),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            120,100}})),
    Documentation(info="<html>
<p>
Model that is used to ensure that the substations obtain the supply from
the upstream connection of the district loop in the reservoir network models.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBoxEnergyTransferStation;
