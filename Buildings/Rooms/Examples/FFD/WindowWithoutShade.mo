within Buildings.Rooms.Examples.FFD;
model WindowWithoutShade
  "Natural convection in an empty room with exterior walls, windows without shade"
  extends Modelica.Icons.Example;
  extends Buildings.Rooms.Examples.FFD.BaseClasses.PartialRoom(
    nConExt=4,
    nConExtWin=2,
    nConPar=0,
    nConBou=0,
    nSurBou=0,
    roo(
      nConExt=nConExt,
      nConExtWin=nConExtWin,
      datConExt(
        name={"North Wall","South Wall","Floor","Ceiling"},
        each A=1,
        layers={matLayExt,matLayExt,matLayExt,matLayExt},
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,
            Buildings.HeatTransfer.Types.Tilt.Floor,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature}),
      datConExtWin(
        name={"East Wall","West Wall"},
        layers={matLayExt,matLayExt},
        each A=1,
        glaSys={glaSys,glaSys},
        each wWin=1,
        each hWin=0.5,
        each fFra=0.2,
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.E,Buildings.HeatTransfer.Types.Azimuth.W},
        boundaryCondition={Buildings.Rooms.Types.CFDBoundaryConditions.Temperature,
            Buildings.Rooms.Types.CFDBoundaryConditions.Temperature}),
      cfdFilNam="Resources/Data/Rooms/FFD/WindowWithoutShade.ffd",
      T_start=283.15,
      shadeRatio={0,0}));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/WindowWithoutShade.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the coupled simulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in a room with only exterior walls and windows.
</p>
<p>
Figure (a) shows the schematic of FFD simulation. 
The walls are exposed to the ambient environment. 
Both the wall and window are well insulated and the initial temperature of wall and windows is 20 degC.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/WindowWithoutShadeSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
Figure (b) shows the velocity vectors and temperature contour [degC] on the X-Z plane at Y = 0.5m simulated by the FFD.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/WindowWithoutShade.png\" border=\"1\"/>
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
end WindowWithoutShade;
