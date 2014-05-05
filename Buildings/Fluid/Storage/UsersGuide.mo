within Buildings.Fluid.Storage;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This user's guide describes the storage tank models.
There are three storage tank models in the this package.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><th>Model name</th>       <th>Description</th>     </tr>
<tr>
<td>
<a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>
</td>
<td>
<p>
This is a model of a stratified storage tank as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Stratified.png\"
width=\"387\" height=\"453\"/>
</p>
<p>
The tank uses several volumes to model the stratification.
Heat conduction is modeled between the volumes through the fluid,
and between the volumes and the ambient.
The port <code>heaPorVol</code> may be used to connect a temperature sensor
that measures the fluid temperature of an individual volume. It may also
be used to add heat to individual volumes, for example if the tank contains
an electrical resistance heater.
</p>
<p>
The tank has <code>nSeg</code> fluid volumes. The top volume has the index <code>1</code>.
Thus, to add a heating element to the bottom element, connect a heat input to
<code>heaPorVol[nSeg]</code>.
</p>
<p>
The heat ports outside the tank insulation can be
used to specify an ambient temperature.
Leave these ports unconnected to force adiabatic boundary conditions.
Note, however, that all heat conduction elements through the tank wall (but not the top and bottom) are connected to the
heat port <code>heaPorSid</code>. Thus, not connecting
<code>heaPorSid</code> means an adiabatic boundary condition in the sense
that <code>heaPorSid.Q_flow = 0</code>. This, however, still allows heat to flow
through the tank walls, modelled by <code>conWal</code>, from one fluid volume
to another one.
</p>
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>
</td>
<td>
<p>
The model is identical to
<a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>,
except that it adds a correction that reduces the numerical
dissipation.
</p>
<p>
The correction uses a third order upwind scheme to compute the
outlet temperatures of the segments in the tank. This model
is implemented in
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>.
</p>
</td>
</tr>
<tr>
<td>
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhancedInternalHex\">
Buildings.Fluid.Storage.StratifiedEnhancedInternalHex</a>
</td>
<td>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>
except that it adds a heat exchanger to the tank.
</p>
<p>
The modifications consist of adding a heat exchanger
and fluid ports to connect to the heat exchanger.
The modifications allow to run a fluid through the tank causing heat transfer to the stored fluid.
A typical example is a storage tank in a solar hot water system.
</p>
<p>
The heat exchanger model assumes flow through the inside of a helical coil heat exchanger,
and stagnant fluid on the outside. Parameters are used to describe the
heat transfer on the inside of the heat exchanger at nominal conditions, and
geometry of the outside of the heat exchanger. This information is used to compute
an <i>hA</i>-value for each side of the coil.
Convection calculations are then performed to identify heat transfer
between the heat transfer fluid and the fluid in the tank.
</p>
<p>
The location of the heat exchanger can be parameterized as follows:
The parameters <code>hHex_a</code> and <code>hHex_b</code> are the heights
of the heat exchanger ports <code>portHex_a</code> and <code>portHex_b</code>,
measured from the bottom of the tank.
For example, to place the port <code>portHex_b</code> at the bottom of the tank,
set <code>hHexB_b=0</code>.
The parameters <code>hHex_a</code> and <code>hHex_b</code> are then used to provide
a default value for the parameters
<code>segHex_a</code> and <code>segHex_b</code>, which are the numbers of the tank
segments to which the heat exchanger ports <code>portHex_a</code> and <code>portHex_b</code>
are connected.
</p>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/StratifiedHex.png\"
width=\"458\" height=\"456\"/>
</p>
<p>
Optionally, this model computes a dynamic response of the heat exchanger.
This can be configured using the parameters
<code>energyDynamicsHex</code> and
<code>massDynamicsHex</code>.
For this computation, the fluid volume inside the heat exchanger
and the heat capacity of the heat
exchanger wall <code>CHex</code> are approximated.
Both depend on the length <code>lHex</code>
of the heat exchanger.
The model provides default values for these
parameters, as well as for the heat exchanger material which is
assumed to be steel. These default values can be overwritten by the user.
The default values for the heat exchanger geometry are computed assuming
that there is a cylindrical heat exchanger
made of steel whose diameter is half the diameter of the tank, e.g.,
<i>r<sub>Hex</sub>=r<sub>Tan</sub>/2</i>.
Hence, the length of the heat exchanger is approximated as
<i>l<sub>Hex</sub> = 2 r<sub>Hex</sub> &pi; h = 2 r<sub>Tan</sub>/2 &pi; h</i>,
where <i>h</i> is the distance between the heat exchanger inlet and outlet.
The wall thickness is assumed to be <i>10%</i> of the heat exchanger
outer diameter.
For typical applications, users do not need to change these values.
</p>
<p>
The heat exchanger is implemented in
<a href=\"Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger\">
Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger</a>.
</p>
</td>
</tr>
</table>
</html>"));
end UsersGuide;
