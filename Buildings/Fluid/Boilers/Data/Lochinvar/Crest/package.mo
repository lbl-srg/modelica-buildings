within Buildings.Fluid.Boilers.Data.Lochinvar;
package Crest "Package with performance data for Lochinvar Crest boilers"
  extends Modelica.Icons.Package;

    annotation (
    defaultComponentPrefixes = "parameter",
    Documentation(info="<html>
<p>
This package contains performance data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/\">
https://www.lochinvar.com/products/commercial-boilers/crest-condensing-boiler/</a>.
All models use the same set of efficiency curves 
(from <a href=\"https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf\">
https://www.lochinvar.com/lit/595403Crest_Efficiency_Curve.pdf</a>) 
which is implemented in
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves\">
Buildings.Fluid.Boilers.Data.Lochinvar.Crest.Curves</a>.
Specifications of each model (from 
<a href=\"https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf\">
https://www.lochinvar.com/lit/961107FBN-PS-17%20(2501-6001).pdf</a>
) are implemented individually in the rest of the records. 
</p>
</html>",   revisions="<html>
<ul>
<li>
November 1, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end Crest;
