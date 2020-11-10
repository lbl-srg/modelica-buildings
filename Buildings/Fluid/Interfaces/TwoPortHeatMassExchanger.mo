within Buildings.Fluid.Interfaces;
model TwoPortHeatMassExchanger
  "Partial model transporting one fluid stream with storing mass or energy"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    port_a(h_outflow(start=h_outflow_start)),
    port_b(h_outflow(start=h_outflow_start)));
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=true);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  replaceable Buildings.Fluid.MixingVolumes.MixingVolume vol
  constrainedby Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
    redeclare final package Medium = Medium,
    nPorts = 2,
    V=m_flow_nominal*tau/rho_default,
    final allowFlowReversal=allowFlowReversal,
    final mSenFac=1,
    final m_flow_nominal = m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start) "Volume for fluid stream"
     annotation (Placement(transformation(extent={{-9,0},{11,-20}})));

  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
      T=T_start, p=p_start, X=X_start);
  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
    "Start value for outflowing enthalpy";

initial algorithm
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");

  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(vol.ports[2], port_b) annotation (Line(
      points={{1,0},{100,0}},
      color={0,127,255}));
  connect(port_a, preDro.port_a) annotation (Line(
      points={{-100,0},{-90,0},{-90,0},{-80,0},{-80,0},{-60,0}},
      color={0,127,255}));
  connect(preDro.port_b, vol.ports[1]) annotation (Line(
      points={{-40,0},{1,0}},
      color={0,127,255}));
  annotation (
    Documentation(info="<html>
<p>
This component transports one fluid stream.
It provides the basic model for implementing dynamic and steady-state
models that exchange heat and water vapor with the fluid stream.
The model also computes the pressure drop due to the flow resistance.
By setting the parameter <code>dp_nominal=0</code>, the computation
of the pressure drop can be avoided.
The variable <code>vol.heatPort.T</code> always has the value of
the temperature of the medium that leaves the component.
For the actual temperatures at the port, the variables <code>sta_a.T</code>
and <code>sta_b.T</code> can be used. These two variables are provided by
the base class
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
</p>

For models that extend this model, see for example
<ul>
<li>
the ideal heater or cooler
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>, and
</li>
<li>
the ideal humidifier
<a href=\"modelica://Buildings.Fluid.Humidifiers.Humidifier_u\">
Buildings.Fluid.Humidifiers.Humidifier_u</a>.
</li>
</ul>

<h4>Implementation</h4>
<p>
The variable names follow the conventions used in
<a href=\"modelica://Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX\">
Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX
</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">Buildings, #1341</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Updated model as <code>use_dh</code> is no longer a parameter in the pressure drop model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>final quantity=Medium.substanceNames</code> for <code>X_start</code>.
</li>
<li>
May 6, 2015, by Michael Wetter:<br/>
Added missing propagation of <code>allowFlowReversal</code> to
instance <code>vol</code>.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/412\">#412</a>.
</li>
<li>
May 1, 2015, by Marcus Fuchs:<br/>
Fixed links in documentation.
</li>
<li>
October 6, 2014, by Michael Wetter:<br/>
Changed medium declaration in pressure drop element to be final.
</li>
<li>
May 28, 2014, by Michael Wetter:<br/>
Removed <code>annotation(Evaluate=true)</code> for parameter <code>tau</code>.
This is needed to allow changing the time constant after translation.
</li>
<li>
November 12, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants</code> statement.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 17, 2012, by Michael Wetter:<br/>
Fixed broken link in documentation.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in the pressure drop model.
</li>
<li>
January 15, 2011, by Michael Wetter:<br/>
Fixed wrong class reference in information section.
</li>
<li>
September 13, 2011, by Michael Wetter:<br/>
Changed assignment of <code>vol(mass/energyDynamics=...)</code> as the
previous assignment caused a non-literal start value that was ignored.
</li>
<li>
July 29, 2011, by Michael Wetter:<br/>
Added start value for outflowing enthalpy.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Changed parameterization of fluid volume so that steady-state balance is
used when <code>tau = 0</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Removed temperature sensor and changed implementation of fluid volume
to allow use of this model for the steady-state and dynamic humidifier
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and
air, which are typically at different pressures.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
January 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end TwoPortHeatMassExchanger;
