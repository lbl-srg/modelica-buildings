within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A;
model TestCellRadiantExterior
  "Model of a room with two exposed walls, built from model of LBNL User Test Facility Cell X3A"
  extends Buildings.ThermalZones.Detailed.MixedAir(
    massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
                                                   AFlo=45,
      nSurBou=1,
      nConPar=0,
      nConBou=3,
      nConExt=0,
      nConExtWin=2,
      hRoo=3,
      surBou(
      A={5*9},
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.Types.Tilt.Floor),
      datConBou(
      layers={parCon,parCon,R20Wal},
      each steadyStateInitial=false,
      each T_a_start=288.15,
      each T_b_start=288.15,
      each stateAtSurface_b=false,
      each boundaryCondition=Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions.Temperature,
         A = {3 * 9, 5 * 3, 5*9},
         til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling},
         azi = {Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.N},
      each stateAtSurface_a=false),
      datConExtWin(
        layers={R25Wal, R25Wal},
      each steadyStateInitial=false,
      each T_a_start=288.15,
      each T_b_start=288.15,
      each stateAtSurface_a=true,
      each stateAtSurface_b=true,
      A={5*3,9*3},
        glaSys={glaSys,glaSys},
      hWin={2,2},
      wWin={2,2},
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.W,Buildings.Types.Azimuth.S}),
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
    conBou(
      each steadyStateInitial=false,
      each T_a_start=288.15,
      each T_b_start=288.15),
    datConPar(
      each steadyStateInitial=true,
      each stateAtSurface_a=true,
      each stateAtSurface_b=true));

  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.ConstructionRadiantR25Wall
                                                                     R25Wal
    annotation (Placement(transformation(extent={{410,-166},{430,-146}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.CellAndElectricalDividingWall
                                                                      R52Wal
    annotation (Placement(transformation(extent={{410,-192},{430,-172}})));
  replaceable parameter Data.Constructions.OpaqueConstructions.Roofs.ASHRAE_901_2010Roof
                                                                   R20Wal
    annotation (Placement(transformation(extent={{410,-216},{430,-196}})));
  replaceable parameter Data.Constructions.GlazingSystems.RadiantGlaSB70XL glaSys
    annotation (Placement(transformation(extent={{436,-192},{456,-172}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.PartitionConstructions.PartitionWall
    parCon
    annotation (Placement(transformation(extent={{436,-216},{456,-196}})));

  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.TestCellDividngWall
                                                                         celDiv
    "Construction of wall connecting to cell UF90X3B- NOT USED"
    annotation (Placement(transformation(extent={{410,-144},{430,-124}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.TestBedDividingWall
                                                                         bedDiv
    "Construction of wall connecting to cell UF90X2B- NOT USED"
    annotation (Placement(transformation(extent={{410,-120},{430,-100}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.PartitionConstructions.PartitionDoor
                                                                   parDoo
    "Door used in partition walls in FLEXLAB test cells- NOT USED"
    annotation (Placement(transformation(extent={{410,-94},{430,-74}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.ExteriorDoorInsulated
    extDoo "Construction of an exterior door- NOT USED"
    annotation (Placement(transformation(extent={{410,-72},{430,-52}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for an exterior zone, with many base characteristics drawn from test cell 3A in the LBNL User Facility. 
  This model is intended to represent a sample exterior zone for radiant and natural ventilation control, and is used in validation models for 
  (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.NightFlush.NightFlushFixedDuration\">
  Buildings.Experimental.NaturalVentilation.NightFlush.NaturalVentilationNightFlushFixedDuration</a>), (<a href=\"modelica://Buildings.Experimental.NaturalVentilation.NightFlush.NightFlushFixedDuration\">
  Buildings.Experimental.NaturalVentilation.NightFlush.NaturalVentilationNightFlushDynamicDuration</a>), and (<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts\">
  Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts</a>). The zone is 5 meters by 9 meters in floor area and is 3 meters in height. The zone has two exposed walls, each with windows: one oriented south, and the other oriented west. 
  The roof is a standard ASHRAE 90.1 2010 code-minimum construction. 
  The floor should be exposed to a radiant slab (in the case of radiant models) or to another boundary condition (if no radiant is present). 
  The remaining two walls are exposed to a constant-temperature boundary condition that should be set to ~70F to approximate interior conditions. 
  Exterior wall constructions are R-25; windows are 2 meters by 2 meters each and are the equivalent of Solarban 70. Partition walls are standard partition constructions. 
  </p>
  </html>",
  revisions = "<html>
  <ul>
  <li>Jun 10, 2013 by Peter Grant:<br/>
  First implementation.
  </li>
  </ul>
  </html>"), defaultComponentName = "radExt", Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},
            {200,200}}),       graphics={
        Bitmap(extent={{-160,164},{162,-166}}, fileName=
              "modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/icon.png"),
                Rectangle(
          extent={{-58,12},{-26,-8}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,-26},{-22,-42}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-108,-132},{-56,-148}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-136,-82},{-84,-98}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,12},{-22,-10}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="air"),
        Text(
          extent={{-72,-22},{-22,-50}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="radiation"),
        Text(
          extent={{-104,-124},{-54,-152}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="surface"),
        Text(
          extent={{-138,-82},{-96,-100}},
          lineColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="fluid")}));
end TestCellRadiantExterior;
