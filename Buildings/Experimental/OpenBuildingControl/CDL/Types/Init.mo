within Buildings.Experimental.OpenBuildingControl.CDL.Types;
type Init = enumeration(
    NoInit
      "No initialization (start values are used as guess values with fixed=false)",
    SteadyState
      "Steady state initialization (derivatives of states are zero)",
    InitialState "Initialization with initial states",
    InitialOutput
      "Initialization with initial outputs (and steady state of the states if possible)")
  "Enumeration defining initialization of a block" annotation (Evaluate=true,
  Documentation(info="<html>
  <p>The following initialization alternatives are available:</p>

<table summary=\"summary\" border=\"1\">
<tr><td><code><strong>NoInit</strong></code></td><td>No initialization (start values are used as guess values with <code>fixed=false</code>)</td></tr>
<tr><td><code><strong>SteadyState</strong></code></td><td>Steady state initialization (derivatives of states are zero)</td></tr>
<tr><td><code><strong>InitialState</strong></code></td><td>Initialization with initial states</td></tr>
<tr><td><code><strong>InitialOutput</strong></code></td><td>Initialization with initial outputs (and steady state of the states if possible)</td></tr>
</table>
<br/>

  </html>", revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
