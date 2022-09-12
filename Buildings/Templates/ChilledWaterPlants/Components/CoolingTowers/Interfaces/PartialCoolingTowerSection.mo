within Buildings.Templates.ChilledWaterPlants.Components.CoolingTowers.Interfaces;
partial model PartialCoolingTowerSection "Partial cooling tower section model"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare package Medium=Buildings.Media.Water,
    final m_flow_nominal = dat.m_flow_nominal);

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlants.Types.CoolingTowerSection
    typ "Type of cooling tower arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  outer parameter Integer nChi "Number of chillers";
  parameter Integer nCooTow(final min=1)
    "Number of cooling towers (count one tower for each cell)"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // Record

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowers.Interfaces.Data
    dat(final typ=typ, final nCooTow=nCooTow) "Cooling tower section data";

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus busCon
                             "Control bus" annotation (Placement(transformation(
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
end PartialCoolingTowerSection;
