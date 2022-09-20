within Buildings.Templates.ChilledWaterPlants.Data;
record ChilledWaterPlant "Record for chilled water plant model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typ "Type of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller
    ctr(
    final isAirCoo=isAirCoo,
    final capChi_nominal=abs(chiSec.chi.Q_flow_nominal),
    final mPri_flow_nominal=mPri_flow_nominal,
    final TChiWatSup_nominal=chiSec.chi[1].TChiWatSup_nominal)
    "Controller"
    annotation (Dialog(group="Controller"));
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup
    chi(
    final isAirCoo=isAirCoo,
    final valChiWatChiIso=pumPri.valChiWatChiIso,
    m2_flow_nominal=mPri_flow_nominal,
    m1_flow_nominal=mCon_flow_nominal) "Chillers"
    annotation (Dialog(group="Equipment"));
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.PumpsPrimary
    pumPri(final nChi=chiSec.nChi, m_flow_nominal=mPri_flow_nominal)
    "Primary CHW pumps"
    annotation (Dialog(group="Equipment"));
  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.Economizer
    eco(m1_flow_nominal=mPri_flow_nominal, m2_flow_nominal=mCon_flow_nominal)
    "Waterside economizer"
    annotation (Dialog(group="Equipment", enable=eco.have_eco));
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Pump
    pumSec(m_flow_nominal=mSec_flow_nominal)
    "Secondary CHW pumps"
    annotation (Dialog(group="Equipment", enable=not pumSec.is_none));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumCon(final nChi=
        chiSec.nChi, m_flow_nominal=mCon_flow_nominal) "CW pumps"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.CoolerGroup
    cooTowSec(m_flow_nominal=mCon_flow_nominal) "Cooling tower section"
    annotation (Dialog(group="Equipment", enable=not isAirCoo));

  // Nominal conditions
  parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal
    "Design primary CHW mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatSec_flow_nominal=
    mChiWatPri_flow_nominal / 1.1
    "Design secondary CHW mass flow rate"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal
    "Differential pressure setpoint on the demand side"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Design condenser water mass flow rate"
    annotation (Dialog(group="Nominal conditions", enable=not isAirCoo));

end ChilledWaterPlant;
