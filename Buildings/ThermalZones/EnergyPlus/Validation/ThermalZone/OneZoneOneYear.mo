within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model OneZoneOneYear
  "Validation model for one zone"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned;
  Controls.OBC.CDL.Continuous.MovingMean TAirMea(
    delta(
      displayUnit="d")=86400,
    y(
      final unit="K",
      displayUnit="degC"))
    "Moving mean of air temperature"
    annotation (Placement(transformation(extent={{60,8},{80,28}})));

equation
  connect(TAirMea.u,zon.TAir)
    annotation (Line(points={{58,18},{41,18}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case that simulates a building with
one thermal zone for one year.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/OneZoneOneYear.mos" "Simulate and plot"),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06));
end OneZoneOneYear;
