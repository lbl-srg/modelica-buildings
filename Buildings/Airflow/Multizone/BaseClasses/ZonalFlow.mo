within Buildings.Airflow.Multizone.BaseClasses;
partial model ZonalFlow "Flow across zonal boundaries of a room"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1 = false,
    final allowFlowReversal2 = false,
    final m1_flow_nominal = 10/3600*1.2,
    final m2_flow_nominal = m1_flow_nominal,
    final m1_flow_small=1E-4*abs(m1_flow_nominal),
    final m2_flow_small=1E-4*abs(m2_flow_nominal));

   replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

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
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-84,54},{-40,34},{0,68},{36,42},{72,50}},
                                                  color={0,0,127},
          smooth=Smooth.Bezier),
        Polygon(
          points={{7,-1},{-9,-1},{-7,-9},{7,-1}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={79,55},
          rotation=360),
        Line(points={{76,-62},{32,-82},{-8,-48},{-44,-74},{-80,-66}},
                                                  color={0,0,127},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-7,-1},{9,-1},{7,-9},{-7,-1}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-79,-63},
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
May 12, 2020, by Michael Wetter:<br/>
Changed assignment of <code>m1_flow_small</code> and
<code>m2_flow_small</code> to <code>final</code>.
These quantities are not used in this model and models that extend from it.
Hence there is no need for the user to change the value.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
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
