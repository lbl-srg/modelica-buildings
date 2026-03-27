within Buildings.Templates.Components.Data;
record HeatPump
  "Record for heat pump model"
  extends Modelica.Icons.Record;
  parameter Types.HeatPump typ
    "Heat pump source/sink type"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatPumpCapability typMod
    "Heat pump operating mode capability"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  // Default fluid properties
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHeaWat_default =
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "HW default specific heat capacity"
    annotation(Dialog(group="Configuration"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWatShc_default =
    cpHeaWat_default
    "CHW default specific heat capacity"
    annotation(Dialog(group="Configuration",
      enable=typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent));
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default =
    if typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    then cpChiWatShc_default
    else cpHeaWat_default
    "CHW default specific heat capacity";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpSou_default =
    if typ == Buildings.Templates.Components.Types.HeatPump.AirToWater
    then Buildings.Utilities.Psychrometrics.Constants.cpAir
    else Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Source fluid default specific heat capacity"
    annotation(Dialog(group="Configuration"));
  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(min=0)
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal(min=0, start=
        Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capHea_nominal
    "Heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(min=273.15)
    "(Highest) HW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal =
    THeaWatSup_nominal - abs(capHea_nominal) / cpHeaWat_default /
      mHeaWat_flow_nominal
    "HW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(min=0, start=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  parameter Modelica.Units.SI.PressureDifference dpChiWatShc_nominal(start=0)
    "Pressure drop at design CHW mass flow rate"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent));
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal =
    if typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible
    then dpHeaWat_nominal * (mChiWat_flow_nominal / mHeaWat_flow_nominal) ^ 2
    elseif typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    then dpChiWatShc_nominal
    else 0
    "Pressure drop at design CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal(start=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(min=253.15, start=
        Buildings.Templates.Data.Defaults.TChiWatSup)
    "(Lowest) CHW supply temperature"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal =
    if typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible
    then TChiWatSup_nominal + abs(capCoo_nominal) / cpChiWat_default /
      mChiWat_flow_nominal
    else Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  parameter Modelica.Units.SI.HeatFlowRate capHeaShc_nominal(start=0)
    "Heating capacity in SHC mode"
    annotation(Dialog(group="Nominal condition",
      enable=typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent));
  parameter Modelica.Units.SI.HeatFlowRate capCooShc_nominal(start=0)
    "Cooling capacity in SHC mode"
    annotation(Dialog(group="Nominal condition",
      enable=typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent));
  parameter Modelica.Units.SI.Temperature TSouHea_nominal(min=220, start=
        Buildings.Templates.Data.Defaults.TOutHpHeaLow)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mSouWwHea_flow_nominal(min=0, start=
        mHeaWat_flow_nominal)
    "Source fluid mass flow rate in heating mode"
    annotation(Dialog(group="Nominal condition",
      enable=typ ==
        Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouWwHea_nominal(min=0,
      start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode"
    annotation(Dialog(group="Nominal condition",
      enable=typ ==
        Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouHea_flow_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then mSouWwHea_flow_nominal
    else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
      capHea_nominal)
    "Source fluid mass flow rate in heating mode";
  final parameter Modelica.Units.SI.PressureDifference dpSouHea_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then dpSouWwHea_nominal else Buildings.Templates.Data.Defaults.dpAirChi
    "Source fluid pressure drop in heating mode";
  parameter Modelica.Units.SI.Temperature TSouCoo_nominal(min=273.15, start=
        Buildings.Templates.Data.Defaults.TOutHpCoo)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode"
    annotation(Dialog(group="Nominal condition",
      enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  parameter Modelica.Units.SI.MassFlowRate mSouWwCoo_flow_nominal(min=0, start=
        mChiWat_flow_nominal)
    "Source fluid mass flow rate in cooling mode"
    annotation(Dialog(group="Nominal condition",
      enable=typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
        and typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible));
  final parameter Modelica.Units.SI.MassFlowRate mSouCoo_flow_nominal =
    if typ == Buildings.Templates.Components.Types.HeatPump.WaterToWater
    then mSouWwCoo_flow_nominal
    else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(
      capCoo_nominal)
    "Source fluid mass flow rate in cooling mode";
  final parameter Modelica.Units.SI.PressureDifference dpSouCoo_nominal =
    dpSouHea_nominal * (mSouCoo_flow_nominal / mSouHea_flow_nominal) ^ 2
    "Source fluid pressure drop in cooling mode";
  /* Propagation of mass flow rate and pressure drop to the subrecords perHea
   * and perCoo is for reference only. The mass flow rate and pressure drop in
   * the HP component are parameterized by the values from this record,
   * not from those subrecords.
   */
  /* HACK(AntoineGautier)
   * Using conditional record instances for the performance records below
   * would allow avoiding the default assignments for devIde, fileName, PLRSup, etc.
   * However, OCT (1.66) and OMC (1.26.3) still fail translating with this syntax.
   * Only Dymola (2026x) manages to translate models with unassigned parameters
   * inside conditionally removed records.
   */
  replaceable parameter Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump perHea(
    mCon_flow_nominal=mHeaWat_flow_nominal,
    mEva_flow_nominal=mSouHea_flow_nominal,
    dpCon_nominal=dpHeaWat_nominal,
    dpEva_nominal=dpSouHea_nominal,
    devIde="",
    fileName="",
    PLRSup={1},
    tabUppBou=[
      TSouHea_nominal - 10, THeaWatSup_nominal + 5;
      TSouHea_nominal + 20, THeaWatSup_nominal + 5],
    use_TConOutForTab=false,
    use_TEvaOutForTab=true)
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump
    "Performance data in heating mode"
    annotation(Dialog(group="Performance data",
      enable=not typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent),
      choicesAllMatching=true,
      Placement(transformation(extent={{-40,0},{-20,20}})));
  replaceable parameter Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic perCoo(
    mCon_flow_nominal=mSouCoo_flow_nominal,
    mEva_flow_nominal=mChiWat_flow_nominal,
    dpCon_nominal=dpSouCoo_nominal,
    dpEva_nominal=dpChiWat_nominal,
    fileName="",
    PLRSup={1},
    tabLowBou=[
      TSouCoo_nominal - 30, TChiWatSup_nominal - 2;
      TSouCoo_nominal + 10, TChiWatSup_nominal - 2],
    devIde="",
    use_TConOutForTab=false,
    use_TEvaOutForTab=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Performance data in cooling mode"
    annotation(choicesAllMatching=true,
      Dialog(group="Performance data",
        enable=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible),
      Placement(transformation(extent={{20,0},{40,20}})));
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic perShc(
    mCon_flow_nominal=mHeaWat_flow_nominal,
    mEva_flow_nominal=mChiWat_flow_nominal,
    dpCon_nominal=dpHeaWat_nominal,
    dpEva_nominal=dpChiWat_nominal,
    PLRHeaSup={1},
    PLRCooSup={1},
    PLRShcSup={1},
    use_TConOutForTab=true,
    use_TEvaOutForTab=true,
    fileNameHea="",
    fileNameCoo="",
    fileNameShc="",
    devIde="")
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDepSHC.Generic
    "Performance data in simultaneous heating and cooling mode"
    annotation(Dialog(group="Performance data",
      enable=typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent),
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-40},{10,-20}})));
  parameter Modelica.Units.SI.Power P_min(min=0)=0
    "Minimum power when system is enabled with compressor cycled off"
    annotation(Dialog(group="Performance data"));
annotation(defaultComponentPrefixes="parameter",
  defaultComponentName="datHp",
  Documentation(
    info="<html>
<p>
  This record provides the set of sizing and operating parameters for heat
  pump models that can be found within
  <a href=\"modelica://Buildings.Templates.Components.HeatPumps\">
    Buildings.Templates.Components.HeatPumps</a>.
</p>
<h4>Performance data</h4>
<p>
  The design capacity is used to parameterize the heat pump model. The
  capacity (and power) computed from the external performance data file will
  be scaled to match the value provided at design conditions.
</p>
<p>
  Also note that placeholders values are assigned to some parameters of the
  subrecords <code>perCoo</code> and <code>perShc</code> which are used to 
  specify the performance data in cooling mode and SHC mode, respectively. 
  These values should be overwritten for reversible and polyvalent heat
  pumps. This overwriting happens automatically when redeclaring or
  reassigning the performance records <code>perCoo</code> and <code>perShc</code>.
</p>
</html>"));
end HeatPump;
