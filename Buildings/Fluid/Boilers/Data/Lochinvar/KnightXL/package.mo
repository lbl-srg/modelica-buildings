within Buildings.Fluid.Boilers.Data.Lochinvar;
package KnightXL "Package with performance data for Lochinvar Knight™ XL boilers"
  extends Modelica.Icons.Package;

    annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This package contains performance data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/knight-xl/\">
https://www.lochinvar.com/products/commercial-boilers/knight-xl/</a>.
All models use the same set of efficiency curves 
(from <a href=\"https://www.lochinvar.com/lit/643565KNIGHT%20XL%20Curve.pdf\">
https://www.lochinvar.com/lit/643565KNIGHT%20XL%20Curve.pdf</a>) 
which is implemented in
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves\">
Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.Curves</a>.
Specifications of each model (from 
<a href=\"https://www.lochinvar.com/lit/277063KBX-PS-01_2021.pdf\">
https://www.lochinvar.com/lit/277063KBX-PS-01_2021.pdf</a>
) are implemented individually in the rest of the records. 
</p>
</html>"));
end KnightXL;
