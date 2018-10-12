within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
package Stage
  "Blocks for chiller staging (fixme: these are modular thus extendible and currently hold the sequences needed for the case study)"
  block Controller
    "Determines chiller stage based on the previous stage and the current capacity requirement. fixme: stagin up and down process (delays, etc) should be added."
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Controller;

  block Capacities "Returns nominal capacities at current and one lower stage"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Capacities;

  block CapacityRequirement
    "Required cooling capacity at given flow, chilled water return and supply setpoint temperatures"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CapacityRequirement;

  block ConditionsForPositiveDisplacement
    "Stage change conditions for positive displacement chillers"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ConditionsForPositiveDisplacement;
end Stage;
