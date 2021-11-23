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
and the efficiency is described in the extended models
using different methods.
</p>
<p>
The heat of combustion released by the fuel is computed as
</p>
<p align=\"center\">
<i>Q&#775;<sub>f</sub> = y &sdot; Q&#775;<sub>0</sub> &frasl; &eta;<sub>0</sub> </i>
</p>
<p>
where <i>y &isin; [0, 1]</i> is the control signal or firing rate,
<i>Q&#775;<sub>0</sub></i> is the nominal heating power
and <i>&eta;<sub>0</sub></i> is the nominal efficiency.
The nominal values correspond to the operating condition at <i>y = 1</i> and,
when applicable, at the nominal temperature <i>T = T<sub>0</sub></i>
or <i>T<sub>inlet</sub> = T<sub>inlet,0</sub></i>,
depending on the choice of model.
</p>
<p>
The heat transferred to the working fluid (typically water or air) is
</p>
<p align=\"center\">
<i>Q&#775; = &eta; &sdot; Q&#775;<sub>f</sub> - Q&#775;<sub>amb</sub> </i>
</p>
<p>
where <i>&eta;</i> is the efficiency at the current operating point
and <i>Q&#775;<sub>amb</sub> > 0</i> is the heat loss from the boiler
to the ambient.
<p>
<i>Q&#775;<sub>amb</sub></i> is considered only when the port <code>heatPort</code>
is connected to a heat port outside of this model
to impose a boundary condition in order to model heat losses to the ambient.
When using this <code>heatPort</code>,
make sure that the efficiency does not already account for this heat loss.
Also note that in
<a href=\"Modelica://Buildings.Fluid.Boilers.BaseClasses.PartialBoiler\">
Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</a>,
the equation
<code>QWat_flow = eta * QFue_flow + UAOve.Q_flow</code>
uses a summation instead of a subtraction because the direction
of <code>UAOve.Q_flow</code> is from the ambient to the boiler.
</p>
<p>
The fuel is specified in
<a href=\"Buildings.Fluid.Data.Fuels\">Buildings.Fluid.Data.Fuels</a>
via
</p>
<p align=\"center\">
<i>m&#775;<sub>f</sub> = Q&#775;<sub>f</sub> &frasl; h<sub>f</sub> </i> <br/>
<i>V&#775;<sub>f</sub> = m&#775;<sub>f</sub> &frasl; &rho;<sub>f</sub> </i>
</p>
<p>
where <i>m&#775;</i> is the mass flow rate of the fuel,
<i>h<sub>f</sub></i> is the heating value of the fuel,
<i>V&#775;<sub>f</sub></i> is the volumetric flow rate of the fuel,
and <i>&rho;<sub>f</sub></i> is the density of the fuel.
Care must be taken to choose the higher or lower heating value correctly
that corresponds to the efficiency <i>&eta;</i>.
(E.g., the efficiency of a condensing boiler may be computed on the
higher heating value to avoid efficiencies higher than <i>1</i>,
whereas a non-condesing boiler's efficiency is typically on the lower heating value.)
</p>
<p>
There are two ways to specify the efficiency <i>&eta;</i>.
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
efficiency near the condensation point can be described conveniently.
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
