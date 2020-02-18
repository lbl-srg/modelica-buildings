within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples;
model ParallelConstantFlowRCB3Z1_tmp
  "Example of series connection with constant district water mass flow rate, 3 RC building models (1 zone)"
  extends BaseClasses.PartialParallel_tmp(
    final allowFlowReversal=allowFlowReversalDis,
    nBui=3,
    datDes(
      mCon_flow_nominal={max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui},
      epsPla=0.935));
  parameter Boolean allowFlowReversalDis = true
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter String weaPat = "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"
    "Library path of the weather file";
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k=datDes.mDisPum_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-284,-150},{-264,-130}})));
  Loads.BuildingSpawnZ6WithETS
                            bui[nBui](
    redeclare each final package Medium=Medium,
    each final allowFlowReversalBui=false,
    each final allowFlowReversalDis=allowFlowReversalDis)
    annotation (Placement(transformation(extent={{-24,-70},{-4,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](
    k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  Modelica.Blocks.Sources.Constant mDisPla_flow(k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
equation
  connect(massFlowMainPump.y, pumDis.m_flow_in) annotation (Line(points={{-263,
          -140},{-60,-140},{-60,-132}},     color={0,0,127}));
  connect(pumSto.m_flow_in, massFlowMainPump.y) annotation (Line(points={{-120,
          -112},{-120,-140},{-263,-140}},
                                       color={0,0,127}));
  connect(TSetHeaWatSup.y,bui. TSetHeaWat)
    annotation (Line(points={{-258,220},{-50,220},{-50,-52},{-25,-52}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y,bui. TSetChiWat)
    annotation (Line(points={{-258,180},{-54,180},{-54,-56},{-25,-56}},
                                          color={0,0,127}));
  connect(bui.port_b, dis.ports_aCon) annotation (Line(points={{-4,-60},{2,-60},
          {2,-84},{-2,-84}},           color={0,127,255}));
  connect(dis.ports_bCon, bui.port_a) annotation (Line(points={{-26,-84},{-30,
          -84},{-30,-60},{-24,-60}},           color={0,127,255}));
  for i in 1:nBui loop
  end for;
  connect(mDisPla_flow.y, pla.mPum_flow) annotation (Line(points={{-259,20},{
          -180,20},{-180,-36},{-161,-36}},
                                  color={0,0,127}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-259,60},{-176,60},
          {-176,-32},{-161,-32}},
                              color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
  __Dymola_Commands,
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end ParallelConstantFlowRCB3Z1_tmp;
