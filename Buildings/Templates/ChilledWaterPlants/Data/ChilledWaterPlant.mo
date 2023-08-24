within Buildings.Templates.ChilledWaterPlants.Data;
record ChilledWaterPlant "Record for chilled water plant model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumChiWatPri=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.PumpArrangement typArrPumChiWatPri
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumChiWatPri
    "Set to true for variable speed primary CHW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nPumConWat=nChi
    "Number of CW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatSec=nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nCoo=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_varPumConWat
    "Set to true for variable speed CW pumps, false for constant speed pumps"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtlHea
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PrimaryOverflowMeasurement typMeaCtlChiWatPri
    "Type of sensors for primary CHW pump control in variable primary-variable secondary plants"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senDpChiWatLoc
    "Set to true for local CHW differential pressure sensor hardwired to plant controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nSenDpChiWatRem
    "Number of remote CHW differential pressure sensors used for CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nLooChiWatSec=1
    "Number of secondary CHW loops"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senVChiWatSec
    "Set to true if secondary loop is equipped with a flow meter"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_senLevCoo
    "Set to true if cooling towers have level sensor for makeup water control"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.Density rhoChiWat_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "CHW default density"
    annotation(Dialog(enable=false));
  parameter Modelica.Units.SI.Density rhoConWat_default=
    Modelica.Media.Water.ConstantPropertyLiquidWater.d_const
    "CW default density"
    annotation(Dialog(enable=false));

  final parameter Boolean have_pumChiWatSec=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller ctl(
    final typ=typCtl,
    final typChi=typChi,
    final nChi=nChi,
    final nPumChiWatPri=nPumChiWatPri,
    final typArrPumChiWatPri=typArrPumChiWatPri,
    final have_varPumChiWatPri=have_varPumChiWatPri,
    final nPumConWat=nPumConWat,
    final typDisChiWat=typDisChiWat,
    final nPumChiWatSec=nPumChiWatSec,
    final typCoo=typCoo,
    final nCoo=nCoo,
    final have_varPumConWat=have_varPumConWat,
    final typCtlHea=typCtlHea,
    final typEco=typEco,
    final typMeaCtlChiWatPri=typMeaCtlChiWatPri,
    final have_senDpChiWatLoc=have_senDpChiWatLoc,
    final nSenDpChiWatRem=nSenDpChiWatRem,
    final nLooChiWatSec=nLooChiWatSec,
    final have_senVChiWatSec=have_senVChiWatSec,
    final have_senLevCoo=have_senLevCoo)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup chi(
    final nChi=nChi,
    final typChi=typChi,
    mChiWatChi_flow_nominal=ctl.VChiWatChi_flow_nominal * rhoChiWat_default,
    mConWatChi_flow_nominal=ctl.VConWatChi_flow_nominal * rhoConWat_default,
    capChi_nominal=ctl.capChi_nominal,
    TChiWatChiSup_nominal=ctl.TChiWatChiSup_nominal,
    TChiWatChiSup_max=fill(ctl.TChiWatSup_max, nChi),
    TConWatChiEnt_nominal=ctl.TConWatChiSup_nominal,
    PLRUnlChi_min=ctl.capUnlChi_min ./ ctl.capChi_nominal)
    "Chiller group"
    annotation(Dialog(group="Chillers"));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatPri(
    final nPum=nPumChiWatPri,
    final rho_default=rhoChiWat_default,
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=chi.mChiWatChi_flow_nominal)
    "Primary CHW pumps"
    annotation(Dialog(group="Primary CHW loop"));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=max(ctl.VChiWatChi_flow_min) * rhoChiWat_default,
    dpValve_nominal=max(chi.dpChiWatChi_nominal) * max(ctl.VChiWatChi_flow_min ./ ctl.VChiWatChi_flow_nominal)^2)
    "CHW minimum flow bypass valve"
    annotation(Dialog(group="Primary CHW loop",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=nPumChiWatSec,
    final rho_default=rhoChiWat_default,
    final typ=if have_pumChiWatSec
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=if have_pumChiWatSec then
      fill(ctl.VChiWatSec_flow_nominal[1] * rhoChiWat_default / nPumChiWatSec, nPumChiWatSec)
      else fill(0, nPumChiWatSec))
    "Secondary CHW pumps"
    annotation(Dialog(group="Secondary CHW loop",
    enable=have_pumChiWatSec));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.CoolerGroup coo(
    final nCoo=nCoo,
    final typCoo=typCoo,
    mConWatCoo_flow_nominal=fill(sum(ctl.VConWatChi_flow_nominal) * rhoConWat_default / nCoo, nCoo),
    TWetBulEnt_nominal=ctl.TWetBulCooEnt_nominal,
    TConWatRet_nominal=max(ctl.TConWatChiRet_nominal),
    TConWatSup_nominal=min(ctl.TConWatChiSup_nominal))
    "Cooler group"
    annotation(Dialog(group="CW loop",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumConWat(
    final nPum=nPumConWat,
    final rho_default=rhoConWat_default,
    final typ=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(sum(coo.mConWatCoo_flow_nominal) / nPumConWat, nPumConWat))
    "CW pumps"
    annotation(Dialog(group="CW loop",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Economizer eco(
    final typ=typEco,
    final rhoChiWat_default=rhoChiWat_default,
    mChiWat_flow_nominal=ctl.VChiWatEco_flow_nominal * rhoChiWat_default,
    mConWat_flow_nominal=ctl.VConWatEco_flow_nominal * rhoConWat_default,
    dpChiWat_nominal=ctl.dpChiWatEco_nominal)
    "Waterside economizer"
    annotation(Dialog(group="Waterside economizer",
    enable=typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
CHW plant models that can be found within
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants\">
Buildings.Templates.ChilledWaterPlants</a>.
</p>
<p>
Most of the parameters should be assigned through the sub-record
dedicated to the controller.
All parameters that are also needed to parameterize other plant
components are propagated from the controller sub-record
to the corresponding equipment sub-records.
Note that those parameter bindings are not final so they may be
overwritten in case a component is parameterized at nominal
conditions that differ from the design conditions specified
in the controller sub-record.
</p>
</html>"));
end ChilledWaterPlant;
