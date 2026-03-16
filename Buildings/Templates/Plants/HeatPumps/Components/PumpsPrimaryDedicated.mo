within Buildings.Templates.Plants.HeatPumps.Components;
model PumpsPrimaryDedicated
  "Dedicated primary pumps"
  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(__ctrlFlow(enable=false));

  parameter Integer nPumHeaWat =
    (if typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    then 1 else 0) * ((if have_hp then nHp else 0) + (if have_shc
      then nShc else 0))
    "Number of primary HW pumps"
    annotation(Evaluate=true);
  parameter Integer nPumChiWat =
    (if typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    then 1 else 0) * ((if have_hp and have_pumChiWatPriDed then nHp else 0) +
      (if have_shc then nShc else 0))
    "Number of primary CHW pumps"
    annotation(Evaluate=true);
  final parameter Integer idxConPumChiWat =
    if have_hp and have_pumChiWatPriDed then nHp + 1 else 1
    "Lowest index to connect SHC unit ports to primary CHW pump ports"
    annotation(Evaluate=true);
  parameter Boolean have_hp = true
    "Set to true for plants with non-reversible or reversible heat pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_shc = false
    "Set to true for plants with polyvalent (SHC) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nHp
    "Number of heat pumps (excluding SHC units)"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Integer nShc = 0
    "Number of polyvalent (SHC) units"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumPri
    "Type of primary pump arrangement"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_pumChiWatPriDed(start=false)
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Boolean have_pumHeaWatPriVar(start=false)
    "Set to true for variable speed primary HW pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Boolean have_pumChiWatPriVar(start=false)
    "Set to true for variable speed primary CHW pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
          and (have_hp and have_pumChiWatPriDed or have_shc)));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWat(
    typ=if nPumHeaWat > 0
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    nPum=nPumHeaWat)
    "HW pump parameters"
    annotation(Dialog(enable=nPumHeaWat > 0),
      Placement(transformation(extent={{-110,0},{-90,20}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWat(
    typ=if nPumChiWat > 0
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    nPum=nPumChiWat)
    "CHW pump parameters"
    annotation(Dialog(enable=nPumChiWat > 0),
      Placement(transformation(extent={{30,0},{50,20}})));
  parameter Modelica.Units.SI.PressureDifference dpValCheHeaWat_nominal[nPumHeaWat](
    each final min=0,
    start=fill(
      if typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then Buildings.Templates.Data.Defaults.dpValChe else 0,
      nPumHeaWat)) =
    fill(
      if typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then Buildings.Templates.Data.Defaults.dpValChe else 0,
      nPumHeaWat)
    "HW pump check valve pressure drop at design pump flow rate (selection conditions)"
    annotation(Dialog(group="Nominal condition",
      enable=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Modelica.Units.SI.PressureDifference dpValCheChiWat_nominal[nPumChiWat](
    each final min=0,
    start=fill(
      if have_pumChiWatPriDed or have_shc
      then Buildings.Templates.Data.Defaults.dpValChe else 0,
      nPumChiWat)) =
    fill(
      if have_pumChiWatPriDed or have_shc
      then Buildings.Templates.Data.Defaults.dpValChe else 0,
      nPumChiWat)
    "CHW pump check valve pressure drop at design pump flow rate (selection conditions)"
    annotation(Dialog(group="Nominal condition",
      enable=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and (have_hp and have_pumChiWatPriDed or have_shc)));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Modelica.Units.SI.Time tau = 1
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState),
      __ctrlFlow(enable=false));
  parameter Boolean allowFlowReversal = true
    "Set to false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"),
      Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
      and (typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
        or typArrPumPri ==
          Buildings.Templates.Components.Types.PumpArrangement.Dedicated
          and not have_pumChiWatPriDed)
    "CHW/HW supply (to primary loop)"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-100,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=270,
        origin={-440,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
    "CHW/HW return (from primary loop)"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={180,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=270,
        origin={658,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
    "CHW/HW return – HP entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={180,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={820,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed
    "HW supply (to primary loop)"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-180,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-760,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed
    "CHW supply (to primary loop)"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-140,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-600,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_hp
    "CHW/HW supply (HP leaving)"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-160,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-820,-400})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{0,180},{40,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWat(
    redeclare final package Medium=Medium,
    final have_var=have_pumHeaWatPriVar,
    final have_varCom=false,
    final nPum=nPumHeaWat,
    final dat=datPumHeaWat,
    final dpValChe_nominal=dpValCheHeaWat_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final energyDynamics=energyDynamics)
    if nPumHeaWat > 0
    "Dedicated primary (HW) Pumps"
    annotation(Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWat(
    redeclare final package Medium=Medium,
    final have_var=have_pumChiWatPriVar,
    final have_varCom=false,
    final nPum=nPumChiWat,
    final dat=datPumChiWat,
    final dpValChe_nominal=dpValCheChiWat_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final energyDynamics=energyDynamics)
    if nPumChiWat > 0
    "Dedicated primary CHW pumps - Optional"
    annotation(Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasHdr[nHp](
    redeclare each final package Medium=Medium)
    if have_hp
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Direct fluid pass-through for headered primary pumps"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-180,-140})));
  Fluid.FixedResistances.Junction junDedSep[nHp](
    redeclare each final package Medium=Medium,
    final m_flow_nominal={{max(
      datPumHeaWat.m_flow_nominal[i], datPumChiWat.m_flow_nominal[i]),
      -datPumHeaWat.m_flow_nominal[i],
      -datPumChiWat.m_flow_nominal[i]} for i in 1:nHp},
    dp_nominal=fill(fill(0, 3), nHp),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal
      then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    if have_hp
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed
    "Fluid junction for separate dedicated primary pumps"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-140,-140})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasDedCom[nHp](
    redeclare each final package Medium=Medium)
    if have_hp
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and not have_pumChiWatPriDed
    "Direct fluid pass-through for common dedicated primary pumps"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-160,-140})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW return (from primary loop) to SHC unit"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={120,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=270,
        origin={500,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "CHW return (from primary loop) to SHC unit"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={60,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=270,
        origin={340,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWatRetShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW return – SHC unit entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={120,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={660,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWatRetShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "CHW return – SHC unit entering"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={60,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={500,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWatShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW supply – SHC unit leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-80,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-660,-400})));
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
        origin={-500,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWatSupShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "CHW supply – SHC unit leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-20,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-120,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWatSupShc[nShc](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_shc
    "HW supply – SHC unit leaving"
    annotation(Placement(transformation(extent={{-10,-40},{10,40}},
      rotation=90,
      origin={-60,200}),
      iconTransformation(extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-280,400})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasHdrHeaWatShc[nShc](
    redeclare each final package Medium=Medium)
    if have_shc
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Direct fluid pass-through for headered primary pumps"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-60,-140})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasHdrChiWatShc[nShc](
    redeclare each final package Medium=Medium)
    if have_shc
      and typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Direct fluid pass-through for headered primary pumps"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-138})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation(Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    "Primary CHW pump control bus"
    annotation(Placement(transformation(extent={{0,-70},{40,-30}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(bus.pumHeaWatPri, busPumHeaWatPri)
    annotation(Line(points={{20,200},{20,-10},{-120,-10},{-120,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.pumChiWatPri, busPumChiWatPri)
    annotation(Line(points={{20,200},{20,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPri, pumHeaWat.bus)
    annotation(Line(points={{-120,-50},{-150,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumChiWatPri, pumChiWat.bus)
    annotation(Line(points={{20,-50},{-30,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(ports_aChiHeaWat, ports_bChiHeaWatHp)
    annotation(Line(points={{180,200},{180,-200}},
      color={0,127,255}));
  connect(pasHdr.port_b, ports_bChiHeaWat)
    annotation(Line(points={{-180,-130},{-180,140},{-100,140},{-100,200}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, junDedSep.port_1)
    annotation(Line(points={{-160,-200},{-140,-200},{-140,-150}},
      color={0,127,255}));
  connect(ports_aHeaWat, ports_bHeaWatRetShc)
    annotation(Line(points={{120,200},{120,-200}},
      color={0,127,255}));
  connect(ports_aChiWat, ports_bChiWatRetShc)
    annotation(Line(points={{60,200},{60,-200}},
      color={0,127,255}));
  connect(ports_aHeaWatShc, pumHeaWat.ports_a[nHp + 1:nHp + nShc])
    annotation(Line(points={{-80,-200},{-80,-80},{-160,-80},{-160,-60}},
      color={0,127,255}));
  connect(ports_aChiWatShc, pumChiWat.ports_a[idxConPumChiWat:idxConPumChiWat +
    nShc - 1])
    annotation(Line(points={{-20,-200},{-40,-200},{-40,-60}},
      color={0,127,255}));
  connect(pumHeaWat.ports_b[nHp + 1:nHp + nShc], ports_bHeaWatSupShc)
    annotation(Line(points={{-140,-60},{-140,160},{-60,160},{-60,200}},
      color={0,127,255}));
  connect(pumChiWat.ports_b[idxConPumChiWat:idxConPumChiWat + nShc -
    1], ports_bChiWatSupShc)
    annotation(Line(points={{-20,-60},{-20,200}},
      color={0,127,255}));
  connect(junDedSep.port_2, pumHeaWat.ports_a[1:nHp])
    annotation(Line(points={{-140,-130},{-140,-80},{-160,-80},{-160,-60}},
      color={0,127,255}));
  connect(junDedSep.port_3, pumChiWat.ports_a[1:nHp])
    annotation(Line(points={{-130,-140},{-100,-140},{-100,-60},{-40,-60}},
      color={0,127,255}));
  connect(pasDedCom.port_b, pumHeaWat.ports_a[1:nHp])
    annotation(Line(points={{-160,-130},{-160,-60}},
      color={0,127,255}));
  connect(ports_aChiWatShc, pasHdrChiWatShc.port_a)
    annotation(Line(points={{-20,-200},{0,-200},{0,-148}},
      color={0,127,255}));
  connect(pasHdrChiWatShc.port_b, ports_bChiWatSupShc)
    annotation(Line(points={{0,-128},{0,200},{-20,200}},
      color={0,127,255}));
  connect(ports_aHeaWatShc, pasHdrHeaWatShc.port_a)
    annotation(Line(points={{-80,-200},{-60,-200},{-60,-150}},
      color={0,127,255}));
  connect(pasHdrHeaWatShc.port_b, ports_bHeaWatSupShc)
    annotation(Line(points={{-60,-130},{-60,200}},
      color={0,127,255}));
  connect(pumHeaWat.ports_b[1:nHp], ports_bHeaWat)
    annotation(Line(points={{-140,-60},{-140,160},{-180,160},{-180,200}},
      color={0,127,255}));
  connect(pumChiWat.ports_b[1:nHp], ports_bChiWat)
    annotation(Line(points={{-20,-60},{-20,180},{-140,180},{-140,200}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, pasHdr.port_a)
    annotation(Line(points={{-160,-200},{-180,-200},{-180,-150}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, pasDedCom.port_a)
    annotation(Line(points={{-160,-200},{-160,-150}},
      color={0,127,255}));
  connect(pumHeaWat.ports_b[1:nHp], ports_bChiHeaWat)
    annotation(Line(points={{-140,-60},{-140,160},{-100,160},{-100,200}},
      color={0,127,255}));
annotation(defaultComponentName="pumPri",
  Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-2400,-400},{2400,400}}),
    graphics={
              Line(points={{2000,60},{2000,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 1),
    Line(points={{2000,400},{2000,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 1),
    Line(points={{2200,400},{2200,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 1),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 1,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={2022,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 1,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={2000,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 1,
      extent={{2080,-50},{2180,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{2020,-40},{2020,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 1),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 1,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={1822,10},
      rotation=90),
    Line(points={{1800,400},{1800,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 1),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 1,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={1800,260},
      rotation=90),
    Line(points={{1820,-40},{1820,-200},{2020,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 1),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 1,
      extent={{1660,-50},{1760,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{2066,0},{2080,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 1),
    Line(points={{1760,0},{1778,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 1),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 1,
      extent={{2080,-50},{2180,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 1,
      extent={{1660,-104},{1760,-4}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(points={{-2000,60},{-2000,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 6),
    Line(points={{-2000,400},{-2000,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 6),
    Line(points={{-1800,400},{-1800,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 6),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 6,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-1978,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 6,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-2000,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 6,
      extent={{-1920,-50},{-1820,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-1980,-40},{-1980,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 6),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 6,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-2178,10},
      rotation=90),
    Line(points={{-2200,400},{-2200,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 6),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 6,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-2200,260},
      rotation=90),
    Line(points={{-2180,-40},{-2180,-200},{-1980,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 6),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 6,
      extent={{-2340,-50},{-2240,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-1934,0},{-1920,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 6),
    Line(points={{-2240,0},{-2222,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 6),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 6,
      extent={{-1920,-50},{-1820,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 6,
      extent={{-2340,-50},{-2240,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(points={{-1200,60},{-1200,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 5),
    Line(points={{-1200,400},{-1200,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 5),
    Line(points={{-1000,400},{-1000,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 5),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 5,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-1178,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 5,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-1200,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 5,
      extent={{-1120,-50},{-1020,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-1180,-40},{-1180,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 5),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 5,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-1378,10},
      rotation=90),
    Line(points={{-1400,400},{-1400,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 5),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 5,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-1400,260},
      rotation=90),
    Line(points={{-1380,-40},{-1380,-200},{-1180,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 5),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 5,
      extent={{-1540,-50},{-1440,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-1134,0},{-1120,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 5),
    Line(points={{-1440,0},{-1422,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 5),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 5,
      extent={{-1120,-50},{-1020,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 5,
      extent={{-1540,-50},{-1440,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(points={{-400,60},{-400,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 4),
    Line(points={{-400,400},{-400,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 4),
    Line(points={{-200,400},{-200,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 4),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 4,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-378,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 4,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-400,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 4,
      extent={{-320,-50},{-220,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-380,-40},{-380,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 4),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 4,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={-578,10},
      rotation=90),
    Line(points={{-600,400},{-600,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 4),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 4,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={-600,260},
      rotation=90),
    Line(points={{-580,-40},{-580,-200},{-380,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 4),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 4,
      extent={{-740,-50},{-640,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{-334,0},{-320,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 4),
    Line(points={{-640,0},{-622,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 4),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 4,
      extent={{-320,-50},{-220,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 4,
      extent={{-740,-50},{-640,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(points={{400,60},{400,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 3),
    Line(points={{400,400},{400,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 3),
    Line(points={{600,400},{600,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 3),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 3,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={422,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 3,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={400,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 3,
      extent={{480,-50},{580,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{420,-40},{420,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 3),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 3,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={222,10},
      rotation=90),
    Line(points={{200,400},{200,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 3),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 3,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={200,260},
      rotation=90),
    Line(points={{220,-40},{220,-200},{420,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 3),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 3,
      extent={{60,-50},{160,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{466,0},{480,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 3),
    Line(points={{160,0},{178,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 3),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 3,
      extent={{480,-50},{580,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 3,
      extent={{60,-50},{160,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Line(points={{1200,60},{1200,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Headered and
        nHp >= 2),
    Line(points={{1200,400},{1200,60}},
      color={0,0,0},
      thickness=5,
      visible=nHp >= 2),
    Line(points={{1400,400},{1400,-400}},
      color={0,0,0},
      thickness=5,
      pattern=LinePattern.Dash,
      visible=nHp >= 2),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 2,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={1222,10},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      nHp >= 2,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={1200,260},
      rotation=90),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      have_pumHeaWatPriVar and nHp >= 2,
      extent={{1280,-50},{1380,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{1220,-40},{1220,-400}},
      color={0,0,0},
      thickness=5,
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 2),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 2,
      extent={{-50,-50},{50,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg",
      origin={1022,10},
      rotation=90),
    Line(points={{1000,400},{1000,60}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 2),
    Bitmap(visible=have_pumChiWatPriDed and nHp >= 2,
      extent={{-40,-40},{40,40}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
      origin={1000,260},
      rotation=90),
    Line(points={{1020,-40},{1020,-200},{1220,-200}},
      color={0,0,0},
      thickness=5,
      visible=have_pumChiWatPriDed and nHp >= 2),
    Bitmap(visible=have_pumChiWatPriDed and have_pumChiWatPriVar and nHp >= 2,
      extent={{860,-50},{960,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(points={{1266,0},{1280,0}},
      color={0,0,0},
      visible=typArrPumPri ==
        Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
        nHp >= 2),
    Line(points={{960,0},{978,0}},
      color={0,0,0},
      visible=have_pumChiWatPriDed and nHp >= 2),
    Bitmap(visible=typArrPumPri ==
      Buildings.Templates.Components.Types.PumpArrangement.Dedicated and
      not have_pumHeaWatPriVar and nHp >= 2,
      extent={{1280,-50},{1380,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
    Bitmap(visible=have_pumChiWatPriDed and not have_pumChiWatPriVar and
      nHp >= 2,
      extent={{860,-50},{960,50}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg")}),
  Documentation(
    revisions="<html>
<ul>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<p>
  This model represents dedicated primary HW pumps and, optionally, separate
  dedicated primary CHW pumps if the parameter
  <code>have_pumChiWatPriDed</code> is set to true. The pump components are
  connected to the heat pump outlet, in a \"pump away\" configuration. Variable
  speed or constant speed pumps can be modeled by setting the parameters
  <code>have_pumHeaWatPriVar</code> and <code>have_pumChiWatPriVar</code>. If
  headered pumps are modeled
  (<code>typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered</code>),
  this component resolves to a direct fluid pass-through.
</p>
</html>"));
end PumpsPrimaryDedicated;
