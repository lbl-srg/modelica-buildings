within Buildings.Rooms.FLEXLAB.Rooms.UF90X3A;
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
         layers = {bedDiv,celDiv, parCon, parDoo, R52Wal},
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

  replaceable Data.Constructions.OpaqueConstructions.ModInsulExtWall R16p8Wal
    annotation (Placement(transformation(extent={{410,-168},{430,-148}})));
  replaceable Data.Constructions.OpaqueConstructions.HighInsulExtWall R52Wal
    annotation (Placement(transformation(extent={{410,-192},{430,-172}})));
  replaceable Data.Constructions.OpaqueConstructions.ASHRAE901Roof R20Wal
    annotation (Placement(transformation(extent={{410,-216},{430,-196}})));
  replaceable Data.Constructions.GlazingSystems.ASHRAE901Gla glaSys
    annotation (Placement(transformation(extent={{436,-192},{456,-172}})));
  replaceable Data.Constructions.OpaqueConstructions.PartitionWall
    parCon
    annotation (Placement(transformation(extent={{436,-216},{456,-196}})));

  replaceable Data.Constructions.OpaqueConstructions.TestCellDividngWall celDiv
    "Construction of wall connecting to cell UF90X3B"
    annotation (Placement(transformation(extent={{410,-144},{430,-124}})));
  replaceable Data.Constructions.OpaqueConstructions.TestBedDividingWall bedDiv
    "Construction of wall connecting to cell UF90X2B"
    annotation (Placement(transformation(extent={{410,-120},{430,-100}})));
  replaceable Data.Constructions.OpaqueConstructions.PartitionDoor parDoo
    "Door used in partition walls in FLEXLAB test cells"
    annotation (Placement(transformation(extent={{410,-96},{430,-76}})));
  replaceable Data.Constructions.OpaqueConstructions.ExteriorDoorInsulated
    extDoo "Construction of an exterior door"
    annotation (Placement(transformation(extent={{410,-72},{430,-52}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for test cell 3A in the LBNL User Facility. The model is based on 
  <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. Appropriate
  condstructions and parameters have been used to describe the test cell. This model is 
  intended to represent the main space in test cell 3A. Other models are provided for
  adjacent rooms. Accurate use of this model will likely require the addition of
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3ACloset\">
  Buildings.Rooms.FLEXLAB.Rooms.UF90X3A.UF90X3ACloset</a> and
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
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Constructions.OpaqueConstructions\">
  Buildings.Rooms.FLEXLAB.Constructions.OpaqueConstructions</a>. All wall 
  construction models are made using information from architectural drawings. Constructions
  used to describe the windows are available in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>. Window models are based on
  information available in the construction specifications.
  </p>
  <p>
  This model assumes that the removable wall between cells A and B is installed.
  </p>
  <p>
  There are 7 different wall sections described in the model. They are shown in the figure below.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/Rooms.FLEXLAB/Rooms/UF90X3A/UF90X3A.png\" border=\"1\" alt=\"Wall sections in UF90X3A model\"/>
  </p>  
  <p>
  The different wall sections are entered into the model according to the following table.
  </p>
  <table border = \"1\">
  <tr>
  <th>Wall Section Number</th>
  <th>Description</th>
  <th>Location in Model</th>
  <th>Corresponding Layer</th>
  </tr>
  <tr>
  <td>1</td>
  <td>This East facing wall is the dividing wall between test cell UF90X2B and UF90X3A. It extends
  from the South wall to the North end of UF90X3B.</td>
  <td>datConBou[1]</td>
  <td>bedDiv</td>
  </tr>
  <tr>
  <td>2</td>
  <td>The wall in section 1 extends beyond the North end of test cell UF90X2B. This section is the
  same wall construction connected to the outdoor environment.</td>
  <td>datConExt[4]</td>
  <td>bedDiv</td>
  </tr>
  <tr>
  <td>3</td>
  <td>This is the north facing exterior wall of test cell UF90X3A. There are actually two constructions
  used here. One construction models the wall, the other construction models a door. The area
  calculation for the wall in the model shows the calculation of the total wall area minus the door area.</td>
  <td>Door: datConExt[1]; Wall: datConExt[2]</td>
  <td>Door: extDoo; Wall: R16p8Wal</td>
  </tr>
  <tr>
  <td>4</td>
  <td>This north-facing wall borders an electrical room. It models the heat transfer between test cell
  UF90X3A and the externally modeled electrical room. For an example see
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>.</td>
  <td>datConBou[5]</td>
  <td>R52Wal</td>
  </tr>
  <tr>
  <td>5</td>
  <td>This north facing wall borders an externally modeled closet. For an example see 
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Cells.Examples.UF90X3AWithRadiantFloor</a>. Similar to wall section 
  3 this wall section contains both a wall construction and a door construction. The wall area
  calculation shows the total wall area minus the door area.</td>
  <td>Door: datConBou[4]; Wall: datConBou[3]</td>
  <td>Door: parDoo; Wall: parCon</td>
  </tr>
  <tr>
  <td>6</td>
  <td>This West facing wall connects to test cell UF90X3B.</td>
  <td>datConBou[2]</td>
  <td>celDiv</td>
  </tr>
  <tr>
  <td>7</td>
  <td>This is the South facing wall of test cell UF90X3A. It includes both a wall construction and 
  windows. The bottoms of the windows are 3 ft above the floor.</td>
  <td>datConExtWin[1]</td>
  <td>Window: glaSys; Wall: R16p8Wal</td>
  </tr>
  </table>
  <p>
  An eigth construction, not shown in the figure, models the ceiling. It is modeled in datConExt[3] using
  the layer <code>R20Wal</code>.
  </p>
  <p>
  Several of the connections in this model are intended to be connected to specific surfaces in other room models.
  The following table describes these connections. The connections in datConExt are not described in the table
  because they are connected to the external environment, and no additional heat port connections are necessary.
  A rationale for why the model is created this way is also provided if it is considered necessary.
  </p>
  <table border =\"1\">
  <tr>
  <th>Location in UF90X3A</th>
  <th>Description of External Connection</th>
  <th>Location in External Model</th>
  <th>Rationale</th>
  </tr>
  <tr>
  <td>surf_ConBou[1]</td>
  <td>Temperature of UF90X2B</td>
  <td>References a data table</td>
  <td>A data table is used, instead of a model of UF90X2B, because the goal of this model is to be able to perform
  simulations of UF90X3A with minimal complexity, by simplifying the neighboring test cells. The wall separating the
  test beds is highly insulated, and it is believed that the error in simulations caused by using a data table will
  be negligible.</td>
  </tr>
  <tr>
  <td>surf_ConBou[2]</td>
  <td>Temperature of UF90X3A</td>
  <td>References a data table</td>
  <td>See rationale for surf_ConBou[1]</td>
  </tr>  
  <tr>
  <td>surf_conBou[3]</td>
  <td>Closet</td>
  <td>UF90X3ACloset.surf_surBou[1]</td>
  <td>The closet is modeled as a separate room under the assumption that the door will be closed, and air exchange
  between the two spaces will be minimal.</td>
  </tr>
  <tr>
  <td>surf_ConBou[4]</td>
  <td>Closet</td>
  <td>UF90X3ACloset.surf_surBou[2]</td>
  <td>See rationale for surf_ConBou[3]</td>
  </tr>
  <tr>
  <td>surf_ConBou[5]</td>
  <td>Electrical room</td>
  <td>UF90X3AElectrical.surf_SurBou[2]</td>
  </tr>  
  </table> 
  </html>",
  revisions = "<html>
  <ul>
  <li>Jun 10, 2013 by Peter Grant:<br>
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
end UF90X3A;
