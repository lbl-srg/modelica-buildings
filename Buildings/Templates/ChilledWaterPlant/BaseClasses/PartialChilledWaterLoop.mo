within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  extends
    Buildings.Templates.ChilledWaterPlant.Interfaces.PartialChilledWaterPlant(
    redeclare final package Medium=MediumChiWat,
    final have_secondary = not pumSec.dat.is_none,
    final have_eco = retSec.have_eco,
    final have_dedChiWatPum = pumPri.dat.is_dedicated,
    final nChi = chiGro.nChi,
    final nPumPri = pumPri.nPum,
    final nPumSec = pumSec.nPum,
    final is_series = chiGro.is_series,
    busCon(final nChi=nChi));

  replaceable package MediumChiWat=Buildings.Media.Water
    "Chilled water medium";

  parameter Boolean have_chiByp = false "= true if chilled water loop has a chiller bypass"
    annotation(Dialog(enable=have_eco));

  parameter Boolean have_TChiWatPlaRet = not have_secondary
    "= true if plant chilled water return temperature is measured"
    annotation(Dialog(enable=have_secondary));
  final parameter Boolean have_VSecSup_flow = have_secondary and not have_VSecRet_flow
    "= true if secondary supply chilled water flow is measured"
    annotation(Dialog(enable=have_secondary and not have_VSecRet_flow));
  parameter Boolean have_VSecRet_flow = false
    "= true if secondary return chilled water flow is measured"
    annotation(Dialog(enable=have_secondary));
  parameter Boolean have_VChiWatRet_flow = priPum.have_floSen and not priPum.have_supFloSen
    "= true if primary flow is measured on return side";

  final inner parameter Boolean have_parChi=
    dat.chiGro.typ==Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel
    "Set to true if the plant has parallel chillers"
    annotation(Dialog(tab="General", group="Configuration"));

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
    chiGro constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
     redeclare final package MediumChiWat = MediumChiWat,
     final dat=dat.chiGro)
    "Chiller group"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=90,origin={-40,10})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
    retSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection(
    redeclare final package MediumChiWat = MediumChiWat,
    final dat=dat.retSec,
    final m2_flow_nominal=dat.mChiWatPri_flow_nominal) "Chilled water return section"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-72})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Headered
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PartialPrimaryPumpGroup(
      redeclare final package Medium = MediumChiWat,
      final dat=dat.pumPri,
      final have_parChi=have_parChi,
      final have_chiByp=have_chiByp)
    "Chilled water primary pump group"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.None
    pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.PartialSecondaryPumpGroup(
      redeclare final package Medium = MediumChiWat,
      final dat=dat.pumSec)
    "Chilled water secondary pump group"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  inner replaceable Components.Controls.OpenLoop con constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final dat=dat.con)
    "Plant controller"
    annotation (Placement(
      transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={70,60})));
      // FixMe: Does it really need to be the same for all chiller?

  Buildings.Templates.Components.Sensors.Temperature TChiWatRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{140,-80},{120,-60}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium = MediumChiWat,
    final have_sen=con.have_sendpChiWatLoc,
    final text_rotation=90)
    "Local sensor for chilled water differential pressure - Hardwired to plant controller"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={180,-30})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatSecSup(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_secondary,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal)
    "Secondary chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatRetPla(
    redeclare final package Medium = MediumChiWat,
    have_sen = have_TChiWatPlaRet,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant chilled water return temperature (plant side of chilled water minimum flow bypass)"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={38,-50})));
  Fluid.FixedResistances.Junction mixByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Bypass mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},rotation=0,origin={-10,-50})));
  Fluid.FixedResistances.Junction splChiByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal*{1,-1,-1},
    final dp_nominal={0,0,0})
    "Splitter for waterside economizer bypass"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},rotation=0,origin={-20,-20})));

  Fluid.Sources.Boundary_pT bouChiWat(redeclare final package Medium =
        MediumChiWat,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,30})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecSup_flow)
    "Secondary chilled water supply flow"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecRet_flow) "Secondary chilled water return flow"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  // FIXME: add icons for OA sensors.
  Modelica.Blocks.Routing.RealPassThrough RHAirOut(
    y(final unit="1", final min=0, final max=1))
    "Outdoor air relative humidity"
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  Modelica.Blocks.Routing.RealPassThrough TAirOut(
    y(final unit="K", displayUnit="degC"))
    "Outdoor air dry-bulb temperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Routing.RealPassThrough TWetAirOut(
    y(final unit="K", displayUnit="degC"))
    "FIXME: Outdoor air wet-bulb temperature (should be computed by controller)"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecRet_flow1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VChiWatRet_flow) "Secondary chilled water return flow"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
equation
  // Sensors
  connect(TChiWatRetPla.y, busCon.TChiWatRetPla);
  connect(TChiWatSecSup.y, busCon.TChiWatSecSup);
  connect(TChiWatRet.y, busCon.TChiWatRet);
  connect(dpChiWatLoc.y, busCon.dpChiWatLoc);
  connect(VSecSup_flow.y, busCon.VSecSup_flow);
  connect(VSecRet_flow.y, busCon.VSecRet_flow);
  connect(TAirOut.y, busCon.TAirOut);
  connect(RHAirOut.y, busCon.RHAirOut);
  connect(TWetAirOut.y, busCon.TWetAirOut);


  // Bus connection
  connect(pumPri.busCon, busCon);
  connect(chiGro.busCon, busCon);
  connect(retSec.busCon, busCon);
  connect(pumSec.busCon, busCon);

  // Controller
  connect(con.busCon, busCon) annotation (Line(
      points={{80,60},{200,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  // Mechanical
  connect(chiGro.ports_b2, pumPri.ports_parallel)
    annotation (Line(points={{-30,16},{-20,16},{-20,10},{-8.88178e-16,10}},
      color={0,127,255}));
  connect(chiGro.port_b2, pumPri.port_series)
    annotation (Line(points={{-34,20},{-34,30},{-10,30},{-10,16},{0,16}},
      color={0,127,255}));
  connect(splChiByp.port_2, chiGro.port_a2)
    annotation (Line(points={{-30,-20},{-34,-20},{-34,0}}, color={0,127,255}));
  connect(splChiByp.port_3,pumPri. port_ChiByp)
    annotation (Line(points={{-20,-10},{-20,4},{0,4}}, color={0,127,255}));
  connect(pumPri.port_b, pumSec.port_a)
    annotation (Line(points={{20,10},{60,10}}, color={0,127,255}));
  connect(mixByp.port_3, pumPri.port_byp)
    annotation (Line(points={{-10,-40},{-10,-34},{10,-34},{10,0}},
    color={0,127,255}));
  connect(TChiWatSecSup.port_b,port_b)
    annotation (Line(points={{160,10},{200,10}}, color={0,127,255}));
  connect(dpChiWatLoc.port_a,port_b)
    annotation (Line(points={{180,-20},{180,10},{200,10}}, color={0,127,255}));
  connect(dpChiWatLoc.port_b,port_a)  annotation (Line(points={{180,-40},{180,-70},
          {200,-70}}, color={0,127,255}));
  connect(retSec.port_b2, mixByp.port_1) annotation (Line(points={{-34,-62},{-34,
          -50},{-20,-50}}, color={0,127,255}));
  connect(mixByp.port_2,TChiWatRetPla. port_a)
    annotation (Line(points={{0,-50},{28,-50}}, color={0,127,255}));
  connect(bouChiWat.ports[1], pumPri.port_b)
    annotation (Line(points={{40,20},{40,10},{20,10}}, color={0,127,255}));
  connect(pumSec.port_b, VSecSup_flow.port_a)
    annotation (Line(points={{80,10},{100,10}}, color={0,127,255}));
  connect(VSecSup_flow.port_b, TChiWatSecSup.port_a)
    annotation (Line(points={{120,10},{140,10}}, color={0,127,255}));
  connect(TChiWatRet.port_b, VSecRet_flow.port_b)
    annotation (Line(points={{120,-70},{100,-70}},color={0,127,255}));
  connect(VSecRet_flow.port_a, retSec.port_a2) annotation (Line(points={{80,-70},
          {-24,-70},{-24,-88},{-34,-88},{-34,-82}}, color={0,127,255}));
  connect(weaBus.TDryBul, TAirOut.u) annotation (Line(
      points={{0,100},{0,80},{18,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.relHum, RHAirOut.u) annotation (Line(
      points={{-8.88178e-16,100},{-2,100},{-2,80},{-18,80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TWetBul, TWetAirOut.u) annotation (Line(
      points={{0,100},{0,120},{18,120}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiWatRet.port_a,port_a)
    annotation (Line(points={{140,-70},{200,-70}}, color={0,127,255}));
  connect(TChiWatRetPla.port_b, VSecRet_flow1.port_b) annotation (Line(points={{48,
          -50},{60,-50},{60,-20},{40,-20}}, color={0,127,255}));
  connect(VSecRet_flow1.port_a, splChiByp.port_1)
    annotation (Line(points={{20,-20},{-10,-20}}, color={0,127,255}));
end PartialChilledWaterLoop;
