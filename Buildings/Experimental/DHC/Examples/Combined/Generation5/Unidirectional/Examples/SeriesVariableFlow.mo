within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Examples;
model SeriesVariableFlow
  "Example of series connection with variable district water mass flow rate"
  extends BaseClasses.PartialSeries(
    redeclare Loads.BuildingTimeSeriesWithETS bui[nBui](
      final filNam=filNam),
    nBui=3,
    dis(show_TOut=true));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Modelica.Blocks.Sources.Constant masFloDisPla(k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet[nBui](
    k=fill(63 + 273.15, nBui))
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-190,170},{-170,190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TColWat[nBui](
    k=fill(15 + 273.15, nBui))
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Experimental.DHC.Networks.Controls.MainPump conPum(
    nMix=nBui,
    nSou=2,
    TMin=279.15,
    TMax=290.15,
    use_temperatureShift=false) "Main pump controller"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=datDes.mDis_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
equation
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-229,20},{
          -184,20},{-184,4.66667},{-161.333,4.66667}},
                                  color={0,0,127}));
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
          {60,80},{-304,80},{-304,-61},{-282,-61}},
                                            color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouIn[2]) annotation (Line(points={{-91,-40},
          {-290,-40},{-290,-58},{-282,-58},{-282,-59}},
                                                  color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouOut[1]) annotation (Line(points={{-91,-40},
          {-290,-40},{-290,-67},{-282,-67}},              color={0,0,127}));
  connect(TDisWatSup.T, conPum.TSouOut[2]) annotation (Line(points={{-91,20},{-100,
          20},{-100,60},{-296,60},{-296,-65},{-282,-65}},
                                                   color={0,0,127}));
  connect(gai.y, pumSto.m_flow_in) annotation (Line(points={{-218,-60},{-180,-60},
          {-180,-68}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/Generation5/Unidirectional/Examples/SeriesVariableFlow.mos"
  "Simulate and plot"),
  experiment(
    StopTime=604800,
    Tolerance=1e-06));
end SeriesVariableFlow;
