within Buildings.Fluid.Movers.BaseClasses;
partial model PartialFlowMachine
  "Partial model to interface fan or pump models with the medium"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1);
  import Modelica.Constants;

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(show_T=false,
    port_a(
      h_outflow(start=h_outflow_start),
      final m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
    port_b(
      h_outflow(start=h_outflow_start),
      p(start=p_start),
      final m_flow(max = if allowFlowReversal then +Constants.inf else 0)),
      final showDesignFlowDirection=false);

  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Buildings.Fluid.Types.InputType inputType = Buildings.Fluid.Types.InputType.Continuous
    "Control input type for this mover";
  parameter Real constInput = 0 "Constant input set point"
    annotation(Dialog(enable=inputType == Buildings.Fluid.Types.InputType.Constant));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  parameter Modelica.SIunits.Time tau=1
    "Time constant of fluid volume for nominal flow, used if dynamicBalance=true"
    annotation (Dialog(tab="Dynamics", group="Nominal condition", enable=dynamicBalance));
  parameter Real stageInputs[:]
    "Vector of input set points corresponding to stages";
  // Models
  Buildings.Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final tau=tau,
    final energyDynamics=if dynamicBalance then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    final massDynamics=if dynamicBalance then massDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final p_start=p_start,
    final prescribedHeatFlowRate=true,
    final allowFlowReversal=allowFlowReversal,
    final nPorts=2) "Fluid volume for dynamic model"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));
  Modelica.Blocks.Interfaces.IntegerInput stage if
       inputType == Buildings.Fluid.Types.InputType.Stage
    "Stage input signal for the pressure head"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

protected
  parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
      T=T_start, p=p_start, X=X_start) "Medium state at start values";
  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
    "Start value for outflowing enthalpy";
  Modelica.Blocks.Sources.Constant[size(stageInputs, 1)] stageVals(k=stageInputs) if
       inputType == Buildings.Fluid.Types.InputType.Stage "Stage input values"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant setConst(k=constInput) if
       inputType == Buildings.Fluid.Types.InputType.Constant
    "Constant input set point"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Routing.Extractor extractor(nin=size(stageInputs, 1)) if
       inputType == Buildings.Fluid.Types.InputType.Stage
    "Stage input extractor"
    annotation (Placement(transformation(extent={{-50,60},{-30,40}})));
  Modelica.Blocks.Routing.RealPassThrough inputSwitch
    "Dummy connection for easy connection of input options"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,50})));
  Modelica.SIunits.Density rho_in "Density of inflowing fluid";

  Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal) "Pressure source"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prePow if addPowerToMedium
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

equation
  // For computing the density, we assume that the fan operates in the design flow direction.
  rho_in = Medium.density(
       Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
  connect(prePow.port, vol.heatPort) annotation (Line(
      points={{-50,20},{-44,20},{-44,10},{-40,10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-40,10},{-40,-80},{-60,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a, vol.ports[1]) annotation (Line(
      points={{-100,5.55112e-16},{-66,5.55112e-16},{-66,-5.55112e-16},{-32,
          -5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], preSou.port_a) annotation (Line(
      points={{-28,-5.55112e-16},{-5,-5.55112e-16},{-5,6.10623e-16},{20,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preSou.port_b, port_b) annotation (Line(
      points={{40,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{100,
          5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(stageVals.y, extractor.u) annotation (Line(
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
      points={{-40,62},{-40,90},{0,90},{0,120},{0,120}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Line(
          visible=not filteredSpeed,
          points={{0,100},{0,40}},
          color={0,0,0},
          smooth=Smooth.None),
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
          visible=dynamicBalance,
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
          textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>This is the base model for fans and pumps.
It provides an interface
between the equations that compute head and power consumption,
and the implementation of the energy and pressure balance
of the fluid.
</p>
<p>
Depending on the value of
the parameter <code>dynamicBalance</code>, the fluid volume
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end PartialFlowMachine;
