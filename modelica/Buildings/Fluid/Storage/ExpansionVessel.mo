within Buildings.Fluid.Storage;
model ExpansionVessel "Pressure expansion vessel with fixed gas cushion"
 extends Buildings.Fluid.Interfaces.PartialLumpedVolume(
   fluidVolume = VLiq,
   energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    substanceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);
   annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(
          extent={{-96,-96},{96,96}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,-94},{40,96}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          visible=use_HeatTransfer,
          extent={{-90,2},{-80,-2}},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-148,98},{152,138}},
          textString="%name",
          lineColor={0,0,255})}), Diagram(graphics),
    Documentation(info="<html>
<p>
This is a model of a pressure expansion vessel. The vessel has a fixed total volume. A fraction of the volume is occupied by a fixed mass of gas, and the other fraction is occupied by the liquid that flows through the port.
The pressure <code>p</code> in the vessel is<pre>
 VGas0 * p_start = (VTot-VLiquid) * p
</pre>
where <code>VGas0</code> is the initial volume occupied by the gas, 
<code>p_start</code> is the initial pressure,
<code>VTot</code> is the total volume of the vessel and
<code>VLiquid</code> is the amount of liquid in the vessel.
</p>
<p>
Optionally, a heat port can be activated by setting <code>use_HeatTransfer=true</code>.
This heat port connects directly to the liquid. The gas does not participate in the energy 
balance.
</p>
</html>", revisions="<html>
<ul>
<li>
Nov. 4, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

 parameter Modelica.SIunits.Volume VTot
    "Total volume of vessel (water and gas side)";
 parameter Modelica.SIunits.Volume VGas0 = VTot/2 "Initial volume of gas";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium = 
        Medium) "Fluid port" 
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // Heat transfer through boundary
  parameter Boolean use_HeatTransfer = false
    "= true to use the HeatTransfer model" 
      annotation (Dialog(tab="Assumptions", group="Heat transfer"));
  parameter Modelica.SIunits.Pressure pMax = 5E5
    "Maximum pressure before simulation stops with an error";
  replaceable model HeatTransfer = 
      Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer (
        surfaceAreas={4*Modelica.Constants.pi*(3/4*VTot/Modelica.Constants.pi)^(2/3)}) 
    constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Wall heat transfer" 
      annotation (Dialog(tab="Assumptions", group="Heat transfer",enable=use_HeatTransfer),choicesAllMatching=true);
  HeatTransfer heatTransfer(
    redeclare final package Medium = Medium,
    final n=1,
    final states = {medium.state},
    final use_k = use_HeatTransfer) 
      annotation (Placement(transformation(
        extent={{-10,-10},{30,30}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer 
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

protected
 Modelica.SIunits.Volume VLiq "Volume of liquid in the vessel";
equation
  assert(medium.p < pMax, "Pressure exceeds maximum pressure.\n" +
       "You may need to increase VTot of the ExpansionVessel.");
  // Water content and pressure
  port_a.p * (VTot-fluidVolume) = p_start * VGas0;
  port_a.p = medium.p;

  // Balance equations
  mb_flow = port_a.m_flow;
  mbXi_flow = port_a.m_flow * actualStream(port_a.Xi_outflow)
    "Component mass flow";
  mbC_flow  = port_a.m_flow * actualStream(port_a.C_outflow)
    "Trace substance mass flow";
  Hb_flow   = port_a.m_flow * actualStream(port_a.h_outflow) "Enthalpy flow";
  Qb_flow   = heatTransfer.Q_flows[1];

  // Outflowing quantities
  port_a.h_outflow  = medium.h;
  port_a.Xi_outflow = medium.Xi;
  port_a.C_outflow  = C;
end ExpansionVessel;
