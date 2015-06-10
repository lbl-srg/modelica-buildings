within Buildings.OpenStudioToModelica.Interfaces;
partial model SimulationExample
  "Base model that can be extended to create simulation examples for room models"
  extends Modelica.Icons.Example;
  replaceable BaseBuilding building(
    lon=weaDat.lon,
    lat=weaDat.lat,
    timZon=weaDat.timZon,
    nRooms=nRooms)
    annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    "Weather data used for the example"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  replaceable InternalHeatGains ihg[nRooms]
    "Internal heat gain and fluid ports for the rooms"
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));
  parameter Integer nRooms=1 "Number of rooms";
equation
  connect(weaDat.weaBus, building.weaBus) annotation (Line(
      points={{-40,30},{-12,30},{-12,7.7},{17.7,7.7}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ihg.roomConnector_out, building.rooms_conn) annotation (Line(
      points={{-40,-24},{-12,-24},{-12,-7},{18,-7}},
      color={0,0,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(
      StopTime=3.1536e+07,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimulationExample;
