within Buildings.Templates.Plants.HeatPumps.Components.Data;
record HeatPumpGroup
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Boolean have_hp
    "Set to true for plants with non-reversible or reversible heat pumps"
    annotation (Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Boolean have_shc
    "Set to true for plants with simultaneous (multi-pipe) units"
    annotation (Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  // Default fluid properties
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHeaWat_default =
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "HW default specific heat capacity"
    annotation(Dialog(group="Configuration",
      enable=false));
  /*
   * cpChiWat_default is for internal use only.
   * It is the same as cpChiWat_default for reversible HP.
   * Non-reversible HP that can be controlled to produce either HW or CHW
   * shall be modeled with chiller components (as a chiller/heater).
   */
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default =
    cpHeaWat_default
    "CHW default specific heat capacity";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpSou_default =
    if typ == Buildings.Templates.Components.Types.HeatPump.AirToWater
    then Buildings.Utilities.Psychrometrics.Constants.cpAir
    else Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Source fluid default specific heat capacity"
    annotation(Dialog(group="Configuration",
      enable=false));
  // RFE: Declare array parameters for unequally sized units.
  // The current implementation only supports equally sized units.
  parameter Modelica.Units.SI.MassFlowRate mHeaWatHp_flow_nominal(min=0, start=1)
    "HW mass flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – Heat pumps",
        enable=have_hp));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatHp_nominal(min=0,
      start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal(start=0)
    "Heating capacity - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp));
  parameter Modelica.Units.SI.Temperature THeaWatSupHp_nominal(min=273.15,
      start=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "HW supply temperature - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp));
  final parameter Modelica.Units.SI.Temperature THeaWatRetHp_nominal =
    THeaWatSupHp_nominal - abs(capHeaHp_nominal) / cpHeaWat_default /
      mHeaWatHp_flow_nominal
    "HW return temperature - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatHp_flow_nominal(min=0, start=1)
    "CHW mass flow rate - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – Heat pumps",
        enable=have_hp and is_rev));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatHp_nominal =
    dpHeaWatHp_nominal * (mChiWatHp_flow_nominal / mHeaWatHp_flow_nominal) ^ 2
    "Pressure drop at design CHW mass flow rate - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps"));
  parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal(start=0)
    "Cooling capacity - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp and is_rev));
  parameter Modelica.Units.SI.Temperature TChiWatSupHp_nominal(min=253.15,
      start=Buildings.Templates.Data.Defaults.TChiWatSup)
    "(Lowest) CHW supply temperature - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp and is_rev));
  final parameter Modelica.Units.SI.Temperature TChiWatRetHp_nominal =
    if is_rev
    then TChiWatSupHp_nominal + abs(capCooHp_nominal) / cpChiWat_default /
      mChiWatHp_flow_nominal
    else Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps"));
  parameter Modelica.Units.SI.Temperature TSouHeaHp_nominal(min=220, start=
        Buildings.Templates.Data.Defaults.TOutHpHeaLow)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp));
  parameter Modelica.Units.SI.MassFlowRate mSouWwHeaHp_flow_nominal(min=0,
      start=mHeaWatHp_flow_nominal)
    "Source fluid mass flow rate in heating mode - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – Heat pumps",
        enable=have_hp
          and typ ==
            Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouWwHeaHp_nominal(min=0,
      start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp
        and typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouHeaHp_flow_nominal =
    if have_hp
    then (if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
      then mSouWwHeaHp_flow_nominal
      else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
        capHeaHp_nominal))
    else 1
    "Source fluid mass flow rate in heating mode - Each heat pump"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouHeaHp_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then dpSouWwHeaHp_nominal else Buildings.Templates.Data.Defaults.dpAirChi
    "Source fluid pressure drop in heating mode - Each heat pump";
  parameter Modelica.Units.SI.Temperature TSouCooHp_nominal(min=273.15, start=
        Buildings.Templates.Data.Defaults.TOutHpCoo)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode - Each heat pump"
    annotation(Dialog(group="Nominal condition – Heat pumps",
      enable=have_hp and is_rev));
  parameter Modelica.Units.SI.MassFlowRate mSouWwCooHp_flow_nominal(min=0,
      start=mChiWatHp_flow_nominal)
    "Source fluid mass flow rate in cooling mode - Each heat pump"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – Heat pumps",
        enable=have_hp
          and typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
          and is_rev));
  final parameter Modelica.Units.SI.MassFlowRate mSouCooHp_flow_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then mSouWwCooHp_flow_nominal
    else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
      capCooHp_nominal)
    "Source fluid mass flow rate in cooling mode - Each heat pump"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouCooHp_nominal =
    dpSouHeaHp_nominal * (mSouCooHp_flow_nominal / mSouHeaHp_flow_nominal) ^ 2
    "Source fluid pressure drop in cooling mode - Each heat pump";
  replaceable parameter Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump perHeaHp(
    devIde="")
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump(
      mCon_flow_nominal=mHeaWatHp_flow_nominal,
      mEva_flow_nominal=mSouHeaHp_flow_nominal,
      dpCon_nominal=dpHeaWatHp_nominal,
      dpEva_nominal=dpSouHeaHp_nominal)
    "Performance data in heating mode"
    annotation(Dialog(group="Performance data – Heat pumps", enable=have_hp),
      choicesAllMatching=true,
      Placement(transformation(extent={{-40,10},{-20,30}})));
  replaceable parameter Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic perCooHp(
    fileName="",
    PLRSup={1},
    tabLowBou=[
      TSouCooHp_nominal - 30, TChiWatSupHp_nominal;
      TSouCooHp_nominal + 10, TChiWatSupHp_nominal],
    devIde="",
    use_TConOutForTab=false,
    use_TEvaOutForTab=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic(
      mCon_flow_nominal=mSouCooHp_flow_nominal,
      mEva_flow_nominal=mChiWatHp_flow_nominal,
      dpCon_nominal=dpSouCooHp_nominal,
      dpEva_nominal=dpChiWatHp_nominal)
    "Performance data in cooling mode"
    annotation(choicesAllMatching=true,
      Dialog(group="Performance data – Heat pumps", enable=have_hp and is_rev),
      Placement(transformation(extent={{-40,-28},{-20,-8}})));
  parameter Modelica.Units.SI.Power PHp_min(min=0)=0
    "Minimum power when system is enabled with compressor cycled off - Each heat pump"
    annotation(Dialog(group="Performance data – Heat pumps", enable=have_hp));
  // RFE: Declare array parameters for unequally sized units.
  // The current implementation only supports equally sized units.
  parameter Modelica.Units.SI.MassFlowRate mHeaWatShc_flow_nominal(min=0, start
      =1)
    "HW mass flow rate - Each SHC unit"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – SHC units",
        enable=have_shc));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatShc_nominal(min=0,
      start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.HeatFlowRate capHeaShc_nominal(start=0)
    "Heating capacity - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.Temperature THeaWatSupShc_nominal(min=273.15,
      start=Buildings.Templates.Data.Defaults.THeaWatSupMed)
    "(Highest) HW supply temperature - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  final parameter Modelica.Units.SI.Temperature THeaWatRetShc_nominal =
    THeaWatSupShc_nominal - abs(capHeaShc_nominal) / cpHeaWat_default /
      mHeaWatShc_flow_nominal
    "HW return temperature - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatShc_flow_nominal(min=0, start
      =1)
    "CHW mass flow rate - Each SHC unit"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – SHC units",
        enable=have_shc));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatShc_nominal =
    dpHeaWatShc_nominal *
      (mChiWatShc_flow_nominal / mHeaWatShc_flow_nominal) ^ 2
    "Pressure drop at design CHW mass flow rate - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units"));
  parameter Modelica.Units.SI.HeatFlowRate capCooShc_nominal(start=0)
    "Cooling capacity - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.Temperature TChiWatSupShc_nominal(min=253.15,
      start=Buildings.Templates.Data.Defaults.TChiWatSup)
    "(Lowest) CHW supply temperature - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  final parameter Modelica.Units.SI.Temperature TChiWatRetShc_nominal =
    TChiWatSupShc_nominal + abs(capCooShc_nominal) / cpChiWat_default /
      mChiWatShc_flow_nominal
    "CHW return temperature - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.Temperature TSouHeaShc_nominal(min=220, start=
        Buildings.Templates.Data.Defaults.TOutHpHeaLow)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.MassFlowRate mSouWwHeaShc_flow_nominal(min=0,
      start=mHeaWatShc_flow_nominal)
    "Source fluid mass flow rate in heating mode - Each SHC unit"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – SHC units",
        enable=have_shc
          and typ ==
            Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouWwHeaShc_nominal(min=0,
      start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc
        and typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouHeaShc_flow_nominal =
    if have_shc
    then (if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
      then mSouWwHeaShc_flow_nominal
      else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
        capHeaShc_nominal))
    else 1
    "Source fluid mass flow rate in heating mode - Each SHC unit"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouHeaShc_nominal =
    if have_shc
      and typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then dpSouWwHeaShc_nominal else Buildings.Templates.Data.Defaults.dpAirChi
    "Source fluid pressure drop in heating mode - Each SHC unit";
  parameter Modelica.Units.SI.Temperature TSouCooShc_nominal(min=273.15, start=
        Buildings.Templates.Data.Defaults.TOutHpCoo)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units",
      enable=have_shc));
  parameter Modelica.Units.SI.MassFlowRate mSouWwCooShc_flow_nominal(min=0,
      start=mChiWatShc_flow_nominal)
    "Source fluid mass flow rate in cooling mode - Each SHC unit"
    annotation(Evaluate=true,
      Dialog(group="Nominal condition – SHC units",
        enable=have_shc
          and typ ==
            Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouCooShc_flow_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then mSouWwCooShc_flow_nominal
    else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
      capCooShc_nominal)
    "Source fluid mass flow rate in cooling mode - Each SHC unit"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouCooShc_nominal =
    dpSouHeaShc_nominal *
      (mSouCooShc_flow_nominal / mSouHeaShc_flow_nominal) ^ 2
    "Source fluid pressure drop in cooling mode - Each SHC unit";
  parameter Modelica.Units.SI.HeatFlowRate capHeaHrShc_nominal(start=0)
    "Heating capacity in heat recovery mode - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units", enable=have_shc));
  parameter Modelica.Units.SI.HeatFlowRate capCooHrShc_nominal(start=0)
    "Cooling capacity in heat recovery mode - Each SHC unit"
    annotation(Dialog(group="Nominal condition – SHC units", enable=have_shc));
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic perShc(
    devIde="",
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    fileNameHea="",
    fileNameCoo="",
    fileNameShc="",
    use_TConOutForTab=true,
    use_TEvaOutForTab=true,
    mCon_flow_nominal=mHeaWatShc_flow_nominal,
    mEva_flow_nominal=mSouHeaShc_flow_nominal,
    dpCon_nominal=dpHeaWatShc_nominal,
    dpEva_nominal=dpSouHeaShc_nominal)
    "Performance data - Each SHC unit"
    annotation(Dialog(group="Performance data – SHC units", enable=have_shc),
      choicesAllMatching=true,
      Placement(transformation(extent={{20,-10},{40,10}})));
  parameter Modelica.Units.SI.Power PShc_min(
    min=0,
    start=0)=0
    "Minimum power when system is enabled with compressor cycled off - Each SHC unit"
    annotation(Dialog(group="Performance data – SHC units", enable=have_shc));
annotation(defaultComponentPrefixes="parameter",
  defaultComponentName="datHp",
  Documentation(
    info="<html>
<p>
  This record provides the set of parameters for heat pump group models that
  can be found within
  <a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups\">
    Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups</a>.
</p>
<p>Only identical heat pumps are currently supported.</p>
<p>
  The heat pump performance data are provided via the subrecords
  <code>perHeaHp</code> and <code>perCooHp</code> for the heating mode and the
  cooling mode, respectively. For the required format of the performance data
  files, please refer to the documentation of the block
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep\">
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDep</a>.
</p>
</html>"));
end HeatPumpGroup;
