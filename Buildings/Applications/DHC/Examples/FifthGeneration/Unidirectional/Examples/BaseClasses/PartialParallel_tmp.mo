within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples.BaseClasses;
partial model PartialParallel_tmp "Partial model for parallel network"
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
        origin={-150,-80})));
  Networks.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium=Medium,
    m_flow_nominal=datDes.mDisPum_flow_nominal)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=0,
      origin={-60,-120})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium,
    nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-14,-120})));
  Networks.BaseClasses.Pump_m_flow pumSto(
    redeclare final package Medium=Medium,
    m_flow_nominal=datDes.mSto_flow_nominal,
    final allowFlowReversal=allowFlowReversal)
    "Bore field pump"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-120,-100})));
  Networks.BaseClasses.ConnectionSeries conPla(
    redeclare final package Medium=Medium,
    mDis_flow_nominal=datDes.mDisPum_flow_nominal,
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
      origin={-80,-60})));
  Networks.UnidirectionalParallel dis(
    redeclare final package Medium=Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final mEnd_flow_nominal=datDes.mEnd_flow_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final dhDis=datDes.dhDis,
    final dhCon=datDes.dhCon,
    final dhEnd=datDes.dhEnd,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-20,-10},{20,10}},
        rotation=0,
        origin={-14,-94})));
  Networks.BaseClasses.ConnectionSeries conSto(
    redeclare final package Medium=Medium,
    mDis_flow_nominal=datDes.mDisPum_flow_nominal,
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
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
equation
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{-24,-120},{-50,-120}},       color={0,127,255}));
  connect(conPla.port_bDis, dis.port_aDisSup)
    annotation (Line(points={{-80,-50},{-80,-40},{-60,-40},{-60,-94},{-34,-94}},
                                                           color={0,127,255}));
  connect(conSto.port_bDis, conPla.port_aDis)
    annotation (Line(points={{-80,-80},{-80,-70}}, color={0,127,255}));
  connect(borFie.port_b, conSto.port_aCon) annotation (Line(points={{-140,-80},
          {-100,-80},{-100,-84},{-90,-84}}, color={0,127,255}));
  connect(pumDis.port_b, conSto.port_aDis) annotation (Line(points={{-70,-120},
          {-80,-120},{-80,-100}},          color={0,127,255}));
  connect(pla.port_disOut, conPla.port_aCon) annotation (Line(points={{-140,-40},
          {-100,-40},{-100,-54},{-90,-54}},
                                        color={0,127,255}));
  connect(conPla.port_bCon, pla.port_disInl) annotation (Line(points={{-90,-60},
          {-188,-60},{-188,-40},{-160,-40}},                   color={0,127,255}));
  connect(borFie.port_a, pumSto.port_b)
    annotation (Line(points={{-160,-80},{-188,-80},{-188,-100},{-130,-100}},
                                                     color={0,127,255}));
  connect(conSto.port_bCon, pumSto.port_a) annotation (Line(points={{-90,-90},{
          -100,-90},{-100,-100},{-110,-100}},                       color={0,
          127,255}));
  connect(dis.port_bDisRet, pumDis.port_a) annotation (Line(points={{-34,-100},
          {-40,-100},{-40,-120},{-50,-120}}, color={0,127,255}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760));
end PartialParallel_tmp;
