within Buildings.Rooms.Examples;
package TestConditionalConstructions "Package that tests if constructions can be conditionally removed"
  extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
The thermal zone model
<a href=\"Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
allows the conditional declaration of constructions for
exterior walls without windows, for exterior walls with windows,
for partition walls, for interior surfaces,
and for interior surfaces.
The models in this package test if the model is well-defined
if such constructions are removed.
The models in this package do not represent realistic buildings, but
are rather designed to test the thermal zone model.
</html>", revisions="<html>
<ul>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestConditionalConstructions;
