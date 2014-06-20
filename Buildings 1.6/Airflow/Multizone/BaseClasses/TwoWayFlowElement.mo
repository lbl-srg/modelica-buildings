within Buildings.Airflow.Multizone.BaseClasses;
partial model TwoWayFlowElement "Flow resistance that uses the power law"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1=false,
    final allowFlowReversal2=false,
    final m1_flow_nominal=10/3600*1.2,
    final m2_flow_nominal=m1_flow_nominal);
  extends Buildings.Airflow.Multizone.BaseClasses.ErrorControl;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  Modelica.SIunits.VolumeFlowRate VAB_flow(nominal=0.001)
    "Volume flow rate from A to B if positive";
  Modelica.SIunits.VolumeFlowRate VBA_flow(nominal=0.001)
    "Volume flow rate from B to A if positive";
  Modelica.SIunits.MassFlowRate mAB_flow(nominal=0.001)
    "Mass flow rate from A to B if positive";
  Modelica.SIunits.MassFlowRate mBA_flow(nominal=0.001)
    "Mass flow rate from B to A if positive";

  Modelica.SIunits.Velocity vAB(nominal=0.01) "Average velocity from A to B";
  Modelica.SIunits.Velocity vBA(nominal=0.01) "Average velocity from B to A";

  Modelica.SIunits.Density rho_a1_inflow(start=1.2)
    "Density of air flowing in from port_a1";
  Modelica.SIunits.Density rho_a2_inflow(start=1.2)
    "Density of air flowing in from port_a2";

  Modelica.SIunits.Area A "Face area";

  parameter Modelica.SIunits.Velocity vZer=0.001
    "Minimum velocity to prevent zero flow. Recommended: 0.001";
protected
  Modelica.SIunits.VolumeFlowRate VZer_flow(fixed=false)
    "Minimum net volume flow rate to prevent zero flow";
protected
  Modelica.SIunits.Mass mExcAB(start=0, fixed=true)
    "Air mass exchanged (for purpose of error control only)";
  Modelica.SIunits.Mass mExcBA(start=0, fixed=true)
    "Air mass exchanged (for purpose of error control only)";
equation
  // enforcing error control on both direction rather than on the sum only
  // gives higher robustness. The reason may be that for bi-directional flow,
  // (VAB_flow - VBA_flow) may be close to zero.
  if forceErrorControlOnFlow then
    der(mExcAB) = mAB_flow;
    der(mExcBA) = mBA_flow;
  else
    der(mExcAB) = 0;
    der(mExcBA) = 0;
  end if;
  rho_a1_inflow = Medium.density(state_a1_inflow);
  rho_a2_inflow = Medium.density(state_a2_inflow);
  VZer_flow = vZer*A;

  mAB_flow = rho_a1_inflow*VAB_flow;
  mBA_flow = rho_a2_inflow*VBA_flow;
  // Average velocity (using the whole orifice area)
  vAB = VAB_flow/A;
  vBA = VBA_flow/A;

  port_a1.m_flow = mAB_flow;
  port_a2.m_flow = mBA_flow;

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

  annotation (
    Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
This is a partial model for models that describe the bi-directional
air flow through large openings.
<P>
Models that extend this model need to compute 
<code>mAB_flow</code> and <code>mBA_flow</code>,
or alternatively <code>VAB_flow</code> and <code>VBA_flow</code>,
and the face area <code>area</code>.
The face area is a variable to allow this partial model to be used
for doors that can be open or closed as a function of an input signal.
</html>",
revisions="<html>
<ul>
<li><i>June 18, 2014</i> by Michael Wetter:<br/>
Added start values and <code>fixed=true</code> attribute for
<code>mExcAB</code> and <code>mExcBA</code>.
This avoids a warning during translation.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end TwoWayFlowElement;
