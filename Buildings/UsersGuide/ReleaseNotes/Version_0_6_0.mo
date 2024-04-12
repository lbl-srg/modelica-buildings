within Buildings.UsersGuide.ReleaseNotes;
class Version_0_6_0 "Version 0.6.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
Added the package
<code>Buildings.Utilities.IO.BCVTB</code>
which contains an interface to the
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed.</a>
</li>
<li>
Updated license to Modelica License 2.
</li>
<li>
Replaced
<code>Buildings.Utilities.Psychrometrics.HumidityRatioPressure</code>
by
<code>Buildings.Utilities.Psychrometrics.HumidityRatio_pWat</code>
and
<code>Buildings.Utilities.Psychrometrics.VaporPressure_X</code>
because the old model used <code>RealInput</code> ports, which are obsolete
in Modelica 3.0.
</li>
<li>
Changed the base class
<code>Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</code>
to enable computation of pressure drop of mechanical equipment.
</li>
<li>
Introduced package
<code>Buildings.Fluid.BaseClasses.FlowModels</code> to model pressure drop,
and rewrote
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>.
</li>
<li>
Redesigned package
<code>Buildings.Utilities.Math</code> to allow having blocks and functions
with the same name. Functions are now in
<code>Buildings.Utilities.Math.Functions</code>.
</li>
<li>
Fixed sign error in
<code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>
which caused a wrong energy balance in
<code>Buildings.Fluid.Storage.StratifiedEnhanced</code>.
</li>
<li>
Renamed
<code>Buildings.Fluid.HeatExchangers.HeaterCoolerIdeal</code> to
<code>Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</code>
to have the same nomenclatures as is used for
<code>Buildings.Fluid.MassExchangers.HumidifierPrescribed</code>
</li>
<li>
In
<code>Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential</code>,
added option to compute linearization near zero based on
the fraction of nominal flow instead of the Reynolds number.
This was set as the default, as it leads most reliably to a model
parametrization that leads to a derivative <code>d m_flow/d p</code>
near the origin that is not too steep for a Newton-based solver.
</li>
<li>
In damper and VAV box models, added optional parameters
to allow specifying the nominal face velocity instead of the area.
</li>
<li>
Set nominal attribute for pressure drop <code>dp</code> in
<code>Buildings.Fluid.BaseClasses.PartialResistance</code> and in its
child classes.
</li>
<li>
Added models for chiller
(<code>Buildings.Fluid.Chillers.Carnot</code>),
for occupancy
(<code>Buildings.Controls.SetPoints.OccupancySchedule</code>) and for
blocks that take a vector as an argument
(<code>Buildings.Utilities.Math.Min</code>,
<code>Buildings.Utilities.Math.Max</code>, and
<code>Buildings.Utilities.Math.Average</code>).
</li>
<li>
Changed various variable names to be consistent with naming
convention used in Modelica.Fluid 1.0.
</li>
</ul>
</html>"));
end Version_0_6_0;
