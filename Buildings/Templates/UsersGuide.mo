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
We adopt the definition hereafter from ASHRAE (2021).
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
<tr><td>DP</td><td>Differential pressure</td></tr>
<tr><td>HHW</td><td>Heating hot water</td></tr>
<tr><td>OA</td><td>Outdoor air</td></tr>
<tr><td>VAV</td><td>Variable air volume</td></tr>
<tr><td>VFD</td><td>Variable frequency drive</td></tr>
</table>

<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
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
by redeclaring some of its components or modifying some 
structural parameters.
Such configuration does not require any further modification
of the template.
In particular, all connect clauses between replaceable components 
are resolved internally without user intervention.
The same applies to sensors that are required for a specific control
option and instantiated only when that option is selected.
</p>
<h4>Creation of a simulation model</h4>
<p>
Currently, there is no template that represents a complete HVAC system
from the plant to the zone equipment.
In order to create a simulation model for a complete HVAC system,
one must
</p>
<ol>
<li>
instantiate the templates (or any derived class representing a particular
configuration) of the different subsystems (e.g., the CHW and HHW plants,
the air handlers and the terminal equipment),
</li>
<li>
if necessary, configure these instances to represent project-specific
system configurations if these configurations differ from the default
configuration proposed for each template,
</li>
<li>
connect the fluid ports of the different instances together,
</li>
<li>
connect the signal busses of the different instances to each other,
</li>
<li>
fill in the parameter records of the different instances with
proper design and operating parameter values.
</li>
</ol>
<p>
When assembling a model for a complete HVAC system,
the user must ensure that the control
sequence selected for one subsystem is compatible
with that selected for another subsystem.
For example, the AHU controller may require reset requests
that originate from the zone equipment controller.
If the controller selected for the zone equipment does not
generate such requests, the simulation model will be singular.
Selecting controllers from the same reference&mdash;e.g.,
ASHRAE (2021)&mdash;is the safest way 
to ensure consistency throughout the HVAC system model.
</p>
<h4>Model parameters</h4>
<p>
Each template contains an instance <code>dat</code> of a record class that 
contains all design and operating parameters for parameterizing
the subcomponents of the template.
For example, the multiple-zone VAV template 
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>
contains an instance of the record class
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Data.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.Data.VAVMultiZone</a>
which contains the parameters for configuring the heating coil component,
as an instance of the record class  
<a href=\"modelica://Buildings.Templates.Components.Data.Coil\">
Buildings.Templates.Components.Data.Coil</a>.
All design and operating parameters should be assigned through this record instance
and are propagated down to each subcomponent.
</p>
<p>
In addition to these parameters, the record class also contains the configuration
parameters that define the system layout and control options.
These configuration parameters are bound to the values that are assigned via
the template's parameter dialog.
In this way, only the set of parameters needed for the particular system layout 
for which the template is configured is displayed in the parameter dialog.
Note that these configuration parameters are disabled in the record class
to avoid any modification by the user and preserve the bindings with the 
template parameters.
</p>
<p>
When creating a model for a complete HVAC system with multiple instances of 
different templates, the class
<a href=\"modelica://Buildings.Templates.Data.AllSystems\">
Buildings.Templates.Data.AllSystems</a>.
can be used at the top level of the model to assign all design and operating parameters.
This class allows the use of Modelica outer components to retrieve the configuration 
parameter values for each template instance based on the instance name.
Thus, it is the avatar in the modeling environment of an HVAC project datasheet.
The validation models within 
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation\">
Buildings.Templates.AirHandlersFans.Validation</a>
illustrate the use of this class.
</p>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));

end UsersGuide;
