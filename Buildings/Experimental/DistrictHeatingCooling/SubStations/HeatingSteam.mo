within Buildings.Experimental.DistrictHeatingCooling.SubStations;
model HeatingSteam "Steam heating substation"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_b = MediumWat,
    redeclare final package Medium_a = MediumSte,
    final show_T = true);

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=623.15) "Water medium";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    min=0) "Nominal heat flow rate added to medium (Q_flow_nominal > 0)";

  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal(
    min=0) "Nominal change in enthalpy";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
    "Nominal mass flow rate";

  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow(min=0, final unit="W")
                    "Heat flow rate extracted from system (Q_flow >= 0)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Fluid.HeatExchangers.SteamHeatExchangerIdeal hex
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Division m_flow "Mass flow rate"
    annotation (Placement(transformation(extent={{-20,44},{0,64}})));
protected
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = MediumWat,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false) "Pump"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Gain inv(final k=-1) "Inverse"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(Q_flow, inv.u)
    annotation (Line(points={{-120,60},{-62,60}}, color={0,0,127}));
  connect(pum.P, PPum) annotation (Line(points={{41,9},{70.5,9},{70.5,60},{110,60}},
        color={0,0,127}));
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(hex.port_b, pum.port_a)
    annotation (Line(points={{-40,0},{20,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(hex.dh, m_flow.u2) annotation (Line(points={{-39,6},{-30,6},{-30,48},
          {-22,48}}, color={0,0,127}));
  connect(inv.y, m_flow.u1)
    annotation (Line(points={{-39,60},{-22,60}}, color={0,0,127}));
  connect(m_flow.y, pum.m_flow_in)
    annotation (Line(points={{1,54},{30,54},{30,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          visible=not allowFlowReversal),
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,80},{-78,38},{80,38},{0,80}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95}),
      Rectangle(
          extent={{-64,38},{64,-70}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,0,0}),
      Rectangle(
        extent={{-42,-4},{-14,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-4},{44,24}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{16,-54},{44,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-42,-54},{-14,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatingSteam;
