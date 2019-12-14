within Buildings.Controls.OBC.Utilities.Examples.BaseClasses.Validation;
model SingleZoneFloor
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Buildings library air media package";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude of site location";
  Buildings.Examples.VAVReheat.ThermalZones.Floor floor(
    redeclare package Medium = Medium, lat=lat) "Five-zone floor model"
    annotation (Placement(transformation(extent={{-28,-48},{28,12}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor sinZonFlo(
    redeclare package Medium = Medium, lat=lat) "Single-zone floor model"
    annotation (Placement(transformation(extent={{-24,16},{16,56}})));
equation
  connect(weaDat.weaBus, floor.weaBus) annotation (Line(
      points={{-60,10},{-40,10},{-40,-18},{9,-18}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sinZonFlo.weaBus) annotation (Line(
      points={{-60,10},{-40,10},{-40,54},{-13,54},{-13,53}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(StopTime=604800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/Examples/BaseClasses/SingleZoneFloor.mos"
        "Simulate and plot"),
  Documentation(info="
  <html>
  <p>
  This model validates the component <a href=\"modelica://Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor\">
  Buildings.Controls.OBC.Utilities.Examples.BaseClasses.SingleZoneFloor</a>.
  </p>
  </html>",
  revisions="
  <html>
  <ul>
  <li>
  December 10, 2019, by Kun Zhang:<br/>
  First implementation.
  </li>
  </ul>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end SingleZoneFloor;
