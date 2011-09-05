within Buildings.Fluid.Storage;
model ExpansionVessel "Pressure expansion vessel with fixed gas cushion"
 extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
 parameter Modelica.SIunits.Volume VTot
    "Total volume of vessel (water and gas side)";
 parameter Modelica.SIunits.Volume VGas0 = VTot/2 "Initial volume of gas";

//////////////////////////////////////////////////////////////
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Fluid port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  parameter Modelica.SIunits.Pressure pMax = 5E5
    "Maximum pressure before simulation stops with an error";

 Modelica.SIunits.Volume VLiq "Volume of liquid in the vessel";
protected
  Buildings.Fluid.Interfaces.LumpedVolume vol(
    redeclare final package Medium = Medium,
    final nPorts = 1,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final fluidVolume = VLiq,
    final Q_flow = 0,
    final mXi_flow = zeros(Medium.nXi))
    "Model for mass and energy balance of water in expansion vessel";

equation
  assert(port_a.p < pMax, "Pressure exceeds maximum pressure.\n" +
       "You may need to increase VTot of the ExpansionVessel.");

  // Water content and pressure
  port_a.p * (VTot-VLiq) = p_start * VGas0;

  connect(port_a, vol.ports[1]);
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
        Text(
          extent={{-148,98},{152,138}},
          textString="%name",
          lineColor={0,0,255})}), Diagram(graphics),
defaultComponentName="exp",
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
<p>
The expansion vessel needs to be used in closed loops that contain
water to set a reference pressure and, for liquids where the
density is modeled as a function of temperature, to allow for
the thermal expansion of the liquid.
</p>
</html>", revisions="<html>
<ul>
<li>
July 26, 2011 by Michael Wetter:<br>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
May 25, 2011 by Michael Wetter:<br>
Revised model due to a change in the fluid volume model.
</li>
<li>
Nov. 4, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExpansionVessel;
