within Buildings.Fluid.Storage;
model ExpansionVessel "Pressure expansion vessel with fixed gas cushion"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=energyDynamics,
    final mSenFac=1);

  parameter Modelica.Units.SI.Volume V_start(start=1)
    "Volume of liquid stored in the vessel at the start of the simulation";
  parameter Modelica.Units.SI.Volume VTot(min=V_start) = 2*V_start
    "Total volume of vessel (liquid and gas side)";
  parameter Modelica.Units.SI.Pressure pMax = p_start + 3E5
    "Maximum pressure before simulation stops with an error";

  Modelica.Blocks.Interfaces.RealOutput VLiq(
    final quantity="Volume",
    final unit="m3",
    start=V_start,
    min=0)
    "Volume of liquid in the vessel";

  Modelica.Blocks.Interfaces.RealOutput m(
    final quantity="Mass",
    final unit="kg",
    min=0)
    "Mass of liquid in the vessel";

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    start=T_start)
    "Temperature of liquid in the vessel";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
    p(start=p_start),
    h_outflow(start=h_start, nominal=Medium.h_default),
    Xi_outflow(start=X_start[1:Medium.nXi], each nominal=0.01),
    C_outflow(start=C_start, nominal=C_nominal))
    "Fluid port"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  final parameter Medium.SpecificEnthalpy h_start = Medium.specificEnthalpy(
    Medium.setState_pTX(
      T=T_start,
      p=p_start,
      X=X_start[1:Medium.nXi]))
    "Specific enthalpy at start values";

  Buildings.Fluid.Storage.BaseClasses.ExpansionVesselVolume vol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final V_start=V_start,
    final VTot=VTot,
    final pMax=pMax)
    "Model for mass and energy balance of fluid in expansion vessel"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

equation
  connect(port_a, vol.port_a)
    annotation (Line(points={{0,-100},{0,-20}}, color={0,127,255}));
  connect(VLiq, vol.VLiqOut);
  connect(m, vol.mOut);
  connect(T, vol.TOut);

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-148,98},{152,138}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,70},{70,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-68,18},{-68,18},{-54,32},{-28,16},{0,30},{26,16},{46,32},{70,18},
            {70,18},{70,-70},{70,-70},{-68,-70},{-68,-70},{-68,18}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-80},{-2,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    defaultComponentName="exp",
    Documentation(
      info="<html>
<p>
This is a model of a pressure expansion vessel with a fixed gas cushion.
The vessel has a constant total volume <code>VTot</code>.
A fraction of this volume is occupied by a fixed mass of gas, and the remaining
fraction <code>VLiq</code> is occupied by the liquid that enters or leaves through
<code>port_a</code>.
</p>
<p>
Assuming constant gas temperature, the ideal gas law determines the port pressure
</p>
<pre>
  port_a.p = p_start * (VTot - V_start) / (VTot - VLiq)
</pre>
<p>
where <code>VTot</code> is the total volume of the vessel,
<code>VLiq</code> is the volume of liquid in the vessel,
<code>V_start</code> is the initial volume of liquid at <code>p_start</code>, and
<code>VTot - V_start</code> is the initial volume occupied by the gas at <code>p_start</code>.
</p>
<p>
The model accounts for the dynamic mass, enthalpy, species, and trace substance balances
of the liquid in the vessel using
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ExpansionVesselVolume\">
Buildings.Fluid.Storage.BaseClasses.ExpansionVesselVolume</a>.
It assumes no heat exchange between the liquid, the gas, and the ambient.
</p>
<p>
The expansion vessel can be used in closed liquid loops to establish a reference
pressure and, for liquids whose density depends on temperature, to accommodate
thermal expansion. Because the vessel pressure depends on the stored liquid volume,
multiple instances of this model can be connected to the same fluid loop.
</p>
<p>
Alternatively, the model
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a> may be used to impose a fixed reference pressure.
Unlike <a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>, where any outflow leaves at a prescribed
temperature and mass can enter or leave without changing pressure, this model
conserves mass and energy in the stored liquid volume.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 23, 2026, by Michael Wetter:<br/>
Refactored model to use
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ExpansionVesselVolume\">
Buildings.Fluid.Storage.BaseClasses.ExpansionVesselVolume</a>
and compute the vessel pressure from the isothermal ideal gas law of the gas
cushion so that multiple expansion vessels can be used in the same fluid loop.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2220\">IBPSA, #2220</a>.
</li>
<li>
November 15, 2026, by Michael Wetter:<br/>
<ul>
<li>
Initialized total fluid enthalpy <code>H</code> using <code>Medium.specificEnthalpy</code> instead of <code>Medium.specificInternalEnergy</code>.
</li>
<li>
Added the trace-substance conservation equation for <code>C</code> so models with <code>Medium.nC &gt; 0</code> are well-posed.
</li>
</ul>
</li>
<li>
May 11, 2022, by Michael Wetter:<br/>
Removed nonused parameter <code>p</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1614\">IBPSA, #1614</a>.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
March 25, 2014 by Michael Wetter:<br/>
Revised the model to use a constant pressure rather than a constant volume of
water and gas. This leads to a simpler model.
</li>
<li>
August 1, 2013 by Michael Wetter:<br/>
Updated model to use new connector <code>mWat_flow</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised due to changes in conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 16, 2011 by Michael Wetter:<br/>
Set <code>m(stateSelect=StateSelect.always)</code>, since
setting the <code>stateSelect</code> attribute leads to smaller systems of equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"modelica://Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
Revised model due to a change in the fluid volume model.
</li>
<li>
Nov. 4, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExpansionVessel;
