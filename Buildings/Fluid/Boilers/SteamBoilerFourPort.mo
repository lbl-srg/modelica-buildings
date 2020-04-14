within Buildings.Fluid.Boilers;
model SteamBoilerFourPort
  "Model for a steam boiler with four ports for air and water flows, including medium changes"
  extends Buildings.Fluid.Interfaces.PartialFourPortFourMedium;
  extends Buildings.Fluid.Boilers.BaseClasses.PartialSteamBoiler(
    redeclare final package Medium_a = Medium_a1,
    redeclare final package Medium_b = Medium_b1,
    vol(
      m_flow_small=m1_flow_small,
      V=m1_flow_nominal*tau/rho_default),
    eva(final m_flow_nominal=m1_flow_nominal, m_flow_small=m1_flow_small),
    dpCon(
      m_flow_nominal=m1_flow_nominal,
      m_flow_small=m1_flow_small,
      addPowerToMedium=false,
      nominalValuesDefineDefaultPressureCurve=true));

  replaceable package Medium_a1 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a1 (inlet)";
  replaceable package Medium_b1 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b2 (outlet)";
  replaceable package Medium_a2 =
      Modelica.Media.Interfaces.PartialMixtureMedium
    "Medium model for port_a2 (inlet)";
  replaceable package Medium_b2 =
      Modelica.Media.Interfaces.PartialMixtureMedium
    "Medium model for port_b2 (outlet)";

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
     annotation (choicesAllMatching = true);

  parameter Real ratAirFue = 10
    "Air-to-fuel ratio (by volume)";

  BaseClasses.Combustion com(
    redeclare final package Medium_a = Medium_a2,
    redeclare final package Medium_b = Medium_b2,
    m_flow_nominal=m2_flow_nominal,
    m_flow_small=m2_flow_small,
    fue=fue,
    ratAirFue=ratAirFue) "Combustion process"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Modelica.Blocks.Sources.RealExpression QFue_flow_out(y=QFue_flow) "Heat transfer rate of fuel"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Sensors.Pressure senPreAir(redeclare final package Medium = Medium_a2) "Air side pressure sensor"
    annotation (Placement(transformation(extent={{-80,-96},{-60,-116}})));
  Modelica.Blocks.Math.Add dpSenAir(k2=-1) "Change in pressure needed to meet setpoint on air side"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Movers.FlowControlled_dp dpConAir(
    redeclare final package Medium = Medium_a2,
    m_flow_nominal=m2_flow_nominal,
    m_flow_small=m1_flow_small,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    show_T=true,
    constantHead=pOut_nominal) "Flow controller with specifiied pressure change between ports"
    annotation (Placement(transformation(extent={{-20,-70},{0,-90}})));
  Modelica.Blocks.Sources.RealExpression pOutSet1(y=pOut_nominal)
    "Pressure setpoint for outgoing fluid"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(port_a2, port_a2) annotation (Line(points={{-100,-80},{-100,-80},{-100,-80}},
        color={0,127,255}));
  connect(port_a1, senMasFlo.port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(temSen_out.port_b, port_b1) annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(QFue_flow_out.y, com.QFue_flow) annotation (Line(points={{41,-70},{48,-70}}, color={0,0,127}));
  connect(senPreAir.port, port_a2)
    annotation (Line(points={{-70,-96},{-70,-80},{-100,-80}}, color={0,127,255}));
  connect(port_a2, dpConAir.port_a) annotation (Line(points={{-100,-80},{-20,-80}}, color={0,127,255}));
  connect(pOutSet1.y, dpSenAir.u1)
    annotation (Line(points={{-59,-60},{-56,-60},{-56,-94},{-52,-94}}, color={0,0,127}));
  connect(senPreAir.p, dpSenAir.u2) annotation (Line(points={{-59,-106},{-52,-106}}, color={0,0,127}));
  connect(dpSenAir.y, dpConAir.dp_in)
    annotation (Line(points={{-29,-100},{-10,-100},{-10,-92}}, color={0,0,127}));
  connect(dpConAir.port_b, com.port_a) annotation (Line(points={{0,-80},{50,-80}}, color={0,127,255}));
  connect(com.port_b, port_b2) annotation (Line(points={{70,-80},{100,-80}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}),
                                                                graphics={
        Rectangle(
          extent={{-80,-76},{80,-102}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,4},{74,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,-76},{100,-84}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-76},{100,-84}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})));
end SteamBoilerFourPort;
