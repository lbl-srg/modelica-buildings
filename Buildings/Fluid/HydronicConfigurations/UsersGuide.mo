within Buildings.Fluid.HydronicConfigurations;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  class Overview "Overview of the configuration models"
    extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The configurations are grouped together depending on the type of
primary network they are compatible with.
See
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide.NomenclatureSymbols\">
Buildings.Fluid.HydronicConfigurations.UsersGuide.NomenclatureSymbols</a>
for the definitions of the different circuit types
and the symbols used in the schematics below.
</p>
<p>
Example models using the configurations are provided in 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples</a>
and
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples</a>.
It is recommended that the user read the documentation of each example model
carefully to understand their implementation, demonstration intent, and observations. 
</p>
    <h4>Configurations for active networks</h4>
    <p>
    The following table presents the configurations compatible
    with such networks.
    </p>
    <table class=\"releaseTable\" summary=\"Main characteristics\" border=\"2\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr>
    <th>
    Designation
    </th>
    <th>
    Schematic
    </th>
    <th>
    Application
    </th>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Decoupling circuit with self-acting &Delta;p control valve
    </td>
    <td valign=\"top\">
    <img alt=\"Decoupling circuit Delta-p\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Decoupling.png\"/>
    </td>
    <td valign=\"top\">
    Used for variable flow
    primary and consumer circuits where the
    consumer circuit has the same supply temperature set point as the
    primary circuit.
    The fixed bypass prevents the primary pressure differential from being
    transmitted to the consumer circuit.
    This allows a proper operation of the terminal
    control valves when the primary pressure differential is either
    too low or too high or varying too much.
    The self-acting &Delta;p control valve maintains a nearly constant
    bypass mass flow rate.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Decoupling circuit with &Delta;T control
    </td>
    <td valign=\"top\">
    <img alt=\"Decoupling circuit Delta-T\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DecouplingTemperature.png\"/>
    </td>
    <td valign=\"top\">
    This configuration is nearly similar to
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Decoupling</a>
    except that an actuated control valve is used to control the &Delta;T between
    the secondary and primary return, ensuring a nearly constant <i>fraction</i>
    of flow recirculation in the bypass line.
    This configuration is <i>not included</i> in the package,
    see the example
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingTemperature\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DecouplingTemperature</a>
    for a justification.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Diversion circuit
    </td>
    <td valign=\"top\">
    <img alt=\"Diversion circuit\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Diversion.png\"/>
    </td>
    <td valign=\"top\">
    Used for constant flow
    primary circuits and variable flow consumer circuits where the
    consumer circuit has the same supply temperature set point as the
    primary circuit.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Diversion\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Diversion</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Injection circuit with three-way valve
    </td>
    <td valign=\"top\">
    <img alt=\"Injection circuit with three-way valve\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionThreeWay.png\"/>
    </td>
    <td valign=\"top\">
Used for constant flow primary and consumer circuits where the
consumer circuit has a different supply temperature set point,
either at design conditions or varying during operation.
Although this configuration may theoretically still be used
if the primary and secondary design temperatures are equal,
it loses its main advantage which is that the
control valve can be sized for a lower flow rate and can therefore
be smaller.
The fixed bypass ensures a consumer circuit operation hydronically decoupled
from the primary side and the control valve position.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionThreeWay\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionThreeWay</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Injection circuit with two-way valve
    </td>
    <td valign=\"top\">
    <img alt=\"Injection circuit with two-way valve\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionTwoWay.png\"/>
    </td>
    <td valign=\"top\">
    Used for variable flow primary circuits and either constant flow or variable
    flow consumer circuits.
    The fixed bypass prevents the primary pressure differential from being
    transmitted to the consumer circuit.
    This allows a proper operation of the terminal control valves on the consumer
    side when the primary pressure differential is either too low or too high or varying too much.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Injection circuit with two-way valve and check valve in bypass branch
    </td>
    <td valign=\"top\">
    <img alt=\"Injection circuit with two-way valve and check valve in bypass branch\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/InjectionTwoWayCheckValve.png\"/>
    </td>
    <td valign=\"top\">
    This configuration is nearly similar to
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
    except for the check valve that is added into the bypass.
    If used in DHC systems and if the control valve is not properly sized
    to maintain the set point at all loads, the check valve prevents recirculation
    in the service line which degrades the &Delta;T in the distribution system.
    If used to connect a heating coil, the check valve reduces the risk
    of freezing in case of secondary pump failure.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWayCheckValve\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWayCheckValve</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Single mixing circuit
    </td>
    <td valign=\"top\">
    <img alt=\"Single mixing circuit\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/SingleMixing.png\"/>
    </td>
    <td valign=\"top\">
    Used for variable flow primary circuits and
    either constant flow or variable flow secondary circuits that
    have a design supply temperature identical to the primary circuit
    but a varying set point during operation.
    The control valve should be sized with a pressure drop equal
    to the primary pressure differential.
    That pressure drop must be compensated for by the secondary
    pump which excludes the use of this configuration to
    applications with a high primary pressure differential.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Throttle circuit
    </td>
    <td valign=\"top\">
    <img alt=\"Throttle circuit\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Throttle.png\"/>
    </td>
    <td valign=\"top\">
    Used for variable flow primary and consumer circuits that have the same supply
    temperature set point.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Throttle\">
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Throttle</a>
    for further details.
    </td>
    </tr>
    </table>

    <h4>Configurations for passive networks</h4>
    <p>
    The following table presents the configurations compatible with such networks.
    </p>
    <table class=\"releaseTable\" summary=\"Main characteristics\" border=\"2\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr>
    <th>
    Designation
    </th>
    <th>
    Schematic
    </th>
    <th>
    Application
    </th>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Dual mixing circuit
    </td>
    <td valign=\"top\">
    <img alt=\"Dual mixing circuit\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/DualMixing.png\"/>
    </td>
    <td valign=\"top\">
    Used instead of
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>
when the primary and secondary circuits have a different design supply temperature.
Contrary to the single mixing circuit,
the use of this configuration is restricted to constant flow secondary circuits
due to the constraint on the fixed bypass pressure differential that must remain sufficiently
high.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing\">
    Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing</a>
    for further details.
    </td>
    </tr>
    <!-- -->
    <tr>
    <td valign=\"top\">
    Single mixing circuit
    </td>
    <td valign=\"top\">
    <img alt=\"Single mixing circuit\"
    src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/PassiveNetworks/SingleMixing.png\"/>
    </td>
    <td valign=\"top\">
    Used for variable flow primary circuits and
    either constant flow or variable flow secondary circuits that
    have a design supply temperature identical to the primary circuit
    but a varying set point during operation.<br/>
    See
    <a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing\">
    Buildings.Fluid.HydronicConfigurations.PassiveNetworks.SingleMixing</a>
    for further details.
    </td>
    </tr>
    </table>
    </html>"));

  end Overview;

  class ModelParameters "Description of the model parameters"
    extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<h4>Control valve</h4>
<p>
The characteristic of the control valve can be selected
using the parameter <code>typCha</code>.
The different choices are defined by the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic\">
Buildings.Fluid.HydronicConfigurations.Types.ValveCharacteristic</a>.
</p>
<p>
Each model includes an automatic sizing of the control valve
based on the considerations provided in the model documentation
and considering the two following criteria.
</p>
<ul>
<li>
Valve authority of <i>0.5</i>.
</li>
<li>
Valve design pressure drop higher than <i>3</i>&nbsp;kPa, which is
considered the limit above which the valve characteristic is
valid.
</li>
</ul>
<p>
The sizing of the control valve may be disabled by setting the
parameter <code>use_siz</code> to <code>false</code>.
When disabled, the user must assign a value to <code>dpValve_nominal</code>.
When enabled, the user must assign a value to <code>dp1_nominal</code>
and/or <code>dp2_nominal</code> depending on the configuration,
respectively the pressure differential on the primary side and the pressure
drop of the consumer circuit at design conditions.
</p>
<p>
Note that the sizing rules do not take into account the discrete sizes
of control valves.
Those are available with <i>Kvs</i> values which increase in a geometric
progression, referred to as a Renard series (Petitjean, 1994):
<i>Kvs &isin; {1.0, 1.6, 2.5, 4.0, 6.3, 10.0, 16.0, ...}</i>.
The models from this package do not take into account those discrete
sizes but rather consider that any pressure drop can be achieved at
design conditions.
Also, the models neither take into account the additional
pressure drop of the reducers that are needed when the valve diameter
is lower than the pipe diameter.
</p>
<h4>Distribution pump</h4>
<p>
For configurations with a secondary distribution pump, the user may choose
whether to include the pump in the configuration model or not, using
the parameter <code>typPum</code> from the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.Pump\">
Buildings.Fluid.HydronicConfigurations.Types.Pump</a>.
When included, the user can further select the type of pump using
the same parameter.
Additionally, the user can select the type of pump model with the
parameter <code>typPumMod</code> from the enumeration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Types.PumpModel\">
Buildings.Fluid.HydronicConfigurations.Types.PumpModel</a>.
</p>
<p>
Each model includes an automatic sizing of the optional distribution pump.
By default the secondary pump is parameterized at maximum speed with
<code>m2_flow_nominal</code> and <code>dp2_nominal</code> plus
any additional pressure drop within the hydronic configuration.
The sizing of the pump may be disabled by setting the
parameter <code>use_siz</code> to <code>false</code>.
When disabled, the user must assign a value to <code>mPum_flow_nominal</code>
and <code>dpPum_nominal</code>,
respectively the mass flow rate and total pressure rise at design conditions.
When enabled, the user must assign a value to <code>dp1_nominal</code>
and/or <code>dp2_nominal</code> depending on the configuration,
respectively the pressure differential on the primary side and the pressure
drop of the consumer circuit at design conditions.
</p>
<p>
A default pump characteristic is also provided, which goes through
the design operating point and spans over
<i>0</i> and twice the design flow rate at maximum speed.
This default characteristic is based on a least squares
polynomial fit of the characteristics from
<a href=\"modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo\">
Buildings.Fluid.Movers.Data.Pumps.Wilo</a>,
see Figure 1.
</p>
  <p>
  <img alt=\"Pump characteristic\"
  src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/PumpCharacteristic.png\"/>
  <br/>
  <i>Figure 1. Pump normalized characteristics and least squares polynomial fit.</i>
  </p>
<h4>Balancing valves</h4>
<p>
The balancing valves are configured with zero pressure drop by default.
The user may refer to the documentation of each configuration model for
the specific balancing requirements, and assign the proper values to the
corresponding parameters.
</p>
<ul>
<li>
Primary side balancing valve design pressure drop: <code>dpBal1_nominal</code>
</li>
<li>
Consumer circuit balancing valve design pressure drop: <code>dpBal2_nominal</code>
</li>
<li>
Bypass balancing valve design pressure drop: <code>dpBal3_nominal</code>
</li>
</ul>
<h4>
References
</h4>
<p>
Petitjean, R., 1994. Total hydronic balancing. Tour &amp; Andersson AB, Ljung, Sweden.
</p>
</html>"));
  end ModelParameters;

  class ControlValves "About control valves"
    extends Modelica.Icons.Information;

    annotation (preferredView="info",
  Documentation(info="<html>
<h4>
Two-way valves
</h4>

<h5>
Valve authority (conventional definition)
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
series with the valve (for instance a heat exchanger) tends towards zero
with the decreasing flow rate.
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
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Examples.TwoWayOpenLoop\">
Buildings.Fluid.HydronicConfigurations.Examples.TwoWayOpenLoop</a>
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
The above equation is directly tractable in a numerical model and can effectively
be used to compute the valve authority.
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
open conditions <i>and at design flow rate</i> to the maximum
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
&beta; = &Delta;p<sub>A-B</sub>(y=100%) / &Delta;p<sub>A-B</sub>(y=0%)</i>.
</p>
<p>
<img alt=\"Three-way valve schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/UsersGuide/ThreeWayValveEquivalence.png\"/>
</p>
<p>
The same caveat as in the case of two-way valves holds for the flow rate at
which the pressure drop <i>&Delta;p<sub>A-B</sub>(y=100%)</i> is evaluated.
There is some additional intricacy for evaluating
<i>&Delta;p<sub>A-B</sub>(y=0%) = &Delta;p<sub>J-M</sub>(y=0%)</i>
because that pressure drop depends on the flow rate in the bypass branch.
If the bypass branch is not balanced, the authority given by
the above formula can virtually take any value and is no more representative
of the valve installed characteristic.
Contrary to the pressure drop <i>&Delta;p<sub>A-B</sub>(y=100%)</i> that can be corrected
to account for a given amount of overflow (see the definition of the practical authority)
there is no straightforward correction term that can be formulated for the pressure drop
<i>&Delta;p<sub>A-B</sub>(y=0%)</i>.
So, contrary to the case of two-way valves, there is no generic formulation
directly tractable in a simulation model to compute the authority of a
three-way valve. The above equation requires to \"conceptually\" consider
a balanced bypass when assessing <i>&Delta;p<sub>A-B</sub>(y=0%)</i>.
</p>
<p>
For the common case where the valve is used to modulate the flow rate through
a coil with a design pressure drop <i>&Delta;p<sub>coil</sub></i>
the generic definition of the authority can be rewritten as
<i>&beta; = &Delta;p<sub>A-AB</sub>(y=100%) /
(&Delta;p<sub>A-AB</sub>(y=100%) + &Delta;p<sub>coil</sub>)</i>.
</p>
<h5>
Should the bypass be balanced?
</h5>
<p>
Although this seems as a sound requirement to ensure an actual constant
flow with a constant speed pump, the answer actually depends on the application.
</p>
<ul>
<li>
Not recommended:
In the case where the valve is used in a mixing configuration
with an active primary pressure differential the bypass should not be balanced,
see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.SingleMixing</a>.
</li>
<li>
Not needed in most cases:
In the case where the valve is used in a diversion configuration
a balanced bypass is not needed in most cases as long as the valve
is selected with a sufficient authority (<i>&ge; 0.5</i>) and that the
design pressure drop of the served consumer does not represent a
significant fraction of the design pump head (<i>&le; 40%</i>).
Moreover, a balanced bypass disturbs the linearity of the heat flow
rate variation with the valve opening at low load for an equal percentage and
linear valve characteristic, see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.DiversionOpenLoop</a>.
Another case where a balanced bypass may be needed is for a mixing
circuit connected to a primary passive network.
The balancing valve helps countering any significant back pressure
from other consumer circuits that could lead to a flow reversal
in the primary branch.
The example
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples.SingleMixingOpenLoop</a>
exhibits that phenomenon.
However, the example also shows that if the control valve is selected
with a sufficient authority (and the secondary pump sized with sufficient head)
the risk of flow reversal is avoided.
</li>
</ul>
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
both use a default value of <code>fraK=0.7</code> for the ratio of
the <i>Kvs</i> coefficient between the bypass branch and the
direct branch.
This default setting yields a pressure drop in the
bypass branch <i>&Delta;p<sub>L-M</sub>(y=0%)</i> that is
<i>1 / 0.7<sup>2</sup> &asymp; 2</i> times higher at design flow rate
than the pressure drop in the
direct branch <i>&Delta;p<sub>A-B</sub>(y=100%)</i>.
If the valve is used in a diversion arrangement to modulate the flow
rate through a heat exchanger, and if the valve is
sized with an authority of <i>&beta; = 0.5</i>
this default setting implies that the bypass is balanced.
However,
</p>
<ul>
<li>
the corresponding flow resistance is variable (with the
valve opening) as opposed to the fixed flow resistance provided by a
balancing valve,
</li>
<li>
when trying to match results published by valve manufacturers such as
in Petitjean (1996), the setting <code>fraK=1.0</code> appears more consistent,
</li>
<li>
when used in a different configuration (such as
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.SingleMixing\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.SingleMixing</a>)
the setting <code>fraK=0.7</code> may cause sizing issues.
</li>
</ul>
<p>
For those reasons the default setting for all three-way valve components
within this package is <code>fraK=1.0</code> unless specified otherwise.
</p>
<h4>
References
</h4>
<p>
Petitjean, R., 1994. Total hydronic balancing. Tour &amp; Andersson AB, Ljung, Sweden.
</p>
</html>"));

  end ControlValves;

  class NomenclatureSymbols "Nomenclature and symbols"
    extends Modelica.Icons.Information;

    annotation (preferredView="info",
  Documentation(info="<html>
<h4>Nomenclature</h4>

<h5>Active network</h5>
<p>
An active network is defined as a network where the pressure
differential at the boundaries of each connected consumer circuit
is primarily driven by the primary circuit circulating pump.
</p>
<p>
The primary circuit is necessarily equipped with a circulating
pump.
The connected consumer circuits may be equipped with
a circulating pump or not.
</p>

<h5>Passive network</h5>
<p>
A passive network is defined as a network where the pressure
differential at the boundaries of each connected consumer circuit
is primarily driven by the consumer circuit circulating pump.
</p>
<p>
The connected consumer circuits are necessarily equipped with
a circulating pump.
However, the primary circuit may be equipped with a circulating
pump or not.
In the former case, a decoupling device (such as a fixed bypass,
a hydraulic separator, or a supply-through loop) is used to
cancel out the pressure differential created by the primary pump.
</p>

<h5>Primary circuit</h5>
<p>
The word \"primary\" is used to refer to the source-side
circuit which distributes heat or cold and connects
with the central plant.
</p>
<p>
Note that if the central plant already uses a primary-secondary
arrangement, then what is called the \"primary\" circuit
is this package is actually the \"secondary circuit\".
</p>
<h5>Secondary (consumer) circuit</h5>
<p>
The word \"secondary\" or \"consumer\" is used to refer
to the load-side circuit that integrates the terminal units.
</p>
<p>
Note that if the central plant already uses a primary-secondary
arrangement, then what is called the \"secondary\" circuit
is this package is actually the \"tertiary circuit\".
</p>


<h4>Symbols</h4>
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
<td>Self-acting &Delta;p control valve (the dotted lines represent the capillary pipes for pressure measurement)</td>
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
This package contains standard configurations used in hydronic circuits,
either for heating or cooling applications.
They have been selected based mainly on the publications from
Petitjean (1994) and HERZ® (2015).
</p>
<h4>
References
</h4>
<p>
HERZ®, 2015. Hydraulics in HVAC applications. HERZ® Armaturen GmbH.
</p>
<p>
Petitjean, R., 1994. Total hydronic balancing. Tour &amp; Andersson AB, Ljung, Sweden.
</p>
</html>"));
end UsersGuide;
