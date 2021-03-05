within Buildings.ThermalZones.EnergyPlus.Validation.ZoneSurface;
model OneZoneControlledFloorTemperature
  "Validation model with one thermal zone with controlled floor temperature"
  extends ThermalZone.OneZone(building(logLevel=Buildings.ThermalZones.EnergyPlus.Types.LogLevels.Debug));
  Buildings.ThermalZones.EnergyPlus.ZoneSurface flo(surfaceName="Living:Floor")
    "Floor surface of living room"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TFlo(k=303.15)
    "Floor temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(TFlo.y, flo.T)
    annotation (Line(points={{-18,60},{-2,60}}, color={0,0,127}));
end OneZoneControlledFloorTemperature;
