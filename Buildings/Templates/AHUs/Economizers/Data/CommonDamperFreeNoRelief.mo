within Buildings.Templates.AHUs.Economizers.Data;
record CommonDamperFreeNoRelief
  extends Interfaces.Data.Economizer;

  parameter Modelica.SIunits.MassFlowRate mOut_flow_nominal=
    dat.getReal(varName=id + ".Supply air mass flow rate")
    "Mass flow rate outside air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamOut_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Economizer.OA damper pressure drop")
    "Pressure drop of damper in outside air leg"
     annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate mRec_flow_nominal=
    dat.getReal(varName=id + ".Return air mass flow rate")
    "Mass flow rate recirculation air damper"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDamRec_nominal(
    min=0, displayUnit="Pa")=
    dat.getReal(varName=id + ".Economizer.RA damper pressure drop")
    "Pressure drop of damper in recirculation air leg"
     annotation (Dialog(group="Nominal condition"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;
