within Buildings.Templates.AirHandlersFans.Components.HeatRecovery;
model None "No heat recovery"
  extends
    .Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialHeatRecovery(
     final typ=Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None);

  annotation (Documentation(info="<html>
<p>
This model represents a configuration with no heat recovery unit.
It resolves to four fluid ports that are not connected
to each other and for which pressure conditions must be provided.
</p>
</html>"));
end None;
