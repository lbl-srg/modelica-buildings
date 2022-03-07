within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces;
partial model PartialCoolingTowerGroup
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare package Medium=Buildings.Media.Water);

  parameter Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.Data dat "Cooling tower group data";

  outer parameter Integer nChi "Number of chillers"
  annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nCooTow(final min=1)
  "Number of cooling towers (count one tower for each cell)"
  annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow)
    "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{30,80},{70,120}}),
      iconTransformation(extent={{40,90},{60,110}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCoolingTowerGroup;
