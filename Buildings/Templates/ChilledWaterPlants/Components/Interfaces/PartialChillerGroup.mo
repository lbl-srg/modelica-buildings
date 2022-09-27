within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
model PartialChillerGroup "Interface class for chiller group"
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid";

  parameter Integer nChi(final min=0)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumConWat(
    start=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered)
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat(
    start=Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant)
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea(
    start=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco(
    start=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  final parameter Boolean enaTypValChiWatIso=
    typArrPumChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered
    "Enable choices of chiller CHW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CHW isolation valve"
    annotation (
    choices(choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating "Two-way modulating valve"),
    Dialog(enable=enaTypValChiWatIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValChiWatIso=
    if enaTypValChiWatIso then typValChiWatIso_select
    else Buildings.Templates.Components.Types.Valve.None
    "Type of chiller CHW isolation valve";
  final parameter Boolean enaTypValConWatIso=
    typArrPumConWat==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered
    and (typCtrHea==Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None or
    typCtrSpePumConWat<>Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant
      and typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Enable choices of chiller CW isolation valve type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.Components.Types.Valve typValConWatIso_select(
    start=Buildings.Templates.Components.Types.Valve.TwoWayModulating)
    "Type of chiller CW isolation valve"
    annotation (
    choices(choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition "Two-way two-position valve",
    choice=Buildings.Templates.Components.Types.Valve.TwoWayModulating "Two-way modulating valve"),
    Dialog(enable=enaTypValConWatIso));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.Valve typValConWatIso=
    if (typChi<>Buildings.Templates.Components.Types.Chiller.WaterCooled or
    typArrPumConWat==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated)
    then Buildings.Templates.Components.Types.Valve.None
    elseif enaTypValConWatIso then typValConWatIso_select
    else Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Type of chiller CW isolation valve";

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup dat(
    final typChi=typChi,
    final nChi=nChi)
    "Parameter record for chiller group";
  /* FIXME DS#SR00937490-01
  Propagation of per from ChillerGroup is removed temporarily due to an issue in Dymola.
  A local assignment in Chiller component is implemented instead.
  */
  final parameter Buildings.Templates.Components.Data.Chiller datChi[nChi](
    final typ=fill(typChi, nChi),
    final mChiWat_flow_nominal=dat.mChiWatChi_flow_nominal,
    final mCon_flow_nominal=dat.mConChi_flow_nominal,
    final cap_nominal=dat.capChi_nominal,
    final dpChiWat_nominal=if typValChiWatIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpChiWatChi_nominal else fill(0, nChi),
    final dpCon_nominal=if typValConWatIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpConChi_nominal else fill(0, nChi),
    final TChiWatSup_nominal=dat.TChiWatChiSup_nominal,
    final TChiWatSup_max=dat.TChiWatChiSup_max,
    final TConEnt_nominal=dat.TConChiEnt_nominal,
    final TConEnt_min=dat.TConChiEnt_min,
    final TConEnt_max=dat.TConChiEnt_max,
    final PLRUnl_min=dat.PLRUnlChi_min,
    final PLR_min=dat.PLRChi_min)
    "Parameter record of each chiller";
  final parameter Buildings.Templates.Components.Data.Valve datValChiWatChiIso[nChi](
    final typ=fill(typValChiWatIso, nChi),
    final m_flow_nominal=mChiWatChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=if typValChiWatIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpChiWatChi_nominal else fill(0, nChi))
    "Parallel chillers CHW bypass valve parameters"
    annotation (Dialog(enable=false));
  final parameter Buildings.Templates.Components.Data.Valve datValConWatChiIso[nChi](
    final typ=fill(typValConWatIso, nChi),
    final m_flow_nominal=mConChi_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nChi),
    dpFixed_nominal=if typValConWatIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpConChi_nominal else fill(0, nChi))
    "Series chillers CHW bypass valve parameters"
    annotation (Dialog(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi]=
    dat.mChiWatChi_flow_nominal
    "CHW mass flow rate for each chiller";
  final parameter Modelica.Units.SI.MassFlowRate mConChi_flow_nominal[nChi]=
    dat.mConChi_flow_nominal
    "Condenser cooling fluid mass flow rate for each chiller";
  final parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi]=
    dat.capChi_nominal
    "Cooling capacity for each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi]=
    dat.dpChiWatChi_nominal
    "CHW pressure drop for each chiller";
  final parameter Modelica.Units.SI.PressureDifference dpConChi_nominal[nChi]=
    dat.dpConChi_nominal
    "CW pressure drop for each chiller";
  final parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi]=
    dat.TChiWatChiSup_nominal
    "CHW supply temperature for each chiller";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply"
    annotation (Placement(transformation(extent={{190,80},{210,160}}),
    iconTransformation(extent={{190,460},{210,540}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid return (e.g. from chillers to cooling towers)"
    annotation (Placement(transformation(extent={{-210,80},{-190,160}}),
        iconTransformation(extent={{-210,460},{-190,540}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aCon[nChi](
    redeclare each final package Medium = MediumCon,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumCon.h_default, nominal=MediumCon.h_default))
    "Condenser cooling fluid supply (e.g. from cooling towers to chillers)"
    annotation (Placement(transformation(extent={{-210,-140},{-190,-60}}),
        iconTransformation(extent={{-210,-540},{-190,-460}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nChi](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{190,-140},{210, -60}}),
    iconTransformation(extent={{190,-540},{210,-460}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,180},{20,220}}),
    iconTransformation(extent={{-20,580},{20,620}})));
  annotation (Diagram(coordinateSystem(extent={{-200,-180},{200,200}})),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-600},{200,600}}), graphics={
        Text(
          extent={{-149,-614},{151,-654}},
          textColor={0,0,255},
          textString="%name"),
    Rectangle(extent={{-200,600},{200,-600}},
            lineColor={28,108,200})}));
end PartialChillerGroup;
