within Buildings.Fluid.Movers.Preconfigured;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains preconfigured versions of the mover models.
They automatically configure a mover model based on
<code>m_flow_nominal</code> and <code>dp_nominal</code>.
</p>
<p>
The configuration is as follows:
</p>
<ul>
<li>
The parameters <code>m_flow_nominal</code> and <code>dp_nominal</code>
are used to construct the pressure curve <i>&Delta; p = f(m&#775;,  y)</i>
where <i>m&#775;</i> is the mass flow rate and <i>y</i> is the speed.
This curve is based on a least squares polynomial fit of all pressure curves from
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Pumps\">
Buildings.Fluid.Movers.Data.Pumps</a>
for pumps and
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Fans\">
Buildings.Fluid.Movers.Data.Fans</a>
for fans. See link in References for more details.
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
<h4>References</h4>
<a href=\"https://simulationresearch.lbl.gov/modelica/releases/v10.0.0/help/Buildings_Fluid_HydronicConfigurations_UsersGuide.html#Buildings.Fluid.HydronicConfigurations.UsersGuide.ModelParameters\">
https://simulationresearch.lbl.gov/modelica/releases/v10.0.0/help/Buildings_Fluid_HydronicConfigurations_UsersGuide.html#Buildings.Fluid.HydronicConfigurations.UsersGuide.ModelParameters</a>
</html>"));

end UsersGuide;
