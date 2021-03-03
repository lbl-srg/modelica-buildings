within Buildings.Experimental.Templates.AHUs.Coils.Data;
record WaterBased
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)=1
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=1
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpWat_nominal(
    displayUnit="Pa")=3e4
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=200
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  /*
  Dymola does not accept the declared type below to be 
  HeatExchangers.Data.EffectivenessNTU by default, see info section.
  Cannot see why based on a minimum example. 
  Seems like a false negative syntax check.
  */
  replaceable parameter HeatExchangers.Data.None datHex
    constrainedby HeatExchangers.Data.None
    "Heat exchanger data"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Heat Exchanger"));

  replaceable parameter Actuators.Data.None datAct
    constrainedby Actuators.Data.None
    "Actuator data"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        group="Actuator"));

  annotation (
    defaultComponentName="datCoiCoo",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
If datHex is declared as
</p>
  replaceable parameter HeatExchangers.Data.EffectivenessNTU datHex
    constrainedby HeatExchangers.Data.None
<p>
Dymola gives the following error
</p>
        Translation of Buildings.Experimental.Templates.AHUs.Validation.CoolingCoilDiscretized:

        Inner must be subtype of outer
But missing component Q_flow_nominal.
Error found inside component datHex.
Component outer Buildings.Experimental.Templates.AHUs.Coils.Data.WaterBased datCoi:
File: /home/agautier/gitrepo/modelica-buildings/Buildings/Experimental/Templates/AHUs/Coils/HeatExchangers/Discretized.mo, line 9
Compared to inner Buildings.Experimental.Templates.AHUs.Validation.CoolingCoilDiscretized.RecordCoiCoo datCoi:
File: /home/agautier/gitrepo/modelica-buildings/Buildings/Experimental/Templates/AHUs/Main/VAVSingleDuct.mo, line 151
<p>
No issue (and no warning) with OCT.
Cannot reproduce with minimum example.
</p>
</html>"));
end WaterBased;
