within Buildings.Rooms.Examples.FFD;
model RoomOnlyExteriorWallNoWindow
  "Natural convection in an empty room with only exterior walls without windows."
  extends Modelica.Icons.Example;
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(
    nConExt=6,
    nConExtWin=0,
    nConPar=0,
    nConBou=0,
    nSurBou=0,
    roo(nConExt=nConExt, datConExt(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
        layers={matLayRoo,matLayRoo,matLayRoo,matLayRoo,matLayRoo,matLayRoo},
        each A=1*1,
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Floor,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature}),
      samplePeriod=30));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/RoomOnlyExteriorWallNoWindow.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only exterior walls and without windows.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The room is 1 meter in length, width and height.
The walls are exposed to the ambient environment (cold winter night in Chicago in this case) and the insulation is emtremely poor.
At t=0s, the temperature of walls are 20 degC and temperature of air is 30 degC.
All temperature drops quickly due to the heat loss. 
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
In the cold mid-night of Chicago, the temperature of ceiling is the lowest and the temperature of ground floor is the highest. 
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
