within Buildings.Fluid.FixedResistances.BaseClasses;
model PlugFlowPipe
  "Pipe model using spatialDistribution for temperature delay"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow(start=m_flow_start));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean have_pipCap=true
    "= true, a mixing volume is added that corresponds
    to the heat capacity of the pipe wall"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean have_symmetry=true
    "= false, the mixing volume is only on port_b,
    which improve performances, but reduces dynamic accuracy."
    annotation (Dialog(tab="Advanced", enable=have_pipCap));

  parameter Modelica.Units.SI.Length dh=sqrt(4*m_flow_nominal/rho_default/
      v_nominal/Modelica.Constants.pi)
    "Hydraulic diameter (assuming a round cross section area)"
    annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.Velocity v_nominal=1.5
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)"
    annotation (Dialog(group="Nominal condition"));

  parameter Real ReC=4000
    "Reynolds number where transition to turbulence starts";

  parameter Modelica.Units.SI.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.Length length "Pipe length"
    annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.Length dIns
    "Thickness of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));

  parameter Modelica.Units.SI.ThermalConductivity kIns
    "Heat conductivity of pipe insulation, used to compute R"
    annotation (Dialog(group="Thermal resistance"));

  parameter Modelica.Units.SI.SpecificHeatCapacity cPip=2300
    "Specific heat of pipe wall material. 2300 for PE, 500 for steel"
    annotation (Dialog(group="Material", enable=have_pipCap));

  parameter Modelica.Units.SI.Density rhoPip(displayUnit="kg/m3") = 930
    "Density of pipe wall material. 930 for PE, 8000 for steel"
    annotation (Dialog(group="Material", enable=have_pipCap));

  parameter Modelica.Units.SI.Length thickness=0.0035 "Pipe wall thickness"
    annotation (Dialog(group="Material"));

  parameter Modelica.Units.SI.Temperature T_start_in(start=Medium.T_default) =
    Medium.T_default "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_out(start=Medium.T_default)
     = T_start_in "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay = false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=0
    "Initial value of mass flow rate through pipe"
    annotation (Dialog(tab="Initialization", enable=initDelay));

  parameter Real R(unit="(m.K)/W")=1/(kIns*2*Modelica.Constants.pi/
    Modelica.Math.log((dh/2 + thickness + dIns)/(dh/2 + thickness)))
    "Thermal resistance per unit length from fluid to boundary temperature"
    annotation (Dialog(group="Thermal resistance"));

  parameter Real fac=1
    "Factor to take into account flow resistance of bends etc.,
    fac=dp_nominal/dpStraightPipe_nominal";

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat transfer to or from surroundings (positive if pipe is colder than surrounding)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // QEnv_flow is introduced because in discretized pipes, heatPort.Q_flow must be summed over all ports.
  // By introducing this variable, both models have the same variable.
  Modelica.Units.SI.HeatFlowRate QEnv_flow=heatPort.Q_flow
    "Heat transfer to or from surroundings (positive if pipe is colder than surrounding)";

  Modelica.Units.SI.Velocity v=del.v "Flow velocity of medium in pipe";

  replaceable Buildings.Fluid.FixedResistances.HydraulicDiameter res(
    final dh=dh,
    final from_dp=from_dp,
    final length=length,
    final roughness=roughness,
    final fac=fac,
    final ReC=ReC,
    final v_nominal=v_nominal,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearized,
    dp(nominal=fac*200*length)) constrainedby
    Buildings.Fluid.Interfaces.PartialTwoPortInterface(
      redeclare final package Medium = Medium,
      final m_flow_nominal=m_flow_nominal,
      final allowFlowReversal=allowFlowReversal,
      final show_T=false)
    "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,40})));

protected
  parameter Modelica.Units.SI.HeatCapacity CPip=length*((dh + 2*thickness)^2 -
      dh^2)*Modelica.Constants.pi/4*cPip*rhoPip "Heat capacity of pipe wall";

  final parameter Modelica.Units.SI.Volume VEqu=if have_symmetry then CPip/(
      rho_default*cp_default)/2 else CPip/(rho_default*cp_default)
    "Equivalent water volume to represent pipe wall thermal inertia";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

  parameter Real C(unit="J/(K.m)")=
    rho_default*Modelica.Constants.pi*(dh/2)^2*cp_default
    "Thermal capacity per unit length of water in pipe";

  parameter Modelica.Units.SI.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Boolean have_pipCap_a = have_pipCap and have_symmetry;

  BaseClasses.PlugFlow del(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final dh=dh,
    final length=length,
    final allowFlowReversal=allowFlowReversal,
    final T_start_in=T_start_in,
    final T_start_out=T_start_out)
    "Model for temperature wave propagation"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  BaseClasses.PlugFlowHeatLoss heaLos_a(
    redeclare final package Medium = Medium,
    final C=C,
    final R=R,
    final m_flow_small=m_flow_small,
    final T_start=T_start_in,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start,
    final show_T=false,
    final show_V_flow=false) "Heat loss for flow from port_b to port_a"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  BaseClasses.PlugFlowHeatLoss heaLos_b(
    redeclare final package Medium = Medium,
    final C=C,
    final R=R,
    final m_flow_small=m_flow_small,
    final T_start=T_start_out,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start,
    final show_T=false,
    final show_V_flow=false) "Heat loss for flow from port_a to port_b"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
     "Mass flow sensor"
    annotation (Placement(transformation(extent={{-40,50},{-20,30}})));
  BaseClasses.PlugFlowTransportDelay timDel(
    final length=length,
    final dh=dh,
    final rho=rho_default,
    final initDelay=initDelay,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_start=m_flow_start) "Time delay"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

  // In the volume, below, we scale down V and use
  // mSenFac. Otherwise, for air, we would get very large volumes
  // which affect the delay of water vapor and contaminants.
  // See also Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.TransportWaterAir
  // for why mSenFac is 10 and not 1000, as this gives more reasonable
  // temperature step response
  Fluid.MixingVolumes.MixingVolume vol_b(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final V=if rho_default > 500 then VEqu else VEqu/1000,
    final nPorts=2,
    final T_start=T_start_out,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final mSenFac=if rho_default > 500 then 1 else 10) if have_pipCap
    "Control volume connected to port_b.
    Represents equivalent pipe wall thermal capacity."
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  LosslessPipe noMixPip_b(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal) if not have_pipCap
    "Lossless pipe for connecting the outlet port when have_pipCap=false"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));

  MixingVolumes.MixingVolume vol_a(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final V=if rho_default > 500 then VEqu else VEqu/1000,
    final nPorts=2,
    final T_start=T_start_out,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final mSenFac=if rho_default > 500 then 1 else 10) if have_pipCap_a
    "Control volume connected to port_a.
    Represents equivalent pipe wall thermal capacity."
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  LosslessPipe noMixPip_a(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal) if not have_pipCap_a
    "Lossless pipe for connecting the outlet port when have_pipCap=false
    or have_symmetry=false"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default
    value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation

  connect(senMasFlo.m_flow,timDel. m_flow)
    annotation (Line(points={{-30,29},{-30,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timDel.tauRev,heaLos_a. tau)
    annotation (Line(points={{11,-36},{16,-36},{16,-20},{-32,-20},
      {-32,16},{-44,16},{-44,10}}, color={0,0,127}));
  connect(timDel.tau,heaLos_b. tau)
    annotation (Line(points={{11,-44},{34,-44},{34,18},{44,18},{44,10}},
      color={0,0,127}));
  connect(heaLos_a.port_a,senMasFlo. port_a)
    annotation (Line(points={{-40,0},{-20,0},{-20,20},{-44,20},
      {-44,40},{-40,40}},color={0,127,255}));
  connect(del.port_a,res. port_b)
    annotation (Line(points={{20,40},{10,40}},
      color={0,127,255}));
  connect(senMasFlo.port_b,res. port_a)
    annotation (Line(points={{-20,40},{-10,40}},
      color={0,127,255}));
  connect(heaLos_b.port_a,del. port_b)
    annotation (Line(points={{40,0},{20,0},{20,20},{44,20},{44,40},{40,40}},
      color={0,127,255}));
  connect(heaLos_b.heatPort, heatPort)
    annotation (Line(points={{50,10},{50,86},{0,86},{0,100}},
      color={191,0,0}));
  connect(heaLos_a.heatPort, heatPort)
    annotation (Line(points={{-50,10},{-50,86},{0,86},{0,100}},
      color={191,0,0}));

  connect(heaLos_b.port_b, vol_b.ports[1])
    annotation (Line(points={{60,0},{78,0},{78,20}}, color={0,127,255}));
  connect(vol_b.ports[2], port_b)
    annotation (Line(points={{82,20},{82,0},{100,0}}, color={0,127,255}));
  connect(heaLos_b.port_b, noMixPip_b.port_a)
    annotation (Line(points={{60,0},{66,0},{66,-20},{70,-20}},
      color={0,127,255}));
  connect(noMixPip_b.port_b, port_b)
    annotation (Line(points={{90,-20},{94,-20},{94,0},{100,0}},
      color={0,127,255}));

  connect(port_a, vol_a.ports[1])
    annotation (Line(points={{-100,0},{-82,0},{-82,20}}, color={0,127,255}));
  connect(vol_a.ports[2], heaLos_a.port_b)
    annotation (Line(points={{-78,20},{-78,0},{-60,0}}, color={0,127,255}));
  connect(port_a, noMixPip_a.port_a) annotation (Line(points={{-100,0},{-94,0},{
          -94,-20},{-90,-20}}, color={0,127,255}));
  connect(noMixPip_a.port_b, heaLos_a.port_b) annotation (Line(points={{-70,-20},
          {-64,-20},{-64,0},{-60,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,90},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              90}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Text(
          extent={{-102,-76},{98,-104}},
          textColor={0,0,0},
          textString="d = %dh"),
        Text(
          extent={{-100,-56},{100,-74}},
          textColor={0,0,0},
          textString="L = %length")}),
    Documentation(revisions="<html>
<ul>
<li>
October 15, 2021, by Michael Wetter:<br/>
Moved model to <code>BaseClasses</code>. This allows
<a href=\"Buildings.Fluid.FixedResistances.PlugFlowPipe\">Buildings.Fluid.FixedResistances.PlugFlowPipe</a>
to redeclare the resistance as final, thereby avoiding that a GUI presents this instance
to users as a replaceable class.
</li>
<li>
October 05, 2021, by Baptiste Ravache:<br/>
Made model symmetrical and extends from
<a href=\"Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
</li>
<li>
September 14, 2021, by Michael Wetter:<br/>
Made most instances protected and exposed main variables of interest.
</li>
<li>
July 9, 2021, by Baptiste Ravache:<br/>
Replaced the vectorized outlet port <code>ports_b</code> with
a single outlet port <code>port_b</code>.<br/>
Expanded the core pipe model that was previously a component.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1494\">IBPSA, #1494</a>.<br/>
This change is not backward compatible.<br/>
The previous classes definitions were moved to
<a href=\"modelica://Buildings.Obsolete.Fluid.FixedResistances.PlugFlowPipe\">
Buildings.Obsolete.Fluid.FixedResistances.PlugFlowPipe</a>.
<a href=\"modelica://Buildings.Obsolete.Fluid.FixedResistances.BaseClasses.PlugFlowCore\">
Buildings.Obsolete.Fluid.FixedResistances.BaseClasses.PlugFlowCore</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
March 6, 2020, by Jelger Jansen:<br/>
Revised calculation of thermal resistance <code>R</code>
by using correct radiuses.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1310\">#1310</a>.
</li>
<li>
October 23, 2017, by Michael Wetter:<br/>
Revised variable names and documentation to follow guidelines.
Corrected malformed hyperlinks.
</li>
<li>
July 4, 2016 by Bram van der Heijde:<br/>
Introduce <code>pipVol</code>.
</li>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
Replace resistance and temperature delay by an adiabatic pipe.
</li>
<li>September, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Pipe with heat loss using the time delay based heat losses and transport
of the fluid using a plug flow model, applicable for simulation of long
pipes such as in district heating and cooling systems.</p>
<p>
This model takes into account transport delay along the pipe length idealized
as a plug flow.
The model also includes thermal inertia of the pipe wall.
</p>
<h4>Implementation</h4>
<p>
The
<code>spatialDistribution</code> operator is used for the temperature wave propagation
through the length of the pipe. This operator is contained in
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow</a>.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowHeatLoss</a>
implements a heat loss in design direction, but leaves the enthalpy unchanged
in opposite flow direction. Therefore it is used in front of and behind the time delay.
</p>
<p>
The pressure drop is implemented using
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>.
This instance is replaceable to allow
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized\">
Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized</a>
to compute the pressure drop only once rather than for each segment.
</p>
<p>
The thermal capacity of the pipe wall is implemented as a mixing volume
of the fluid in the pipe, of which the thermal capacity is equal to that
of the pipe wall material.
In addition, this mixing volume allows the hydraulic separation of subsequent pipes.
<br/>
The mixing volume is either split between the inlet and outlet ports
(port_a and port_b) or lumped in at the outlet (port_b)
if <code>have_symmetry</code> is set to false.
This mixing volume can be removed from this model with the Boolean parameter
<code>have_pipCap</code>, in cases where the pipe wall heat capacity
is negligible and a state is not needed at the pipe outlet
(see the note below about numerical Jacobians).
</p>
<p>
Note that in order to model a branched network it is recommended to use
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a> at each junction and to configure
that junction model with a state
(<code>energyDynamics &lt;&gt; Modelica.Fluid.Types.Dynamics.SteadyState</code>),
see for instance
<a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.PlugFlowAIT</a>.
This will avoid the numerical Jacobian that is otherwise created when
the inlet ports of two instances of the plug flow model are connected together.
</p>
<h4>Assumptions</h4>
<ul>
<li>
Heat losses are for steady-state operation.
</li>
<li>
The axial heat diffusion in the fluid, the pipe wall and the ground are neglected.
</li>
<li>
The boundary temperature is uniform.
</li>
<li>
The thermal inertia of the pipe wall material is lumped on the side of the pipe
that is connected to <code>port_b</code>.
</li>
</ul>
<h4>References</h4>
<p>
Full details on the model implementation and experimental validation can be found
in:
</p>
<p>
van der Heijde, B., Fuchs, M., Ribas Tugores, C., Schweiger, G., Sartor, K.,
Basciotti, D., M&uuml;ller, D., Nytsch-Geusen, C., Wetter, M. and Helsen, L.
(2017).<br/>
Dynamic equation-based thermo-hydraulic pipe model for district heating and
cooling systems.<br/>
<i>Energy Conversion and Management</i>, vol. 151, p. 158-169.
<a href=\"https://doi.org/10.1016/j.enconman.2017.08.072\">doi:
10.1016/j.enconman.2017.08.072</a>.</p>
</html>"));
end PlugFlowPipe;
