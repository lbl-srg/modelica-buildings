within Buildings.Applications.DHC.EnergyTransferStations.Heating.Generation1;
model Heating1stGenIdeal "Ideal heating energy transfer station"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare replaceable package Medium_a =
      IBPSA.Media.Interfaces.PartialPureSubstanceWithSat,
    show_T=true);

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    min=0) "Nominal heat flow rate added to medium (Q_flow_nominal > 0)";

//  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal(
//    min=0) "Nominal change in enthalpy";

//  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dh_nominal
//    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";

  Modelica.Blocks.Interfaces.RealOutput PPum(unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow(min=0, final unit="W")
                    "Heat flow rate extracted from system (Q_flow >= 0)"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Fluid.HeatExchangers.SteamHeatExchangerIdeal hex(
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    pSte_nominal=pSte_nominal)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Division mAct_flow "Actual mass flow rate"
    annotation (Placement(transformation(extent={{0,44},{20,64}})));
//protected
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium_b,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final m_flow_nominal=m_flow_nominal,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false) "Pump"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Gain inv(final k=-1) "Inverse"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(pum.P, PPum) annotation (Line(points={{41,9},{70.5,9},{70.5,60},{110,60}},
        color={0,0,127}));
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(hex.port_b, pum.port_a)
    annotation (Line(points={{-60,0},{20,0}}, color={0,127,255}));
  connect(pum.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(mAct_flow.y, pum.m_flow_in)
    annotation (Line(points={{21,54},{30,54},{30,12}},color={0,0,127}));
  connect(Q_flow, mAct_flow.u1)
    annotation (Line(points={{-120,60},{-2,60}}, color={0,0,127}));
  connect(inv.y, mAct_flow.u2) annotation (Line(points={{-19,30},{-10,30},{-10,
          48},{-2,48}}, color={0,0,127}));
  connect(hex.dh, inv.u) annotation (Line(points={{-59,6},{-50,6},{-50,30},{-42,
          30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-98,4},{102,-4}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={175,175,175},
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,8},{80,-8}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Heating1stGenIdeal;
