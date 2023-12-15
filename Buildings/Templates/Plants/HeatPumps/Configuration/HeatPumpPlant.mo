within Buildings.Templates.Plants.HeatPumps.Configuration;
record HeatPumpPlant "Configuration parameters for heat pump plant"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Type of heat pump"
    annotation (Evaluate=true);
   parameter Boolean have_heaWat=true
    "Set to true if the plant provides HW"
    annotation (Evaluate=true);
  parameter Boolean have_hotWat=false
    "Set to true if the plant provides DHW"
    annotation (Evaluate=true);
  parameter Boolean have_chiWat=false
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true);
  parameter Integer nHeaPum
    "Number of heat pumps"
    annotation (Evaluate=true);
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
  parameter Buildings.Templates.Plants.HeatPumps.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.HeatPumps.Types.Distribution typDisHeaWat
    "Type of HW distribution system"
    annotation (Evaluate=true);

  annotation (Documentation(info="<html>
<p>
This record provides the set of configuration parameters for 
the heat pump plant models within  
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps\">
Buildings.Templates.Plants.HeatPumps</a>.
</p>
</html>"));
end HeatPumpPlant;
