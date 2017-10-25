within Buildings.Fluid.MixingVolumes.BaseClasses;
model MixingVolumeHeatPort
  "Mixing volume with heat port and initialize_p not set to final"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
      T(start=T_start)) "Heat port for heat exchange with the control volume"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
equation
    connect(heaFloSen.port_a, heatPort)
      annotation (Line(points={{-90,0},{-100,0},{-100,0}}, color={191,0,0}));

  annotation (
  defaultComonentName="vol",
  Documentation(info="<html>
<p>
Mixing volume with a heat port.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume</a>,
except that it has a heat port.
</p>
<p>
Note that this model is typically only used to implement new component models that
have staggered volumes.
In contrast to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>, it does
not set <code>initialize_p</code> to <code>final</code> in order
for this model to be usable in staggered volumes which require one
pressure to be set to <code>initialize_p = not Medium.singleState</code>
and all others to <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 19, 2017, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
</ul>
</html>"));
end MixingVolumeHeatPort;
