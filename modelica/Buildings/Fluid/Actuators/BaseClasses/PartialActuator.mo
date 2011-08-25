within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialActuator "Partial model of an actuator"
    extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
     show_T=false, show_V_flow=false,
     m_flow(start=0, nominal=m_flow_nominal_pos),
     dp(start=0, nominal=dp_nominal_pos));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
     annotation(Dialog(group = "Nominal condition"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=270,
        origin={0,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));
  Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Turbulent flow if |m_flow| >= m_flow_turbulent, not a parameter because k can be a function of time"
     annotation(Evaluate=true);

protected
  parameter Medium.ThermodynamicState sta0=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.DynamicViscosity eta_nominal=Medium.dynamicViscosity(sta0)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";
  parameter Modelica.SIunits.SpecificEnthalpy h0=Medium.h_default
    "Initial value for solver for specific enthalpy";           //specificEnthalpy(sta0)
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";

protected
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_pos = abs(m_flow_nominal)
    "Absolute value of nominal flow rate";
  final parameter Modelica.SIunits.Pressure dp_nominal_pos = abs(dp_nominal)
    "Absolute value of nominal pressure";

equation
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);

   annotation (Documentation(info="<html>
Partial actuator that is the base class for dampers and two way valves.
Models that extend this class need to implement an equation for 
<code>m_flow</code> and for <code>dp</code>.
</html>", revisions="<html>
<ul>
<li>
August 1, by Michael Wetter:<br>
Set start values for <code>dp</code> and <code>m_flow</code>
to zero.
</li>
<li>
April 4, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{38,112},{62,74}},
          lineColor={0,0,127},
          textString="y")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics));
end PartialActuator;
