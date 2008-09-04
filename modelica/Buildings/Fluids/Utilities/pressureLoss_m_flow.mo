function pressureLoss_m_flow "Pressure loss as a function of flow rate" 
  extends Modelica.Icons.Function;
  import SI = Modelica.SIunits;
  annotation(smoothOrder=2);
  input SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";
  input SI.MassFlowRate m_small_flow 
    "Mass flow rate where function is approximated";
  input Real k(min=0, unit="1/kg/m") "Flow coefficient, k=dp/m_flow^2";
  output SI.Pressure dp "Pressure drop (dp = port_a.p - port_b.p)";
algorithm 
  dp:=Modelica_Fluid.Utilities.regSquare2(
    x=m_flow,
    x_small=m_small_flow,
    k1=k,
    k2=k);
end pressureLoss_m_flow;
