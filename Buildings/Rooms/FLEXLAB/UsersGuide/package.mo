within Buildings.Rooms.FLEXLAB;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


  annotation(preferredView="info",
  Documentation(info="<html>
  <p>
  The <code>Buildings.Rooms.FLEXLAB</code> package contains models of rooms, wall constructions, window
  constructions, and examples demonstrating their use. These models are
  created to match the FLEXLAB architectural drawings.
  </p>
  <h4>Use of FLEXLAB models</h4>
  <p>
  FLEXLAB models are made based on architectural drawings of individual
  rooms. The room models are located in the
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms\">
  Buildings.Rooms.FLEXLAB.Rooms</a> package. The intent is that simulations of 
  FLEXLAB test cells are created by connecting the necessary room models 
  for the desired application.
  </p>
  <p>
  The wall and window constructions in the models match the walls
  and windows installed during the intial FLEXLAB construction. The data records for
  walls can be found in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions</a>. The data
  records for glazing systems can be found in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>.
  </p>
  <p>
  One example demonstrating the use of FLEXLAB models is
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>.
  The example  is made assuming that the shading position controls, internal 
  gains, air handlers, and central plant do not need detailed models. Instead it 
  is assumed that experimental data is available and data tables reading that 
  data are used instead.
  </p>
  <p>
  Each room model is made to match architectural drawings. If a construction
  needs to be changed to match an experiment the construction definition
  can be changed in the Parameters window. Sometimes constructions are used
  in multiple walls, so the user must be careful to avoid accidentally 
  changing the construction of more walls than intended. Detailed editing
  of a model may be necessary.
  </p>
  <p>
  All FLEXLAB room models are created by extending the <a href=\"modelica://Buildings.Rooms.MixedAir\">
  Buildings.Rooms.MixedAir</a> model. This model contains several ports which must be used to describe
  the heat transfer into and out of the space. The ports are described both here and in the documentation
  for <a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. The following table
  describes the available ports:
  </p>
  <table border = \"1\" summary=\"Description of ports in FLEXLAB models\">
  <tr>
  <th>Name in icon</th>
  <th>Name of connector</th>
  <th>Physical significance</th>
  </tr>
  <tr>
  <td>u</td>
  <td><code>uSha</code></td>
  <td>Shade control signal.<br/>
  1 = closed shade<br/>
  0 = open shade</td>
  </tr>
  <tr>
  <td>q</td>
  <td><code>qGai_flow</code></td>
  <td>Internal gains vector with elements<br/>
  [1] = Radiant in [W/m<sup>2</sup>] floor area<br/>
  [2] = Convective in [W/m<sup>2</sup>] floor area<br/>
  [3] = Latent in [W/m<sup>2</sup>] floor area</td>
  </tr>
  <tr>
  <td>surface</td>
  <td><code>surf_surBou</code></td>
  <td>Models walls of the room with the construction represented externally. The connection represents heat
  transfer from the surface (represented by a separate model outside of the room model) to the air in the space.
  The air in the space must be described within the room model. An example of this could be a description of the
  floor area within the room model, connected to a model of a radiant slab modeled outside the room model.</td>
  </tr>
  <tr>
  <td>boundary</td>
  <td><code>surf_conBou</code></td>
  <td>Connects to rooms with a shared wall. The wall is modeled in this room, and connects to the air in the other
  room. The area of the air gap in the other room must be described in the other model.</td>
  </tr>
  <tr>
  <td>air</td>
  <td><code>heaPorAir</code></td>
  <td>Heat port connecting directly to the air in the room.</td>
  </tr>
  <tr>
  <td>radiation</td>
  <td><code>heaPorRad</code></td>
  <td>Heat port for radiative heat gain and radiative temperature.</td>
  </tr>
  <tr>
  <td>fluid</td>
  <td><code>ports</code></td>
  <td>Fluid ports that connect to the air volume inside the space.
  These ports are typically used for air conditioning inlets and outlets, and
  for air infiltration when connected to the outside air.
  Note that mass is conserved, hence the thermal zone cannot only have air inflow but
  must also have a means for air to leave the room.</td>
  </tr>
  </table>
  <p>
  For an example demonstrating how many of these ports are used, see 
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>.
  </p>  
  <h4>Future Work</h4>
  <p>
  A list of items which still need to be understood and finalized is below:
  </p>
  <ul>
  <li>Do radiant floors serve the closets and electrical rooms?</li>
  <li>Does HVAC serve the closets and electrical rooms?</li>
  <li>Identify all detailed door constructions when detailed
  specifications are available.</li>
  <li>Use available window information to identify detailed
  model-level window specifications.</li>
  <li>Create FLEXLAB-specific weather data file for 
  taking weather data from the FLEXLAB weather sensors.
  </li>
  <li>The design of the radiant slab is not clearly documented.
  The model of the radiant slab should be carefully checked when
  the design information is available. Specific inputs which
  must be checked include: disPip, m_flow_nominal, iLayPip,
  construction for pipe, fluid flowing through the slab</li>
  <li>Check available air and water flow sensors. The example model
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>
  assumes that several temperature and flow measurements are available.
  Are they? If not, how does the model need to be changed?</li>
  <li>Ventilation assumptions used in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>  
  include zero ACH in the electrical room overnight. Probably not realistic. Electrical
  equipment will need cooling overnight. Try to estimate convective heat gains from
  electrical equipment and identify an air flow rate to keep temperature in space
  realistic.</li>
  <li>The specific construction information for the roofs is not currently available 
  (9/5/13). Roof construction packages in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Data.Constructions\">
  Buildings.Rooms.FLEXLAB.Data.Constructions</a> are based on comments on A2.01 in the
  drawings. These constructions should be revisited when detailed information is
  available. There is currently no construction for test cell UF90XR-B because the
  comment in the drawings merely says \"ANNUAL NET-ZERO\".</li>
  <li>Is east wall of UF90X3B actually made using Construction18? Yes according to
  drawing on A2.03, but Construction18 is typically a cell or bed dividing wall
  and UF90X4 is no longer in construction. Has construction been changed since
  UF90X4 removed from plan?</li>
  </ul>
  </html>"));
end UsersGuide;
