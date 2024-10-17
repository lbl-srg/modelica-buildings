within Buildings.ThermalZones.EnergyPlus_24_2_0.Validation.SurfaceComparison.BaseClasses;
model ZoneSurfaces
  "Example model with two EnergyPlus unconditioned zones with their separating surfaces modeled in Modelica"
  extends BaseClasses.ReferenceSurfaces;

  parameter Integer nSta = 3 "Number of states";

  BaseClasses.InteriorWall int(
    layers=intWal,
    surNam_a="Garage:Interior",
    surNam_b="Living:Interior",
    A=16.87) "Interior wall between living room and garage" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-70})));
  BaseClasses.ExteriorWall wes(
    layers=extWal,
    surNam="Garage:WestWall",
    A=14.87) "West wall of garage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-50})));
  BaseClasses.ExteriorWall eas(
    layers=extWal,
    surNam="Garage:EastWall",
    A=14.87) "East wall of garage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-50})));

protected
  parameter HeatTransfer.Data.Solids.GypsumBoard gyp(
    x=0.0127,
    k=0.16,
    c=837,
    d(displayUnit="kg/m3") = 801,
    nStaRef=nSta) "Gypsum or Plaster Board 1/2 in"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  parameter HeatTransfer.Data.Solids.InsulationBoard ins(
    x=0.09,
    k=0.043,
    c=837,
    d(displayUnit="kg/m3") = 10.0,
    nStaRef=nSta) "Mineral Wool/Fiber Batt R-11"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  parameter HeatTransfer.Data.Solids.Concrete CB11(
    x=0.2032000,
    k=1.048000,
    c=837,
    d(displayUnit="kg/m3") = 1105,
    nStaRef=nSta) "Concrete Block 8 in HW Hol."
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard stu(
    x=0.025389841,
    k=0.6918309,
    c=836.8000,
    d(displayUnit="kg/m3") = 1858.142,
    nStaRef=nSta) "Stucco layer 1 in"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic intWal(
    nLay=3,
    material={gyp,ins,gyp},
    absSol_a=0.75,
    absSol_b=0.75) "Interior wall construction"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic extWal(
    nLay=2,
    material={stu,CB11},
    absSol_a=0.92,
    absSol_b=0.92) "Exterior garage wall construction"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));


  annotation (
    Documentation(
      info="<html>
<p>
This model simulates the envelope of a single family house with EnergyPlus but uses
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface</a> to model the heat
transfer through the garage exterior (east and west facing) and interior walls.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 21, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/SurfaceComparison/ZoneSurfaces.mos"
        "Simulate and Plot", file="../test.mos" "test"),
    experiment(
      StopTime=2592000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ZoneSurfaces;
