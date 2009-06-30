within Buildings.Fluids.BaseClasses;
partial model PartialResistance "Partial model for a hydraulic resistance"
    extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(m_flow_small = 1E-4*m_flow_nominal,
     m_flow(nominal=m_flow_nominal), dp(nominal=dp_nominal, displayUnit="Pa"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}), Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}),
          defaultComponentName="res",
Documentation(info="<html>
<p>
Partial model for a flow resistance, possible with variable flow coefficient.
The pressure drop is computed by an instance of
<a href=\"Modelica:Buildings.Fluids.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluids.BaseClasses.FlowModels.BasicFlowModel</a>,
i.e., using a regularized implementation of the equation
<pre>
  m_flow = sign(dp) * k * sqrt(|dp|).
</pre>
</p>
</html>"),
revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
Extracted pressure drop computation and implemented it in the
new model
<a href=\"Modelica:Buildings.Fluids.BaseClasses.FlowModels.BasicFlowModel\">
Buildings.Fluids.BaseClasses.FlowModels.BasicFlowModel</a>.
</li>
<li>
September 18, 2008, by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <tt>C</tt> and <tt>mC_flow</tt>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");

  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)" 
    annotation (Evaluate=true, Dialog(tab="Advanced"), choices(__Dymola_checkBox=true));
  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
    "Pressure"                                annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Evaluate=true, Dialog(tab="Advanced"), choices(__Dymola_checkBox=true));

  Real k(unit="") "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  Medium.MassFlowRate m_flow_turbulent
    "Turbulent flow if |m_flow| >= m_flow_turbulent, not a parameter because k can be a function of time"
     annotation(Evaluate=true);

//  Modelica.SIunits.Pressure dp_turbulent
//    "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";

protected
  parameter Medium.ThermodynamicState sta0=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.DynamicViscosity eta_nominal=Medium.dynamicViscosity(sta0)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";
  parameter Modelica.SIunits.SpecificEnthalpy h0=Medium.h_default
    "Initial value for solver for specific enthalpy";           //specificEnthalpy(sta0)
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";
equation
  // Pressure drop calculation
  if from_dp then
    m_flow=FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized);
  else
    dp=FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized);
  end if;

  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

end PartialResistance;
