within Buildings.Templates.AHUs.Coils.Actuators.Data;
record TwoWayValve
  extends Interfaces.Data.Actuator;

  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)=
    dat.getReal(varName=id + "." + funStr + " coil valve.Pressure drop")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0)=dpWat_nominal
    "Nominal pressure drop of pipes and other equipment in flow leg"
    annotation(Dialog(group="Nominal condition"));
end TwoWayValve;
