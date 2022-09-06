within Buildings.Templates.ChilledWaterPlants.Data;
record ChilledWaterPlant "Record for chilled water plant model"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean isAirCoo=
    typ ==Buildings.Templates.ChilledWaterPlants.Components.Types.Configuration.AirCooled
    "= true, chillers are air cooled, 
     = false, chillers are water cooled";

  // Component parameters

  // Controller

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller
    ctr(
    final isAirCoo=isAirCoo,
    final capChi_nominal=abs(chiSec.chi.Q_flow_nominal),
    final mPri_flow_nominal=mPri_flow_nominal,
    final TChiWatSup_nominal=chiSec.chi[1].TChiWatSup_nominal)
    "Controller data" annotation (Dialog(group="Controller"));

  // Evaporator side equipment

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerSection
    chiSec(
    final isAirCoo=isAirCoo,
    final valChiWatChiIso=pumPri.valChiWatChiIso,
    m2_flow_nominal=mPri_flow_nominal,
    m1_flow_nominal=mCon_flow_nominal) "Chiller section"
    annotation (Dialog(group="Equipment"));
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.PumpsPrimary
    pumPri(final nChi=chiSec.nChi, m_flow_nominal=mPri_flow_nominal)
    "Primary pumps" annotation (Dialog(group="Equipment"));
  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.EconomizerSection
    eco(m1_flow_nominal=mPri_flow_nominal, m2_flow_nominal=mCon_flow_nominal)
    "Waterside Economizer"
    annotation (Dialog(group="Equipment", enable=eco.have_eco));
  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.PumpsSecondary
    pumSec(m_flow_nominal=mSec_flow_nominal) "Secondary pumps"
    annotation (Dialog(group="Equipment", enable=not pumSec.is_none));

  //Condenser side equipment

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.PumpsCondenserWater
    pumCon(final nChi=chiSec.nChi, m_flow_nominal=mCon_flow_nominal)
    "Condenser pumps"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));
  parameter
    Buildings.Templates.ChilledWaterPlants.Components.CoolingTowerSection.Interfaces.Data
    cooTowSec(m_flow_nominal=mCon_flow_nominal) "Cooling tower section"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));

  // Nominal conditions

  parameter Modelica.Units.SI.MassFlowRate mPri_flow_nominal
    "Design primary chilled water mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal=
    mPri_flow_nominal
    "Design secondary chilled water mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal
    "Differential pressure setpoint on the demand side"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Design condenser water mass flow rate"
    annotation (Dialog(group="Nominal conditions", enable=not isAirCoo));

end ChilledWaterPlant;
