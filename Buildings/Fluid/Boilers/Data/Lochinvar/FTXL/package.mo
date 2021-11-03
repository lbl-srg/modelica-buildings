within Buildings.Fluid.Boilers.Data.Lochinvar;
package FTXL "Package with performance data for Lochinvar FTXL™ Fire Tube boilers"
  extends Modelica.Icons.Package;

    annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This package contains performance data from
<a href=\"https://www.lochinvar.com/products/commercial-boilers/ftxl-fire-tube-boiler/\">
https://www.lochinvar.com/products/commercial-boilers/ftxl-fire-tube-boiler/</a>.
All models use the same set of efficiency curves 
(from <a href=\"https://www.lochinvar.com/lit/FTXL%20Efficiency%20Curve.pdf\">
https://www.lochinvar.com/lit/FTXL%20Efficiency%20Curve.pdf</a>) 
which is implemented in
<a href=\"modelica://Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.Curves\">
Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.Curves</a>.
Specifications of each model (from 
<a href=\"https://www.lochinvar.com/lit/FTX-PS-02.pdf\">
https://www.lochinvar.com/lit/FTX-PS-02.pdf</a>
) are implemented individually in the rest of the records. 
</p>
</html>"));
end FTXL;
