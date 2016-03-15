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

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{52,60},{72,80}})));

  parameter Buildings.Fluid.Types.InputType inputType = Buildings.Fluid.Types.InputType.Continuous
    "Control input type"
    annotation(Dialog(
      group="Control"));
  parameter Real constInput = 0 "Constant input set point"
    annotation(Dialog(
      group="Control",
      enable=inputType == Buildings.Fluid.Types.InputType.Constant));
  parameter Real stageInputs[:]
    "Vector of input set points corresponding to stages"
    annotation(Dialog(
      group="Control",
      enable=inputType == Buildings.Fluid.Types.InputType.Stages));

  parameter Boolean computePowerUsingSimilarityLaws
    "= true, compute power exactly, using similarity laws. Otherwise approximate.";

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

  parameter Boolean nominalValuesDefineDefaultPressureCurve = false
    "Set to true to avoid warning if m_flow_nominal and dp_nominal are used to construct the default pressure curve";

  parameter Modelica.SIunits.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",
                        group="Nominal condition",
                        enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState or
                               massDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));

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

  // Connectors and ports
    Modelica.Blocks.Interfaces.IntegerInput stage if
       inputType == Buildings.Fluid.Types.InputType.Stages
    "Stage input signal for the pressure head"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput y_actual(
    min=0,
    final unit="1")
    "Actual normalised pump speed that is used for computations"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
        iconTransformation(extent={{100,40},{120,60}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));

  // Variables
  Modelica.SIunits.VolumeFlowRate VMachine_flow = eff.V_flow "Volume flow rate";
  Modelica.SIunits.PressureDifference dpMachine(displayUnit="Pa")=
      -preSou.dp "Pressure difference";

  Modelica.SIunits.Efficiency eta =    eff.eta "Global efficiency";
  Modelica.SIunits.Efficiency etaHyd = eff.etaHyd "Hydraulic efficiency";
  Modelica.SIunits.Efficiency etaMot = eff.etaMot "Motor efficiency";

  // Quantity to control
protected
  parameter Types.PrescribedVariable preVar "Type of prescribed variable";

  // The parameter speedIsInput is required to conditionally remove the instance gain.
  // If the conditional removal of this instance where to use the test
  // preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed,
  // then OpenModelica fails to translate the model with the message
  // .../PartialFlowMachine.mo:185:3-189:70:writable]
  // Error: Variable Types.PrescribedVariable.Speed not found in scope
  // Buildings.Fluid.Movers.SpeedControlled_y$floMac1.
  final parameter Boolean speedIsInput=
    (preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed)
    "Parameter that is true if speed is the controlled variables";

  final parameter Integer nOri = size(per.pressure.V_flow, 1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);

  final parameter Boolean haveVMax = (abs(per.pressure.dp[nOri]) < Modelica.Constants.eps)
    "Flag, true if user specified data that contain V_flow_max";

  final parameter Modelica.SIunits.VolumeFlowRate V_flow_max=
    if per.havePressureCurve then
    (if haveVMax then
      per.pressure.V_flow[nOri]
     else
      per.pressure.V_flow[nOri] - (per.pressure.V_flow[nOri] - per.pressure.V_flow[
      nOri - 1])/((per.pressure.dp[nOri] - per.pressure.dp[nOri - 1]))*per.pressure.dp[nOri])
    else
      m_flow_nominal/rho_default "Maximum volume flow rate, used for smoothing";
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
      inputType == Buildings.Fluid.Types.InputType.Stages "Stage input extractor"
    annotation (Placement(transformation(extent={{-50,60},{-30,40}})));
  Modelica.Blocks.Routing.RealPassThrough inputSwitch
    "Dummy connection for easy connection of input options"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,50})));

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
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Modelica.Blocks.Continuous.Filter filter(
     order=2,
     f_cut=5/(2*Modelica.Constants.pi*riseTime),
     final init=init,
     x(each stateSelect=StateSelect.always),
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
        filteredSpeed
    "Second order filter to approximate valve opening time, and to improve numerics"
    annotation (Placement(transformation(extent={{20,81},{34,95}})));

  Modelica.Blocks.Math.Gain gaiSpe(y(final unit="1")) if
    inputType == Buildings.Fluid.Types.InputType.Continuous and
    speedIsInput
    "Gain to normalized speed using speed_nominal or speed_rpm_nominal"
    annotation (Placement(transformation(extent={{-4,74},{-16,86}})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow= (preVar ==  Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.FlowRate))
    "Pressure source"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Movers.BaseClasses.PowerInterface heaDis(
    final motorCooledByFluid=per.motorCooledByFluid,
    final delta_V_flow=1E-3*V_flow_max) if
      addPowerToMedium "Heat dissipation into medium"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Modelica.Blocks.Math.Add PToMed(final k1=1, final k2=1) if
    addPowerToMedium "Heat and work input into medium"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prePow if
    addPowerToMedium
    "Prescribed power (=heat and flow work) flow for dynamic model"
    annotation (Placement(transformation(extent={{-14,-104},{-34,-84}})));

  Modelica.Blocks.Sources.RealExpression rho_inlet(y=
    Medium.density(
      Medium.setState_phX(port_a.p,
                          inStream(port_a.h_outflow),
                          inStream(port_a.Xi_outflow))))
    "Density of the inflowing fluid"
    annotation (Placement(transformation(extent={{-90,-74},{-70,-54}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-70,10},{-50,-10}})));

  Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium) "Head of mover"
    annotation (Placement(transformation(extent={{58,-27},{43,-14}})));

  // Because the speed data are not used by FlowMachineInterface, we set them
  // to zero.
  FlowMachineInterface eff(
    per(
      final hydraulicEfficiency = per.hydraulicEfficiency,
      final motorEfficiency =     per.motorEfficiency,
      final motorCooledByFluid =  per.motorCooledByFluid,
      final speed_nominal =       0,
      final constantSpeed =       0,
      final speeds =              {0},
      final power =               per.power),
    final nOri = nOri,
    final rho_default=rho_default,
    final computePowerUsingSimilarityLaws=computePowerUsingSimilarityLaws,
    final haveVMax=haveVMax,
    final V_flow_max=V_flow_max,
    r_N(start=y_start),
    r_V(start=m_flow_nominal/rho_default),
    final preVar=preVar) "Flow machine"
    annotation (Placement(transformation(extent={{-32,-68},{-12,-48}})));

initial equation
  // The control signal is dp or m_flow but the user did not provide a pump curve.
  // Hence, the speed is computed using default values, which likely are wrong.
  // Therefore, scaling the power using the speed is inaccurate.
  assert(nominalValuesDefineDefaultPressureCurve or
         per.havePressureCurve or
         (preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed),
"*** Warning: You are using a flow or pressure controlled mover with the
             default pressure curve.
             This leads to approximate calculations of the electrical power
             consumption. Add the correct pressure curve in the record per
             to obtain an accurate computation.
             Setting nominalValuesDefineDefaultPressureCurve=true will suppress this warning.",
         level=AssertionLevel.warning);

  // The control signal is dp or m_flow but the user did not provide a pump curve.
  // Hence, the speed is computed using default values, which likely are wrong.
  // In addition, the user wants to use (V_flow, P) to compute the power.
  // This can lead to using a power that is less than the flow work. We avoid
  // this by ignoring the setting of per.use_powerCharacteristics.
  assert(nominalValuesDefineDefaultPressureCurve or
         (per.havePressureCurve or
           (preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed)) or
         per.use_powerCharacteristic == false,
"*** Warning: You are using a flow or pressure controlled mover with the
             default pressure curve and you set use_powerCharacteristic = true.
             Since this can cause wrong power consumption, the model will overwrite
             this setting and use instead use_powerCharacteristic = false.
             Since this causes the efficiency curve to be used,
             make sure that the efficiency curves in the performance record per
             are correct or add the pressure curve of the mover.
             Setting nominalValuesDefineDefaultPressureCurve=true will suppress this warning.",
         level=AssertionLevel.warning);

equation
  connect(prePow.port, vol.heatPort) annotation (Line(
      points={{-34,-94},{-40,-94},{-40,10},{-20,10}},
      color={191,0,0}));

  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-20,10},{-20,10},{-40,10},{-40,-100},{-60,-100}},
      color={191,0,0}));
  connect(preSou.port_b, port_b) annotation (Line(
      points={{60,0},{100,0}},
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

  connect(PToMed.y, prePow.Q_flow) annotation (Line(points={{71,-80},{80,-80},{80,
          -94},{-14,-94}},                 color={0,0,127}));
  connect(PToMed.u1, heaDis.Q_flow) annotation (Line(points={{48,-74},{44,-74},{
          44,-72},{44,-70},{41,-70}},
                             color={0,0,127}));

  connect(port_a, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-86,0},{-70,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, vol.ports[1])
    annotation (Line(points={{-50,0},{-12,0}},color={0,127,255}));
  connect(vol.ports[2], preSou.port_a)
    annotation (Line(points={{-8,0},{-8,0},{40,0}},
                                                  color={0,127,255}));
  connect(senRelPre.port_b, preSou.port_a) annotation (Line(points={{43,-20.5},{
          20,-20.5},{20,0},{40,0}},
                               color={0,127,255}));
  connect(senRelPre.port_a, preSou.port_b) annotation (Line(points={{58,-20.5},{
          80,-20.5},{80,0},{60,0}},
                               color={0,127,255}));
  connect(heaDis.etaHyd,eff. etaHyd) annotation (Line(points={{18,-60},{10,-60},
          {10,-65},{-11,-65}},                     color={0,0,127}));
  connect(heaDis.V_flow,eff. V_flow) annotation (Line(points={{18,-66},{14,-66},
          {14,-53.2},{-6,-53.2},{-11,-53.2}},
                                     color={0,0,127}));
  connect(eff.PEle, heaDis.PEle) annotation (Line(points={{-11,-59},{0,-59},{0,-80},
          {18,-80}},      color={0,0,127}));
  connect(eff.WFlo, heaDis.WFlo) annotation (Line(points={{-11,-56},{-8,-56},{-8,
          -74},{18,-74}}, color={0,0,127}));
  connect(rho_inlet.y,eff. rho) annotation (Line(points={{-69,-64},{-69,-64},{-34,
          -64}},                          color={0,0,127}));
  connect(eff.m_flow, senMasFlo.m_flow) annotation (Line(points={{-34,-54},{-60,
          -54},{-60,-11}},                         color={0,0,127}));
  connect(eff.PEle, P) annotation (Line(points={{-11,-59},{0,-59},{0,-50},{90,-50},
          {90,80},{110,80}}, color={0,0,127}));
  connect(eff.WFlo, PToMed.u2) annotation (Line(points={{-11,-56},{-8,-56},{-8,-86},
          {48,-86}},      color={0,0,127}));
  connect(inputSwitch.y, filter.u) annotation (Line(points={{1,50},{16,50},{16,88},
          {18.6,88}},     color={0,0,127}));

  connect(senRelPre.p_rel, eff.dp_in) annotation (Line(points={{50.5,-26.35},{50.5,
          -38},{-18,-38},{-18,-46}},               color={0,0,127}));
  connect(eff.y_out, y_actual) annotation (Line(points={{-11,-48},{92,-48},{92,50},
          {110,50}}, color={0,0,127}));
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
February 19, 2016, by Michael Wetter and Filip Jorissen:<br/>
Refactored model to make implementation clearer.
This model now includes code for both speed and flow prescribed models,
eliminating the need for an additional level of partial models.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PartialFlowMachine;
