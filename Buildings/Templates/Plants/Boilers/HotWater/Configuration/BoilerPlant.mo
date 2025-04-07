within Buildings.Templates.Plants.Boilers.HotWater.Configuration;
record BoilerPlant "Configuration parameters for boiler plant"
  extends Modelica.Icons.Record;
  // Boilers
  parameter Boolean have_boiCon
    "Set to true if the plant includes condensing boilers"
    annotation (Evaluate=true);
  parameter Boolean have_boiNon
    "Set to true if the plant includes non-condensing boilers"
    annotation (Evaluate=true);
  parameter Integer nBoiCon
    "Number of condensing boilers"
    annotation (Evaluate=true);
  parameter Integer nBoiNon
    "Number of non-condensing boilers"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model (same model for all boilers)"
    annotation (Evaluate=true);
  // Controls
  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true);
  // Loads
  parameter Integer nAirHan
    "Number of air handling units served by the plant"
    annotation (Evaluate=true);
  parameter Integer nEquZon
    "Number of terminal units (zone equipment) served by the plant"
    annotation (Evaluate=true);
  // Default fluid properties
  parameter Modelica.Media.Interfaces.Types.Density rhoHeaWat_default
    "HW default density"
    annotation (Evaluate=true);
  // Primary HW loop
  parameter Integer nPumHeaWatPriCon
    "Number of primary HW pumps - Condensing boilers"
    annotation (Evaluate=true);
  parameter Integer nPumHeaWatPriNon
    "Number of primary HW pumps - Non-cCondensing boilers"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriCon
    "Type of primary HW pump arrangement - Condensing boilers";
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPriNon
    "Type of primary HW pump arrangement - Non-condensing boilers";
  parameter Boolean have_varPumHeaWatPriCon
    "Set to true for variable speed primary HW pumps - Condensing boilers"
    annotation (Evaluate=true);
  parameter Boolean have_varPumHeaWatPriNon
    "Set to true for variable speed primary HW pumps - Non-condensing boilers"
    annotation (Evaluate=true);
  parameter Boolean have_valHeaWatMinBypCon
    "Set to true if the plant has a HW minimum flow bypass valve - Condensing boilers"
    annotation (Evaluate=true);
  parameter Boolean have_valHeaWatMinBypNon
    "Set to true if the plant has a HW minimum flow bypass valve - Non-condensing boilers"
    annotation (Evaluate=true);
  // Secondary HW loop
  parameter Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumHeaWatSec
    "Number of secondary HW pumps"
    annotation (Evaluate=true);
  parameter Integer nLooHeaWatSec
    "Number of secondary HW loops for distributed secondary distribution"
    annotation (Evaluate=true);
  // Sensors
  parameter Boolean have_senDpHeaWatRemWir
    "Set to true for remote HW differential pressure sensor(s) hardwired to plant or pump controller"
    annotation (Evaluate=true);
  parameter Boolean have_senVHeaWatSec
    "Set to true for secondary HW flow sensor"
    annotation (Evaluate=true);
  parameter Integer nSenDpHeaWatRem
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true);
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="cfg",
    Documentation(
      info="<html>
<p>
This record provides the set of configuration parameters for
the heat pump plant models within
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
Buildings.Templates.Plants.HeatPumps</a>.
</p>
</html>"));
end BoilerPlant;
