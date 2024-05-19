within Buildings.Fluid.Movers.BaseClasses;
partial model PartialFlowMachine
  "Partial model to interface fan or pump models with the medium"
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);
  extends Buildings.Fluid.Interfaces.PartialTwoPort(
    port_a(
      p(start=Medium.p_default),
      h_outflow(start=h_outflow_start)),
    port_b(
      p(start=p_start),
      h_outflow(start=h_outflow_start)));

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

  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));

  // Classes used to implement the filtered speed
  parameter Boolean use_inputFilter=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      group="Filtered speed",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));

  // Connectors and ports
  Modelica.Blocks.Interfaces.IntegerInput stage
    if inputType == Buildings.Fluid.Types.InputType.Stages
    "Stage input signal for the pressure head"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));

  Modelica.Blocks.Interfaces.RealOutput y_actual(
    final unit="1")
    "Actual normalised fan or pump speed that is used for computations"
    annotation (Placement(transformation(extent={{100,60},{120,80}}),
        iconTransformation(extent={{100,60},{120,80}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    final unit="W") "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat dissipation to environment"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}),
        iconTransformation(extent={{-10,-78},{10,-58}})));

  // Variables
  Modelica.Units.SI.VolumeFlowRate VMachine_flow(start=_VMachine_flow) = eff.V_flow
    "Volume flow rate";
  Modelica.Units.SI.PressureDifference dpMachine(displayUnit="Pa") = -preSou.dp
    "Pressure difference";

  Real eta(unit="1", final quantity="Efficiency") =    eff.eta "Global efficiency";
  Real etaHyd(unit="1", final quantity="Efficiency") = eff.etaHyd "Hydraulic efficiency";
  Real etaMot(unit="1", final quantity="Efficiency") = eff.etaMot "Motor efficiency";

  // Quantity to control

  // Copied from Fluid.Interfaces.PartialTwoPortInterface
  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    _m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start) = port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(
    start=_dp_start,
    displayUnit="Pa") = port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  Medium.ThermodynamicState sta_a=
    if allowFlowReversal then
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
    else
      Medium.setState_phX(port_a.p,
                          noEvent(inStream(port_a.h_outflow)),
                          noEvent(inStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
    if allowFlowReversal then
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
    else
      Medium.setState_phX(port_b.p,
                          noEvent(port_b.h_outflow),
                          noEvent(port_b.Xi_outflow))
       if show_T "Medium properties in port_b";
  // - Copy continues in protected section

protected
  parameter Modelica.Units.SI.MassFlowRate _m_flow_nominal=
    max(eff.per.pressure.V_flow)*rho_default
    "Nominal mass flow rate";

  // Copied from Fluid.Interfaces.PartialTwoPortInterface
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start=0
    "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(displayUnit=
        "Pa") = 0
    "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";
  // - End of copy

  final parameter Modelica.Units.SI.VolumeFlowRate _VMachine_flow=0
    "Start value for VMachine_flow, used to avoid a warning if not specified";

  parameter Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable preVar "Type of prescribed variable";

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

  final parameter Boolean haveVMax = eff.haveVMax
    "Flag, true if user specified data that contain V_flow_max";

  final parameter Modelica.Units.SI.VolumeFlowRate V_flow_max=eff.V_flow_max;
  final parameter Modelica.Units.SI.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

  final parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
    T=T_start,
    p=p_start,
    X=X_start) "Medium state at start values";

  final parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_start=
      Medium.specificEnthalpy(sta_start) "Start value for outflowing enthalpy";

  final parameter Modelica.Units.SI.Frequency fCut=5/(2*Modelica.Constants.pi*
      riseTime) "Cut-off frequency of filter";

  Modelica.Blocks.Sources.Constant[size(stageInputs, 1)] stageValues(
    final k=stageInputs)
   if inputType == Buildings.Fluid.Types.InputType.Stages "Stage input values"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant setConst(
    final k=constInput)
   if inputType == Buildings.Fluid.Types.InputType.Constant
    "Constant input set point"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Extractor extractor(final nin=size(stageInputs,1))
   if inputType == Buildings.Fluid.Types.InputType.Stages "Stage input extractor"
    annotation (Placement(transformation(extent={{-50,60},{-30,40}})));

  Modelica.Blocks.Routing.RealPassThrough inputSwitch
    "Dummy connection for easy connection of input options"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-10,50})));

  Buildings.Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final m_flow_nominal=_m_flow_nominal,
    final m_flow_small=m_flow_small,
    final p_start=p_start,
    final prescribedHeatFlowRate=true,
    final allowFlowReversal=allowFlowReversal,
    nPorts=2) "Fluid volume for dynamic model"
    annotation (Placement(transformation(extent={{-70,0},{-90,20}})));

  Buildings.Fluid.BaseClasses.ActuatorFilter filter(
    final n=2,
    final f=fCut,
    final normalized=true,
    final initType=init) if use_inputFilter
    "Second order filter to approximate dynamics of the fan or pump's speed, and to improve numerics"
    annotation (Placement(transformation(extent={{20,61},{40,80}})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    final control_m_flow= (preVar ==  Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.FlowRate))
    "Pressure source"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Movers.BaseClasses.PowerInterface heaDis(
    final motorCooledByFluid=per.motorCooledByFluid,
    final delta_V_flow=1E-3*V_flow_max)
   if addPowerToMedium "Heat dissipation into medium"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Modelica.Blocks.Math.Add PToMed(final k1=1, final k2=1)
 if addPowerToMedium "Heat and work input into medium"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prePow(
    final alpha=0)
 if addPowerToMedium
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
    annotation (Placement(transformation(extent={{-50,10},{-30,-10}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium) "Head of mover"
    annotation (Placement(transformation(extent={{58,-27},{43,-14}})));

  // Because the speed data are not used by FlowMachineInterface, we set them
  // to zero.
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff(
    per(
      final powerOrEfficiencyIsHydraulic = per.powerOrEfficiencyIsHydraulic,
      final efficiency =           per.efficiency,
      final motorEfficiency =      per.motorEfficiency,
      final motorEfficiency_yMot = per.motorEfficiency_yMot,
      final motorCooledByFluid =   per.motorCooledByFluid,
      final speed_nominal =        0,
      final constantSpeed =        0,
      final speeds =               {0},
      final power =                per.power,
      final peak =                 per.peak),
    final nOri = nOri,
    final rho_default=rho_default,
    final computePowerUsingSimilarityLaws=computePowerUsingSimilarityLaws,
    r_V(start=_m_flow_nominal/rho_default),
    final preVar=preVar) "Flow machine"
    annotation (Placement(transformation(extent={{-32,-68},{-12,-48}})));

protected
  block Extractor
    "Extract scalar signal out of signal vector dependent on IntegerRealInput index"
    extends Modelica.Blocks.Interfaces.MISO;

    Modelica.Blocks.Interfaces.IntegerInput index "Integer input for control input"
    annotation (Placement(
          transformation(
          origin={0,-120},
          extent={{-20,-20},{20,20}},
          rotation=90)));
  equation
  y = sum({if index == i then u[i] else 0 for i in 1:nin});

  annotation (Icon(graphics={
          Rectangle(
            extent={{-80,50},{-40,-50}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-84.4104,1.9079},{-84.4104,-2.09208},{-80.4104,-0.09208},{
                -84.4104,1.9079}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{-62,2},{-50.1395,12.907},{-39.1395,12.907}}, color={0,0,
                127}),
          Line(points={{-63,4},{-49,40},{-39,40}}, color={0,0,127}),
          Line(points={{-102,0},{-65.0373,-0.01802}}, color={0,0,127}),
          Ellipse(
            extent={{-70.0437,4.5925},{-60.0437,-4.90745}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Line(points={{-63,-5},{-50,-40},{-39,-40}}, color={0,0,127}),
          Line(points={{-62,-2},{-50.0698,-12.907},{-39.0698,-12.907}}, color={
                0,0,127}),
          Polygon(
            points={{-38.8808,-11},{-38.8808,-15},{-34.8808,-13},{-38.8808,-11}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-39,42},{-39,38},{-35,40},{-39,42}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-38.8728,-38.0295},{-38.8728,-42.0295},{-34.8728,-40.0295},
                {-38.8728,-38.0295}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-38.9983,14.8801},{-38.9983,10.8801},{-34.9983,12.8801},{-38.9983,
                14.8801}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-30,50},{30,-50}},
            fillColor={235,235,235},
            fillPattern=FillPattern.Solid,
            lineColor={0,0,127}),
          Line(points={{100,0},{0,0}}, color={0,0,127}),
          Line(points={{0,2},{0,-104}}, color={255,128,0}),
          Line(points={{-35,40},{-20,40}}, color={0,0,127}),
          Line(points={{-35,13},{-20,13}}, color={0,0,127}),
          Line(points={{-35,-13},{-20,-13}}, color={0,0,127}),
          Line(points={{-35,-40},{-20,-40}}, color={0,0,127}),
          Polygon(points={{0,0},{-20,13},{-20,13},{0,0},{0,0}}, lineColor={0,0,
                127}),
          Ellipse(
            extent={{-6,6},{6,-6}},
            lineColor={255,128,0},
            fillColor={255,128,0},
            fillPattern=FillPattern.Solid)}));
  end Extractor;

initial algorithm
  // The control signal is dp or m_flow but the user did not provide a fan or pump curve.
  // Hence, the speed is computed using default values, which likely are wrong.
  // Therefore, scaling the power using the speed is inaccurate.
  assert(nominalValuesDefineDefaultPressureCurve or
         per.havePressureCurve or
         (preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed),
"*** Warning in " + getInstanceName() +
": Mover is flow or pressure controlled and uses default pressure curve.
This leads to an approximate power consumption.
Set nominalValuesDefineDefaultPressureCurve=true to suppress this warning.",
         level=AssertionLevel.warning);

  // The control signal is dp or m_flow but the user did not provide a fan or pump curve.
  // Hence, the speed is computed using default values, which likely are wrong.
  // In addition, the user wants to use (V_flow, P) to compute the power.
  // This can lead to using a power that is less than the flow work. We avoid
  // this by ignoring the setting of per.etaHydMet.
  // The comment is split into two parts since otherwise the JModelica C-compiler
  // throws warnings.
  assert(nominalValuesDefineDefaultPressureCurve or
         (per.havePressureCurve or
           (preVar == Buildings.Fluid.Movers.BaseClasses.Types.PrescribedVariable.Speed)) or
         per.etaHydMet<>
      Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
"*** Warning in " + getInstanceName() +
": Mover is flow or pressure controlled, uses default pressure curve and
has per.etaHydMet=.Power_VolumeFlowRate.
As this can cause wrong power consumption, the model overrides this setting by using per.etaHydMet=.NotProvided.
Set nominalValuesDefineDefaultPressureCurve=true to suppress this warning.",
         level=AssertionLevel.warning);

  assert(per.havePressureCurve or
          not (per.etaHydMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate
            or per.etaHydMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber),
"*** Warning in " + getInstanceName() +
": Mover has per.etaHydMet=.Power_VolumeFlowRate or per.etaHydMet=.EulerNumber.
This requires per.pressure to be provided.
Because it is not, the model overrides this setting by using per.etaHydMet=.NotProvided.
Also consider using models under Movers.Preconfigured which autopopulate a pressure curve.",
         level=AssertionLevel.warning);

  assert(per.havePressureCurve or per.haveWMot_nominal or
          not (per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
            or per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
"*** Warning in " + getInstanceName() +
": Mover has per.etaMotMet=.Efficiency_MotorPartLoadRatio or per.etaMotMet=.GenericCurve.
This requires per.WMot_nominal or per.pressure to be provided. Because neither is provided,
the model overrides this setting and by using per.etaMotMet=.NotProvided.
Also consider using models under Movers.Preconfigured which autopopulate a pressure curve.",
         level=AssertionLevel.warning);

  assert(per.powerOrEfficiencyIsHydraulic or
          not (per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_MotorPartLoadRatio
            or per.etaMotMet ==
               Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
"*** Warning in " + getInstanceName() +
": Mover has per.etaMotMet=.Efficiency_MotorPartLoadRatio or per.etaMotMet=.GenericCurve
and provides information for total electric power instead of hydraulic power.
This forms an algebraic loop. If simulation fails to converge,
see the \"Motor efficiency\" section in the users guide for how to correct it.",
         level=AssertionLevel.warning);

equation
  connect(prePow.port, vol.heatPort) annotation (Line(
      points={{-34,-94},{-60,-94},{-60,10},{-70,10}},
      color={191,0,0}));

  connect(vol.heatPort, heatPort) annotation (Line(
      points={{-70,10},{-70,10},{-60,10},{-60,-100}},
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

  connect(senRelPre.port_b, preSou.port_a) annotation (Line(points={{43,-20.5},{
          20,-20.5},{20,0},{40,0}},
                               color={0,127,255}));
  connect(senRelPre.port_a, preSou.port_b) annotation (Line(points={{58,-20.5},{
          80,-20.5},{80,0},{60,0}},
                               color={0,127,255}));
  connect(heaDis.V_flow,eff. V_flow) annotation (Line(points={{18,-60},{14,-60},
          {14,-52},{-11,-52}},       color={0,0,127}));
  connect(eff.PEle, heaDis.PEle) annotation (Line(points={{-11,-60},{0,-60},{0,
          -80},{18,-80}}, color={0,0,127}));
  connect(eff.WFlo, heaDis.WFlo) annotation (Line(points={{-11,-56},{4,-56},{4,
          -66},{18,-66}}, color={0,0,127}));
  connect(rho_inlet.y,eff. rho) annotation (Line(points={{-69,-64},{-69,-64},{-34,
          -64}},                          color={0,0,127}));
  connect(eff.m_flow, senMasFlo.m_flow) annotation (Line(points={{-34,-54},{-34,
          -54},{-40,-54},{-40,-11}},               color={0,0,127}));
  connect(eff.WFlo, PToMed.u2) annotation (Line(points={{-11,-56},{4,-56},{4,
          -86},{48,-86}}, color={0,0,127}));
  connect(inputSwitch.y, filter.u) annotation (Line(points={{1,50},{12,50},{12,70.5},
          {18,70.5}},     color={0,0,127}));

  connect(senRelPre.p_rel, eff.dp_in) annotation (Line(points={{50.5,-26.35},{50.5,
          -38},{-18,-38},{-18,-46}},               color={0,0,127}));
  connect(eff.y_out, y_actual) annotation (Line(points={{-11,-48},{92,-48},{92,
          70},{110,70}},
                     color={0,0,127}));
  connect(port_a, vol.ports[1])
    annotation (Line(points={{-100,0},{-79,0},{-79,0}}, color={0,127,255}));
  connect(vol.ports[2], senMasFlo.port_a)
    annotation (Line(points={{-81,0},{-81,0},{-50,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, preSou.port_a)
    annotation (Line(points={{-30,0},{40,0},{40,0}}, color={0,127,255}));
  connect(eff.WHyd, heaDis.WHyd) annotation (Line(points={{-11,-58},{2,-58},{2,
          -74},{18,-74}}, color={0,0,127}));
  connect(eff.PEle, P) annotation (Line(points={{-11,-60},{0,-60},{0,-50},{90,
          -50},{90,90},{110,90}},
                             color={0,0,127}));
   annotation(Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Line(
          points={{0,70},{100,70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,90},{100,90}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible=not use_inputFilter,
          points={{0,100},{0,40}}),
        Rectangle(
          extent={{-100,16},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,58},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-50},{54,0},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,16},{36,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Text(extent={{64,106},{114,92}},
          textColor={0,0,127},
          textString="P"),
        Text(extent={{42,86},{92,72}},
          textColor={0,0,127},
          textString="y_actual"),
        Line(
          points={{0,100},{0,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          visible=use_inputFilter,
          extent={{-32,40},{34,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-32,100},{34,40}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-20,92},{22,46}},
          textColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold})}),
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
<p>
In the previous implementation, this model extends from
<a href=\"Modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>.
Now it copies much of the code instead.
This is to resolve a potential circular parameter binding that occurs when
<a href=\"Modelica://Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y\">
Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y</a>
extends from
<a href=\"Modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
The former uses the nominal flow rate provided by user to construct
the pressure curve, whilst the latter uses the user-provided pressure curve
to determine the nominal flow rate. The new implementation removes the
original declaration of nominal flow rate from
<a href=\"Modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>
and hides it (<code>protected _m_flow_nominal</code>) from the user.
This way, A higher-level model (e.g.
<a href=\"Modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>),
can still provide a default but not the other way around.
See discussions in
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1705\">#1705</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 29, 2023, by Hongxiang Fu:<br/>
Removed the gain block that normalised the speed input
because it is no longer needed. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
March 1, 2023, by Hongxiang Fu:<br/>
Instead of extending
<a href=\"Modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>,
this model now has its code copied, then rewrote <code>m_flow_nominal</code>
as <code>protected _m_flow_nominal</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1705\">#1705</a>.
</li>
<li>
May 6, 2022, by Hongxiang Fu:<br/>
<ul>
<li>
Moved <code>haveVMax</code> from here to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
and <code>V_flow_max</code> from here to
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
</li>
<li>
Added <code>per.peak</code>, <code>per.totalEfficiency,</code>,
<code>per.motorEfficiency_yMot</code>to be also passed down to <code>eff.per</code>
at instantiation.
</li>
<li>
Added an <code>assert()</code> warning when the model has to make an unreliable
guess for efficiency computation using <code>.EulerNumber</code>.
</li>
<li>
Added an <code>assert()</code> warning when the model has to override
<code>per.etaMotMet</code>.
</li>
</ul>
These are for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
June 17, 2021, by Michael Wetter:<br/>
Changed implementation of the filter.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
October 25, 2019, by Jianjun Hu:<br/>
Improved icon graphics annotation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1225\">#1225</a>.
</li>
<li>
January 22, 2019, by Filip Jorissen:<br/>
Split long assert output string into two strings to avoid compiler warnings
in JModelica.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1081\">#1081</a>.
</li>
<li>
January 8, 2019, by Filip Jorissen:<br/>
Added assert for value of <code>m_flow_nominal</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/908\">#908</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredSpeed</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
November 3, 2016, by Michael Wetter:<br/>
Set start value for <code>VMachine_flow</code> to avoid a warning in
<a href=\"modelica://Buildings.Fluid.Movers.Examples.MoverContinuous\">
Buildings.Fluid.Movers.Examples.MoverContinuous</a>.
</li>
<li>
July 29, 2016, by Michael Wetter:<br/>
Made <code>Extractor</code> protected so that it can be removed later
with a backwards compatible change.
</li>
<li>
July 19, 2016, by Filip Jorissen:<br/>
Created custom implementation for extractor.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/498\">#498</a>.
</li>
<li>
June 16, 2016, by Filip Jorissen:<br/>
Switched position of mixing volume and mass flow rate sensor.
This is to have a consistent operating point tuple
of <code>dp</code> and <code>m_flow</code> when having
compressible flow.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/458\">#458</a>.
</li>
<li>
February 19, 2016, by Michael Wetter and Filip Jorissen:<br/>
Refactored model to make implementation clearer.
This model now includes code for both speed and flow prescribed models,
eliminating the need for an additional level of partial models.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
Removed the parameter <code>dynamicBalance</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/411\">#411</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">#349</a>.
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
</html>"));
end PartialFlowMachine;
