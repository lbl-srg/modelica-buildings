within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A;
model TestCell "Model of LBNL User Test Facility Cell X3A"
  extends Buildings.ThermalZones.Detailed.MixedAir(AFlo=60.97,
      nSurBou=4,
      nConPar=0,
      nConBou=5,
      nConExt=4,
      nConExtWin=1,
      hRoo=3.6576,
      surBou(
        A = {6.645*3.09, 6.645*1.51, 6.645*0.91, 6.645*3.65},
        each absIR=0.9,
        each absSol=0.9,
        each til=Buildings.Types.Tilt.Floor),
      datConExt(
         layers={extDoo,
         R16p8Wal,
         R20Wal,
         bedDiv},
         A={1.3716 * 2.39, 3.6576*2.52-2.39*1.3716, 6.6675*9.144, 3.6576 * 1.524},
         til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling, Buildings.Types.Tilt.Wall},
         azi={Buildings.Types.Azimuth.N,Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.S, Buildings.Types.Azimuth.W}),
      datConBou(
         layers = {bedDiv,celDiv, parCon, parDoo, R52Wal},
         A = {3.6576 * 7.62, 3.6576 * 9.144, 3.6576*2.886075-2.39*1.22, 2.39*1.22, 3.6576*1.2614},
         til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall},
         azi = {Buildings.Types.Azimuth.W, Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N},
         stateAtSurface_a = {false, false, true, true, true}),
      datConExtWin(
        layers={R16p8Wal},
        A={6.6675*3.6576},
        glaSys={glaSys},
        hWin={1.8288},
        wWin={5.88},
        til={Buildings.Types.Tilt.Wall},
        azi={Buildings.Types.Azimuth.S}),
      intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
      extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind);

  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.Construction10and23
                                                                     R16p8Wal
    annotation (Placement(transformation(extent={{410,-168},{430,-148}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.CellAndElectricalDividingWall
                                                                      R52Wal
    annotation (Placement(transformation(extent={{410,-192},{430,-172}})));
  replaceable parameter Data.Constructions.OpaqueConstructions.Roofs.ASHRAE_901_2010Roof
                                                                   R20Wal
    annotation (Placement(transformation(extent={{410,-216},{430,-196}})));
  replaceable parameter Data.Constructions.GlazingSystems.ASHRAE901Gla glaSys
    annotation (Placement(transformation(extent={{436,-192},{456,-172}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.PartitionConstructions.PartitionWall
    parCon
    annotation (Placement(transformation(extent={{436,-216},{456,-196}})));

  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.TestCellDividngWall
                                                                         celDiv
    "Construction of wall connecting to cell UF90X3B"
    annotation (Placement(transformation(extent={{410,-144},{430,-124}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.TestBedDividingWall
                                                                         bedDiv
    "Construction of wall connecting to cell UF90X2B"
    annotation (Placement(transformation(extent={{410,-120},{430,-100}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.PartitionConstructions.PartitionDoor
                                                                   parDoo
    "Door used in partition walls in FLEXLAB test cells"
    annotation (Placement(transformation(extent={{410,-96},{430,-76}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.ExteriorDoorInsulated
    extDoo "Construction of an exterior door"
    annotation (Placement(transformation(extent={{410,-72},{430,-52}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for test cell 3A in the LBNL User Facility. This model is intended to represent
  the main space in test cell 3A. This documentation describes the wall constructions used to model
  test cell X3A. Documentation describing how it is to be combined to other room models to create
  a model of the full test cell can be found in
  <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A\">Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A</a>.
  </p>
  <p>
  There are 7 different wall sections described in the model. They are shown in the figure below.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/X3A/TestCell.png\" border=\"1\" alt=\"Wall sections in test cell model\"/>
  </p>
  <p>
  The different wall sections are entered into the model according to the following table.
  </p>
  <table border = \"1\" summary=\"Description of walls in test cell room model\">
  <tr>
  <th>Wall Section Number</th>
  <th>Description</th>
  <th>Location in Model</th>
  <th>Corresponding Layer</th>
  </tr>
  <tr>
  <td>1</td>
  <td>The west wall is modeled in two parts. One part represents the dividing wall between test cells X3A
  and X2B. The other part represents a portion of the wall exposed to the ambient conditions. Wall
  1 is the section of wall connected to test cell X2B.</td>
  <td>datConBou[1]</td>
  <td>bedDiv</td>
  </tr>
  <tr>
  <td>2</td>
  <td>The west wall is modeled in two parts. One part represents the dividing wall between test cell X3A
  and test cell X2B. The other part represents a portion of the wall exposed to the ambient conditions. Wall
  2 is the section of wall exposed to ambient conditions.</td>
  <td>datConExt[4]</td>
  <td>bedDiv</td>
  </tr>
  <tr>
  <td>3</td>
  <td>This is the north exterior wall of test cell X3A. There are actually two constructions
  used here. One construction models the wall, the other construction models a door. The area
  calculation for the wall in the model shows the calculation of the total wall area minus the door area.</td>
  <td>Door: datConExt[1]; Wall: datConExt[2]</td>
  <td>Door: extDoo; Wall: R16p8Wal</td>
  </tr>
  <tr>
  <td>4</td>
  <td>This north wall borders an electrical room. It models the heat transfer between test cell
  X3A and the externally modeled electrical room. For an example see
  <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>.</td>
  <td>datConBou[5]</td>
  <td>R52Wal</td>
  </tr>
  <tr>
  <td>5</td>
  <td>This north wall borders an externally modeled closet. For an example see
  <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>. Similar to wall section
  3 this wall section contains both a wall construction and a door construction. The wall area
  calculation shows the total wall area minus the door area.</td>
  <td>Door: datConBou[4]; Wall: datConBou[3]</td>
  <td>Door: parDoo; Wall: parCon</td>
  </tr>
  <tr>
  <td>6</td>
  <td>This east wall connects to test cell UF90X3B. This wall is removable, but this model was
  developed assuming that the wall is installed.</td>
  <td>datConBou[2]</td>
  <td>celDiv</td>
  </tr>
  <tr>
  <td>7</td>
  <td>This is the south wall of test cell X3A. It includes both a wall construction and
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
  The test cell can be configured with several different floor types. The options include radiant conditioning,
  a slab on grade floor with no conditioning, or a raised floor. Because of this uncertainty in floor design, a
  model of the floor itself is not included in this model. The user must include a model for the floor in any
  applications of this model.
  </p>
  <p>
  Several of the connections in this model are intended to be connected to specific surfaces in other room models.
  The following table describes the connections to models outside of the X3A package. The connections in datConExt
  are not described in the table because they are connected to the external environment, and no additional heat
  port connections are necessary. A rationale for why the model is created this way is also provided if it is
  considered necessary.
  </p>
  <table border =\"1\" summary=\"Description of intended connections including TestCell model\">
  <tr>
  <th>Location in TestCell</th>
  <th>Description of External Connection</th>
  <th>Location in External Model</th>
  <th>Rationale</th>
  </tr>
  <tr>
  <td>surf_conBou[1]</td>
  <td>Temperature of test cell X2B</td>
  <td>References a data table</td>
  <td>A data table is used, instead of a model of test cell X2B, because the goal of this model is to be able to perform
  simulations of TestCell with minimal complexity, by simplifying the neighboring test cells. The wall separating the
  test beds is highly insulated, and it is believed that the error in simulations caused by using a data table will
  be negligible.</td>
  </tr>
  <tr>
  <td>surf_conBou[2]</td>
  <td>Temperature of test cell X3B</td>
  <td>References a data table</td>
  <td>See rationale for surf_ConBou[1]</td>
  </tr>
  </table>
  </html>",
  revisions = "<html>
  <ul>
  <li>Jun 10, 2013 by Peter Grant:<br/>
  First implementation.</li>
  </ul>
  </html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},
            {200,200}}),       graphics={
        Bitmap(extent={{-160,164},{162,-166}}, fileName=
              "modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/icon.png"),
                Rectangle(
          extent={{-58,12},{-26,-8}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,-26},{-22,-42}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
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
        Text(
          extent={{-60,12},{-22,-10}},
          textColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="air"),
        Text(
          extent={{-72,-22},{-22,-50}},
          textColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="radiation"),
        Text(
          extent={{-104,-124},{-54,-152}},
          textColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="surface"),
        Text(
          extent={{-138,-82},{-96,-100}},
          textColor={0,0,0},
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          textString="fluid")}));
end TestCell;
