within Buildings.Fluid.HydronicConfigurations;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  class ControlValves "About control valves"
    extends Modelica.Icons.Information;

    annotation (preferredView="info",
  Documentation(info="<html>
<h4>
Control valve authority
</h4>

<h5>
Conventional definition
</h5>

<p>
To define the concept of the valve authority one may 
start with a reminder of the definition of the valve flow characteristic.
The valve flow characteristic is the function that relates the 
volume flow rate (expressed as the ratio to the flow rate at fully open conditions) 
to the valve opening for a constant pressure differential:
<i>1</i> bar in SI units and <i>1</i> psi in IP units
(refer to 
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">
Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics</a>
for further details).
However, in a real system the pressure differential at the valve boundaries
increases as the valve closes. 
Indeed, the pressure drop across the other fixed flow resistances in
series with the valve tends towards zero with the decreasing flow rate.
So the pressure differential available at the circuit boundaries shifts
entirely towards the valve.
This yields a shift of the \"inherent\" characteristic of the valve towards 
higher pressure drop values, hence higher flow rate values.
With respect to the control loop this means an increased process gain
which may be detrimental to the control loop stability.
</p>
<p>
The valve authority <i>&beta;</i> is introduced as a metric of this disturbance of the
inherent valve characteristic when the valve is integrated into a hydronic circuit.
See 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.TwoWayValveAuthority\">
Buildings.Fluid.HydronicConfigurations.Examples.TwoWayValveAuthority</a>
for a numerical illustration.
The authority is defined as the ratio between the pressure differential at 
the valve boundaries when the valve is fully open and the pressure differential at 
the valve boundaries when the valve is fully closed.
</p>
<p>
<i>
&beta; = &Delta;p(y=100%) / &Delta;p(y=0%)
</i>
</p>
<p>
As mentioned previously, <i>&Delta;p(y=0%)</i> may also be apprehended 
as the pressure differential at the boundaries of the circuit where the flow rate
is modulated by the control valve.
</p>
<p>
A general design rule for stable controls of hydronic systems is to 
ensure a control valve authority greater or equal to <i>0.5</i>.
</p>

<h5>
Practical valve authority
</h5>
<p>
Some authors such as R. Petitjean (1994) claim that the valve authority should be
corrected to account for flow imbalance in real systems.
Indeed, even for a perfectly balanced system at design conditions, some 
level of flow imbalance is inevitable at other operating points.
Some circuits may therefore be exposed to a pressure differential higher 
than at design conditions. Such high pressure differential affects 
<i>&Delta;p<sub>min</sub> = &Delta;p(y=100%)</i> and 
<i>&Delta;p<sub>max</sub> = &Delta;p(y=0%)</i> with 
the same factor. 
Therefore, the valve authority <i>&beta;</i> remains the same.
However, the rate of change of the flow rate with respect to the valve 
opening is increased and the controllability is potentially degraded, which
is not captured by the conventional definition of the authority.
The concept of \"practical authority\" is introduced to overcome
that limitation.
It is defined as the ratio of the pressure differential at fully
open conditions <i>and design flow rate</i> to the maximum
pressure differential corresponding to fully closed conditions.
</p>
<p>
<i>
&beta;' = (&Delta;p valve fully open and design flow) / (&Delta;p valve fully closed)
</i>
</p>
<p>
The two definitions of the authority are related by the square of the ratio 
of the actual flow rate to the design flow rate.
</p>
<p>
<i>
&beta;' = &beta; / (V&#775;<sub>actual</sub> / V&#775;<sub>design</sub>)<sup>2</sup>
</i>
</p>
<p>
Particularly, when the valve is fully open, if the flow rate is equal 
to the design value then <i>&beta;' = &beta;</i>.
In most of the simulation models developed during the design phase, 
we use theoretical values of pressure drops and consider perfectly 
balanced systems at design conditions.
We will therefore use the conventional authority <i>&beta;</i> for our 
analysis. 
</p>

<h4>
Three-way valves
</h4>

<p>
Three-way valves are typically designed to perform a mixing function,
i.e., with two inlet ports and one outlet port.
Therefore, all configurations that include three-way valves integrate
them in a mixing arrangement, even when they perfom a diverting function
such as 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Diversion\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Diversion</a>.
</p>

<h5>
Three-way valve authority
</h5>
<p>
The definition of the authority for a three-way valve is based on the
equivalence with a pair of two-way valves actuated in opposition, 
as illustrated in the figure below.
</p>
<p>
Using the nomenclature from the right-hand side figure with the pair of
two-way valves, we have:
<i>
&beta; = &Delta;p<sub>A-B</sub>(y=100%) / &Delta;p<sub>A-B</sub>(y=0%)
</i>.
</p>
<p>
<img alt=\"Three-way valve schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/ThreeWayValve.png\"/>
</p>
<p>
The same caveat holds for the flow rate at 
which the pressure drop <i>&Delta;p<sub>A-B</sub>(y=100%)</i> is evaluated.
There is some additional intricacy for evaluating 
<i>&Delta;p<sub>A-B</sub>(y=0%)</i> because contrary
to the two-valve, that pressure drop is here impacted by the flow rate 
in the bypass branch.
The example 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.ControlValves.ThreeWayOpenLoop\">
Buildings.Fluid.HydronicConfigurations.Examples.ControlValves.ThreeWayOpenLoop</a>
shows that if the bypass branch is not balanced, the authority given by 
the above formula can virtually take any value and is no more representative
of the valve installed characteristic. 
Contrary to the pressure drop <i>p<sub>A-B</sub>(y=100%)</i> that can be corrected
to account for a given amount of overflow (see the definition of the practical authority)
there is no straightforward correction term that can be formulated for the pressure drop 
<i>p<sub>A-B</sub>(y=0%)</i>.
</p>
<p>
For the common case where the valve is used to modulate the flow rate through
a coil with a design pressure drop <i>&Delta;p<sub>coil</sub></i>
the generic definition of the authority can be rewritten as
<i>&beta; = &Delta;p<sub>A-AB</sub>(y=100%) /
(&Delta;p<sub>A-AB</sub>(y=100%) + &Delta;p<sub>coil</sub>)</i>.
</p>
<h5>
Should the bypass branch be balanced?
</h5>
<p>
NO for single miwing configuration with active primary pressure diffenrential.
When used in a diversion configuration for coil control, not critical, 
provided that the valve has a good authority.
Appears only critical to counter back pressure from other circuits.
is  
</p>
<h5>
Default model parameter
</h5>
<p>
The models
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear\">
Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear</a>
and
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.ThreeWayLinear\">
Buildings.Fluid.Actuators.Valves.ThreeWayLinear</a>
both use a default value of <code>fraK = 0.7</code> for the ratio of 
the <i>Kvs</i> coefficient between the bypass branch and the 
direct branch.
This default setting yields a pressure drop in the
bypass branch <i>&Delta;p<sub>L-M</sub>(y=0%)</i> that is 
<i>1 / 0.7<sup>2</sup> &asymp; 2</i> times higher at design flow rate 
than the pressure drop in the
direct branch <i>&Delta;p<sub>A-B</sub>(y=100%)</i>.
If the valve is sized with an authority of <i>&beta; = 0.5</i>
this default setting implies that the bypass branch is balanced.
However, note that the corresponding flow resistance is variable (with the 
valve opening) as opposed to the fixed flow resistance provided by a
balancing valve. 
</p>
<h4>
References
</h4>
<p>
Petitjean, R., 1994. Total hydronic balancing. Tour & Andersson AB, Ljung, Sweden.
</p>
</html>"));

  end ControlValves;

  class NomenclatureSymbols "Nomenclature and symbols"
    extends Modelica.Icons.Information;

    annotation (preferredView="info",
  Documentation(info="<html>
<table summary=\"summary\"  border=\"1\">
<tr><th>Symbol</th>
    <th>Description</th></tr>
<tr>
<td>
<img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/BalancingValve.png\"/></td>
<td>Balancing valve</td>
</tr>
<tr>
<td>
<img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/CheckValve.png\"/></td>
<td>Check valve (the arrow indicating the flow direction is not part of the symbol)</td>
</tr>
<tr>
<td>
<img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/Pump.png\"/></td>
<td>Circulating pump</td>
</tr>
<tr>
<td>
<img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/ConsumerCircuit.png\"/></td>
<td>Consumer circuit (typically a heating or cooling circuit or a terminal unit)</td>
</tr>
<tr>
<td>
<img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/Controller.png\"/></td>
<td>Controller (the dotted lines represent the wiring to the sensor and actuator)</td>
</tr>
<tr>
<td><img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/PressureControlValve.png\"/></td>
<td>Self-acting &Delta;P control valve (the dotted lines represent the capillary pipes for pressure measurement)</td>
</tr>
<tr>
<td><img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/ThreeWayValve.png\"/></td>
<td>Three-way valve with modulating actuator (the arrow indicating the flow direction is not part of the symbol)</td>
</tr>
<tr>
<td><img alt=\"Symbol\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/TwoWayValve.png\"/></td>
<td>Two-way valve with modulating actuator</td>
</tr>
</table>
</html>"));
  end NomenclatureSymbols;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
By default the secondary pump is parameterized at maximum speed with 
<code>m2_flow_nominal</code> and <code>dp2_nominal</code> plus
any additional pressure drop within the hydronic configuration.
The consumer circuit balancing balve (\"partner valve\") <code>res2</code> 
is therefore configured by default with zero pressure drop.
</p>
</html>"));
end UsersGuide;
