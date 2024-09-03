within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A;
model Closet "Model of the closet connected to test cell X3A"
  extends Buildings.ThermalZones.Detailed.MixedAir(
  hRoo = 3.6576,
  AFlo = 3.93,
  nConExt = 2,
  nConBou = 3,
  nSurBou = 2,
  nConExtWin = 0,
  nConPar = 0,
  surBou(
    A = {3.6576 * 2.886075 - 2.39*1.22, 2.39 * 1.22},
    each absIR = 0.9,
    each absSol = 0.9,
    each til=Buildings.Types.Tilt.Wall),
  datConExt(
    layers = {higIns, roo},
    A = {3.6576 * 1.667, AFlo},
    til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling},
    azi = {Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N}),
  datConBou(
    layers = {higIns, celDiv, slaCon},
    A = {3.6576*1.524, 3.6576 * 1.524, 3.93},
    til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Floor},
    azi = {Buildings.Types.Azimuth.W, Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.N},
    stateAtSurface_a = {true, false, false}));

  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.CellAndElectricalDividingWall
                                                                      higIns
    "High insulation wall. Between X3A closet and exterior, X3A closet and electrical room"
    annotation (Placement(transformation(extent={{430,-208},{450,-188}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.DividingWalls.TestCellDividngWall
                                                                         celDiv
    "Wall dividing the X3A closet and the X3B closet"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  replaceable parameter Data.Constructions.OpaqueConstructions.Roofs.ASHRAE_901_2010Roof
                                                                   roo
    "Construction of the roof of the closet in X3A"
    annotation(Placement(transformation(extent={{430,-148},{450,-128}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic
    slaCon(nLay=3, material={
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1524,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.127,
        k=0.036,
        c=1200,
        d=40),
      Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)}) "Construction of the slab"
    annotation (Placement(transformation(extent={{432,-118},{452,-98}})));
    annotation (Documentation(info="<html>
    <p>
    This is a model for the closet attached to test cell 3A in the LBNL User Facility.
    This documentation describes the wall constructions used in the closet. Documentation
    describing how it should be connected to other models in the package to form a
    complete model of test cell X3A can be found in
    <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A\">
    Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A</a>.
    </p>
    <p>
    There are four different wall sections connected to the closet modeled here. They are shown
    in the figure below.
    </p>
    <p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/X3A/Closet.png\" border=\"1\" alt=\"Wall sections in Closet model\"/>
    </p>
    <p>
    The different wall sections are represented in the model according to the following table.
    </p>
    <table border = \"1\" summary = \"Wall sections in Closet model\">
    <tr>
    <th>Wall Section Number</th>
    <th>Description</th>
    <th>Location in Model</th>
    <th>Corresponding Layer</th>
    </tr>
    <tr>
    <td>1</td>
    <td>North wall on the exterior of the buildings</td>
    <td>datConExt[1]</td>
    <td>higIns</td>
    </tr>
    <tr>
    <td>2</td>
    <td>East wall connected to ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet</td>
    <td>datConBou[2]</td>
    <td>celDiv</td>
    </tr>
    <tr>
    <td>3</td>
    <td>Air space connected to partition wall and door in TestCell model</td>
    <td>Wall: datSurBou[1]<br/>
    Door: datSurBou[2]</td>
    </tr>
    <tr>
    <td>4</td>
    <td>West wall connected to Electrical</td>
    <td>datConBou[1]</td>
    <td>higIns</td>
    </tr>
    </table>
    <p>
    There are two additional surfaces which are not included in the diagram. One is the model of the roof. It is
    modeled in datConExt[2] using the layer <code>roo</code>. The other is the floor, which is modeled in
    datConBou[1] using the layer <code>slaCon</code>.
    </p>
    <p>
    Several of the connections in this model are intended to be connected to specific surfaces in other room models.
    The following table describes the connections to models outside of the X3A package.. The connections in datConExt
    are not described in the table because they are connected to the external environment, and no additional heat
    port connections are necessary. A rationale for why the model is created this way is also provided if it is
    considered necessary.
    </p>
    <table border =\"1\" summary=\"Intended connections including the Closet model\">
    <tr>
    <th>Location in Closet</th>
    <th>Description of External Connection</th>
    <th>Location in External Model</th>
    <th>Rationale</th>
    </tr>
    <tr>
    <td>surf_conBou[2]</td>
    <td>X3B.Closet</td>
    <td>References a data table</td>
    <td>A data table is used, instead of a model of ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet, because the goal of this model is to be able to perform
    simulations of TestCell with minimal complexity, by simplifying the neighboring test cells. The wall separating the
    test cells is highly insulated, and it is believed that the error in simulations caused by using a data table will
    be negligible.</td>
    </tr>
    <tr>
    <td>surf_conBou[3]</td>
    <td>Ground temperature</td>
    <td></td>
    <td>There is no specific connection which is appropriate connection for this construction. surf_conBou[3] represents
    the floor of the room, and must be connected to a heat port representing the ground temperature.</td>
    </tr>
    </table>
    </html>",
    revisions = "<html>
    <ul>
    <li>Sept 16, 2013 by Peter Grant:<br/>
    Added a model representing the floor.</li>
    <li>July 26, 2013 by Peter Grant:<br/>
    First implementation.</li>
    </ul>
    </html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={
        Bitmap(extent={{-160,164},{162,-166}}, fileName=
              "modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/icon.png"),
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
end Closet;
