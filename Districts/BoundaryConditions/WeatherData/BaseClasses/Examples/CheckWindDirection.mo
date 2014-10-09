within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckWindDirection "Test model for wind direction check"
  extends Modelica.Icons.Example;
  import Districts;
  Districts.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    tableOnFile=true,
    tableName="tab1",
    fileName=
        "modelica://Districts/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    columns=2:30,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "Data reader"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
public
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckWindDirection
    cheWinDir annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.UnitConversions.From_deg from_deg
    annotation (Placement(transformation(extent={{20,0},{42,20}})));
equation
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[15], from_deg.u) annotation (Line(
      points={{1,10},{17.8,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(from_deg.y, cheWinDir.nIn) annotation (Line(
      points={{43.1,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),__Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckWindDirection.mos"
        "Simulate and plot"));
end CheckWindDirection;
