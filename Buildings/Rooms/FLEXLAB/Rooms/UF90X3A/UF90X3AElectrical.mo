within Buildings.Rooms.FLEXLAB.Rooms.UF90X3A;
model UF90X3AElectrical
  "Model of the electrical room attached to test cell UF90X3A"
  extends Buildings.Rooms.MixedAir(
  hRoo = 3.6576,
  AFlo = 2.39,
  lat = 0.66098585832754,
  nSurBou = 2,
  nConExt=4,
  nConExtWin=0,
  nConPar=0,
  nConBou=0,
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
  replaceable Data.Constructions.OpaqueConstructions.ElectricalRoomExteriorWall
    eleExt "Construction describing the exterior walls in the electrical room"
    annotation (Placement(transformation(extent={{430,-210},{450,-190}})));
  replaceable Data.Constructions.OpaqueConstructions.ExteriorDoorUninsulated
    extDooUn "Construction describing the door in the electrical room"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  replaceable Data.Constructions.OpaqueConstructions.ASHRAE901Roof roo
    "Construction describing the roof of the electrical room"
    annotation (Placement(transformation(extent={{430,-148},{450,-128}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for the electrical room connected to test cell 3A in the LBNL User Facility.
  The model is based on 
  <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. The model
  was built using construction and parameter information taken from architectural
  drawings. Other models are provided for the main space of the test cell and the 
  connected closet. Accurate use of this model will likely require the addition of
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A\">
  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A</a> and
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3ACloset\">
  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3ACloset</a>. The documentation
  for these models describes the connecting walls for the spaces, as well as how they
  are intended to be connected. An example of how they can be connected and applied is 
  provided in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>.  
  </p>
  <p>
  Constructions used to describe the walls used in test cell UF90X3A are available in 
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions</a>. All wall 
  construction models are made using information from architectural drawings. Constructions
  used to describe the windows are available in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>. Window models are based on
  information available in the construction specifications.
  </p>  
  <p>
  There are 4 different wall sections described in the model. They are shown in the figure below.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/Rooms/FLEXLAB/Rooms/UF90X3A/UF90X3AElectrical.png\" border=\"1\" alt=\"Wall sections in UF90X3A model\"/>
  </p>
  <p>
  The different wall sections are entered into the model according to the following table.  
  </p>
  <table border=\"1\" summary=\"Description of wall sections in EF90X3AElectrical\">
  <tr>
  <th>Wall Section Number</th>
  <th>Description</th>
  <th>Location in Model</th>
  <th>Corresponding Layer</th>
  </tr>
  <tr>
  <td>1</td>
  <td>North-facing exterior wall</td>
  <td>datConExt[1]</td>
  <td>eleExt</td>
  </tr>
  <tr>
  <td>2</td>
  <td>East-facing air space connecting to UF90X3ACloset</td>
  <td>surBou[2]</td>
  </tr>
  <tr>
  <td>3</td>
  <td>South-facing air space connecting to UF90X3A</td>
  <td>surBou[1]</td>
  </tr>
  <tr>
  <td>4</td>
  <td>West-facing exterior door and wall</td>
  <td>Door: datConExt[3]; Wall: datConExt[2]</td>
  <td>Door: eleExt; Wall: extDooUn</td>
  </tr>
  </table>
  <p>
  An additional surface, not shown on the diagram, is the model of the roof. It is modeled in datConExt[2] using
  the layer <code>roo</code>.
  </p>
  <p>
  Several of the connections in this model are intended to be connected to specific surfaces in other room models.
  The following table describes these connections. The connections in datConExt are not described in the table
  because they are connected to the external environment, and no additional heat port connections are necessary.
  A rationale for why the model is created this way is also provided if it is considered necessary. 
  </p>
  <table border =\"1\" summary = \"Description of intended connections including UF90X3AElectrical model\">
  <tr>
  <th>Location in UF90XAElectrical</th>
  <th>Description of External Connection</th>
  <th>Location in External Model</th>
  <th>Rationale</th>
  </tr>
  <tr>
  <td>surf_surBou[1]</td>
  <td>This is a connection to the wall between UF90X3AElectrical and UF90X3A. This connection port represents an air
  space and the corresponding wall is modeled in UF90X3A.</td>
  <td>UF90X3A.surf_conBou[5]</td>
  <td>This wall is modeled in UF90X3A. surf_surBou[1] in UF90X3AElectrical represents the air gap in the electrical
  room while surf_conBou[5] in UF90X3A represents the wall surface.</td>
  <td></td>
  </tr>
  <tr>
  <td>surf_surBou[2]</td>
  <td>This is a connection to the wall between UF90X3AElectrical and UF90X3ACloset. This connection port represent
  an air space and the corresponding wall is modeled in UF90X3ACloset.</td>
  <td>UF90X3ACloset.surf_conBou[1]</td>
  <td>This wall is modeled in UF90X3ACloset. surf_surBou[2] in UF90X3AElectrical represents the air gap in the
  electrical room while surf_conBou[1] in UF90X3ACloset represents the wall surface.</td>
  <td></td>
  </tr>
  </table>
  </html>",
  revisions = "<html>
  <ul>
  <li>July 26, 2013 by Peter Grant:<br/>
  First implementation.</li>
  </ul>
  </html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={
        Bitmap(extent={{-160,164},{162,-166}}, fileName=
              "modelica://Buildings/Resources/Images/Rooms/FLEXLAB/Rooms/icon.png"),
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
          textString="surface")}));
end UF90X3AElectrical;
