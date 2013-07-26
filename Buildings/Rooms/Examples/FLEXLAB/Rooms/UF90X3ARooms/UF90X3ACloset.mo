within Buildings.Rooms.Examples.FLEXLAB.Rooms.UF90X3ARooms;
model UF90X3ACloset "Model of the closet connected to test bed UF90X3A"
  extends Buildings.Rooms.MixedAir(
  hRoo = 3.6576,
  AFlo = 3.93,
  lat = 0.66098585832754,
  nConExt = 1,
  nConBou = 2,
  nSurBou = 2,
  surBou(
    A = {3.6576 * 2.886075 - 2.39*1.22, 2.39 * 1.22},
    each absIR = 0.9,
    each absSol = 0.9,
    each til=Buildings.HeatTransfer.Types.Tilt.Floor),
  datConExt(
    layers = {higIns},
    A = {3.6576 * 1.667},
    til = {Buildings.HeatTransfer.Types.Tilt.Wall},
    azi = {Buildings.HeatTransfer.Types.Azimuth.N}),
  datConBou(
    layers = {higIns, celDiv},
    A = {3.6576*1.524, 3.6576 * 1.524},
    til = {Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall},
    azi = {Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.E}));

  Data.Constructions.OpaqueConstructions.HighInsulExtWall higIns
    "High insulation wall. Between UF90X3A closet and exterior, UF90X3A closet and electricl room"
    annotation (Placement(transformation(extent={{430,-208},{450,-188}})));
  Data.Constructions.OpaqueConstructions.TestCellDividngWall celDiv
    "Wall dividing the UF90X3A closet and the UF90X3B closet"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
end UF90X3ACloset;
