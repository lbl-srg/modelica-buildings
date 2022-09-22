within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
block PartialController "Interface class for plant controller"
  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nChi(start=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_bypChiWatFix
    "Set to true if the plant has a fixed CHW bypass"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_pumChiWatSec
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumConWat
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatPri
    "Type of primary CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatSec
    "Type of secondary CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nCoo(start=1)
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec(start=1)
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
     or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
     or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed));
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso
    "Cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso
    "Cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(
        transformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={220,0}),  iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=90,
        origin={100,0})));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,-114},{149,-154}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{220,
            200}})));
end PartialController;
