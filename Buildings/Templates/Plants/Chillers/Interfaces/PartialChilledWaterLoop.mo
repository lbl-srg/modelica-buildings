within Buildings.Templates.Plants.Chillers.Interfaces;
partial model PartialChilledWaterLoop
  "Partial chilled water plant with chiller group and CHW pumps"
  extends Buildings.Templates.Plants.Chillers.Interfaces.PartialChillerPlant(
    final typValChiWatChiIso=chi.typValChiWatChiIso,
    final typValConWatChiIso=chi.typValConWatChiIso,
    final typEco=eco.typ,
    final typCtl=ctl.typ,
    cfg(
      final have_senDpChiWatRemWir=ctl.have_senDpChiWatRemWir,
      final have_senVChiWatSec=ctl.have_senVChiWatSec,
      final have_senLevCoo=ctl.have_senLevCoo,
      final nSenDpChiWatRem=ctl.nSenDpChiWatRem,
      final typCtlHea=ctl.typCtlHea,
      final typMeaCtlChiWatPri=ctl.typMeaCtlChiWatPri,
      final have_valChiWatChiBypPar=intChi.have_valChiWatChiBypPar));

  replaceable
    Buildings.Templates.Plants.Chillers.Components.ChillerGroups.Compression
    chi(final linearized=linearized, final show_T=show_T)
        constrainedby
    Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup(
    redeclare final package MediumChiWat = MediumChiWat,
    redeclare final package MediumCon = MediumCon,
    final nChi=nChi,
    final typ=typChi,
    final typArr=typArrChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final have_pumConWatVar=have_pumConWatVar,
    final typCtlHea=ctl.typCtlHea,
    final typDisChiWat=typDisChiWat,
    final typMeaCtlChiWatPri=ctl.typMeaCtlChiWatPri,
    final typEco=typEco,
    final dat=dat.chi,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal) "Chillers" annotation (Dialog(
        group="Chillers"), Placement(transformation(extent={{-40,-196},{40,4}})));

  // Primary CHW loop
  Plants.Chillers.Components.Routing.ChillersToPrimaryPumps intChi(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
    final typValChiWatChiIso=chi.typValChiWatChiIso,
    final nPumChiWatPri=nPumChiWatPri,
    final have_senTChiWatPlaRet=ctl.have_senTChiWatPlaRet,
    final have_senVChiWatPri=ctl.have_senVChiWatPri,
    final locSenFloChiWatPri=ctl.locSenFloChiWatPri,
    final typArrChi=typArrChi,
    final typDisChiWat=typDisChiWat,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typEco=typEco,
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Hydronic interface between chillers (and optional WSE) and primary CHW pumps"
    annotation (Placement(transformation(extent={{40,-264},{80,4}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatPri,
    final have_var=have_pumChiWatPriVar,
    final have_varCom=have_pumChiWatPriVarCom,
    final dat=dat.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-360)
    "Primary CHW pumps"
    annotation (
    Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-360,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    "Primary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final show_T=show_T,
    final typ=if typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
      then Buildings.Templates.Components.Types.Valve.TwoWayModulating else
      Buildings.Templates.Components.Types.Valve.None,
    final dat=dat.valChiWatMinByp,
    final allowFlowReversal=allowFlowReversal,
    from_dp=true,
    final linearized=linearized)
    if typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only or
      have_bypChiWatFix
    "CHW minimum flow bypass valve or fixed CHW bypass (common leg)"
    annotation (
    Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={170,-100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatPri and
      ctl.locSenFloChiWatPri==Buildings.Templates.Plants.Chillers.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    "Primary CHW volume flow rate"
    annotation (
    Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Templates.Components.Routing.Junction junction(
    redeclare final package Medium=MediumChiWat,
    final tau=tau,
    final m_flow_nominal=mChiWatPri_flow_nominal*{1,-1,-1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction at minimum flow bypass or common leg"
    annotation (
    Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={170,0})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium = MediumChiWat,
    final have_sen=ctl.have_senTChiWatPriSup,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    "Primary CHW supply temperature"
    annotation (
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={150,0})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatByp_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=
      (typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2
      or typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed) and
      ctl.typMeaCtlChiWatPri==Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    "Decoupler CHW volume flow rate"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={170,-150})));

  // CW loop
  Buildings.Templates.Components.Routing.MultipleToMultiple inlConChi(
    redeclare final package Medium = MediumCon,
    final nPorts_a=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
         then nPumConWat else nChi,
    final nPorts_b=nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final have_comLeg=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
         and typArrPumConWat==Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_xout=200,
    icon_offset=(6-nChi)*inlConChi.icon_dy,
    icon_dy=360,
    icon_pipe=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled then
    Buildings.Templates.Components.Types.IntegrationPoint.Supply else
    Buildings.Templates.Components.Types.IntegrationPoint.None)
    "Chiller group condenser fluid inlet"
    annotation (Placement(transformation(extent={{-70,-202},{-50,-182}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outConChi(
    redeclare final package Medium = MediumCon,
    final nPorts=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
      and typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then nChi + 1 else nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-360,
    icon_pipe=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled then
      Buildings.Templates.Components.Types.IntegrationPoint.Return else
      Buildings.Templates.Components.Types.IntegrationPoint.None)
    "Chiller group condenser fluid outlet"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  // Secondary CHW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    if have_pumChiWatSec
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatSec,
    final have_var=true,
    final have_varCom=true,
    final dat=dat.pumChiWatSec,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    if have_pumChiWatSec
    "Secondary CHW pumps"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    if have_pumChiWatSec
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWat(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    if not have_pumChiWatSec
    "CHW supply line - Without secondary CHW pumps"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal,
    final text_rotation=-90) if not ctl.have_senDpChiWatRemWir
    "Local CHW differential pressure sensor"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={280,-120})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSecSup_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec and ctl.locSenFloChiWatSec ==
      Buildings.Templates.Plants.Chillers.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Supply)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{250,-10},{270,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSecRet_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec and ctl.locSenFloChiWatSec ==
        Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Return)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{250,-270},{230,-250}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecRet,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    icon_pipe=Buildings.Templates.Components.Types.IntegrationPoint.Return)
    "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={200,-260})));

  // WSE
  replaceable Buildings.Templates.Plants.Chillers.Components.Economizers.None eco(final
      show_T=show_T)
    constrainedby
    Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat=MediumChiWat,
      redeclare final package MediumConWat=MediumCon,
      final dat=dat.eco,
      final allowFlowReversal=allowFlowReversal,
      final energyDynamics=energyDynamics)
    "Waterside economizer"
    annotation (
    Dialog(group="Waterside economizer"),
    choices(
      choice(redeclare replaceable Buildings.Templates.Plants.Chillers.Components.Economizers.None eco
      "No waterside economizer"),
      choice(redeclare replaceable Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump eco
      "Heat exchanger with pump for CHW flow control"),
      choice(redeclare replaceable Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve eco
      "Heat exchanger with bypass valve for CHW flow control")),
    Placement(transformation(extent={{-40,-262},{40,-242}})));

  // Controls
  replaceable Buildings.Templates.Plants.Chillers.Components.Controls.OpenLoop ctl
    constrainedby
    Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialController(
    final nAirHan=nAirHan,
    final nEquZon=nEquZon,
    final cfg=cfg,
    final dat=dat.ctl)
    "Plant controller"
    annotation (
    Dialog(group="Controls"),
    Placement(transformation(extent={{-10,190},{10,210}})));

  // Miscellaneous
  Buildings.Fluid.Sources.Outside out(
    redeclare replaceable package Medium=Buildings.Media.Air,
    nPorts=2)
    "Outdoor air conditions"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,240})));
  Buildings.Fluid.Sensors.RelativeHumidity phiOut(
    redeclare replaceable package Medium=Buildings.Media.Air,
    final warnAboutOnePortConnection=false)
    "OA relative humidity"
    annotation (Placement(transformation(extent={{-50,230},{-30,250}})));
  Buildings.Fluid.Sensors.Temperature TOut(
    redeclare replaceable package Medium=Buildings.Media.Air,
    warnAboutOnePortConnection=false)
    "OA temperature"
    annotation (Placement(transformation(extent={{30,230},{50,250}})));
  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat,
    p=Buildings.Templates.Data.Defaults.pChiWat_rel_nominal + 101325,
    nPorts=1)
    "Pressure boundary condition mimicking expansion tank" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-220})));
equation
  /* Control point connection - start */
  connect(TOut.T, bus.TOut);
  connect(phiOut.phi, bus.phiOut);
  connect(bus, intChi.bus);
  connect(bus, chi.bus);
  connect(bus, eco.bus);
  connect(bus.pumChiWatPri, pumChiWatPri.bus);
  connect(bus.valChiWatMinByp, valChiWatMinByp.bus);
  connect(bus.pumChiWatSec, pumChiWatSec.bus);
  connect(dpChiWatLoc.y, bus.dpChiWatLoc);
  connect(VChiWatPri_flow.y, bus.VChiWatPri_flow);
  connect(VChiWatSecSup_flow.y, bus.VChiWatSec_flow);
  connect(VChiWatSecRet_flow.y, bus.VChiWatSec_flow);
  connect(TChiWatPriSup.y, bus.TChiWatPriSup);
  connect(TChiWatSecRet.y, bus.TChiWatSecRet);
  /* Control point connection - stop */
  connect(intChi.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{80,0},{80,0}}, color={0,127,255}));
  connect(chi.ports_bCon, outConChi.ports_a[1:nChi])
    annotation (Line(points={{-40,0},{-40,0}}, color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{100,0},{100,0}},    color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{200,0},{200,0}},     color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{220,0},{220,0}},     color={0,127,255}));
  connect(intChi.ports_bRet[1:nChi], chi.ports_aChiWat) annotation (Line(
      points={{40,-260},{40,-192}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(chi.ports_bChiWat, intChi.ports_aSup[1:nChi]) annotation (Line(points={{40,0},{
          40,0}},   color={0,0,0},
      thickness=0.5));
  connect(intChi.ports_bRet[nChi + 1], eco.port_a) annotation (Line(
      points={{40,-260},{40,-236},{-64,-236},{-64,-280},{-10,-280},{-10,-252}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(eco.port_b, intChi.ports_aSup[nChi + 1]) annotation (Line(
      points={{10,-252},{40,-252},{40,0}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(inlConChi.ports_b, chi.ports_aCon)
    annotation (Line(
      points={{-50,-192},{-40,-192}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(inlConChi.port_aComLeg, eco.port_aConWat)
    annotation (Line(
      points={{-60,-192},{-60,-244},{-40,-244}},
      color={0,0,0},
      thickness=0.5,
      visible=typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  connect(eco.port_bConWat, outConChi.ports_a[nChi + 1]) annotation (Line(
      points={{-40,-260},{-50,-260},{-50,0},{-40,0}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash,
      visible=typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None));
  connect(dpChiWatLoc.port_a, port_b)
    annotation (Line(
      points={{280,-110},{280,0},{300,0}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(dpChiWatLoc.port_b, port_a) annotation (Line(
      points={{280,-130},{280,-260},{300,-260}},
      color={0,127,255},
      visible=viewDiagramAll));
  connect(outPumChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{120,0},{120,0}}, color={0,0,0},
      thickness=0.5));
  connect(junction.port_2, inlPumChiWatSec.port_a)
    annotation (Line(points={{180,0},{180,0}}, color={0,127,255}));
  connect(junction.port_3, valChiWatMinByp.port_a) annotation (Line(
      points={{170,-10},{170,-90}},
      color={0,0,0},
      thickness=0.5));
  connect(junction.port_2, supChiWat.port_a) annotation (Line(
      points={{180,0},{200,0}},
      color={0,0,0},
      thickness=0.5));
  connect(outPumChiWatSec.port_b, VChiWatSecSup_flow.port_a)
    annotation (Line(points={{240,0},{250,0}}, color={0,127,255}));
  connect(supChiWat.port_b, VChiWatSecSup_flow.port_a) annotation (Line(points={{220,0},
          {250,0}}, color={0,0,0}, thickness=0.5));
  connect(VChiWatSecSup_flow.port_b, port_b)
    annotation (Line(points={{270,0},{300,0}}, color={0,0,0},
      thickness=0.5));
  connect(port_a, VChiWatSecRet_flow.port_a)
    annotation (Line(points={{300,-260},{250,-260}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(VChiWatSecRet_flow.port_b, TChiWatSecRet.port_a)
    annotation (Line(points={{230,-260},{210,-260}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(TChiWatSecRet.port_b, intChi.port_aRet) annotation (Line(points={{190,
          -260},{80,-260}}, color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(VChiWatPri_flow.port_b, TChiWatPriSup.port_a)
    annotation (Line(
      points={{140,0},{140,0}},
      color={0,0,0},
      thickness=0.5));
  connect(TChiWatPriSup.port_b, junction.port_1) annotation (Line(
      points={{160,0},{160,0}},
      color={0,0,0},
      thickness=0.5));
  connect(VChiWatByp_flow.port_b, intChi.port_aByp) annotation (Line(points={{170,
          -160},{170,-230},{40,-230}}, color={0,0,0},
      thickness=0.5));
  connect(valChiWatMinByp.port_b, VChiWatByp_flow.port_a) annotation (Line(
        points={{170,-110},{170,-140}},                       color={0,0,0},
      thickness=0.5));
  connect(busWea, out.weaBus) annotation (Line(
      points={{0,280},{0,250},{0.2,250}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], TOut.port)
    annotation (Line(points={{-1,230},{40,230}}, color={0,127,255}));
  connect(phiOut.port, out.ports[2])
    annotation (Line(points={{-40,230},{1,230}}, color={0,127,255}));
  connect(bus, ctl.bus) annotation (Line(
      points={{-300,200},{-10,200}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.busAirHan, busAirHan) annotation (Line(
      points={{10,206},{280,206},{280,240},{300,240}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.busEquZon, busEquZon) annotation (Line(
      points={{10,194},{280,194},{280,160},{300,160}},
      color={255,204,51},
      thickness=0.5));
  connect(bouChiWat.ports[1], intChi.port_aByp)
    annotation (Line(points={{0,-230},{40,-230}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This serves as the base class to build chilled water plant
templates.
The model boundaries are the condenser inlet and outlet ports
on the CW side, and the supply and return ports on the CHW side.
The following components are included.
</p>
<ul>
<li>
Chiller group, as modeled with any classes extending
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup\">
Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup</a>
</li>
<li>
Optional WSE, as modeled with any classes extending
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialEconomizer\">
Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialEconomizer</a>
</li>
<li>
Primary CHW pumps, as modeled with
<a href=\"modelica://Buildings.Templates.Components.Pumps.Multiple\">
Buildings.Templates.Components.Pumps.Multiple</a>
</li>
<li>
Optional secondary CHW pumps, as modeled with
<a href=\"modelica://Buildings.Templates.Components.Pumps.Multiple\">
Buildings.Templates.Components.Pumps.Multiple</a><br/>
Note that if the CHW distribution type is equal to
<code>Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1And2Distributed</code>
then the secondary CHW pumps are not included in this model
and must be modeled separately from the plant.
</li>
<li>
Optional CHW bypass pipe with optional modulating valve<br/>
Those options are automatically selected based on the CHW distribution
type, as specified by an instance of
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Types.Distribution\">
Buildings.Templates.Plants.Chillers.Types.Distribution</a>.
A bypass pipe is modeled for any configuration other than
constant primary-only.
A modulating valve is modeled only for variable primary-only systems.
All other configurations are modeled with a fixed bypass, or
so-called common leg.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
Diagram(graphics={Rectangle(
  extent={{280,0},{281,-240}},
  lineColor={0,0,0},
  visible=not ctl.have_senDpChiWatRemWir)}));
end PartialChilledWaterLoop;
