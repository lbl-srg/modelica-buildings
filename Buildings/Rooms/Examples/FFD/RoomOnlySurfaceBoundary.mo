within Buildings.Rooms.Examples.FFD;
model RoomOnlySurfaceBoundary
  "Natural convection in an empty room with only surface boundary"
  extends Modelica.Icons.Example;
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(roo(
      linearizeRadiation=false,
      samplePeriod=60,
      surBou(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
        each A=1*1,
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Floor,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        each absIR=1e-5,
        each absSol=1e-5,
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.Rooms.Types.CFDBoundaryConditions.HeatFlowRate})),
      nSurBou=6);

  Buildings.HeatTransfer.Sources.FixedTemperature TWesWal(each T=283.15)
    "Boundary condition for the west wall" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-30})));

  HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow[nSurBou - 2](each Q_flow=0)
    annotation (Placement(transformation(extent={{6,-24},{26,-4}})));
  HeatTransfer.Sources.FixedTemperature           TEasWal(each T=313.15)
    "Temperature of east wall"            annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,10})));
equation
  for i in 1:nSurBou - 2 loop
    connect(fixedHeatFlow[i].port, roo.surf_surBou[i+2])
    annotation (Line(
      points={{26,-14},{62.2,-14},{62.2,26}},
      color={191,0,0},
      smooth=Smooth.None));
  end for;

  connect(TEasWal.port, roo.surf_surBou[1]) annotation (Line(
      points={{100,10},{62.2,10},{62.2,26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TWesWal.port, roo.surf_surBou[2]) annotation (Line(
      points={{100,-30},{62.2,-30},{62.2,26}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,
            200}}),     graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/RoomOnlySurfaceBoundary.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only surface boundaries. 
It is also used to test the adiabatic boundary conditon in the FFD code.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation. 
The following conditions are applied at Modelica side:
</p>
<ul>
<li>
East Wall: Fixed temperature at 40 degC, 
</li>
<li>
West Wall: Fixed temperature at 10 degC,
</li>
<li>
North &amp; South Wall, Ceiling, Floor: Fixed heat flux at 0 W/m2. 
</li>
</ul>
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/RoomOnlySurfaceBoundary.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
December 31, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomOnlySurfaceBoundary;
