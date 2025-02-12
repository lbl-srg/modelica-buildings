within Buildings.Templates.Components.Data;
record Chiller
  "Record for chiller model"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW default specific heat capacity"
    annotation (Dialog(group="Configuration"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon_default=if typ ==
    Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    else Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Condenser cooling fluid default specific heat capacity"
    annotation (Dialog(group="Configuration"));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal(
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then mChiWat_flow_nominal elseif typ == Buildings.Templates.Components.Types.Chiller.AirCooled
      then Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(cap_nominal)
      else 0,
    final min=0)
    "Condenser cooling fluid (e.g. CW) mass flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal
    "Cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(
    final min=0)=abs(cap_nominal) *(1 / COP_nominal + 1)
    "Condenser heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COP_nominal(
    final min=1,
    final unit="1")
    "Cooling COP"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then Buildings.Templates.Data.Defaults.dpConWatChi
      elseif typ == Buildings.Templates.Components.Types.Chiller.AirCooled
      then Buildings.Templates.Data.Defaults.dpAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    final min=260)
    "CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal(
    final min=260)=TChiWatSup_nominal + abs(cap_nominal) /
    cpChiWat_default / mChiWat_flow_nominal
    "CHW return temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_min=TChiWatSup_nominal
    "Minimum CHW supply temperature"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max=
    Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConEnt_nominal(
    final min=273.15)
    "Condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Chiller.None));
  // The following parameter is not declared as final to allow parameterization
  // based on leaving CHW temperature. In this case, the user shall compute
  // TConEnt_nominal from TConLvg_nominal.
  parameter Modelica.Units.SI.Temperature TConLvg_nominal=
    TConEnt_nominal + QCon_flow_nominal / mCon_flow_nominal / cpCon_default
    "Condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConLvg_min(
    final min=273.15)=Buildings.Templates.Data.Defaults.TConLvg_min
    "Minimum condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConLvg_max(
    final min=273.15)=Buildings.Templates.Data.Defaults.TConLvg_max
    "Maximum condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Real PLRUnl_min(
    start=0,
    final min=PLR_min,
    final max=1)=PLR_min
    "Minimum unloading ratio (before engaging hot gas bypass, if any)";
  parameter Real PLR_min(
    start=0,
    final min=0,
    final max=1)=0.15
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic per(
    COP_nominal=COP_nominal,
    QEva_flow_nominal=- abs(cap_nominal),
    TConLvg_nominal=TConLvg_nominal,
    TConLvgMin=TConLvg_min,
    TConLvgMax=TConLvg_max,
    TEvaLvg_nominal=TChiWatSup_nominal,
    TEvaLvgMin=TChiWatSup_nominal,
    TEvaLvgMax=TChiWatSup_max,
    PLRMin=PLR_min,
    PLRMinUnl=PLRUnl_min,
    PLRMax=1.0,
    etaMotor=1.0,
    mEva_flow_nominal=mChiWat_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal)
    "Chiller performance data"
    annotation (choicesAllMatching=true);
  final parameter Real COPPer_nominal(
    final min=0,
    final unit="1")=per.COP_nominal /
      Buildings.Utilities.Math.Functions.biquadratic(
        a=per.EIRFunT,
        x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
        x2=Modelica.Units.Conversions.to_degC(TConLvg_nominal)) / Buildings.Utilities.Math.Functions.bicubic(
        a=per.EIRFunPLR,
        x1=Modelica.Units.Conversions.to_degC(TConLvg_nominal),
        x2=1)
    "Cooling COP computed at design conditions from performance record"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate capPer_flow_nominal=abs(per.QEva_flow_nominal) *
    Buildings.Utilities.Math.Functions.biquadratic(
      a=per.capFunT,
      x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
      x2=Modelica.Units.Conversions.to_degC(TConLvg_nominal))
    "Cooling capacity computed at design conditions from performance record"
    annotation (Dialog(group="Nominal condition"));
  final parameter Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic perSca(
    final COP_nominal=per.COP_nominal * COP_nominal / COPPer_nominal,
    final QEva_flow_nominal=per.QEva_flow_nominal * abs(cap_nominal) /
      capPer_flow_nominal,
    final EIRFunPLR=per.EIRFunPLR,
    final EIRFunT=per.EIRFunT,
    final PLRMax=per.PLRMax,
    final PLRMin=per.PLRMin,
    final PLRMinUnl=per.PLRMinUnl,
    final TConLvgMax=per.TConLvgMax,
    final TConLvgMin=per.TConLvgMin,
    final TConLvg_nominal=per.TConLvg_nominal,
    final TEvaLvgMax=per.TEvaLvgMax,
    final TEvaLvgMin=per.TEvaLvgMin,
    final TEvaLvg_nominal=per.TEvaLvg_nominal,
    final capFunT=per.capFunT,
    final etaMotor=per.etaMotor,
    final mCon_flow_nominal=per.mCon_flow_nominal,
    final mEva_flow_nominal=per.mEva_flow_nominal)
    "Chiller performance data scaled to specified design capacity and COP"
    annotation (choicesAllMatching=true);
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datChi",
    Documentation(
      info="<html>
<p>
This record provides the set of sizing and operating parameters for
the classes within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>.
It is composed of a set of parameters corresponding to the design
(selection) conditions and a sub-record <code>per</code> corresponding
to the rating conditions at which the performance curves <code>per.capFunT</code>,
<code>per.EIRFunT</code> and <code>per.EIRFunPLR</code> are calculated.
</p>
<p>
The performance data specified in the sub-record
<code>per</code> are \"translated\" so that the capacity and cooling <i>COP</i>
calculated at design conditions match the design values
<code>cap_nominal</code> and <code>COP_nominal</code>.
The performance data that result from this translation are stored in
the sub-record <code>perSca</code> which is ultimately used by the chiller models within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>.<br/>
Note that the performance data can be specified either by redeclaring
the sub-record <code>per</code>, or by simply assigning the performance
curves <code>per.capFunT</code>, <code>per.EIRFunT</code> and <code>per.EIRFunPLR</code>
in case these curves were calculated based on the design conditions.
To support the former, the design conditions are propagated \"down\" to
the sub-record <code>per</code> but these bindings do not persist
after redeclaration so that a record at different rating conditions can
also be used.
</p>
</html>"));
end Chiller;
