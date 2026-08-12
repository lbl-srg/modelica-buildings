within Buildings.Fluid.Geothermal.ZonedBorefields;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains borefield models for the simulation of zoned borehole
thermal energy storage systems. These models can simulate any arbitrary
configuration of vertical boreholes with equal lengths with both short and
long-term accuracy with an aggregation method to speed up the calculations of
the ground heat transfer. Examples
of how to use the borefield models and validation cases can be found in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Examples\">
Buildings.Fluid.Geothermal.ZonedBorefields.Examples</a>
and
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Validation\">
Buildings.Fluid.Geothermal.ZonedBorefields.Validation</a>,
respectively.
</p>
<p>
The major features and configurations are as follows:
<ul>
<li> User-defined borefield characteristics and geometry (borehole radius, pipe radius, shank spacing, etc.),
including single U-tube, double U-tube in parallel and double U-tube in series configurations.
</li>
<li> The resistances <i>R<sub>b</sub></i> and <i>R<sub>a</sub></i> are
either automatically calculated using the multipole method,
or the resistance <i>R<sub>b</sub></i> can be directly provided by the user.
In this case, the resistances <i>R<sub>b</sub></i> and <i>R<sub>a</sub></i> are
still evaluated internally, but their values are weighted so that the borehole
resistance matches the specified value.
</li>
<li>
The pipe convection resistance can be evaluated using nominal fluid properties,
or using temperature-dependent fluid properties. The temperature-dependent
formulation is useful when the fluid properties vary significantly over the
operating temperature range, for example for water-glycol mixtures.
</li>
<li>
User-defined vertical discretization of boreholes are supported.The same
vertical segmentation is used for the borehole heat transfer, and can also be
used for the detailed pressure-drop calculation.
</li>
<li>
Borefields can consist of one or many boreholes. Each borehole can be positioned
at an arbitrary position in the field using cartesian coordinates.
</li>
<li>
The resolution and precision of the load aggregation method for the ground heat transfer can be adapted.
</li>
<li>
The thermal response of the ground heat transfer is stored locally to avoid
having to recalculate it for future simulations with the same borefield configuration.
</li>
<li>
Pressure losses can be disabled, computed with the nominal pressure-drop
formulation, or computed with a detailed Darcy-Weisbach formulation. If
<code>computePressureDrop=false</code>, the zoned borefield is hydraulically
lossless. If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=false</code>, the model uses the nominal
<code>dp_nominal</code> / <code>m_flow_nominal</code> pressure-drop
formulation for each zone. If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=true</code>, the vertical ground heat exchanger
pipes are modeled with a detailed Darcy-Weisbach pressure-drop calculation.
The detailed calculation can use constant fluid properties, properties evaluated
at a reference temperature, or properties evaluated at the local fluid
temperature, depending on the value of <code>fluidProperties</code>.
</li>
</ul>

<p>
The model allows the simulation of multiple zones of boreholes within the same
borefield. All boreholes in a zone have the same length
<code>hBor</code>, the same radius <code>rBor</code>, and are buried at the
same depth <code>dBor</code> below the ground surface (also known as the
inactive borehole length).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedBorefields/BorefieldGeometry_01.png\" />
</p>
<h4>How to use the borefield models</h4>
<h5>Borefield data record</h5>
<p>
Most of the parameter values of the model are contained in the record called <code>borFieDat</code>.
This record is composed of three subrecords:
<code>filDat</code> contains the thermal characteristics of the borehole filling material,
<code>soiDat</code> contains the thermal characteristics of the surrounding soil,
and <code>conDat</code> contains all others parameters, namely parameters
defining the configuration of the borefield.
The structure and default values of the record are in the package:
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data\">Buildings.Fluid.Geothermal.ZonedBorefields.Data</a>.
The <code>borFieDat</code> record
can be found in the <a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield</a> subpackage therein.
Examples of the subrecords <code>conDat</code>, <code>filDat</code> and <code>soiDat</code>
can be found in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Configuration</a>,
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Filling</a> and
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil\">
Buildings.Fluid.Geothermal.ZonedBorefields.Data.Soil</a>, respectively.
</p>
<p>
It is important to make sure that the <code>borCon</code> parameter within
the <code>conDat</code> subrecord is compatible with the chosen borefield model.
For example, if a double U-tube
borefield model is chosen, the <code>borCon</code> parameter could be set
to both a parallel double U-tube configuration and a double U-tube configuration in series,
but could not be set to a single U-tube configuration. An incompatible borehole
configuration will stop the simulation.
</p>


<h5>Ground heat transfer parameters</h5>
<p>
Other than the parameters contained in the <code>borFieDat</code> record,
the borefield models have other parameters which can be modified by the user.
The <code>tLoaAgg</code> parameter is the time resolution of the load aggregation
for the calculation of the ground heat transfer. It represents the
frequency at which the load aggregation procedure is performed in the simulation.
Therefore, smaller values of <code>tLoaAgg</code>  will improve
the accuracy of the model, at the cost of increased simulation times
due to a higher number of events occuring in the simulation. While a default value
is provided for this parameter, it is advisable to ensure that it is lower
than a fraction (e.g. half) of the time required for the fluid to completely circulate
through the borefield,
as increasing the value of <code>tLoaAgg</code> beyond this
will result in non-physical borehole wall temperatures.
</p>
<p>
The <code>nCel</code> parameter also affects the accuracy and simulation time
of the ground heat transfer calculations. As this parameter sets the number
of consecutive equal-size aggregation cells before increasing the size of cells,
increasing its value will result in less load aggregation, which will increase
accuracy at the cost of computation time. On the other hand,
decreasing the value of <code>nCel</code> (down to a minimum of 1)
will decrease accuracy but improve
computation time. The default value is chosen as a compromise between the two.
</p>
<p>
Further information on the <code>tLoaAgg</code> and <code>nCel</code> parameters can
be found in the documentation of
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.GroundTemperatureResponse\">
Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</a>.
</p>
<h5>Other parameters</h5>
<p>
Other parameters which can be modified include the dynamics, initial conditions,
and further information regarding the fluid flow, for example whether the flow is reversible.
It is worth noting that regardless of the <code>energyDynamics</code> chosen,
the <code>steadyState</code> parameter of the borehole filling material can be set to <code>true</code>
to remove the effect of the thermal capacitance
of the filling material in the borehole(s).
The <code>nSeg</code> parameter specifies the number of segments for the vertical discretization
of the borehole(s).
Further information on this discretization can be found in the &#34;Model description&#34; section below.
</p>
<p>
The zoned borefield models use the same internal borehole heat exchanger base
classes as the borefield models. Therefore, the same options are available for
temperature-dependent pipe convection resistance and detailed pressure-drop
calculation.
</p>
<p>
The model-level parameter <code>use_TDepRConv</code> enables
temperature-dependent pipe convection resistance. Pressure-drop calculation is
controlled by <code>computePressureDrop</code> and
<code>use_detailedPressureDrop</code>. If <code>computePressureDrop=false</code>,
no pressure drop is computed. If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=false</code>, the model uses the nominal
pressure-drop formulation based on <code>dp_nominal</code> and
<code>m_flow_nominal</code>. If <code>computePressureDrop=true</code> and
<code>use_detailedPressureDrop=true</code>, the model uses a detailed
Darcy-Weisbach pressure-drop calculation for the vertical ground heat exchanger
pipes.
</p>
<p>
For the detailed Darcy-Weisbach calculation, the parameter
<code>fluidProperties</code> controls how density and dynamic viscosity are
evaluated:
</p>
<ul>
<li>
<code>Buildings.Fluid.Types.FluidProperties.Constant</code>: uses the
user-specified constant values <code>rhoMed</code> and <code>muMed</code>.
This is intended as an expert option and should be kept consistent with the
redeclared <code>Medium</code>.
</li>
<li>
<code>Buildings.Fluid.Types.FluidProperties.DefaultTemperature</code>: evaluates
density and viscosity from the redeclared <code>Medium</code> at the reference
temperature <code>T_ref</code>.
</li>
<li>
<code>Buildings.Fluid.Types.FluidProperties.ActualTemperature</code>: evaluates
density and viscosity from the local fluid temperature during the simulation.
</li>
</ul>
<p>
These options are set on the zoned borefield model instance and are propagated
to the representative borehole model of each zone. They are not set in the
configuration data record.
</p>
<p>
When <code>use_TDepRConv=true</code> or
<code>fluidProperties=Buildings.Fluid.Types.FluidProperties.ActualTemperature</code>,
the fluid type and, for glycol-water media, the glycol mass fraction are derived
from the redeclared <code>Medium</code>. The supported media for
temperature-dependent property evaluation are
</p>
<ul>
<li>
<code>Buildings.Media.Water</code>,
</li>
<li>
<code>Buildings.Media.Antifreeze.EthyleneGlycolWater</code>,
</li>
<li>
<code>Buildings.Media.Antifreeze.PropyleneGlycolWater</code>.
</li>
</ul>
<p>
If temperature-dependent property evaluation is disabled, the zoned borefield
model can still be used with any compatible medium.
</p>
<p>
These options are particularly relevant for zoned borefield simulations because
the local fluid temperature, and therefore the local fluid properties, can vary
between zones and along the borehole depth. The detailed pressure-drop
calculation preserves the segment-wise formulation used for the heat-transfer
calculation.
</p>
<p>
For a more detailed description of these options, see
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.UsersGuide\">
Buildings.Fluid.Geothermal.Borefields.UsersGuide</a>.
</p>
<h5>Fluid flow</h5>
<p>
In every zone, all boreholes are connected in parallel. Models that instantiate this borefield model need to provide the
pressure drop or mass flow rate that is needed to distribute the flow to the different zones. Each zone of a borefield is connected
between its <code>port_a</code> and <code>port_b</code>, e.g., flow that enters <code>port_a[1]</code> leaves at <code>port_b[1]</code>.
Zones that operate in series can be configured by connecting the fluid
ports of the respective zones. For example, suppose the borefield has the instance name <code>borFie</code>. Then,
the connect statement
</p>
<pre>
connect(borFie.port_b[1], borFie.port_a[2]);
</pre>
<p>
connects the outlet of the first zone to the inlet of the second zone.
</p>
<h4>Model description</h4>
<p>
The borefield models rely on the following key assumptions:
<ul>
<li>The thermal properties of the soil (conductivity and diffusivity) are constant,
homogenous and isotropic.
</li>
<li>
The conductivity, capacitance and density of the grout and pipe material are constant, homogenous and isotropic.
</li>
<li>
There is no heat extraction or injection prior to the simulation start.
</li>
<li>
All of the boreholes in the borefield have uniform dimensions (including the pipe dimensions).
</li>
<li>
Inside the boreholes, the non-advective heat transfer is only in the radial direction.
</li>
</ul>
<p>
The borefield models are constructed in two main parts: the borehole(s) and the ground heat transfer.
The former is modeled as a vertical discretization of borehole segments, where a uniform temperature increase or decrease
(due to heat injection or extraction) is superimposed to the far-field ground temperature to obtain the borehole wall
temperature. The thermal effects of the circulating fluid (including the convection resistance),
of the pipes and of the filling material are all taken into consideration, which allows modeling
short-term thermal effects in the borehole. The pipe convection resistance and the optional detailed pressure-drop
calculation use the same formulations as the borefield models. Further information is provided in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.UsersGuide\">
Buildings.Fluid.Geothermal.Borefields.UsersGuide</a>. The borehole segments do not take into account axial effects,
thus only radial (horizontal) effects are considered within the borehole(s). The thermal
behavior between the pipes and borehole wall are modeled as a resistance-capacitance network, with
the grout capacitance being split in the number of pipes present in a borehole section.
The capacitance is only present if the <code>steadyState</code> parameter of the borehole filling material
is set to <code>false</code>.
The figure below shows an example for a borehole section within a single U-tube configuration.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/BoreholeResistances_01.png\" />
</p>
<p>
The second main part of the borefield models is the ground heat transfer. The heat transfer in the ground
is modeled analytically as a superposition of convolution integrals between the heat flux at each
of the borehole segments and the borefield's thermal response factor.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/ZonedBorefields/LoadAggregation_04.png\" />
</p>
<p>
The model uses a load aggregation technique to reduce the time required to calculate
the borehole wall temperature changes resulting from heat injection or extraction.
</p>
<p>
The ground heat transfer takes into account both the borehole axial effects and
the borehole radial effects which are a result of its cylindrical geometry.
Further information on the
ground heat transfer model and the thermal temperature response calculations can
be found in
<a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.GroundTemperatureResponse\">
Buildings.Fluid.Geothermal.ZonedBorefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</a>.
</p>
<h4>Calculation times</h4>
<p>
The calculation times for both the initialization and the time integration depends
on the square of the number of zones and the number of segments.
The number of boreholes should only weakly impact on the initialization time.
</p>
</html>"));

end UsersGuide;
