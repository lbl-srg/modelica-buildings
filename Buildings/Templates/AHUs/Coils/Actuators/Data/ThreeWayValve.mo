within Buildings.Templates.AHUs.Coils.Actuators.Data;
record ThreeWayValve
  extends Interfaces.Data.Actuator;

  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
     displayUnit="Pa",
     min=0)=
    dat.getReal(varName=id + "." + funStr + " coil valve.Pressure drop")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2](
    each displayUnit="Pa",
    each min=0)={1, 1}*
    dat.getReal(varName=id + "." + funStr + " coil.Liquid pressure drop")
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation(Dialog(group="Nominal condition"));
end ThreeWayValve;
