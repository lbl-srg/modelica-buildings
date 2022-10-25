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
Based on the parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>,
a pressure curve is constructed based on regression results of pump or fan records
in <a href=\"Modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo\">
Buildings.Fluid.Movers.Data.Pumps.Wilo</a>
or <a href=\"Modelica://Buildings.Fluid.Movers.Data.Fans.Greenheck\">
Buildings.Fluid.Movers.Data.Fans.Greenheck</a>.
For more information, see documentation of
<code>Buildings.Fluid.HydronicConfiguration.UsersGuide.ModelParameters</code>
(currently under the development branch of
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1884\">#1884</a>.
<b>fixme</b> This needs to be revised, users should not have to consult
a development branch to get information.)
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
