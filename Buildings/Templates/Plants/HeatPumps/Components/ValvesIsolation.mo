within Buildings.Templates.Plants.HeatPumps.Components;
model ValvesIsolation
  "Heat pump isolation valves"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(__ctrlFlow(enable=false));

  final parameter Buildings.Templates.Components.Types.Valve typValHpInlIso =
    if have_valHpInlIso
    then Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    else Buildings.Templates.Components.Types.Valve.None
    "Valve type at HP inlet"
    annotation(Evaluate=true);
  final parameter Buildings.Templates.Components.Types.Valve typValHpOutIso =
    if have_valHpOutIso
    then Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    else Buildings.Templates.Components.Types.Valve.None
    "Valve type at HP outlet"
    annotation(Evaluate=true);
  final parameter Buildings.Templates.Components.Types.Valve typValShcInlIso =
    if have_valShcInlIso
    then Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    else Buildings.Templates.Components.Types.Valve.None
    "Valve type at SHC unit inlet"
    annotation(Evaluate=true);
  final parameter Buildings.Templates.Components.Types.Valve typValShcOutIso =
    if have_valShcOutIso
    then Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    else Buildings.Templates.Components.Types.Valve.None
    "Valve type at SHC unit outlet"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat = true
    "Set to true if the plant provides CHW"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_hp = true
    "Set to true if the plant includes SHC (4-pipe) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_shc = false
    "Set to true if the plant includes SHC (4-pipe) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nHp
    "Number of heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nShc = 0
    "Number of SHC (4-pipe) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean is_shcMod = false
    "Set to true for modular SHC unit"
    annotation(Evaluate=true);
  parameter Boolean have_valHpInlIso = false
    "Set to true for isolation valves at HP inlet"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_valHpOutIso = false
    "Set to true for isolation valves at HP outlet"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_valShcInlIso = false
    "Set to true for isolation valves at SHC unit inlet"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_valShcOutIso = false
    "Set to true for isolation valves at SHC unit outlet"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_pumChiWatPriDed = false
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatUni_flow_nominal[nHp + nShc](
    each final min=0,
    each start=0)
    "HW mass flow rate - Each unit "
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatUni_nominal[nHp +
    nShc](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpHeaWatHp)
    "Pressure drop at design HW mass flow rate - Each unit"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatUni_nominal[nHp +
    nShc](each final min=0) = fill(0, nHp + nShc)
    "Balancing valve pressure drop at design HW mass flow rate - Each unit"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatUni_flow_nominal[nHp + nShc](
    each final min=0,
    each start=0)
    "CHW mass flow rate - Each unit"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatUni_nominal[nHp +
    nShc] =
    dpHeaWatUni_nominal .*
      (mChiWatUni_flow_nominal ./ mHeaWatUni_flow_nominal) .^ 2
    "Pressure drop at design CHW mass flow rate - Each unit"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatUni_nominal[nHp +
    nShc](each final min=0, each start=0) = fill(0, nHp + nShc)
    "Balancing valve pressure drop at design CHW mass flow rate - Each unit"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  parameter Modelica.Units.SI.PressureDifference dpValveHeaWat_nominal[nHp +
    nShc] = fill(Buildings.Templates.Data.Defaults.dpValIso, nHp + nShc)
    "HW isolation valve pressure drop (identical for inlet and outlet valves)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpFixedHeaWat_nominal[nHp +
    nShc] = dpHeaWatUni_nominal + dpBalHeaWatUni_nominal
    "Fixed HW pressure drop: HP + balancing valve"
    annotation(Dialog(group="Nominal condition"));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal[nHp +
    nShc] =
    dpFixedHeaWat_nominal + (if have_shc
      then cat(
          1,
          if have_valHpOutIso
            then dpValveHeaWat_nominal[1:nHp] else fill(0, nHp),
          if have_valShcOutIso
            then dpValveHeaWat_nominal[nHp + 1:nHp + nShc] else fill(0, nShc)) +
        cat(
          1,
          if have_valHpInlIso
            then dpValveHeaWat_nominal[1:nHp] else fill(0, nHp),
          if have_valShcInlIso
            then dpValveHeaWat_nominal[nHp + 1:nHp + nShc] else fill(0, nShc))
      else (if have_valHpOutIso then dpValveHeaWat_nominal else fill(0, nHp)) +
        (if have_valHpInlIso then dpValveHeaWat_nominal else fill(0, nHp)))
    "Total HW pressure drop: fixed + valves"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValveChiWat_nominal[nHp +
    nShc](each final min=0, each start=0) =
    fill(Buildings.Templates.Data.Defaults.dpValIso, nHp + nShc)
    "Isolation valve CHW pressure drop (identical for inlet and outlet valves)"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  final parameter Modelica.Units.SI.PressureDifference dpFixedChiWat_nominal[nHp +
    nShc] =
    if have_chiWat
    then dpBalChiWatUni_nominal + dpChiWatUni_nominal else fill(0, nHp + nShc)
    "Total fixed CHW pressure drop"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal[nHp +
    nShc] =
    if have_chiWat
    then dpFixedChiWat_nominal + (if have_shc
      then cat(
          1,
          if have_valHpOutIso
            then dpValveChiWat_nominal[1:nHp] else fill(0, nHp),
          if have_valShcOutIso
            then dpValveChiWat_nominal[nHp + 1:nHp + nShc] else fill(0, nShc)) +
        cat(
          1,
          if have_valHpInlIso
            then dpValveChiWat_nominal[1:nHp] else fill(0, nHp),
          if have_valShcInlIso
            then dpValveChiWat_nominal[nHp + 1:nHp + nShc] else fill(0, nShc))
      else (if have_valHpOutIso then dpValveChiWat_nominal else fill(0, nHp)) +
        (if have_valHpInlIso then dpValveChiWat_nominal else fill(0, nHp)))
    else fill(0, nHp)
    "Total CHW pressure drop: fixed + valves"
    annotation(Dialog(group="Nominal condition",
      enable=have_chiWat));
  // We include the fixed resistance prioritarily where isolation valves are used.
  // If no isolation valves are used, the fixed resistance is included at outlet.
  final parameter Buildings.Templates.Components.Data.Valve datValHeaWatUniOutIso[nHp +
    nShc](
    typ=cat(1, fill(typValHpOutIso, nHp), fill(typValShcOutIso, nShc)),
    m_flow_nominal=mHeaWatUni_flow_nominal,
    dpValve_nominal=dpValveHeaWat_nominal,
    dpFixed_nominal=if have_valHpOutIso
      or not have_valHpOutIso and not have_valHpInlIso
      then dpFixedHeaWat_nominal else fill(0, nHp + nShc))
    "Unit outlet HW isolation valve parameters"
    annotation(Placement(transformation(extent={{-10,0},{10,20}})));
  final parameter Buildings.Templates.Components.Data.Valve datValHeaWatUniInlIso[nHp +
    nShc](
    typ=cat(1, fill(typValHpInlIso, nHp), fill(typValShcInlIso, nShc)),
    m_flow_nominal=mHeaWatUni_flow_nominal,
    dpValve_nominal=dpValveHeaWat_nominal,
    dpFixed_nominal=if not have_valHpOutIso and have_valHpInlIso
      then dpFixedHeaWat_nominal else fill(0, nHp + nShc))
    "Unit inlet HW isolation valve parameters"
    annotation(Placement(transformation(extent={{-10,30},{10,50}})));
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatUniOutIso[nHp +
    nShc](
    typ=cat(1, fill(typValHpOutIso, nHp), fill(typValShcOutIso, nShc)),
    m_flow_nominal=mChiWatUni_flow_nominal,
    dpValve_nominal=dpValveChiWat_nominal,
    dpFixed_nominal=if have_valHpOutIso
      or not have_valHpOutIso and not have_valHpInlIso
      then dpFixedChiWat_nominal else fill(0, nHp + nShc))
    "Unit outlet CHW isolation valve parameters"
    annotation(Placement(transformation(extent={{-10,-30},{10,-10}})));
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatUniInlIso[nHp +
    nShc](
    typ=cat(1, fill(typValHpInlIso, nHp), fill(typValShcInlIso, nShc)),
    m_flow_nominal=mChiWatUni_flow_nominal,
    dpValve_nominal=dpValveChiWat_nominal,
    dpFixed_nominal=if not have_valHpOutIso and have_valHpInlIso
      then dpFixedChiWat_nominal else fill(0, nHp + nShc))
    "Heat pump inlet CHW isolation valve parameters"
    annotation(Placement(transformation(extent={{-10,-60},{10,-40}})));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Modelica.Units.SI.Time tau = 10
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState),
      __ctrlFlow(enable=false));
  parameter Boolean allowFlowReversal = true
    "Set to false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"),
      Evaluate=true);
  parameter Boolean use_strokeTime =
    energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState
    "Set to true to continuously open and close valve"
    annotation(__ctrlFlow(enable=false),
      Dialog(tab="Dynamics",
        group="Time needed to open or close valve",
        enable=have_valHpInlIso or have_valHpOutIso));
  parameter Modelica.Units.SI.Time strokeTime = 120
    "Time needed to open or close valve"
    annotation(__ctrlFlow(enable=false),
      Dialog(tab="Dynamics",
        group="Time needed to open or close valve",
        enable=use_strokeTime and (have_valHpInlIso or have_valHpOutIso)));
  parameter Modelica.Blocks.Types.Init init =
    Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(__ctrlFlow(enable=false),
      Dialog(tab="Dynamics",
        group="Time needed to open or close valve",
        enable=use_strokeTime and (have_valHpInlIso or have_valHpOutIso)));
  parameter Real y_start = 1
    "Initial position of actuator"
    annotation(__ctrlFlow(enable=false),
      Dialog(tab="Dynamics",
        group="Time needed to open or close valve",
        enable=use_strokeTime and (have_valHpInlIso or have_valHpOutIso)));
  parameter Boolean from_dp = true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation(Evaluate=true,
      Dialog(tab="Advanced",
        enable=have_valHpInlIso or have_valHpOutIso));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true,
      Dialog(tab="Advanced",
        enable=have_valHpInlIso or have_valHpOutIso));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium=Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_chiWat
    "CHW supply (to primary loop)"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-100,200}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2400,600})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_chiWat
    "CHW return (from primary loop)"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={180,200}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2400,200})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium=Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW supply (to primary loop)"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-180,200}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2400,0})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "HW return (from primary loop)"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={100,200}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2400,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
    "CHW/HW return – HP entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={40,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={660,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp and not have_pumChiWatPriDed
    "CHW/HW supply – HP leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-140,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-440,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp and have_pumChiWatPriDed
    "HW supply – HP leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-180,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-760,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp and have_pumChiWatPriDed
    "CHW supply – HP leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-100,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-600,-700})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{-20,180},{20,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatUniOutIso[nHp + nShc](
    redeclare each final package Medium=Medium,
    final dat=datValHeaWatUniOutIso,
    final typ=cat(1, fill(typValHpOutIso, nHp), fill(typValShcOutIso, nShc)),
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    "Unit outlet HW isolation valve"
    annotation(Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=90,
      origin={-160,0})));
  Buildings.Templates.Components.Actuators.Valve valChiWatUniOutIso[nHp + nShc](
    redeclare each final package Medium=Medium,
    final dat=datValChiWatUniOutIso,
    final typ=cat(1, fill(typValHpOutIso, nHp), fill(typValShcOutIso, nShc)),
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_chiWat
    "Unit outlet CHW isolation valve"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-80,0})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatUniInlIso[nHp + nShc](
    redeclare each final package Medium=Medium,
    final dat=datValHeaWatUniInlIso,
    final typ=cat(1, fill(typValHpInlIso, nHp), fill(typValShcInlIso, nShc)),
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    "Unit inlet HW isolation valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,0})));
  Buildings.Templates.Components.Actuators.Valve valChiWatUniInlIso[nHp + nShc](
    redeclare each final package Medium=Medium,
    final dat=datValChiWatUniInlIso,
    final typ=cat(1, fill(typValHpInlIso, nHp), fill(typValShcInlIso, nShc)),
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if have_chiWat
    "Unit inlet CHW isolation valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={160,0})));
  Fluid.Delays.DelayFirstOrder junHeaWatSup(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mHeaWatUni_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1 + (if have_shc then nShc else 0))
    "Fluid volume at junction"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-160,70})));
  Fluid.Delays.DelayFirstOrder junChiWatSup(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mChiWatUni_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1 + (if have_shc then nShc else 0))
    if have_chiWat
    "Fluid volume at junction"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-80,70})));
  Fluid.Delays.DelayFirstOrder junHeaWatRet(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mHeaWatUni_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1 + (if have_shc then nShc else 0))
    "Fluid volume at junction"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={80,70})));
  Fluid.Delays.DelayFirstOrder junChiWatRet(
    redeclare final package Medium=Medium,
    final tau=tau,
    final m_flow_nominal=sum(mChiWatUni_flow_nominal),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final prescribedHeatFlowRate=false,
    final nPorts=nHp + 1 + (if have_shc then nShc else 0))
    if have_chiWat
    "Fluid volume at junction"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={160,70})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWatShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "CHW return – SHC unit entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={160,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={340,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWatShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW return – SHC unit entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={100,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={500,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWatShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW supply – SHC unit leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-60,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-280,-700})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWatShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "CHW supply – SHC unit leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-20,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-120,-700})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpInlIso[nHp]
    if have_valHpInlIso
    "HP inlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{20,100},{60,140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatHpOutIso[nHp]
    if have_valHpOutIso
    "HP outlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-60,100},{-20,140}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpInlIso[nHp]
    if have_chiWat and have_valHpInlIso
    "Heat pump inlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{20,160},{60,200}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatHpOutIso[nHp]
    if have_chiWat and have_valHpOutIso
    "Heat pump outlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-60,160},{-20,200}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatShcOutIso[nShc]
    if have_shc and have_valShcOutIso
    "SHC unit outlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{-60,80},{-20,120}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatShcOutIso[nShc]
    if have_shc and have_valShcOutIso
    "SHC unit outlet CHW isolation valve control bus"
    annotation(Placement(transformation(extent={{-60,140},{-20,180}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busValHeaWatShcInlIso[nShc]
    if have_shc and have_valShcInlIso
    "SHC unit inlet HW isolation valve control bus"
    annotation(Placement(transformation(extent={{20,80},{60,120}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatShcInlIso[nShc]
    if have_shc and have_valShcInlIso
    "SHC unit inlet CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{20,140},{60,180}}), iconTransformation(extent={
            {-466,50},{-426,90}})));
equation
  connect(bus.valHeaWatHpInlIso, busValHeaWatHpInlIso)
    annotation(Line(points={{0,200},{0,120},{40,120}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valHeaWatHpOutIso, busValHeaWatHpOutIso)
    annotation(Line(points={{0,200},{0,120},{-40,120}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valChiWatHpInlIso, busValChiWatHpInlIso)
    annotation(Line(points={{0,200},{0,180},{40,180}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valChiWatHpOutIso, busValChiWatHpOutIso)
    annotation(Line(points={{0,200},{0,180},{-40,180}},
      color={255,204,51},
      thickness=0.5));
  connect(valHeaWatUniOutIso.port_b, junHeaWatSup.ports[1:nHp + nShc])
    annotation(Line(points={{-160,10},{-160,60}},
      color={0,127,255}));
  connect(junHeaWatSup.ports[nHp + nShc + 1], port_bHeaWat)
    annotation(Line(points={{-160,60},{-180,60},{-180,200}},
      color={0,127,255}));
  connect(valChiWatUniOutIso.port_b, junChiWatSup.ports[1:nHp + nShc])
    annotation(Line(points={{-80,10},{-80,60}},
      color={0,127,255}));
  connect(port_bChiWat, junChiWatSup.ports[nHp + nShc + 1])
    annotation(Line(points={{-100,200},{-100,60},{-80,60}},
      color={0,127,255}));
  connect(port_aHeaWat, junHeaWatRet.ports[nHp + nShc + 1])
    annotation(Line(points={{100,200},{100,60},{80,60}},
      color={0,127,255}));
  connect(port_aChiWat, junChiWatRet.ports[nHp + nShc + 1])
    annotation(Line(points={{180,200},{180,60},{160,60}},
      color={0,127,255}));
  connect(junHeaWatRet.ports[1:nHp + nShc], valHeaWatUniInlIso.port_a)
    annotation(Line(points={{80,60},{80,10}},
      color={0,127,255}));
  connect(valChiWatUniInlIso.port_a, junChiWatRet.ports[1:nHp + nShc])
    annotation(Line(points={{160,10},{160,60}},
      color={0,127,255}));
  connect(valChiWatUniInlIso[nHp + 1:nHp + nShc].port_b, ports_bChiWatShc)
    annotation(Line(points={{160,-10},{160,-200}},
      color={0,127,255}));
  connect(valHeaWatUniInlIso[nHp + 1:nHp + nShc].port_b, ports_bHeaWatShc)
    annotation(Line(points={{80,-10},{80,-20},{100,-20},{100,-200}},
      color={0,127,255}));
  connect(bus.valHeaWatShcOutIso, busValHeaWatShcOutIso)
    annotation(Line(points={{0,200},{0,100},{-40,100}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valHeaWatShcInlIso, busValHeaWatShcInlIso)
    annotation(Line(points={{0,200},{0,100},{40,100}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valChiWatShcOutIso, busValChiWatShcOutIso)
    annotation(Line(points={{0,200},{0,160},{-40,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valChiWatShcInlIso, busValChiWatShcInlIso)
    annotation(Line(points={{0,200},{0,160},{40,160}},
      color={255,204,51},
      thickness=0.5));
  connect(busValHeaWatHpInlIso, valHeaWatUniInlIso[1:nHp].bus)
    annotation(Line(points={{40,120},{60,120},{60,0},{70,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatHpInlIso, valChiWatUniInlIso[1:nHp].bus)
    annotation(Line(points={{40,180},{140,180},{140,0},{150,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValHeaWatHpOutIso, valHeaWatUniOutIso[1:nHp].bus)
    annotation(Line(points={{-40,120},{-140,120},{-140,0},{-150,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatHpOutIso, valChiWatUniOutIso[1:nHp].bus)
    annotation(Line(points={{-40,180},{-120,180},{-120,0},{-90,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatShcOutIso, valChiWatUniOutIso[nHp + 1:nHp + nShc].bus)
    annotation(Line(points={{-40,160},{-120,160},{-120,0},{-90,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatShcInlIso, valChiWatUniInlIso[nHp + 1:nHp + nShc].bus)
    annotation(Line(points={{40,160},{140,160},{140,0},{150,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValHeaWatShcInlIso, valHeaWatUniInlIso[nHp + 1:nHp + nShc].bus)
    annotation(Line(points={{40,100},{60,100},{60,0},{70,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValHeaWatShcOutIso, valHeaWatUniOutIso[nHp + 1:nHp + nShc].bus)
    annotation(Line(points={{-40,100},{-140,100},{-140,0},{-150,0}},
      color={255,204,51},
      thickness=0.5));
  connect(ports_aChiWatHp, valChiWatUniOutIso[1:nHp].port_a)
    annotation(Line(points={{-100,-200},{-100,-20},{-80,-20},{-80,-10}},
      color={0,127,255}));
  connect(ports_aHeaWatHp, valHeaWatUniOutIso[1:nHp].port_a)
    annotation(Line(points={{-180,-200},{-180,-20},{-160,-20},{-160,-10}},
      color={0,127,255}));
  connect(ports_aChiWatShc, valChiWatUniOutIso[nHp + 1:nHp + nShc].port_a)
    annotation(Line(points={{-20,-200},{-20,-20},{-80,-20},{-80,-10}},
      color={0,127,255}));
  connect(ports_aHeaWatShc, valHeaWatUniOutIso[nHp + 1:nHp + nShc].port_a)
    annotation(Line(points={{-60,-200},{-60,-40},{-160,-40},{-160,-10}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, valChiWatUniOutIso[1:nHp].port_a)
    annotation(Line(points={{-140,-200},{-140,-20},{-80,-20},{-80,-10}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, valHeaWatUniOutIso[1:nHp].port_a)
    annotation(Line(points={{-140,-200},{-140,-20},{-160,-20},{-160,-10}},
      color={0,127,255}));
  connect(valHeaWatUniInlIso[1:nHp].port_b, ports_bChiHeaWatHp)
    annotation(Line(points={{80,-10},{80,-20},{40,-20},{40,-200}},
      color={0,127,255}));
  connect(valChiWatUniInlIso[1:nHp].port_b, ports_bChiHeaWatHp)
    annotation(Line(points={{160,-10},{160,-40},{40,-40},{40,-200}},
      color={0,127,255}));
annotation(defaultComponentName="valIso",
  Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-2400,-700},{2400,700}}),
    graphics={
              Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 1,
      origin={1950,-400},
      rotation=90),
    Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 2,
      origin={1150,-400},
      rotation=90),
    Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 3,
      origin={350,-400},
      rotation=90),
    Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 4,
      origin={-450,-400},
      rotation=90),
    Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 5,
      origin={-1250,-400},
      rotation=90),
    Line(points={{240,150},{0,150},{0,-50}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and not have_pumChiWatPriDed and nHp >= 6,
      origin={-2050,-400},
      rotation=90),
    Line(points={{1000,-160},{1000,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 2),
    Line(points={{200,-160},{200,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 3),
    Line(points={{-600,-160},{-600,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 4),
    Line(points={{-1400,-160},{-1400,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 5),
    Line(points={{-2200,-160},{-2200,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 6),
    Line(points={{1800,-160},{1800,-700}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 1),
    Line(points={{2400,200},{2400,-400},{2200,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 1),
    Line(points={{1800,-160},{1800,600},{2400,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 1),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={1800,-200}),
    Line(points={{-2400,400},{2200,400},{2200,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 1),
    Bitmap(visible=have_valHpInlIso and nHp >= 1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={2200,-200}),
    Bitmap(visible=have_chiWat and nHp >= 1 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={2400,-200}),
    Line(visible=have_chiWat and nHp >= 1 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={2370,-200},
      rotation=-90),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 1 and have_valHpInlIso,
      extent={{2260,-240},{2340,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 1,
      extent={{2060,-240},{2140,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 1,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={2170,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 1,
      extent={{1860,-240},{1940,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 1,
      extent={{1660,-240},{1740,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 1,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={1770,-200},
      rotation=-90),
    Rectangle(extent={{1780,20},{1820,-20}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 1),
    Line(points={{1000,-160},{1000,600},{1800,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 2),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 2,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={1000,-200}),
    Line(points={{1400,400},{1400,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 2),
    Bitmap(visible=have_valHpInlIso and nHp >= 2,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={1400,-200}),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 2 and have_valHpInlIso,
      extent={{1460,-240},{1540,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 2,
      extent={{1260,-240},{1340,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 2,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={1370,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 2,
      extent={{1060,-240},{1140,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 2,
      extent={{860,-240},{940,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 2,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={970,-200},
      rotation=-90),
    Rectangle(extent={{980,20},{1020,-20}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 2),
    Line(points={{1200,4},{1200,-696}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 2),
    Bitmap(visible=have_valHpOutIso and nHp >= 2,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={1200,-200}),
    Line(visible=have_valHpOutIso and nHp >= 2,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={1170,-200},
      rotation=-90),
    Line(points={{200,-160},{200,600},{1000,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 3),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={200,-200}),
    Line(points={{600,400},{600,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 3),
    Bitmap(visible=have_valHpInlIso and nHp >= 3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={600,-200}),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 3,
      extent={{460,-240},{540,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 3,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={570,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 3,
      extent={{260,-240},{340,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 3,
      extent={{60,-240},{140,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 3,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={170,-200},
      rotation=-90),
    Rectangle(extent={{180,20},{220,-20}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 3),
    Line(points={{400,0},{400,-700}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 3),
    Bitmap(visible=have_valHpOutIso and nHp >= 3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={400,-200}),
    Line(visible=have_valHpOutIso and nHp >= 3,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={370,-200},
      rotation=-90),
    Line(points={{-600,-160},{-600,600},{200,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 4),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-600,-200}),
    Line(points={{-200,400},{-200,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 4),
    Bitmap(visible=have_valHpInlIso and nHp >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-200,-200}),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 4,
      extent={{-340,-240},{-260,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 4,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-230,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 4,
      extent={{-540,-240},{-460,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 4,
      extent={{-740,-240},{-660,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 4,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-630,-200},
      rotation=-90),
    Rectangle(extent={{-620,20},{-580,-20}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 4),
    Line(points={{-400,0},{-400,-700}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 4),
    Bitmap(visible=have_valHpOutIso and nHp >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-400,-200}),
    Line(visible=have_valHpOutIso and nHp >= 4,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-430,-200},
      rotation=-90),
    Line(points={{-1400,-160},{-1400,600},{-600,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 5),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 5,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-1400,-200}),
    Line(points={{-1000,400},{-1000,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 5),
    Bitmap(visible=have_valHpInlIso and nHp >= 5,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-1000,-200}),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 5,
      extent={{-1140,-240},{-1060,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 5,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-1030,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 5,
      extent={{-1340,-240},{-1260,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 5,
      extent={{-1540,-240},{-1460,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 5,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-1430,-200},
      rotation=-90),
    Rectangle(extent={{-1420,20},{-1380,-20}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 5),
    Line(points={{-1200,0},{-1200,-700}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 5),
    Bitmap(visible=have_valHpOutIso and nHp >= 5,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-1200,-200}),
    Line(visible=have_valHpOutIso and nHp >= 5,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-1230,-200},
      rotation=-90),
    Line(points={{-2200,-160},{-2200,600},{-1400,600}},
      color={0,0,0},
      thickness=5,
      visible=have_chiWat and nHp >= 6),
    Bitmap(visible=have_chiWat and have_valHpOutIso and nHp >= 6,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-2200,-200}),
    Line(points={{-1800,400},{-1800,-700}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nHp >= 6),
    Bitmap(visible=have_valHpInlIso and nHp >= 6,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-1800,-200}),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpInlIso and nHp >= 6,
      extent={{-1940,-240},{-1860,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_valHpInlIso and nHp >= 6,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-1830,-200},
      rotation=-90),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_valHpOutIso and nHp >= 6,
      extent={{-2140,-240},{-2060,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(visible=typValHpOutIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and have_valHpOutIso and nHp >= 6,
      extent={{-2340,-240},{-2260,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(visible=have_chiWat and have_valHpOutIso and nHp >= 6,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-2230,-200},
      rotation=-90),
    Rectangle(extent={{-2220,20},{-2180,-22}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 6),
    Line(points={{-2000,0},{-2000,-700}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 6),
    Bitmap(visible=have_valHpOutIso and nHp >= 6,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-2000,-200}),
    Line(visible=have_valHpOutIso and nHp >= 6,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-2030,-200},
      rotation=-90),
    Line(points={{-2400,0},{2000,0},{2000,-700}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 1),
    Bitmap(visible=have_valHpOutIso and nHp >= 1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={2000,-200}),
    Line(visible=have_valHpOutIso and nHp >= 1,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={1970,-200},
      rotation=-90),
    Line(points={{1820,-508}},
      color={0,0,0}),
    Rectangle(extent={{2180,220},{2220,178}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 2),
    Line(points={{2400,200},{1600,200},{1600,-400},{1400,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 2),
    Bitmap(visible=have_chiWat and nHp >= 2 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={1600,-200}),
    Line(visible=have_chiWat and nHp >= 2 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={1570,-200},
      rotation=-90),
    Rectangle(extent={{1380,220},{1420,178}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 3),
    Line(points={{1600,200},{800,200},{800,-400},{600,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 3),
    Bitmap(visible=have_chiWat and nHp >= 3 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={800,-200}),
    Line(visible=have_chiWat and nHp >= 3 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={770,-200},
      rotation=-90),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 3 and have_valHpInlIso,
      extent={{660,-240},{740,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Rectangle(extent={{580,220},{620,180}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 4),
    Rectangle(extent={{-220,220},{-180,180}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 5),
    Rectangle(extent={{-1020,220},{-980,180}},
      lineColor={0,0,0},
      lineThickness=1,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      visible=have_chiWat and nHp >= 6),
    Line(points={{800,200},{0,200},{0,-400},{-200,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 4),
    Bitmap(visible=have_chiWat and nHp >= 4 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={0,-200}),
    Line(visible=have_chiWat and nHp >= 4 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-30,-200},
      rotation=-90),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 4 and have_valHpInlIso,
      extent={{-140,-240},{-60,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(points={{0,200},{-800,200},{-800,-400},{-1000,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 5),
    Bitmap(visible=have_chiWat and nHp >= 5 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-800,-200}),
    Line(visible=have_chiWat and nHp >= 5 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-830,-200},
      rotation=-90),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 5 and have_valHpInlIso,
      extent={{-940,-240},{-860,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Line(points={{-800,200},{-1600,200},{-1600,-400},{-1800,-400}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=have_chiWat and nHp >= 6),
    Bitmap(visible=have_chiWat and nHp >= 6 and have_valHpInlIso,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-1600,-200}),
    Line(visible=have_chiWat and nHp >= 6 and have_valHpInlIso,
      points={{0,30},{0,-30}},
      color={0,0,0},
      origin={-1630,-200},
      rotation=-90),
    Bitmap(visible=typValHpInlIso ==
      Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and
      have_chiWat and nHp >= 6 and have_valHpInlIso,
      extent={{-1740,-240},{-1660,-160}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg")}),
  Documentation(
    info="<html>
<p>
  This model represents the heat pump isolation valves. The isolation valves
  are modeled as two-way two-position valves, which can be located at the heat
  pump inlet and/or outlet depending on the settings of the parameters
  <code>have_valHpInlIso</code> and <code>have_valHpOutIso</code>. It is
  assumed that the heat pumps always provide heating hot water. Optionally,
  chilled water return and supply and the associated isolation valves can be
  modeled by setting the parameter <code>have_chiWat</code> to true.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    May 7, 2025, by Antoine Gautier:<br />
    Refactored with fixed resistance in valve component.<br />
    This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4227\">#4227</a>.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end ValvesIsolation;
