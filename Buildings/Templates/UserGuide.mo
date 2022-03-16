within Buildings.Templates;
package UserGuide "Templates Package User Guide"
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
<code>Control point connection - (start | stop)</code>.
</p>

<h4>Definitions</h4>
<h5>System</h5>
<p>
We adopt the definition hereafter from <a href=\"#ASHRAE2018\">ASHRAE (2018)</a>.
\"A set of components is a system if they share a load in
common (i.e., collectively act as a source to downstream
equipment, such as a set of chillers in a lead/lag relation-
ship serving air handlers).\"
</p>
<ul>
<li>
Each air handler constitutes its own separate system
because it does not share a load in common with the other AHUs. 
</li>
<li>
Each VAV box constitutes its own system because it does
not share a load in common the other VAV boxes. 
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
<tr><td>HHW</td><td>Heating hot water</td></tr>
<tr><td>OA</td><td>Outdoor air</td></tr>
</table>

<h4>References</h4>
<ul>
<li id=\"ASHRAE2018\">
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
<h4>Physical Boundaries</h4>
<p>
The templates are defined at the system level (refer to
<a href=\"modelica://Buildings.Templates.UserGuide.Conventions\">
Buildings.Templates.UserGuide.Conventions</a>
for the definition of a system).
A template is a self-contained model that can be reconfigured 
by redeclaring some of its components or modifying some of its 
structural parameters.
Such configuration does not require any other modification
of the template.
The templates have been validated for all system configurations
that they cover.
However, since there is currently no template for the whole HVAC 
system, it is the user's responsibility to ensure that the control
sequence selected for one system is compatible 
with the one selected for another system.
For instance the AHU controller may require reset requests 
yielded by the zone equipment controller.
If the controller selected for the zone equipment does not
generate such requests, the simulation model will be singular.
</p>
<h4>Simulation Model Assembly</h4>
<p>
To build a simulation model representing a complete HVAC system, 
one needs to 
</p>
<ol>
<li>
instantiate the templates (or any derived class representing a specific 
configuration) of the different systems (such as the CHW and HHW plants, the
air handlers and the terminal units),
</li>
<li>
if needed, configure those instances to represent project-specific 
system configurations, 
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
An online configuration tool is being developed to assist the user
with the steps 2 and 5.
</p>
<h4>Parameterization</h4>
<p>
Explain how to use and propagate the records.
Using Linkage
Using any Modelica tool
</p>
</html>"));

end UserGuide;
