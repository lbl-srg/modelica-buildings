within Buildings.Rooms.Examples.FLEXLAB;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


  annotation(Documentation(info="<html>
  <p>
  The FLEXLAB package contains models of rooms, wall constructions, window
  constructions and examples demonstrating their use.
  </p>
  <h4>Use of FLEXLAB models</h4>
  <p>
  Models for FLEXLAB are made based on architectural drawings of individual
  rooms. The intent is simulations of FLEXLAB test cells are created by
  connecting the necessary room models for the desired applications.
  </p>
  <p>
  Examples of FLEXLAB simulations are made assuming that the shading position
  controls, internal gains, air handlers, and the central plant do not need
  detailed models. Instead it is assumed that experimental data is available
  and data tables reading that data are used instead.
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
  <li>Identify detailed door constructions</li>
  <li>Use available window information to identify detailed
  model-level window specifications</li>
  <li>Create FLEXLAB-specific weater data file for 
  taking weather data from the FLEXLAB weather sensors (May be 
  able to use python script to read data, pass into standard 
  weather data reader inputs)</li>
  <li>The design of the radiant slab is still poorly defined.
  The model of the radiant slab should be carefully checked when
  the design information is available. Specific inputs which
  must be checked include: disPip, m_flow_nominal, iLayPip,
  construction for pipe, fluid flowing through the slab</li>
  </ul>
  </html>"));
end UsersGuide;
