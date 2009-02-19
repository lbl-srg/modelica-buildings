within Buildings.Fluids.Utilities;
function massFlowRate_dp "Mass flow rate as a function of pressure drop"
  extends Modelica.Icons.Function;
  import SI = Modelica.SIunits;
  annotation(smoothOrder=2);
  input SI.Pressure dp "Pressure drop (dp = port_a.p - port_b.p)";
  input SI.AbsolutePressure dp_small "Turbulent flow if |dp| >= dp_small";
  input Real k(min=0)
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  output SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";
protected
   Real kk;
algorithm
  kk:=k*k;
  m_flow:=Modelica_Fluid.Utilities.regRoot2(x=dp, x_small=dp_small, k1=kk, k2=kk);
end massFlowRate_dp;
