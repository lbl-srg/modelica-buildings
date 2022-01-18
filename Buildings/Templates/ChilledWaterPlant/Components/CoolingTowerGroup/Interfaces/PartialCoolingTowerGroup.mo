within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces;
partial model PartialCoolingTowerGroup
  extends Fluid.Interfaces.PartialTwoPortInterface(
    redeclare package Medium=Buildings.Media.Water);

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.CoolingTowerGroup typ
    "Type of cooling tower group"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Integer nCooTow(final min=1)
    "Number of cooling towers (count one tower for each cell)";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    dat.getReal(varName=id + ".CoolingTower.dp_nominal.value")
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    dat.getReal(varName=id + ".CoolingTower.dpValve_nominal.value")
    "Nominal pressure difference of the valve";
  parameter Real ratWatAir_nominal(
    final min=0,
    final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=
    dat.getReal(varName=id + ".CoolingTower.TAirInWB_nominal.value")
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal=
    dat.getReal(varName=id + ".CoolingTower.TCW_nominal.value")
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(
    displayUnit="K", final min=0)=
    dat.getReal(varName=id + ".CoolingTower.dT_nominal.value")
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Power PFan_nominal=
    dat.getReal(varName=id + ".CoolingTower.PFan_nominal.value")
    "Fan power"
    annotation (Dialog(group="Fan"));
  final parameter Modelica.Units.SI.Temperature TWatOut_nominal(displayUnit="degC")=
    TWatIn_nominal - dT_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.TemperatureDifference dTApp_nominal(
    displayUnit="K", final min=0)=
    TWatOut_nominal - TAirInWB_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Nominal condition"));

  Bus busCon(final nCooTow=nCooTow) "Control bus" annotation (Placement(transformation(
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
end PartialCoolingTowerGroup;
