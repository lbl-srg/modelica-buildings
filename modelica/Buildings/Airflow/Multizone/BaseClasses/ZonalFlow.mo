within Buildings.Airflow.Multizone.BaseClasses;
partial model ZonalFlow "Flow across zonal boundaries of a room"
  extends Buildings.Fluid.Interfaces.PartialStaticFourPortInterface(
     redeclare final package Medium1 = Medium,
     redeclare final package Medium2 = Medium,
     final allowFlowReversal1 = false,
     final allowFlowReversal2 = false,
     final m1_flow_nominal = 10/3600*1.2,
     final m2_flow_nominal = m1_flow_nominal);
  extends Buildings.Airflow.Multizone.BaseClasses.ErrorControl;

   replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching = true);

equation
  // Energy balance (no storage, no heat loss/gain)
  port_a1.h_outflow = inStream(port_b1.h_outflow);
  port_b1.h_outflow = inStream(port_a1.h_outflow);
  port_a2.h_outflow = inStream(port_b2.h_outflow);
  port_b2.h_outflow = inStream(port_a2.h_outflow);

  // Mass balance (no storage)
  port_a1.m_flow = -port_b1.m_flow;
  port_a2.m_flow = -port_b2.m_flow;

  port_a1.Xi_outflow = inStream(port_b1.Xi_outflow);
  port_b1.Xi_outflow = inStream(port_a1.Xi_outflow);
  port_a2.Xi_outflow = inStream(port_b2.Xi_outflow);
  port_b2.Xi_outflow = inStream(port_a2.Xi_outflow);

  // Transport of trace substances
  port_a1.C_outflow = inStream(port_b1.C_outflow);
  port_b1.C_outflow = inStream(port_a1.C_outflow);
  port_a2.C_outflow = inStream(port_b2.C_outflow);
  port_b2.C_outflow = inStream(port_a2.C_outflow);

  annotation (Diagram(graphics),
                       Icon(graphics={
        Line(points={{-86,-46},{0,-34},{88,-52}}, color={0,0,127}),
        Line(points={{-92,50},{0,34},{84,48}},    color={0,0,127}),
        Polygon(
          points={{-7,1},{9,1},{7,9},{-7,1}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-87,-49},
          rotation=360),
        Polygon(
          points={{7,-1},{-9,-1},{-7,-9},{7,-1}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={85,53},
          rotation=360)}),
    Documentation(info="<html>
<p>
This is a partial model for computing the air exchange between volumes.
</p>
<p>
fixme.
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
<li><i>January 4, 2006</i>
       by Michael Wetter:<br>
       Implemented first version.
</li>
</ul>
</HTML>"));
end ZonalFlow;
