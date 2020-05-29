within Buildings.Fluid.Boilers;
model SteamBoilerFourPort
  "Model for a steam boiler with four ports for air and water flows, including medium changes"
  extends Buildings.Fluid.Interfaces.PartialFourPortFourMediumParallel(
    redeclare final package Medium_a2 = Medium2,
    redeclare final package Medium_b2 = Medium2);
  extends Buildings.Fluid.Boilers.BaseClasses.PartialSteamBoiler(
    redeclare final package Medium_a = Medium_a1,
    redeclare final package Medium_b = Medium_b1,
    final m_flow_nominal = m1_flow_nominal,
    vol(
      m_flow_small=m1_flow_small,
      V=m1_flow_nominal*tau/rho_default),
    eva(final m_flow_nominal=m1_flow_nominal, m_flow_small=m1_flow_small,
      pSte_nominal=pOut_nominal),
    dpCon(
      m_flow_nominal=m1_flow_nominal,
      m_flow_small=m1_flow_small,
      addPowerToMedium=false,
      nominalValuesDefineDefaultPressureCurve=true));

  replaceable package Medium_a1 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model (liquid state) for port_a1 (inlet)";
  replaceable package Medium_b1 =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat
    "Medium model (vapor state) for port_b1 (outlet)";
  replaceable package Medium2 =
      Modelica.Media.Interfaces.PartialMedium
    "Medium model for fluid stream 2 (from a2 to b2)";

  parameter Real ratAirFue = 10
    "Air-to-fuel ratio (by volume)";

  BaseClasses.Combustion com(
    m_flow_nominal=m2_flow_nominal,
    redeclare final package Medium = Medium2,
    final show_T = show_T) "Combustion process"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  FixedResistances.PressureDrop preDroAir(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=1400,
    final show_T = show_T) "Air side total pressure drop"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(port_a2, port_a2) annotation (Line(points={{-100,-80},{-100,-80},{-100,-80}},
        color={0,127,255}));
  connect(port_a1, senMasFlo.port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(temSen_out.port_b, port_b1) annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(com.port_b, port_b2) annotation (Line(points={{60,-80},{100,-80}}, color={0,127,255}));
  connect(y, com.y) annotation (Line(points={{-120,80},{-90,80},{-90,-56},{10,
          -56},{10,-72},{39,-72}}, color={0,0,127}));
  connect(port_a2, preDroAir.port_a)
    annotation (Line(points={{-100,-80},{-40,-80}}, color={0,127,255}));
  connect(preDroAir.port_b, com.port_a)
    annotation (Line(points={{-20,-80},{40,-80}}, color={0,127,255}));
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
