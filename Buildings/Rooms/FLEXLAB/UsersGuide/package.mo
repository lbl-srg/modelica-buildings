within Buildings.Rooms.FLEXLAB;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


  annotation(Documentation(info="<html>
  <p>
  The FLEXLAB package contains models of rooms, wall constructions, window
  constructions, and examples demonstrating their use. These models are
  created to match the FLEXLAB architectural drawings.
  </p>
  <h4>Use of FLEXLAB models</h4>
  <p>
  Models for FLEXLAB are made based on architectural drawings of individual
  rooms. The room models are located in the
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms\">
  Buildings.Rooms.FLEXLAB.Rooms</a> package. The intent is that simulations of 
  FLEXLAB test cells are created by connecting the necessary room models 
  for the desired application.
  </p>
  <p>
  The wall and window constructions in the models match the walls
  and windows installed during the intial FLEXLAB construction. The data records for
  walls can be found in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions</a>. The data
  records for glazing systems can be found in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>.
  </p>
  <p>
  The example of a FLEXLAB simulation is made assuming that the shading position
  controls, internal gains, air handlers, and central plant do not need
  detailed models. Instead it is assumed that experimental data is available
  and data tables reading that data are used instead. An example simulation
  using FLEXLAB models is located in the
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples</a>.
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
  All FLEXLAB room models are created by extending the <a href=\"modelica:Buildings.Rooms.MixedAir\">
  Buildings.Rooms.MixedAir</a> model. This model contains several ports which must be used to describe
  the heat transfer into and out of the space. The ports are described both here and in the documentation
  for <a href=\"modelica:Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>. The following table
  describes the available ports:
  </p>
  <table border = \"1\" summary=\"Description of ports in FLEXLAB models\">
  <tr>
  <th>Name in image</th>
  <th>Connection port name</th>
  <th>Physical significance</th>
  </tr>
  <tr>
  <td>u</td>
  <td>qGai_flow</td>
  <td>Shade control signal.<br/>
  1 = closed shade<br/>
  0 = open shade</td>
  </tr>
  <tr>
  <td>q</td>
  <td>qGai_flow</td>
  <td>Internal gains matrix<br/>
  [1] = Radiant<br/>
  [2] = Convective<br/>
  [3] = Latent</td>
  </tr>
  <tr>
  <td>surface</td>
  <td>surf_surBou</td>
  <td>Models walls of the room with the construction represented externally. The connection represents heat
  transfer from the surface (represented by a separate model outside of the room model) to the air in the space.
  The air in the space must be described within the room model. An example of this could be a description of the
  floor area within the room model, connected to a model of a radiant slab modeled outside the room model.</td>
  </tr>
  <tr>
  <td>boundary</td>
  <td>surf_conBou</td>
  <td>Connects to rooms with a shared wall. The wall is modeled in this room, and connects to the air in the other
  room. The area of the air gap in the other room must be described in the other model.</td>
  </tr>
  <tr>
  <td>air</td>
  <td>heaPorAir</td>
  <td>Heat port connecting directly to the air in the room</td>
  </tr>
  <tr>
  <td>radiation</td>
  <td>heaPorRad</td>
  <td>Heat port for radiative heat gain and radiative temperature</td>
  </tr>
  <tr>
  <td></td>
  <td>ports</td>
  <td>Fluid ports representing air flow in the space. These ports are typically used for ventilation and 
  conditioning air. Connections must include both an inlet and outlet port.</td>
  </tr>
  </table>
  <p>
  For an example demonstrating how many of these ports are used see 
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>.
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
  model-level window specifications - recommended to speak
  with Christian Kohler (sp?).</li>
  <li>Create FLEXLAB-specific weather data file for 
  taking weather data from the FLEXLAB weather sensors (May be 
  able to use python script to read data, pass into standard 
  weather data reader inputs). See e-mail from Cindy Regnier
  on Aug 6, attachment
  \"110612-Baseline Measurement and Instrumentation Set v26.pdf\"
  for information on available sensors.</li>
  <li>The design of the radiant slab is still poorly defined.
  The model of the radiant slab should be carefully checked when
  the design information is available. Specific inputs which
  must be checked include: disPip, m_flow_nominal, iLayPip,
  construction for pipe, fluid flowing through the slab</li>
  <li>Check available air and water flow sensors. The example model
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>
  assumes that several temperature and flow measurements are available.
  Are they? If not, how does the model need to be changed?</li>
  <li>Ventilation assumptions used in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.UF90X3AWithRadiantFloor</a>  
  include 0 ACH in the electrical room overnight. Probably not realistic. Electrical
  equipment will need cooling overnight. Try to estimate convective heat gains from
  electrical equipment and identify an air flow rate to keep temperature in space
  realistic.</li>  
  </ul>
  </html>"));
end UsersGuide;
