within Buildings.Experimental.OpenBuildingControl.CDL.Types;
type InitPID = enumeration(
    NoInit
      "No initialization (start values are used as guess values with fixed=false)",
    SteadyState
      "Steady state initialization (derivatives of states are zero)",
    InitialState "Initialization with initial states",
    InitialOutput
      "Initialization with initial outputs (and steady state of the states if possible)",
    DoNotUse_InitialIntegratorState
      "Do not use, only for backward compatibility (initialize only integrator state)")
  "Enumeration defining initialization of PID and LimPID blocks" annotation (
    Evaluate=true, Documentation(info="<html>
<p>
This initialization type is identical to <a href=\"modelica://Modelica.Blocks.Types.Init\">Types.Init</a> and has just one
additional option <strong><code>DoNotUse_InitialIntegratorState</code></strong>. This option
is introduced in order that the default initialization for the
<code>Continuous.PID</code> and <code>Continuous.LimPID</code> blocks are backward
compatible. In Modelica 2.2, the integrators have been initialized
with their given states where as the D-part has not been initialized.
The option <strong><code>DoNotUse_InitialIntegratorState</code></strong> leads to this
initialization definition.
</p>

 <p>The following initialization alternatives are available:</p>
  <dl>
    <dt><code><strong>NoInit</strong></code></dt>
      <dd>No initialization (start values are used as guess values with <code>fixed=false</code>)</dd>
    <dt><code><strong>SteadyState</strong></code></dt>
      <dd>Steady state initialization (derivatives of states are zero)</dd>
    <dt><code><strong>InitialState</strong></code></dt>
      <dd>Initialization with initial states</dd>
    <dt><code><strong>InitialOutput</strong></code></dt>
      <dd>Initialization with initial outputs (and steady state of the states if possible)</dd>
    <dt><code><strong>DoNotUse_InitialIntegratorState</strong></code></dt>
      <dd>Do not use, only for backward compatibility (initialize only integrator state)</dd>
  </dl>
</html>"));
