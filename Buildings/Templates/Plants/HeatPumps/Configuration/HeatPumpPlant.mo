within Buildings.Templates.Plants.HeatPumps.Configuration;
record HeatPumpPlant
  "Configuration parameters for heat pump plant"
  extends Modelica.Icons.Record;
  // Generic
  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Type of heat pump"
    annotation (Evaluate=true);
  parameter Boolean have_heaWat
    "Set to true if the plant provides HW"
    annotation (Evaluate=true);
  parameter Boolean have_hotWat
    "Set to true if the plant provides DHW"
    annotation (Evaluate=true);
  parameter Boolean have_chiWat
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true);
  parameter Integer nHeaPum
    "Number of heat pumps"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true);
  // Default fluid properties
  parameter Modelica.Units.SI.Density rhoHeaWat_default
    "HW default density";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHeaWat_default
    "HW default specific heat capacity";
  parameter Modelica.Units.SI.Density rhoChiWat_default
    "CHW default density";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default
    "CHW default specific heat capacity";
  // HW loop
  parameter Integer nPumHeaWatPri
    "Number of primary HW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumHeaWatSec
    "Number of secondary HW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_valHeaWatMinByp
    "Set to true if the HW loop has a minimum flow bypass valve"
    annotation (Evaluate=true);
  parameter Boolean have_senDpHeaWatLoc
    "Set to true for local HW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true);
  parameter Integer nSenDpHeaWatRem
    "Number of remote HW differential pressure sensors used for HW pump speed control"
    annotation (Evaluate=true);
  parameter Boolean have_senVHeaWatSec
    "Set to true if secondary HW loop is equipped with a flow meter"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumHeaWatPri
    "Type of primary HW pump arrangement"
    annotation (Evaluate=true);
  parameter Boolean have_varPumHeaWatPri
    "Set to true for variable speed primary HW pumps"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumHeaWatSec
    "Type of secondary HW pumps"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDisHeaWat
    "Type of HW distribution system"
    annotation (Evaluate=true);
  // CHW loop
  parameter Integer nPumChiWatPri
    "Number of primary CHW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumChiWatSec
    "Number of secondary CHW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_valChiWatMinByp
    "Set to true if the CHW loop has a minimum flow bypass valve"
    annotation (Evaluate=true);
  parameter Boolean have_senDpChiWatLoc
    "Set to true for local CHW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true);
  parameter Integer nSenDpChiWatRem
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true);
  parameter Boolean have_senVChiWatSec
    "Set to true if secondary CHW loop is equipped with a flow meter"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true);
  parameter Boolean have_varPumChiWatPri
    "Set to true for variable speed primary CHW pumps"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.PumpsSecondary typPumChiWatSec
    "Type of secondary CHW pumps"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true);
  annotation (
    Documentation(
      info="<html>
<p>
This record provides the set of configuration parameters for 
the heat pump plant models within  
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
Buildings.Templates.Plants.HeatPumps</a>.
</p>
</html>"));
end HeatPumpPlant;
