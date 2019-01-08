within Buildings.Fluid.MixingVolumes.BaseClasses.Validation;
model MixingVolumeHeatMoisturePort
  "Validation model for setting the initialization of the pressure for model with moisture port"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.Validation.MixingVolumeHeatPortWater(
    redeclare package Medium = Buildings.Media.Air,
    redeclare Buildings.Fluid.MixingVolumes.BaseClasses.MixingVolumeHeatMoisturePort vol);

  Modelica.Blocks.Sources.Constant const[nEle](each k=0) "Zero input signal"
    annotation (Placement(transformation(extent={{-60,28},{-40,48}})));
equation
  connect(const.y, vol.mWat_flow)
    annotation (Line(points={{-39,38},{-12,38}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Model that validates that the initial conditions are uniquely set
and not overdetermined.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2019 by Michael Wetter:<br/>
Removed erroneous <code>each</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1068\">Buildings, issue 1068</a>.
</li>
<li>
October 23, 2017 by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1E-6, StopTime=1.0),
__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/BaseClasses/Validation/MixingVolumeHeatMoisturePort.mos"
  "Simulate and plot"));
end MixingVolumeHeatMoisturePort;
