within Buildings.Templates.ChilledWaterPlant.BaseClasses;
model PartialChilledWaterLoop
  extends
    Buildings.Templates.ChilledWaterPlant.Interfaces.PartialChilledWaterPlant(
    redeclare final package Medium=MediumCHW,
    final nChi=chiGro.nChi);

  replaceable package MediumCHW=Buildings.Media.Water "Chilled water medium";

  parameter Boolean have_byp = false "= true if chilled water loop has a minimum flow bypass"
    annotation(Dialog(enable=have_secondary));
  parameter Boolean have_ChiByp = false "= true if chilled water loop has a chiller bypass"
    annotation(Dialog(enable=have_WSE));

  final inner parameter Boolean have_secondary = not pumSec.is_none
    "= true if plant has secondary pumping";
  final inner parameter Boolean have_WSE = not retSec.is_none
    "=true if plant has waterside economizer";

  parameter Boolean have_TPlaCHWRet = not have_secondary
    " = true if plant chilled water return temperature is measured"
    annotation(Dialog(enable=have_secondary));
  final parameter Boolean have_VSecSup_flow = have_secondary and not have_VSecRet_flow
    " = true if secondary supply chilled water flow is measured"
    annotation(Dialog(enable=have_secondary and not have_VSecRet_flow));
  parameter Boolean have_VSecRet_flow = false
    " = true if secondary return chilled water flow is measured"
    annotation(Dialog(enable=have_secondary));

  final inner parameter Integer nPumPri = pumPri.nPum "Number of primary pumps";
  final inner parameter Integer nPumSec = if not have_secondary then 0 else pumSec.nPum "Number of secondary pumps";

  parameter Modelica.Units.SI.MassFlowRate mPri_flow_nominal=
    dat.getReal(varName=id + ".ChilledWater.mPri_flow_nominal.value")
    "Primary mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal=
    if not have_secondary then mPri_flow_nominal else
    dat.getReal(varName=id + ".ChilledWater.mSec_flow_nominal.value")
    "Secondary mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal=
    dat.getReal(varName=id + ".ChilledWater.dpSetPoi.value")
    "Differential pressure setpoint on the demand side";

  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.ChillerParallel
    chiGro(final have_dedPum=pumPri.is_dedicated)
           constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ChillerGroup.Interfaces.PartialChillerGroup(
     redeclare final package MediumCHW = MediumCHW,
     final m2_flow_nominal=mPri_flow_nominal,
     final isAirCoo=isAirCoo)
    "Chiller group"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},rotation=90,origin={-40,10})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.NoEconomizer
    retSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection(
    redeclare final package MediumCHW = MediumCHW,
    final isAirCoo=isAirCoo,
    final m2_flow_nominal=mPri_flow_nominal) "Chilled water return section"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-72})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Headered
    pumPri constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumpGroup.Interfaces.PartialPrimaryPumpGroup(
      redeclare final package Medium = MediumCHW,
      final mTot_flow_nominal=mPri_flow_nominal,
      final dp_nominal=dpPri_nominal,
      final nChi=nChi,
      final have_ParChi=chiGro.typ == Buildings.Templates.ChilledWaterPlant.Components.Types.ChillerGroup.ChillerParallel,
      final have_byp=have_byp,
      final have_ChiByp=have_ChiByp,
      final have_comLeg=have_secondary)
    "Chilled water primary pump group"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  inner replaceable
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.None
    pumSec constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.PartialSecondaryPumpGroup(
      redeclare final package Medium = MediumCHW,
      final mTot_flow_nominal=mSec_flow_nominal,
      final dp_nominal=dpSec_nominal)
    "Chilled water secondary pump group"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  inner replaceable Components.Controls.OpenLoop con
    constrainedby
    Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.PartialController(
      final nChi=nChi,
      final nPumPri=nPumPri,
      final nPumSec=nPumSec,
      final isAirCoo=isAirCoo)
    annotation (Placement(
      transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={70,60})));

  Buildings.Templates.Components.Sensors.Temperature TCHWRet(
    redeclare final package Medium = MediumCHW,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=mSec_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{120,-80},{100,-60}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpCHW(
    redeclare final package Medium = MediumCHW,
    final have_sen=true,
    final text_rotation=90)
    "Chilled water demand side differential pressure"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=90,
        origin={180,-30})));
  Buildings.Templates.Components.Sensors.Temperature TSCHWSup(
    redeclare final package Medium = MediumCHW,
    final have_sen=have_secondary,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=mSec_flow_nominal)
    "Secondary chilled water supply temperature"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  Buildings.Templates.Components.Sensors.Temperature TPlaCHWRet(
    redeclare final package Medium = MediumCHW,
    have_sen = have_TPlaCHWRet,
    final m_flow_nominal=mPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant chilled water return temperature after bypass"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={30,-50})));
  Fluid.FixedResistances.Junction mixByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=mPri_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0})
    "Bypass mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},rotation=0,origin={-10,-50})));
  Fluid.FixedResistances.Junction splChiByp(
    redeclare package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each final m_flow_nominal=mPri_flow_nominal*{1,-1,-1},
    final dp_nominal={0,0,0})
    "Splitter for waterside economizer bypass"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},rotation=0,origin={-20,-20})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater chwCon(
    final nChi=nChi,
    final nPumPri=nPumPri,
    final nPumSec=nPumSec)
    "Chilled water loop control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={200,60})));

  Fluid.Sources.Boundary_pT bouCHW(redeclare final package Medium = MediumCHW,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,30})));
  Buildings.Templates.Components.Sensors.Temperature TCHWRet1(
    redeclare final package Medium = MediumCHW,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=mSec_flow_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecSup_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecSup_flow)
    "Secondary chilled water supply flow"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VSecRet_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mSec_flow_nominal,
    final typ = Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    have_sen=have_VSecRet_flow) "Secondary chilled water return flow"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
protected
  parameter Modelica.Units.SI.PressureDifference dpPri_nominal=
    if not have_secondary then chiGro.dpCHW_nominal + dpDem_nominal
    else chiGro.dpCHW_nominal
    "Nominal pressure drop for primary loop";
  parameter Modelica.Units.SI.PressureDifference dpSec_nominal=
    if not have_secondary then 0 else dpDem_nominal
    "Nominal pressure drop for secondary loop";

equation
  // Sensors
  connect(TPlaCHWRet.y, chwCon.TPlaCHWRet);
  connect(TSCHWSup.y, chwCon.TSCHWSup);
  connect(TCHWRet.y, chwCon.TCHWRet);
  connect(dpCHW.y, chwCon.dpCHW);
  connect(VSecSup_flow.y, chwCon.VSecSup_flow);
  connect(VSecRet_flow.y, chwCon.VSecRet_flow);

  // Bus connection
  connect(pumPri.busCon, chwCon.pumPri);
  connect(chiGro.busCon, chwCon);
  connect(retSec.busCon, chwCon.wse);
  connect(pumSec.busCon, chwCon.pumSec);

  // Controller
  connect(con.busCHW, chwCon) annotation (Line(
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
  connect(TPlaCHWRet.port_b, splChiByp.port_1)
    annotation (Line(points={{40,-50},{60,-50},{60,-20},{-10,-20}},
    color={0,127,255}));
  connect(mixByp.port_3, pumPri.port_byp)
    annotation (Line(points={{-10,-40},{-10,-34},{10,-34},{10,0}},
    color={0,127,255}));
  connect(TSCHWSup.port_b, port_a)
    annotation (Line(points={{160,10},{200,10}}, color={0,127,255}));
  connect(dpCHW.port_a, port_a)
    annotation (Line(points={{180,-20},{180,10},{200,10}}, color={0,127,255}));
  connect(dpCHW.port_b, port_b) annotation (Line(points={{180,-40},{180,-70},{
          200,-70}}, color={0,127,255}));
  connect(retSec.port_b2, mixByp.port_1) annotation (Line(points={{-34,-62},{-34,
          -50},{-20,-50}}, color={0,127,255}));
  connect(mixByp.port_2,TPlaCHWRet. port_a)
    annotation (Line(points={{0,-50},{20,-50}}, color={0,127,255}));
  connect(bouCHW.ports[1], pumPri.port_b)
    annotation (Line(points={{40,20},{40,10},{20,10}}, color={0,127,255}));
  connect(TCHWRet.port_a, TCHWRet1.port_b)
    annotation (Line(points={{120,-70},{140,-70}}, color={0,127,255}));
  connect(TCHWRet1.port_a, port_b)
    annotation (Line(points={{160,-70},{200,-70}}, color={0,127,255}));
  connect(pumSec.port_b, VSecSup_flow.port_a)
    annotation (Line(points={{80,10},{100,10}}, color={0,127,255}));
  connect(VSecSup_flow.port_b, TSCHWSup.port_a)
    annotation (Line(points={{120,10},{140,10}}, color={0,127,255}));
  connect(TCHWRet.port_b, VSecRet_flow.port_b)
    annotation (Line(points={{100,-70},{80,-70}}, color={0,127,255}));
  connect(VSecRet_flow.port_a, retSec.port_a2) annotation (Line(points={{60,-70},
          {-24,-70},{-24,-88},{-34,-88},{-34,-82}}, color={0,127,255}));
end PartialChilledWaterLoop;
