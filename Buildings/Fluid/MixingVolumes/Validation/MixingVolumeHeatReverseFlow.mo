within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeHeatReverseFlow
  "Validation model for mixing volume with heat input and flow reversal"
  extends
    Buildings.Fluid.MixingVolumes.Validation.BaseClasses.MixingVolumeReverseFlow(
      gain(k=10));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaDyn
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaSte
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  connect(gain.y, preHeaDyn.Q_flow) annotation (Line(points={{-19,40},{-12,40},
          {-12,60},{0,60}}, color={0,0,127}));
  connect(gain.y, preHeaSte.Q_flow)
    annotation (Line(points={{-19,40},{-9.5,40},{0,40}}, color={0,0,127}));
  connect(preHeaDyn.port, volDyn.heatPort) annotation (Line(points={{20,60},{30,
          60},{30,26},{0,26},{0,10},{10,10}}, color={191,0,0}));
  connect(preHeaSte.port, volSte.heatPort) annotation (Line(points={{20,40},{26,
          40},{26,28},{-2,28},{-2,-40},{10,-40}}, color={191,0,0}));
annotation (Documentation(
        info="<html>
<p>
This model validates the use of the mixing volume with air flowing into and out of the volume
and sensible heat added to the volume.
</p>
<p>
The model <code>volDyn</code> uses a dynamic balance,
whereas the model <code>volSte</code> uses a steady-state balance.
The mass flow rate starts positive and reverses its direction at <i>t=5</i> seconds.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeHeatReverseFlow.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-08, StopTime=10));
end MixingVolumeHeatReverseFlow;
