within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions;
package ExteriorConstructions "Exterior walls in FLEXLAB test cells"
  extends Modelica.Icons.MaterialPropertiesPackage;

  annotation(Documentation(info="<html>
    <p>
    This package contains constructions defining exterior walls used in
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
    UF90XRB:<br/>
    UF90X1A:</td>
    <td>North wall of the closet<br/>
    West exterior wall<br/>
    East exterior wall<br/>
    West exterior wall</td>
    </tr>
    <tr>
    <td>Construction2</td>
    <td>UF90X2:</td>
    <td>South exterior wall</td>
    </tr>
    <tr>
    <td>Construction3</td>
    <td>All test cells:</td>
    <td>North wall of electrical room</td>
    </tr>
    <tr>
    <td>Construction5and8</td>
    <td>UF90XRB:</td>
    <td>North exterior and south exterior</td>
    <tr>
    <td>Construction9</td>
    <td>UF90X1:</td>
    <td>South exterior wall</td>
    </tr>
    <tr>
    <td>Construction10</td>
    <td>UF90X3:</td>
    <td>South exterior wall</td>
    </tr>
    <tr>
    <td>Construction17and24</td>
    <td>UF90XRA:</td>
    <td>North exterior and south exterior</td>
    </tr>
    </table>
    </html>"));
end ExteriorConstructions;
