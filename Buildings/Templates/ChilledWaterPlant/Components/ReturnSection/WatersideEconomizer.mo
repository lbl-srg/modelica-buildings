within Buildings.Templates.ChilledWaterPlant.Components.ReturnSection;
model WatersideEconomizer
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.ChilledWaterReturnSection(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.WatersideEconomizer.WatersideEconomizer,
      final is_airCoo = false)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end WatersideEconomizer;
