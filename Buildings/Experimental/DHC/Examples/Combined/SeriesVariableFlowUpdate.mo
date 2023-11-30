within Buildings.Experimental.DHC.Examples.Combined;
model SeriesVariableFlowUpdate
  "Example of series connection with variable district water mass flow rate controller update"
  extends
    Buildings.Experimental.DHC.Examples.Combined.BaseClasses.PartialSeries(      redeclare
      Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS
      bui[nBui](final filNam=filNam), datDes(
      mPumDis_flow_nominal=97.3,
      mPipDis_flow_nominal=69.5,
      mSto_flow_nominal=75,
      dpPla_nominal(displayUnit="bar") = 50000,
      TLooMin=279.15,
      dp_length_nominal=250,
      epsPla=0.91),
    TSewWat(k=273.15),
    pumSto(dp_nominal=40000));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Modelica.Blocks.Sources.Constant masFloDisPla(
    k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet[nBui](
    k=fill(63 + 273.15, nBui))
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-190,170},{-170,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TColWat[nBui](
    k=fill(15 + 273.15, nBui))
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Experimental.DHC.Examples.Combined.Controls.MainPump conPum(
    nMix=nBui,
    nSou=2,
    nBui=nBui,
    TMin=279.15,
    TMax=290.15,
    dTSlo=1.5,
    use_temperatureShift=true) "Main pump controller"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=datDes.mPumDis_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  Modelica.Blocks.Sources.CombiTimeTable HXmassflow(table=[0,1; 25000,0.25;
        40000,1.25; 54000,1.5; 86400,1], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-250,-32},{-230,-12}})));
  Modelica.Blocks.Sources.CombiTimeTable HXtemperature(table=[0,14; 60*86400,12;
        210*86400,20; 365*86400,14], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-280,-2},{-260,18}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-218,-2},{-198,18}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-210,28},{-190,48}})));
  Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    T_start=281.15,
    m_flow_nominal=datDes.mPipDis_flow_nominal,
    dp_nominal=0,
    nSeg=nSeg,
    thicknessIns=0.02,
    lambdaIns=0.2,
    length=100,
    useMultipleHeatPorts=true)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,100})));
  Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    T_start=281.15,
    m_flow_nominal=datDes.mPipDis_flow_nominal,
    dp_nominal=0,
    nSeg=nSeg,
    thicknessIns=0.02,
    lambdaIns=0.2,
    diameter=diameter,
    length=100,
    useMultipleHeatPorts=true)
                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,102})));
  Modelica.Blocks.Sources.Constant HXmassFlowGain(k=1)
    "mass flow rate gain for sewage heat exchanger"
    annotation (Placement(transformation(extent={{-280,-36},{-260,-16}})));
  .Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(k=datDes.mSto_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-240,-112},{-220,-92}})));
  parameter Modelica.Units.SI.Length diameter= 0.0381*pip1.m_flow_nominal^0.3764
    "Pipe diameter (without insulation)";
  parameter Integer nSeg=10 "Number of volume segments";
  Fluid.Sensors.TemperatureTwoPort TDisWatSup1(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,134})));
  Fluid.Sensors.TemperatureTwoPort TDisWatRet1(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={78,130})));
  BaseClasses.PipeGroundCouplingMulti pipeGroundCouplingMulti(
    lpip=200,
    rpip=diameter/2,
    rgroLay=pipeGroundCouplingMulti.rpip + 0.5,
    nSeg=nSeg,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
      k=2.3,
      c=1000,
      d=2600))
    annotation (Placement(transformation(extent={{-54,92},{-32,112}})));
  BaseClasses.PipeGroundCouplingMulti pipeGroundCouplingMulti1(
    lpip=200,
    rpip=diameter/2,
    rgroLay=pipeGroundCouplingMulti.rpip + 0.5,
    nSeg=nSeg,
    redeclare parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
      k=2.3,
      c=1000,
      d=2600)) annotation (Placement(transformation(extent={{30,92},{52,112}})));
  Buildings.Experimental.DHC.Examples.Combined.Controls.AgentPump
    pumPlantControlNsew(
    yPumMin=0,
    dTnom=0.5,
    k=0.5,
    khea=0.8,
    Ti=600,
    uLowHea=0.75,
    uHighHea=1.5,
    h=0.5) annotation (Placement(transformation(extent={{-360,-18},{-340,2}})));
  Buildings.Experimental.DHC.Examples.Combined.Controls.AgentPump
    pumPlantControlNsewSto(
    yPumMin=0,
    dTnom=0.45,
    k=0.35,
    khea=1.2,
    kcoo=0.85,
    Ti=600,
    uLowHea=0.25,
    uHighHea=0.5,
    uLowCoo=0.15,
    uHighCoo=0.4)
    annotation (Placement(transformation(extent={{-330,-116},{-310,-96}})));
  Modelica.Blocks.Sources.Constant TSewWat1(k=1)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-326,-80},{-306,-60}})));
equation
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-168,
          180},{-40,180},{-40,183},{-12,183}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-138,160},{-40,160},
          {-40,164},{-8,164},{-8,168}},
                                color={0,0,127}));
  connect(pumDis.m_flow_in, gai.y)
    annotation (Line(points={{68,-60},{-218,-60}},
                                                 color={0,0,127}));
  connect(conPum.y, gai.u)
    annotation (Line(points={{-258,-60},{-242,-60}},
                                                 color={0,0,127}));
  connect(dis.TOut, conPum.TMix) annotation (Line(points={{22,134},{30,134},{30,
          120},{-300,120},{-300,-54},{-282,-54}},
                                         color={0,0,127}));
  connect(TDisWatRet.T, conPum.TSouIn[1]) annotation (Line(points={{69,0},{60,0},
          {60,80},{-304,80},{-304,-60.5},{-282,-60.5}},
                                            color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouIn[2]) annotation (Line(points={{-91,-40},
          {-290,-40},{-290,-58},{-282,-58},{-282,-59.5}},
                                                  color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouOut[1]) annotation (Line(points={{-91,-40},
          {-290,-40},{-290,-66.5},{-283.6,-66.5}},        color={0,0,127}));
  connect(TDisWatSup.T, conPum.TSouOut[2]) annotation (Line(points={{-91,20},{
          -100,20},{-100,60},{-296,60},{-296,-65.5},{-283.6,-65.5}},
                                                   color={0,0,127}));
  connect(masFloDisPla.y, product1.u1)
    annotation (Line(points={{-229,20},{-229,14},{-220,14}}, color={0,0,127}));
  connect(product1.y, pla.mPum_flow) annotation (Line(points={{-197,8},{-197,
          4.66667},{-161.333,4.66667}}, color={0,0,127}));
  connect(TSewWat.y, add.u1)
    annotation (Line(points={{-259,40},{-259,44},{-212,44}}, color={0,0,127}));
  connect(HXtemperature.y[1], add.u2) annotation (Line(points={{-259,8},{-256,8},
          {-256,32},{-212,32}}, color={0,0,127}));
  connect(add.y, pla.TSewWat) annotation (Line(points={{-189,38},{-189,36},{
          -161.333,36},{-161.333,7.33333}}, color={0,0,127}));
  connect(pip.port_b, TDisWatRet.port_a)
    annotation (Line(points={{80,90},{80,10}}, color={0,127,255}));
  connect(pip1.port_a, TDisWatSup.port_b)
    annotation (Line(points={{-80,92},{-80,30}}, color={0,127,255}));
  connect(gai1.y, pumSto.m_flow_in) annotation (Line(points={{-218,-102},{-214,
          -102},{-214,-64},{-180,-64},{-180,-68}}, color={0,0,127}));
  connect(TDisWatSup1.port_a, pip1.port_b) annotation (Line(points={{-60,124},{-68,
          124},{-68,112},{-80,112}}, color={0,127,255}));
  connect(TDisWatSup1.port_b, dis.port_aDisSup) annotation (Line(points={{-60,144},
          {-60,148},{-36,148},{-36,140},{-20,140}}, color={0,127,255}));
  connect(dis.port_bDisSup, TDisWatRet1.port_a)
    annotation (Line(points={{20,140},{78,140}}, color={0,127,255}));
  connect(TDisWatRet1.port_b, pip.port_a) annotation (Line(points={{78,120},{78,
          115},{80,115},{80,110}}, color={0,127,255}));
  connect(pipeGroundCouplingMulti.heatPorts, pip1.heatPorts) annotation (Line(
        points={{-44,97},{-44,84},{-96,84},{-96,102},{-85,102}}, color={127,0,0}));
  connect(pipeGroundCouplingMulti1.heatPorts, pip.heatPorts) annotation (Line(
        points={{40,97},{40,84},{64,84},{64,80},{96,80},{96,100},{85,100}},
        color={127,0,0}));
  connect(add.y, pumPlantControlNsew.TSou) annotation (Line(points={{-189,38},{
          -189,36},{-180,36},{-180,56},{-358.571,56},{-358.571,-3.66667}},
                                                      color={0,0,127}));
  connect(TDisWatBorLvg.T, pumPlantControlNsew.TSouIn) annotation (Line(points={{-91,-40},
          {-372,-40},{-372,-6.33333},{-358.571,-6.33333}},
        color={0,0,127}));
  connect(TDisWatSup.T, pumPlantControlNsew.TsupPla) annotation (Line(points={{-91,20},
          {-100,20},{-100,60},{-380,60},{-380,-8.83333},{-358.571,-8.83333}},
                                                                      color={0,0,
          127}));
  connect(TDisWatSup1.T, pumPlantControlNsew.TsupDis) annotation (Line(points={{-71,134},
          {-128,134},{-128,124},{-312,124},{-312,-24},{-358.571,-24},{-358.571,
          -15.5}},                                      color={0,0,127}));
  connect(TDisWatRet1.T, pumPlantControlNsew.TretDis) annotation (Line(points={{67,130},
          {56,130},{56,120},{20,120},{20,76},{-308,76},{-308,-28},{-358.571,-28},
          {-358.571,-12.1667}},
        color={0,0,127}));
  connect(borFie.TBorAve, pumPlantControlNsewSto.TSou) annotation (Line(points={{-119,
          -75.6},{-108,-75.6},{-108,-56},{-212,-56},{-212,-64},{-216,-64},{-216,
          -84},{-328.571,-84},{-328.571,-101.667}},
        color={0,0,127}));
  connect(TDisWatRet.T, pumPlantControlNsewSto.TSouIn) annotation (Line(points={{69,
          7.21645e-16},{60,7.21645e-16},{60,80},{-304,80},{-304,-92},{-292,-92},
          {-292,-112},{-304,-112},{-304,-124},{-328.571,-124},{-328.571,
          -104.333}},
        color={0,0,127}));
  connect(TDisWatBorLvg.T, pumPlantControlNsewSto.TsupPla) annotation (Line(
        points={{-91,-40},{-348,-40},{-348,-106.833},{-328.571,-106.833}},
        color={0,0,127}));
  connect(TDisWatSup1.T, pumPlantControlNsewSto.TsupDis) annotation (Line(
        points={{-71,134},{-71,132},{-128,132},{-128,124},{-312,124},{-312,-24},
          {-376,-24},{-376,-113.5},{-328.571,-113.5}},         color={0,0,127}));
  connect(TDisWatRet1.T, pumPlantControlNsewSto.TretDis) annotation (Line(
        points={{67,130},{56,130},{56,120},{20,120},{20,76},{-308,76},{-308,-28},
          {-352,-28},{-352,-110.167},{-328.571,-110.167}},
        color={0,0,127}));
  connect(pumPlantControlNsewSto.y, gai1.u) annotation (Line(points={{-311.429,
          -106},{-300,-106},{-300,-102},{-242,-102}},
                        color={0,0,127}));
  connect(pumPlantControlNsew.y, product1.u2) annotation (Line(points={{
          -341.429,-8},{-341.429,4},{-288,4},{-288,-8},{-252,-8},{-252,2},{-220,
          2}},                   color={0,0,127}));
  connect(bui.mCoo_flow, conPum.m_flow_coo) annotation (Line(points={{34,164},{
          34,144},{-436,144},{-436,-70.4},{-282.4,-70.4}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-400,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/SeriesVariableFlow.mos"
  "Simulate and plot"),
  experiment(
      StopTime=31536000,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with base classes from the <code>DHC</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model is identical to
<a href=\"Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow\">
Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow</a>
except for the pipe diameter and the control of the main circulation pump.
Rather than having a constant mass flow rate, the mass flow rate is varied
based on the mixing temperatures after each agent.
If these mixing temperatures are sufficiently far away from the minimum or maximum
allowed loop temperature, then the mass flow rate is reduced to save pump energy.
</p>
</html>"),
    Icon(coordinateSystem(extent={{-400,-260},{360,260}})));
end SeriesVariableFlowUpdate;
