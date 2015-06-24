within Buildings.Rooms.Examples.FFD;
model RoomOnlyConstructionBoundary
  "Test model for natural convection in an empty room with only construction boundary."
  extends Modelica.Icons.Example;
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayWal(
      final nLay=1, material={HeatTransfer.Data.Solids.Steel(x=0.001)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth)
    "Construction material for all the envelopes"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(
    roo(
      datConBou(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
      layers={matLayWal,matLayWal,matLayWal,matLayWal,matLayWal,matLayWal},
      each A=1*1,
        til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Ceiling},
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature}),
        homotopyInitialization=false),
      nConBou=6);

  Buildings.HeatTransfer.Sources.FixedTemperature TWalRes[nConBou - 1](
      each T=283.15) "Boundary condition for the other walls" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,-30})));

  HeatTransfer.Sources.FixedTemperature TEasWal(each T=313.15)
    "Temperature of the east wall"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
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
    experiment(StopTime=120),
    Documentation(info="<html>
<p>
This model tests the copuled simulation of
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only construction boundaries.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The room is <i>1</i> meter in length, width and height.
The temperature of the east wall is set to <i>40</i>&circ;C and the rest walls are at <i>10</i>&circ;C.
The initial value for the temperature of the room air is <i>30</i>&circ;C.
Two sensors are placed in the room center at (<i>0.5</i> m, <i>0.5</i> m, <i>0.5</i> m)
that measure the temperature and the velocity.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/OnlyWallSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p>
Figure (b) shows the velocity vectors and temperature contours in degree Celsius
on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
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
