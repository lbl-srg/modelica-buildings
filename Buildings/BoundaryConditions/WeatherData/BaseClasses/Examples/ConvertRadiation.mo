within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model ConvertRadiation "Test model for ConvertRadiation"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    conGloRad "Convert units for global horizontal radiation"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation
    conDifRad "Convert units for diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime timCon
    "Convert simmulation time to calendar time"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
       "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

equation
  connect(timCon.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[8], conGloRad.HIn) annotation (Line(
      points={{1,10},{10,10},{10,30},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[10], conDifRad.HIn) annotation (Line(
      points={{1,10},{10,10},{10,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, timCon.simTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
experiment(StopTime=8640000),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/ConvertRadiation.mos"
        "Simulate and plot"));
end ConvertRadiation;
