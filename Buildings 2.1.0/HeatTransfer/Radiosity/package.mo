within Buildings.HeatTransfer;
package Radiosity "Package with models for radiosity transfer"
  extends Modelica.Icons.VariantsPackage;


annotation (Documentation(info="<html>
<p>
This package provides component models for the
infrared radiative heat exchange of window assemblies.
The models are according to TARCOG 2006,
except for the outdoor radiosity, which is computed by
<a href=\"modelica://Buildings.HeatTransfer.Radiosity.OutdoorRadiosity\">
Buildings.HeatTransfer.Radiosity.OutdoorRadiosity</a>.
The outdoor radiosity is different from the TARCOG implementation so
that the same equations are used for windows as are used for
opaque walls in the room heat transfer model of the package
<a href=\"modelica://Buildings.Rooms\">
Buildings.Rooms</a>.
</p>
<p>
By definition, incoming and outcoming radiosity are both positive.
This is required to connect incoming and outcoming radiosity connectors.
</p>
<h4>References</h4>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>"));
end Radiosity;
