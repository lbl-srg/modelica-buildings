within Buildings.Airflow.Multizone;
model ZonalFlow_ACS "Zonal flow with input air change per second"
  extends Buildings.Airflow.Multizone.BaseClasses.ZonalFlow;

  parameter Boolean useDefaultProperties = false
    "Set to true to use constant density";
  parameter Modelica.Units.SI.Volume V "Volume of room";

  Modelica.Blocks.Interfaces.RealInput ACS
    "Air change per seconds, relative to the smaller of the two volumes"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
protected
  Modelica.Units.SI.VolumeFlowRate V_flow
    "Volume flow rate at standard pressure";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(T=Medium.T_default,
         p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

  Medium.ThermodynamicState sta_a1_inflow=
      Medium1.setState_phX(port_a1.p, port_b1.h_outflow, port_b1.Xi_outflow)
    "Medium properties in port_a1";
  Medium.ThermodynamicState sta_a2_inflow=
      Medium1.setState_phX(port_a2.p, port_b2.h_outflow, port_b2.Xi_outflow)
    "Medium properties in port_a2";

equation
  when useDefaultProperties and initial() then
   assert( abs(1-rho_default/((Medium.density(sta_a1_inflow) + Medium.density(sta_a2_inflow))/2))  < 0.2,
    "Wrong density. Densities need to match.");
// The next three lines have been removed as they cause
// a compilation error in OpenModelica.
//    + "\n Medium.density(sta_a1) = " + String(Medium.density(sta_a1_inflow))
//    + "\n Medium.density(sta_a2) = " + String(Medium.density(sta_a2_inflow))
//    + "\n rho_nominal            = " + String(rho_default));
  end when;
  V_flow = V * ACS;
  m_flow / V_flow = if useDefaultProperties then rho_default else (Medium.density(sta_a1_inflow) + Medium.density(sta_a2_inflow))/2;
  // assign variable in base class
  port_a1.m_flow = m_flow;
  port_a2.m_flow = m_flow;
  annotation (Icon(graphics={
        Text(
          extent={{-92,108},{16,66}},
          textColor={0,0,127},
          textString=
               "ACS = %ACS")}),
defaultComponentName="floExc",
Documentation(info="<html>
<p>
This model computes the air exchange between volumes.
</p>
<p>
Input is the air change per seconds. The volume flow rate is computed as
</p>
<pre>
  V_flow = ACS * V
</pre>
<p>
where <code>ACS</code> is an input and the volume <code>V</code> is a parameter.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 18, 2014, by Michael Wetter:<br/>
Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
Changed message of assert statement to avoid an error in OpenModelica.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Changed the parameter <code>useConstantDensity</code> to
<code>useDefaultProperties</code> to use consistent names within this package.
A conversion script can be used to update this parameter.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
July 20, 2010 by Michael Wetter:<br/>
Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>
January 4, 2006 by Michael Wetter:<br/>
Implemented first version.
</li>
</ul>
</html>"));
end ZonalFlow_ACS;
