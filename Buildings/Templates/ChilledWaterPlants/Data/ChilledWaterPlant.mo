within Buildings.Templates.ChilledWaterPlants.Data;
record ChilledWaterPlant "Record for chilled water plant model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatSec
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  final parameter Boolean have_pumChiWatSec=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller ctr(
    typChi=typChi,
    nChi=nChi,
    typCoo=typCoo,
    nCoo=nCoo,
    typDisChiWat=typDisChiWat,
    typCtrSpePumConWat=typCtrSpePumConWat,
    nPumChiWatSec=nPumChiWatSec,
    mChiWatChi_flow_nominal=chi.mChiWatChi_flow_nominal,
    mConWatChi_flow_nominal=chi.mConChi_flow_nominal)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup chi(
    nChi=nChi,
    typChi=typChi)
    "Chiller group";

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatPri(
    nPum=nChi,
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=chi.mChiWatChi_flow_nominal)
    "Primary CHW pumps"
    annotation(Dialog(group="Primary CHW loop"));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=max(ctr.mChiWatChi_flow_min),
    dpValve_nominal=max(chi.dpChiWatChi_nominal) * max(ctr.mChiWatChi_flow_min ./ chi.mChiWatChi_flow_nominal)^2)
    "CHW minimum flow bypass valve"
    annotation(Dialog(group="Primary CHW loop",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    nPum=nPumChiWatSec,
    typ=Buildings.Templates.Components.Types.Pump.Multiple)
    "Secondary CHW pumps"
    annotation(Dialog(group="Secondary CHW loop",
    enable=have_pumChiWatSec));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.CoolerGroup coo(
    nCoo=nCoo,
    typCoo=typCoo,
    mConWatCoo_flow_nominal=chi.mConChi_flow_nominal)
    "Cooler group"
    annotation(Dialog(group="CW loop",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumConWat(
    nPum=nChi,
    typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=chi.mConChi_flow_nominal)
    "CW pumps"
    annotation(Dialog(group="CW loop",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

end ChilledWaterPlant;
