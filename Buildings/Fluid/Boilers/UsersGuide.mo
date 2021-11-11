within Buildings.Fluid.Boilers;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models for boilers.
The main equations are computed in the base class
<a href=\"Modelica://Buildings.Fluid.Boilers.BaseClasses.PartialBoiler\">
Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</a>
and the efficiency is computed in the extended models.
</p>
<p>
The heat transferred to the working fluid (typically water or air) is
</p>
<p align=\"center\">
<i>Q̇ = y Q̇<sub>0</sub> &eta; &frasl; &eta;<sub>0</sub> </i>
</p>
<p>
where <i>y &isin; [0, 1]</i> is the control signal,
<i>Q̇<sub>0</sub></i> is the nominal power,
<i>&eta;</i> is the efficiency at the current operating point,
and <i>&eta;<sub>0</sub></i> is the efficiency at <i>y=1</i> and,
when applicable, at the nominal temperature <i>T=T<sub>nominal</sub></i>
or <i>T<sub>inlet</sub>=T<sub>inlet,nominal</sub></i>,
depending on the choice of model.
</p>
<p>
The efficiency is defined as
</p>
<p align=\"center\">
<i>&eta;</i> = <i>Q̇</i> &frasl; <i>Q̇<sub>f</sub></i>,
</p>
<p>
where <i>Q̇<sub>f</sub></i> is the heat of combustion released by the fuel as specified in
<a href=\"Buildings.Fluid.Data.Fuels\">Buildings.Fluid.Data.Fuels</a>.
There are two methods of specifying the efficiency.
</p>
<ul>
<li>
In <a href=\"Modelica://Buildings.Fluid.Boilers.BoilerPolynomial\">
Buildings.Fluid.Boilers.BoilerPolynomial</a>,
the efficiency is specified using a polynomial
of the firing rate <i>y</i> and optionally the temperature of the fluid <i>T</i>.
</li>
<li>
In <a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>,
the efficiency is specified with curves
of the firing rate <i>y</i> and the inlet temperature <i>T<sub>inlet</sub></i>.
Example curves are implemented in
<a href=\"Modelica://Buildings.Fluid.Boilers.Data.Lochinvar\">
Buildings.Fluid.Boilers.Data.Lochinvar</a>.
</li>
</ul>
<p>
Specifying the performance using a table as implemtend in
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>
is generally easier for representing condensing boilers because the change in
efficiency near the condensation point can easily be specified.
</p>
<p>
The parameter <code>Q_flow_nominal</code>
is the power transferred to the fluid for
<i><code>y</code></i>=1
and, if the efficiency depends on temperature
in the extended polynomial boiler model,
for <i><code>T=T<sub>0</sub></code></i>.
</p>
<p>
The fuel mass flow rate and volume flow rate are computed as
</p>
<p align=\"center\">
<i>ṁ<sub>f</sub> = Q̇<sub>f</sub> &frasl; h<sub>f</sub> </i>
</p>
<p>
and
</p>
<p align=\"center\">
<i>V̇<sub>f</sub> = ṁ<sub>f</sub> &frasl; &rho;<sub>f</sub>, </i>
</p>
<p>
where the fuel heating value <i>h<sub>f</sub></i>
and the fuel mass density <i>&rho;<sub>f</sub></i> are obtained
from the parameter <code>fue</code>.
Note that if <i>&eta;</i> is the efficiency relative to the lower heating value,
then the fuel properties also need to be used for the lower heating value.
</p>
<p>
Optionally, the port <code>heatPort</code>
can be connected to a heat port outside of this model
to impose a boundary condition in order to model heat losses to the ambient.
When using this <code>heatPort</code>,
make sure that the efficiency does not already account for this heat loss.
</p>
<p>
On the Assumptions tag, the model can be parameterized to compute a transient
or steady-state response. The transient response of the boiler is computed
using a first order differential equation to compute the boiler&apos;s water
and metal temperature, which are lumped into one state.
The boiler outlet temperature is equal to this water temperature.
</p>
</html>"));
end UsersGuide;
