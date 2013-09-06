within Buildings.Rooms.FLEXLAB.Data;
package OpaqueConstructions "Opaque constructions found in FLEXLAB test cells"
  extends Modelica.Icons.MaterialPropertiesPackage;

  package DividingWalls "Walls used to divide test beds and cells"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record CellAndElectricalDividingWall =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01905)},
        final nLay = 5) "Wall separating FLEXLAB test cells from the adjoining
      electrical rooms";

    record ClosetAndElectricalDividingWall =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01905),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 6) "Wall separating FLEXLAB closets from the adjoining 
      electrical rooms";

    record TestBedDividingWall =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.1588)},
        nLay = 10) "Wall separating test beds";

    record TestCellDividngWall =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.1588)},
        nLay = 7) "Wall separating test cells within a test bed";

  end DividingWalls;

  package ExteriorConstructions
    "Exterior walls facing north in FLEXLAB test cells"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record Construction1 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 5) "North wall in FLEXLAB closets, west wall in UF90X1A";

    record Construction2 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.08255),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 4) "South wall in test cell UF90X2";

    record Construction3 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.03175)},
        final nLay = 4) "North wall of the electrical room in all test cells";

    record Construction5and8 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 3) "Wall construction found in test cell UF90XRB";

    record Construction9 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.06985),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 4) "South wall in test cell UF90X1";

    record Construction10 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.02413),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.08255),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 4) "South wall in test cell UF90X3";

    record Construction17and24 =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.04752),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay = 4) "Wall construction found in UF90XRA";

    record ExteriorDoorInsulated =
       Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
        final nLay=3) "Model of an insulated exterior door";

    record ExteriorDoorUninsulated =
       Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
        final nLay=2) "Model of an uninsulated exterior door";

    annotation(Documentation(info="<html>
    <p>
    This package contains constructions defining exterior walls and windows used in 
    FLEXLAB test cells. The following table lists locations in FLEXLAB test cells
    where the constructions are used. Locations of walls in UF90XR are described
    assuming that the windows are facing south. Some of the constructions are
    combined into single packages because they are, from a thermal point of
    view, functionally identical.
    </p>
    <table border =\"1\" summary = \"Description of walls using each construction\">
    <tr>
    <th>Construction</th>
    <th>Test Cell</th>
    <th>Wall</th>
    </tr>
    <tr>
    <td>Construction1</td>
    <td>All test cells:<br/>
    UF90XRA:<br/>
    UF90XRB:<br/></td>
    <td>North wall of the closet<br/>
    West exterior wall<br/>
    East exterior wall<br/></td>
    </tr>
    <tr>
    <td>Construction2</td>
    <td>UF90X2:</td>
    <td>South wall</td>
    </tr>
    <tr>
    <td>Construction3</td>
    <td>All test cells:</td>
    <td>North wall of electrical room</td>
    </tr>
    <tr>
    <td>Construction5and8</td>
    <td>UF90XRB</td>
    <td>North exterior and south exterior</td>
    <tr>
    <td>Construction9</td>
    <td>UF90X1:</td>
    <td>South wall</td>
    </tr>
    <tr>
    <td>Construction10</td>
    <td>UF90X3:</td>
    <td>South wall</td>
    </tr>
    <tr>
    <td>Construction17and24</td>
    <td>UF90XRA</td>
    <td>North exterior and south exterior</td>
    </tr>
    </table>
    </html>"));
  end ExteriorConstructions;

  package PartitionConstructions
    "Constructions used in partitions contained within a test cell"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record PartitionDoor =
       Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
        final nLay=2) "Model of a partition wall door. Air is neglected";

    record PartitionWall =
       Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
        final nLay=2) "Model of a partition wall. Air is neglected";

  end PartitionConstructions;

  package Roofs "Roof constructions commonly found in FLEXLAB test cells"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record ASHRAE_901_1975Roof =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.09652),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
        final nLay=3) "Construction model for a roof minimally compliant with ASHRAE 90.1-1975. 
      Used in test cells 90X1A and 90X1B";

    record ASHRAE_901_2010Roof =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
        final nLay=3) "Construction model for a roof minimally compliant with ASHRAE 90.1. 
      Used in test cells 90X3A, 90X3B, and 90XRA";

    record CA_T24_2013Roof =
      Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
        Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
        Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
        Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
        final nLay=3) "Construction model for a roof minimally compliant with CA Title 24-2013. 
      Used in test cells 90X2A and 90X2B";

  end Roofs;

end OpaqueConstructions;
