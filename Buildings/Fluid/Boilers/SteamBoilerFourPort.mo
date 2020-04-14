within Buildings.Fluid.Boilers;
model SteamBoilerFourPort
  "Model for a steam boiler with four ports for air and water flows, including medium changes"
  extends Buildings.Fluid.Interfaces.PartialFourPortFourMedium;
  extends Buildings.Fluid.Boilers.BaseClasses.PartialSteamBoiler(
    final Medium_a = Medium_a1,
    final Medium_b = Medium_b1,
    vol(
      m_flow_small=m1_flow_small,
      V=m1_flow_nominal*tau/rho_nominal),
    eva(final m_flow_nominal=m1_flow_nominal, m_flow_small=m1_flow_small),
    dpCon(
      redeclare package Medium = Medium_a1,
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
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_a2 (inlet)";
  replaceable package Medium_b2 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    "Medium model for port_b2 (outlet)";

  parameter Real ratAirFue = 10
    "Air-to-fuel ratio (by volume)";

  BaseClasses.Combustion com(
    redeclare package Medium_a = Medium_a2,
    redeclare package Medium_b = Medium_b2,
    m_flow_nominal=m2_flow_nominal,
    m_flow_small=m2_flow_small,
    ratAirFue=ratAirFue) "Combustion process"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
  connect(port_a2, port_a2) annotation (Line(points={{100,-60},{100,-60},{100,-60}},
        color={0,127,255}));
  connect(port_b2, com.port_a)
    annotation (Line(points={{-100,-60},{-10,-60}}, color={0,127,255}));
  connect(com.port_b, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,120}}),                                  graphics={
        Rectangle(
          extent={{-74,4},{74,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{74,4}},
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
          extent={{74,56},{100,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,64},{-74,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,64},{-66,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,4},{74,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-56},{100,-64}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-56},{100,-64}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            120}})));
end SteamBoilerFourPort;
