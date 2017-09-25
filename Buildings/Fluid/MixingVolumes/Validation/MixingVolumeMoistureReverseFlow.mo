within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeMoistureReverseFlow
  "Validation model for mixing volume with moisture input and flow reversal"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.MixingVolumeReverseFlow(
    gain(k=0.005),
    redeclare MixingVolumeMoistAir volDyn,
    redeclare MixingVolumeMoistAir volSte);

equation
  connect(volDyn.mWat_flow, gain.y) annotation (Line(points={{8,18},{-2,18},{-10,
          18},{-10,40},{-19,40}}, color={0,0,127}));
  connect(gain.y, volSte.mWat_flow) annotation (Line(points={{-19,40},{-10,40},{
          -10,-32},{8,-32}}, color={0,0,127}));
  annotation (Documentation(
        info="<html>
<p>
This model validates the use of the mixing volume with air flowing into and out of the volume
and moisture added to the volume.
</p>
<p>
The model <code>volDyn</code> uses a dynamic balance,
whereas the model <code>volSte</code> uses a steady-state balance.
The mass flow rate starts positive and reverses its direction at <i>t=5</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
March 9, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeMoistureReverseFlow.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=10));
end MixingVolumeMoistureReverseFlow;
