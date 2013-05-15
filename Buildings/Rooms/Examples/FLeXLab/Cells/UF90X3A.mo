within Buildings.Rooms.Examples.FLeXLab.Cells;
model UF90X3A
  "Extension of PartialTestCell to include geometry and construction of UF90X3A"
  extends Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses.PartialTestCell(
  roo(AFlo=A,
      nSurBou=1,
      nConPar=1,
      hRoo=3.6576,
      nConExtWin=1,
      surBou(
        each A=6.645*9.144,
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.HeatTransfer.Types.Tilt.Floor),
      datConExt(
        layers={R16p8Wal,R52Wal,R20Wal},
        A={3.6576*4.42,3.6576*1.472, 6.645*9.144},
        til={Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Wall,Buildings.HeatTransfer.Types.Tilt.Ceiling},
        azi={Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N,Buildings.HeatTransfer.Types.Azimuth.S}),
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
      nConExt=3,
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind,
      lat=0.66098585832754),                       sla(
      disPip=disPip,
      length=A/disPip,
      A=A,
      sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Types.SystemType.Floor,
      pipe=pipe,
      nSeg=10,
      layers=slaCon,
      iLayPip=1));

  parameter Modelica.SIunits.Area A = 60.97 "Floor area of the test cell";
  parameter Modelica.SIunits.Length disPip = 0.2 "Distance between the pipes";

  Data.Constructions.OpaqueConstructions.Gyp16Gyp16
                                parCon
    "Partition wall between the test cell and the electrical room"
    annotation (Placement(transformation(extent={{-164,-120},{-144,-100}})));
  Data.Constructions.OpaqueConstructions.Insul24Ply13Insul83Gyp16
                                              R16p8Wal
    "Wall with R16.8 worth of insulation"
    annotation (Placement(transformation(extent={{-134,-120},{-114,-100}})));
  HeatTransfer.Data.GlazingSystems.TripleClearAir13ClearAir13Clear glaSys(
      haveExteriorShade=true)
    annotation (Placement(transformation(extent={{-164,-98},{-144,-78}})));

    //fixme - Not necessarily the right window model. Get specs from specifications (see Cindy Regnier e-mail, Apr 16)

  Data.Constructions.OpaqueConstructions.Gyp16Insul102Ply13
                                        R20Wal
    "Wall construction with R20 insulation. Used in the roof of test cell UF90X3A"
    annotation (Placement(transformation(extent={{-164,-144},{-144,-124}})));

  Data.Constructions.OpaqueConstructions.Insul127Ply13Insul203Ply13Gyp16
                                                     R52Wal
    "Wall construction with R52 insulation"
    annotation (Placement(transformation(extent={{-194,-144},{-174,-124}})));

annotation(Documentation(info="<html>    
  <p>
  This model is an extension of <a href=\"modelica://Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses.PartialTestCell\">Buildings.Rooms.Examples.FLeXLab.Cells.BaseClasses.PartialTestCell</a>
  to include specific information describing test cell UF90X3A. Parameters have been entered into <a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
  and <a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab</a> to
  describe the geometry and construction of the test cell.
  </p>
  <p>
  Inputs describing shade position, internal gains, supply air, supply water and ground temperature have been left blank to allow flexibility when using the model.
  This way users can either read the data in from a text-based data file or create simulations controlling the mentioned inputs.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  May 15, 2013 by Peter Grant:<br>
  First implementation
  </li>
  </ul>
  </html>"));
end UF90X3A;
