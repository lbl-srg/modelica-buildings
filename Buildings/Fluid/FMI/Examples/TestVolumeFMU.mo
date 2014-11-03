within Buildings.Fluid.FMI.Examples;
model TestVolumeFMU
  parameter Modelica.SIunits.Volume V=1 "Volume";
  constant Modelica.SIunits.SpecificHeatCapacity cp = 4200
    "Specific heat capacity";

  input Modelica.SIunits.MassFlowRate m_flow_inflow
    "Mass flow rate entering the volume";
  Modelica.SIunits.MassFlowRate m_flow_outflow
    "Mass flow rate leaving the volume";
  input Modelica.SIunits.Temperature T_inlet_inflow
    "Temperature of the medium that stream into the inlet port";
  input Modelica.SIunits.Temperature T_outlet_inflow
    "Temperature of the medium that stream into the outlet port";
  input Modelica.SIunits.Pressure p_inlet "Inlet pressure";
  output Modelica.SIunits.Pressure p_outlet "Outlet pressure";

  Modelica.SIunits.Temperature T(start=293.15) "Temperature of the volume";
  Modelica.SIunits.Pressure p "Volume pressure";
  parameter Real k = 1 "Flow resistance";

  function density "Density"
    input Modelica.SIunits.Temperature T "Temperature";
    output Modelica.SIunits.Density d "Density";

  algorithm
  d := smooth(1,
    if T < 278.15 then
      -0.042860825*T + 1011.9695761
    elseif T < 373.15 then
      0.000015009*(T - 273.15)^3
        - 0.00583576*(T-273.15)^2 + 0.0143711*T
        + 996.194534035
    else
     -0.7025109*T + 1220.35045233);
  end density;
equation
  // Energy balance
  der(V*density(T)*T) =
    if m_flow_inflow >= 0 then
      m_flow_inflow * T_inlet_inflow - m_flow_outflow*T
   else
    m_flow_outflow*T_outlet_inflow - m_flow_inflow*T;
  // Mass balance
  der(V*density(T)) = m_flow_inflow - m_flow_outflow;
  // Pressure balance
  p_inlet-p_outlet = k*m_flow_inflow;
  p = p_outlet;

end TestVolumeFMU;
