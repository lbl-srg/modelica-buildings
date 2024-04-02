within Buildings.Templates.Plants.HeatPumps.Interfaces;
partial model PartialHeatPumpPlant
  "Interface class for heat pump plant"
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation (Dialog(enable=have_heaWat),
  __ctrlFlow(enable=false));
  replaceable package MediumHotWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "DHW medium"
    annotation (Dialog(enable=have_hotWat),
  __ctrlFlow(enable=false));
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium"
    annotation (Dialog(enable=have_chiWat),
  __ctrlFlow(enable=false));
  /*
  Derived classes representing AWHP shall use:
  redeclare final package MediumSou = MediumAir
  */
    replaceable package MediumSou=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium"
    annotation (Dialog(enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater),
      __ctrlFlow(enable=false));
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium"
    annotation (Dialog(enable=typ==Buildings.Templates.Components.Types.HeatPump.AirToWater),
  __ctrlFlow(enable=false));
  // The current implementation only supports plants that provide HHW.
  final parameter Boolean have_heaWat=true
    "Set to true if the plant provides HW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  // RFE: To be exposed for templates that include optional DHW service.
  final parameter Boolean have_hotWat=false
    "Set to true if the plant provides DHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  // RFE(AntoineGautier): Add option for sidestream HRC. Always excluded for now.
  final parameter Boolean have_hrc(
    start=false)=false
    "Set to true for plants with a sidestream heat recovery chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
    enable=have_heaWat and have_chiWat));
  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Type of heat pump"
    annotation (Evaluate=true,
    Dialog(group="Heat pumps"));
  parameter Buildings.Templates.Plants.HeatPumps.Configuration.HeatPumpPlant cfg(
    final cpChiWat_default=cpChiWat_default,
    final cpHeaWat_default=cpHeaWat_default,
    final cpSou_default=cpSou_default,
    final have_chiWat=have_chiWat,
    final have_heaWat=have_heaWat,
    final have_hrc=have_hrc,
    final have_hotWat=have_hotWat,
    final have_pumHeaWatPriVar=have_pumHeaWatPriVar,
    final have_pumChiWatPriVar=have_pumChiWatPriVar,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final have_valChiWatMinByp=have_valChiWatMinByp,
    final have_valHeaWatMinByp=have_valHeaWatMinByp,
    final have_valHpInlIso=have_valHpInlIso,
    final have_valHpOutIso=have_valHpOutIso,
    final is_rev=is_rev,
    final nHp=nHp,
    final nPumChiWatPri=nPumChiWatPri,
    final nPumChiWatSec=nPumChiWatSec,
    final nPumHeaWatPri=nPumHeaWatPri,
    final nPumHeaWatSec=nPumHeaWatSec,
    final rhoChiWat_default=rhoChiWat_default,
    final rhoHeaWat_default=rhoHeaWat_default,
    final rhoSou_default=rhoSou_default,
    final typ=typ,
    final typArrPumPri=typArrPumPri,
    final typDis=typDis,
    final typPumChiWatPri=typPumChiWatPri,
    final typPumHeaWatPri=typPumHeaWatPri,
    final typPumChiWatSec=typPumChiWatSec,
    final typPumHeaWatSec=typPumHeaWatSec,
    final typCtl=ctl.typ,
    final nAirHan=ctl.nAirHan,
    final nEquZon=ctl.nEquZon,
    final have_senDpHeaWatRemWir=ctl.have_senDpHeaWatRemWir,
    final nSenDpHeaWatRem=ctl.nSenDpHeaWatRem,
    final have_senDpChiWatRemWir=ctl.have_senDpChiWatRemWir,
    final nSenDpChiWatRem=ctl.nSenDpChiWatRem,
    final have_inpSch=ctl.have_inpSch)
    "Configuration parameters"
    annotation (__ctrlFlow(enable=false));
  parameter Buildings.Templates.Plants.HeatPumps.Data.HeatPumpPlant dat(
    cfg=cfg)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{-120,360},{-100,380}})));
  // RFE(AntoineGautier): Allow specifying subset of units dedicated to HW, CHW or DHW production.
  parameter Integer nHp(
    final min=1,
    start=1)
    "Total number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Heat pumps"));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation (Evaluate=true,
    Dialog(group="Heat pumps"));
  // Plants with AWHP.
  // RFE(AntoineGautier): Add constant primary-only option.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDis_select1(
    start=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)=
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
    "Type of distribution system"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.AirToWater),
    choices(
      choice=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
      "Constant primary - Variable secondary centralized"));
  // Plants with WWHP.
  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDis_select2(
    start=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)
    "Type of distribution system"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDis=
    if typ == Buildings.Templates.Components.Types.HeatPump.AirToWater then typDis_select1
    else typDis_select2
    "Type of distribution system"
    annotation (Evaluate=true);
  final parameter Boolean have_valHpInlIso=if not have_chiWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated then false
    else true
    "Set to true for isolation valves at HP inlet"
    annotation (Evaluate=true);
  final parameter Boolean have_valHpOutIso=if not have_chiWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated then false
    elseif nHp == 1 then false elseif have_pumChiWatPriDed then false else true
    "Set to true for isolation valves at HP outlet"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumPri=
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Type of primary pump arrangement"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  final parameter Boolean have_bypHeaWatFix=
    have_heaWat and typDis <> Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
    and typDis <> Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    "Set to true if the HW loop has a fixed bypass"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  final parameter Boolean have_valHeaWatMinByp=have_heaWat and typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    "Set to true if the HW loop has a minimum flow bypass valve"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  // Constant primary plants with dedicated primary pumps.
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri_select1(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)=
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Type of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_heaWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated
        and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)),
    choices(
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
      "Constant speed pump specified separately",
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      "Variable speed pump specified separately"));
  // Constant primary plants with headered primary pumps.
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri_select2(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)=
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Type of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_heaWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)),
    choices(choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
      "Constant speed pump specified separately",
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      "Variable speed pump specified separately"));
  // Variable primary plants with headered primary pumps require variable speed pumps.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumHeaWatPri=
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)
    then typPumHeaWatPri_select1 elseif have_heaWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Headered and (typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only or typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)
    then typPumHeaWatPri_select2 elseif have_heaWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated and (typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only or typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2) then
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    elseif have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)
    then Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable else
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Type of primary HW pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumHeaWatPriVar=
    typPumHeaWatPri == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumHeaWatPri_select(
    final min=0,
    start=0)=nHp
    "Number of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_heaWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Integer nPumHeaWatPri=if have_heaWat then (if typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Headered then nPumHeaWatPri_select
    else nHp) else 0
    "Number of primary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  // RFE: Only centralized secondary HW pumps are currently supported for primary-secondary plants.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec=
    if have_heaWat and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)
    then Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    else Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Type of secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary HW loop"));
  // Primary-secondary plants.
  parameter Integer nPumHeaWatSec_select(
    final min=0)=nHp
    "Number of secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary HW loop",
      enable=have_heaWat and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)));
  final parameter Integer nPumHeaWatSec(
    final min=0)=if not have_heaWat or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    then 0 else nPumHeaWatSec_select
    "Number of secondary HW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary HW loop"));
  // Plants with dedicated primary pumps.
  parameter Boolean have_pumChiWatPriDed_select(
    start=false)=false
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_chiWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  final parameter Boolean have_pumChiWatPriDed=if have_chiWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Dedicated then have_pumChiWatPriDed_select
    else false
    "Set to true for plants with separate dedicated primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  final parameter Boolean have_bypChiWatFix=
    have_chiWat and typDis <> Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
    and typDis <> Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    "Set to true if the CHW loop has a fixed bypass"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  final parameter Boolean have_valChiWatMinByp=have_chiWat and typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    "Set to true if the CHW loop has a minimum flow bypass valve"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  // Constant primary plants with separate dedicated primary CHW pumps.
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumChiWatPri_select1(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)=
    typPumHeaWatPri
    "Type of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_pumChiWatPriDed and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)));
  // Constant primary plants with headered primary pumps.
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumChiWatPri_select2(
    start=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable)=
    typPumHeaWatPri
    "Type of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_chiWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
        and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)),
    choices(choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
      "Constant speed pump specified separately",
    choice=Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      "Variable speed pump specified separately"));
  // Variable primary plants with headered primary CHW pumps require variable speed pumps.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary typPumChiWatPri=
    if have_pumChiWatPriDed and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)
    then typPumChiWatPri_select1 elseif have_chiWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Headered and (typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Only or typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2)
    then typPumChiWatPri_select2 elseif have_pumChiWatPriDed and (typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only or typDis ==
    Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2) then
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    elseif have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)
    then Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable else
    Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    "Type of primary CHW pumps"
    annotation (Evaluate=true);
  final parameter Boolean have_pumChiWatPriVar=
    typPumChiWatPri == Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
    "Set to true for variable speed primary CHW pumps"
    annotation (Evaluate=true);
  // Plants with headered primary CHW pumps.
  parameter Integer nPumChiWatPri_select(
    final min=0,
    start=0)=nHp
    "Number of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop",
      enable=have_chiWat and typArrPumPri==Buildings.Templates.Components.Types.PumpArrangement.Headered));
  final parameter Integer nPumChiWatPri=if have_chiWat and typArrPumPri ==
    Buildings.Templates.Components.Types.PumpArrangement.Headered then nPumChiWatPri_select
    elseif have_pumChiWatPriDed then nHp else 0
    "Number of primary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Primary loop"));
  // RFE: Currently, only centralized secondary CHW pumps are supported for primary-secondary plants.
  final parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumChiWatSec=
    if have_chiWat and (typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
    or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)
    then Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    else Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    "Type of secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary CHW loop"));
  parameter Integer nPumChiWatSec_select(
    final min=0)=nHp
    "Number of secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary CHW loop",
      enable=have_chiWat and (typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
        or typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2)));
  final parameter Integer nPumChiWatSec(
    final min=0)=if not have_chiWat or typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only
    then 0 else nPumChiWatSec_select
    "Number of secondary CHW pumps"
    annotation (Evaluate=true,
    Dialog(group="Secondary CHW loop"));
  // Design and operating parameters.
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatPri_flow_nominal=if have_heaWat
    then dat.hp.mHeaWatHp_flow_nominal * nHp else 0
    "Primary HW mass flow rate"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=if have_heaWat
    then (if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    then mHeaWatPri_flow_nominal else sum(dat.pumHeaWatSec.m_flow_nominal)) else 0
    "HW mass flow rate (total, distributed to consumers)"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.HeatFlowRate capHea_nominal=if have_heaWat
    then abs(dat.hp.capHeaHp_nominal) * nHp else 0
    "Heating capacity - All units";
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
    capHea_nominal
    "Heating heat flow rate - All units";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=dat.ctl.THeaWatSup_nominal
    "Maximum HW supply temperature";
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - QHea_flow_nominal / cpHeaWat_default /
    mHeaWat_flow_nominal
    "HW return temperature";
  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=if have_chiWat
    then dat.hp.mChiWatHp_flow_nominal * nHp else 0
    "Primary CHW mass flow rate"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=if have_chiWat
    then (if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.None
    then mChiWatPri_flow_nominal else sum(dat.pumChiWatSec.m_flow_nominal)) else 0
    "CHW mass flow rate - Total, distributed to consumers"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal=if have_chiWat
    then abs(dat.hp.capCooHp_nominal) * nHp else 0
    "Cooling capacity - All units";
  final parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=-
    capCoo_nominal
    "Cooling heat flow rate - All units";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=dat.ctl.TChiWatSup_nominal
    "Minimum CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=if is_rev
    then TChiWatSup_nominal - QCoo_flow_nominal / cpChiWat_default /
    mChiWat_flow_nominal else Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature TSouHea_nominal=dat.hp.TSouHeaHp_nominal
    "OAT or source fluid supply temperature (evaporator entering) in heating mode - Each heat pump";
  final parameter Modelica.Units.SI.Temperature TSouCoo_nominal=dat.hp.TSouCooHp_nominal
    "OAT or source fluid supply temperature (evaporator entering) in cooling mode - Each heat pump";
  // Dynamics and miscellaneous parameterss.
  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics",group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Boolean show_T=false
    "= true, if actual temperature at port is computed"
    annotation (Dialog(tab="Advanced",group="Diagnostics"));
  final parameter MediumHeaWat.Density rhoHeaWat_default=MediumHeaWat.density(staHeaWat_default)
    "HW default density"
    annotation (Evaluate=true);
  final parameter MediumHeaWat.SpecificHeatCapacity cpHeaWat_default=
    MediumHeaWat.specificHeatCapacityCp(staHeaWat_default)
    "HW default specific heat capacity"
    annotation (Evaluate=true);
  final parameter MediumHeaWat.ThermodynamicState staHeaWat_default=MediumHeaWat.setState_pTX(
    T=THeaWatSup_nominal,
    p=MediumHeaWat.p_default,
    X=MediumHeaWat.X_default)
    "HW default state"
    annotation (Evaluate=true);
  final parameter MediumChiWat.Density rhoChiWat_default=MediumChiWat.density(staChiWat_default)
    "CHW default density"
    annotation (Evaluate=true);
  final parameter MediumChiWat.SpecificHeatCapacity cpChiWat_default=
    MediumChiWat.specificHeatCapacityCp(staChiWat_default)
    "CHW default specific heat capacity"
    annotation (Evaluate=true);
  final parameter MediumChiWat.ThermodynamicState staChiWat_default=MediumChiWat.setState_pTX(
    T=TChiWatSup_nominal,
    p=MediumChiWat.p_default,
    X=MediumChiWat.X_default)
    "CHW default state"
    annotation (Evaluate=true);
  /*
  Source fluid default state = heating mode:
  - Impact of difference between TSouHea_nominal and TSouCoo_nominal on cp is about 0.5 %.
  - Impact of difference between TSouHea_nominal and TSouCoo_nominal on rho is about 2 %,
    with rhoSouHea_nominal > rhoSouCoo_nominal, so conservative for pump sizing.
  */
  final parameter MediumSou.Density rhoSou_default=MediumSou.density(staSou_default)
    "Source fluid default density"
    annotation (Evaluate=true);
  final parameter MediumSou.SpecificHeatCapacity cpSou_default=MediumSou.specificHeatCapacityCp(staSou_default)
    "Source fluid default specific heat capacity"
    annotation (Evaluate=true);
  final parameter MediumSou.ThermodynamicState staSou_default=MediumSou.setState_pTX(
    T=TSouHea_nominal,
    p=MediumSou.p_default,
    X=MediumSou.X_default)
    "Source fluid default state"
    annotation (Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium=MediumHeaWat,
    m_flow(
      final min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_heaWat
    "HW return"
    annotation (Placement(transformation(extent={{590,-370},{610,-350}}),
      iconTransformation(extent={{190,-190},{210,-170}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium=MediumHeaWat,
    m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    h_outflow(
      start=MediumHeaWat.h_default,
      nominal=MediumHeaWat.h_default))
    if have_heaWat
    "HW supply"
    annotation (Placement(transformation(extent={{590,-290},{610,-270}}),
      iconTransformation(extent={{190,-110},{210,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium=MediumChiWat,
    m_flow(
      final min=if allowFlowReversal then - Modelica.Constants.inf else 0),
    h_outflow(
      start=MediumChiWat.h_default,
      nominal=MediumChiWat.h_default))
    if have_chiWat
    "CHW return"
    annotation (Placement(transformation(extent={{590,-10},{610,10}}),
      iconTransformation(extent={{190,-50},{210,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium=MediumChiWat,
    m_flow(
      max=if allowFlowReversal then + Modelica.Constants.inf else 0),
    h_outflow(
      start=MediumChiWat.h_default,
      nominal=MediumChiWat.h_default))
    if have_chiWat
    "CHW supply"
    annotation (Placement(transformation(extent={{590,70},{610,90}}),
      iconTransformation(extent={{190,30},{210,50}})));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={-600,320}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-200,180})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[cfg.nAirHan]
    if cfg.nAirHan > 0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=-90,
      origin={600,340}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={200,180})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[cfg.nEquZon]
    if cfg.nEquZon > 0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=-90,
      origin={600,300}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=-90,origin={200,120})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather bus"
    annotation (Placement(transformation(extent={{-20,380},{20,420}}),
      iconTransformation(extent={{-20,180},{20,220}})));
  replaceable Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController ctl
    constrainedby
    Buildings.Templates.Plants.HeatPumps.Components.Interfaces.PartialController(
      final cfg=cfg,
      final dat=dat.ctl)
    "Plant controller"
    annotation (
    Dialog(group="Controls"),
    Placement(transformation(extent={{460,310},{480,330}})));
  // Miscellaneous
  Buildings.Fluid.Sources.Outside out(
    redeclare replaceable package Medium=Buildings.Media.Air,
    nPorts=1)
    "Outdoor air conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={0,380})));
  Buildings.Fluid.Sensors.Temperature TOut(
    redeclare replaceable package Medium=Buildings.Media.Air,
    warnAboutOnePortConnection=false)
    "OA temperature"
    annotation (Placement(transformation(extent={{-30,370},{-10,390}})));
initial equation
  if typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated then
    assert(nPumHeaWatPri == nHp, "In " + getInstanceName() + ": " +
      "In case of dedicated primary HW pumps, the number pumps (=" + String(nPumHeaWatPri) +
      ") must be equal to the number of heat pumps (=" + String(nHp) + ").");
  end if;
  if have_pumChiWatPriDed then
    assert(nPumChiWatPri == nHp, "In " + getInstanceName() + ": " +
      "In case of separate dedicated primary CHW pumps, the number pumps (=" +
      String(nPumChiWatPri) + ") must be equal to the number of heat pumps (=" +
      String(nHp) + ").");
  end if;
equation
  /* Control point connection - start */
                                         connect(TOut.T, bus.TOut);
  /* Control point connection - stop */
                                       connect(bus, ctl.bus)
    annotation (Line(points={{-600,320},{460,320}}, color={255,204,51},thickness=0.5));
  connect(ctl.busAirHan, busAirHan)
    annotation (Line(points={{480,326},{580,326},{580,340},{600,340}},   color={255,204,51},thickness=0.5));
  connect(ctl.busEquZon, busEquZon)
    annotation (Line(points={{480,314},{580,314},{580,300},{600,300}},   color={255,204,51},thickness=0.5));
  connect(busWea, out.weaBus)
    annotation (Line(points={{0,400},{0,390},{0.2,390}},color={255,204,51},thickness=0.5));
  connect(out.ports[1], TOut.port)
    annotation (Line(points={{0,370},{-20,370}},
                                               color={0,127,255}));
  annotation (
    defaultComponentName="plaHp",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}}),
      graphics={
        Line(
          points={{20,-100},{20,-180},{200,-180}},
          color={28,108,200},
          thickness=5,
          pattern=LinePattern.Dash,
          visible=have_chiWat),
        Line(
          points={{0,40},{0,-100},{-40,-100}},
          color={28,108,200},
          thickness=5,
          origin={160,-100},
          rotation=-90,
          visible=have_chiWat),
        Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-212},{149,-252}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{20,-40},{20,-100},{-60,-100}},
          color={238,46,47},
          pattern=LinePattern.Dash,
          thickness=5),
        Line(
          points={{-60,60},{20,60},{20,-40}},
          color={238,46,47},
          thickness=5,
          pattern=LinePattern.Dash),
        Line(
          points={{100,-100},{100,-180}},
          color={238,46,47},
          thickness=5,
          visible=have_heaWat),
        Rectangle(
          extent={{-160,130},{-60,30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-130,100},{-90,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-122,96},{-126,68}},
          color={0,0,0}),
        Line(
          points={{-98,96},{-94,68}},
          color={0,0,0}),
        Rectangle(
          extent={{-160,-32},{-60,-132}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-130,-62},{-90,-102}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-122,-66},{-126,-94}},
          color={0,0,0}),
        Line(
          points={{-98,-66},{-94,-94}},
          color={0,0,0}),
        Line(
          points={{100,38},{100,-42}},
          color={28,108,200},
          thickness=5,
          visible=have_chiWat),
        Line(
          points={{0,40},{0,-100}},
          color={28,108,200},
          thickness=5,
          visible=have_chiWat,
          origin={160,40},
          rotation=-90),
        Line(
          points={{0,40},{0,-140}},
          color={28,108,200},
          thickness=5,
          visible=have_chiWat,
          origin={160,-40},
          rotation=-90,
          pattern=LinePattern.Dash),
        Line(
          points={{-60,-60},{60,-60},{60,40}},
          color={238,46,47},
          thickness=5),
        Line(
          points={{-60,100},{60,100},{60,40}},
          color={238,46,47},
          thickness=5),
        Ellipse(
          extent={{-40,-40},{0,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-20,-41},{-20,-79},{-1,-60},{-20,-41}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-40,120},{0,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-20,119},{-20,81},{-1,100},{-20,119}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Line(
          points={{0,40},{0,-100},{-40,-100}},
          color={238,46,47},
          thickness=5,
          visible=have_heaWat,
          origin={160,-100},
          rotation=-90),
        Line(
          points={{0,40},{0,-140},{-80,-140}},
          color={238,46,47},
          thickness=5,
          visible=have_heaWat,
          pattern=LinePattern.Dash,
          origin={160,-180},
          rotation=-90),
        Ellipse(
          extent={{130,-80},{170,-120}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          startAngle=0,
          endAngle=360,
          visible=have_heaWat and typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None),
        Polygon(
          points={{150,-81},{150,-119},{169,-100},{150,-81}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=have_heaWat and typPumHeaWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None),
        Ellipse(
          extent={{130,60},{170,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          startAngle=0,
          endAngle=360,
          visible=have_chiWat and typPumChiWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None),
        Polygon(
          points={{150,59},{150,21},{169,40},{150,59}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=have_chiWat and typPumChiWatSec<>Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-600,-400},{600,400}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This partial class provides a standard interface for heat pump
plant models.
</p>
</html>"));
end PartialHeatPumpPlant;
