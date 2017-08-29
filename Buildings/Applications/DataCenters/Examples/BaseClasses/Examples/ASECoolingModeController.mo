within Buildings.Applications.DataCenters.Examples.BaseClasses.Examples;
model ASECoolingModeController
  "Example that demonstrates the use of model Buildings.Applications.DataCenters.Examples.BaseClasses.ASECoolingModeController"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.Examples.BaseClasses.ASECoolingModeController
    cooModCon(tWai=1200)
    "Cooling mode controller for the DX cooling system with an airside economizer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant SATSet(
    k = 291.15) "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant RAT(k=298.15) "Return air temperature"
    annotation (Placement(transformation(extent={{-60,-78},{-40,-58}})));
  BoundaryConditions.WeatherData.ReaderTMY3  weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}}),
        iconTransformation(extent={{-58,-10},{-38,10}})));
equation
  connect(SATSet.y, cooModCon.SATSet)
    annotation (Line(points={{-39,70},{-20,70},
          {-20,8},{-12,8}}, color={0,0,127}));
  connect(RAT.y, cooModCon.RAT)
    annotation (Line(points={{-39,-68},{-20,-68},{-20,
          -8},{-12,-8}}, color={0,0,127}));
  connect(weaDat.weaBus,weaBus)
    annotation (Line(
      points={{-60,0},{-60,0},{-48,0}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.TDryBul, cooModCon.OAT)
    annotation (Line(
      points={{-48,0},{-20,0},{-20,3},{-12,3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, cooModCon.OATDewPoi)
    annotation (Line(
      points={{-48,0},{-48,0},{-20,0},{-20,-3},{-12,-3}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DataCenters/Examples/BaseClasses/Examples/ASECoolingModeController.mos"
        "Simulate and PLot"),
    Documentation(revisions="<html>
<ul>
<li>
August 29, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates how the cooling mode signal can be generated according to varying OA dry bulb temperature, 
OA dewpoint temperature, return air temperature and supply air temperature setpoint.The detailed control logic can be
refered in <a href=\"modelica://Buildings.Applications.DataCenters.Examples.BaseClasses.ASECoolingModeController\">
Buildings.Applications.DataCenters.Examples.BaseClasses.ASECoolingModeController</a>.
</p>
</html>"));
end ASECoolingModeController;
