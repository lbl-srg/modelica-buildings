within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model BuildingWithETS
  "Dummy building with ETS model for validation purposes"
  extends
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    redeclare ETS ets,
    redeclare Building bui);
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(info="<html>
<p> 
This is a minimum example of a class extending 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS</a>
developed for testing purposes only.
</p>
</html>"));
end BuildingWithETS;
