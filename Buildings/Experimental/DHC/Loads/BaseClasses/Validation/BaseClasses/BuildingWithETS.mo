within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model BuildingWithETS
  "Dummy building with ETS model for validation purposes"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    redeclare ETS ets,
    redeclare Building bui);
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end BuildingWithETS;
