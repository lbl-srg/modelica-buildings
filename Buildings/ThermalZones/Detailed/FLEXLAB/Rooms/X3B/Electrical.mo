within Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B;
model Electrical "Model of the electrical room attached to test cell X3A"
  extends Buildings.ThermalZones.Detailed.MixedAir(
  hRoo = 3.6576,
  AFlo = 2.39,
  lat = 0.66098585832754,
  nSurBou = 2,
  nConExt=4,
  nConExtWin=0,
  nConPar=0,
  nConBou=1,
  surBou(
    A = {3.6576 * 1.2641, 3.6576 * 1.524},
    each absIR = 0.9,
    each absSol = 0.9,
    each til = Buildings.Types.Tilt.Wall),
  datConExt(
    layers = {eleExt, eleExt, extDooUn, roo},
    A = {3.6576 * 1.26413, 3.6576 * 1.524 - 2.38658 * 1.524, 2.38658*1.524, 2.39},
    til = {Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Ceiling},
    azi = {Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.N}),
   datConBou(
     layers = {slaCon},
     A = {2.39},
     til = {Buildings.Types.Tilt.Floor},
     azi = {Buildings.Types.Azimuth.N},
     stateAtSurface_a = {false}));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.Construction3
    eleExt "Construction describing the exterior walls in the electrical room"
    annotation (Placement(transformation(extent={{430,-210},{450,-190}})));
  replaceable parameter
    Data.Constructions.OpaqueConstructions.ExteriorConstructions.ExteriorDoorUninsulated
    extDooUn "Construction describing the door in the electrical room"
    annotation (Placement(transformation(extent={{430,-178},{450,-158}})));
  replaceable parameter Data.Constructions.OpaqueConstructions.Roofs.ASHRAE_901_2010Roof
                                                                   roo
    "Construction describing the roof of the electrical room"
    annotation (Placement(transformation(extent={{430,-148},{450,-128}})));

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
    annotation (Placement(transformation(extent={{428,-118},{448,-98}})));
  annotation(Documentation(info="<html>
  <p>
  This is a model for the electrical room connected to test cell 3B in the LBNL User Facility.
  Other models are provided for the main space of the test cell and the connected closet. This
  documentation describes the wall constructions used in the electrical room model. For
  documentation describing how the room models are to be connected to develop a model of the
  entire X3B test cell see
  <a href=\"modelica://Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B\">
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B</a>.
  </p>
  <p>
  There are 4 different wall sections described in the model. They are shown in the figure below.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/FLEXLAB/Rooms/X3B/Electrical.png\" border=\"1\" alt=\"Wall sections in TestCell model\"/>
  </p>
  <p>
  The different wall sections are entered into the model according to the following table.
  </p>
  <table border=\"1\" summary=\"Description of wall sections in Electrical\">
  <tr>
  <th>Wall Section Number</th>
  <th>Description</th>
  <th>Location in Model</th>
  <th>Corresponding Layer</th>
  </tr>
  <tr>
  <td>1</td>
  <td>South air space connecting to TestCell</td>
  <td>surBou[1]</td>
  </tr>
  <tr>
  <td>2</td>
  <td>West air space connecting to Closet</td>
  <td>surBou[2]</td>
  </tr>
  <tr>
  <td>3</td>
  <td>North exterior wall</td>
  <td>datConExt[1]</td>
  <td>eleExt</td>
  </tr>
  <tr>
  <td>4</td>
  <td>East exterior door and wall</td>
  <td>  Wall: datConExt[2]<br/>
  Door: datConExt[3]</td>
  <td>  Wall: eleExt<br/>
  Door: extDooUn</td>
  </tr>
  </table>
  <p>
  There are two additional surfaces which are not included in the diagram. One is the model of the roof. It is
  modeled in datConExt[4] using the layer <code>roo</code>. The other is the floor, which is modeled in
  datConBou[1] using the layer <code>slaCon</code>.
  </p>
  <p>
  Several of the connections in this model are intended to be connected to specific surfaces in other room models.
  The following table describes the connections to rooms which are not in the X3B package. The constructions in
  datConExt are not described in the table because they are connected to the external environment, and no
  additional heat port connections are necessary. A rationale for why the model is created this way is also
  provided if it is considered necessary.
  </p>
  <table border =\"1\" summary = \"Description of intended connections including Electrical model\">
  <tr>
  <th>Location in Electrical</th>
  <th>Description of External Connection</th>
  <th>Rationale</th>
  </tr>
  <tr>
  <td>surf_conBou[1]</td>
  <td>Connection to ground temperature model</td>
  <td>This port represents the bottom of the floor in the space. It is to be connected to a heat port representing
  the temperature of the ground.</td>
  </tr>
  </table>
  </html>",
  revisions = "<html>
  <ul>
  <li>Setp 16, 2013 by Peter Grant:<br/>
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
