within Buildings.Fluid.Movers.BaseClasses;
partial model PartialFlowMachine
  "Partial model to interface fan or pump models with the medium"
  import Modelica.Constants;

  extends Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface(show_T=true,
    port_a(
      h_outflow(start=h_start),
      final m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
    port_b(
      h_outflow(start=h_start),
      p(start=p_start),
      final m_flow(max = if allowFlowReversal then +Constants.inf else 0)));

  Delays.DelayFirstOrder vol(
    redeclare package Medium = Medium,
    tau=tau,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    use_T_start=use_T_start,
    T_start=T_start,
    h_start=h_start,
    X_start=X_start,
    C_start=C_start,
    m_flow_nominal=m_flow_nominal,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer,
    nPorts=2,
    p_start=p_start) if
       dynamicBalance "Fluid volume for dynamic model"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
   parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Evaluate=true, Dialog(tab="Assumptions", group="Dynamics"));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
                     Modelica.Fluid.Types.Dynamics.SteadyStateInitial
    "Formulation of energy balance (used if dynamicBalance=true)"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance (used if dynamicBalance=true)"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));

  parameter Modelica.SIunits.Time tau=1
    "Time constant of fluid volume for nominal flow, used if dynamicBalance=true"
    annotation (Dialog(tab="Assumptions", group="Dynamics", enable=dynamicBalance));

  // Parameters for initialization
  // Initialization
  parameter Boolean use_T_start=true "= true, use T_start, otherwise h_start"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.Temperature T_start=if
      use_T_start then system.T_start else Medium.temperature_phX(
      p_start,
      h_start,
      X_start) "Start value of temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.SpecificEnthalpy h_start=
      if use_T_start then Medium.specificEnthalpy_pTX(
      p_start,
      T_start,
      X_start) else Medium.h_default "Start value of inlet specific enthalpy"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.MassFraction X_start[Medium.nX]=
     Medium.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Media.Interfaces.PartialMedium.ExtraProperty C_start[
    Medium.nC]=fill(0, Medium.nC) "Start value of trace substances"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Pressure p_start = Medium.p_default
    "Start value of inlet pressure"
    annotation (Dialog(tab="Initialization"));
  Modelica.SIunits.Density rho_in "Density of inflowing fluid";
  Modelica.SIunits.VolumeFlowRate V_in_flow
    "Volume flow rate that flows into the device";
  // Models
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if dynamicBalance
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));

protected
  IdealSource souDyn(redeclare package Medium =
                       Medium, final addPowerToMedium=false) if dynamicBalance
    "Pressure source for dynamic model, this changes the pressure in the medium"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource souSta(
                            redeclare package Medium = Medium,
                            final addPowerToMedium=addPowerToMedium) if not dynamicBalance
    "Source for static model, this changes the pressure in the medium and adds heat"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prePow if (dynamicBalance and addPowerToMedium)
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{-68,0},{-48,20}})));

equation
  // For computing the density, we assume that the fan operates in the design flow direction.
  rho_in = Medium.density(
       Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
  V_in_flow = m_flow/rho_in;
  connect(prePow.port, vol.heatPort) annotation (Line(
      points={{-48,10},{-40,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(souSta.port_b, port_b) annotation (Line(
      points={{70,-60},{80,-60},{80,5.55112e-16},{100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-40,10},{-40,-80},{-60,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, vol.ports[1]) annotation (Line(
      points={{-100,5.55112e-16},{-52,5.55112e-16},{-52,0},{-32,0},{-32,
          -5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souDyn.port_b, port_b) annotation (Line(
      points={{20,6.10623e-16},{69,6.10623e-16},{69,5.55112e-16},{100,
          5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souSta.port_a, port_a) annotation (Line(
      points={{50,-60},{-60,-60},{-60,5.55112e-16},{-100,5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], souDyn.port_a) annotation (Line(
      points={{-28,-5.55112e-16},{-15,-5.55112e-16},{-15,6.10623e-16},{
          -5.55112e-16,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-48,-60},{-72,-100},{72,-100},{48,-60},{-48,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-100,46},{100,-46}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{2,70},{2,-66},{72,4},{2,70}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,72},{0,-68},{74,4},{0,72}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{16,18},{46,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=dynamicBalance,
          fillColor={0,100,199})}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}),
            graphics={Text(
          extent={{-48,-74},{98,-94}},
          lineColor={0,0,255},
          textString="Note that one of the two fluid streams will be removed"),
          Text(
          extent={{-48,-84},{70,-102}},
          lineColor={0,0,255},
          textString="depending on the value of dynamicBalance.")}),
    Documentation(info="<html>
<p>This is the base model for fans and pumps.
It provides an interface
between the equations that compute head and power consumption,
and the implementation of the energy and pressure balance
of the fluid.
</p>
<p>
The model has two fluid streams. Depending on the value of
the parameter <code>dynamicBalance</code>, one of the streams
is removed.
</p>
<p>
The parameter <code>addPowerToMedium</code> determines whether 
any power is added to the fluid. The default is <code>addPowerToMedium=true</code>,
and hence the outlet enthalpy is higher than the inlet enthalpy if the
flow device is operating.
The setting <code>addPowerToMedium=false</code> is physically incorrect
(since the flow work, the flow friction and the fan heat do not increase
the enthalpy of the medium), but this setting does in some cases lead to simpler equations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 29, 2010, by Michael Wetter:<br>
Reduced fan time constant from 10 to 1 second.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialFlowMachine;
