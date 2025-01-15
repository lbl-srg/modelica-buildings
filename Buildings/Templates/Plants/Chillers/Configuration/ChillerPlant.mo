within Buildings.Templates.Plants.Chillers.Configuration;
record ChillerPlant "Configuration parameters for chiller plant"
  extends Modelica.Icons.Record;
  // Chillers
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true);
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl typCtlHea
    "Type of head pressure control"
    annotation (Evaluate=true);
  // Controls
  parameter Buildings.Templates.Plants.Chillers.Types.Controller typCtl
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
  parameter Modelica.Units.SI.Density rhoChiWat_default
    "CHW default density"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default
    "CHW default specific heat capacity"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Density rhoCon_default
    "Condenser cooling fluid (OA or CW) default density"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon_default
    "Condenser cooling fluid (OA or CW) default specific heat capacity"
    annotation (Evaluate=true);
  // CHW loop
  parameter Buildings.Templates.Plants.Chillers.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatPriVar
    "Set to true for variable speed primary CHW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumChiWatPri
    "Number of primary CHW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_pumChiWatSec
    "Set to true if the plant includes secondary CHW pumps"
    annotation (Evaluate=true);
  parameter Integer nPumChiWatSec
    "Number of secondary CHW pumps"
    annotation (Evaluate=true);
  parameter Integer nSenDpChiWatRem
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.Chillers.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senDpChiWatLoc
    "Set to true for local CHW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nLooChiWatSec=1
    "Number of secondary CHW loops"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senVChiWatSec
    "Set to true if secondary loop is equipped with a flow meter"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  // WSE
  parameter Buildings.Templates.Plants.Chillers.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true);
  // CW pumps
  parameter Integer nPumConWat
    "Number of CW pumps"
    annotation (Evaluate=true);
  parameter Boolean have_varPumConWat
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true);
  // Coolers
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true);
  parameter Integer nCoo
    "Number of cooler units"
    annotation (Evaluate=true);
  parameter Boolean have_senLevCoo
    "Set to true if cooling towers have level sensor for makeup water control"
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
end ChillerPlant;
