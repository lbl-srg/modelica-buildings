within Buildings.Fluid.Movers.BaseClasses;
partial model PartialFlowMachine
  "Partial model to interface fan or pump models with the medium"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1);

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    show_T=false,
    port_a(
      h_outflow(start=h_outflow_start)),
    port_b(
      h_outflow(start=h_outflow_start),
      p(start=p_start),
      final m_flow(max = if allowFlowReversal then +Modelica.Constants.inf else 0)));

  parameter Buildings.Fluid.Types.InputType inputType = Buildings.Fluid.Types.InputType.Continuous
    "Control input type for this mover";
  parameter Real constInput = 0 "Constant input set point"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  parameter Modelica.SIunits.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",
                        group="Nominal condition",
                        enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState or
                               massDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));
  parameter Real stageInputs[:]
    "Vector of input set points corresponding to stages";

  // Classes used to implement the filtered speed
  parameter Boolean filteredSpeed=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Real y_start(min=0, max=1, unit="1")=0 "Initial value of speed"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));

  Modelica.Blocks.Interfaces.IntegerInput stage if
       inputType == Buildings.Fluid.Types.InputType.Stages
    "Stage input signal for the pressure head"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  // Models
  Buildings.Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final p_start=p_start,
    final prescribedHeatFlowRate=true,
    final allowFlowReversal=allowFlowReversal,
    nPorts=2) "Fluid volume for dynamic model"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));
protected
  final parameter Modelica.SIunits.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

  final parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
    T=T_start,
    p=p_start,
    X=X_start) "Medium state at start values";

  final parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
    "Start value for outflowing enthalpy";
  Modelica.Blocks.Sources.Constant[size(stageInputs, 1)] stageValues(
    final k=stageInputs) if
       inputType == Buildings.Fluid.Types.InputType.Stages "Stage input values"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant setConst(
    final k=constInput) if
       inputType == Buildings.Fluid.Types.InputType.Constant
    "Constant input set point"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Extractor extractor(
    final nin=size(stageInputs, 1),
    index(fixed=true,
          start=0)) if
       inputType == Buildings.Fluid.Types.InputType.Stages
    "Stage input extractor"
    annotation (Placement(transformation(extent={{-50,60},{-30,40}})));
  Modelica.Blocks.Routing.RealPassThrough inputSwitch
    "Dummy connection for easy connection of input options"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,50})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal) "Pressure source"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Movers.BaseClasses.PowerInterface heaDis(
    rho_default=rho_default) "Heat dissipation into medium"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Modelica.Blocks.Math.Add PToMed(final k1=1, final k2=1) if
                   addPowerToMedium "Heat and work input into medium"
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prePow if addPowerToMedium
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{-14,-90},{-34,-70}})));

  Modelica.Blocks.Sources.RealExpression rho_inlet(y=
    Medium.density(
      Medium.setState_phX(port_a.p,
                          inStream(port_a.h_outflow),
                          inStream(port_a.Xi_outflow))))
    "Density of the inflowing fluid"
    annotation (Placement(transformation(extent={{-94,-60},{-74,-40}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-70,10},{-50,-10}})));
equation
  connect(prePow.port, vol.heatPort) annotation (Line(
      points={{-34,-80},{-42,-80},{-42,10},{-10,10}},
      color={191,0,0}));

  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-10,10},{-10,10},{-42,10},{-42,-80},{-60,-80}},
      color={191,0,0}));
  connect(preSou.port_b, port_b) annotation (Line(
      points={{60,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{100,
          5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stageValues.y, extractor.u) annotation (Line(
      points={{-59,50},{-52,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractor.y, inputSwitch.u) annotation (Line(
      points={{-29,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setConst.y, inputSwitch.u) annotation (Line(
      points={{-59,80},{-26,80},{-26,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractor.index, stage) annotation (Line(
      points={{-40,62},{-40,90},{0,90},{0,120}},
      color={255,127,0},
      smooth=Smooth.None));

  connect(PToMed.y, prePow.Q_flow) annotation (Line(points={{71,-70},{80,-70},{80,
          -92},{0,-92},{0,-80},{-14,-80}}, color={0,0,127}));
  connect(PToMed.u1, heaDis.Q_flow) annotation (Line(points={{48,-64},{44,-64},{
          44,-50},{41,-50}}, color={0,0,127}));

  connect(port_a, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-86,0},{-70,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, vol.ports[1])
    annotation (Line(points={{-50,0},{-2,0}}, color={0,127,255}));
  connect(vol.ports[2], preSou.port_a)
    annotation (Line(points={{2,0},{2,0},{40,0}}, color={0,127,255}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Line(
          points={{0,50},{100,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,80},{100,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible=not filteredSpeed,
          points={{0,100},{0,40}}),
        Rectangle(
          extent={{-100,16},{100,-14}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,50},{54,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-56},{54,2},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,14},{34,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Rectangle(
          visible=filteredSpeed,
          extent={{-34,40},{32,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=filteredSpeed,
          extent={{-34,100},{32,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=filteredSpeed,
          extent={{-22,92},{20,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold}),
        Text(extent={{64,98},{114,84}},
          lineColor={0,0,127},
          textString="P")}),
    Documentation(info="<html>
<p>
This is the base model for fans and pumps.
It provides an interface
between the equations that compute head and power consumption,
and the implementation of the energy and pressure balance
of the fluid.
</p>
<p>
Optionally, the fluid volume
is computed using a dynamic balance or a steady-state balance.
</p>
<p>
The parameter <code>addPowerToMedium</code> determines whether
any power is added to the fluid. The default is <code>addPowerToMedium=true</code>,
and hence the outlet enthalpy is higher than the inlet enthalpy if the
flow device is operating.
The setting <code>addPowerToMedium=false</code> is physically incorrect
(since the flow work, the flow friction and the fan heat do not increase
the enthalpy of the medium), but this setting does in some cases lead to simpler equations
and more robust simulation, in particular if the mass flow is equal to zero.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
Refactored model to make implementation clearer.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
<br/>
Removed the parameter <code>dynamicBalance</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/411\">#411</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/349\">#349</a>.
Removed assignment of <code>min</code> and <code>max</code> attributes
of the port mass flow rate as this is already done in the base class.
Removed <code>import</code> statement.
</li>
<li>
April 2, 2015, by Filip Jorissen:<br/>
Added code for supporting stage input and constant input.
Added code for displaying constant set point in symbol.
</li>
<li>
January 24, 2015, by Michael Wetter:<br/>
Propagated <code>m_flow_small</code> of instance <code>vol</code> and made
all its parameters final.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 29, 2010, by Michael Wetter:<br/>
Reduced fan time constant from 10 to 1 second.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end PartialFlowMachine;
