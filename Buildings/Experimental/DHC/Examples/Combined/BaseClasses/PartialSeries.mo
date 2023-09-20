within Buildings.Experimental.DHC.Examples.Combined.BaseClasses;
partial model PartialSeries "Partial model for series network"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  constant Real facMul = 10
    "Building loads multiplier factor";
  parameter Real dpDis_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate - Distribution line";
  parameter Real dpCon_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate - Connection line";
  parameter Boolean allowFlowReversalSer = true
    "Set to true to allow flow reversal in the service lines"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal for in-building systems"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nBui = datDes.nBui
    "Number of buildings connected to DHC system"
    annotation (Evaluate=true);
  inner parameter
    Buildings.Experimental.DHC.Examples.Combined.BaseClasses.DesignDataSeries
    datDes(final mCon_flow_nominal=bui.ets.mSerWat_flow_nominal) "Design data"
    annotation (Placement(transformation(extent={{-340,220},{-320,240}})));
  // COMPONENTS
  Buildings.Experimental.DHC.Plants.Reservoir.BoreField
    borFie(redeclare final package Medium = Medium) "Bore field" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-80})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumDis(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mPumDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer,
    dp_nominal=150E3)
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
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pumSto(
    redeclare final package Medium = Medium,
    m_flow_nominal=datDes.mSto_flow_nominal)
    "Bore field pump"
    annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=180,
      origin={-180,-80})));
  Buildings.Experimental.DHC.Networks.Combined.BaseClasses.ConnectionSeriesStandard
    conPla(
    redeclare final package Medium = Medium,
    final mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    final mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=0,
    lCon=0,
    final dhDis=0.2,
    final dhCon=0.2,
    final allowFlowReversal=allowFlowReversalSer)
    "Connection to the plant (pressure drop lumped in plant and network model)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-10})));
  Buildings.Experimental.DHC.Networks.Combined.BaseClasses.ConnectionSeriesStandard
    conSto(
    redeclare final package Medium = Medium,
    final mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    final mCon_flow_nominal=datDes.mSto_flow_nominal,
    lDis=0,
    lCon=0,
    final dhDis=0.2,
    final dhCon=0.2,
    final allowFlowReversal=allowFlowReversalSer)
    "Connection to the bore field (pressure drop lumped in plant and network model)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-90})));
  Buildings.Experimental.DHC.Plants.Heating.SewageHeatRecovery
    pla(
    redeclare final package Medium = Medium,
    final mSew_flow_nominal=datDes.mPla_flow_nominal,
    final mDis_flow_nominal=datDes.mPla_flow_nominal,
    final dpSew_nominal=datDes.dpPla_nominal,
    final dpDis_nominal=datDes.dpPla_nominal,
    final epsHex=datDes.epsPla) "Sewage heat recovery plant"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Experimental.DHC.Networks.Combined.UnidirectionalSeries
    dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    show_TOut=true,
    final mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer) "Distribution network"
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
  Fluid.Sensors.TemperatureTwoPort TDisWatSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,20})));
  Fluid.Sensors.TemperatureTwoPort TDisWatRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,0})));
  Fluid.Sensors.TemperatureTwoPort TDisWatBorLvg(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water borefield leaving temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-40})));
  replaceable
    Buildings.Experimental.DHC.Loads.Combined.BaseClasses.PartialBuildingWithETS
    bui[nBui] constrainedby
    Buildings.Experimental.DHC.Loads.Combined.BaseClasses.PartialBuildingWithETS(
    bui(each final facMul=facMul),
    redeclare each final package MediumBui = Medium,
    redeclare each final package MediumSer = Medium,
    each final allowFlowReversalBui=allowFlowReversalBui,
    each final allowFlowReversalSer=allowFlowReversalSer) "Building and ETS"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMaxSet[nBui](
    k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-250,210},{-230,230}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMinSet[nBui](
    each k=28 + 273.15)
    "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-280,230},{-260,250}})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum PPumETS(
    final nin=nBui)
    "ETS pump power"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Modelica.Blocks.Continuous.Integrator EPumETS(
    initType=Modelica.Blocks.Types.Init.InitialState)
    "ETS pump electric energy"
    annotation (Placement(transformation(extent={{220,190},{240,210}})));
  Modelica.Blocks.Continuous.Integrator EPumDis(
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Distribution pump electric energy"
    annotation (Placement(transformation(extent={{220,-90},{240,-70}})));
  Modelica.Blocks.Continuous.Integrator EPumSto(
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Storage pump electric energy"
    annotation (Placement(transformation(extent={{220,-150},{240,-130}})));
  Modelica.Blocks.Continuous.Integrator EPumPla(initType=Modelica.Blocks.Types.Init.InitialState)
    "Plant pump electric energy"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum EPum(nin=4)
    "Total pump electric energy"
    annotation (Placement(transformation(extent={{280,110},{300,130}})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum PHeaPump(
    final nin=nBui)
    "Heat pump power"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Modelica.Blocks.Continuous.Integrator EHeaPum(
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Heat pump electric energy"
    annotation (Placement(transformation(extent={{220,150},{240,170}})));
 Buildings.Controls.OBC.CDL.Reals.MultiSum ETot(nin=2) "Total electric energy"
    annotation (Placement(transformation(extent={{320,150},{340,170}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.ConstraintViolation conVio(
    final uMin(final unit="K", displayUnit="degC")=datDes.TLooMin,
    final uMax(final unit="K", displayUnit="degC")=datDes.TLooMax,
    final nu=3+nBui,
    u(each final unit="K", each displayUnit="degC"))
    "Check if loop temperatures are within given range"
    annotation (Placement(transformation(extent={{320,10},{340,30}})));
equation
  connect(dis.TOut, conVio.u[4:4+nBui-1]);
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
  connect(bui.PPumETS, PPumETS.u)
    annotation (Line(points={{7,192},{7,200},{138,200}}, color={0,0,127}));
  connect(PPumETS.y, EPumETS.u)
    annotation (Line(points={{162,200},{218,200}}, color={0,0,127}));
  connect(pumDis.P, EPumDis.u)
    annotation (Line(points={{71,-71},{71,-80},{218,-80}}, color={0,0,127}));
  connect(pumSto.P, EPumSto.u) annotation (Line(points={{-169,-71},{-160,-71},{-160,
          -140},{218,-140}}, color={0,0,127}));
  connect(pla.PPum, EPumPla.u) annotation (Line(points={{-138.667,5.33333},{
          -120,5.33333},{-120,40},{218,40}}, color={0,0,127}));
  connect(EPumETS.y, EPum.u[1]) annotation (Line(points={{241,200},{260,200},{260,
          119.25},{278,119.25}},
                               color={0,0,127}));
  connect(EPumPla.y, EPum.u[2]) annotation (Line(points={{241,40},{260,40},{260,
          119.75},{278,119.75}},
                               color={0,0,127}));
  connect(EPumDis.y, EPum.u[3]) annotation (Line(points={{241,-80},{262,-80},{262,
          120.25},{278,120.25}},
                               color={0,0,127}));
  connect(EPumSto.y, EPum.u[4]) annotation (Line(points={{241,-140},{264,-140},{
          264,120.75},{278,120.75}},
                                   color={0,0,127}));
  connect(bui.PHea, PHeaPump.u) annotation (Line(points={{12,189},{120,189},{
          120,160},{138,160}},
                           color={0,0,127}));
  connect(PHeaPump.y, EHeaPum.u)
    annotation (Line(points={{162,160},{218,160}}, color={0,0,127}));
  connect(EHeaPum.y, ETot.u[1]) annotation (Line(points={{241,160},{300,160},{300,
          159.5},{318,159.5}}, color={0,0,127}));
  connect(EPum.y, ETot.u[2]) annotation (Line(points={{302,120},{310,120},{310,160.5},
          {318,160.5}},    color={0,0,127}));
  connect(TDisWatSup.T, conVio.u[1]) annotation (Line(points={{-91,20},{-100,20},
          {-100,12},{-60,12},{-60,20},{318,20}},           color={0,0,127}));
  connect(TDisWatBorLvg.T, conVio.u[2]) annotation (Line(points={{-91,-40},{-100,
          -40},{-100,-30},{-60,-30},{-60,-40},{300,-40},{300,20},{318,20}},
                                                        color={0,0,127}));
  connect(TDisWatRet.T, conVio.u[3]) annotation (Line(points={{69,6.66134e-16},{
          60,6.66134e-16},{60,20},{318,20}},           color={0,0,127}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
      Documentation(revisions="<html>
<ul>
<li>
June 2, 2023, by Michael Wetter:<br/>
Added units to <code>conVio</code>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Set correct nominal pressure for distribution pump.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with base classes from the <code>DHC</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that is used by the reservoir network models.
The reservoir network models extend this model, add controls,
and configure some component sizes.
</p>
</html>"));
end PartialSeries;
