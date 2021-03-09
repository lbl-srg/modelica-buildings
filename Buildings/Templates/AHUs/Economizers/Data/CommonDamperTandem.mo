within Buildings.Templates.AHUs.Economizers.Data;
record CommonDamperTandem
  extends CommonDamperFreeNoRelief;

  parameter Modelica.SIunits.MassFlowRate mExh_flow_nominal=
    dat.getReal(varName=id + ".Return air mass flow rate")
    "Mass flow rate exhaust air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamExh_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Economizer.EA damper pressure drop")
    "Pressure drop of damper in exhaust air leg"
     annotation (Dialog(group="Nominal condition"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperTandem;
