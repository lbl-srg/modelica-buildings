within Buildings.Fluid.Boilers.BaseClasses;
model Combustion "Model for combustion with ideal mixing"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;

  replaceable package Medium_a =
      Modelica.Media.Interfaces.PartialMixtureMedium
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      Modelica.Media.Interfaces.PartialMixtureMedium
    "Medium model for port_b (outlet)";

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  parameter Real ratAirFue = 10
    "Air-to-fuel ratio (by volume)";

  Modelica.SIunits.SpecificEnthalpy h_a_instream
    "Instreaming enthalpy at port_a";

  Modelica.SIunits.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

//  Modelica.SIunits.MassFlowRate mAir_flow "Mass flow rate of fresh air";
  Modelica.SIunits.VolumeFlowRate VAir_flow "Volumetric flow rate of fresh air";
  Modelica.SIunits.Temperature TAir "Fresh air temperature";
  Modelica.SIunits.Density dAir "Density of fresh air";

  Modelica.Blocks.Interfaces.RealInput QFue_flow "Heat transfer rate of fuel"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));


equation
  port_b.p = port_a.p;
  h_a_instream = inStream(port_a.h_outflow);

  // Air properties
  TAir= Medium_a.temperature(
    state=Medium_a.setState_phX(
      p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow)));
  dAir = Medium_a.density(state=
      Medium_a.setState_pTX(p=port_a.p,T=TAir,X=inStream(port_b.Xi_outflow)));

  // Mass fractions of mixtures assumed constant
//  inStream(port_a.Xi_outflow[:]) = Medium_a.X_default[:];
//  port_b.Xi_outflow[:] = Medium_b.X_default[:];

  // Air to fuel ratio
  VAir_flow = ratAirFue * VFue_flow;
  port_a.m_flow = VAir_flow * dAir;
//  mAir_flow = port_a.m_flow;

  // Steady state conservation of mass
  port_a.m_flow + port_b.m_flow + mFue_flow = 0;

  // Steady state energy balance
  QFue_flow + port_a.m_flow*inStream(port_a.h_outflow) +
    port_b.m_flow*port_b.h_outflow = 0;

  // Reverse flow
//  port_a.h_outflow = Medium_a.h_default;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,4},{100,-4}},
          lineColor={244,125,35},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-60},{80,60}},
          lineColor={244,125,35},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-147,-114},{153,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-30,-30},{30,30}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Sphere)}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Combustion;
