within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A;
model ClosetFullBed
  "Model of the closet connected to test cell X3A intended to be connected to ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet"
  extends Buildings.ThermalZones.Detailed.MixedAir(
  hRoo = 3.6576,
  AFlo = 3.93,
  nConExt = 2,
  nConBou = 2,
  nSurBou = 3,
  nConExtWin = 0,
  nConPar = 0,
  surBou(
    A = {3.6576 * 2.886075 - 2.39*1.22, 2.39 * 1.22, 3.6576 * 1.524},
    each absIR = 0.9,
    each absSol = 0.9,
    each til=Buildings.Types.Tilt.Wall),
  datConExt(
    layers = {higIns, roo},
    A = {3.6576 * 1.667, AFlo},
    til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling},
    azi = {Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N}),
  datConBou(
    layers = {higIns, slaCon},
    A = {3.6576*1.524, 3.93},
    til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Floor},
    azi = {Buildings.Types.Azimuth.W, Buildings.Types.Azimuth.N},
    stateAtSurface_a = {true, false}));

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
    This is a duplicate model of <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Closet\">
    Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Closet</a> with the wall separating this model and
    <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet\">
    Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet</a> removed. It is intended for use in simulations
    which include both room models to simulate the whole test bed. If the regular models are used
    the wall separating the closets will be modeled twice, so one model must have the wall removed.
    This documentation only describes the walls and connections which are different from
    <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Closet\">
    Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.Closet</a>. For information on the rest of the walls
    and connections see that documentation.
    </p>
    <p>
    There are four different wall sections connected to the closet modeled here. They are shown
    in the figure below. Only wall section 2 is described in this documentation.
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
    <td>2</td>
    <td>Dividing wall modeled in ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet</td>
    <td>surBou[3]</td>
    </tr>
    </table>
    <p>
    As a result of removing the dividing wall construction, the location of the construction of the floor has changed.
    The following table shows the old and new location of this wall construction.
    </p>
    <table border =\"1\" summary=\"Changes to construction locations\">
    <tr>
    <th>Physical Description</th>
    <th>Location in Closet</th>
    <th>Location in ClosetNoCelDiv</th>
    </tr>
    <tr>
    <td>Construction modeling the floor</td>
    <td>datConBou[3]</td>
    <td>datConBou[2]</td>
    </tr>
    </table>
    <p>
    Several of the connections in this model are intended to be connected to specific surfaces in other room models.
    The following table describes the connections to models outside of the X3A package. The connections in datConExt
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
    <td>surf_surBou[3]</td>
    <td>X3B.Closet</td>
    <td>X3B.Closet.surf_conBou[2]</td>
    <td>X3B.Closet.surf_conBou[2] is the location of the cell dividing wall in the neighboring closet. Connecting
    X3A.ClosetNoCelDiv.surf_surBou[3] to this port models heat transfer from the wall in ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Closet to the air in this
    space.</td>
    </tr>
    </table>
    </html>",
    revisions = "<html>
    <ul>
    <li>Sep 18, 2013 by Peter Grant:<br/>
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
end ClosetFullBed;
