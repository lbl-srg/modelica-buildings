within Buildings.Experimental.DHC.Examples.Combined;
model SeriesVariableFlowAgentControl
  "Example of series connection with variable district water mass flow rate with updated agent controller"
  extends
    Buildings.Experimental.DHC.Examples.Combined.BaseClasses.PartialSeries(
    redeclare
      Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS bui[
      nBui](final filNam=filNam),
    datDes(
      mPumDis_flow_nominal=97.3,
      mPipDis_flow_nominal=69.5,
      mSto_flow_nominal=75,
      dpPla_nominal(displayUnit="bar") = 50000,
      TLooMin=279.15,
      dp_length_nominal=250,
      epsPla=0.91),
    pumSto(dp_nominal=40000));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  parameter Modelica.Units.SI.Length diameter=sqrt(4*datDes.mPipDis_flow_nominal/1000/1.5/Modelica.Constants.pi)
    "Pipe diameter (without insulation)";
  parameter Modelica.Units.SI.Height lDisPip=200 "Distribution pipes length";
  parameter Modelica.Units.SI.Radius rPip=diameter/2 "Pipe external radius";
  parameter Modelica.Units.SI.Radius thiGroLay=0.5
    "Dynamic ground layer thickness";
  Modelica.Blocks.Sources.Constant masFloDisPla(
    k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet[nBui](
    k=fill(63 + 273.15, nBui))
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-374,170},{-354,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat[nBui](
    k=fill(15 + 273.15, nBui))
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-344,150},{-324,170}})));
  Buildings.Experimental.DHC.Networks.Controls.MainPump conPum(
    nMix=nBui,
    nSou=2,
    nBui=nBui,
    TMin=279.15,
    TMax=290.15,
    dTSlo=1.5) "Main pump controller"
    annotation (Placement(transformation(extent={{-52,-198},{-28,-162}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=datDes.mPumDis_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{24,-190},{44,-170}})));
  Modelica.Blocks.Sources.CombiTimeTable HXtemperature(table=[0,14 + 273.15; 60
        *86400,12 + 273.15; 210*86400,20 + 273.15; 365*86400,14 + 273.15],
                                     extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-288,30},{-268,50}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-216,4},{-196,24}})));
  .Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=datDes.mSto_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-242,-110},{-222,-90}})));

  Fluid.Sensors.TemperatureTwoPort TDisWatSup1(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,128})));
  Fluid.Sensors.TemperatureTwoPort TDisWatRet1(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mPumDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,128})));
  Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling pipeGroundCouplingMulti[nBui + 3](
    each lPip=lDisPip,
    each rPip=rPip,
    each thiGroLay=thiGroLay,
    each nSeg=1,
    redeclare parameter  Buildings.HeatTransfer.Data.Soil.Generic soiDat(
      each k=2.3,
      each c=1000,
      each d=2600))
    annotation (Placement(transformation(extent={{-10,100},{12,80}})));
  Buildings.Experimental.DHC.Networks.Controls.AgentPump pumPlantControlNsew(
    yPumMin=0,
    dToff=0.5,
    k=0.8,
    Ti=600,
    uLowHea=0.75,
    uHighHea=1.5,
    h=0.5) annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Experimental.DHC.Networks.Controls.AgentPump pumPlantControlNsewSto(
    yPumMin=0,
    dToff=0.45,
    k=1.1,
    Ti=600,
    uLowHea=0.25,
    uHighHea=0.5,
    uLowCoo=0.15,
    uHighCoo=0.4)
    annotation (Placement(transformation(extent={{-330,-110},{-310,-90}})));

  Networks.Distribution1PipePlugFlow dis(
    nCon=nBui,
    allowFlowReversal=allowFlowReversalSer,
    redeclare package Medium = Medium,
    show_TOut=true,
    mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    mCon_flow_nominal=datDes.mCon_flow_nominal,
    lDis=datDes.lDis,
    lEnd=datDes.lEnd,
    dIns=0.02,
    kIns=0.2)
    annotation (Placement(transformation(extent={{-20,132},{20,152}})));
  Fluid.FixedResistances.PlugFlowPipe supDisPluFlo(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversalSer,
    m_flow_nominal=datDes.mPipDis_flow_nominal,
    length=lDisPip,
    dIns=0.02,
    kIns=0.2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,92})));
  Fluid.FixedResistances.PlugFlowPipe retDisPluFlo(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversalSer,
    m_flow_nominal=datDes.mPipDis_flow_nominal,
    length=lDisPip,
    dIns=0.02,
    kIns=0.2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,92})));
equation
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-352,
          180},{-18,180},{-18,183},{-12,183}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-322,160},{-8,160},
          {-8,168}},            color={0,0,127}));
  connect(pumDis.m_flow_in, gai.y)
    annotation (Line(points={{68,-60},{60,-60},{60,-180},{46,-180}},
                                                 color={0,0,127}));
  connect(conPum.y, gai.u)
    annotation (Line(points={{-26.1538,-180},{22,-180}},
                                                 color={0,0,127}));
  connect(TDisWatRet.T, conPum.TSouIn[1]) annotation (Line(points={{69,
          7.21645e-16},{20,7.21645e-16},{20,-152},{-68,-152},{-68,-175.05},{
          -54.0308,-175.05}},               color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouIn[2]) annotation (Line(points={{-91,-40},
          {-100,-40},{-100,-174},{-76,-174},{-76,-174.15},{-54.0308,-174.15}},
                                                  color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouOut[1]) annotation (Line(points={{-91,-40},
          {-100,-40},{-100,-184.05},{-54.0308,-184.05}},  color={0,0,127}));
  connect(TDisWatSup.T, conPum.TSouOut[2]) annotation (Line(points={{-91,20},{
          -102,20},{-102,-184},{-100,-184},{-100,-183.15},{-54.0308,-183.15}},
                                                   color={0,0,127}));
  connect(masFloDisPla.y, product1.u1)
    annotation (Line(points={{-229,20},{-218,20}},           color={0,0,127}));
  connect(product1.y, pla.mPum_flow) annotation (Line(points={{-195,14},{-195,
          4.66667},{-161.333,4.66667}}, color={0,0,127}));
  connect(gai1.y, pumSto.m_flow_in) annotation (Line(points={{-220,-100},{-206,
          -100},{-206,-64},{-180,-64},{-180,-68}}, color={0,0,127}));
  connect(TDisWatBorLvg.T, pumPlantControlNsew.TSouIn) annotation (Line(points={{-91,-40},
          {-286,-40},{-286,7},{-281.538,7}},
        color={0,0,127}));
  connect(TDisWatSup.T,pumPlantControlNsew.TSouOut)  annotation (Line(points={{-91,20},
          {-100,20},{-100,60},{-296,60},{-296,-1},{-281.538,-1}},     color={0,0,
          127}));
  connect(TDisWatSup1.T, pumPlantControlNsew.TsupDis) annotation (Line(points={{-91,128},
          {-312,128},{-312,-8},{-281.538,-8}},          color={0,0,127}));
  connect(TDisWatRet1.T, pumPlantControlNsew.TretDis) annotation (Line(points={{69,128},
          {40,128},{40,112},{-308,112},{-308,-5},{-281.538,-5}},
        color={0,0,127}));
  connect(borFie.TBorAve, pumPlantControlNsewSto.TSou) annotation (Line(points={{-119,
          -75.6},{-108,-75.6},{-108,-60},{-336,-60},{-336,-96},{-331.538,-96},{
          -331.538,-97}},
        color={0,0,127}));
  connect(TDisWatRet.T, pumPlantControlNsewSto.TSouIn) annotation (Line(points={{69,
          7.21645e-16},{22,7.21645e-16},{22,-150},{-340,-150},{-340,-92},{
          -331.538,-92},{-331.538,-93}},
        color={0,0,127}));
  connect(TDisWatBorLvg.T,pumPlantControlNsewSto.TSouOut)  annotation (Line(
        points={{-91,-40},{-348,-40},{-348,-101},{-331.538,-101}},
        color={0,0,127}));
  connect(TDisWatSup1.T, pumPlantControlNsewSto.TsupDis) annotation (Line(
        points={{-91,128},{-370,128},{-370,-108},{-331.538,-108}},
                                                               color={0,0,127}));
  connect(TDisWatRet1.T, pumPlantControlNsewSto.TretDis) annotation (Line(
        points={{69,128},{40,128},{40,112},{-310,112},{-310,-20},{-354,-20},{
          -354,-105},{-331.538,-105}},
        color={0,0,127}));
  connect(pumPlantControlNsewSto.y, gai1.u) annotation (Line(points={{-308.462,
          -100},{-244,-100}},
                        color={0,0,127}));
  connect(pumPlantControlNsew.y, product1.u2) annotation (Line(points={{
          -258.462,0},{-220,0},{-220,8},{-218,8}},
                                 color={0,0,127}));
  connect(bui.PPumCoo, conPum.PpumCoo) annotation (Line(points={{3,168},{-4,168},
          {-4,156},{-280,156},{-280,140},{-392,140},{-392,-190.8},{-54.0308,
          -190.8}},                                              color={0,0,127}));
  connect(TDisWatSup1.port_b, dis.port_aDisSup) annotation (Line(points={{-80,138},
          {-80,142},{-20,142}}, color={0,127,255}));
  connect(dis.port_bDisSup, TDisWatRet1.port_a)
    annotation (Line(points={{20,142},{80,142},{80,138}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_aSerAmb) annotation (Line(points={{-12,152},
          {-14,152},{-14,180},{-10,180}},color={0,127,255}));
  connect(dis.ports_aCon, bui.port_bSerAmb) annotation (Line(points={{12,152},{
          16,152},{16,180},{10,180}},
                                   color={0,127,255}));
  connect(dis.TOut, conPum.TMix) annotation (Line(points={{22,136},{34,136},{34,
          150},{-272,150},{-272,134},{-382,134},{-382,-168},{-54.0308,-168},{
          -54.0308,-167.4}},                        color={0,0,127}));
  connect(TDisWatSup.port_b, supDisPluFlo.port_a)
    annotation (Line(points={{-80,30},{-80,82}}, color={0,127,255}));
  connect(supDisPluFlo.port_b, TDisWatSup1.port_a) annotation (Line(points={{-80,102},
          {-80,118}},                color={0,127,255}));
  connect(TDisWatRet1.port_b, retDisPluFlo.port_a)
    annotation (Line(points={{80,118},{80,102}}, color={0,127,255}));
  connect(retDisPluFlo.port_b, TDisWatRet.port_a) annotation (Line(points={{80,82},
          {80,10}},                 color={0,127,255}));
  connect(pipeGroundCouplingMulti[1:(nBui+1)].heatPorts[1], dis.heatPorts)
    annotation (Line(points={{0,95},{0,96},{0.4,96},{0.4,139.8}},
        color={127,0,0}));
  connect(supDisPluFlo.heatPort, pipeGroundCouplingMulti[nBui + 2].heatPorts[1])
    annotation (Line(points={{-70,92},{0,92},{0,95}},
        color={191,0,0}));
  connect(retDisPluFlo.heatPort, pipeGroundCouplingMulti[nBui + 3].heatPorts[1])
    annotation (Line(points={{70,92},{0,92},{0,95}},                     color={
          191,0,0}));
  connect(HXtemperature.y[1], pla.TSewWat) annotation (Line(points={{-267,40},{
          -172,40},{-172,7.33333},{-161.333,7.33333}}, color={0,0,127}));
  connect(HXtemperature.y[1], pumPlantControlNsew.TSou) annotation (Line(points={{-267,40},
          {-260,40},{-260,20},{-288,20},{-288,3},{-281.538,3}},
                     color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-400,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/SeriesVariableFlowAgentControl.mos"
  "Simulate and plot"),
  experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>
January 20, 2023, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow\">
Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow</a>
except for the pipe diameter and the control of the main circulation pump.
Rather than having a constant mass flow rate, the mass flow rate is varied
based on the mixing temperatures after each agent.
If these mixing temperatures are sufficiently far away from the minimum or maximum
allowed loop temperature, then the mass flow rate is reduced to save pump energy.
</p>
</html>"),
    Icon(coordinateSystem(extent={{-400,-260},{360,260}})));
end SeriesVariableFlowAgentControl;
