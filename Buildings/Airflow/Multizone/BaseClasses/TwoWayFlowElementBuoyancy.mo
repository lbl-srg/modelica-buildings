within Buildings.Airflow.Multizone.BaseClasses;
partial model TwoWayFlowElementBuoyancy
  "Flow resistance that uses the power law"
  extends Buildings.Airflow.Multizone.BaseClasses.TwoWayFlowElement;

  parameter Modelica.SIunits.Length wOpe=0.9 "|Geometry|Width of opening";
  parameter Modelica.SIunits.Length hOpe=2.1 "|Geometry|Height of opening";

  parameter Modelica.SIunits.Length hA=2.7/2
    "|Geometry|Height of reference pressure zone A";
  parameter Modelica.SIunits.Length hB=2.7/2
    "|Geometry|Height of reference pressure zone B";

  annotation (Documentation(info="<html>
<p>
This is a partial model for models that describe the bi-directional
air flow through large openings.
<p>
Models that extend this model need to compute
<code>mAB_flow</code> and <code>mBA_flow</code>,
or alternatively <code>VAB_flow</code> and <code>VBA_flow</code>,
and the face area <code>area</code>.
The face area is a variable to allow this partial model to be used
for doors that can be open or closed as a function of an input signal.
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end TwoWayFlowElementBuoyancy;
