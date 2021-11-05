within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces;
partial model SecondaryPumpGroup
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare package Medium=Buildings.Media.Water);

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup
    typ "Type of chilled water secondary pump group"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Integer nPum = 1 "Number of primary pumps";

  Bus busCon "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Modelica.Fluid.Interfaces.FluidPort_b port_comLeg(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if not is_none
    "Common leg outlet"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));

protected
  parameter Boolean is_none = typ <>Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Icon(graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end SecondaryPumpGroup;
