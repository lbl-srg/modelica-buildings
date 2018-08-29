within Buildings.Controls.OBC.CDL.Types;
type Init = enumeration(
    NoInit "No initialization (start values are used as guess values)",
    InitialState "Initialization with initial states",
    InitialOutput "Initialization with initial outputs")
  "Enumeration defining initialization of a block" annotation (Evaluate=true,
    Documentation(info="<html>
<p>
Enumeration for the type of initialization that is used for state variables.
The possible values are:
</p>
<table summary=\"summary\" border=\"1\">
<tr><td><code>NoInit</code></td><td>No initialization (start values are used as guess values with <code>fixed=false</code>).
</td></tr>
<tr><td><code>InitialState</code></td>
<td>Initialization with initial states.</td></tr>
<tr><td><code>InitialOutput</code></td>
<td>Initialization with initial outputs (and steady state of the states if possible).
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
April 25, 2017, by Jianjun Hu:<br/>
Removed SteadyState initialization type so to avoid global analysis when implementing it in CDL.
</li>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
