within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents;
model RCBuildingWithETS
  "Model of a building (RC) with an energy transfer station"
  extends
    Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Agents.BaseClasses.PartialBuildingWithETS(
    redeclare Buildings.Applications.DHC.Loads.Examples.BaseClasses.RCBuildingPump bui(
      nZon=nZon));
  parameter Integer nZon = 1
    "Number of thermal zones"
    annotation(Dialog(group="Building model parameters"), Evaluate=true);
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(
    transformation(extent={{-18,84},{16,116}}),
    iconTransformation(extent={{-18,84},{16,116}})));
equation
  connect(weaBus, bui.weaBus) annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end RCBuildingWithETS;
