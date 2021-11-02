within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces;
partial model CoolingTowerGroup
  extends Fluid.Interfaces.PartialTwoPort(
    redeclare package Medium=Buildings.Media.Water);

  parameter Buildings.Types.CoolingTowerGroup typ "Type of cooling tower group"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // ToDo: Other CoolingTowerGroup parameters

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  BaseClasses.Bus busCon "Control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  BoundaryConditions.WeatherData.Bus weaBus
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
end CoolingTowerGroup;
