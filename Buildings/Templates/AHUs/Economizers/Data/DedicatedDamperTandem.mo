within Buildings.Experimental.Templates.AHUs.Economizers.Data;
record DedicatedDamperTandem
  extends CommonDamperTandem;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal=1
    "Mass flow rate minimum outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal(
    min=0, displayUnit="Pa")=20
    "Pressure drop of damper in minimum outside air leg"
     annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpFixOutMin_nominal(
    min=0, displayUnit="Pa") = 0
    "Pressure drop of duct and other resistances in minimum outside air leg"
     annotation (Dialog(group="Nominal condition"));

end DedicatedDamperTandem;
