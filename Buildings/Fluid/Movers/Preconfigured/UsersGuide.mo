within Buildings.Fluid.Movers.Preconfigured;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains preconfigured versions of the mover models.
They automatically configure a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>
(and <code>speed_rpm_nominal</code> for <code>SpeedControlled_Nrpm</code> only).
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
The parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>
are used to construct the pressure curve <i>&Delta; p(V&#775;)</i>.
The curve support points come from regression of the pump and fan data records
available in the data package.
The pump pressure curve is based on all data records in
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Pumps\">
Buildings.Fluid.Movers.Data.Pumps</a>
and the fan pressure curve is based on all data records in
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Fans\">
Buildings.Fluid.Movers.Data.Fans</a>.
(See also
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1884\">#1884</a>.)
The model identifies itself as a fan or pump based on the default density of
the medium.
</li>
<li>
The hydraulic efficiency is computed based on the Euler number.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
Buildings.Fluid.Movers.UsersGuide</a>
for details.
</li>
<li>
The motor efficiency is computed based on a generic curve.
See <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve</a>
for details.
</li>
</ul>
</html>"));

end UsersGuide;
