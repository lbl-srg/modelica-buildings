within Buildings.Fluid.HeatExchangers.RadiantSlabs;
model ParallelCircuitsSlab
  "Model of multiple parallel circuits of a radiant slab"
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    port_a(p(start=p_start,
             nominal=Medium.p_default)),
    port_b(p(start=p_start,
           nominal=Medium.p_default)));
  extends Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Slab;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
   dp_nominal = Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal/nCir,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=pipe.dIn,
      roughness=pipe.roughness,
      m_flow_small=m_flow_small/nCir));

  parameter Integer nCir(min=1) = 1 "Number of parallel circuits";
  parameter Integer nSeg(min=1) = if heatTransfer==Types.HeatTransfer.EpsilonNTU then 1 else 5
    "Number of volume segments in each circuit (along flow path)";

  parameter Modelica.SIunits.Area A
    "Surface area of radiant slab (all circuits combined)"
  annotation(Dialog(group="Construction"));
  parameter Modelica.SIunits.Length length = A/disPip/nCir
    "Length of the pipe of a single circuit";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate of all circuits combined"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate of all circuits combined for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  final parameter Modelica.SIunits.Velocity v_nominal=
    4*m_flow_nominal/pipe.dIn^2/Modelica.Constants.pi/rho_default/nCir
    "Velocity at m_flow_nominal";

  // Parameters used for the fluid model implementation
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer
    heatTransfer=Types.HeatTransfer.EpsilonNTU
    "Model for heat transfer between fluid and slab";

  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.MassFlowRate m_flow(start=0) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction) for all circuits combined";
  Modelica.SIunits.PressureDifference dp(start=0, displayUnit="Pa") = port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=if homotopyInitialization then
      Medium.setState_phX(port_a.p,
                          homotopy(actual=noEvent(actualStream(port_a.h_outflow)),
                                   simplified=inStream(port_a.h_outflow)),
                          homotopy(actual=noEvent(actualStream(port_a.Xi_outflow)),
                                   simplified=inStream(port_a.Xi_outflow)))
    else
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=if homotopyInitialization then
      Medium.setState_phX(port_b.p,
                          homotopy(actual=noEvent(actualStream(port_b.h_outflow)),
                                   simplified=port_b.h_outflow),
                          homotopy(actual=noEvent(actualStream(port_b.Xi_outflow)),
                            simplified=port_b.Xi_outflow))
    else
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if
          show_T "Medium properties in port_b";

  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla(
    redeclare final package Medium = Medium,
    final heatTransfer=heatTransfer,
    final sysTyp=sysTyp,
    final A=A/nCir,
    final disPip=disPip,
    final pipe=pipe,
    final layers=layers,
    final steadyStateInitial=steadyStateInitial,
    final iLayPip=iLayPip,
    final T_a_start=T_a_start,
    final T_b_start=T_b_start,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal/nCir,
    final m_flow_small=m_flow_small/nCir,
    final homotopyInitialization=homotopyInitialization,
    final from_dp=from_dp,
    final dp_nominal=dp_nominal,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final nSeg=nSeg,
    final length=length,
    final ReC=4000,
    final stateAtSurface_a=stateAtSurface_a,
    final stateAtSurface_b=stateAtSurface_b) "Single parallel circuit of the radiant slab"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Start state";
  parameter Modelica.SIunits.Density rho_default = Medium.density(state_default);
  parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at nominal condition";

  Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.MassFlowRateMultiplier masFloMul_a(
      redeclare final package Medium = Medium,
      final k=nCir)
    "Mass flow multiplier, used to avoid having to instanciate multiple slab models"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.MassFlowRateMultiplier masFloMul_b(
      redeclare final package Medium = Medium,
      final k=nCir)
    "Mass flow multiplier, used to avoid having to instanciate multiple slab models"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.HeatFlowRateMultiplier heaFloMul_a(
      final k=nCir)
    "Heat flow rate multiplier, used to avoid having to instanciate multiple slab models"
    annotation (Placement(transformation(extent={{-40,20},{-60,40}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.HeatFlowRateMultiplier heaFloMul_b(
     final k=nCir)
    "Heat flow rate multiplier, used to avoid having to instanciate multiple slab models"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(sla.port_b, masFloMul_b.port_a) annotation (Line(
      points={{10,0},{28,0},{28,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(masFloMul_b.port_b, port_b) annotation (Line(
      points={{60,0},{80,0},{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(port_a, masFloMul_a.port_b) annotation (Line(
      points={{-100,0},{-78,0},{-78,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(masFloMul_a.port_a, sla.port_a) annotation (Line(
      points={{-40,0},{-24,0},{-24,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sla.surf_a,heaFloMul_a. port_a) annotation (Line(
      points={{4,10},{4,30},{-40,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloMul_a.port_b, surf_a) annotation (Line(
      points={{-60,30},{-70,30},{-70,50},{40,50},{40,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla.surf_b,heaFloMul_b. port_a) annotation (Line(
      points={{4,-10},{4,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFloMul_b.port_b, surf_b) annotation (Line(
      points={{60,-30},{70,-30},{70,-80},{40,-80},{40,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This is a model of a radiant slab with pipes or a capillary heat exchanger
embedded in the construction.
The model is a composition of multiple models of
<a href=\"Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>
that are arranged in a parallel.
</p>
<p>
The parameter <code>nCir</code> declares the number of parallel flow circuits.
Each circuit will have the same mass flow rate, and it is exposed to the same
port variables for the heat port at the two surfaces, and for the flow inlet and outlet.
</p>
<p>
A typical model application is as follows: Suppose a large room has a radiant slab with two parallel circuits
with the same pipe spacing and pipe length. Then, rather than using two instances of
<a href=\"Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>,
this system can be modeled using one instance of this model in order to reduce computing effort.
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuitEpsilonNTU\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuitEpsilonNTU</a> for an example
that shows that the models give identical results.
</p>
<p>
Since this model is a parallel arrangment of <code>nCir</code> models of
<a href=\"Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>,
we refer to
<a href=\"Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a>
for the model documentation.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">
user's guide</a> for more information.
</p>
<h4>Implementation</h4>
<p>
To allow a better comment for the nominal mass flow rate, i.e., to specify that
its value is for all circuits combined, this
model does not inherit
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
June 9, 2015 by Michael Wetter:<br/>
Changed base class from
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\">
Modelica.Fluid.Interfaces.PartialTwoPort</a>
to
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPort\">
Buildings.Fluid.Interfaces.PartialTwoPort</a>.
</li>
<li>
October 10, 2013 by Michael Wetter:<br/>
Added <code>noEvent</code> to the computation of the states at the port.
This is correct, because the states are only used for reporting, but not
to compute any other variable.
Use of the states to compute other variables would violate the Modelica
language, as conditionally removed variables must not be used in any equation.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 14, 2013, by Michael Wetter:<br/>
Corrected assignment of start value for pressure at <code>port_a</code>
and <code>port_b</code>, which used <code>Medium.p_default</code>
instead of the parameter <code>p_start</code>.
</li>
<li>
June 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={95,95,95},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{-74,0},{-74,72},{60,72},{60,46},{-48,46},{-48,14},{59.8945,
              14},{59.9999,0.0136719},{92,0}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None),
        Line(
          points={{-90,0},{-74,0},{-74,-72},{60,-72},{60,-48},{-48,-48},{-48,-12},
              {59.7891,-12},{60,0}},
          color={0,128,255},
          thickness=1,
          smooth=Smooth.None)}));
end ParallelCircuitsSlab;
