within Buildings.Templates.Plants.HeatPumps;
model AirToWater
  "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumChiWat=MediumHeaWat,
    redeclare final package MediumSou=MediumAir,
    redeclare Buildings.Templates.Plants.HeatPumps.Components.Controls.OpenLoop ctl,
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final is_rev=have_chiWat,
    cfg(
      final typMod=hp.typMod));
  // Heat pumps, dedicated primary pumps and isolation valves
  Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater hp(
    redeclare final package MediumHeaWat=MediumHeaWat,
    redeclare final package MediumAir=MediumAir,
    final nHp=nHp,
    final is_rev=is_rev,
    final energyDynamics=energyDynamics,
    final have_preDroChiHeaWat=false,
    final have_preDroSou=false,
    final dat=dat.hp,
    final allowFlowReversal=allowFlowReversal,
    final allowFlowReversalSou=false)
    "Heat pump group"
    annotation (Placement(transformation(extent={{-200,-188},{0,-108}})));
  Components.PumpsPrimaryDedicated pumPri(
    redeclare final package Medium=MediumHeaWat,
    final nHp=nHp,
    final typArrPumPri=typArrPumPri,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final have_varPumHeaWatPri=have_varPumHeaWatPri,
    final have_varPumChiWatPri=have_varPumChiWatPri,
    final datPumHeaWat=dat.pumHeaWatPri,
    final datPumChiWat=dat.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Dedicated primary pumps"
    annotation (Placement(transformation(extent={{-200,-108},{0,-28}})));
  Components.ValvesIsolation valIso(
    redeclare final package Medium=MediumHeaWat,
    final nHp=nHp,
    final have_chiWat=have_chiWat,
    final have_valHpInlIso=have_valHpInlIso,
    final have_valHpOutIso=have_valHpOutIso,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final mHeaWatHp_flow_nominal=fill(dat.hp.mHeaWatHp_flow_nominal, nHp),
    final dpHeaWatHp_nominal=fill(dat.hp.dpHeaWatHp_nominal, nHp),
    final mChiWatHp_flow_nominal=fill(dat.hp.mChiWatHp_flow_nominal, nHp),
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Heat pump isolation valves"
    annotation (Placement(transformation(extent={{-200,-28},{0,52}})));
  // Primary CHW loop
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumChiWat,
    final dat=dat.pumChiWatPri,
    final nPum=nPumChiWatPri,
    final have_var=have_varPumChiWatPri,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary CHW pumps"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if not(have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Primary CHW supply pipe - Plant with dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final typ=if have_valChiWatMinByp then Buildings.Templates.Components.Types.Valve.TwoWayModulating
      else Buildings.Templates.Components.Types.Valve.None,
    final chaTwo=Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.EqualPercentage,
    final dat=dat.valChiWatMinByp,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics)
    if have_valChiWatMinByp or have_bypChiWatFix
    "CHW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={140,0})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Primary CHW volume flow rate"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
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
      else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={140,40})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatPriSup,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Primary CHW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={110,40})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatByp_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2
      and ctl.typMeaCtlChiWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Decoupler CHW volume flow rate"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={140,-20})));
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
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={140,-40})));
  // Secondary CHW loop
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatSec,
    final have_var=true,
    final have_varCom=true,
    final dat=dat.pumChiWatSec)
    if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{198,30},{218,50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW supply pipe - Plant without secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,10},{200,30}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSec_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  // Primary HW loop
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumHeaWat,
    final dat=dat.pumHeaWatPri,
    final nPum=nPumHeaWatPri,
    final have_var=have_varPumHeaWatPri,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary HW pumps"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if not(have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Primary HW supply pipe - Plant with dedicated primary HW pumps"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  Buildings.Templates.Components.Actuators.Valve valHeaWatMinByp(
    redeclare final package Medium=MediumHeaWat,
    final typ=if have_valHeaWatMinByp then Buildings.Templates.Components.Types.Valve.TwoWayModulating
      else Buildings.Templates.Components.Types.Valve.None,
    final chaTwo=Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.EqualPercentage,
    final dat=dat.valHeaWatMinByp,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics)
    if have_valHeaWatMinByp or have_bypHeaWatFix
    "HW minimum flow bypass valve"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={140,-240})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPri_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
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
      else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={140,-200})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSup(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatPriSup,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={110,-200})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatByp_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=typDis == Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1And2
      and ctl.typMeaCtlHeaWatPri == Buildings.Templates.Plants.Components.Controls.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Decoupler HW volume flow rate"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=90,
      origin={140,-260})));
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
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=0,
      origin={140,-280})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium=MediumHeaWat,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Pressure boundary condition to mimic expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,
      origin={20,-270})));
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
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{198,-210},{218,-190}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW supply pipe - Plant without secondary HW pumps"
    annotation (Placement(transformation(extent={{180,-230},{200,-210}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSec_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{220,-210},{240,-190}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
equation
  /* Control point connection - start */ connect(bus, hp.bus);
  connect(busWea, hp.busWea);
  connect(bus, pumPri.bus);
  connect(bus, valIso.bus);
  connect(bus.pumChiWatPri, pumChiWatPri.bus);
  connect(bus.pumHeaWatPri, pumHeaWatPri.bus);
  connect(bus.valChiWatMinByp, valChiWatMinByp.bus);
  connect(bus.valHeaWatMinByp, valHeaWatMinByp.bus);
  connect(bus.pumChiWatSec, pumChiWatSec.bus);
  connect(bus.pumHeaWatSec, pumHeaWatSec.bus);
  connect(VChiWatPri_flow.y, bus.VChiWatPri_flow);
  connect(VHeaWatPri_flow.y, bus.VHeaWatPri_flow);
  connect(VChiWatSec_flow.y, bus.VChiWatSec_flow);
  connect(VHeaWatSec_flow.y, bus.VHeaWatSec_flow);
  connect(TChiWatPriSup.y, bus.TChiWatPriSup);
  connect(THeaWatPriSup.y, bus.THeaWatPriSup);
  /* Control point connection - stop */connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{60,40},{60,40}},color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{40,40},{40,40}},color={0,127,255}));
  connect(valIso.port_bChiWat, inlPumChiWatPri.port_a)
    annotation (Line(points={{0,40},{20,40}},color={0,127,255}));
  connect(hp.ports_bChiHeaWat, pumPri.ports_aChiHeaWatHp)
    annotation (Line(points={{-150,-108},{-150,-108}},color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp)
    annotation (Line(points={{-150,-28},{-150,-28}},color={0,127,255}));
  connect(pumPri.ports_bHeaWat, valIso.ports_aHeaWatHp)
    annotation (Line(points={{-166,-28},{-166,-28}},color={0,127,255}));
  connect(pumPri.ports_bChiWat, valIso.ports_aChiWatHp)
    annotation (Line(points={{-134,-28},{-134,-28.2}},color={0,127,255}));
  connect(outPumChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{80,40},{80,40}},color={0,127,255}));
  connect(VChiWatPri_flow.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{100,40},{100,40}},color={0,127,255}));
  connect(TChiWatPriSup.port_b, junChiWatBypSup.port_1)
    annotation (Line(points={{120,40},{130,40}},color={0,127,255}));
  connect(junChiWatBypSup.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{140,30},{140,10}},color={0,127,255}));
  connect(valChiWatMinByp.port_b, VChiWatByp_flow.port_a)
    annotation (Line(points={{140,-10},{140,-10}},color={0,127,255}));
  connect(VChiWatByp_flow.port_b, junChiWatBypRet.port_3)
    annotation (Line(points={{140,-30},{140,-30}},color={0,127,255}));
  connect(port_aChiWat, junChiWatBypRet.port_1)
    annotation (Line(points={{300,-40},{150,-40}},color={0,127,255}));
  connect(junChiWatBypRet.port_2, valIso.port_aChiWat)
    annotation (Line(points={{130,-40},{20,-40},{20,24},{0,24}},color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{200,40},{198,40}},color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{180,40},{180,40}},color={0,127,255}));
  connect(junChiWatBypSup.port_2, inlPumChiWatSec.port_a)
    annotation (Line(points={{150,40},{160,40}},color={0,127,255}));
  connect(inlPumChiWatSec.port_a, supChiWatSec.port_a)
    annotation (Line(points={{160,40},{160,20},{180,20}},color={0,127,255}));
  connect(valIso.port_bChiWat, supChiWatPri.port_a)
    annotation (Line(points={{0,40},{40,40},{40,20}},color={0,127,255}));
  connect(supChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{60,20},{60,40},{80,40}},color={0,127,255}));
  connect(valIso.ports_bChiHeaWatHp, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{-50,-28},{-50,-28}},color={0,127,255}));
  connect(pumPri.ports_bChiHeaWatHp, hp.ports_aChiHeaWat)
    annotation (Line(points={{-50,-108},{-50,-108}},color={0,127,255}));
  connect(VChiWatSec_flow.port_b, port_bChiWat)
    annotation (Line(points={{240,40},{300,40}},color={0,127,255}));
  connect(supChiWatSec.port_b, VChiWatSec_flow.port_a)
    annotation (Line(points={{200,20},{220,20},{220,40}},color={0,127,255}));
  connect(outPumChiWatSec.port_b, VChiWatSec_flow.port_a)
    annotation (Line(points={{218,40},{220,40}},color={0,127,255}));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{60,-200},{60,-200}},color={0,127,255}));
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{40,-200},{40,-200}},color={0,127,255}));
  connect(outPumHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{80,-200},{80,-200}},color={0,127,255}));
  connect(VHeaWatPri_flow.port_b, THeaWatPriSup.port_a)
    annotation (Line(points={{100,-200},{100,-200}},color={0,127,255}));
  connect(THeaWatPriSup.port_b, junHeaWatBypSup.port_1)
    annotation (Line(points={{120,-200},{130,-200}},color={0,127,255}));
  connect(junHeaWatBypSup.port_3, valHeaWatMinByp.port_a)
    annotation (Line(points={{140,-210},{140,-230}},color={0,127,255}));
  connect(valHeaWatMinByp.port_b, VHeaWatByp_flow.port_a)
    annotation (Line(points={{140,-250},{140,-250}},color={0,127,255}));
  connect(VHeaWatByp_flow.port_b, junHeaWatBypRet.port_3)
    annotation (Line(points={{140,-270},{140,-270}},color={0,127,255}));
  connect(port_aHeaWat, junHeaWatBypRet.port_1)
    annotation (Line(points={{300,-280},{150,-280}},color={0,127,255}));
  connect(junHeaWatBypRet.port_2, valIso.port_aHeaWat)
    annotation (Line(points={{130,-280},{-240,-280},{-240,48},{-200,48}},color={0,127,255}));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{200,-200},{198,-200}},color={0,127,255}));
  connect(inlPumHeaWatSec.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{180,-200},{180,-200}},color={0,127,255}));
  connect(junHeaWatBypSup.port_2, inlPumHeaWatSec.port_a)
    annotation (Line(points={{150,-200},{160,-200}},color={0,127,255}));
  connect(inlPumHeaWatSec.port_a, supHeaWatSec.port_a)
    annotation (Line(points={{160,-200},{160,-220},{180,-220}},color={0,127,255}));
  connect(supHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{60,-220},{60,-200},{80,-200}},color={0,127,255}));
  connect(supHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(points={{200,-220},{220,-220},{220,-200}},color={0,127,255}));
  connect(outPumHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(points={{218,-200},{220,-200}},color={0,127,255}));
  connect(valIso.port_bHeaWat, inlPumHeaWatPri.port_a)
    annotation (Line(points={{-200,32},{-220,32},{-220,-200},{20,-200}},color={0,127,255}));
  connect(VHeaWatSec_flow.port_b, port_bHeaWat)
    annotation (Line(points={{240,-200},{300,-200}},color={0,127,255}));
  connect(valIso.port_bHeaWat, supHeaWatPri.port_a)
    annotation (Line(points={{-200,32},{-220,32},{-220,-220},{40,-220}},color={0,127,255}));
  connect(bouHeaWat.ports[1], valIso.port_aHeaWat)
    annotation (Line(points={{20,-280},{-240,-280},{-240,48},{-200,48}},color={0,127,255}));
  annotation (
    defaultComponentName="pla",
    Documentation(
      info="<html>
<p>
The parameter <code>is_rev</code> is bound to <code>have_chiWat</code> as 
AWHP that provide chilled water are necessary reversible units.
</p>
<p>
Heat pump CHW and HW pressure drops are computed within the component <code>valIso</code>
for best computational efficiency.
</p>
</html>"));
end AirToWater;
