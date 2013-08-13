within Buildings.Rooms.FLEXLAB;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


  annotation(Documentation(info="<html>
  <p>
  The FLEXLAB package contains models of rooms, wall constructions, window
  constructions and examples demonstrating their use. These models are
  created to match the FLEXLAB architectural drawings.
  </p>
  <h4>Use of FLEXLAB models</h4>
  <p>
  Models for FLEXLAB are made based on architectural drawings of individual
  rooms. The room models are located in the
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms\">
  Buildings.Rooms.FLEXLAB.Rooms</a> package. The intent that is simulations of 
  FLEXLAB test cells are created by connecting the necessary room models 
  for the desired applications.
  </p>
  <p>
  The wall and window constructions in the models match the installed walls
  and windows during the intial FLEXLAB construction. The data records for
  walls can be found in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions</a>. The data
  records for glazing systems can be found in
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems\">
  Buildings.Rooms.FLEXLAB.Data.Constructions.GlazingSystems</a>.
  </p>
  <p>
  Examples of FLEXLAB simulations are made assuming that the shading position
  controls, internal gains, air handlers, and the central plant do not need
  detailed models. Instead it is assumed that experimental data is available
  and data tables reading that data are used instead. Examples of simulations
  using FLEXLAB models are located in the
  <a href=\"modelica:Buildings.Rooms.FLEXLAB.Rooms.Examples\">
  Buildings.Rooms.FLEXLAB.Data.Rooms.Examples</a>.
  </p>
  <p>
  Each room model is made to match architectural drawings. If a construction
  needs to be changed to match an experiment the construction definition
  can be changed in the Parameters window. Sometimes constructions are used
  in multiple walls, so the user must be careful to acoid accidentally 
  changing the construction of more walls than intended. Detailed editing
  of a model may be necessary.
  </p>
  <h4>Future Work</h4>
  <p>
  A list of items which still need to be understood and finalized is below:
  </p>
  <ul>
  <li>Do radiant floors serve the closets and electrical rooms?</li>
  <li>Does HVAC serve the closets and electrical rooms?</li>
  <li>Identify all detailed door constructions</li>
  <li>Use available window information to identify detailed
  model-level window specifications - recommended to speak
  with Christian Kohler (sp?)</li>
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
  </ul>
  </html>"));
end UsersGuide;
