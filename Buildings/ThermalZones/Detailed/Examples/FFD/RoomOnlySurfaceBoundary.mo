within Buildings.ThermalZones.Detailed.Examples.FFD;
model RoomOnlySurfaceBoundary
  "Natural convection in an empty room with only surface boundary"
  extends Modelica.Icons.Example;
  extends Buildings.ThermalZones.Detailed.Examples.FFD.BaseClasses.PartialRoom(roo(
      linearizeRadiation=false,
      samplePeriod=60,
      surBou(
        name={"East Wall","West Wall","North Wall","South Wall","Floor","Ceiling"},
        each A=1*1,
        til={Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Floor,
            Buildings.Types.Tilt.Ceiling},
        each absIR=1e-5,
        each absSol=1e-5,
        boundaryCondition={
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.HeatFlowRate})),
        nSurBou=6);

  Buildings.HeatTransfer.Sources.FixedTemperature TWesWal(T=283.15)
    "Boundary condition for the west wall" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,-30})));

  HeatTransfer.Sources.FixedTemperature TEasWal(T=313.15)
    "Temperature of the east wall"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,10})));
equation

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
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/RoomOnlySurfaceBoundary.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-06, StopTime=1800),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating the natural convection in an empty room with only surface boundaries.
It is also used to test the adiabatic boundary conditon in the FFD code.
</p>
<p>
Figure (a) shows the schematic of the FFD simulation.
The following conditions are applied in the Modelica model:
</p>
<ul>
<li>
East Wall: Fixed temperature at <i>40</i>&circ;C,
</li>
<li>
West Wall: Fixed temperature at <i>10</i>&circ;C,
</li>
<li>
North and South Wall, Ceiling, Floor: Fixed heat flux at <i>0</i> W/m<sup>2</sup>.
</li>
</ul>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/OnlyWallSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p>
Figure (b) shows the velocity vectors and temperature contours in degree Celsius
on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/RoomOnlySurfaceBoundary.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
July 7, 2015 by Michael Wetter:<br/>
Removed model for prescribed heat flow boundary condition
as the value was zero and hence the model is not needed.
This is for <a href=\"/https://github.com/lbl-srg/modelica-buildings/issues/439\">issue 439</a>.
</li>
<li>
December 31, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomOnlySurfaceBoundary;
