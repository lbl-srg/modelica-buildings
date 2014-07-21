within Buildings.Rooms.Examples.FFD;
model RoomOnlyConstructionBoundary
  "Test model for natural convection in an empty room with only construction boundary."
  extends Modelica.Icons.Example;
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(roo(datConBou(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
        layers={matLayRoo,matLayRoo,matLayRoo,matLayRoo,matLayRoo,matLayRoo},
        each A=1*1,
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Floor,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature})),
      nConBou=6);

  Buildings.HeatTransfer.Sources.FixedTemperature TWalRes[nConBou - 1](each T=
        283.15) "Boundary condition for the rest of walls" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-30})));

  HeatTransfer.Sources.FixedTemperature           TEasWal(each T=313.15)
    "Temperature of east wall"            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,0})));
equation
  for i in 1:nConBou - 1 loop
    connect(TWalRes[i].port, roo.surf_conBou[i + 1]) annotation (Line(
        points={{100,-30},{72,-30},{72,24}},
        color={191,0,0},
        smooth=Smooth.None));

  end for;

  connect(TEasWal.port, roo.surf_conBou[1]) annotation (Line(
      points={{100,0},{72,0},{72,24}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,
            200}}),     graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/RoomOnlyConstructionBoundary.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the copuled simulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only construction boundaries.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The room is 1 meter in length, width and height.
The temperature of the east wall is set to 40 degC and the rest walls are 10 degC.
The temperature of room air is 30 degC at t = 0s.
Two sensors are placed in the room center (0.5m, 0.5m, 0.5m) that measure the temperature and the velocity. 
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/OnlyWallSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p>
Figure (b) shows the velocity vectors and temperature contour [degC] on the X-Z plane at Y = 0.5m simulated by the FFD. 
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/RoomOnlyConstructionBoundary.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomOnlyConstructionBoundary;
