within Buildings.Airflow.Multizone;
model ZonalFlow_m_flow "Zonal flow with input air change per second"
  extends Buildings.Airflow.Multizone.BaseClasses.ZonalFlow;
   Modelica.Blocks.Interfaces.RealInput mAB_flow "Mass flow rate from A to B"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput mBA_flow "Mass flow rate from B to A"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));

equation
  port_a1.m_flow = mAB_flow;
  port_a2.m_flow = mBA_flow;

  annotation (defaultComponentName="floExc",
Documentation(info="<html>
<p>
This model computes the air exchange between volumes.
</p>
<p>
Input is the mass flow rate from <i>A</i> to <i>B</i> and from <i>B</i> to <i>A</i>.
</html>",
revisions="<html>
<ul>
<li>
August 18, 2014, by Michael Wetter:<br/>
Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
</li>
<li>
July 20, 2010, by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
January 17, 2006, by Michael Wetter:<br/>
Implemented first version.
</li>
</ul>
</html>"));
end ZonalFlow_m_flow;
