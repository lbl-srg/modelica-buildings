within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckSkyCover "Test model for checking sky cover"
  extends Modelica.Icons.Example;
public
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckSkyCover
    cheTotSkyCov "Check total sky cover"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckSkyCover
    cheOpaSkyCov "Check opaque sky cover"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Utilities.SimulationTime simTim "Generate simulation time"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
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
public
  Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(datRea.y[17], cheTotSkyCov.nIn) annotation (Line(
      points={{1,10},{10,10},{10,30},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[18], cheOpaSkyCov.nIn) annotation (Line(
      points={{1,10},{10,10},{10,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
experiment(StopTime=8640000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckSkyCover.mos"
        "Simulate and plot"));
end CheckSkyCover;
