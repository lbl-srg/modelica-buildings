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

  parameter Integer nPum "Number of primary pumps";

  final parameter Boolean is_none=
    typ <> Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None;

  Bus busCon(final nPum=nPum)
             if not is_none
             "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
              Icon(graphics={
              Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end SecondaryPumpGroup;
