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
With respect to the control loop this means an increase of the process gain
which may be detrimental to the control loop stability.
</p>
<p>
The valve authority <i>&beta;</i> is introduced as a metric of the disturbance of the
inherent valve characteristic when the valve is integrated into a hydronic circuit.
See 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.TwoWayValveAuthority\">
Buildings.Fluid.HydronicConfigurations.Examples.TwoWayValveAuthority</a>
for a numerical illustration.
The authority is defined as the ratio between the minimum <i>&Delta;p<sub>min</sub></i> and the 
maximum <i>&Delta;p<sub>max</sub></i> pressure differential at the valve boundaries.
</p>
<p>
<i>
&beta; = &Delta;p<sub>min</sub> / &Delta;p<sub>max</sub>
</i>
</p>
<p>
Those extreme values of the pressure differential at the valve boundaries
are obtained when the valve is fully open and fully closed, respectively.
<i>&Delta;p<sub>max</sub></i> is sometimes presented as the pressure 
differential at the extreme boundaries of the circuit where the flow rate
is modulated by the control valve. However, this definition proves
to be less tractable to compute the valve authority in non obvious 
configurations, for instance with an intermediary bypass or in case
of a three-way valve (see below).
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
<i>&Delta;p<sub>min</sub></i> and <i>&Delta;p<sub>max</sub></i> with 
the same factor. 
Therefore, the valve authority <i>&beta;</i> remains the same.
However, the rate of change of the flow rate with respect to the valve 
opening is increased and the controllability is degraded, which
is not captured by the conventional definition of the authority.
The concept of \"practical authority\" is introduced to overcome
that limitation.
It is defined as the ratio of the pressure differential at fully
open conditions <i>and</i> design flow rate to the maximum
pressure differential corresponding to fully closed conditions.
</p>
<p>
<i>
&beta;' = (&Delta;p valve fully open and design flow) / (&Delta;p valve fully closed)
</i>
</p>
<p>
The two variables are related by the square of the ratio of the actual flow
rate to the design flow rate.
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

<h5>
Three-way valve authority
</h5>

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
  </html>"));
  end NomenclatureSymbols;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
Three-way valves are typically designed to perform a mixing function,
i.e., with two inlet ports and one outlet port.
</p>
</html>"));
end UsersGuide;
