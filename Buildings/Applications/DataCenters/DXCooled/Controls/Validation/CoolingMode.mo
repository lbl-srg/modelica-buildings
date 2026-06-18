within Buildings.Applications.DataCenters.DXCooled.Controls.Validation;
model CoolingMode
  "Example that demonstrates the use of cooling mode selection for the airside economizer"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.DXCooled.Controls.CoolingMode
    cooModCon(tWai=1200)
    "Cooling mode controller for the DX cooling system with an airside economizer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant TSupSet(k=291.15)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant TRet(k=295.15) "Return air temperature"
    annotation (Placement(transformation(extent={{-60,-78},{-40,-58}})));
  BoundaryConditions.WeatherData.ReaderTMY3  weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}}),
        iconTransformation(extent={{-58,-10},{-38,10}})));

equation
  connect(TSupSet.y, cooModCon.TSupSet)
    annotation (Line(points={{-39,70},{-20,
          70},{-20,5},{-12,5}}, color={0,0,127}));
  connect(TRet.y, cooModCon.TRet)
    annotation (Line(points={{-39,-68},{-20,-68},
          {-20,-5},{-12,-5}}, color={0,0,127}));
  connect(weaDat.weaBus,weaBus)
    annotation (Line(
      points={{-60,0},{-60,0},{-48,0}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, cooModCon.TOutDryBul)
    annotation (Line(
      points={{-48,0},{-20,0},{-12,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/DXCooled/Controls/Validation/CoolingMode.mos"
        "Simulate and Plot"),
    Documentation(revisions="<html>
<ul>
<li>
August 29, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how the cooling mode signal can be generated
according to varying outside air dry bulb temperature,
outside air dewpoint temperature, return air temperature and
supply air temperature setpoint.The detailed control logic can be
refered in
<a href=\"modelica://Buildings.Applications.DataCenters.DXCooled.Controls.CoolingMode\">
Buildings.Applications.DataCenters.DXCooled.Controls.CoolingMode</a>.
</p>
</html>"),
    experiment(
      StartTime=8928000,
      StopTime=9000000,
      Tolerance=1e-06));
end CoolingMode;
