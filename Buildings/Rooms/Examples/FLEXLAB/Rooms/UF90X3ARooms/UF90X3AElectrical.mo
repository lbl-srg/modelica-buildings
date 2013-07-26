within Buildings.Rooms.Examples.FLEXLAB.Rooms.UF90X3ARooms;
model UF90X3AElectrical
  "Model of the electrical room attached to test cell UF90X3A"
  extends Buildings.Rooms.MixedAir(
  hRoo = 3.6576,
  AFlo = 2.39,
  lat = 0.66098585832754,
  nSurBou = 2,
  nConExt=4,
  surBou(
    A = {3.6576 * 1.2641, 3.6576 * 1.524},
    each absIR = 0.9,
    each absSol = 0.9,
    each til = Buildings.HeatTransfer.Types.Tilt.Wall),
  datConExt(
    layers = {eleExt, eleExt, extDooUn, roo},
    A = {3.6576 * 1.26413, 3.6576 * 1.524 - 2.38658 * 1.524, 2.38658*1.524, 2.39},
    til = {Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Ceiling},
    azi = {Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.N}));
  Data.Constructions.OpaqueConstructions.ElectricalRoomExteriorWall
    eleExt "Construction describing the exterior walls in the electrical room"
    annotation (Placement(transformation(extent={{430,-210},{450,-190}})));
  Data.Constructions.OpaqueConstructions.ExteriorDoorUninsulated
    extDooUn "Construction describing the door in the electrical room"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  Data.Constructions.OpaqueConstructions.ASHRAE901Roof roo
    "Construction describing the roof of the electrical room"
    annotation (Placement(transformation(extent={{430,-148},{450,-128}})));
end UF90X3AElectrical;
