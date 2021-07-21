within Buildings.Fluid.MixingVolumes.Validation;
model CoupledVolumesGlycol47
  "Validation model for two coupled volumes with glycol"
  extends Buildings.Fluid.MixingVolumes.Validation.CoupledVolumesWater(
    redeclare package Medium = Modelica.Media.Incompressible.Examples.Glycol47);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Validation model for two directly coupled volumes.
</p>
<p>
This tests whether a Modelica translator can perform the index reduction.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2018, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/910\">IBPSA, issue 910</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/CoupledVolumesGlycol47.mos"
           "Simulate and plot"));
end CoupledVolumesGlycol47;
