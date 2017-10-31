within Buildings.Controls.OBC;
package CDL "Package with blocks, examples and validation tests for control description language"
extends Modelica.Icons.VariantsPackage;

annotation (
Documentation(info="<html>
<p>
Package that has elementary input-output blocks
that form the Control Description Language (CDL).
The implementation is structured into sub-packages.
The packages <code>Validation</code> and <code>Examples</code>
contain validation and example models.
These are not part of the CDL specification, but rather
implemented to provide reference responses computed by the CDL blocks.
For a specification of CDL, see
<a href=\"http://obc.lbl.gov/specification/cdl.html\">
http://obc.lbl.gov/specification/cdl.html</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2016, by Michael Wetter:<br/>
Firt implementation, based on the blocks from the Modelica Standard Library.
</li>
</ul>
</html>"));
end CDL;
