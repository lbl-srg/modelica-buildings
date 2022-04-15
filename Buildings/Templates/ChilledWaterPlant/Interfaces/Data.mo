within Buildings.Templates.ChilledWaterPlant.Interfaces;
record Data "Data for chilled water plants"
  extends Modelica.Icons.Record;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration
    typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean isAirCoo=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled
    "= true, chillers are air cooled, 
     = false, chillers are water cooled";

  // Component parameters

  // Controller

  parameter Buildings.Templates.ChilledWaterPlant.Components.Controls.Interfaces.Data con(
    final isAirCoo=isAirCoo,
    final capChi_nominal=abs(chiSec.chi.Q_flow_nominal),
    final mChiWatPri_flow_nominal=mChiWatPri_flow_nominal,
    final TChiWatSup_nominal=chiSec.chi[1].TChiWatSup_nominal)
    "Controller data"
    annotation (Dialog(group="Controller"));

  // Evaporator side equipment

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.ChillerSection.Interfaces.Data
    chiSec(
      final isAirCoo=isAirCoo,
      final valChiWatChi=pumPri.valChiWatChi,
      m2_flow_nominal=mChiWatPri_flow_nominal,
      m1_flow_nominal=mCon_flow_nominal) "Chiller section"
    annotation (Dialog(group="Equipment"));
  parameter
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.Data
    pumPri(
      final nChi=chiSec.nChi,
      m_flow_nominal=mChiWatPri_flow_nominal) "Primary pumps"
    annotation (Dialog(group="Equipment"));
  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.Data
    eco(
      final isAirCoo=isAirCoo,
      m1_flow_nominal=mChiWatPri_flow_nominal,
      m2_flow_nominal=mCon_flow_nominal) "Waterside Economizer"
    annotation (Dialog(group="Equipment", enable=eco.have_eco));
  parameter
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumps.Interfaces.Data
    pumSec(m_flow_nominal=mChiWatSec_flow_nominal) "Secondary pumps"
    annotation (Dialog(group="Equipment", enable=not pumSec.is_none));

  //Condenser side equipment

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.Data
    pumCon(
      final nChi=chiSec.nChi,
      m_flow_nominal=mCon_flow_nominal) "Condenser pumps"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));
  parameter
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerSection.Interfaces.Data
    cooTowSec(m_flow_nominal=mCon_flow_nominal) "Cooling tower section"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));

  // Nominal conditions

  parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal
    "Design primary chilled water mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatSec_flow_nominal=
    mChiWatPri_flow_nominal
    "Design secondary chilled water mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal
    "Differential pressure setpoint on the demand side"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Design condenser water mass flow rate"
    annotation (Dialog(group="Nominal conditions", enable=not isAirCoo));


end Data;
