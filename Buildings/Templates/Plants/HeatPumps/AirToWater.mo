within Buildings.Templates.Plants.HeatPumps;
model AirToWater
  "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
    redeclare final package MediumChiWat=MediumHeaWat,
    redeclare final package MediumSou=MediumAir,
    redeclare Buildings.Templates.Plants.HeatPumps.Components.Controls.AirToWater ctl,
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
    annotation (Placement(transformation(extent={{-340,-208},{-140,-128}})));
  Components.PumpsPrimaryDedicated pumPri(
    redeclare final package Medium=MediumHeaWat,
    final nHp=nHp,
    final typArrPumPri=typArrPumPri,
    final have_pumChiWatPriDed=have_pumChiWatPriDed,
    final have_pumHeaWatPriVar=have_pumHeaWatPriVar,
    final have_pumChiWatPriVar=have_pumChiWatPriVar,
    final datPumHeaWat=dat.pumHeaWatPri,
    final datPumChiWat=dat.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Dedicated primary pumps"
    annotation (Placement(transformation(extent={{-340,-128},{-140,-48}})));
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
    annotation (Placement(transformation(extent={{-340,-28},{-140,52}})));
  // Primary CHW loop
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumChiWat,
    final dat=dat.pumChiWatPri,
    final nPum=nPumChiWatPri,
    final have_var=have_pumChiWatPriVar,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary CHW pumps"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if not
          (have_chiWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Primary CHW supply pipe - Plant with dedicated primary CHW pumps"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Primary CHW volume flow rate"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
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
      origin={20,40})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium=MediumChiWat,
    final have_sen=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) "Primary CHW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-20,40})));
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
      origin={20,-40})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriRet(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatPriRet,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal) "Primary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={-20,-40})));
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
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumChiWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{118,30},{138,50}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if typPumChiWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary CHW supply pipe - Plant without secondary CHW pumps"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSec_flow(
    redeclare final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{150,30},{170,50}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecSup(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecSup,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal) "Secondary CHW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={60,40})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecRet(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecRet,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal) "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={60,-40})));
  // Primary HW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  Buildings.Templates.Components.Pumps.Multiple pumHeaWatPri(
    final energyDynamics=energyDynamics,
    redeclare final package Medium=MediumHeaWat,
    final dat=dat.pumHeaWatPri,
    final nPum=nPumHeaWatPri,
    final have_var=have_pumHeaWatPriVar,
    final have_varCom=true,
    final allowFlowReversal=allowFlowReversal)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Headered primary HW pumps"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatPri,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered
    "Primary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatPri(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if not
          (have_heaWat and typArrPumPri == Buildings.Templates.Components.Types.PumpArrangement.Headered)
    "Primary HW supply pipe - Plant with dedicated primary HW pumps"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatPri_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatPri,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Primary HW volume flow rate"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
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
      origin={20,-220})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriSup(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=true,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={-20,-220})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatPriRet(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatPriRet,
    final m_flow_nominal=mHeaWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal)
    "Primary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={-20,-300})));
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
      origin={20,-300})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium=MediumHeaWat,
    p=Buildings.Templates.Data.Defaults.pHeaWat_rel_nominal + 101325,
    nPorts=1)
    "Pressure boundary condition to mimic expansion tank"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,
      origin={-120,-290})));
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
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps inlet manifold"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final nPorts=nPumHeaWatSec,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    if typPumHeaWatSec == Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW pumps outlet manifold"
    annotation (Placement(transformation(extent={{118,-230},{138,-210}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supHeaWatSec(
    redeclare final package Medium=MediumHeaWat,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    if typPumHeaWatSec <> Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary.Centralized
    "Secondary HW supply pipe - Plant without secondary HW pumps"
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VHeaWatSec_flow(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVHeaWatSec,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply)
    "Secondary HW volume flow rate"
    annotation (Placement(transformation(extent={{150,-230},{170,-210}})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecSup(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatSecSup,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Supply,
    final allowFlowReversal=allowFlowReversal)
    "Secondary HW supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,
      origin={60,-220})));
  Buildings.Templates.Components.Sensors.Temperature THeaWatSecRet(
    redeclare final package Medium=MediumHeaWat,
    final have_sen=ctl.have_senTHeaWatSecRet,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final icon_pipe=Buildings.Templates.Components.Types.IconPipe.Return,
    final allowFlowReversal=allowFlowReversal)
    "Secondary HW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,
      origin={60,-300})));
equation
  /* Control point connection - start */
  connect(bus, hp.bus);
  connect(busWea, hp.busWea);
  connect(bus, pumPri.bus);
  connect(bus, valIso.bus);
  connect(bus.pumChiWatPri, pumChiWatPri.bus);
  connect(bus.pumHeaWatPri, pumHeaWatPri.bus);
  connect(bus.pumChiWatSec, pumChiWatSec.bus);
  connect(bus.pumHeaWatSec, pumHeaWatSec.bus);
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
  /* Control point connection - stop */
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{-80,40},{-80,40}},
                                              color={0,127,255}));
  connect(inlPumChiWatPri.ports_b, pumChiWatPri.ports_a)
    annotation (Line(points={{-100,40},{-100,40}},
                                              color={0,127,255}));
  connect(valIso.port_bChiWat, inlPumChiWatPri.port_a)
    annotation (Line(points={{-140,40},{-120,40}},
                                             color={0,127,255}));
  connect(hp.ports_bChiHeaWat, pumPri.ports_aChiHeaWatHp)
    annotation (Line(points={{-290,-128},{-290,-128}},color={0,127,255}));
  connect(pumPri.ports_bChiHeaWat, valIso.ports_aChiHeaWatHp)
    annotation (Line(points={{-290,-48},{-290,-28}},color={0,127,255}));
  connect(pumPri.ports_bHeaWat, valIso.ports_aHeaWatHp)
    annotation (Line(points={{-306,-48},{-306,-28}},color={0,127,255}));
  connect(pumPri.ports_bChiWat, valIso.ports_aChiWatHp)
    annotation (Line(points={{-274,-48},{-274,-28.2}},color={0,127,255}));
  connect(outPumChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{-60,40},{-60,40}},
                                              color={0,127,255}));
  connect(VChiWatPri_flow.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{-40,40},{-30,40}},color={0,127,255}));
  connect(TChiWatPriSup.port_b, junChiWatBypSup.port_1)
    annotation (Line(points={{-10,40},{10,40}}, color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{120,40},{118,40}},color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{100,40},{100,40}},color={0,127,255}));
  connect(valIso.port_bChiWat, supChiWatPri.port_a)
    annotation (Line(points={{-140,40},{-100,40},{-100,20}},
                                                     color={0,127,255}));
  connect(supChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{-80,20},{-80,40},{-60,40}},
                                                      color={0,127,255}));
  connect(valIso.ports_bChiHeaWatHp, pumPri.ports_aChiHeaWat)
    annotation (Line(points={{-190,-28},{-190,-48}},
                                                  color={0,127,255}));
  connect(pumPri.ports_bChiHeaWatHp, hp.ports_aChiHeaWat)
    annotation (Line(points={{-190,-128},{-190,-128}},
                                                    color={0,127,255}));
  connect(VChiWatSec_flow.port_b, port_bChiWat)
    annotation (Line(points={{170,40},{400,40}},color={0,127,255}));
  connect(supChiWatSec.port_b, VChiWatSec_flow.port_a)
    annotation (Line(points={{120,20},{150,20},{150,40}},color={0,127,255}));
  connect(outPumChiWatSec.port_b, VChiWatSec_flow.port_a)
    annotation (Line(points={{138,40},{150,40}},color={0,127,255}));
  connect(pumHeaWatPri.ports_b, outPumHeaWatPri.ports_a)
    annotation (Line(points={{-80,-220},{-80,-220}},
                                                  color={0,127,255}));
  connect(inlPumHeaWatPri.ports_b, pumHeaWatPri.ports_a)
    annotation (Line(points={{-100,-220},{-100,-220}},
                                                  color={0,127,255}));
  connect(outPumHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{-60,-220},{-60,-220}},
                                                  color={0,127,255}));
  connect(VHeaWatPri_flow.port_b, THeaWatPriSup.port_a)
    annotation (Line(points={{-40,-220},{-30,-220}},color={0,127,255}));
  connect(THeaWatPriSup.port_b, junHeaWatBypSup.port_1)
    annotation (Line(points={{-10,-220},{10,-220}}, color={0,127,255}));
  connect(pumHeaWatSec.ports_b, outPumHeaWatSec.ports_a)
    annotation (Line(points={{120,-220},{118,-220}},color={0,127,255}));
  connect(inlPumHeaWatSec.ports_b, pumHeaWatSec.ports_a)
    annotation (Line(points={{100,-220},{100,-220}},color={0,127,255}));
  connect(supHeaWatPri.port_b, VHeaWatPri_flow.port_a)
    annotation (Line(points={{-80,-240},{-80,-220},{-60,-220}},
                                                            color={0,127,255}));
  connect(supHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(points={{120,-240},{150,-240},{150,-220}},color={0,127,255}));
  connect(outPumHeaWatSec.port_b, VHeaWatSec_flow.port_a)
    annotation (Line(points={{138,-220},{150,-220}},color={0,127,255}));
  connect(valIso.port_bHeaWat, inlPumHeaWatPri.port_a)
    annotation (Line(points={{-340,32},{-360,32},{-360,-220},{-120,-220}},
                                                                        color={0,127,255}));
  connect(VHeaWatSec_flow.port_b, port_bHeaWat)
    annotation (Line(points={{170,-220},{400,-220}},color={0,127,255}));
  connect(valIso.port_bHeaWat, supHeaWatPri.port_a)
    annotation (Line(points={{-340,32},{-360,32},{-360,-240},{-100,-240}},
                                                                        color={0,127,255}));
  connect(bouHeaWat.ports[1], valIso.port_aHeaWat)
    annotation (Line(points={{-120,-300},{-380,-300},{-380,48},{-340,48}},
                                                                        color={0,127,255}));
  connect(junHeaWatBypSup.port_3, junHeaWatBypRet.port_3)
    annotation (Line(points={{20,-230},{20,-290}},   color={0,127,255}));
  connect(junChiWatBypSup.port_3, junChiWatBypRet.port_3)
    annotation (Line(points={{20,30},{20,-30}},   color={0,127,255}));
  connect(junChiWatBypSup.port_2, TChiWatSecSup.port_a)
    annotation (Line(points={{30,40},{50,40}}, color={0,127,255}));
  connect(TChiWatSecSup.port_b, inlPumChiWatSec.port_a)
    annotation (Line(points={{70,40},{80,40}}, color={0,127,255}));
  connect(junChiWatBypRet.port_1, TChiWatSecRet.port_b)
    annotation (Line(points={{30,-40},{50,-40}}, color={0,127,255}));
  connect(port_aChiWat, TChiWatSecRet.port_a)
    annotation (Line(points={{400,-40},{70,-40}}, color={0,127,255}));
  connect(junChiWatBypRet.port_2, TChiWatPriRet.port_a)
    annotation (Line(points={{10,-40},{-10,-40}}, color={0,127,255}));
  connect(TChiWatPriRet.port_b, valIso.port_aChiWat) annotation (Line(points={{-30,
          -40},{-120,-40},{-120,24},{-140,24}}, color={0,127,255}));
  connect(junHeaWatBypRet.port_1, THeaWatSecRet.port_b)
    annotation (Line(points={{30,-300},{50,-300}}, color={0,127,255}));
  connect(port_aHeaWat, THeaWatSecRet.port_a)
    annotation (Line(points={{400,-300},{70,-300}}, color={0,127,255}));
  connect(junHeaWatBypSup.port_2, THeaWatSecSup.port_a)
    annotation (Line(points={{30,-220},{50,-220}}, color={0,127,255}));
  connect(THeaWatSecSup.port_b, inlPumHeaWatSec.port_a)
    annotation (Line(points={{70,-220},{80,-220}}, color={0,127,255}));
  connect(THeaWatSecSup.port_b, supHeaWatSec.port_a) annotation (Line(points={{70,
          -220},{80,-220},{80,-240},{100,-240}}, color={0,127,255}));
  connect(TChiWatSecSup.port_b, supChiWatSec.port_a) annotation (Line(points={{70,
          40},{80,40},{80,20},{100,20}}, color={0,127,255}));
  connect(junHeaWatBypRet.port_2, THeaWatPriRet.port_a)
    annotation (Line(points={{10,-300},{-10,-300}}, color={0,127,255}));
  connect(THeaWatPriRet.port_b, valIso.port_aHeaWat) annotation (Line(points={{-30,
          -300},{-380,-300},{-380,48},{-340,48}}, color={0,127,255}));
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
