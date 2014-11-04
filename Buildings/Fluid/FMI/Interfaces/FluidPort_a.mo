within Buildings.Fluid.FMI.Interfaces;
connector FluidPort_a "Connector for fluid inlet"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  input Medium.MassFlowRate m_flow
    "Mass flow rate from the connection point into the component";
  input Medium.AbsolutePressure p
    "Thermodynamic pressure in the connection point";
  input Medium.SpecificEnthalpy h_inflow
    "Specific thermodynamic enthalpy close to the connection point if m_flow >= 0";
  input Medium.MassFraction Xi_inflow[Medium.nXi]
    "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  input Medium.ExtraProperty C_inflow[Medium.nC]
    "Properties c_i/m close to the connection point if m_flow < 0";

  output Medium.SpecificEnthalpy h_outflow if
       allowFlowReversal
    "Specific thermodynamic enthalpy close to the connection point if m_flow >= 0";
  output Medium.MassFraction Xi_outflow[Medium.nXi] if
       allowFlowReversal
    "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
  output Medium.ExtraProperty C_outflow[Medium.nC] if
       allowFlowReversal
    "Properties c_i/m close to the connection point if m_flow < 0";

  annotation (defaultComponentName="port_a",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Polygon(
          points={{-100,100},{-100,-100},{100,0},{-100,100}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Backward,
          fillColor={0,0,255})}));
end FluidPort_a;
