within Buildings.Templates.AHUs.BaseClasses.Dampers.Data;
record Modulated
  extends Interfaces.Data.Damper;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if braStr=="Outdoor air" then
    dat.getReal(varName=id + ".Supply air mass flow rate")
    elseif braStr=="Relief air" then
    dat.getReal(varName=id + ".Return air mass flow rate")
    else
    dat.getReal(varName=id + ".Economizer." + braStr + " mass flow rate")
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Economizer." + braStr + " damper pressure drop")
    "Pressure drop of open damper"
    annotation (Dialog(group="Nominal condition"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Modulated;
