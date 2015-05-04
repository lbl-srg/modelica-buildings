within Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests;
package Test4NodesFeeder "This package contains models for the IEEE 4 nodes test feeder"
extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p>
This package contains examples that shows the validation of the models
against the IEEE four-nodes test feeder validation procedure <a href=\"#\"></a>.
The tests that are part of the validation certify the capability to represent
transformers of various configurations, full three-phase lines, and unbalanced loads.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Electrical/AC/ThreePhasesUnbalanced/Validation/IEEETests/Test4nodesFeeder/IEEE_4nodes_schema.png\"/>
</p>
<p>
The figure shows the structure of the four-nodes network. The voltage
source is connected to the load through two lines and a transformer. The validation procedure
consists of mutliple tests in which the type of the load and the type of the transformer vary.
The test cases that have been successfully implemented using the models of the
<a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a>
package.
</p>
<p>
Each example in this package is part of the validation tests.
The examples have been grouped into sub-packages depending on the characteristics
of the validation test. The table below summarizes the examples that are part of this
package.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
  <th>Transformer</th>
  <th>Load</th>
</tr>
<tr>
  <td>Gr Y - Gr Y Step Up</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>Gr Y - D Step Up</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>D - D Step Up</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>Gr Y - Gr Y Step Down</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>Gr Y - D Step Down</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>D - D Step Down</td>
  <td>Balanced</td>
</tr>
<tr>
  <td>Gr Y - Gr Y Step Up</td>
  <td>Unbalanced</td>
</tr>
<tr>
  <td>Gr Y - D Step Up</td>
  <td>Unbalanced</td>
</tr>
<tr>
  <td>D - D Step Up</td>
  <td>Unbalanced</td>
</tr>
<tr>
  <td>Gr Y - Gr Y Step Down</td>
  <td>Unbalanced</td>
</tr>
<tr>
  <td>Gr Y - D Step Down</td>
  <td>Unbalanced</td>
</tr>
<tr>
  <td>D - D Step Down</td>
  <td>Unbalanced</td>
</tr>
</table>

<p>
For example Gr Y - D Step Up indicates that the transformer has a grounded Y connection at the primary
side, and a D connection at the secondary side. Step up indicates that the voltage at the secondary
side is higher than the primary side.
Each test listed in the table produces results that differ from the reference IEEE values by
less than 0.05%, which is the threshold defined by IEEE to determine whether results should be accepted or not.
</p>

<h4>References</h4>
<p>
<a NAME=\"kersting2001radial\"/>
Kersting, William H.<br/>
<a href=\"http://ewh.ieee.org/soc/pes/dsacom/testfeeders/\">
Radial distribution test feeders</a><br/>
<i>Power Engineering Society Winter Meeting (2) p. 908-912, 2001. IEEE</i><br/>
</p>

</html>", revisions="<html>
<ul>
<li>
October 8, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Test4NodesFeeder;
