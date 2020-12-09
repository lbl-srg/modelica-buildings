within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Examples;
model SeriesConstantFlowTimeSeriesB3
  "Example of series connection with constant district water mass flow rate, 3 time series building load models"
  extends BaseClasses.PartialSeries(
    final allowFlowReversal=allowFlowReversalDis,
    nBui=3,
    datDes(
      mCon_flow_nominal=bui.ets.mDisWat_flow_nominal,
      epsPla=0.935));
  parameter Boolean allowFlowReversalDis = true
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Loads.BuildingTimeSeriesWithETS bui[nBui](
    redeclare each final package MediumBui=Medium,
    redeclare each final package MediumSer=Medium,
    final filNam=filNam,
    each final allowFlowReversalBui=false,
    each final allowFlowReversalSer=allowFlowReversalDis)
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.Blocks.Sources.Constant masFloMaiPum(k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet[nBui](
    k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet[nBui](
    k=bui.TChiWatSup_nominal) "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-252,190},{-232,210}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));
  Modelica.Blocks.Sources.Constant masFloDisPla(k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet[nBui](k=fill(63 +
        273.15, nBui)) "Service hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TColWat[nBui](k=fill(15 + 273.15,
        nBui)) "Cold water temperature"
    annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
equation
  connect(masFloMaiPum.y, pumDis.m_flow_in) annotation (Line(points={{-259,-60},
          {60,-60},{60,-60},{68,-60}}, color={0,0,127}));
  connect(pumSto.m_flow_in, masFloMaiPum.y) annotation (Line(points={{-180,-68},
          {-180,-60},{-259,-60}}, color={0,0,127}));
  connect(THeaWatSupSet.y, bui.THeaWatSupSet) annotation (Line(points={{-258,
          220},{-20,220},{-20,188},{-11,188}}, color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-230,
          200},{-40,200},{-40,184},{-11,184}}, color={0,0,127}));
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-219,20},{-180,
          20},{-180,4},{-162,4}}, color={0,0,127}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-259,40},{-176,40},{
          -176,8},{-162,8}},  color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-198,
          180},{-40,180},{-40,176},{-11,176}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-168,160},{-40,160},
          {-40,172},{-11,172}}, color={0,0,127}));
  connect(bui.port_bSerAmb, dis.ports_aCon) annotation (Line(points={{10,180},{
          20,180},{20,160},{12,160},{12,150}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_aSerAmb) annotation (Line(points={{-12,150},
          {-12,160},{-20,160},{-20,180},{-10,180}}, color={0,127,255}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/Generation5/Unidirectional/Examples/SeriesConstantFlowTimeSeriesB3.mos"
  "Simulate and plot"),
  experiment(
    StopTime=604800,
    Tolerance=1e-06));
end SeriesConstantFlowTimeSeriesB3;
