within Buildings.Fluids.BaseClasses;
partial model PartialResistance "Partial model for a hydraulic resistance"
    extends Modelica_Fluid.Interfaces.PartialTwoPortTransport(m_flow_small = 1E-4*m_flow_nominal,
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
  parameter Medium.MassFlowRate m_flow_nominal(min=0) "Nominal mass flow rate" 
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
    "Pressure"                                annotation(Dialog(group = "Nominal condition"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate" 
    annotation(Dialog(tab="Advanced"));
protected
  Real kSqu(start=1, unit="kg.m") "Flow coefficient, kSqu=k^2=m_flow^2/|dp|";
  Real k(start=1, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
//  Real kk(start=1, unit="kg.m")=k*k "Flow coefficient";
//  Real kInv(min=0, unit="1/(kg.m)")
//    "Flow coefficient for inverse flow computation, kInv=dp/m_flow^2";

  Modelica.SIunits.Pressure dp_turbulent
    "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
  Medium.MassFlowRate m_flow_turbulent(nominal=m_flow_nominal)
    "Turbulent flow if |m_flow| >= m_flow_turbulent, not a parameter because k can be a function of time";

  parameter Medium.ThermodynamicState sta0=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.DynamicViscosity eta_nominal=Medium.dynamicViscosity(sta0)
    "Dynamic viscosity, used to compute transition to turbulent flow regime";
  parameter Modelica.SIunits.SpecificEnthalpy h0=Medium.h_default
    "Initial value for solver for specific enthalpy";           //specificEnthalpy(sta0)
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";
equation
//  kInv = 1/k/k;
  //1=k*k*kInv;
  kSqu=k*k;
     if from_dp then
       dp_turbulent = m_flow_turbulent^2/kSqu;
     else
       m_flow_turbulent = sqrt(dp_turbulent)*k;
    end if;
  if linearized then
     m_flow = k * dp * conv2;
  else
     if from_dp then
       m_flow = Modelica_Fluid.Utilities.regRoot2(x=dp, x_small=dp_turbulent, k1=kSqu, k2=kSqu);
     else
       dp = Modelica_Fluid.Utilities.regSquare2(x=m_flow, x_small=m_flow_turbulent, k1=1/kSqu, k2=1/kSqu);
    end if;
  end if;

  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

end PartialResistance;
