within Buildings.Templates;
package UsersGuide "Templates user guide"
  extends Modelica.Icons.Information;
  class Conventions
    "Conventions"
    extends Modelica.Icons.Information;
    annotation (
      preferredView="info",
      Documentation(
        info="<html>
<h4>Control point connections</h4>
<p>
Inside a template class, the connect clauses involving control points 
typically do not have
any graphical annotation and are therefore not rendered as 
connection lines in the diagram view.
Those connect clauses are grouped together in a dedicated section of
the equation section of each class, namely
<code>/* Control point connection - (start | stop) */</code>.
</p>

<h4>Definitions</h4>
<h5>System</h5>
<p>
We adopt the definition hereafter from ASHRAE (2018).
</p>
<p>
A set of components is a system if they share a load in
common (i.e., collectively act as a source to downstream
equipment, such as a set of chillers in a lead/lag relation-
ship serving air handlers).
</p>
<ul>
<li>
Each air handler constitutes its own separate system
because it does not share a load (terminal unit) in common with 
the other air handlers. 
</li>
<li>
Each VAV box constitutes its own system because it does
not share a load (conditioned space) in common with the other VAV boxes. 
</li>
</ul>

<h4>Abbreviations</h4>
<p>
The following abbreviations are used in that package.<br/>
</p>
<table summary=\"log levels\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Abbreviation</th><th>Description</th></tr>
<tr><td>AI</td><td>Analog input (integer or real)</td></tr>
<tr><td>AFMS</td><td>Airflow measuring station</td></tr>
<tr><td>AHU</td><td>Air handling unit</td></tr>
<tr><td>AO</td><td>Analog output (integer or real)</td></tr>
<tr><td>CHW</td><td>Chilled water</td></tr>
<tr><td>CW</td><td>Condenser water</td></tr>
<tr><td>DHW</td><td>Domestic hot water</td></tr>
<tr><td>DI</td><td>Digital input (Boolean)</td></tr>
<tr><td>DO</td><td>Digital output (Boolean)</td></tr>
<tr><td>DOAS</td><td>Dedicated outdoor air system</td></tr>
<tr><td>HHW</td><td>Heating hot water</td></tr>
<tr><td>OA</td><td>Outdoor air</td></tr>
<tr><td>VAV</td><td>Variable air volume</td></tr>
<tr><td>VFD</td><td>Variable frequency drive</td></tr>
</table>

<h4>References</h4>
<ul>
<li>
ASHRAE, 2018. Guideline 36-2018, High-Performance Sequences of Operation 
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
  end Conventions;
  annotation (
    preferredView="info",
    Documentation(
      revisions="<html>
<ul>
<li>
March 11, 2022, by Antoine Gautier:<br/>
Created user guide.
</li>
</ul>
</html>", info="<html>
<p>
This user guide describes how to use the templates.
</p>
<h4>Physical boundaries</h4>
<p>
The templates are defined at the system level, such as an air handler
or a terminal unit (refer to
<a href=\"modelica://Buildings.Templates.UsersGuide.Conventions\">
Buildings.Templates.UsersGuide.Conventions</a>
for the definition of a system).
A template is a self-contained model that can be reconfigured 
by redeclaring some of its components or modifying some of its 
structural parameters.
Such configuration does not require any other modification
of the template.
Particularly, all connect clauses between
replaceable components are resolved internally,
without any need for user intervention.
The same holds true for sensors required by a specific control 
option which are conditionally instantiated if that option is 
selected.
</p>
<h4>Simulation model assembly</h4>
<p>
There is currently no template representing a complete HVAC system,
from the plant to the terminal unit.
To build a simulation model representing a complete HVAC system, 
one needs to 
</p>
<ol>
<li>
instantiate the templates (or any derived class representing a specific 
configuration) of the different subsystems (such as the CHW and HHW plants, 
the air handlers and the terminal units),
</li>
<li>
if needed, configure those instances to represent project-specific 
system configurations if those configurations differ from the default
configuration proposed for each template, 
</li>
<li>
connect the fluid connectors of the different instances together, 
</li>
<li>
connect the signal buses of the different instances together,
</li>
<li>
fill in the parameter records of the different instances with
proper design and operating parameter values.
</li>
</ol>
<p>
When assembling a model for a complete HVAC system,
it is the user's responsibility to ensure that the control
sequence selected for one subsystem is compatible 
with the one selected for another subsystem.
For instance the AHU controller may require reset requests 
yielded by the zone equipment controller.
If the controller selected for the zone equipment does not
generate such requests, the simulation model will be singular.
Selecting controllers from the same reference&mdash;such as
ASHRAE (2018)&mdash;is the safest way 
to ensure consistency across the whole HVAC system model. 
</p>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2018. Guideline 36-2018, High-Performance Sequences of Operation 
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));

end UsersGuide;
