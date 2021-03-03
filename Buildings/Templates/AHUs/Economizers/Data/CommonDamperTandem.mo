within Buildings.Experimental.Templates.AHUs.Economizers.Data;
record CommonDamperTandem
  extends CommonDamperFreeNoRelief;

  // FIXME: Dummy default values fo testing purposes only.

  // TEST WITH NO DEFAULT

  parameter Modelica.SIunits.MassFlowRate mExh_flow_nominal
    "Mass flow rate exhaust air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamExh_nominal(
    min=0, displayUnit="Pa") = 20
    "Pressure drop of damper in exhaust air leg"
     annotation (Dialog(group="Nominal condition"));

  annotation (
    defaultComponentName="datEco",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperTandem;
