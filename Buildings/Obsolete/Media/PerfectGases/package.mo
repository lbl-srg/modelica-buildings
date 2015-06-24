within Buildings.Obsolete.Media;
package PerfectGases "Package with models for perfect gases"
  extends Modelica.Icons.MaterialPropertiesPackage;


annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models of <i>thermally perfect</i> gases.
</p>
<p>
A medium is called thermally perfect if
<ul>
<li>
it is in thermodynamic equilibrium,
</li><li>
it is chemically not reacting, and
</li><li>
internal energy and enthalpy are functions of temperature only.
</li>
</ul>
<p>
In addition, the gases in this package are <i>calorically perfect</i>, i.e., the
specific heat capacities at constant pressure <i>c<sub>p</sub></i>
and constant volume <i>c<sub>v</sub></i> are both constant (Bower 1998).
</p>
<p>
For dry and moist air media that also have a constant density, see
<a href=\"modelica://Buildings.Obsolete.Media.GasesConstantDensity\">
Buildings.Obsolete.Media.GasesConstantDensity</a>.
</p>
<h4>References</h4>
<p>
Bower, William B. <i>A primer in fluid mechanics: Dynamics of flows in one
space dimension</i>. CRC Press. 1998.
</p>
</html>"));
end PerfectGases;
