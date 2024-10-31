within Buildings.Templates.Plants.HeatPumps.Components;
model ValvesIsolation
  "Heat pump isolation valves"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (__ctrlFlow(enable=false));
  final parameter Buildings.Templates.Components.Types.Valve typ=
    Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Valve type"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Integer nHp(
    final min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_chiWat
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_valHpInlIso
    "Set to true for isolation valves at HP inlet"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_valHpOutIso
    "Set to true for isolation valves at HP outlet"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_pumChiWatPriDed(
    start=false)
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=have_chiWat));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatHp_flow_nominal[nHp](
    each final min=0,
    each start=0)
    "HW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatHp_nominal[nHp](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatHp_nominal[nHp](
    each final min=0)=fill(0, nHp)
    "Balancing valve pressure drop at design HW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatHp_flow_nominal[nHp](
    each start=0,
    each final min=0)
    "CHW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatHp_nominal[nHp]=
    dpHeaWatHp_nominal .*(mChiWatHp_flow_nominal ./ mHeaWatHp_flow_nominal) .^ 2
    "Pressure drop at design CHW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatHp_nominal[nHp](
    each final min=0,
    each start=0)=fill(0, nHp)
    "Balancing valve pressure drop at design CHW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  parameter Modelica.Units.SI.PressureDifference dpValveHeaWat_nominal[nHp]=
    fill(Buildings.Templates.Data.Defaults.dpValIso, nHp)
    "HW isolation valve pressure drop (identical for inlet and outlet valves)"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpFixedHeaWat_nominal[nHp]=
    dpHeaWatHp_nominal + dpBalHeaWatHp_nominal
    "Fixed HW pressure drop: HP + balancing valve"
    annotation (Dialog(group="Nominal condition"));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal[nHp]=
    dpFixedHeaWat_nominal +
    (if have_valHpOutIso then dpValveHeaWat_nominal else fill(0, nHp)) +
    (if have_valHpInlIso then dpValveHeaWat_nominal else fill(0, nHp))
    "Total HW pressure drop: fixed + valves"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValveChiWat_nominal[nHp](
    each start=0)=fill(Buildings.Templates.Data.Defaults.dpValIso, nHp)
    "Isolation valve CHW pressure drop (identical for inlet and outlet valves)"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  final parameter Modelica.Units.SI.PressureDifference dpFixedChiWat_nominal[nHp]=
    if have_chiWat then dpBalChiWatHp_nominal + dpChiWatHp_nominal else fill(0, nHp)
    "Total fixed CHW pressure drop"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal[nHp]=
    if have_chiWat then dpFixedChiWat_nominal +
      (if have_valHpOutIso then dpValveChiWat_nominal else fill(0, nHp)) +
      (if have_valHpInlIso then dpValveChiWat_nominal else fill(0, nHp))
    else fill(0, nHp)
    "Total CHW pressure drop: fixed + valves"
    annotation (Dialog(group="Nominal condition",
      enable=have_chiWat));
  final parameter Buildings.Templates.Components.Data.Valve datValHeaWatHpOutIso[nHp](
    each typ=typ,
    m_flow_nominal=mHeaWatHp_flow_nominal,
    dpValve_nominal=dpValveHeaWat_nominal,
    dpFixed_nominal=dpFixedHeaWat_nominal)
    "Heat pump outlet HW isolation valve parameters"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  // dpFixed_nominal only applied to inlet valves if there is no outlet valve.
  final parameter Buildings.Templates.Components.Data.Valve datValHeaWatHpInlIso[nHp](
    each typ=typ,
    m_flow_nominal=mHeaWatHp_flow_nominal,
    dpValve_nominal=dpValveHeaWat_nominal,
    dpFixed_nominal=if not have_valHpOutIso then dpFixedHeaWat_nominal else fill(0, nHp))
    "Heat pump inlet HW isolation valve parameters"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatHpOutIso[nHp](
    each typ=typ,
    m_flow_nominal=mChiWatHp_flow_nominal,
    dpValve_nominal=dpValveChiWat_nominal,
    dpFixed_nominal=dpFixedChiWat_nominal)
    "Heat pump outlet CHW isolation valve parameters"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  // dpFixed_nominal only applied to inlet valves if there is no outlet valve.
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatHpInlIso[nHp](
    each typ=typ,
    m_flow_nominal=mChiWatHp_flow_nominal,
    dpValve_nominal=dpValveChiWat_nominal,
    dpFixed_nominal=if not have_valHpOutIso then dpFixedChiWat_nominal else fill(0, nHp))
    "Heat pump inlet CHW isolation valve parameters"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
    __ctrlFlow(enable=false));
  parameter Boolean allowFlowReversal=true
    "Set to false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Boolean use_strokeTime=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState
    "Set to true to continuously open and close valve"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=have_valHpInlIso or have_valHpOutIso));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to open or close valve"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and have_valHpInlIso or have_valHpOutIso));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and have_valHpInlIso or have_valHpOutIso));
  parameter Real y_start=1
    "Initial position of actuator"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and have_valHpInlIso or have_valHpOutIso));
  parameter Boolean from_dp=true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true,
    Dialog(tab="Advanced",
      enable=have_valHpInlIso or have_valHpOutIso));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Evaluate=true,
    Dialog(tab="Advanced",
      enable=have_valHpInlIso or have_valHpOutIso));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if have_chiWat
    "CHW supply (to primary loop)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2400,600})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if have_chiWat
    "CHW return (from primary loop)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2400,200})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "HW supply (to primary loop)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2400,0})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "HW return (from primary loop)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2400,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "CHW/HW return (HP entering)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={100,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={500,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if not have_pumChiWatPriDed
    "CHW/HW supply (HP leaving)"
    annotation (Placement(transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-100,-200}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-500,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if have_pumChiWatPriDed
    "HW supply (HP leaving)"
    annotation (Placement(transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-180,-200}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-660,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if have_pumChiWatPriDed
    "CHW supply (HP leaving)"
    annotation (Placement(transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-20,-200}), iconTransformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-340,-700})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatHpOutIso[nHp](
    redeclare each final package Medium=Medium,
    final dat=datValHeaWatHpOutIso,
    each final typ=typ,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_valHpOutIso
    "HP outlet HW isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-180,0})));
  Buildings.Templates.Components.Actuators.Valve valChiWatHpOutIso[nHp](
    redeclare each final package Medium=Medium,
    final dat=datValChiWatHpOutIso,
    each final typ=typ,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_valHpOutIso and have_chiWat
    "HP outlet CHW isolation valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-100,0})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatHpInlIso[nHp](
    redeclare each final package Medium=Medium,
    final dat=datValHeaWatHpInlIso,
    each final typ=typ,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_valHpInlIso
    "HP inlet HW isolation valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={100,0})));
  Buildings.Templates.Components.Actuators.Valve valChiWatHpInlIso[nHp](
    redeclare each final package Medium=Medium,
    final dat=datValChiWatHpInlIso,
    each final typ=typ,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_valHpInlIso and have_chiWat
    "HP inlet CHW isolation valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={180,0})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasHeaWatHpOut[nHp](
    redeclare each final package Medium=Medium)
    if not have_valHpOutIso
    "Direct fluid pass-through"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-160,0})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasChiWatHpOut[nHp](
    redeclare each final package Medium=Medium)
    if not have_valHpOutIso and have_chiWat
    "Direct fluid pass-through"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-80,0})));
  Fluid.Delays.DelayFirstOrder junHeaWatSup(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mHeaWatHp_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1)
    "Fluid volume at junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-160,120})));
  Fluid.Delays.DelayFirstOrder junChiWatSup(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mChiWatHp_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1)
    if have_chiWat
    "Fluid volume at junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-80,120})));
  Fluid.Delays.DelayFirstOrder junHeaWatRet(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mHeaWatHp_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1)
    "Fluid volume at junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={80,120})));
  /*
  HW pressure drop computed in this component in the absence of isolation valves
  at both inlet and outlet.
  */
    Fluid.FixedResistances.PressureDrop pasHeaWatHpInl[nHp](
    redeclare each final package Medium=Medium,
    final m_flow_nominal=mHeaWatHp_flow_nominal,
    final dp_nominal=if not have_valHpInlIso and not have_valHpOutIso then dpFixedHeaWat_nominal
      else fill(0, nHp))
    if not have_valHpInlIso
    "Direct fluid pass-through with optional fluid resistance"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={80,0})));
  /*
  CHW pressure drop computed in this component in the absence of isolation valves
  at both inlet and outlet.
  */
    Fluid.FixedResistances.PressureDrop pasChiWatHpInl[nHp](
    redeclare each final package Medium=Medium,
    final m_flow_nominal=mChiWatHp_flow_nominal,
    final dp_nominal=if not have_valHpInlIso and not have_valHpOutIso then dpFixedChiWat_nominal
      else fill(0, nHp))
    if not have_valHpInlIso and have_chiWat
    "Direct fluid pass-through with optional fluid resistance"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={160,0})));
  Fluid.Delays.DelayFirstOrder junChiWatRet(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mChiWatHp_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1)
    if have_chiWat
    "Fluid volume at junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={160,120})));
protected
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[nHp]
    if have_valHpInlIso
    "Heat pump inlet HW isolation valve control bus"
    annotation (Placement(transformation(extent={{40,140},{80,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[nHp]
    if have_valHpOutIso
    "Heat pump outlet HW isolation valve control bus"
    annotation (Placement(transformation(extent={{-80,140},{-40,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[nHp]
    if have_chiWat and have_valHpInlIso
    "Heat pump inlet CHW isolation valve control bus"
    annotation (Placement(transformation(extent={{10,160},{50,200}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[nHp]
    if have_chiWat and have_valHpOutIso
    "Heat pump outlet CHW isolation valve control bus"
    annotation (Placement(transformation(extent={{-50,160},{-10,200}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(bus.valHeaWatHpInlIso, busValHeaWatHpInlIso)
    annotation (Line(points={{0,200},{0,160},{60,160}},color={255,204,51},thickness=0.5));
  connect(bus.valHeaWatHpOutIso, busValHeaWatHpOutIso)
    annotation (Line(points={{0,200},{0,160},{-60,160}},color={255,204,51},thickness=0.5));
  connect(bus.valChiWatHpInlIso, busValChiWatHpInlIso)
    annotation (Line(points={{0,200},{0,180},{30,180}},color={255,204,51},thickness=0.5));
  connect(bus.valChiWatHpOutIso, busValChiWatHpOutIso)
    annotation (Line(points={{0,200},{0,180},{-30,180}},color={255,204,51},thickness=0.5));
  connect(ports_aHeaWatHp, valHeaWatHpOutIso.port_a)
    annotation (Line(points={{-180,-200},{-180,-10}},color={0,127,255}));
  connect(ports_aChiHeaWatHp, valHeaWatHpOutIso.port_a)
    annotation (Line(points={{-100,-200},{-120,-200},{-120,-20},{-180,-20},{
          -180,-10}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, valChiWatHpOutIso.port_a)
    annotation (Line(points={{-100,-200},{-100,-200},{-100,-10}},color={0,127,255}));
  connect(ports_aChiWatHp, valChiWatHpOutIso.port_a)
    annotation (Line(points={{-20,-200},{-20,-20},{-100,-20},{-100,-10}},  color={0,127,255}));
  connect(ports_aHeaWatHp, pasHeaWatHpOut.port_a)
    annotation (Line(points={{-180,-200},{-160,-200},{-160,-10}},          color={0,127,255}));
  connect(ports_aChiHeaWatHp, pasHeaWatHpOut.port_a)
    annotation (Line(points={{-100,-200},{-120,-200},{-120,-20},{-160,-20},{-160,
          -10}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, pasChiWatHpOut.port_a)
    annotation (Line(points={{-100,-200},{-80,-200},{-80,-10}},          color={0,127,255}));
  connect(ports_aChiWatHp, pasChiWatHpOut.port_a)
    annotation (Line(points={{-20,-200},{-20,-20},{-80,-20},{-80,-10}},
      color={0,127,255}));
  connect(valHeaWatHpOutIso.port_b, junHeaWatSup.ports[1:nHp])
    annotation (Line(points={{-180,10},{-180,20},{-160,20},{-160,110}},
                                                                      color={0,127,255}));
  connect(pasHeaWatHpOut.port_b, junHeaWatSup.ports[1:nHp])
    annotation (Line(points={{-160,10},{-160,110}},
                                                  color={0,127,255}));
  connect(junHeaWatSup.ports[nHp + 1], port_bHeaWat)
    annotation (Line(points={{-160,110},{-180,110},{-180,200}},
                                                             color={0,127,255}));
  connect(valChiWatHpOutIso.port_b, junChiWatSup.ports[1:nHp])
    annotation (Line(points={{-100,10},{-100,20},{-80,20},{-80,110}},
                                                                    color={0,127,255}));
  connect(pasChiWatHpOut.port_b, junChiWatSup.ports[1:nHp])
    annotation (Line(points={{-80,10},{-80,110}},        color={0,127,255}));
  connect(port_bChiWat, junChiWatSup.ports[nHp + 1])
    annotation (Line(points={{-100,200},{-100,110},{-80,110}},
                                                            color={0,127,255}));
  connect(port_aHeaWat, junHeaWatRet.ports[nHp + 1])
    annotation (Line(points={{100,200},{100,110},{80,110}},
                                                         color={0,127,255}));
  connect(junHeaWatRet.ports[1:nHp], valHeaWatHpInlIso.port_a)
    annotation (Line(points={{80,110},{80,20},{100,20},{100,10}},
                                                                color={0,127,255}));
  connect(pasHeaWatHpInl.port_a, junHeaWatRet.ports[1:nHp])
    annotation (Line(points={{80,10},{80,110}},               color={0,127,255}));
  connect(port_aChiWat, junChiWatRet.ports[nHp + 1])
    annotation (Line(points={{180,200},{180,110},{160,110}},
                                                          color={0,127,255}));
  connect(valChiWatHpInlIso.port_a, junChiWatRet.ports[1:nHp])
    annotation (Line(points={{180,10},{180,20},{160,20},{160,110}},
                                                                  color={0,127,255}));
  connect(pasChiWatHpInl.port_a, junChiWatRet.ports[1:nHp])
    annotation (Line(points={{160,10},{160,110}},                 color={0,127,255}));
  connect(pasHeaWatHpInl.port_b, ports_bChiHeaWatHp)
    annotation (Line(points={{80,-10},{80,-200},{100,-200}},         color={0,127,255}));
  connect(pasChiWatHpInl.port_b, ports_bChiHeaWatHp)
    annotation (Line(points={{160,-10},{160,-180},{100,-180},{100,-200}},color={0,127,255}));
  connect(busValHeaWatHpInlIso, valHeaWatHpInlIso.bus)
    annotation (Line(points={{60,160},{110,160},{110,0}},color={255,204,51},thickness=0.5));
  connect(busValChiWatHpInlIso, valChiWatHpInlIso.bus)
    annotation (Line(points={{30,180},{190,180},{190,0}},color={255,204,51},thickness=0.5));
  connect(busValChiWatHpOutIso, valChiWatHpOutIso.bus)
    annotation (Line(points={{-30,180},{-110,180},{-110,0}},color={255,204,51},thickness=0.5));
  connect(busValHeaWatHpOutIso, valHeaWatHpOutIso.bus)
    annotation (Line(points={{-60,160},{-190,160},{-190,0}},color={255,204,51},thickness=0.5));

  connect(valHeaWatHpInlIso.port_b, ports_bChiHeaWatHp) annotation (Line(points
        ={{100,-10},{100,-10},{100,-200}}, color={0,127,255}));
  connect(valChiWatHpInlIso.port_b, ports_bChiHeaWatHp) annotation (Line(points
        ={{180,-10},{180,-180},{100,-180},{100,-200}}, color={0,127,255}));
  annotation (
    defaultComponentName="valIso",
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-2400,-700},{2400,700}}), graphics={
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 1,
          origin={1950,-400},
          rotation=90),
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 2,
          origin={1150,-400},
          rotation=90),
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 3,
          origin={350,-400},
          rotation=90),
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 4,
          origin={-450,-400},
          rotation=90),
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 5,
          origin={-1250,-400},
          rotation=90),
        Line(
          points={{240,150},{0,150},{0,-50}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 6,
          origin={-2050,-400},
          rotation=90),
        Line(
          points={{1000,-160},{1000,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 2),
        Line(
          points={{200,-160},{200,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 3),
        Line(
          points={{-600,-160},{-600,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 4),
        Line(
          points={{-1400,-160},{-1400,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 5),
        Line(
          points={{-2200,-160},{-2200,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 6),
        Line(
          points={{1800,-160},{1800,-700}},
          color={0,0,0},
          thickness=5,
          visible=have_pumChiWatPriDed and nHp >= 1),
        Line(
          points={{2400,200},{2400,-400},{2200,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 1),
        Line(
          points={{1800,-160},{1800,600},{2400,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 1),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 1,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={1800,-200}),
    Line( points={{-2400,400},{2200,400},{2200,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 1),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 1,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={2200,-200}),
    Bitmap(
          visible=have_chiWat and nHp >= 1 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={2400,-200}),
    Line( visible=have_chiWat and nHp >= 1 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={2370,-200},
          rotation=-90),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 1 and have_valHpInlIso,
          extent={{2260,-240},{2340,-160}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
                                 Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 1,
          extent={{2060,-240},{2140,-160}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 1,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={2170,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 1,
          extent={{1860,-240},{1940,-160}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 1,
          extent={{1660,-240},{1740,-160}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 1,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={1770,-200},
          rotation=-90),
   Rectangle(
          extent={{1780,20},{1820,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 1),
        Line(
          points={{1000,-160},{1000,600},{1800,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 2),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 2,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={1000,-200}),
    Line( points={{1400,400},{1400,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 2),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 2,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={1400,-200}),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 2 and have_valHpInlIso,
          extent={{1460,-240},{1540,-160}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
                                 Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 2,
          extent={{1260,-240},{1340,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 2,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={1370,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 2,
          extent={{1060,-240},{1140,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 2,
          extent={{860,-240},{940,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 2,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={970,-200},
          rotation=-90),
   Rectangle(
          extent={{980,20},{1020,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 2),
   Line(  points={{1200,4},{1200,-696}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 2),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 2,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={1200,-200}),
    Line( visible=have_valHpOutIso and nHp >= 2,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={1170,-200},
          rotation=-90),
        Line(
          points={{200,-160},{200,600},{1000,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 3),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 3,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={200,-200}),
    Line( points={{600,400},{600,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 3),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 3,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={600,-200}),    Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 3,
          extent={{460,-240},{540,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 3,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={570,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 3,
          extent={{260,-240},{340,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 3,
          extent={{60,-240},{140,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 3,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={170,-200},
          rotation=-90),
   Rectangle(
          extent={{180,20},{220,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 3),
   Line(  points={{400,0},{400,-700}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 3),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 3,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={400,-200}),
    Line( visible=have_valHpOutIso and nHp >= 3,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={370,-200},
          rotation=-90),
        Line(
          points={{-600,-160},{-600,600},{200,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 4),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 4,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-600,-200}),
    Line( points={{-200,400},{-200,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 4),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 4,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,-200}),   Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 4,
          extent={{-340,-240},{-260,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 4,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-230,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 4,
          extent={{-540,-240},{-460,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 4,
          extent={{-740,-240},{-660,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 4,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-630,-200},
          rotation=-90),
   Rectangle(
          extent={{-620,20},{-580,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 4),
   Line(  points={{-400,0},{-400,-700}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 4),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 4,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-400,-200}),
    Line( visible=have_valHpOutIso and nHp >= 4,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-430,-200},
          rotation=-90),
        Line(
          points={{-1400,-160},{-1400,600},{-600,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 5),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 5,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-1400,-200}),
    Line( points={{-1000,400},{-1000,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 5),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 5,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-1000,-200}),  Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 5,
          extent={{-1140,-240},{-1060,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 5,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-1030,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 5,
          extent={{-1340,-240},{-1260,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 5,
          extent={{-1540,-240},{-1460,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 5,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-1430,-200},
          rotation=-90),
   Rectangle(
          extent={{-1420,20},{-1380,-20}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 5),
   Line(  points={{-1200,0},{-1200,-700}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 5),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 5,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-1200,-200}),
    Line( visible=have_valHpOutIso and nHp >= 5,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-1230,-200},
          rotation=-90),
        Line(
          points={{-2200,-160},{-2200,600},{-1400,600}},
          color={0,0,0},
          thickness=5,
          visible=have_chiWat and nHp >= 6),
    Bitmap(
          visible=have_chiWat and have_valHpOutIso and nHp >= 6,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-2200,-200}),
    Line( points={{-1800,400},{-1800,-700}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nHp >= 6),
    Bitmap(
          visible=have_valHpInlIso and nHp >= 6,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-1800,-200}),  Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpInlIso and nHp >= 6,
          extent={{-1940,-240},{-1860,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_valHpInlIso and nHp >= 6,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-1830,-200},
          rotation=-90),         Bitmap(
          visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_valHpOutIso and nHp >= 6,
          extent={{-2140,-240},{-2060,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and have_valHpOutIso and nHp >= 6,
          extent={{-2340,-240},{-2260,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line( visible=have_chiWat and have_valHpOutIso and nHp >= 6,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-2230,-200},
          rotation=-90),
   Rectangle(
          extent={{-2220,20},{-2180,-22}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 6),
   Line(  points={{-2000,0},{-2000,-700}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 6),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 6,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-2000,-200}),
    Line( visible=have_valHpOutIso and nHp >= 6,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-2030,-200},
          rotation=-90),
   Line(  points={{-2400,0},{2000,0},{2000,-700}},
          color={0,0,0},
          thickness=5,
          visible=nHp >= 1),
    Bitmap(
          visible=have_valHpOutIso and nHp >= 1,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={2000,-200}),
    Line( visible=have_valHpOutIso and nHp >= 1,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={1970,-200},
          rotation=-90),
        Line(points={{1820,-508}}, color={0,0,0}),
   Rectangle(
          extent={{2180,220},{2220,178}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 2),
        Line(
          points={{2400,200},{1600,200},{1600,-400},{1400,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 2),
    Bitmap(
          visible=have_chiWat and nHp >= 2 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={1600,-200}),
    Line( visible=have_chiWat and nHp >= 2 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={1570,-200},
          rotation=-90),
   Rectangle(
          extent={{1380,220},{1420,178}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 3),
        Line(
          points={{1600,200},{800,200},{800,-400},{600,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 3),
    Bitmap(
          visible=have_chiWat and nHp >= 3 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={800,-200}),
    Line( visible=have_chiWat and nHp >= 3 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={770,-200},
          rotation=-90),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 3 and have_valHpInlIso,
          extent={{660,-240},{740,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
   Rectangle(
          extent={{580,220},{620,180}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 4),
   Rectangle(
          extent={{-220,220},{-180,180}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 5),
   Rectangle(
          extent={{-1020,220},{-980,180}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=have_chiWat and nHp >= 6),
        Line(
          points={{800,200},{0,200},{0,-400},{-200,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 4),
    Bitmap(
          visible=have_chiWat and nHp >= 4 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={0,-200}),
    Line( visible=have_chiWat and nHp >= 4 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-30,-200},
          rotation=-90),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 4 and have_valHpInlIso,
          extent={{-140,-240},{-60,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
        Line(
          points={{0,200},{-800,200},{-800,-400},{-1000,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 5),
    Bitmap(
          visible=have_chiWat and nHp >= 5 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-800,-200}),
    Line( visible=have_chiWat and nHp >= 5 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-830,-200},
          rotation=-90),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 5 and have_valHpInlIso,
          extent={{-940,-240},{-860,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
        Line(
          points={{-800,200},{-1600,200},{-1600,-400},{-1800,-400}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_chiWat and nHp >= 6),
    Bitmap(
          visible=have_chiWat and nHp >= 6 and have_valHpInlIso,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-1600,-200}),
    Line( visible=have_chiWat and nHp >= 6 and have_valHpInlIso,
          points={{0,30},{0,-30}},
          color={0,0,0},
          origin={-1630,-200},
          rotation=-90),
   Bitmap(visible=typ == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
               and have_chiWat and nHp >= 6 and have_valHpInlIso,
          extent={{-1740,-240},{-1660,-160}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg")}),
    Documentation(
      info="<html>
<p>
This model represents the heat pump isolation valves.
The isolation valves are modeled as two-way two-position
valves, which can be located at the heat pump inlet and/or
outlet depending on the settings of the parameters <code>have_valHpInlIso</code>
and <code>have_valHpOutIso</code>.
It is assumed that the heat pumps always provide heating hot water.
Optionally, chilled water return and supply and the associated isolation valves
can be modeled by setting the parameter <code>have_chiWat</code> to true.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValvesIsolation;
