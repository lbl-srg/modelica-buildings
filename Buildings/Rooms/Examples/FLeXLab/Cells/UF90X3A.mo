within Buildings.Rooms.Examples.FLeXLab.Cells;
model UF90X3A "Model of LBNL User Test Facility Cell 90X3A"
  extends MixedAir(AFlo=60.97,
      nSurBou=1,
      nConPar=1,
      nConBou = 0,
      nConExt=4,
      nConExtWin=1,
      hRoo=3.6576,
      surBou(
        each A=6.645*9.144,
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.HeatTransfer.Types.Tilt.Floor),
      datConExt(
        layers={R16p8Wal,
        R52Wal,
        R52Wal,
        R20Wal},
        A={3.6576*3.9243,3.6576*2.7432, 3.6576*1.524, 6.645*9.144},
        til={Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Ceiling},
        azi={Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.S}),
      datConExtWin(
        layers={R16p8Wal},
        A={6.645*3.6576},
        glaSys={glaSys},
        hWin={1.8288},
        wWin={5.86},
        til={Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.S}),
      datConPar(
        layers={parCon},
        A={3.6576*1.472},
        til={Buildings.HeatTransfer.Types.Tilt.Wall},
        azi={Buildings.HeatTransfer.Types.Azimuth.S}),
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
      lat=0.66098585832754);
  Data.Constructions.OpaqueConstructions.ModInsulExtWall          R16p8Wal
    annotation (Placement(transformation(extent={{-180,-94},{-160,-74}})));
  Data.Constructions.OpaqueConstructions.HighInsulExtWall                R52Wal
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Data.Constructions.OpaqueConstructions.ASHRAE901Roof      R20Wal
    annotation (Placement(transformation(extent={{-180,-144},{-160,-124}})));
  Data.Constructions.GlazingSystems.ASHRAE901Gla               glaSys
    annotation (Placement(transformation(extent={{-180,-168},{-160,-148}})));
  Data.Constructions.OpaqueConstructions.PartitionWall
                                                    parCon
    annotation (Placement(transformation(extent={{-180,-192},{-160,-172}})));

  annotation(Documentation(info="<html>
  <p>
  This is a model for test cell 3A in the LBNL User Facility. The model is based on 
  <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. Appropriate
  condstructions and parameters have been used to describe the test cell.
  </p>
  <p>
  Constructions used to describe the walls used in 
  <a href=\"modelica:Buildings.Rooms.Examples.FLeXLab.Cells.UF90X3A\">
  Buildings.Rooms.Examples.FLeXLab.Cells.UF90X3A</a> are available in 
  <a href=\"modelica:Buildings.Rooms.Examples.FLeXLab.Constructions.OpaqueConstructions\">
  Buildings.Rooms.Examples.FLeXLab.Constructions.OpaqueConstructions</a>. All wall 
  construction models are made using information from architectural drawings. Constructions
  used to describe the windows are available in
  <a href=\"modelica:Buildings.Rooms.Examples.FLeXLab.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.Examples.FLeXLab.Data.Constructions.GLazingSystems</a>. Window models are based on
  information available in the construction specifications.
  </p>
  <p>
  This model assumes that the removable wall between cells A and B is installed.<br>
  </p>
  </html>",
  revisions = "<html>
  <ul>
  <li>Jun 10, 2013 by Peter Grant:<br>
  First implementation.</li>
  </ul>
  </html>"));
end UF90X3A;
