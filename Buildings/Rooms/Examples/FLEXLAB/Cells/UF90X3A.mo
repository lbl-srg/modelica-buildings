within Buildings.Rooms.Examples.FLEXLAB.Cells;
model UF90X3A "Model of LBNL User Test Facility Cell 90X3A"
  extends Buildings.Rooms.MixedAir(AFlo=60.97,
      nSurBou=1,
      nConPar=0,
      nConBou=5,
      nConExt=4,
      nConExtWin=1,
      hRoo=3.6576,
      surBou(
        each A=6.645*9.144,
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.HeatTransfer.Types.Tilt.Floor),
      datConExt(
         layers={extDoo,
         R16p8Wal,
         R20Wal,
         bedDiv},
         A={1.3716 * 2.39, 3.6576*2.52-2.39*1.3716, 6.6675*9.144, 3.6576 * 1.524},
         til={Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Ceiling, Buildings.HeatTransfer.Types.Tilt.Wall},
         azi={Buildings.HeatTransfer.Types.Azimuth.N,Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.S, Buildings.HeatTransfer.Types.Azimuth.W}),
      datConBou(
         layers = {bedDiv,celDiv,parCon, parDoo, R52Wal},
         A = {3.6576 * 7.62, 3.6576 * 9.144, 3.6576*2.886075-2.39*1.22, 2.39*1.22, 3.6576*1.2614},
         til = {Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall},
         azi = {Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.E, Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N}),
      datConExtWin(
        layers={R16p8Wal},
        A={6.6675*3.6576},
        glaSys={glaSys},
        hWin={1.8288},
        wWin={5.88},
        til={Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.S}),
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
      lat=0.66098585832754);

  Data.Constructions.OpaqueConstructions.ModInsulExtWall          R16p8Wal
    annotation (Placement(transformation(extent={{410,-168},{430,-148}})));
  Data.Constructions.OpaqueConstructions.HighInsulExtWall                R52Wal
    annotation (Placement(transformation(extent={{410,-192},{430,-172}})));
  Data.Constructions.OpaqueConstructions.ASHRAE901Roof      R20Wal
    annotation (Placement(transformation(extent={{410,-216},{430,-196}})));
  Data.Constructions.GlazingSystems.ASHRAE901Gla               glaSys
    annotation (Placement(transformation(extent={{436,-192},{456,-172}})));
  Data.Constructions.OpaqueConstructions.PartitionWall
                                                    parCon
    annotation (Placement(transformation(extent={{436,-216},{456,-196}})));

  Data.Constructions.OpaqueConstructions.TestCellDividngWall celDiv
    "Construction of wall connecting to cell UF90X3B"
    annotation (Placement(transformation(extent={{410,-144},{430,-124}})));
  Data.Constructions.OpaqueConstructions.TestBedDividingWall bedDiv
    "Construction of wall connecting to cell UF90X2B"
    annotation (Placement(transformation(extent={{410,-120},{430,-100}})));
  Data.Constructions.OpaqueConstructions.PartitionDoor parDoo
    "Door used in partition walls in FLeXLab test cells"
    annotation (Placement(transformation(extent={{410,-96},{430,-76}})));
  Data.Constructions.OpaqueConstructions.ExteriorDoor extDoo
    "Construction of an exterior door"
    annotation (Placement(transformation(extent={{410,-72},{430,-52}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for test cell 3A in the LBNL User Facility. The model is based on 
  <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. Appropriate
  condstructions and parameters have been used to describe the test cell.
  </p>
  <p>
  Constructions used to describe the walls used in test cell UF90X3A are available in 
  <a href=\"modelica:Buildings.Rooms.Examples.FLEXLAB.Constructions.OpaqueConstructions\">
  Buildings.Rooms.Examples.FLEXLAB.Constructions.OpaqueConstructions</a>. All wall 
  construction models are made using information from architectural drawings. Constructions
  used to describe the windows are available in
  <a href=\"modelica:Buildings.Rooms.Examples.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.Examples.FLEXLAB.Data.Constructions.GLazingSystems</a>. Window models are based on
  information available in the construction specifications.
  </p>
  <p>
  This model assumes that the removable wall between cells A and B is installed.
  </p>
  <p>
  There are 7 different wall sections described in the model. They are shown below:
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/Controls/SetPoints/Examples/HotWaterTemperatureReset.png\" border=\"1\" alt=\"Supply and return water temperatures.\"/>
  </p>  
  
  </html>",
  revisions = "<html>
  <ul>
  <li>Jun 10, 2013 by Peter Grant:<br>
  First implementation.</li>
  </ul>
  </html>"));
end UF90X3A;
