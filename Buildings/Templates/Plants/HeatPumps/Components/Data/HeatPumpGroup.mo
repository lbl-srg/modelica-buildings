within Buildings.Templates.Plants.HeatPumps.Components.Data;
record HeatPumpGroup
  extends Modelica.Icons.Record;
  parameter Integer nHp(
    final min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
  parameter Buildings.Templates.Components.Types.HeatPumpModel typMod
    "Type of heat pump model"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
  // Default fluid properties
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHeaWat_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "HW default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  /*
  cpChiWat_default is for internal use only.
  It is the same as cpChiWat_default for reversible HP.
  Non-reversible HP that can be controlled to produce either HW or CHW
  shall be modeled with chiller components (as a chiller/heater).
  */
    final parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    cpHeaWat_default
    "CHW default specific heat capacity";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpSou_default=if typ ==
    Buildings.Templates.Components.Types.HeatPump.AirToWater then Buildings.Utilities.Psychrometrics.Constants.cpAir
    else Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Source fluid default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  // RFE: Declare array parameters for unequally sized units.
  // The current implementation only supports equally sized units.
  parameter Modelica.Units.SI.MassFlowRate mHeaWatHp_flow_nominal(
    final min=0)
    "HW mass flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatHp_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capHeaHp_nominal
    "Heating capacity - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSupHp_nominal(
    final min=273.15)
    "(Highest) HW supply temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature THeaWatRetHp_nominal=
    THeaWatSupHp_nominal - abs(capHeaHp_nominal) / cpHeaWat_default /
    mHeaWatHp_flow_nominal
    "HW return temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatHp_flow_nominal(
    start=0,
    final min=0)
    "CHW mass flow rate - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Nominal condition",
      enable=is_rev));
  final parameter Modelica.Units.SI.PressureDifference dpChiWatHp_nominal=
    dpHeaWatHp_nominal *(mChiWatHp_flow_nominal / mHeaWatHp_flow_nominal) ^ 2
    "Pressure drop at design CHW mass flow rate - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capCooHp_nominal(
    start=0)
    "Cooling capacity - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=is_rev));
  parameter Modelica.Units.SI.Temperature TChiWatSupHp_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=253.15)
    "(Lowest) CHW supply temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=is_rev));
  final parameter Modelica.Units.SI.Temperature TChiWatRetHp_nominal=if is_rev
    then TChiWatSupHp_nominal + abs(capCooHp_nominal) / cpChiWat_default /
    mChiWatHp_flow_nominal else Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=is_rev));
  parameter Modelica.Units.SI.Temperature TSouHeaHp_nominal(
    start=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    final min=220)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode - Each heat pump"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mSouWwHeaHp_flow_nominal(
    start=mHeaWatHp_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in heating mode - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouWwHeaHp_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouHeaHp_flow_nominal=if typ ==
    Buildings.Templates.Components.Types.HeatPump.WaterToWater then mSouWwHeaHp_flow_nominal
    else Buildings.Templates.Data.Defaults.mAirFloByCapChi * abs(capHeaHp_nominal)
    "Source fluid mass flow rate in heating mode - Each heat pump"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouHeaHp_nominal=if typ ==
    Buildings.Templates.Components.Types.HeatPump.WaterToWater then dpSouWwHeaHp_nominal
    else Buildings.Templates.Data.Defaults.dpAirChi
    "Source fluid pressure drop in heating mode - Each heat pump";
  parameter Modelica.Units.SI.Temperature TSouCooHp_nominal(
    start=Buildings.Templates.Data.Defaults.TOutHpCoo,
    final min=273.15)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode - Each heat pump"
    annotation (Dialog(group="Nominal condition",
      enable=is_rev));
  parameter Modelica.Units.SI.MassFlowRate mSouWwCooHp_flow_nominal(
    start=mChiWatHp_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in cooling mode - Each heat pump"
    annotation (Evaluate=true,
    Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater and is_rev));
  final parameter Modelica.Units.SI.MassFlowRate mSouCooHp_flow_nominal=if typ ==
    Buildings.Templates.Components.Types.HeatPump.WaterToWater then mSouWwCooHp_flow_nominal
    else Buildings.Templates.Data.Defaults.mAirFloByCapChi * abs(capCooHp_nominal)
    "Source fluid mass flow rate in cooling mode - Each heat pump"
    annotation (Evaluate=true);
  final parameter Modelica.Units.SI.PressureDifference dpSouCooHp_nominal=
    dpSouHeaHp_nominal *(mSouCooHp_flow_nominal / mSouHeaHp_flow_nominal) ^ 2
    "Source fluid pressure drop in cooling mode - Each heat pump";
  replaceable parameter Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump modHeaHp(
    mCon_flow_nominal=mHeaWatHp_flow_nominal,
    mEva_flow_nominal=mSouHeaHp_flow_nominal,
    dpCon_nominal=dpHeaWatHp_nominal,
    dpEva_nominal=dpSouHeaHp_nominal,
    tabPEle=[
      0, TSouHeaHp_nominal;
      THeaWatSupHp_nominal, 0],
    tabQCon_flow=[
      0, TSouHeaHp_nominal;
      THeaWatSupHp_nominal, 0],
    tabUppBou=[
      TSouHeaHp_nominal, THeaWatSupHp_nominal],
    devIde="",
    use_TConOutForOpeEnv=true,
    use_TEvaOutForOpeEnv=false,
    use_TConOutForTab=true,
    use_TEvaOutForTab=false)
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump
    "Performance data in heating mode - Modular model"
    annotation (Dialog(enable=typMod==Buildings.Templates.Components.Types.HeatPumpModel.ModularTableData2D),
  choicesAllMatching=true,
  Placement(transformation(extent={{-38,0},{-22,16}})));
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic modCooHp(
    mCon_flow_nominal=mSouCooHp_flow_nominal,
    mEva_flow_nominal=mChiWatHp_flow_nominal,
    dpCon_nominal=dpSouCooHp_nominal,
    dpEva_nominal=dpChiWatHp_nominal,
    tabPEle=[
      0, TSouCooHp_nominal;
      TSouCooHp_nominal, 0],
    tabQEva_flow=[
      0, TSouCooHp_nominal;
      TSouCooHp_nominal, 0],
    tabLowBou=[
      TSouCooHp_nominal, TChiWatSupHp_nominal],
    devIde="",
    use_TConOutForOpeEnv=false,
    use_TEvaOutForOpeEnv=true,
    use_TConOutForTab=false,
    use_TEvaOutForTab=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    "Performance data in cooling mode - Modular model - Each heat pump"
    annotation (Dialog(enable=typMod==Buildings.Templates.Components.Types.HeatPumpModel.ModularTableData2D
      and is_rev),
  choicesAllMatching=true,
  Placement(transformation(extent={{22,0},{38,16}})));
  replaceable parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic perFitHp(
    dpHeaLoa_nominal=dpHeaWatHp_nominal,
    dpHeaSou_nominal=dpSouHeaHp_nominal,
    hea(
      Q_flow=abs(capHeaHp_nominal),
      P=0,
      mLoa_flow=mHeaWatHp_flow_nominal,
      mSou_flow=mSouHeaHp_flow_nominal,
      coeQ={1, 0, 0, 0, 0},
      coeP={1, 0, 0, 0, 0},
      TRefLoa=THeaWatRetHp_nominal,
      TRefSou=TSouHeaHp_nominal),
    coo(
      Q_flow=if is_rev then - abs(capCooHp_nominal) else - 1,
      P=0,
      mLoa_flow=mChiWatHp_flow_nominal,
      mSou_flow=mSouCooHp_flow_nominal,
      coeQ={1, 0, 0, 0, 0},
      coeP={1, 0, 0, 0, 0},
      TRefLoa=TChiWatRetHp_nominal,
      TRefSou=TSouCooHp_nominal))
    constrainedby Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic
    "Performance data - Equation fit model - Each heat pump"
    annotation (Dialog(enable=typMod==Buildings.Templates.Components.Types.HeatPumpModel.EquationFit),
  choicesAllMatching=true,
  Placement(transformation(extent={{-8,-40},{8,-24}})));
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datHp");
end HeatPumpGroup;
