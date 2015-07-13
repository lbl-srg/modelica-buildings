within Buildings.Rooms.Examples.FFD;
model RoomOnlyExteriorWallNoWindow
  "Natural convection in an empty room with only exterior walls without windows."
  extends Modelica.Icons.Example;
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic matLayWal(
      final nLay=1, material={HeatTransfer.Data.Solids.Steel(x=0.001)},
    roughness_a=Buildings.HeatTransfer.Types.SurfaceRoughness.Smooth)
    "Construction material for all the envelopes"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(
    nConExt=6,
    nConExtWin=0,
    nConPar=0,
    nConBou=0,
    nSurBou=0,
    roo(nConExt=nConExt, datConExt(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
        layers={matLayWal,matLayWal,matLayWal,matLayWal,matLayWal,matLayWal},
        each A=1*1,
        til={Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Floor,
            Buildings.Types.Tilt.Ceiling},
        boundaryCondition={
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature}),
        samplePeriod=30));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/RoomOnlyExteriorWallNoWindow.mos"
        "Simulate and plot"),
    experiment(StopTime=60),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only exterior walls and without windows.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The room is <i>1</i> meter in length, width and height.
The walls are exposed to the ambient environment (cold winter night in Chicago) and the insulation is very poor.
The initial values are for the temperatures of the walls <i>20</i>&circ;C and for temperature of the air <i>30</i>&circ;C.
All temperature drop quickly due to the heat loss.
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
Figure (b) shows the velocity vectors and temperature contours in degree Celsius on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
In the cold mid-night of Chicago, the temperature of the ceiling is the lowest and the temperature of the ground floor is the highest.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/RoomOnlyExteriorWallNoWindow.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
August 13, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomOnlyExteriorWallNoWindow;
