within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Examples;
model SeriesConstantFlowRCB3Z1
  "Example of series connection with constant district water mass flow rate, 3 RC building models (1 zone)"
  extends BaseClasses.PartialSeries(
    redeclare Loads.BuildingRCZ1WithETS bui[nBui],
    nBui=3,
    datDes(
      mCon_flow_nominal=bui.ets.mDisWat_flow_nominal,
      epsPla=0.935));
  parameter String weaName = "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"
    "Name of the weather file";
  Modelica.Blocks.Sources.Constant masFloMaiPum(k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(weaName))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,210},{40,230}})));
  Modelica.Blocks.Sources.Constant masFloDisPla(k=datDes.mPla_flow_nominal)
    "District water mass flow rate to plant"
    annotation (Placement(transformation(extent={{-248,10},{-228,30}})));
equation
  connect(masFloMaiPum.y, pumDis.m_flow_in) annotation (Line(points={{-259,-60},
          {60,-60},{60,-60},{68,-60}}, color={0,0,127}));
  connect(pumSto.m_flow_in, masFloMaiPum.y) annotation (Line(points={{-180,-68},
          {-180,-60},{-259,-60}}, color={0,0,127}));
  for i in 1:nBui loop
    connect(weaDat.weaBus, bui[i].weaBus)
      annotation (Line(
      points={{40,220},{0,220},{0,186.2}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-227,20},{
          -184,20},{-184,4},{-162,4}},
                                  color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/Generation5/Unidirectional/Examples/SeriesConstantFlowRCB3Z1.mos"
  "Simulate and plot"),
  experiment(
    StopTime=604800,
    Tolerance=1e-06));
end SeriesConstantFlowRCB3Z1;
