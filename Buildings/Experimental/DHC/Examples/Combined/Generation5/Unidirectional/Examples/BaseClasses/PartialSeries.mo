within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Examples.BaseClasses;
partial model PartialSeries "Partial model for series network"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  constant Real facMul = 10
    "Building loads multiplier factor";
  parameter Boolean allowFlowReversalSer = true
    "Set to true to allow flow reversal in the service lines"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal for in-building systems"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nBui = datDes.nBui
    "Number of buildings connected to DHC system"
    annotation (Evaluate=true);
  inner parameter Data.DesignDataSeries datDes(
    mCon_flow_nominal=bui.ets.mDisWat_flow_nominal,
    epsPla=0.935)
    "Design data"
    annotation (Placement(transformation(extent={{-340,220},{-320,240}})));
  // COMPONENTS
  ThermalStorages.BoreField borFie(
    redeclare final package Medium = Medium)
    "Bore field"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-80})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-60})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=Medium,
    final nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-20})));
  DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumSto(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mSto_flow_nominal)
    "Bore field pump"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={-180,-80})));
  Networks.BaseClasses.ConnectionSeries conPla(
    redeclare final package Medium=Medium,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=0,
    lCon=10,
    final dhDis=datDes.dhDis,
    dhCon=0.10,
    final allowFlowReversal=allowFlowReversalSer)
    "Connection to the plant"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-10})));
  Networks.BaseClasses.ConnectionSeries conSto(
    redeclare final package Medium=Medium,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mSto_flow_nominal,
    lDis=0,
    lCon=0,
    final dhDis=datDes.dhDis,
    final dhCon=datDes.dhDis,
    final allowFlowReversal=allowFlowReversalSer)
    "Connection to the bore field"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-90})));
  CentralPlants.SewageHeatRecovery pla(
    redeclare final package Medium=Medium,
    final mSew_flow_nominal=datDes.mPla_flow_nominal,
    final mDis_flow_nominal=datDes.mPla_flow_nominal,
    final dpSew_nominal=datDes.dpPla_nominal,
    final dpDis_nominal=datDes.dpPla_nominal,
    final epsHex=datDes.epsPla)
    "Sewage heat recovery plant"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Networks.UnidirectionalSeries dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final dhDis=datDes.dhDis,
    final dhCon=datDes.dhCon,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
  Fluid.Sensors.TemperatureTwoPort TDisWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,20})));
  Fluid.Sensors.TemperatureTwoPort TDisWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,0})));
  Fluid.Sensors.TemperatureTwoPort TDisWatBorLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water borefield leaving temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-40})));
  replaceable Loads.BaseClasses.PartialBuildingWithETS bui[nBui]
    constrainedby Loads.BaseClasses.PartialBuildingWithETS(
      bui(each final facMul=facMul),
      redeclare each final package MediumBui=Medium,
      redeclare each final package MediumSer=Medium,
      each final allowFlowReversalBui=allowFlowReversalBui,
      each final allowFlowReversalSer=allowFlowReversalSer)
    "Building and ETS"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMaxSet[nBui](k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMinSet[nBui](
    each k=28 + 273.15)
    "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-280,230},{-260,250}})));
  Results res(
    PHeaPum=sum(bui.PHea),
    PPumETS=sum(bui.ets.PPum),
    PPumDis=pumDis.P,
    PPumSto=pumSto.P,
    PPumPla=pla.PPum,
    QHea_flow=sum(bui.QHea_flow),
    QCoo_flow=sum(bui.QCoo_flow))
    "Simulation results";
model Results
  "Model to store the results of the simulation"
  input Modelica.SIunits.Power PHeaPum "Total heat pump power";
  input Modelica.SIunits.Power PPumETS "ETS pump power";
  input Modelica.SIunits.Power PPumDis "Distribution pump power";
  input Modelica.SIunits.Power PPumPla "Plant pump power";
  input Modelica.SIunits.Power PPumSto "Storage pump power";
  input Modelica.SIunits.Power QHea_flow "Heating flow rate";
  input Modelica.SIunits.Power QCoo_flow "Cooling flow rate";
  Modelica.SIunits.Power PPum "Total pump power";
  Modelica.SIunits.Power PTot "Total power";
  Real EHeaPum(start=0, fixed=true) "Heat pump electric energy";
  Real EPumETS(start=0, fixed=true) "ETS pump electric energy";
  Real EPumDis(start=0, fixed=true) "Distribution pump electric energy";
  Real EPumPla(start=0, fixed=true) "Plant pump electric energy";
  Real EPumSto(start=0, fixed=true) "Storage pump electric energy";
  Real EPum(start=0, fixed=true) "Total pump electric energy";
  Real ETot(start=0, fixed=true) "Total electric energy";
  Real QHea(start=0, fixed=true) "Heating energy";
  Real QCoo(start=0, fixed=true) "Cooling energy";
equation
  PPum = PPumETS + PPumDis + PPumPla + PPumSto;
  PTot = PPum + PHeaPum;
  der(EHeaPum) = PHeaPum;
  der(EPumETS) = PPumETS;
  der(EPumDis) = PPumDis;
  der(EPumPla) = PPumPla;
  der(EPumSto) = PPumSto;
  der(EPum) = PPum;
  der(ETot) = PTot;
  der(QHea) = QHea_flow;
  der(QCoo) = QCoo_flow;
end Results;
equation
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{102,-20},{80,-20},{80,-50}}, color={0,127,255}));
  connect(borFie.port_b, conSto.port_aCon) annotation (Line(points={{-120,-80},
          {-100,-80},{-100,-84},{-90,-84}}, color={0,127,255}));
  connect(pumDis.port_b, conSto.port_aDis) annotation (Line(points={{80,-70},{
          80,-120},{-80,-120},{-80,-100}}, color={0,127,255}));
  connect(borFie.port_a, pumSto.port_b)
    annotation (Line(points={{-140,-80},{-170,-80}}, color={0,127,255}));
  connect(conSto.port_bCon, pumSto.port_a) annotation (Line(points={{-90,-90},{
          -100,-90},{-100,-100},{-200,-100},{-200,-80},{-190,-80}}, color={0,
          127,255}));
  connect(conPla.port_bDis, TDisWatSup.port_a)
    annotation (Line(points={{-80,0},{-80,10}}, color={0,127,255}));
  connect(TDisWatSup.port_b, dis.port_aDisSup) annotation (Line(points={{-80,30},
          {-80,140},{-20,140}}, color={0,127,255}));
  connect(dis.port_bDisSup, TDisWatRet.port_a)
    annotation (Line(points={{20,140},{80,140},{80,10}}, color={0,127,255}));
  connect(TDisWatRet.port_b, pumDis.port_a)
    annotation (Line(points={{80,-10},{80,-50}}, color={0,127,255}));
  connect(conSto.port_bDis, TDisWatBorLvg.port_a)
    annotation (Line(points={{-80,-80},{-80,-50}}, color={0,127,255}));
  connect(TDisWatBorLvg.port_b, conPla.port_aDis)
    annotation (Line(points={{-80,-30},{-80,-20}}, color={0,127,255}));
  connect(bui.port_bSerAmb, dis.ports_aCon) annotation (Line(points={{10,180},{20,
          180},{20,160},{12,160},{12,150}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_aSerAmb) annotation (Line(points={{-12,150},{
          -12,160},{-20,160},{-20,180},{-10,180}}, color={0,127,255}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-259,40},{-180,40},
          {-180,7.33333},{-161.333,7.33333}},
                              color={0,0,127}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{-228,
          220},{-20,220},{-20,187},{-12,187}}, color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-198,200},
          {-24,200},{-24,185},{-12,185}},      color={0,0,127}));
  connect(pla.port_bSerAmb, conPla.port_aCon) annotation (Line(points={{-140,1.33333},
          {-100,1.33333},{-100,-4},{-90,-4}}, color={0,127,255}));
  connect(conPla.port_bCon, pla.port_aSerAmb) annotation (Line(points={{-90,-10},
          {-100,-10},{-100,-20},{-200,-20},{-200,1.33333},{-160,1.33333}},
        color={0,127,255}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{-258,
          240},{-16,240},{-16,189},{-12,189}}, color={0,0,127}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760));
end PartialSeries;
