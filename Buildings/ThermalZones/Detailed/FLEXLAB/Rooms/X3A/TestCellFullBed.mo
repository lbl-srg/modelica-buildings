within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A;
model TestCellFullBed
  "Model of LBNL User Test Facility Cell X3A intended for connection with ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell"
  extends Buildings.ThermalZones.Detailed.MixedAir(AFlo=60.97,
      nSurBou=5,
      nConPar=0,
      nConBou=4,
      nConExt=4,
      nConExtWin=1,
      hRoo=3.6576,
      surBou(
        A = {6.645*3.09, 6.645*1.51, 6.645*0.91, 6.645*3.65, 3.6575 * 9.144},
        each absIR=0.9,
        each absSol=0.9,
        til={Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Wall}),
      datConExt(
         layers={extDoo,
         R16p8Wal,
         R20Wal,
         bedDiv},
         A={1.3716 * 2.39, 3.6576*2.52-2.39*1.3716, 6.6675*9.144, 3.6576 * 1.524},
         til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling, Buildings.Types.Tilt.Wall},
         azi={Buildings.Types.Azimuth.N,Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.S, Buildings.Types.Azimuth.W}),
      datConBou(
         layers = {bedDiv, parCon, parDoo, R52Wal},
         A = {3.6576 * 7.62, 3.6576*2.886075-2.39*1.22, 2.39*1.22, 3.6576*1.2614},
         til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall},
         azi = {Buildings.Types.Azimuth.W, Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N},
         stateAtSurface_a = {false, true, true, true}),
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
  This is a duplicate model of <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell\">
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell</a> with the wall separating X3A and X3B removed.
  It is designed for simulations where both X3A and X3B are used in the simulation to model the
  whole test bed. If a simulation is created using TestCell from both packages the dividing wall
  will be modeled twice, so one of the two models used must be created without the dividing wall
  in the model.
  </p>
  <p>
  This documentation states only the items which are different from the
  <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell\">
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell</a> model. For documentation on the rest of the
  walls and connections see that documentation instead.
  </p>
  <p>
  There are 7 different wall sections described in the model. They are shown in the figure below.
  This documentation only describes wall section 6.
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
  <td>6</td>
  <td>This east wall connects to test cell X3B. This model contains an air gap instead of a model
  of the wall. It is intended to be connected to the wall model in X3B.</td>
  <td>surBou[2]</td>
  <td></td>
  </tr>
  </table>
  <p>
  Because wall section 6 was moved from datConBou[2] to surBou[2] the reference for other constructions in
  datConBou have changed as well. These changes are documented in the following table.
  </p>
  <table border =\"1\" summary=\"Description of changes to construction locations\">
  <tr>
  <th>Wall Section Number</th>
  <th>Physical Description</th>
  <th>Location in TestCell</th>
  <th>Location in TestCelNoDiv</th>
  </tr>
  <tr>
  <td>4</td>
  <td>Insulated wall separating the test cell and the electrical room</td>
  <td>datConBou[5]</td>
  <td>datConBou[4]</td>
  </tr>
  <tr>
  <td>5</td>
  <td>Partition wall and door separating the test cell and the closet</td>
  <td>Wall: datConBou[3]<br/>
  Door: datConBou[4]</td>
  <td>Wall: datConBou[2]<br/>
  Door: datConBou[3]</td>
  </tr>
  </table>
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
  <td>surf_surBou[2]</td>
  <td>Dividing wall modeled in ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell</td>
  <td>X3B.TestCell.surf_conBou[1]</td>
  <td>X3B.TestCell.surf_conBou[1] is the location of the cell dividing wall in the neighboring test cell. Connecting
  X3A.TestCellNoCelDiv.surf_surBou[2] to this port models heat transfer from the wall in ThermalZones.Detailed.FLEXLAB.Rooms.X3B.TestCell to the air in this
  space.</td>
  </tr>
  </table>
  </html>",
  revisions = "<html>
  <ul>
  <li>Sept 18, 2013 by Peter Grant:<br/>
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
end TestCellFullBed;
