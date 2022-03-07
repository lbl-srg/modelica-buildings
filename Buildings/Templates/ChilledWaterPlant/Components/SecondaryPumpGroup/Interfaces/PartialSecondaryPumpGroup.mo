within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces;
partial model PartialSecondaryPumpGroup
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare replaceable package Medium=Buildings.Media.Water);

  parameter Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.Data dat
    "Secondary pump group data";

  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow) if not dat.is_none
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
        coordinateSystem(preserveAspectRatio=false)));
end PartialSecondaryPumpGroup;
