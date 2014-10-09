within Districts.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CheckTemperature "Test model for CheckTemperature"
  extends Modelica.Icons.Example;
  import Districts;
public
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDryBul "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Districts.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDewPoi "Check dew point temperature"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
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
  Districts.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{20,20},{42,40}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{20,-20},{42,0}})));
equation
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-79,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], from_degC.u) annotation (Line(
      points={{1,10},{10,10},{10,30},{17.8,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(from_degC.y, cheTemDryBul.TIn) annotation (Line(
      points={{43.1,30},{58,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], from_degC1.u) annotation (Line(
      points={{1,10},{10,10},{10,-10},{17.8,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(from_degC1.y, cheTemDewPoi.TIn) annotation (Line(
      points={{43.1,-10},{58,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file=
          "modelica://Districts/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/CheckTemperature.mos"
        "Simulate and plot"));
end CheckTemperature;
