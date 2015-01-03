within Buildings.Fluid.Sources;
model Outside
  "Boundary that takes weather data, and optionally trace substances, as an input"
  extends Buildings.Fluid.Sources.BaseClasses.Outside;

equation
  connect(weaBus.pAtm, p_in_internal);
  connect(weaBus.TDryBul, T_in_internal);
  annotation (defaultComponentName="out",
    Documentation(info="<html>
<p>
This model describes boundary conditions for
pressure, enthalpy, and species concentration that can be obtained
from weather data.
</p>
<p>
To use this model, connect weather data from
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a> to the port
<code>weaBus</code> of this model.
This will cause the medium of this model to be
at the pressure that is obtained from the weather file, and any flow that
leaves this model to be at the temperature and humidity that are obtained
from the weather data.
</p>
<p>If the parameter <code>use_C_in</code> is <code>false</code> (default option),
the <code>C</code> parameter
is used as the trace substance for flow that leaves the component, and the
<code>C_in</code> input connector is disabled; if <code>use_C_in</code> is <code>true</code>,
then the <code>C</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>
Note that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary pressure, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 26, 2011 by Michael Wetter:<br/>
Introduced new base class to allow implementation of wind pressure for natural ventilation.
</li>
<li>
April 27, 2011 by Michael Wetter:<br/>
Revised implementation to allow medium model that do not have water vapor.
</li>
<li>
Feb. 9, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Outside;
