within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Examples;
model SeriesVariableFlow
  "Example of series connection with variable district water mass flow rate"
  extends BaseClasses.PartialSeries(
    redeclare Loads.BuildingTimeSeriesWithETS bui[nBui](
      final filNam=filNam),
    nBui=3);
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Modelica.Blocks.Sources.Constant masFloDisPla(k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet[nBui](k=fill(63 +
        273.15, nBui)) "Service hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TColWat[nBui](k=fill(15 + 273.15,
        nBui)) "Cold water temperature"
    annotation (Placement(transformation(extent={{-190,150},{-170,170}})));
  Buildings.Experimental.DHC.Networks.Controls.MainPump distributionPump
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=datDes.mDis_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
equation
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-229,20},{
          -184,20},{-184,4},{-162,4}},
                                  color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-198,
          180},{-40,180},{-40,176},{-11,176}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-168,160},{-40,160},
          {-40,172},{-11,172}}, color={0,0,127}));
  connect(pumDis.m_flow_in, gai.y)
    annotation (Line(points={{68,-60},{62,-60}}, color={0,0,127}));
  connect(distributionPump.y, gai.u)
    annotation (Line(points={{32,-60},{38,-60}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/Generation5/Unidirectional/Examples/SeriesConstantFlow.mos"
  "Simulate and plot"),
  experiment(
    StopTime=604800,
    Tolerance=1e-06));
end SeriesVariableFlow;
