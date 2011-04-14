within Buildings;
package Media "Package with medium models"
  extends Modelica.Icons.MaterialPropertiesPackage;

  annotation (preferedView="info", Documentation(info="<html>
This package contains different implementations for
various media.
The media models in this package are
compatible with 
<a href=\"Modelica:Modelica.Media\">
Modelica.Media</a> 
but the implementation is in general simpler, which often 
leads to easier numerical problems and better convergence of the
models.
Due to the simplifications, the media model of this package
are generally accurate for a smaller temperature range than the 
models in <a href=\"Modelica:Modelica.Media\">
Modelica.Media</a>, but the smaller temperature range may often be 
sufficient for building HVAC applications. 
</html>"));
end Media;
