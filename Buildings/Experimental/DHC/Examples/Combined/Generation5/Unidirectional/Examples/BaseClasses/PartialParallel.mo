within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Examples.BaseClasses;
partial model PartialParallel "Partial model for parallel network"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Boolean allowFlowReversal = false
    "Set to true to allow flow reversal in the distribution and connections"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nBui = datDes.nBui
    "Number of buildings connected to DHC system"
    annotation (Evaluate=true);
  inner parameter Data.DesignDataParallel datDes
    "Design data"
    annotation (Placement(transformation(extent={{-340,220},{-320,240}})));
  // COMPONENTS
  ThermalStorages.BoreField borFie(
    redeclare final package Medium=Medium)
    "Bore field"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-80})));
  Networks.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium=Medium,
    m_flow_nominal=datDes.mDis_flow_nominal)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-60})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={112,-20})));
  Networks.BaseClasses.Pump_m_flow pumSto(
    redeclare final package Medium=Medium,
    m_flow_nominal=datDes.mSto_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Bore field pump"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-180,-80})));
  Networks.BaseClasses.ConnectionSeries conPla(
    redeclare final package Medium=Medium,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=0,
    lCon=10,
    dhDis=datDes.dhDis[1],
    dhCon=0.10,
    final allowFlowReversal=allowFlowReversal)
    "Connection to the plant"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-80,-10})));
  Networks.UnidirectionalParallel dis(
    redeclare final package Medium=Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final dhDis=datDes.dhDis,
    final dhCon=datDes.dhCon,
    final dhEnd=datDes.dhEnd,
    final allowFlowReversal=allowFlowReversal)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
  Networks.BaseClasses.ConnectionSeries conSto(
    redeclare final package Medium=Medium,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mSto_flow_nominal,
    lDis=0,
    lCon=0,
    dhDis=datDes.dhDis[1],
    dhCon=datDes.dhDis[1],
    final allowFlowReversal=allowFlowReversal)
    "Connection to the bore field"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-90})));
  CentralPlants.SewageHeatRecovery pla(
    redeclare package Medium=Medium,
    mSew_flow_nominal=datDes.mPla_flow_nominal,
    mDis_flow_nominal=datDes.mPla_flow_nominal,
    dpSew_nominal=datDes.dpPla_nominal,
    dpDis_nominal=datDes.dpPla_nominal,
    epsHex=datDes.epsPla) "Sewage heat recovery plant"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
equation
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{102,-20},{80,-20},{80,-50}}, color={0,127,255}));
  connect(conPla.port_bDis, dis.port_aDisSup)
    annotation (Line(points={{-80,0},{-80,140},{-20,140}}, color={0,127,255}));
  connect(conSto.port_bDis, conPla.port_aDis)
    annotation (Line(points={{-80,-80},{-80,-20}}, color={0,127,255}));
  connect(borFie.port_b, conSto.port_aCon) annotation (Line(points={{-120,-80},
          {-100,-80},{-100,-84},{-90,-84}}, color={0,127,255}));
  connect(pumDis.port_b, conSto.port_aDis) annotation (Line(points={{80,-70},{
          80,-120},{-80,-120},{-80,-100}}, color={0,127,255}));
  connect(pla.port_disOut, conPla.port_aCon) annotation (Line(points={{-140,0},
          {-100,0},{-100,-4},{-90,-4}}, color={0,127,255}));
  connect(conPla.port_bCon, pla.port_disInl) annotation (Line(points={{-90,-10},
          {-100,-10},{-100,-20},{-200,-20},{-200,0},{-160,0}}, color={0,127,255}));
  connect(borFie.port_a, pumSto.port_b)
    annotation (Line(points={{-140,-80},{-170,-80}}, color={0,127,255}));
  connect(conSto.port_bCon, pumSto.port_a) annotation (Line(points={{-90,-90},{
          -100,-90},{-100,-100},{-200,-100},{-200,-80},{-190,-80}}, color={0,
          127,255}));
  connect(dis.port_bDisRet, pumDis.port_a) annotation (Line(points={{-20,134},{
          -40,134},{-40,0},{80,0},{80,-50}}, color={0,127,255}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760));
end PartialParallel;
