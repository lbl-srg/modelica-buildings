within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.ZoneSurface;
model OneZoneConstantFloorTemperature
  "Validation model with one thermal zone with constant floor temperature"
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_9_6_0.ZoneSurface flo(
    surfaceName="Living:Floor")
    "Floor surface of living room"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Controls.OBC.CDL.Reals.Sources.Constant TFlo(
    k(final unit="K",
      displayUnit="degC")=298.15)
    "Floor temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

equation
  connect(TFlo.y,flo.T)
    annotation (Line(points={{-18,70},{-2,70}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/ZoneSurface/OneZoneConstantFloorTemperature.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Model that uses EnergyPlus and sets the floor temperature to a constant value.
</p>
<p>
When simulated, the heat flow rate at the floor is often around <i>10..20</i> Watts.
However, it becomes negative when the direct solar irradiation is high, indicating that the
net heat flow rate is from the room into the construction due to the solar gains that hit the floor
even though the surface temperature is above the room air and room radiative temperature.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 12, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneZoneConstantFloorTemperature;
