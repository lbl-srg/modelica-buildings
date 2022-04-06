within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces;
partial model PartialSecondaryPumpGroup
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare replaceable package Medium=Buildings.Media.Water);

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup typ
    "Type of chilled water secondary pump group"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Integer nPum "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  // Record

  parameter Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.Data dat(
    final typ=typ,
    final nPum=nPum)
    "Secondary pump group data";


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
