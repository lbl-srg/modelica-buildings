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
  // We set m(start=(VTot-VGas0)*1000, stateSelect=StateSelect.always)
  // since the mass accumulated in the volume should be a state.
  // This often leads to smaller systems of equations.
protected
  Buildings.Fluid.Interfaces.ConservationEquation vol(
    redeclare final package Medium = Medium,
    m(start=(VTot-VGas0)*1000, stateSelect=StateSelect.always),
    final nPorts=1,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final fluidVolume = VLiq)
    "Model for mass and energy balance of water in expansion vessel"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.Constant heaInp(final k=0)
    "Block to set heat input into volume"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Modelica.Blocks.Sources.Constant       masExc[Medium.nXi](final k=zeros(Medium.nXi)) if
        Medium.nXi > 0 "Block to set mass exchange in volume"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  assert(port_a.p < pMax, "Pressure exceeds maximum pressure.\n" +
       "You may need to increase VTot of the ExpansionVessel.");

  // Water content and pressure
  port_a.p * (VTot-VLiq) = p_start * VGas0;

  connect(heaInp.y, vol.Q_flow) annotation (Line(
      points={{-59,70},{-20,70},{-20,-4},{-12,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masExc.y, vol.mXi_flow) annotation (Line(
      points={{-59,40},{-30,40},{-30,-8},{-12,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, vol.ports[1]) annotation (Line(
      points={{5.55112e-16,-100},{5.55112e-16,-60},{6.66134e-16,-60},{
          6.66134e-16,-20}},
      color={0,127,255},
      smooth=Smooth.None));
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
This is a model of a pressure expansion vessel. The vessel has a fixed total volume. 
A fraction of the volume is occupied by a fixed mass of gas, and the other fraction is occupied 
by the liquid that flows through the port.
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
<p>
Note that alternatively, the model
<a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a> may be used to set 
a reference pressure. The main difference between these two models
is that in this model, there is an energy and mass balance for the volume.
In contrast, for
<a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a>, 
any mass flow rate that flows out of the model will be at a user-specified temperature.
Therefore, <a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a> leads to smaller systems
of equations, which may result in faster simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br>
Revised due to changes in conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 16, 2011 by Michael Wetter:<br>
Set <code>m(stateSelect=StateSelect.always)</code>, since
setting the <code>stateSelect</code> attribute leads to smaller systems of equations.
</li>
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
