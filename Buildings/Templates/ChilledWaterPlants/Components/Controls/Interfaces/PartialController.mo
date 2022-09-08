within Buildings.Templates.ChilledWaterPlants.Components.Controls.Interfaces;
block PartialController "Partial controller for chilled water plant"

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpChiWatRem = 0
    "Number of remote chilled water differential pressure sensors"
    annotation (Dialog(tab="General", group="Chilled water pump"));
  parameter Boolean have_sendpChiWatLoc = true
    "Set to true if there is a local DP sensor hardwired to the plant controller"
    annotation (Dialog(tab="General", group="Configuration"));
  parameter Boolean have_fixSpeConWatPum = false
    "Set to true if the plant has fixed speed condenser water pumps. (Must be false if the plant has Waterside Economizer.)"
    annotation(Dialog(tab="General", group="Condenser water pump",
      enable=not have_eco and not isAirCoo));
  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  outer parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side";
  outer parameter Boolean have_dedConWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side";
  outer parameter Boolean have_parChi
    "Set to true if the plant has parallel chillers";
  outer parameter Boolean have_eco
    "Set to true if the plant has a Waterside Economizer";
  outer parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled";
  outer parameter Boolean have_secPum
    "Set to true if plant has secondary pumping";

  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nPumPri "Number of primary pumps";
  outer parameter Integer nPumSec "Number of secondary pumps";
  outer parameter Integer nPumCon "Number of condenser pumps";
  outer parameter Integer nCooTow "Number of cooling towers";

  // Record

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller
    dat(
    final typ=typ,
    final nSenDpChiWatRem=nSenDpChiWatRem,
    final nChi=nChi,
    final have_eco=have_eco,
    final have_sendpChiWatLoc=have_sendpChiWatLoc,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final have_ctrHeaPre=have_ctrHeaPre) "Controller data";

  outer replaceable
    Buildings.Templates.ChilledWaterPlants.Components.Economizers.Interfaces.PartialEconomizer
    eco "Waterside economizer";
  outer replaceable
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Interfaces.PartialCoolingTowerSection
    cooTowSec if isAirCoo "Cooling towers";
  outer replaceable
    Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Interfaces.PartialCondenserPump
    pumCon if isAirCoo "Condenser pumps";

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus(final nChi=nChi,
      final nCooTow=nCooTow) "Plant control bus" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,0})));

  annotation (
    __Dymola_translate=true,
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
