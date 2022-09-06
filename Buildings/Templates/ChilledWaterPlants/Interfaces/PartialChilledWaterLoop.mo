within Buildings.Templates.ChilledWaterPlants.Interfaces;
model PartialChilledWaterLoop "Interface class for CHW plant - Including CHW side"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterPlant(
    bus(final nChi=nChi),
    redeclare final package Medium = MediumChiWat,
    final nChi=chiSec.nChi,
    final nPumPri=chiSec.pumPri.nPum,
    final nPumSec=pumSec.nPum,
    final have_parChi=chiSec.is_parallel,
    final have_dedChiWatPum=chiSec.pumPri.is_dedicated,
    final have_secPum=not pumSec.is_none,
    final have_minFloByp=chiSec.pumPri.have_minFloByp,
    dat(
      ctr(
        typ=ctr.typ,
        nSenDpChiWatRem=ctr.nSenDpChiWatRem,
        nChi=ctr.nChi,
        have_eco=ctr.have_eco,
        have_sendpChiWatLoc=ctr.have_sendpChiWatLoc,
        have_fixSpeConWatPum=ctr.have_fixSpeConWatPum,
        have_ctrHeaPre=ctr.have_ctrHeaPre),
      chiSec(
        typ=chiSec.typ,
        nChi=chiSec.nChi,
        chi(typ=chiSec.chi.typ)),
      pumPri(
        typ=chiSec.pumPri.typ,
        nPum=chiSec.pumPri.nPum,
        have_minFloByp=chiSec.pumPri.have_minFloByp,
        have_chiWatChiByp=chiSec.pumPri.have_chiWatChiByp,
        valChiWatChiIso(typ=chiSec.typValChiWatChiIso),
        pum(each typ=chiSec.pumPri.pum.typ)),
      pumSec(
        typ=pumSec.typ,
        nPum=pumSec.nPum,
        pum(each typ=pumSec.pum.typ))));

  replaceable package MediumChiWat=Buildings.Media.Water
    "Chilled water medium";

  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel chiSec
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Interfaces.PartialChillerSection(
    redeclare final package MediumChiWat = MediumChiWat,
    final dat=dat.chiSec,
    final datPumPri=dat.pumPri,
    final have_TPriRet=have_TPriRet) "Chiller section" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-100})),
                         choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
          chiSec "Chillers in parallel"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Series
          chiSec "Chillers in series")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
    pumSec constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Interfaces.PartialSecondaryPump(
      redeclare final package Medium = MediumChiWat, final dat=dat.pumSec)
    "Chilled water secondary pumps" annotation (Placement(transformation(extent={{60,-10},
            {80,10}})),        choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
          pumSec "No secondary pumping"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.Centralized
          pumSec "Centralized secondary pumping")));
  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoop ctr
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Controls.Interfaces.PartialController(
     final dat=dat.ctr) "Plant controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-250,240})),
                          choices(choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Controls.OpenLoop
          con "Open loop controller"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Controls.Guideline36
          con "Guideline 36 controller")));

  Buildings.Templates.Components.Sensors.Temperature TChiWatRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_TChiWatRet,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mSec_flow_nominal)
    "Loop chilled water return temperature"
    annotation (Placement(transformation(extent={{160,-190},{140,-170}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatLoc(
    redeclare final package Medium = MediumChiWat,
    final have_sen=ctr.have_sendpChiWatLoc,
    final text_rotation=90)
    "Local sensor for chilled water differential pressure - Hardwired to plant controller"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={280,-90})));
  Buildings.Templates.Components.Sensors.Temperature TSecSup(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_secPum,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mSec_flow_nominal)
    "Secondary chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));

  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = MediumChiWat, nPorts=2)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,10})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecSup_flow)
    "Secondary chilled water supply flow"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.mSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecRet_flow)
    "Secondary chilled water return volume flow rate"
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  // FIXME: add icons for OA sensors.
  Modelica.Blocks.Routing.RealPassThrough RHAirOut(
    y(final unit="1", final min=0, final max=1))
    "Outdoor air relative humidity"
    annotation (Placement(transformation(extent={{-20,230},{-40,250}})));
  Modelica.Blocks.Routing.RealPassThrough TAirOut(
    y(final unit="K", displayUnit="degC"))
    "Outdoor air dry-bulb temperature"
    annotation (Placement(transformation(extent={{20,250},{40,270}})));
  Modelica.Blocks.Routing.RealPassThrough TWetAirOut(
    y(final unit="K", displayUnit="degC"))
    "FIXME: Outdoor air wet-bulb temperature (should be computed by controller)"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Buildings.Templates.Components.Sensors.Temperature TSecRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_TSecRet,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.mSec_flow_nominal)
    "Secondary chilled water return temperature"
    annotation (Placement(transformation(extent={{120,-190},{100,-170}})));
equation
  // Sensors
  connect(TSecSup.y, bus.TSecSup);
  connect(TChiWatRet.y, bus.TChiWatRet);
  connect(dpChiWatLoc.y, bus.dpChiWatLoc);
  connect(VSecSup_flow.y, bus.VSecSup_flow);
  connect(VSecRet_flow.y, bus.VSecRet_flow);
  connect(TAirOut.y, bus.TAirOut);
  connect(RHAirOut.y, bus.RHAirOut);
  connect(TWetAirOut.y, bus.TWetAirOut);

  // Bus connection
  connect(chiSec.bus, bus);
  connect(pumSec.busCon, bus);

  connect(busWea.TDryBul, TAirOut.u)
    annotation (Line(
      points={{-8.88178e-16,280},{-8.88178e-16,260},{18,260}},
      color={255,204,51},
      thickness=0.5));
  connect(busWea.relHum, RHAirOut.u)
    annotation (Line(
      points={{-8.88178e-16,280},{-2,280},{-2,240},{-18,240}},
      color={255,204,51},
      thickness=0.5));
  connect(busWea.TWetBul, TWetAirOut.u)
    annotation (Line(
      points={{-8.88178e-16,280},{-8.88178e-16,220},{18,220}},
      color={255,204,51},
      thickness=0.5));

  // Controller

  // Mechanical
  connect(dpChiWatLoc.port_b,port_a)
    annotation (Line(points={{280,-100},{280,-180},{300,-180}},
                                                             color={0,127,255}));
  connect(chiSec.port_b2, bouChiWat.ports[1])
    annotation (Line(points={{-24,-90},{-24,-88},{-20,-88},{-20,-3.55271e-15},{
          19,-3.55271e-15}},                                color={0,127,255}));
  connect(bouChiWat.ports[2], pumSec.port_a)
    annotation (Line(points={{21,-3.55271e-15},{21,0},{60,0}},
                                                       color={0,127,255}));
  connect(pumSec.port_b, VSecSup_flow.port_a)
    annotation (Line(points={{80,0},{100,0}},   color={0,127,255}));
  connect(VSecSup_flow.port_b, TSecSup.port_a)
    annotation (Line(points={{120,0},{140,0}},   color={0,127,255}));
  connect(TSecSup.port_b,port_b)
    annotation (Line(points={{160,0},{300,0}},   color={0,127,255}));
  connect(dpChiWatLoc.port_a,port_b)
    annotation (Line(points={{280,-80},{280,0},{300,0}},   color={0,127,255}));

  connect(port_a, TChiWatRet.port_a)
    annotation (Line(points={{300,-180},{160,-180}},
                                                   color={0,127,255}));
  connect(TChiWatRet.port_b, TSecRet.port_a)
    annotation (Line(points={{140,-180},{120,-180}},
                                                   color={0,127,255}));
  connect(TSecRet.port_b, VSecRet_flow.port_b)
    annotation (Line(points={{100,-180},{80,-180}},
                                                  color={0,127,255}));
  connect(bus, ctr.bus) annotation (Line(
      points={{-300,140},{-280,140},{-280,240},{-260,240}},
      color={255,204,51},
      thickness=0.5));
end PartialChilledWaterLoop;
