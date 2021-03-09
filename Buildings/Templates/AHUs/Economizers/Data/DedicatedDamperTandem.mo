within Buildings.Templates.AHUs.Economizers.Data;
record DedicatedDamperTandem
  extends CommonDamperTandem;

  parameter Modelica.SIunits.MassFlowRate mOutMin_flow_nominal=
    dat.getReal(varName=id + ".Minimum OA mass flow rate")
    "Mass flow rate minimum outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOutMin_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Minimum OA damper pressure drop")
    "Pressure drop of damper in minimum outside air leg"
     annotation (Dialog(group="Nominal condition"));

end DedicatedDamperTandem;
