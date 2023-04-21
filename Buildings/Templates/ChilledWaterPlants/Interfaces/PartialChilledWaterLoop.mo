within Buildings.Templates.ChilledWaterPlants.Interfaces;
partial model PartialChilledWaterLoop
  "Partial chilled water plant with chiller group and CHW pumps"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterPlant(
    final typValChiWatChiIso=chi.typValChiWatChiIso,
    final typValConWatChiIso=chi.typValConWatChiIso,
    final typEco=eco.typ,
    final typCtl=ctl.typ,
    dat(
      typCtlHea=ctl.typCtlHea,
      typMeaCtlChiWatPri=ctl.typMeaCtlChiWatPri,
      have_senDpChiWatLoc=ctl.have_senDpChiWatLoc,
      nSenDpChiWatRem=ctl.nSenDpChiWatRem,
      nLooChiWatSec=ctl.nLooChiWatSec,
      have_senVChiWatSec=ctl.have_senVChiWatSec,
      have_senLevCoo=ctl.have_senLevCoo));

  replaceable Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups.Compression chi
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumCon,
    final nChi=nChi,
    final typChi=typChi,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final have_varPumConWat=have_varPumConWat,
    final typCtlHea=ctl.typCtlHea,
    final typDisChiWat=typDisChiWat,
    final typMeaCtlChiWatPri=ctl.typMeaCtlChiWatPri,
    final typEco=typEco,
    final dat=dat.chi,
    final tau=tau,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal)
    "Chillers"
    annotation (
    Dialog(group="Chillers"),
    Placement(transformation(extent={{-60,-190},{-20,10}})));

  // Primary CHW loop
  Components.Routing.ChillersToPrimaryPumps intChi(
    redeclare final package MediumChiWat = MediumChiWat,
    final nChi=nChi,
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
    annotation (
    Placement(transformation(extent={{0,-250},{40,10}})));
  Buildings.Templates.Components.Pumps.Multiple pumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPum=nPumChiWatPri,
    final have_var=have_varPumChiWatPri,
    final have_varCom=have_varComPumChiWatPri,
    final dat=dat.pumChiWatPri,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300)
    "Primary CHW pumps"
    annotation (
    Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatPri(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=-300)
    "Primary CHW pumps outlet manifold"
    annotation (
    Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatMinByp(
    redeclare final package Medium=MediumChiWat,
    final dat=dat.valChiWatMinByp,
    final allowFlowReversal=allowFlowReversal)
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
    "CHW minimum flow bypass valve"
    annotation (
    Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={130,-100})));
  Buildings.Templates.Components.Routing.PassThroughFluid bypChiWatFix(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    if have_bypChiWatFix
    "Fixed CHW bypass (common leg)"
    annotation (
    Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={150,-100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatPri and
    ctl.locSenFloChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary CHW volume flow rate"
    annotation (
    Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Fluid.FixedResistances.Junction junByp(
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
        origin={140,0})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium = MediumChiWat,
    final have_sen=ctl.have_senTChiWatPriSup,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Primary CHW supply temperature"
    annotation (
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatByp_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=
      (typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
      or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed) and
      ctl.typMeaCtlChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement.FlowDecoupler,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Decoupler CHW volume flow rate"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={140,-150})));

  // CW loop
  Buildings.Templates.Components.Routing.MultipleToMultiple inlConChi(
    redeclare final package Medium = MediumCon,
    final nPorts_a=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
         then nPumConWat else nChi,
    final nPorts_b=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
         and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
         then nChi + 1 else nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final have_comLeg=typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
         and typArrPumConWat == Buildings.Templates.Components.Types.PumpArrangement.Headered,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_extend=200,
    icon_dy=300)
    "Chiller group condenser fluid inlet"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outConChi(
    redeclare final package Medium = MediumCon,
    final nPorts=if typChi == Buildings.Templates.Components.Types.Chiller.WaterCooled
      and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
      then nChi + 1 else nChi,
    final m_flow_nominal=mCon_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dash=true,
    icon_dy=-300)
    "Chiller group condenser fluid outlet"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

  // Secondary CHW loop
  Buildings.Templates.Components.Routing.SingleToMultiple inlPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300)
    if have_pumChiWatSec
    "Secondary CHW pumps inlet manifold"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
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
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Templates.Components.Routing.MultipleToSingle outPumChiWatSec(
    redeclare final package Medium=MediumChiWat,
    final nPorts=nPumChiWatSec,
    final m_flow_nominal=mChiWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    icon_dy=300)
    if have_pumChiWatSec
    "Secondary CHW pumps outlet manifold"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid supChiWat(
    redeclare final package Medium=MediumChiWat,
    final allowFlowReversal=allowFlowReversal)
    if not have_pumChiWatSec
    "CHW supply line - Without secondary CHW pumps"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium=MediumChiWat,
    final have_sen=ctl.have_senDpChiWatLoc,
    final allowFlowReversal=allowFlowReversal,
    final text_rotation=-90)
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
      Buildings.Templates.ChilledWaterPlants.Types.SensorLocation.Supply,
    final text_flip=false,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{230,-10},{250,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatSecRet_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWat_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=ctl.have_senVChiWatSec and ctl.locSenFloChiWatSec ==
        Buildings.Templates.ChilledWaterPlants.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Secondary CHW volume flow rate"
    annotation (Placement(transformation(extent={{250,-250},{230,-230}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=ctl.have_senTChiWatSecRet,
    final m_flow_nominal=mChiWat_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Secondary CHW return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={200,-240})));

  // WSE
  replaceable Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat=MediumChiWat,
      redeclare final package MediumConWat=MediumCon,
      final dat=dat.eco,
      final allowFlowReversal=allowFlowReversal,
      final energyDynamics=energyDynamics)
    "Waterside economizer"
    annotation (
    Dialog(group="Waterside economizer"),
    choices(
      choice(redeclare replaceable
        Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco
        "No waterside economizer"),
      choice(redeclare replaceable
        Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithPump eco
        "Heat exchanger with pump for CHW flow control"),
      choice(redeclare replaceable
        Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithValve eco
        "Heat exchanger with bypass valve for CHW flow control")),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-220})));

  // Controls
  replaceable Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoop ctl
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialController(
    final nAirHan=nAirHan,
    final nEquZon=nEquZon,
    final dat=dat.ctl,
    final typChi=typChi,
    final nChi=nChi,
    final typArrChi=typArrChi,
    final typDisChiWat=typDisChiWat,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final typArrPumConWat=typArrPumConWat,
    final have_varPumChiWatPri=have_varPumChiWatPri,
    final have_varComPumChiWatPri=have_varComPumChiWatPri,
    final have_varPumConWat=have_varPumConWat,
    final have_varComPumConWat=have_varComPumConWat,
    final typEco=typEco,
    final typCoo=typCoo,
    final nCoo=nCoo,
    final nPumChiWatSec=nPumChiWatSec,
    final typValChiWatChiIso=typValChiWatChiIso,
    final typValConWatChiIso=typValConWatChiIso,
    final typValCooInlIso=typValCooInlIso,
    final typValCooOutIso=typValCooOutIso)
    "Plant controller"
    annotation (
    Dialog(group="Controls"),
    Placement(transformation(extent={{-10,130},{10,150}})));

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
  /* Control point connection - stop */
  connect(intChi.ports_bSup, pumChiWatPri.ports_a)
    annotation (Line(points={{40,0},{40,0}}, color={0,127,255}));
  connect(chi.ports_bCon, outConChi.ports_a[1:nChi])
    annotation (Line(points={{-60,0},{-60,0}}, color={0,127,255}));
  connect(pumChiWatPri.ports_b, outPumChiWatPri.ports_a)
    annotation (Line(points={{60,0},{60,0}},      color={0,127,255}));
  connect(inlPumChiWatSec.ports_b, pumChiWatSec.ports_a)
    annotation (Line(points={{180,0},{180,0}},     color={0,127,255}));
  connect(pumChiWatSec.ports_b, outPumChiWatSec.ports_a)
    annotation (Line(points={{200,0},{200,0}},     color={0,127,255}));
  connect(intChi.ports_bRet[1:nChi], chi.ports_aChiWat) annotation (Line(points=
         {{0,-240},{-12,-240},{-12,-180},{-20,-180}}, color={0,127,255}));
  connect(chi.ports_bChiWat, intChi.ports_aSup[1:nChi]) annotation (Line(points=
         {{-20,0},{-10,0},{-10,0},{0,0}}, color={0,127,255}));
  connect(intChi.ports_bRet[nChi + 1], eco.port_a) annotation (Line(points={{0,
          -240},{-40,-240},{-40,-230}}, color={0,127,255}));
  connect(eco.port_b, intChi.ports_aSup[nChi + 1]) annotation (Line(points={{-40,
          -210},{-40,-200},{-6,-200},{-6,0},{0,0}}, color={0,127,255}));
  connect(inlConChi.ports_b[1:nChi], chi.ports_aCon)
    annotation (Line(points={{-80,-180},{-60,-180}}, color={0,127,255}));
  connect(inlConChi.ports_b[nChi + 1], eco.port_aConWat) annotation (Line(
        points={{-80,-180},{-68,-180},{-68,-210},{-49,-210}},
                                                   color={0,127,255}));
  connect(eco.port_bConWat, outConChi.ports_a[nChi + 1]) annotation (Line(
        points={{-49,-230},{-60,-230},{-60,0}},         color={0,127,255}));
  connect(dpChiWatLoc.port_a, port_b)
    annotation (Line(points={{280,-110},{280,0},{300,0}},color={0,127,255}));
  connect(dpChiWatLoc.port_b, port_a) annotation (Line(points={{280,-130},{280,
          -240},{300,-240}},
                       color={0,127,255}));
  connect(outPumChiWatPri.port_b, VChiWatPri_flow.port_a)
    annotation (Line(points={{80,0},{80,0}}, color={0,127,255}));
  connect(junByp.port_2, inlPumChiWatSec.port_a)
    annotation (Line(points={{150,0},{160,0}}, color={0,127,255}));
  connect(junByp.port_3, valChiWatMinByp.port_a)
    annotation (Line(points={{140,-10},{140,-80},{130,-80},{130,-90}},
                                                   color={0,127,255}));
  connect(junByp.port_3, bypChiWatFix.port_a) annotation (Line(points={{140,-10},
          {140,-80},{150,-80},{150,-90}}, color={0,127,255}));
  connect(junByp.port_2, supChiWat.port_a) annotation (Line(points={{150,0},{160,
          0},{160,-40},{180,-40}}, color={0,127,255}));
  connect(outPumChiWatSec.port_b, VChiWatSecSup_flow.port_a)
    annotation (Line(points={{220,0},{230,0}}, color={0,127,255}));
  connect(supChiWat.port_b, VChiWatSecSup_flow.port_a) annotation (Line(points={
          {200,-40},{220,-40},{220,0},{230,0}}, color={0,127,255}));
  connect(VChiWatSecSup_flow.port_b, port_b)
    annotation (Line(points={{250,0},{300,0}}, color={0,127,255}));
  connect(port_a, VChiWatSecRet_flow.port_a)
    annotation (Line(points={{300,-240},{250,-240}}, color={0,127,255}));
  connect(VChiWatSecRet_flow.port_b, TChiWatSecRet.port_a)
    annotation (Line(points={{230,-240},{210,-240}}, color={0,127,255}));
  connect(TChiWatSecRet.port_b, intChi.port_aRet) annotation (Line(points={{190,
          -240},{60,-240},{60,-240},{40,-240}}, color={0,127,255}));
  connect(VChiWatPri_flow.port_b, TChiWatPriSup.port_a)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(TChiWatPriSup.port_b, junByp.port_1)
    annotation (Line(points={{120,0},{130,0}}, color={0,127,255}));
  connect(bypChiWatFix.port_b, VChiWatByp_flow.port_a)
    annotation (Line(points={{150,-110},{150,-120},{140,-120},{140,-140}},
                                                   color={0,127,255}));
  connect(VChiWatByp_flow.port_b, intChi.port_aByp) annotation (Line(points={{
          140,-160},{140,-200},{40,-200}}, color={0,127,255}));
  connect(valChiWatMinByp.port_b, VChiWatByp_flow.port_a) annotation (Line(
        points={{130,-110},{130,-120},{140,-120},{140,-140}}, color={0,127,255}));
  connect(busWea, out.weaBus) annotation (Line(
      points={{0,280},{0,250},{0.2,250}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], TOut.port)
    annotation (Line(points={{-1,230},{40,230}}, color={0,127,255}));
  connect(phiOut.port, out.ports[2])
    annotation (Line(points={{-40,230},{1,230}}, color={0,127,255}));
  connect(bus, ctl.bus) annotation (Line(
      points={{-300,140},{-10,140}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.busAirHan, busAirHan) annotation (Line(
      points={{10,146},{20,146},{20,180},{300,180}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.busEquZon, busEquZon) annotation (Line(
      points={{10,134},{20,134},{20,100},{300,100}},
      color={255,204,51},
      thickness=0.5));
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
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup</a>
</li>
<li>
Optional WSE, as modeled with any classes extending
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer\">
Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialEconomizer</a>
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
<code>Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed</code>
then the secondary CHW pumps are not included in this model
and must be modeled separately from the plant.
</li>
<li>
Optional CHW bypass pipe with optional modulating valve<br/>
Those options are automatically selected based on the CHW distribution
type, as specified by an instance of
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Types.Distribution\">
Buildings.Templates.ChilledWaterPlants.Types.Distribution</a>.
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
</html>"));
end PartialChilledWaterLoop;
