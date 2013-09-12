within Buildings.Rooms.FLEXLAB.Rooms.X3A;
model Electrical "Model of the electrical room attached to test cell X3A"
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
  replaceable
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.Construction3
    eleExt "Construction describing the exterior walls in the electrical room"
    annotation (Placement(transformation(extent={{430,-210},{450,-190}})));
  replaceable
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.ExteriorDoorUninsulated
    extDooUn "Construction describing the door in the electrical room"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  replaceable Data.Constructions.OpaqueConstructions.Roofs.ASHRAE_901_2010Roof
                                                                   roo
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
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.X3A.TestCell\">
  Buildings.Rooms.FLEXLAB.Rooms.X3A.TestCell</a> and
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.X3A.Closet\">
  Buildings.Rooms.FLEXLAB.Rooms.X3A.Closet</a>. The documentation
  for these models describes the connecting walls for the spaces, as well as how they
  are intended to be connected. An example of how they can be connected and applied is 
  provided in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>.  
  </p>
  <p>
  Constructions used to describe the walls used in test cell X3A are available in 
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
  <img src=\"modelica://Buildings/Resources/Images/Rooms/FLEXLAB/Rooms/X3A/Electrical.png\" border=\"1\" alt=\"Wall sections in TestCell model\"/>
  </p>
  <p>
  The different wall sections are entered into the model according to the following table.  
  </p>
  <table border=\"1\" summary=\"Description of wall sections in EF90Electrical\">
  <tr>
  <th>Wall Section Number</th>
  <th>Description</th>
  <th>Location in Model</th>
  <th>Corresponding Layer</th>
  </tr>
  <tr>
  <td>1</td>
  <td>North exterior wall</td>
  <td>datConExt[1]</td>
  <td>eleExt</td>
  </tr>
  <tr>
  <td>2</td>
  <td>East air space connecting to Closet</td>
  <td>surBou[2]</td>
  </tr>
  <tr>
  <td>3</td>
  <td>South air space connecting to TestCell</td>
  <td>surBou[1]</td>
  </tr>
  <tr>
  <td>4</td>
  <td>West exterior door and wall</td>
  <td>Door: datConExt[3]<br/>
  Wall: datConExt[2]</td>
  <td>  Door: eleExt<br/>
  Wall: extDooUn</td>
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
  <table border =\"1\" summary = \"Description of intended connections including Electrical model\">
  <tr>
  <th>Location in Electrical</th>
  <th>Description of External Connection</th>
  <th>Location in External Model</th>
  <th>Rationale</th>
  </tr>
  <tr>
  <td>surf_surBou[1]</td>
  <td>This is a connection to the wall between Electrical and TestCell. This connection port represents an air
  space and the corresponding wall is modeled in TestCell.</td>
  <td>TestCell.surf_conBou[5]</td>
  <td>This wall is modeled in TestCell. surf_surBou[1] in Electrical represents the air gap in the electrical
  room while surf_conBou[5] in TestCell represents the wall surface.</td>
  <td></td>
  </tr>
  <tr>
  <td>surf_surBou[2]</td>
  <td>This is a connection to the wall between Electrical and Closet. This connection port represent
  an air space and the corresponding wall is modeled in Closet.</td>
  <td>Closet.surf_conBou[1]</td>
  <td>This wall is modeled in Closet. surf_surBou[2] in Electrical represents the air gap in the
  electrical room while surf_conBou[1] in Closet represents the wall surface.</td>
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
        Rectangle(
          extent={{-74,-26},{-22,-42}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,12},{-26,-8}},
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
end Electrical;
