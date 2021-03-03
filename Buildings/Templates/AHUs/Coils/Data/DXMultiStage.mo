within Buildings.Experimental.Templates.AHUs.Coils.Data;
record DXMultiStage
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Boolean have_dryCon = true
    "Set to true for purely sensible cooling of the condenser";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=1
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=200
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  replaceable parameter
    Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
    constrainedby Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    annotation(choicesAllMatching=true);

  annotation (
    defaultComponentName="datCoiCoo",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DXMultiStage;
