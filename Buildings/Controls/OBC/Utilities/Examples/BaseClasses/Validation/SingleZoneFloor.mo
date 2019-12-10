within Buildings.Controls.OBC.Utilities.Examples.BaseClasses.Validation;
model SingleZoneFloor
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Buildings library air media package";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180;
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor
    singleZoneFloor(redeclare package Medium = Medium, lat=lat)
    annotation (Placement(transformation(extent={{-24,16},{16,56}})));
  Buildings.Examples.VAVReheat.ThermalZones.Floor floor(redeclare package
      Medium = Medium, lat=lat)
    annotation (Placement(transformation(extent={{-28,-48},{28,12}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(weaDat.weaBus, singleZoneFloor.weaBus) annotation (Line(
      points={{-60,10},{-40,10},{-40,52.6},{-13,52.6}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, floor.weaBus) annotation (Line(
      points={{-60,10},{-40,10},{-40,-18},{9,-18}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleZoneFloor;
