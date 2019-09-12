within Buildings.ThermalZones.ReducedOrder;
package EquivalentAirTemperature "Package with models for equivalent air temperatures according to VDI 6007
  Part 1"
extends Modelica.Icons.VariantsPackage;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

annotation (Documentation(info="<html>
<p>This package package contains models for
calculating an equivalent air temperature. There are two common ways to
consider solar radiation hitting exterior surfaces. One way is to consider
the resulting heat load at the wall&apos;s capacity. The other way is to
add correction terms to the outdoor air temperature. The models in the package
<a href=\"modelica://Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature\">
Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature</a>
follow the second approach. This approach is, for example, described in the German
Guideline VDI 6007 Part 1 (VDI, 2012). The influence of indoor temperatures
via heat transfer through exterior walls is neglected. The exterior wall&apos;s
outdoor surface is assumed to have the outdoor air temperature for calculation
of radiative heat exchange with the ambient.</p>
<p>The fundamental equation is</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>EqAirExt</sub> = T
<sub>AirAmb</sub>+&Delta;T<sub>EqLW</sub>+&Delta;T
<sub>EqSW</sub>.
</p>
<p>
The correction term for long-wave radiation is based on the black body sky
temperature and dry bulb temperature, and it is calculated as</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;T<sub>EqLW</sub> =
(T<sub>BlaSky</sub>-T<sub>DryBul</sub>)
h<sub>Rad</sub>/
(h<sub>Rad</sub>+h<sub>Ext</sub>).
</p>
<p>
The Guideline VDI 6007 Part 1 considers in
addition an environmental radiative temperature (similar to the black-body
sky temperature) and tilt angles for all orientations. As
necessary inputs for the environmental radiative temperature are not defined
in TMY weather data sets (radiation from the environment is missing), the
influence of this temperature is not considered in the presented
models. It is in any case a minor effect as black-body sky temperature and
environmental radiative temperature hardly differ. Furthermore, the Guideline
VDI 6007 Part 1 calculates the correction term for each orientation separately
with individual radiative and convective coefficients of heat transfer. In the
presented models, the user can define only one radiative and one convective
coefficient of heat transfer. When using area-weighted coefficients, the impact
is of minor importance for typical values.
</p>
<p>If a sunblind is present, the current status (closed = 1 and open = 0) is
considered by multiplying the long-wave correction terms for windows with the
status variable minus one. The sunblind status is defined per orientation.
</p>
<p>The correction term for short-wave radiation does not count for windows and
is calculated with the help of the solar radiation for the specific orientations
as
</p>
<p align=\"center\"  style=\"font-style:italic;\">
&Delta;T<sub>EqSW</sub> = H<sub>Sol
</sub>a<sub>Ext</sub>/(h<sub>Rad</sub>+h<sub>Ext</sub>).
</p>
<p>
With the equations above, one equivalent air temperature per orientation
and wall or window is calculated. These equivalent air temperatures are then
aggregated weighting each entry with a weighting factor. In this part, constant
temperatures of ground coupled elements or adjacent rooms can be considered.
The sum of weighting factors per calculated equivalent air temperature must be
one.
If you consider two equivalent air temperatures, one for walls and one for
windows, the sum of weighting factors should be one per category. In the given
case, the weighting factors are calculated with the <i>U</i>-value and area of
the concerned wall elements as
</p>
<p align=\"center\"  style=\"font-style:italic;\">
WeighFac<sub>i</sub> =
U<sub>i </sub>A<sub>i</sub>/&Sigma;U<sub>i </sub>A<sub>i</sub>
</p>
<p>More information about this topic can be found in Lauster <i>et al</i> .
(2014).</p>
<h4>References</h4>
<p>VDI. German Association of Engineers Guideline VDI 6007-1 March 2012.
Calculation of transient thermal response of rooms and buildings - modelling of
rooms.</p>
<p>M. Lauster, P. Remmen, M. Fuchs, J. Teichmann, R. Streblow, D. Mueller.
Modelling long-wave radiation heat exchange for thermal network building
simulations at urban scale using Modelica. <i>Proceedings of the 10th
International Modelica Conference</i>, p. 125-133, Lund, Sweden. Mar. 10-12,
2014. <a href=\"http://www.ep.liu.se/ecp/096/013/ecp14096013.pdf\">
http://www.ep.liu.se/ecp/096/013/ecp14096013.pdf</a></p>
</html>"));
end UsersGuide;




  annotation (Documentation(info="<html>
<p>
This package contains models to calculate an equivalent air temperature
taking into account short-wave and long-wave radiation on exterior surfaces.
</p>
</html>"));
end EquivalentAirTemperature;
