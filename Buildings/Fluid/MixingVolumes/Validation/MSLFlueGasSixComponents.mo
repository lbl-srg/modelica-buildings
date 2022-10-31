within Buildings.Fluid.MixingVolumes.Validation;
model MSLFlueGasSixComponents
  "Test model with medium for flue gas from the Modelica Standard Library"
    extends Buildings.Fluid.MixingVolumes.Validation.MSLCombustionAir(
      redeclare package Medium =
        Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents);

  annotation (
  experiment(
    Tolerance=1E-6,
    StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MSLFlueGasSixComponents.mos"
        "Simulate and plot"),
    Documentation(
info = "<html>
<p>
This model verifies that basic fluid flow components also
work with a medium model from the Modelica Standard Library
for flue gas with six components.
</p>
<p>
This medim differs from media in the Buildings library in that it sets <code>reducedX=false</code>.
</p>
</html>",
revisions = "<html>
<ul>
<li>
October 24, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1650\">#1650</a>.
</li>
</ul>
</html>"));
end MSLFlueGasSixComponents;
