within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper_dp
  "Mass flow rate for damper with exponential opening characteristics"
  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition laminar to turbulent occurs";
  input Boolean linearized
    "= true, use linear relation between m_flow and dp for any flow rate";

  input Real y(min=0, max=1, unit="")
    "Control signal, y=0 is closed, y=1 is open";
  input Real a(unit="") "Coefficient a for damper characteristics";
  input Real b(unit="") "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";
  input Modelica.SIunits.Density rho "Density of medium";
  input Modelica.SIunits.Area A "Cross sectional area of damper";
  input Real kFixed(unit="")
    "Flow coefficient of fixed resistance that may be in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

  output Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
protected
  Real k(unit="") "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";

algorithm
 k:=sqrt(2*rho)*A/Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
    y=y,
    a=a,
    b=b,
    cL=cL,
    cU=cU,
    yL=yL,
    yU=yU);
 k := if (kFixed>Modelica.Constants.eps) then sqrt(1/(1/kFixed^2 + 1/k^2)) else k;
 m_flow :=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
    dp=dp,
    k=k,
    m_flow_turbulent=m_flow_turbulent,
    linearized=linearized);

annotation (
Documentation(info="<html>
<p>
This function computes the mass flow rate as a function of the pressure drop and
the damper opening signal.
The model assumes that the air damper has the opening characteristics that is
implemented in
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
</p>
<p>
The air damper can also have an additional flow resistance that does not depend on
the opening signal. This additional flow resistance has a pressure drop
of <i>dp = (m_flow &frasl; k)^2</i>, where <i>k</i> is an input.
To model no additional flow resistance, set <i>k=0</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
smoothOrder=1,
inverse(dp=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_m_flow(
            m_flow, m_flow_turbulent, linearized,
            y, a, b, cL, cU, yL, yU, rho, A, kFixed)));
end exponentialDamper_dp;
