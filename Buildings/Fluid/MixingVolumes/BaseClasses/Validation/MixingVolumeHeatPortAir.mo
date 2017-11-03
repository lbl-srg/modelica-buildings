within Buildings.Fluid.MixingVolumes.BaseClasses.Validation;
model MixingVolumeHeatPortAir
  "Validation model for setting the initialization of the pressure for air"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.Validation.MixingVolumeHeatPortWater(
    redeclare package Medium = Buildings.Media.Air);

  annotation (Documentation(info="<html>
<p>
Model that validates that the initial conditions are uniquely set
and not overdetermined for water.
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2017 by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=1.0),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/BaseClasses/Validation/MixingVolumeHeatPortAir.mos"
        "Simulate and plot"));
end MixingVolumeHeatPortAir;
