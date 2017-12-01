within Buildings.Fluid;
package Sensors "Package with sensor models"
  extends Modelica.Icons.SensorsPackage;
annotation (preferredView="info",
Documentation(info="<html>
<p>
Package <code>Sensors</code> consists of idealized sensor components that
provide variables of a medium as
output signals. These signals can be, e.g., further processed
with components of the
<a href=\"modelica://Modelica.Blocks\">
Modelica.Blocks</a>
library.
</p>
</html>",
      revisions="<html>
<ul>
<li><i>22 Dec 2008</i>
    by R&uuml;diger Franke
    <ul>
    <li>flow sensors based on Modelica.Fluid.Interfaces.PartialTwoPort</li>
    <li>adapted documentation to stream connectors, i.e. less need for two port sensors</li>
    </ul>
</li>
<li><i>4 Dec 2008</i>
    by Michael Wetter<br/>
       included sensors for trace substance</li>
<li><i>31 Oct 2007</i>
    by Carsten Heinrich<br/>
       updated sensor models, included one and two port sensors for thermodynamic state variables</li>
</ul>
</html>"));
end Sensors;
