within Buildings.Templates.Plants.Chillers.Data;
record ChillerPlant "Record for chiller plant"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Plants.Chillers.Configuration.ChillerPlant cfg
    "Configuration parameters"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.Controller ctl(
    final cfg=cfg)
    "Controller"
    annotation(Dialog(group="Controls"));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup
    chi(
    final nChi=cfg.nChi,
    final typ=cfg.typChi,
    final cpChiWat_default=cfg.cpChiWat_default,
    final cpCon_default=cfg.cpCon_default,
    mChiWatChi_flow_nominal=ctl.VChiWatChi_flow_nominal*cfg.rhoChiWat_default,
    mConWatChi_flow_nominal=ctl.VConWatChi_flow_nominal*cfg.rhoCon_default,
    capChi_nominal=ctl.capChi_nominal,
    TChiWatSupChi_nominal=ctl.TChiWatChiSup_nominal,
    TChiWatSupChi_max=fill(ctl.TChiWatSup_max, cfg.nChi),
    TConWatEntChi_nominal=ctl.TConWatSupChi_nominal,
    PLRUnlChi_min=ctl.capUnlChi_min ./ ctl.capChi_nominal)
    "Chiller group"
    annotation (Dialog(group="Chillers"));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatPri(
    final nPum=cfg.nPumChiWatPri,
    final rho_default=cfg.rhoChiWat_default,
    final typ=Buildings.Templates.Components.Types.Pump.Multiple,
    m_flow_nominal=chi.mChiWatChi_flow_nominal)
    "Primary CHW pumps"
    annotation(Dialog(group="Primary CHW loop"));
  parameter Buildings.Templates.Components.Data.Valve valChiWatMinByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
    m_flow_nominal=max(ctl.VChiWatChi_flow_min) * cfg.rhoChiWat_default,
    dpValve_nominal=max(chi.dpChiWatChi_nominal) * max(ctl.VChiWatChi_flow_min ./ ctl.VChiWatChi_flow_nominal)^2)
    "CHW minimum flow bypass valve"
    annotation(Dialog(group="Primary CHW loop",
    enable=cfg.typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only));

  parameter Buildings.Templates.Components.Data.PumpMultiple pumChiWatSec(
    final nPum=cfg.nPumChiWatSec,
    final rho_default=cfg.rhoChiWat_default,
    final typ=if cfg.have_pumChiWatSec
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=if cfg.have_pumChiWatSec then
      fill(ctl.VChiWatSec_flow_nominal[1] * cfg.rhoChiWat_default / cfg.nPumChiWatSec, cfg.nPumChiWatSec)
      else fill(0, cfg.nPumChiWatSec))
    "Secondary CHW pumps"
    annotation(Dialog(group="Secondary CHW loop",
    enable=cfg.have_pumChiWatSec));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.CoolerGroup coo(
    final nCoo=cfg.nCoo,
    final typCoo=cfg.typCoo,
    mConWatCoo_flow_nominal=fill(sum(ctl.VConWatChi_flow_nominal) * cfg.rhoCon_default / cfg.nCoo, cfg.nCoo),
    TWetBulEnt_nominal=ctl.TWetBulCooEnt_nominal,
    TConWatRet_nominal=max(ctl.TConWatRetChi_nominal),
    TConWatSup_nominal=min(ctl.TConWatSupChi_nominal))
    "Cooler group"
    annotation(Dialog(group="CW loop",
    enable=cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.Components.Data.PumpMultiple pumConWat(
    final nPum=cfg.nPumConWat,
    final rho_default=cfg.rhoCon_default,
    final typ=if cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then Buildings.Templates.Components.Types.Pump.Multiple
      else Buildings.Templates.Components.Types.Pump.None,
    m_flow_nominal=fill(sum(coo.mConWatCoo_flow_nominal) / cfg.nPumConWat, cfg.nPumConWat))
    "CW pumps"
    annotation(Dialog(group="CW loop",
    enable=cfg.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Buildings.Templates.Plants.Chillers.Components.Data.Economizer eco(
    final typ=cfg.typEco,
    final rhoChiWat_default=cfg.rhoChiWat_default,
    mChiWat_flow_nominal=ctl.VChiWatEco_flow_nominal * cfg.rhoChiWat_default,
    mConWat_flow_nominal=ctl.VConWatEco_flow_nominal * cfg.rhoCon_default,
    dpChiWat_nominal=ctl.dpChiWatEco_nominal)
    "Waterside economizer"
    annotation(Dialog(group="Waterside economizer",
    enable=cfg.typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
CHW plant models that can be found within
<a href=\"modelica://Buildings.Templates.Plants.Chillers\">
Buildings.Templates.Plants.Chillers</a>.
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
end ChillerPlant;
