within Buildings.Experimental.Templates.AHUs.Coils.Actuators.Data;
record ThreeWayValve
  extends None;
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2](
    each displayUnit="Pa",
    each min=0) = {0, 0}
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation(Dialog(group="Nominal condition"));
end ThreeWayValve;
