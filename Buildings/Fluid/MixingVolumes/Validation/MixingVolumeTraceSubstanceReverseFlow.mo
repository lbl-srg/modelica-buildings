within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeTraceSubstanceReverseFlow
  "Validation model for mixing volume with trace substance input and flow reversal"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.MixingVolumeReverseFlow(
    Medium(extraPropertiesNames={"CO2"}),
    volDyn(use_C_flow=true),
    volSte(use_C_flow=true),
    gain(k=1/1000),
    bou(C={0.003}));

equation
  connect(gain.y, volSte.C_flow[1]) annotation (Line(points={{-19,40},{-10,40},{
          -10,-46},{8,-46}}, color={0,0,127}));
  connect(gain.y, volDyn.C_flow[1]) annotation (Line(points={{-19,40},{-10,40},{
          -10,4},{8,4}}, color={0,0,127}));
annotation (Documentation(
        info="<html>
<p>
This model validates the use of the mixing volume with air flowing into and out of the volume
and trace substances added to the volume.
</p>
<p>
The model <code>volDyn</code> uses a dynamic balance,
whereas the model <code>volSte</code> uses a steady-state balance.
The mass flow rate starts positive and reverses its direction at <i>t=5</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
December 7, 2016, by Michael Wetter:<br/>
Set <code>bou(C={0.003})</code> to avoid a negative value for
<code>C_outflow</code> of the steady state volume.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/613\">#613</a>.
</li>
<li>
January 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeTraceSubstanceReverseFlow.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-08, StopTime=10));
end MixingVolumeTraceSubstanceReverseFlow;
