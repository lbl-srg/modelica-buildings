within Buildings.UsersGuide.ReleaseNotes;
class Version_0_11_0 "Version 0.11.0"
  extends Modelica.Icons.ReleaseNotes;
annotation (preferredView="info", Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>

<ul>
<li>
Added the package
<code>Buildings.ThermalZones.Detailed</code> to compute heat transfer in rooms
and through the building envelope.
Multiple instances of these models can be connected to create
a multi-zone building model.
</li>
<li>
Added the package
<code>Buildings.HeatTransfer.Windows</code>
to compute heat transfer (solar radiation, infrared radiation,
convection and conduction) through glazing systems.
</li>
<li>
In package
<code>Buildings.Fluid.Chillers</code>, added the chiller models
<code>Buildings.Fluid.Chillers.ElectricReformulatedEIR</code>
and
<code>Buildings.Fluid.Cphillers.ElectricEIR</code>, and added
the package
<code>Buildings.Fluid.Chillers.Data</code>
that contains data sets of chiller performance data.
</li>
<li>
Added package
<code>Buildings.BoundaryConditions</code>
with models to compute boundary conditions, such as
solar irradiation and sky temperature.
</li>
<li>
Added package
<code>Buildings.Utilities.IO.WeatherData</code>
with models to read weather data in the TMY3 format.
</li>
<li>
Revised the package
<code>Buildings.Fluid.Sensors</code>.
</li>
<li>
Revised the package
<code>Buildings.Fluid.HeatExchangers.CoolingTowers</code>.
</li>
<li>
In
<code>Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</code>
and
<code>Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</code>,
fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream.
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
In
<code>Buildings.Fluid.Interfaces.ConservationEquation</code> and in
<code>Buildings.Media.Interfaces.PartialSimpleMedium</code>, set
nominal attribute for medium to provide consistent normalization.
Without this change, Dymola 7.4 uses different values for the nominal attribute
based on the value of <code>Advanced.OutputModelicaCodeWithJacobians=true/false;</code>
in the model
<code>Buildings.Examples.HydronicHeating</code>.
</li>
<li>
Fixed bug in energy balance of
<code>Buildings.Fluid.Chillers.Carnot</code>.
</li>
<li>
Fixed bug in efficiency curves in package
<code>Buildings.Fluid.Movers.BaseClasses.Characteristics</code>.
</li>
</ul>
</html>"));
end Version_0_11_0;
