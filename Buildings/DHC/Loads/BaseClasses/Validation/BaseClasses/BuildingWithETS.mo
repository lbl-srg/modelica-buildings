within Buildings.DHC.Loads.BaseClasses.Validation.BaseClasses;
model BuildingWithETS
  "Dummy building with ETS model for validation purposes"
  extends
    Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    redeclare ETS ets,
    redeclare Building bui(
      final QChiWat_flow_nominal=QChiWat_flow_nominal,
      final QHeaWat_flow_nominal=QHeaWat_flow_nominal,
      final m_flow_nominal=ets.m_flow_nominal));
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
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS\">
Buildings.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS</a>
developed for testing purposes only.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingWithETS;
