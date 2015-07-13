within Buildings.Airflow.Multizone.BaseClasses;
partial model ZonalFlow "Flow across zonal boundaries of a room"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
     redeclare final package Medium1 = Medium,
     redeclare final package Medium2 = Medium,
     final allowFlowReversal1 = false,
     final allowFlowReversal2 = false,
     final m1_flow_nominal = 10/3600*1.2,
     final m2_flow_nominal = m1_flow_nominal);

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

  annotation (                       Icon(graphics={
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
Models that extend this model need to provide an equation for
<code>port_a1.m_flow</code> and <code>port_a2.m_flow</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 18, 2014, by Michael Wetter:<br/>
Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
January 4, 2006, by Michael Wetter:<br/>
Implemented first version.
</li>
</ul>
</html>"));
end ZonalFlow;
