within Buildings.AirCleaning.BaseClasses;
partial model PartialInDuctGUVCalc "Partial model duct GUV calculation"
    extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
     show_T=false,
     dp(nominal=if dp_nominal_pos > Modelica.Constants.eps
          then dp_nominal_pos else 1),
     m_flow(
        nominal=if m_flow_nominal_pos > Modelica.Constants.eps
          then m_flow_nominal_pos else 1),
     final m_flow_small = 1E-4*abs(m_flow_nominal));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent
    "Turbulent flow if |m_flow| >= m_flow_turbulent";

  parameter Real kGUV[Medium.nC](min=0)
    "Inactivation constant";

  Modelica.Units.SI.MassFlowRate m_flow_GUV(min = 0)
    "comment";

  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Interfaces.BooleanInput u "on/off"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.Units.SI.DynamicViscosity eta_default=
      Medium.dynamicViscosity(sta_default)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_pos=abs(
      m_flow_nominal) "Absolute value of nominal flow rate";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal_pos(
      displayUnit="Pa") = abs(dp_nominal)
    "Absolute value of nominal pressure difference";
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = if allowFlowReversal then inStream(port_b.h_outflow) else Medium.h_default;
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  if m_flow<m_flow_small then
    m_flow_GUV = m_flow_small;
  else
    m_flow_GUV = m_flow;
  end if;
  for i in 1:Medium.nC loop
    port_b.C_outflow[i] = booleanToReal.y*(1 - exp(-kGUV[i]*m_flow_nominal/m_flow_GUV))*inStream(port_a.C_outflow[i]);
  end for;
  //port_b.C_outflow[2] = (1-eff)*inStream(vol.ports[2].C_outflow[2]);
  //port_b.C_outflow[1] = inStream(vol.ports[2].C_outflow[1]);

  connect(u,booleanToReal. u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{100,10},{100+200*max(-1, min(0, m_flow/(abs(m_flow_nominal)))),-10}}),
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent=DynamicSelect({{-100,10},{-100,10}}, {{-100,10},{-100+200*min(1, max(0, m_flow/abs(m_flow_nominal))),-10}}),
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
Documentation(info="<html>
<p>
Partial model for a duct GUV trace species inactivation calculation.
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024 by Cary Faulkner:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialInDuctGUVCalc;
