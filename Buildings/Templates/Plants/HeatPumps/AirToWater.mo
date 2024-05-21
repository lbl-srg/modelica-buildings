within Buildings.Templates.Plants.HeatPumps;
model AirToWater
  "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumChiWat=MediumHeaWat,
    redeclare final package MediumSou=MediumAir,
    redeclare Buildings.Templates.Plants.HeatPumps.Components.Controls.AirToWater ctl(ctl(
      final yPumHeaWatPriSet=if is_dpBalYPumSetCal then yPumHeaWatPriSet else dat.ctl.yPumHeaWatPriSet,
      final yPumChiWatPriSet=if is_dpBalYPumSetCal then yPumChiWatPriSet else dat.ctl.yPumChiWatPriSet)),
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=have_chiWat,
    final cfg(
      final typMod=hp.typMod));
  parameter Boolean is_dpBalYPumSetCal(start=false)=false
    "Set to true to automatically size balancing valves or evaluate pump speed providing design flow"
    annotation(Evaluate=true, Dialog(tab="Advanced",
      enable=typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2));
  // The check valve pressure drop is scaled for configurations with common dedicated CHW and HW pumps.
  final parameter Modelica.Units.SI.PressureDifference dpValCheHeaWat_nominal=
    dat.dpValCheHeaWat_nominal * (hp.mHeaWatHp_flow_nominal / max(dat.pumHeaWatPri.m_flow_nominal))^2
    "Primary HW pump check valve pressure drop at design HW flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpValCheChiWat_nominal=
    if have_chiWat then (
    if typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
    then dat.dpValCheHeaWat_nominal * (hp.mChiWatHp_flow_nominal / max(dat.pumHeaWatPri.m_flow_nominal))^2
    else dat.dpValCheChiWat_nominal)
    else 0
    "Primary (CHW or common HW and CHW) pump check valve pressure drop at design CHW flow rate";
  final parameter Modelica.Units.SI.PressureDifference dpBalHeaWatHp_nominal=
    if is_dpBalYPumSetCal
      and typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
    then Buildings.Templates.Utilities.computeBalancingPressureDrop(
      m_flow_nominal=hp.mHeaWatHp_flow_nominal,
      dp_nominal=hp.dpHeaWatHp_nominal + max(valIso.dpValveHeaWat_nominal) * (
        (if have_valHpInlIso then 1 else 0) + (if have_valHpOutIso then 1 else 0))
        + dpValCheHeaWat_nominal,
      datPum=dat.pumHeaWatPriSin[1])
    else dat.dpBalHeaWatHp_nominal
    "HP HW balancing valve pressure drop at design HW flow";
  final parameter Modelica.Units.SI.PressureDifference dpBalChiWatHp_nominal=
    if is_dpBalYPumSetCal
      and (typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
      or have_chiWat and not have_pumChiWatPriDed and
      typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant)
    then Buildings.Templates.Utilities.computeBalancingPressureDrop(
      m_flow_nominal=hp.mChiWatHp_flow_nominal,
      dp_nominal=hp.dpChiWatHp_nominal + max(valIso.dpValveChiWat_nominal) * (
        (if have_valHpInlIso then 1 else 0) + (if have_valHpOutIso then 1 else 0))
        + dpValCheChiWat_nominal,
      datPum=if cfg.typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant
        then dat.pumChiWatPriSin[1] else dat.pumHeaWatPriSin[1])
    else dat.dpBalChiWatHp_nominal
    "HP CHW balancing valve pressure drop at design CHW flow";
  parameter Real yPumHeaWatPriSet(
    final fixed=false,
    final max=1,
    final min=0,
    start=1,
    final unit="1")
    "Primary pump speed providing design heat pump flow in heating mode"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor"));
  parameter Real yPumChiWatPriSet(
    final fixed=false,
    final max=1,
    final min=0,
    start=1,
    final unit="1")
    "Primary pump speed providing design heat pump flow in cooling mode"
    annotation (Dialog(group="Information provided by testing, adjusting, and balancing contractor"));
  // Heat pumps, dedicated primary pumps and isolation valves
  // The handling of HP pressure drop is accounted for within the isolation valve component.
  Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater hp(
    redeclare final package MediumHeaWat=MediumHeaWat,
    redeclare final package MediumAir=MediumAir,
    final nHp=nHp,
    final is_rev=is_rev,
    final energyDynamics=energyDynamics,
    final have_dpChiHeaWatHp=false,
    final have_dpSou=false,
    final dat=dat.hp,
    final allowFlowReversal=allowFlowReversal,
    final allowFlowReversalSou=false)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-540,-210},{-60,-130}})));
  Components.PumpsPrimaryDedicated pumPri(
    redeclare final package Medium=MediumHeaWat,
    final nHp=nHp,
    final typArrPumPri=typArrPumPri,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final have_pumHeaWatPriVar=have_pumHeaWatPriVar,
    final have_pumChiWatPriVar=have_pumChiWatPriVar,
    final datPumHeaWat=dat.pumHeaWatPri,
    final datPumChiWat=dat.pumChiWatPri,
    final dpValCheHeaWat_nominal=fill(dat.dpValCheHeaWat_nominal, nPumHeaWatPri),
    final dpValCheChiWat_nominal=fill(dat.dpValCheChiWat_nominal, nPumChiWatPri),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Dedicated primary pumps"
    annotation (Placement(transformation(extent={{-540,-130},{-60,-50}})));
  Components.ValvesIsolation valIso(
    redeclare final package Medium=MediumHeaWat,
    final nHp=nHp,
    final have_chiWat=have_chiWat,
    final have_valHpInlIso=have_valHpInlIso,
    final have_valHpOutIso=have_valHpOutIso,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final mHeaWatHp_flow_nominal=fill(dat.hp.mHeaWatHp_flow_nominal, nHp),
    final dpHeaWatHp_nominal=fill(dat.hp.dpHeaWatHp_nominal, nHp),
    final dpBalHeaWatHp_nominal=fill(dpBalHeaWatHp_nominal, nHp),
    final mChiWatHp_flow_nominal=fill(dat.hp.mChiWatHp_flow_nominal, nHp),
    final dpBalChiWatHp_nominal=fill(dpBalChiWatHp_nominal, nHp),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    linearized=linearized)
    "Heat pump isolation valves"
    annotation (Placement(transformation(extent={{-540,-50},{-60,90}})));
  // Primary CHW loop
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumChiWat,
    final dat=dat.pumChiWatPri,
    final dpValChe_nominal=fill(dpValCheChiWat_nominal, nPumChiWatPri),
    final nPum=nPumChiWatPri,
    final have_var=have_pumChiWatPriVar,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_chiWat and typArrPumPri
     == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Primary CHW supply pipe - Plant with dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat
    "Primary CHW volume flow rate"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypSup(
    redeclare final package Medium=MediumChiWat,
    final tau=tau,
    final m_flow_nominal=mChiWatPri_flow_nominal * {1, - 1, - 1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving) if have_chiWat
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={180,80})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Primary CHW supply temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,80})));
  Buildings.Templates.Components.Routing.Junction junChiWatBypRet(
    redeclare final package Medium=MediumChiWat,
    final tau=tau,
    final m_flow_nominal=mChiWatPri_flow_nominal * {1, - 1, 1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={180,0})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriRet(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatPriRet,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Primary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={60,0})));
  Buildings.Templates.Components.Actuators.Valve valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final dat=dat.valChiWatMinByp,
    final typ=if have_valChiWatMinByp then Buildings.Templates.Components.Types.Valve.TwoWayModulating
      else Buildings.Templates.Components.Types.Valve.None,
    final chaTwo=Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Linear,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    linearized=linearized,
    from_dp=true)
    if have_valChiWatMinByp or have_bypChiWatFix
    "CHW minimum flow bypass valve or fixed bypass depending on type of distribution"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,40})));
  // Secondary CHW loop
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatSec,
    final have_var=true,
    final have_varCom=true,
    final dat=dat.pumChiWatSec) if have_chiWat and typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{250,70},{270,90}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300) if
    have_chiWat and typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{230,70},{250,90}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300) if
    have_chiWat and typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{270,70},{290,90}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_chiWat and
    typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW supply pipe - Plant without secondary CHW pumps"
    annotation (Placement(transformation(extent={{250,70},{270,90}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSec_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{288,70},{308,90}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecSup(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecSup,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Secondary CHW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={220,80})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecRet(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecRet,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={320,0})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium = MediumChiWat,
    text_rotation=90) if have_chiWat and not ctl.have_senDpChiWatRemWir
    "Local CHW ∆p sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={560.5,40})));
  // Primary HW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-40,-290},{-20,-270}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumHeaWat,
    final dat=dat.pumHeaWatPri,
    final dpValChe_nominal=fill(dpValCheHeaWat_nominal, nPumHeaWatPri),
    final nPum=nPumHeaWatPri,
    final have_var=have_pumHeaWatPriVar,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_heaWat and typArrPumPri
     == Buildings.Templates.Components.Types.PumpArrangement.Dedicated
    "Primary HW supply pipe - Plant with dedicated primary HW pumps"
    annotation (Placement(transformation(extent={{-20,-290},{0,-270}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPri_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{20,-290},{40,-270}})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypSup(
    redeclare final package Medium=MediumHeaWat,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal * {1, - 1, - 1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving) if have_heaWat
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={180,-280})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSup(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=true,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={60,-280})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriRet(
    redeclare final package Medium = MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatPriRet,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={60,-360})));
  Buildings.Templates.Components.Routing.Junction junHeaWatBypRet(
    redeclare final package Medium=MediumHeaWat,
    final tau=tau,
    final m_flow_nominal=mHeaWatPri_flow_nominal * {1, - 1, 1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={180,-360})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatMinByp(
    redeclare final package Medium = MediumHeaWat,
    final dat=dat.valHeaWatMinByp,
    final typ=if have_valHeaWatMinByp then Buildings.Templates.Components.Types.Valve.TwoWayModulating
         else Buildings.Templates.Components.Types.Valve.None,
    final chaTwo=Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Linear,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    linearized=linearized,
    from_dp=true)
    if have_valHeaWatMinByp or have_bypHeaWatFix
    "HW minimum flow bypass valve or fixed bypass depending on type of distribution"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={180,-320})));
  // Secondary HW loop
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatSec(
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium=MediumHeaWat,
    final nPum=nPumHeaWatSec,
    final have_var=true,
    final have_varCom=true,
    final dat=dat.pumHeaWatSec)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps"
    annotation (Placement(transformation(extent={{250,-290},{270,-270}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{230,-290},{250,-270}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final icon_dy=300)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{270,-290},{290,-270}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) if have_heaWat and
    typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW supply pipe - Plant without secondary HW pumps"
    annotation (Placement(transformation(extent={{250,-290},{270,-270}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSec_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{290,-290},{310,-270}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecSup(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatSecSup,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Secondary HW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={220,-280})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecRet(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatSecRet,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal)
    "Secondary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={320,-360})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpHeaWatLoc(
    redeclare final package Medium = MediumHeaWat,
    text_rotation=90) if have_heaWat and not ctl.have_senDpHeaWatRemWir
    "Local HW ∆p sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={560.5,-320})));
  Components.HeatRecoveryChiller hrc(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumHeaWat=MediumHeaWat,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final show_T=show_T,
    final datPumChiWat=dat.pumChiWatHrc,
    final datPumHeaWat=dat.pumHeaWatHrc,
    final datHrc=dat.hrc,
    final energyDynamics=energyDynamics) if have_hrc
    "Sidestream heat recovery chiller"
    annotation (Placement(transformation(extent={{380,-184},{500,-64}})));
  Buildings.Templates.Components.Routing.Junction junHeaWatHrcEnt(
    redeclare final package Medium = MediumHeaWat,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Return)
    if have_heaWat "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={500,-360})));
  Buildings.Templates.Components.Routing.Junction junHeaWatHrcLvg(
    redeclare final package Medium = MediumHeaWat,
    final tau=tau,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat "Fluid junction" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={380,-360})));
  Buildings.Templates.Components.Routing.Junction junChiWatHrcEnt(
    redeclare final package Medium = MediumChiWat,
    final tau=tau,
    final m_flow_nominal=mChiWat_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Return)
    if have_chiWat "Fluid junction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={500,0})));
   Buildings.Templates.Components.Routing.Junction junChiWatHrcLvg(
    redeclare final package Medium = MediumChiWat,
    final tau=tau,
    final m_flow_nominal=mChiWat_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    icon_pipe1=Buildings.Templates.Components.Types.IconPipe.Return,
    icon_pipe3=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={380,0})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatRetUpsHrc(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_hrc,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal) if have_chiWat
    "CHW return temperature upstream of HRC" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={540,0})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatRetUpsHrc(
    redeclare final package Medium = MediumHeaWat,
    final have_sen=have_hrc,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal)
    "HW return temperature upstream of HRC" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={540,-360})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = MediumHeaWat,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1) if have_heaWat
    "Pressure boundary condition mimicking expansion tank" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={140,-340})));
initial equation
  // Calculation of pump speed providing design flow.
  if is_dpBalYPumSetCal
    and have_heaWat
    and typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
    and typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable then
    0=Buildings.Templates.Utilities.computeBalancingPressureDrop(
      m_flow_nominal=hp.mHeaWatHp_flow_nominal,
      dp_nominal=max(valIso.dpHeaWat_nominal) + dpValCheHeaWat_nominal,
      datPum=dat.pumHeaWatPriSin[1],
      r_N=yPumHeaWatPriSet);
  else
    yPumHeaWatPriSet=1;
  end if;
  if is_dpBalYPumSetCal
    and have_chiWat
    and typDis==Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2
    and (typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
      or typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.None
      and typPumHeaWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable) then
    0=Buildings.Templates.Utilities.computeBalancingPressureDrop(
      m_flow_nominal=hp.mChiWatHp_flow_nominal,
      dp_nominal=max(valIso.dpChiWat_nominal) + dpValCheChiWat_nominal,
      datPum=if typPumChiWatPri==Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable
        then dat.pumChiWatPriSin[1] else dat.pumHeaWatPriSin[1],
      r_N=yPumChiWatPriSet);
  else
    yPumChiWatPriSet=1;
  end if;

equation
  /* Control point connection - start */
  connect(busWea, hp.busWea);
  connect(bus, hp.bus);
  connect(bus, hrc.bus);
  connect(bus, pumPri.bus);
  connect(bus, valIso.bus);
  connect(bus.pumChiWatPri, pumChiWatPri.bus);
  connect(bus.pumHeaWatPri, pumHeaWatPri.bus);
  connect(bus.pumChiWatSec, pumChiWatSec.bus);
  connect(bus.pumHeaWatSec, pumHeaWatSec.bus);
  connect(bus.valChiWatMinByp, valChiWatMinByp.bus);
  connect(bus.valHeaWatMinByp, valHeaWatMinByp.bus);
  connect(VChiWatPri_flow.y, bus.VChiWatPri_flow);
  connect(VHeaWatPri_flow.y, bus.VHeaWatPri_flow);
  connect(VChiWatSec_flow.y, bus.VChiWatSec_flow);
  connect(VHeaWatSec_flow.y, bus.VHeaWatSec_flow);
  connect(TChiWatPriSup.y, bus.TChiWatPriSup);
  connect(THeaWatPriSup.y, bus.THeaWatPriSup);
  connect(TChiWatPriRet.y, bus.TChiWatPriRet);
  connect(THeaWatPriRet.y, bus.THeaWatPriRet);
  connect(TChiWatSecSup.y, bus.TChiWatSecSup);
  connect(THeaWatSecSup.y, bus.THeaWatSecSup);
  connect(TChiWatSecRet.y, bus.TChiWatSecRet);
  connect(THeaWatSecRet.y, bus.THeaWatSecRet);
  connect(THeaWatRetUpsHrc.y, bus.THeaWatRetUpsHrc);
  connect(TChiWatRetUpsHrc.y, bus.TChiWatRetUpsHrc);
  connect(dpHeaWatLoc.y, bus.dpHeaWatLoc);
  connect(dpChiWatLoc.y, bus.dpChiWatLoc);
  /* Control point connection - stop */
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{0,80},{0,80}},  color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{-20,80},{-20,80}},
                                              color={0,127,255}));
  connect(valIso.port_bChiWat, inlPumChiWatPri.port_a)
    annotation (Line(
      points={{-60,80},{-60,80},{-40,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  connect(hp.ports_bChiHeaWat, pumPri.ports_aChiHeaWatHp)
    annotation (Line(points={{-350,-130},{-350,-130}},color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp)
    annotation (Line(points={{-350,-50},{-350,-50}},color={0,127,255}));
  connect(pumPri.ports_bHeaWat, valIso.ports_aHeaWatHp)
    annotation (Line(points={{-366,-50},{-366,-50}},color={0,127,255}));
  connect(pumPri.ports_bChiWat, valIso.ports_aChiWatHp)
    annotation (Line(points={{-334,-50},{-334,-50}},  color={0,127,255}));
  connect(outPumChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{20,80},{20,80}},color={0,127,255}));
  connect(VChiWatPri_flow.port_b, TChiWatPriSup.port_a)
    annotation (Line(
      points={{40,80},{50,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat));
  connect(TChiWatPriSup.port_b, junChiWatBypSup.port_1)
    annotation (Line(
      points={{70,80},{170,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{270,80},{270,80}},color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{250,80},{250,80}},color={0,127,255}));
  connect(valIso.port_bChiWat, supChiWatPri.port_a)
    annotation (Line(
      points={{-60,80},{-60,80},{-20,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  connect(supChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(
      points={{0,80},{20,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  connect(valIso.ports_bChiHeaWatHp, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{-250,-50},{-250,-50}},
                                                  color={0,127,255}));
  connect(pumPri.ports_bChiHeaWatHp, hp.ports_aChiHeaWat)
    annotation (Line(points={{-250,-130},{-250,-130}},
                                                    color={0,127,255}));
  connect(supChiWatSec.port_b, VChiWatSec_flow.port_a)
    annotation (Line(
      points={{270,80},{288,80}},
      color={0,0,0},
      visible=have_chiWat and typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized,
      thickness=0.5));

  connect(port_bChiWat, dpChiWatLoc.port_a)
    annotation (Line(
      points={{600,80},{560.5,80},{560.5,50}},
      color={0,127,255},
      visible=false));
  connect(dpChiWatLoc.port_b, port_aChiWat)
    annotation (Line(
      points={{560.5,30},{560.5,0},{600,0}},
      color={0,127,255},
      visible=false));
  connect(port_bHeaWat, dpHeaWatLoc.port_a) annotation (Line(
      points={{600,-280},{560.5,-280},{560.5,-310}},
      color={0,127,255},
      visible=false));
  connect(dpHeaWatLoc.port_b, port_aHeaWat) annotation (Line(
      points={{560.5,-330},{560.5,-360},{600,-360}},
      color={0,127,255},
      visible=false));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{0,-280},{0,-280}},  color={0,127,255}));
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{-20,-280},{-20,-280}},
                                                  color={0,127,255}));
  connect(outPumHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{20,-280},{20,-280}},color={0,127,255}));
  connect(VHeaWatPri_flow.port_b, THeaWatPriSup.port_a)
    annotation (Line(points={{40,-280},{50,-280}},  color={0,0,0},
      thickness=0.5));
  connect(THeaWatPriSup.port_b, junHeaWatBypSup.port_1)
    annotation (Line(points={{70,-280},{170,-280}}, color={0,0,0},
      thickness=0.5));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{270,-280},{270,-280}},color={0,127,255}));
  connect(inlPumHeaWatSec.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{250,-280},{250,-280}},color={0,127,255}));
  connect(supHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(
      points={{0,-280},{20,-280}},
      color={0,0,0},
      thickness=0.5,
      visible=have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  connect(supHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(
      points={{270,-280},{290,-280}},
      color={0,0,0},
      thickness=0.5,
      visible=have_heaWat and typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  connect(outPumHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(points={{290,-280},{290,-280}},color={0,0,0},
      thickness=0.5));
  connect(valIso.port_bHeaWat, inlPumHeaWatPri.port_a)
    annotation (Line(
      points={{-540,20},{-540,-280},{-40,-280}},
      color={0,0,0},
      thickness=0.5,
      visible=have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  connect(VHeaWatSec_flow.port_b, port_bHeaWat)
    annotation (Line(points={{310,-280},{600,-280}},color={0,0,0},
      thickness=0.5));
  connect(valIso.port_bHeaWat, supHeaWatPri.port_a)
    annotation (Line(
      points={{-540,20},{-540,-280},{-20,-280}},
      color={0,0,0},
      thickness=0.5,
      visible=have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Dedicated));
  connect(junChiWatBypSup.port_2, TChiWatSecSup.port_a)
    annotation (Line(
      points={{190,80},{210,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat));
  connect(TChiWatSecSup.port_b, inlPumChiWatSec.port_a)
    annotation (Line(points={{230,80},{230,80}},
                                               color={0,0,0},
      thickness=0.5));
  connect(junChiWatBypRet.port_1, TChiWatSecRet.port_b)
    annotation (Line(
      points={{190,0},{310,0}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5,
      visible=have_chiWat));
  connect(junHeaWatBypSup.port_2, THeaWatSecSup.port_a)
    annotation (Line(points={{190,-280},{210,-280}},
                                                   color={0,0,0},
      thickness=0.5));
  connect(THeaWatSecSup.port_b, inlPumHeaWatSec.port_a)
    annotation (Line(points={{230,-280},{230,-280}},
                                                   color={0,0,0},
      thickness=0.5));
  connect(THeaWatSecSup.port_b, supHeaWatSec.port_a) annotation (Line(
      points={{230,-280},{250,-280}},
      color={0,0,0},
      thickness=0.5,
      visible=have_heaWat and typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  connect(TChiWatSecSup.port_b, supChiWatSec.port_a) annotation (Line(
      points={{230,80},{250,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat and typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized));
  connect(junHeaWatBypRet.port_1, THeaWatSecRet.port_b)
    annotation (Line(points={{190,-360},{310,-360}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(THeaWatPriRet.port_b, valIso.port_aHeaWat) annotation (Line(
      points={{50,-360},{-584,-360},{-584,60},{-540,60}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(outPumChiWatSec.port_b, VChiWatSec_flow.port_a) annotation (Line(
      points={{290,80},{288,80}},
      color={0,0,0},
      thickness=1));
  connect(TChiWatPriRet.port_b, valIso.port_aChiWat) annotation (Line(
      points={{50,0},{0,0},{0,40},{-60,40}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5,
      visible=have_chiWat));
  connect(junHeaWatHrcEnt.port_2, junHeaWatHrcLvg.port_1)
    annotation (Line(points={{490,-360},{390,-360}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(junHeaWatHrcLvg.port_2, THeaWatSecRet.port_a)
    annotation (Line(points={{370,-360},{330,-360}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(junHeaWatHrcEnt.port_3, hrc.port_a1) annotation (Line(points={{500,-350},
          {500,-180},{380,-180},{380,-160}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(hrc.port_b1, junHeaWatHrcLvg.port_3) annotation (Line(points={{500,-160},
          {440,-160},{440,-200},{380,-200},{380,-350}}, color={0,0,0},
      thickness=0.5));
  connect(junChiWatHrcEnt.port_3, hrc.port_a2)
    annotation (Line(points={{500,-10},{500,-88}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(junChiWatHrcEnt.port_2, junChiWatHrcLvg.port_1)
    annotation (Line(
      points={{490,0},{390,0}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash,
      visible=have_chiWat));
  connect(junChiWatHrcLvg.port_2, TChiWatSecRet.port_a)
    annotation (Line(
      points={{370,0},{330,0}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash,
      visible=have_chiWat));
  connect(hrc.port_b2, junChiWatHrcLvg.port_3)
    annotation (Line(points={{380,-88},{380,-10}}, color={0,0,0},
      thickness=0.5));
  connect(port_aChiWat, TChiWatRetUpsHrc.port_a) annotation (Line(
      points={{600,0},{550,0}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5,
      visible=have_chiWat));
  connect(TChiWatRetUpsHrc.port_b, junChiWatHrcEnt.port_1) annotation (Line(
      points={{530,0},{510,0}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(port_aHeaWat, THeaWatRetUpsHrc.port_a) annotation (Line(
      points={{600,-360},{550,-360}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(THeaWatRetUpsHrc.port_b, junHeaWatHrcEnt.port_1) annotation (Line(
      points={{530,-360},{510,-360}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(junChiWatBypSup.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{180,70},{180,50}}, color={0,0,0},
      thickness=0.5));
  connect(valChiWatMinByp.port_b, junChiWatBypRet.port_3)
    annotation (Line(points={{180,30},{180,10}}, color={0,0,0},
      thickness=0.5));
  connect(junHeaWatBypSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{180,-290},{180,-310}}, color={0,0,0},
      thickness=0.5));
  connect(valHeaWatMinByp.port_b, junHeaWatBypRet.port_3)
    annotation (Line(points={{180,-330},{180,-350}}, color={0,0,0},
      thickness=0.5));
  connect(junChiWatBypRet.port_2, TChiWatPriRet.port_a)
    annotation (Line(
      points={{170,0},{70,0}},
      color={0,0,0},
      pattern=LinePattern.Dash,
      thickness=0.5,
      visible=have_chiWat));
  connect(bouHeaWat.ports[1], junHeaWatBypRet.port_2) annotation (Line(points={{
          140,-350},{140,-360},{170,-360}}, color={0,127,255}));
  connect(junHeaWatBypRet.port_2, THeaWatPriRet.port_a) annotation (Line(
      points={{170,-360},{70,-360}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(VChiWatSec_flow.port_b, port_bChiWat)
    annotation (Line(
      points={{308,80},{600,80}},
      color={0,0,0},
      thickness=0.5,
      visible=have_chiWat));
  annotation (
    defaultComponentName="pla",
    Documentation(
      info="<html>
<h4>Description</h4>
<p>
This template represents an air-to-water heat pump plant
with closed-loop controls. While the heat pump plant configuration can be changed
through parameters, a typical configuration is shown in the image below.
For a detailed schematic of the actual plant configuration, refer to the diagram 
view of the plant component. In Dymola, for example, you can access this by right-clicking 
the component <code>pla</code> in the model 
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Validation.AirToWater\">
Buildings.Templates.Plants.HeatPumps.Validation.AirToWater</a>
and selecting \"Show Component\" from the context menu.
</p>
<p align=\"center\">
<img alt=\"Image of heat pump plant\"
src=\"modelica://Buildings/Resources/Images/Templates/Plants/HeatPumps/AirToWater.png\"/>
</p>
<p>
Currently, only identical heat pumps are supported. 
Although the template can accommodate any number of identical heat pumps, 
the graphical feedback for system configuration via the diagram layer is 
only accurate for up to 6 devices.
</p>
<p>
The supported plant configurations are enumerated in the table below.
The first option displayed in bold characters corresponds to the default
configuration.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>Function</td>
<td>
<b>Heating and cooling</b><br/>
Heating-only
</td>
<td>
The plant always provides heating hot water.<br/>
Setting the parameter <code>have_chiWat</code> to true (default setting) allows
modeling a plant that provides both heating hot water and chilled water.
</td>
</tr>
<tr><td>Type of distribution</td>
<td>
<b>Constant primary-variable secondary centralized</b>
</td>
<td>
It is assumed that the HW and the CHW loops have the
same type of distribution, as specified by this parameter.<br/>
\"Centralized secondary pumps\" refers to configurations with a single
group of secondary pumps that is typically integrated into the plant.<br/>
Distributed secondary pumps with multiple secondary loops served
by dedicated secondary pumps are currently not supported.<br/>
Options are limited to constant primary distributions because most
AWHPs on the market use a reverse cycle for defrosting.
This requires maximum primary flow during defrost cycles and hinders
variable primary distributions.<br/>
An option for constant primary-only distributions with ∆p-controlled
variable speed pumps will be added in a next release.
</td>
</tr>
<tr><td>Type of primary pump arrangement</td>
<td>
<b>Dedicated</b><br/>
Headered
</td>
<td>It is assumed that the HW and the CHW loops have the
same type of primary pump arrangement, as specified by this parameter.
</td>
</tr>
<tr><td>Separate dedicated primary CHW pumps</td>
<td>
<b>False</b><br/>
True
</td>
<td>This option is only available for heating and cooling plants
with dedicated primary pumps.
If this option is not selected (default setting), each AWHP uses
a common dedicated primary pump for HW and CHW –
this pump is then denoted as the primary HW pump.
Otherwise, each AWHP relies on a separate dedicated HW pump
and a separate dedicated CHW pump.
</td>
</tr>
<tr><td>Type of primary HW pumps</td>
<td>
<b>Variable speed</b><br/>
Constant speed
</td>
<td>
For constant primary-variable secondary distributions, the variable
speed primary pumps are commanded at fixed speeds, determined during the
Testing, Adjusting and Balancing phase to provide design AWHP flow in
heating and cooling modes.
The same intent is achieved with constant speed primary pumps through the
use of balancing valves.
</td>
</tr>
<tr><td>Type of primary CHW pumps</td>
<td>
<b>Variable speed</b><br/>
Constant speed
</td>
<td>See the note above on primary HW pumps.</td>
</tr>
<tr><td>Controller</td>
<td>
<b>Closed-loop controls with supply temperature and differential pressure reset</b><br/>
</td>
<td>
Most parts of the sequence of operation are similar to that
described in ASHRAE, 2021 for chiller plants.<br/>
See the documentation of <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.AirToWater\">
Buildings.Templates.Plants.Controls.HeatPumps.AirToWater</a>
for more details.<br/>
An open loop controller is also available for validation purposes.
</td>
</tr>
</table>
<h4>Control points</h4>
<p>
The control sequence implemented in this template requires the
external input points specified in the documentation of the controller
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Controls.AirToWater\">
Buildings.Templates.Plants.HeatPumps.Components.Controls.AirToWater</a>.
<h4>Implementation details</h4>
<p>
The pressure drops of the heat pump CHW and HW heat exchangers are calculated
within the isolation valve component <code>valIso</code> based on lumped flow
coefficients for the sake of computational efficiency.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"),
    Diagram(graphics={
        Polygon(
          points={{560,80},{560,44},{561,44},{561,80}},
          lineColor={0,0,0},
          visible=have_chiWat and not ctl.have_senDpChiWatRemWir),
        Polygon(
          points={{560,36},{560,0},{561,0},{561,36}},
          lineColor={0,0,0},
          visible=have_chiWat and not ctl.have_senDpChiWatRemWir),
        Polygon(
          points={{560,-324},{560,-360},{561,-360},{561,-324}},
          lineColor={0,0,0},
          visible=have_heaWat and not ctl.have_senDpHeaWatRemWir),
        Polygon(
          points={{560,-280},{560,-316},{561,-316},{561,-280}},
          lineColor={0,0,0},
          visible=have_heaWat and not ctl.have_senDpHeaWatRemWir)}));
end AirToWater;
