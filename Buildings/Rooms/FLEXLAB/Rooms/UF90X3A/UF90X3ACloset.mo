within Buildings.Rooms.FLEXLAB.Rooms.UF90X3A;
model UF90X3ACloset "Model of the closet connected to test bed UF90X3A"
  extends Buildings.Rooms.MixedAir(
  hRoo = 3.6576,
  AFlo = 3.93,
  lat = 0.66098585832754,
  nConExt = 2,
  nConBou = 2,
  nSurBou = 2,
  nConExtWin = 0,
  nConPar = 0,
  surBou(
    A = {3.6576 * 2.886075 - 2.39*1.22, 2.39 * 1.22},
    each absIR = 0.9,
    each absSol = 0.9,
    each til=Buildings.HeatTransfer.Types.Tilt.Wall),
  datConExt(
    layers = {higIns, roo},
    A = {3.6576 * 1.667, AFlo},
    til = {Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Ceiling},
    azi = {Buildings.HeatTransfer.Types.Azimuth.N, Buildings.HeatTransfer.Types.Azimuth.N}),
  datConBou(
    layers = {higIns, celDiv},
    A = {3.6576*1.524, 3.6576 * 1.524},
    til = {Buildings.HeatTransfer.Types.Tilt.Wall, Buildings.HeatTransfer.Types.Tilt.Wall},
    azi = {Buildings.HeatTransfer.Types.Azimuth.W, Buildings.HeatTransfer.Types.Azimuth.E}));

  replaceable Data.Constructions.OpaqueConstructions.HighInsulExtWall higIns
    "High insulation wall. Between UF90X3A closet and exterior, UF90X3A closet and electricl room"
    annotation (Placement(transformation(extent={{430,-208},{450,-188}})));
  replaceable Data.Constructions.OpaqueConstructions.TestCellDividngWall celDiv
    "Wall dividing the UF90X3A closet and the UF90X3B closet"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  replaceable Data.Constructions.OpaqueConstructions.ASHRAE901Roof roo
    "Construction of the roof of the closet in UF90X3A"
    annotation(Placement(transformation(extent={{430,-148},{450,-128}})));

    annotation (Documentation(info="<html>
    <p>
    This is a model for the closet attached to test cell 3A in the LBNL User Facility. The 
    model is based on <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>.
    The model was built using construction and parameter information taken from architectural
    drawings. Other models are provided for the main space of the test cell and the connected 
    electrical room. Accurate use of this model will likely require the addition of
    <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A\">
    Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3A</a> and
    <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3AElectrical\">
    Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3AElectrical</a>. The documentation
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
    Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>. Window models are 
    based on information available in the construction specifications.    
    </p>
    <p>
    There are four different wall sections connected to the closet modeled here. They are shown
    in the figure below.
    </p>
    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Rooms/FLEXLAB/Rooms/UF90X3A/UF90X3ACloset.png\" border=\"1\" alt=\"Wall sections in UF90X3ACloset model\"/>
    </p>
    <p>
    The different wall sections are represented in the model according to the following table.
    </p>
    <table border = \"1\" summary = \"Wall sections in UF90X3ACloset model\">
    <tr>
    <th>Wall Section Number</th>
    <th>Description</th>
    <th>Location in Model</th>
    <th>Corresponding Layer</th>
    </tr>
    <tr>
    <td>1</td>
    <td>North-facing wall on the exterior of the buildings</td>
    <td>datConExt[1]</td>
    <td>higIns</td>
    </tr>
    <tr>
    <td>2</td>
    <td>East-facing wall connected to UF90X3BCloset</td>
    <td>datConBou[2]</td>
    <td>celDiv</td>
    </tr>
    <tr>
    <td>3</td>
    <td>Air space connected to partition wall and door in UF90X3A model</td>
    <td>Wall: datSurBou[1]; Door: datSurBou[2]</td>
    </tr>    
    <tr>
    <td>4</td>
    <td>West-facing wall connected to UF90X3AElectrical</td>
    <td>datConBou[1]</td>
    <td>higIns</td>
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
    <table border =\"1\" summary=\"Intended connections including the UF90X3ACloset model\">
    <tr>
    <th>Location in UF90X3ACloset</th>
    <th>Description of External Connection</th>
    <th>Location in External Model</th>
    <th>Rationale</th>
    </tr>
    <tr>
    <td>surf_surBou[1]</td>
    <td>UF90X3A partition wall</td>
    <td>UF90X3A.surf_conBou[3]</td>
    <td>This wall is modeled in the UF90X3A model. surf_surBou[1] in UF90X3ACloset represents the corresponding air
    space on the closet side of the wall.</td>
    </tr>
    <tr>
    <td>surf_surBou[2]</td>
    <td>UF90X3A partition door</td>
    <td>UF90X3A.surf_conBou[4]</td>
    <td>This wall is modeled in the UF90X3A model. surf_surBou[2] in UF90X3ACloset represents the corresponding air
    space on the closet side of the door.</td>
    </tr>
    <tr>
    <td>surf_conBou[1]</td>
    <td>Insulated wall between the closet and UF90X3AElectrical</td>
    <td>UF90X3AElectrical.surf_surBou[2]</td>
    <td></td>
    </tr>
    <tr>
    <td>surf_conBou[2]</td>
    <td>UF90X3BCloset</td>
    <td>References a data table</td>
    <td>A data table is used, instead of a model of UF90X3BCloset, because the goal of this model is to be able to perform
    simulations of UF90X3A with minimal complexity, by simplifying the neighboring test cells. The wall separating the
    test cells is highly insulated, and it is believed that the error in simulations caused by using a data table will
    be negligible.</td>
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
end UF90X3ACloset;
