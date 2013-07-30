within Buildings.Rooms.Examples.FLEXLAB;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


  annotation(Documentation(info="<html>
  <p>
  A list of items which still need to be understood and finalized is belowL
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
