within Buildings.Applications.DHC.Loads.Examples;
model GeojsonRCRawExport "Multizone RC model"
  import Buildings;
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));

  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonBuilding bui
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHea[bui.nHeaLoa]
    annotation (Placement(transformation(extent={{-18,-30},{2,-10}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCoo[bui.nCooLoa]
    annotation (Placement(transformation(extent={{-18,-50},{2,-30}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{90,-20},{50.1,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(heaFloCoo.port, bui.heaPorCoo)
    annotation (Line(points={{2,-40},{20,-40},{20,-37},{40,-37}}, color={191,0,0}));
  connect(heaFloHea.port, bui.heaPorHea)
    annotation (Line(points={{2,-20},{20,-20},{20,-23},{40,-23}}, color={191,0,0}));
  connect(bui.Q_flowHeaReq, heaFloHea.Q_flow)
    annotation (Line(points={{61,-24},{80,-24},{80,0},{-40,0},{-40,-20},{-18,-20}}, color={0,0,127}));
  connect(bui.Q_flowCooReq, heaFloCoo.Q_flow)
    annotation (Line(points={{61,-36},{80,-36},{80,-60},{-40,-60},{-40,-40},{-18,-40}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified multizone RC model resulting
  from the translation of a GeoJSON model specified within Urbanopt UI, see
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding</a>.
  </p>
  </html>"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{140,80}})),
    __Dymola_Commands);
end GeojsonRCRawExport;
