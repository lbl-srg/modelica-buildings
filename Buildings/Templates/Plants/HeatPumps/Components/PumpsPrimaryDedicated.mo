within Buildings.Templates.Plants.HeatPumps.Components;
model PumpsPrimaryDedicated
  "Dedicated primary pumps"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (__ctrlFlow(enable=false));
  parameter Integer nHp(min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  /* RFE: Add support for multiple pumps for each heat pump.
  Currently, only one dedicated CHW or HW pump for each HP is supported.
  */
  final parameter Integer nPum=if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    then nHp else 0
    "Number of primary pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumPri
    "Type of primary pump arrangement"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_pumChiWatPriDed(start=false)
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Boolean have_pumHeaWatPriVar(start=false)
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Boolean have_pumChiWatPriVar(start=false)
    "Set to true for variable speed primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and have_pumChiWatPriDed));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumHeaWat(
    typ=if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      then Buildings.Templates.Components.Types.Pump.Multiple else Buildings.Templates.Components.Types.Pump.None,
    nPum=nPum)
    "HW pump parameters"
    annotation (Dialog(enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated),
      Placement(transformation(extent={{170,170},{190,190}})));
  parameter Buildings.Templates.Components.Data.PumpMultiple datPumChiWat(
    typ=if have_pumChiWatPriDed then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    nPum=if have_pumChiWatPriDed then nPum else 0)
    "CHW pump parameters"
    annotation (Dialog(enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed),
      Placement(transformation(extent={{170,130},{190,150}})));
  parameter Modelica.Units.SI.PressureDifference dpValCheHeaWat_nominal[nPum](
    each final min=0,
    start=fill(if typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    then Buildings.Templates.Data.Defaults.dpValChe else 0, nPum))=
    fill(if typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    then Buildings.Templates.Data.Defaults.dpValChe else 0, nPum)
    "HW pump check valve pressure drop at design HW pump flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  parameter Modelica.Units.SI.PressureDifference dpValCheChiWat_nominal[if have_pumChiWatPriDed then nPum else 0](
    each final min=0,
    start=fill(if have_pumChiWatPriDed then Buildings.Templates.Data.Defaults.dpValChe else 0,
    if have_pumChiWatPriDed then nPum else 0))=
    fill(if have_pumChiWatPriDed then Buildings.Templates.Data.Defaults.dpValChe else 0,
    if have_pumChiWatPriDed then nPum else 0)
    "CHW pump check valve pressure drop at design CHW pump flow rate"
    annotation (Dialog(group="Nominal condition", enable=have_pumChiWatPriDed));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Modelica.Units.SI.Time tau=1
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
    __ctrlFlow(enable=false));
  parameter Boolean allowFlowReversal=true
    "Set to false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
      or typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and not have_pumChiWatPriDed
    "CHW/HW supply (to primary loop)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={-100,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=270,origin={-500,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "CHW/HW return (from primary loop)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={100,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=270,origin={500,400})));
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
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={500,-400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed
    "HW supply (to primary loop)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={-180,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={-660,400})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
      and have_pumChiWatPriDed
    "CHW supply (to primary loop)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={-20,200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={-340,400})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiHeaWatHp[nHp](
    redeclare each final package Medium=Medium,
    each m_flow(
      min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "CHW/HW supply (HP leaving)"
    annotation (Placement(transformation(extent={{-10,-40},{10,40}},rotation=90,
      origin={-100,-200}),
      iconTransformation(extent={{-10,-40},{10,40}},rotation=90,origin={-500,-400})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{20,180},{60,220}}),
      iconTransformation(extent={{-20,380},{20,420}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWat(
    redeclare final package Medium=Medium,
    final have_var=have_pumHeaWatPriVar,
    final have_varCom=false,
    final nPum=nPum,
    final dat=datPumHeaWat,
    final dpValChe_nominal=dpValCheHeaWat_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final energyDynamics=energyDynamics)
    if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Dedicated primary (HW) Pumps"
    annotation (Placement(transformation(extent={{-110,-70},{-130,-50}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWat(
    redeclare final package Medium=Medium,
    final have_var=have_pumChiWatPriVar,
    final have_varCom=false,
    final nPum=if have_pumChiWatPriDed then nPum else 0,
    final dat=datPumChiWat,
    final dpValChe_nominal=dpValCheChiWat_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final energyDynamics=energyDynamics)
    if have_pumChiWatPriDed
    "Dedicated primary CHW pumps - Optional"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas[nHp](
    redeclare each final package Medium=Medium)
    if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Direct fluid pass-through in case of headered primary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,
      origin={-100,120})));
protected
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{-20,-40},{20,0}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumChiWatPri
    if have_pumChiWatPriDed
    "Primary CHW pump control bus"
    annotation (Placement(transformation(extent={{-20,-70},{20,-30}}),
      iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(bus.pumHeaWatPri, busPumHeaWatPri)
    annotation (Line(points={{40,200},{40,-20},{0,-20}},color={255,204,51},thickness=0.5));
  connect(bus.pumChiWatPri, busPumChiWatPri)
    annotation (Line(points={{40,200},{40,-50},{0,-50}},color={255,204,51},thickness=0.5));
  connect(ports_aChiHeaWatHp, pumHeaWat.ports_a)
    annotation (Line(points={{-100,-200},{-100,-60},{-110,-60}},color={0,127,255}));
  connect(pumHeaWat.ports_b, ports_bHeaWat)
    annotation (Line(points={{-130,-60},{-140,-60},{-140,180},{-180,180},{-180,200}},
      color={0,127,255}));
  connect(pumHeaWat.ports_b, ports_bChiHeaWat)
    annotation (Line(points={{-130,-60},{-140,-60},{-140,180},{-100,180},{-100,200}},
      color={0,127,255}));
  connect(ports_aChiHeaWatHp, pumChiWat.ports_a)
    annotation (Line(points={{-100,-200},{-100,-60},{-90,-60}},color={0,127,255}));
  connect(pumChiWat.ports_b, ports_bChiWat)
    annotation (Line(points={{-70,-60},{-60,-60},{-60,180},{-20,180},{-20,200}},
      color={0,127,255}));
  connect(pumChiWat.ports_b, ports_bChiHeaWat)
    annotation (Line(points={{-70,-60},{-60,-60},{-60,180},{-100,180},{-100,200}},
      color={0,127,255}));
  connect(busPumHeaWatPri, pumHeaWat.bus)
    annotation (Line(points={{0,-20},{-40,-20},{-40,-50},{-120,-50}},color={255,204,51},thickness=0.5));
  connect(busPumChiWatPri, pumChiWat.bus)
    annotation (Line(points={{0,-50},{-80,-50}},color={255,204,51},thickness=0.5));
  connect(ports_aChiHeaWat, ports_bChiHeaWatHp)
    annotation (Line(points={{100,200},{100,-200}},color={0,127,255}));
  connect(ports_aChiHeaWatHp, pas.port_a)
    annotation (Line(points={{-100,-200},{-100,110}},color={0,127,255}));
  connect(pas.port_b, ports_bChiHeaWat)
    annotation (Line(points={{-100,130},{-100,200}},color={0,127,255}));
  annotation (
    defaultComponentName="pumPri",
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-1000,-400},{1000,400}})));
end PumpsPrimaryDedicated;
