within Buildings.Rooms.Examples.FFD;
model WindowWithShade
  "Natural convection in an empty room with exterior walls, windows and shades"
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
      cfdFilNam="Resources/Data/Rooms/FFD/WindowWithShade.ffd",
      linearizeRadiation=false,
      shadeRatio={0.5,0.5},
      T_start=283.15,
      samplePeriod=10));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=true) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
  Modelica.Blocks.Sources.Constant shaSig[2](k=0.5) "Singal for shades"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
equation
  connect(shaSig.y, roo.uSha) annotation (Line(
      points={{21,80},{32,80},{32,56},{44,56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/FFD/WindowWithShade.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the cosimulation of 
<a href=\"modelica://Buildings.Rooms.CFD\">
Buildings.Rooms.CFD</a>
with the FFD program by simulating the natural convection in a room with only exterior walls and windows with shades.
</p>
<p>
Figure (a) show the schematic of FFD simulation. 
The walls and windows are exposed to the ambient environment. 
Both the wall and window are well insulated and the initial temperature of wall and windows is 20 degC.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/WindowWithShadeSchematic.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
Figure (b) shows the velocity vectors and temperature contour [degC] on the X-Z plane at Y=0.5m at t = 300s simulated by the FFD.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Rooms/Examples/FFD/WindowWithShade.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (b)
</p>
<p>
Note: Current version of the FFD program does not support the moving boundary.
Thus, the shade control signal must to be constant that is the same as the initial value.
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
August 13, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WindowWithShade;
