within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  extends
    Buildings.Templates.ChilledWaterPlant.Interfaces.PartialChilledWaterPlant(
      redeclare final package Medium=MediumChiWat,
      final nChi = chiSec.nChi,
      final nPumPri = pumPri.nPum,
      final nPumSec = pumSec.nPum,
      final have_parChi = chiSec.is_parallel,
      final have_dedChiWatPum = pumPri.is_dedicated,
      final have_secPum = not pumSec.is_none,
      final have_eco = eco.have_eco,
      final have_VChiWatRet_flow = pumPri.have_floSen and not pumPri.have_supFloSen,
      final typValChiWatChi=
        if have_parChi then pumPri.typValChiWatChiPar
        else chiSec.typValChiWatChiSer,
      busCon(final nChi=nChi));

  replaceable package MediumChiWat=Buildings.Media.Water
    "Chilled water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Parallel
    chiSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.PartialChillerSection(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.chiSec)
    "Chiller section"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,10})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.None
    eco constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
      redeclare final package MediumChiWat = MediumChiWat,
      final dat=dat.eco)
    "Chilled water return section"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-72})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.HeaderedSeries
      pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.PartialPrimaryPump(
      redeclare final package Medium = MediumChiWat,
      final dat=dat.pumPri)
    "Chilled water primary pumps"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.None
      pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Interfaces.PartialSecondaryPump(
      redeclare final package Medium = MediumChiWat,
      final dat=dat.pumSec)
    "Chilled water secondary pumps"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.Controls.OpenLoop
    con constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final dat=dat.con)
    "Plant controller"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,60})));

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
    final have_sen=have_secPum,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mChiWatSec_flow_nominal)
    "Secondary chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatRetPla(
    redeclare final package Medium = MediumChiWat,
    final have_sen = have_TChiWatPlaRet,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant chilled water return temperature (plant side of chilled water minimum flow bypass)"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={38,-50})));
  Buildings.Fluid.FixedResistances.Junction mixByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Bypass mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},rotation=0,origin={-10,-50})));
  Buildings.Fluid.FixedResistances.Junction splChiByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.mChiWatPri_flow_nominal*{1,-1,-1},
    final dp_nominal={0,0,0})
    "Splitter for chiller bypass"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},rotation=0,origin={-20,-20})));

  Buildings.Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat,
    nPorts=1)
    annotation (Placement(transformation(
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
  connect(chiSec.busCon, busCon);
  connect(eco.busCon, busCon);
  connect(pumSec.busCon, busCon);

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
  connect(chiSec.ports_b2, pumPri.ports_a) annotation (Line(points={{-34,20},{-34,
          30},{-10,30},{-10,10},{-8.88178e-16,10}},
                                           color={0,127,255}));
  connect(chiSec.port_b2, pumPri.port_a) annotation (Line(points={{-34,20},{-34,
          30},{-10,30},{-10,10},{0,10}}, color={0,127,255}));
  connect(splChiByp.port_2, chiSec.port_a2)
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
  connect(eco.port_b2, mixByp.port_1) annotation (Line(points={{-34,-62},{-34,
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
  connect(VSecRet_flow.port_a, eco.port_a2) annotation (Line(points={{80,-70},
          {-24,-70},{-24,-88},{-34,-88},{-34,-82}}, color={0,127,255}));
  connect(TChiWatRet.port_a,port_a)
    annotation (Line(points={{140,-70},{200,-70}}, color={0,127,255}));
  connect(TChiWatRetPla.port_b, VSecRet_flow1.port_b) annotation (Line(points={{48,
          -50},{60,-50},{60,-20},{40,-20}}, color={0,127,255}));
  connect(VSecRet_flow1.port_a, splChiByp.port_1)
    annotation (Line(points={{20,-20},{-10,-20}}, color={0,127,255}));
end PartialChilledWaterLoop;
