within Buildings.Airflow.Multizone.BaseClasses;
partial model TwoWayFlowElementBuoyancy
  "Flow resistance that uses the power law"
  extends Buildings.Airflow.Multizone.BaseClasses.TwoWayFlowElement;

  parameter Modelica.Units.SI.Length wOpe=0.9 "Width of opening"
    annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length hOpe=2.1 "Height of opening"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Units.SI.Length hA=2.7/2
    "Height of reference pressure zone A" annotation (Dialog(group="Geometry"));
  parameter Modelica.Units.SI.Length hB=2.7/2
    "Height of reference pressure zone B" annotation (Dialog(group="Geometry"));

  annotation (Documentation(info="<html>
<p>
This is a partial model for models that describe the bi-directional
air flow through large openings.
</p>
<p>
Models that extend this model need to compute
<code>mAB_flow</code> and <code>mBA_flow</code>,
or alternatively <code>VAB_flow</code> and <code>VBA_flow</code>,
and the face area <code>area</code>.
The face area is a variable to allow this partial model to be used
for doors that can be open or closed as a function of an input signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 27, 2018, by Michael Wetter:<br/>
Corrected old parameter annotation.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
February 4, 2005 by Michael Wetter:<br/>
Released first version.
</ul>
</html>"));
end TwoWayFlowElementBuoyancy;
