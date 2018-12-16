within Buildings.Fluid.Actuators.BaseClasses;
block LinearizeVAVBoxExponential
  "Linearizing block for exponential damper with optional fixed flow resistance"
  extends Modelica.Blocks.Interfaces.SISO;

  input Real rho;

  parameter Real kFixed;
  parameter Real dp_nominal_pos;
  parameter Real dp_cor_nominal;
  parameter Real m_flow_nominal_pos;
  parameter Real A;
  parameter Real a;
  parameter Real b;
  parameter Real[3] cL;
  parameter Real[3] cU;
  parameter Real yL;
  parameter Real yU;

equation
  y = noEvent(if (u < Modelica.Constants.eps or u > 1-Modelica.Constants.eps) then u else
  if (kFixed < Modelica.Constants.eps) then Buildings.Fluid.Actuators.BaseClasses.exponentialDamperInv(
  kThetaSqRt=sqrt(2*rho)*A*sqrt(dp_nominal_pos)/(sqrt(u)*m_flow_nominal_pos),
  a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU) else Buildings.Fluid.Actuators.BaseClasses.exponentialDamperInv(
  kThetaSqRt=sqrt(2*rho)*A/(sqrt(1/((dp_nominal_pos+dp_cor_nominal)/(u*m_flow_nominal_pos^2)
    -1/kFixed^2))),
  a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU));

end LinearizeVAVBoxExponential;
