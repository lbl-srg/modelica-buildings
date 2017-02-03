within Buildings.Fluid;
package MixingVolumes "Package with mixing volumes"
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>
This package contains models for completely mixed volumes.
</p>
<p>
For most situations, the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> should be used.
The other models are only of interest if water should be added to
or subtracted from the fluid volume, such as in a
coil with water vapor condensation.
</p>
</html>"));
end MixingVolumes;
