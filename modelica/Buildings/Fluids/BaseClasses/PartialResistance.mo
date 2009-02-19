within Buildings.Fluids.BaseClasses;
partial model PartialResistance "Partial model for a hydraulic resistance"
    extends Modelica_Fluid.Interfaces.PartialTwoPortTransport(m_flow_small = 1E-4*m0_flow);

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
</p>
</html>"), revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
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
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Medium.MassFlowRate m0_flow(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
  parameter Medium.AbsolutePressure dp_start = 0.01*system.p_start
    "Guess value of dp = port_a.p - port_b.p" 
    annotation(Dialog(tab = "Advanced"));
  Modelica.SIunits.Pressure dp(start=dp_start)
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
  Real k(start=1) "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  Real kInv(unit="1/(kg.m)", start=1)
    "Flow coefficient for inverse flow computation, kInv=dp/m_flow^2";

  Modelica.SIunits.AbsolutePressure dp_laminar
    "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
  Medium.MassFlowRate m_flow_laminar
    "Turbulent flow if |m_flow| >= m_flow_laminar, not a parameter because k can be a function of time";

  parameter Medium.ThermodynamicState sta0=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.DynamicViscosity eta0=Medium.dynamicViscosity(sta0)
    "Dynamic viscosity, used to compute laminar/turbulent transition";
  parameter Modelica.SIunits.SpecificEnthalpy h0=Medium.h_default
    "Initial value for solver for specific enthalpy";           //specificEnthalpy(sta0)

equation
  1=k*k*kInv;
  dp_laminar = kInv * m_flow_laminar^2;
  if linearized then
     m_flow = k * dp;
  else
    if from_dp then
       m_flow = Buildings.Fluids.Utilities.massFlowRate_dp(dp=dp, dp_small=dp_laminar, k=k);
    else
       dp = Buildings.Fluids.Utilities.pressureLoss_m_flow(m_flow=m_flow,m_small_flow=m_flow_laminar,k=kInv);
    end if;
  end if;

  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

end PartialResistance;
