within Buildings.Airflow.Multizone;
model ZonalFlow_m_flow "Zonal flow with input air change per second"
  extends Buildings.Airflow.Multizone.BaseClasses.ZonalFlow;
   Modelica.Blocks.Interfaces.RealInput mAB_flow "Mass flow rate from A to B"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}},rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput mBA_flow "Mass flow rate from B to A"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}},
                                                                     rotation=0)));

equation
  port_a1.m_flow = mAB_flow;
  port_a2.m_flow = mBA_flow;

  annotation (Icon(graphics),        Documentation(info="<html>
<p>
This model computes the air exchange between volumes.
</p>
<p>
Input is the mass flow rate from A to B and from B to A.
</p>
<h1>Main Author</h1>
<P>
    Michael Wetter<br>
    <a href=\"http://www.utrc.utc.com\">United Technologies Research Center</a><br>
    411 Silver Lane<br>
    East Hartford, CT 06108<br>
    USA<br>
    email: <A HREF=\"mailto:WetterM@utrc.utc.com\">WetterM@utrc.utc.com</A><br>
<h3>Release Notes</h3>
<P>
<ul>
<li><i>January 17, 2006</i>
       by Michael Wetter:<br>
       Implemented first version.
</li>
</ul>
</HTML>"),
    Diagram(graphics));
end ZonalFlow_m_flow;
