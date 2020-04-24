within Buildings.ThermalZones.Detailed.Examples.FFD;
model WindowWithShade
  "Natural convection in an empty room with exterior walls, windows and shades"
  extends Modelica.Icons.Example;
  extends Buildings.ThermalZones.Detailed.Examples.FFD.BaseClasses.PartialRoom(
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
        til={
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Floor,
            Buildings.Types.Tilt.Ceiling},
        boundaryCondition={
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature}),
      datConExtWin(
        name={"East Wall","West Wall"},
        layers={matLayExt,matLayExt},
        each A=1,
        glaSys={glaSys,glaSys},
        each wWin=1,
        each hWin=0.5,
        each fFra=0.2,
        til={
            Buildings.Types.Tilt.Wall,
            Buildings.Types.Tilt.Wall},
        azi={
            Buildings.Types.Azimuth.E,
            Buildings.Types.Azimuth.W},
        boundaryCondition={
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
            Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature}),
        uSha_fixed={0.5,0.5},
        samplePeriod=10,
        linearizeRadiation=true,
        cfdFilNam="modelica://Buildings/Resources/Data/ThermalZones/Detailed/Examples/FFD/WindowWithShade.ffd"));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));

  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveExteriorShade=false,
    haveInteriorShade=true) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            200,200}}), graphics),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/WindowWithShade.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-06, StopTime=300),
    Documentation(info="<html>
<p>This model tests the cosimulation of <a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a> with the FFD program by simulating natural convection in a room with only exterior walls and windows with shades. </p>
<p>Figure (a) show the schematic of FFD simulation. The walls and the windows are exposed to the ambient environment. The wall is well insulated and the initial temperature is <i>20</i>&deg;C. The initial temperature for the room air is 17&deg;C.</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/WindowWithShadeSchematic.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (a) </p>
<p>Figure (b) shows the velocity vectors and temperature contours in degree Celsius on the X-Z plane at <i>Y = 0.5</i> m, at <i>t = 300</i> s as simulated by the FFD. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/WindowWithShade.png\" alt=\"image\"/> </p>
<p align=\"center\">Figure (b) </p>
<p><b>Note</b>: The current version of the FFD program does not support a moving boundary. Thus, the shade can only be at a fixed position as determined by the parameter <code>uSha_fixed={0.5,0.5}</code>. </p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2013, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WindowWithShade;
