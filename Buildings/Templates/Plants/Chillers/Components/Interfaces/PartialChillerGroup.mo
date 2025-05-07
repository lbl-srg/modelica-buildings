within Buildings.Templates.Plants.Chillers.Components.Interfaces;
partial model PartialChillerGroup "Interface class for chiller group"
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid";

  parameter Integer nChi(final min=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_switchover=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Boolean use_TChiWatSupForCtl=true
    "Set to true for CHW supply temperature control, false for CHW return temperature control"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumConWat(start=Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Boolean have_pumConWatVar(start=false)
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl typCtlHea(
    start=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BuiltIn)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Plants.Chillers.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri(
    start=Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDecoupler)
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=
    typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed));

  parameter Buildings.Templates.Plants.Chillers.Types.Economizer typEco(
    start=Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));

  final parameter Boolean enaTypValChiWatChiIso=
    typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Enable choices of chiller CHW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, choices(
    choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Two-way modulating valve"),
    Dialog(group="Configuration", enable=enaTypValChiWatChiIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso=
    if enaTypValChiWatChiIso then typValChiWatChiIso_select
    else Buildings.Templates.Components.Types.Valve.None
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean enaTypValConWatChiIso=
    typArrPumConWat==Buildings.Templates.Components.Types.PumpArrangement.Headered
      and (typCtlHea==Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None
      or have_pumConWatVar
      and typEco==Buildings.Templates.Plants.Chillers.Types.Economizer.None)
    "Enable choices of chiller CW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true,
    choices(choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Two-way modulating valve"),
    Dialog(group="Configuration", enable=enaTypValConWatChiIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso
    =if (typ <> Buildings.Templates.Components.Types.Chiller.WaterCooled or
      typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Dedicated)
       then Buildings.Templates.Components.Types.Valve.None elseif
      enaTypValConWatChiIso then typValConWatChiIso_select
    else Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // The following parameter stores the user selection.
  parameter Boolean have_senTChiWatChiSup_select=false
    "Set to true for chiller CHW supply temperature sensor"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=
    not
       ((typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)
    and typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.TemperatureChillerSensor
    or typCtlHea==Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.External)));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_senTChiWatChiSup=
    if (typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
    or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed)
    and typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.TemperatureChillerSensor
    or typCtlHea==Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.External
    then true
    else have_senTChiWatChiSup_select
    "Set to true for chiller CHW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTChiWatChiRet=false
    "Set to true for chiller CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senTConWatChiSup=false
    "Set to true for chiller CW supply temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  // The following parameter stores the user selection.
  parameter Boolean have_senTConWatChiRet_select=false
    "Set to true for chiller CW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=typ ==
          Buildings.Templates.Components.Types.Chiller.WaterCooled and not
          typCtlHea == Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.External));
  // The following parameter stores the actual configuration setting.
  final parameter Boolean have_senTConWatChiRet=
    if typCtlHea == Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.External
    then true elseif typ <> Buildings.Templates.Components.Types.Chiller.WaterCooled
    then false else have_senTConWatChiRet_select
    "Set to true for chiller CW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup
    dat(typ=typ, typArrChi=typArrChi, nChi=nChi)
    "Parameter record for chiller group"
    annotation (Placement(transformation(extent={{170,170},{190,190}})));
  final parameter Buildings.Templates.Components.Data.Chiller datChi[nChi](
    final typ=fill(typ, nChi),
    final mChiWat_flow_nominal=mChiWatChi_flow_nominal,
    final mCon_flow_nominal=mConChi_flow_nominal,
    final cap_nominal=capChi_nominal,
    final dpChiWat_nominal=if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      then dat.dpChiWatChi_nominal else fill(0, nChi),
    final dpCon_nominal=fill(0, nChi),
    final TChiWatSup_nominal=dat.TChiWatSupChi_nominal,
    final TCon_nominal=dat.TConChi_nominal,
    final per=dat.perChi)
    "Parameter record - Each chiller";
  // For series chillers, the following component is used to model the unique balancing valve after the last chiller.
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatChiIsoPar[nChi](
    final typ=if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
     then fill(typValChiWatChiIso, nChi) else
     fill(Buildings.Templates.Components.Types.Valve.None, nChi),
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      then dpFixedChiWat_nominal else dpBalChiWatChi_nominal)
    "CHW isolation valve parameters - Parallel chillers"
    annotation (Dialog(enable=false));
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatChiIsoSer[nChi](
    final typ=fill(typValChiWatChiIso, nChi),
    final m_flow_nominal=fill(sum(mChiWatChi_flow_nominal), nChi),
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=fill(0, nChi))
    "CHW isolation valve parameters - Series chillers"
    annotation (Dialog(enable=false));
  final parameter Buildings.Templates.Components.Data.Valve datValConWatChiIso[nChi](
    final typ=fill(typValConWatChiIso, nChi),
    final m_flow_nominal=mConChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=dpFixedConWat_nominal)
    "CW isolation valve parameters"
    annotation (Dialog(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    dat.mChiWatChi_flow_nominal
    "Design CHW mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.MassFlowRate mConChi_flow_nominal[nChi]=if
    typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
    or typ == Buildings.Templates.Components.Types.Chiller.AirCooled
    then dat.mConChi_flow_nominal else fill(0, nChi)
    "Condenser cooling fluid mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi]=
    dat.capChi_nominal
    "Cooling capacity - Each chiller";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatChi_flow_nominal[nChi]=
    -abs(capChi_nominal)
    "Design cooling heat flow rate - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    dat.dpChiWatChi_nominal
    "CHW pressure drop - Each chiller";
  // For series chillers, a unique balancing valve is modeled after the last chiller.
  final parameter Modelica.Units.SI.PressureDifference dpBalChiWatChi_nominal[nChi]=
    if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel then
      dat.dpBalChiWatChiPar_nominal else
      {if i < nChi then 0 else dat.dpBalChiWatSer_nominal for i in 1:nChi}
    "CHW balancing valve pressure drop at design mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpFixedChiWat_nominal[nChi]=
    dpChiWatChi_nominal .+ dpBalChiWatChi_nominal
    "Fixed CHW pressure drop: chiller + balancing valve"
    annotation (Dialog(group="Nominal condition"));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal[nChi]=
    dpFixedChiWat_nominal .+
    (if typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
     and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
     then datValChiWatChiIsoPar.dpValve_nominal else fill(0, nChi))
    "Total CHW pressure drop: fixed + valves"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpConChi_nominal[nChi]=
    dat.dpConChi_nominal
    "CW pressure drop - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpBalConWatChi_nominal[nChi]=
    dat.dpBalConWatChi_nominal
    "CW balancing valve pressure drop at design mass flow rate - Each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpFixedConWat_nominal[nChi]=
    dpConChi_nominal .+ dpBalConWatChi_nominal
    "Fixed CW pressure drop: chiller + balancing valve"
    annotation (Dialog(group="Nominal condition"));
  // The following parameter is intended for external use.
  final parameter Modelica.Units.SI.PressureDifference dpConWat_nominal[nChi]=
    dpFixedConWat_nominal .+
    (if typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
    then datValConWatChiIso.dpValve_nominal else fill(0, nChi))
    "Total CW pressure drop: fixed + valves"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature TChiWatSupChi_nominal[nChi]=
    dat.TChiWatSupChi_nominal
    "CHW supply temperature - Each chiller";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "Load side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Boolean allowFlowReversalSou=true
    "Source side flow reversal: false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions",
      enable=Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Evaluate=true);

  parameter Boolean use_strokeTime=
    energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState
    "Set to true to continuously open and close valve"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
     or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.Time strokeTime=120
    "Time needed to open or close valve"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and (
    typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None)));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and (
    typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None)));
  parameter Real y_start=1
    "Initial position of actuator"
    annotation (__ctrlFlow(enable=false),
  Dialog(tab="Dynamics",group="Time needed to open or close valve",
    enable=use_strokeTime and (
    typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None)));
  parameter Boolean from_dp=true
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true,
    Dialog(tab="Advanced",
      enable=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Evaluate=true,
    Dialog(tab="Advanced",
      enable=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
    or typValConWatChiIso<>Buildings.Templates.Components.Types.Valve.None));

  // Diagnostics
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced",group="Diagnostics"),HideResult=true);
  MediumChiWat.ThermodynamicState sta_aChiWat[nChi]=MediumChiWat.setState_phX(
    ports_aChiWat.p, noEvent(actualStream(ports_aChiWat.h_outflow)),
    noEvent(actualStream(ports_aChiWat.Xi_outflow)))
    if show_T
    "CHW properties in ports_aChiWat";
  MediumChiWat.ThermodynamicState sta_bChiWat[nChi]=MediumChiWat.setState_phX(
    ports_bChiWat.p, noEvent(actualStream(ports_bChiWat.h_outflow)),
    noEvent(actualStream(ports_bChiWat.Xi_outflow)))
    if show_T
    "CHW properties in ports_bChiWat";
  MediumCon.ThermodynamicState sta_aCon[nChi]=MediumCon.setState_phX(
    ports_aCon.p, noEvent(actualStream(ports_aCon.h_outflow)),
    noEvent(actualStream(ports_aCon.Xi_outflow)))
    if show_T
    "Condenser cooling fluid properties in porta_bCon";
  MediumCon.ThermodynamicState sta_bCon[nChi]=MediumCon.setState_phX(
    ports_bCon.p, noEvent(actualStream(ports_bCon.h_outflow)),
    noEvent(actualStream(ports_bCon.Xi_outflow)))
    if show_T
    "Condenser cooling fluid properties in ports_bCon";

  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{190,-140},{210, -60}}),
    iconTransformation(extent={{390,-1000},{410,-920}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply"
    annotation (Placement(transformation(extent={{190,80},{210,160}}),
        iconTransformation(extent={{390,920},{410,1000}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(max=if allowFlowReversalSou then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid return (e.g. from chillers to cooling towers)"
    annotation (Placement(transformation(extent={{-210,80},{-190,160}}),
        iconTransformation(extent={{-410,920},{-390,1000}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(min=if allowFlowReversalSou then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid supply (e.g. from cooling towers to chillers)"
    annotation (Placement(transformation(extent={{-210,-140},{-190,-60}}),
        iconTransformation(extent={{-410,-1000},{-390,-920}})));
  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
    iconTransformation(extent={{-20,982},{20,1022}})));
protected
  Buildings.Templates.Components.Interfaces.Bus busChi[nChi]
    "Chiller control bus"
    annotation (Placement(transformation(extent={{-20,140},{20,180}}),
                        iconTransformation(extent={{-350,6},{-310,46}})));
  Buildings.Templates.Components.Interfaces.Bus busValChiWatChiIso[nChi]
    if typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
    "Chiller CHW isolation valve control bus" annotation (Placement(
        transformation(extent={{60,140},{100,180}}), iconTransformation(extent=
            {{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValConWatChiIso[nChi]
    if typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
    "Chiller CW isolation valve control bus" annotation (Placement(
        transformation(extent={{-100,140},{-60,180}}), iconTransformation(
          extent={{-466,50},{-426,90}})));
initial equation
  if typ==Buildings.Templates.Components.Types.Chiller.AirCooled then
    assert(not Modelica.Math.BooleanVectors.anyTrue(dat.perChi.use_TConOutForTab),
      "In " + getInstanceName() +
      ": Only use_TConOutForTab=false is supported for air-cooled chiller performance data.");
  end if;
equation
  connect(busChi, bus.chi) annotation (Line(
      points={{0,160},{0,200}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valChiWatChiIso, busValChiWatChiIso) annotation (Line(
      points={{0,200},{0,180},{80,180},{80,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valConWatChiIso, busValConWatChiIso) annotation (Line(
      points={{0,200},{0,180},{-80,180},{-80,160}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(extent={{-200,-240},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-400,-1000},{400,1000}}),
  graphics={
    Line( points={{180,840},{400,840}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5),
    Line(
      points={{180,960},{400,960}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 2,
      points={{180,600},{400,600}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 3,
      points={{180,240},{400,240}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Line(
      visible=nChi >= 4,
      points={{180,-120},{400,-120}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Text( extent={{-151,-1008},{149,-1048}},
          textColor={0,0,255},
          textString="%name"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi>=1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,960}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and nChi >= 1,
      extent={{260,1020},{340,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi >= 2,
      extent={{260,660},{340,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
               and nChi >= 2,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=-90,
          origin={300,600}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi >= 3,
      extent={{260,300},{340,380}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi >= 3,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,240}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
        and nChi >= 4,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-120}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=4,
      extent={{260,-60},{340,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and nChi >= 1,
      extent={{260,1020},{340,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi >= 2,
      extent={{260,660},{340,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
               and nChi >= 3,
          extent={{260,300},{340,380}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=4,
      extent={{260,-60},{340,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
          extent={{180,1000},{-180,800}},
          lineColor={0,0,0},
          lineThickness=1),
    Text(
      extent={{-180,900},{180,860}},
      textColor={0,0,0},
      textString="CHI-1"),
    Rectangle(
          extent={{180,640},{-180,440}},
          lineColor={0,0,0},
          lineThickness=1,
          visible=nChi >= 2),
    Text(
      visible=nChi >= 2,
      extent={{-180,540},{180,500}},
      textColor={0,0,0},
      textString="CHI-2"),
    Line( visible=nChi >= 2,
          points={{180,480},{400,480}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5),
    Rectangle(
      extent={{180,280},{-180,78}},
      lineColor={0,0,0},
      lineThickness=1,
      visible=nChi >= 3),
    Text(
      visible=nChi >= 3,
      extent={{-180,180},{180,140}},
      textColor={0,0,0},
      textString="CHI-3"),
    Line( points={{180,120},{400,120}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nChi >= 3),
    Rectangle(
      visible=nChi >= 4,
      extent={{180,-80},{-180,-280}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi >= 4,
      extent={{-180,-180},{180,-220}},
      textColor={0,0,0},
      textString="CHI-4"),
    Line( points={{180,-240},{400,-240}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=nChi >= 4),
    Line(
      points={{300,1020},{300,960}},
      color={0,0,0},
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 1),
    Line(
      points={{300,660},{300,600}},
      color={0,0,0},
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2),
    Line(
      points={{300,300},{300,240}},
      color={0,0,0},
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 3),
    Line(
      points={{300,-60},{300,-120}},
      color={0,0,0},
      visible=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
            and nChi >= 4),
    Line(
      visible=nChi>=5,
      points={{180,-480},{400,-480}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and nChi>=5,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-480}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and nChi>=5,
      extent={{260,-420},{340,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and nChi >= 5,
      extent={{260,-420},{340,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
      visible=nChi>=5,
      extent={{180,-440},{-180,-640}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi>=5,
      extent={{-180,-540},{180,-580}},
      textColor={0,0,0},
          textString="CHI-5"),
    Line( points={{180,-600},{400,-600}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nChi>=5),
    Line(
      points={{300,-420},{300,-480}},
      color={0,0,0},
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
      and nChi >= 5),
    Line(
      visible=nChi>=6,
      points={{180,-840},{400,-840}},
      color={0,0,0},
      pattern=LinePattern.Solid,
      thickness=5),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and nChi>=6,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={300,-840}),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi>=6,
      extent={{260,-780},{340,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=6,
      extent={{260,-780},{340,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Rectangle(
      visible=nChi>=6,
      extent={{180,-800},{-180,-1000}},
      lineColor={0,0,0},
      lineThickness=1),
    Text(
      visible=nChi>=6,
      extent={{-180,-880},{180,-920}},
      textColor={0,0,0},
          textString="CHI-6"),
    Line( points={{180,-960},{400,-960}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5,
      visible=nChi>=6),
    Line(
      points={{300,-780},{300,-840}},
      color={0,0,0},
      visible=typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      and typValChiWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 6),
    Line(
      visible=nChi >= 1 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,840},{-180,840}},
      color={0,0,0},
      thickness=5),
    Line(
      visible=nChi >= 1 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,960},{-180,960}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 2 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,600},{-180,600}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 3 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,240},{-180,240}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Line(
      visible=nChi >= 4 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-120},{-180,-120}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 1,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,960}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and nChi >= 1,
      extent={{-320,1020},{-240,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi >= 2,
      extent={{-318,660},{-238,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,600}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
            and nChi >= 3,
      extent={{-320,300},{-240,380}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 3,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,240}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 4,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-120}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=4,
      extent={{-320,-60},{-240,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and nChi >= 1,
      extent={{-320,1020},{-240,1100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi >= 2,
      extent={{-318,660},{-238,740}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
               and nChi >= 3,
          extent={{-320,300},{-240,380}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=4,
      extent={{-320,-60},{-240,20}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( visible=nChi >= 2 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
          points={{-400,480},{-180,480}},
          color={0,0,0},
          thickness=5),
    Line( points={{-400,120},{-180,120}},
          color={0,0,0},
          thickness=5,
          visible=nChi >= 3 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line( points={{-400,-240},{-180,-240}},
          color={0,0,0},
          thickness=5,
          visible=nChi >= 4 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line(
      points={{-280,1020},{-280,960}},
      color={0,0,0},
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 1),
    Line(
      points={{-280,660},{-280,600}},
      color={0,0,0},
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 2),
    Line( points={{-280,300},{-280,240}},
          color={0,0,0},
          visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
               and nChi >= 3),
    Line(
      points={{-280,-60},{-280,-120}},
      color={0,0,0},
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 4),
    Line(
      visible=nChi>=5 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-480},{-180,-480}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 5,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-480}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition and nChi>=5,
      extent={{-320,-420},{-240,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating and nChi >= 5,
      extent={{-320,-420},{-240,-340}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( points={{-400,-600},{-180,-600}},
      color={0,0,0},
      thickness=5,
      visible=nChi>=5),
    Line(
      points={{-280,-420},{-280,-480}},
      color={0,0,0},
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
            and nChi >= 5),
    Line(
      visible=nChi>=6 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled,
      points={{-400,-840},{-180,-840}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=5),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
      and nChi >= 6,
      extent={{-100,-100},{100,100}},
      fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90,
      origin={-280,-840}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
        typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
        and nChi>=6,
      extent={{-320,-780},{-240,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso== Buildings.Templates.Components.Types.Valve.TwoWayModulating
        and nChi>=6,
      extent={{-320,-780},{-240,-700}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line(
      points={{-400,-960},{-180,-960}},
      color={0,0,0},
      thickness=5,
      visible=nChi >= 6 and typ == Buildings.Templates.Components.Types.Chiller.WaterCooled),
    Line(
      points={{-280,-780},{-280,-840}},
      color={0,0,0},
      visible=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and
typValConWatChiIso <> Buildings.Templates.Components.Types.Valve.None
        and nChi >= 6),
    Bitmap(
          extent={{-60,1000},{60,1120}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 1),
    Bitmap(
          extent={{-60,640},{60,760}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 2),
    Bitmap(
          extent={{-60,280},{60,400}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 3),
    Bitmap(
          extent={{-60,-80},{60,40}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 4),
    Bitmap(
          extent={{-60,-440},{60,-320}},
          fileName=
          "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
          visible=nChi >= 5),
    Bitmap(
      extent={{-60,-800},{60,-680}},
      fileName=
      "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg",
      visible=nChi >= 6)}


),  Documentation(info="<html>
<p>
This partial class provides a standard interface for chiller group models.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available for all
models inheriting from this interface.
</p>
<ul>
<li>
Sub-bus <code>bus.chi=busChi</code> storing all signals dedicated
to each unit, with a dimensionality of one
<ul>
<li>
See the class
<a href=\"modelica://Buildings.Templates.Components.Chillers.Compression\">
Buildings.Templates.Components.Chillers.Compression</a>
for the control signals typically included in this sub-bus.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialChillerGroup;
