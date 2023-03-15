within Buildings.Templates.HeatingPlants.HotWater.Components.Interfaces;
block PartialController
  parameter Buildings.Templates.HeatingPlants.HotWater.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nBoi(final min=0)
    "Number of boilers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter
    Buildings.Templates.HeatingPlants.HotWater.Types.Distribution
    typDisHeaWat "Type of HW distribution system"
    annotation (Evaluate=true,
      Dialog(group="Primary HW loop"));
  parameter Integer nPumHeaWatPri(
    start=1,
    final min=1)=nBoi
    "Number of primary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumHeaWatSec(
    start=1,
    final min=0)=nBoi
    "Number of secondary HW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Constant1Variable2
    or typDisHeaWat==Buildings.Templates.HeatingPlants.HotWater.Types.Distribution.Variable1And2));
  parameter Integer nAirHan(
    final min=0)=0
    "Number of air handling units served by the plant"
    annotation(Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36),
    Evaluate=true);
  parameter Integer nEquZon(
    final min=0)=0
    "Number of terminal units (zone equipment) served by the plant"
    annotation(Dialog(group="Configuration", enable=
    typ==Buildings.Templates.HeatingPlants.HotWater.Types.Controller.Guideline36),
    Evaluate=true);
  Buildings.Templates.HeatingPlants.HotWater.Interfaces.Bus bus
    "Plant control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-260,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));
  Buildings.Templates.AirHandlersFans.Interfaces.Bus busAirHan[nAirHan]
    if nAirHan>0
    "Air handling unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={260,140}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,60})));
  Buildings.Templates.ZoneEquipment.Interfaces.Bus busEquZon[nEquZon]
    if nEquZon>0
    "Terminal unit control bus"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={260,-140}),
        iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={100,-60})));

protected
  Buildings.Templates.Components.Interfaces.Bus busBoi[nBoi]
    "Boiler control bus" annotation (Placement(transformation(extent={{-260,120},
            {-220,160}}), iconTransformation(extent={{-466,50},{-426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busValBoiIso[nBoi]
    "Boiler isolation valve control bus" annotation (Placement(transformation(
          extent={{-260,80},{-220,120}}), iconTransformation(extent={{-466,50},{
            -426,90}})));
  Buildings.Templates.Components.Interfaces.Bus busPumHeaWatPri
    "Primary HW pump control bus"
    annotation (Placement(transformation(extent={{
            -260,40},{-220,80}}), iconTransformation(extent={{-466,50},{-426,90}})));
equation
  connect(busBoi, bus.boi) annotation (Line(
      points={{-240,140},{-220,140},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busValBoiIso, bus.valBoiIso) annotation (Line(
      points={{-240,100},{-220,100},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busPumHeaWatPri, bus.pumHeaWatPri) annotation (Line(
      points={{-240,60},{-220,60},{-220,0},{-260,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-260,-380},{260,380}})));
end PartialController;
