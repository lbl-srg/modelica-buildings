within Buildings.Experimental.Templates.AHUs.Coils.Actuators.Data;
record TwoWayValve
  extends None;
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0) = 0
    "Nominal pressure drop of pipes and other equipment in flow leg"
    annotation(Dialog(group="Nominal condition"));
end TwoWayValve;
