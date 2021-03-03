within Buildings.Experimental.Templates.AHUs.Economizers.Data;
record CommonDamperFreeNoRelief
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal = 1
    "Mass flow rate outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal(
    min=0, displayUnit="Pa") = 20
    "Pressure drop of damper in outside air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal = 1
    "Mass flow rate recirculation air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamRec_nominal(
    min=0, displayUnit="Pa") = 20
    "Pressure drop of damper in recirculation air leg"
     annotation (Dialog(group="Nominal condition"));

  annotation (
    defaultComponentName="datEco",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;
