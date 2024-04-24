within Buildings.Templates.Components.Data;
record Chiller "Record for chiller model"
  extends Modelica.Icons.Record;

  parameter Boolean use_datDes = true
    "Set to true to use specified design conditions, false to use data from performance record"
    annotation(Evaluate=true, __ctrlFlow(enable=false));
  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon_default=
    if typ==Buildings.Templates.Components.Types.Chiller.AirCooled then
       Buildings.Utilities.Psychrometrics.Constants.cpAir else
       Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Condenser cooling fluid default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    start=if not use_datDes then per.mEva_flow_nominal else 1E-3,
    final min=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal(
    start=if not use_datDes then per.mCon_flow_nominal elseif
     typ==Buildings.Templates.Components.Types.Chiller.AirCooled then
     Buildings.Templates.Data.Defaults.mAirFloByCapChi * abs(cap_nominal)
     else 1E-3,
    final min=0)
    "Condenser cooling fluid (e.g. CW) mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled and use_datDes));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    start=if not use_datDes then abs(per.QEva_flow_nominal) else 1E-3)
    "Cooling capacity"
    annotation (
    Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  final parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(final min=0)=
    abs(cap_nominal) * (1/COP_nominal + 1)
    "Condenser heat flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Real COP_nominal(
    start=if not use_datDes then per.COP_nominal else
    Buildings.Templates.Data.Defaults.COPChiAirCoo,
    final min=1,
    final unit="1")
    "Cooling COP"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Chiller.None then 0 else
    Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
    then Buildings.Templates.Data.Defaults.dpConWatChi elseif
    typ == Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Templates.Data.Defaults.dpAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    start=if not use_datDes then per.TEvaLvg_nominal else
    Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=260)
    "CHW supply temperature"
    annotation(Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal(
    final min=260)=if typ==Buildings.Templates.Components.Types.Chiller.None then TChiWatSup_nominal
    else TChiWatSup_nominal+abs(cap_nominal)/cpChiWat_default/mChiWat_flow_nominal
    "CHW return temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_min(
    start=if not use_datDes then per.TEvaLvgMin else
    Buildings.Templates.Data.Defaults.TChiWatSup_min)=
    Buildings.Templates.Data.Defaults.TChiWatSup_min
    "Minimum CHW supply temperature"
    annotation(Dialog(group="Operating limits",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max(
    start=if not use_datDes then per.TEvaLvgMax else
    Buildings.Templates.Data.Defaults.TChiWatSup_max)=
    Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature"
    annotation(Dialog(group="Operating limits",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.Temperature TConEnt_nominal(
    final min=273.15,
    start=if not use_datDes then per.TConLvg_nominal - QCon_flow_nominal / mCon_flow_nominal / cpCon_default
    else Buildings.Templates.Data.Defaults.TConEnt_max)
    "Condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  // The following parameter is not declared as final to allow parameterization
  // based on leaving CHW temperature.
  parameter Modelica.Units.SI.Temperature TConLvg_nominal=
    if not use_datDes then per.TConLvg_nominal
    else TConEnt_nominal + QCon_flow_nominal / mCon_flow_nominal / cpCon_default
    "Condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Nominal condition",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.Temperature TConLvg_min(
    start=if not use_datDes then per.TConLvgMin else Buildings.Templates.Data.Defaults.TConLvg_min,
    final min=273.15)= Buildings.Templates.Data.Defaults.TConLvg_min
    "Minimum condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Modelica.Units.SI.Temperature TConLvg_max(
    start=if not use_datDes then per.TConLvgMax else Buildings.Templates.Data.Defaults.TConLvg_max,
    final min=273.15)=
    Buildings.Templates.Data.Defaults.TConLvg_max
    "Maximum condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits",
    enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Real PLRUnl_min(
    start=if not use_datDes then per.PLRMinUnl else 0,
    final min=PLR_min,
    final max=1)=PLR_min
    "Minimum unloading ratio (before engaging hot gas bypass, if any)"
    annotation (Dialog(enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  parameter Real PLR_min(
    start=if not use_datDes then per.PLRMin else 0,
    final min=0,
    final max=1)=0.15
    "Minimum part load ratio before cycling"
    annotation (Dialog(enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic per(
    TConLvg_nominal=if use_datDes then TConLvg_nominal else 273.15,
    TConLvgMin=if use_datDes then TConLvg_min else 273.15,
    TConLvgMax=if use_datDes then TConLvg_max else 273.15,
    COP_nominal=if use_datDes then COP_nominal else 1.1,
    QEva_flow_nominal=if use_datDes then -abs(cap_nominal) else 1E-3,
    TEvaLvg_nominal=if use_datDes then TChiWatSup_nominal else 273.15,
    TEvaLvgMin=if use_datDes then TChiWatSup_nominal else 273.15,
    TEvaLvgMax=if use_datDes then TChiWatSup_max else 273.15,
    PLRMin=if use_datDes then PLR_min else 0,
    PLRMinUnl=if use_datDes then PLRUnl_min else 0,
    PLRMax=1.0,
    etaMotor=1.0,
    mEva_flow_nominal=if use_datDes then mChiWat_flow_nominal else 1E-3,
    mCon_flow_nominal=if use_datDes then mCon_flow_nominal else 1E-3,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0,0,0,0,0,0,0,0})
    constrainedby Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic
    "Chiller performance data"
    annotation (
    choicesAllMatching=true,
    Dialog(enable=typ<>Buildings.Templates.Components.Types.Chiller.None and use_datDes));
  final parameter Real COPPer_nominal(
    final min=0,
    final unit="1")=if typ==Buildings.Templates.Components.Types.Chiller.None
    then per.COP_nominal
    else per.COP_nominal /
    Buildings.Utilities.Math.Functions.biquadratic(
      a=per.EIRFunT,
      x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
      x2=Modelica.Units.Conversions.to_degC(TConLvg_nominal)) /
    Buildings.Utilities.Math.Functions.bicubic(
      a=per.EIRFunPLR,
      x1=Modelica.Units.Conversions.to_degC(TConLvg_nominal),
      x2=1)
    "Cooling COP computed from performance record"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate capPer_flow_nominal =
    if typ==Buildings.Templates.Components.Types.Chiller.None then abs(per.QEva_flow_nominal)
    else abs(per.QEva_flow_nominal) * Buildings.Utilities.Math.Functions.biquadratic(
      a=per.capFunT,
      x1=Modelica.Units.Conversions.to_degC(TChiWatSup_nominal),
      x2=Modelica.Units.Conversions.to_degC(TConLvg_nominal))
    "Cooling capacity computed from performance record"
    annotation(Dialog(group="Nominal condition"));
  final parameter Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic perSca(
    final COP_nominal=per.COP_nominal * COP_nominal / COPPer_nominal,
    final QEva_flow_nominal=per.QEva_flow_nominal * abs(cap_nominal) / capPer_flow_nominal,
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
    annotation (
    choicesAllMatching=true);
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName="datChi",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the classes within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>.
It is composed of a set of parameters corresponding to the design
(selection) conditions and a sub-record <code>per</code> corresponding 
to the rating conditions at which the performance curves are calculated.
</p>
<p>
The record allows two different parameterization logics, depending
on the value of the parameter <code>use_datDes</code>.
(The user can refer to the valiation model
<a href=\"modelica://Buildings.Templates.Components.Chillers.Validation.Compression\">
Buildings.Templates.Components.Chillers.Validation.Compression</a>
for an illustration of these two logics.)
</p>
<ul>
<li>
If <code>use_datDes=true</code> &ndash; default setting that should be
used in most cases: The performance data specified in the sub-record 
<code>per</code> are \"translated\" so that the capacity and <i>COP</i> 
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
To support the latter, the design conditions are propagated \"down\" to 
the sub-record <code>per</code> but these bindings do not persist
after redeclaration so that a record at different rating conditions can
also be used.
</li>
<li>
If <code>use_datDes=false</code> &ndash; non-default setting that should only be
used if the rating conditions match the design conditions: 
The rating conditions specified in the sub-record 
<code>per</code> are propagated \"up\" (via the <code>start</code> attribute)
and used as design conditions.
The sub-record <code>perSca</code> which is ultimately used by the chiller models within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>
is then identical to the sub-record <code>per</code>.
When using this logic, no assignment shall be made for the design
parameters, except for the design pressure drops <code>dp*_nominal</code>.
</li>
</ul>
<p>
note that placeholders values are assigned to the performance curves,
the reference source temperature and the input power in
cooling mode to avoid assigning these parameters in case of non-reversible
heat pumps.
These values are unrealistic and must be overwritten for reversible heat pumps, which
is always the case when redeclaring or
reassigning the performance record <code>per</code>.
Models that use this record will issue a warning if these placeholders values
are not overwritten in case of reversible heat pumps.
</p>
Note that placeholders values are assigned to the chiller performance curves
(<code>per.capFunT</code> , <code>per.EIRFunT</code> and <code>per.EIRFunPLR</code>) 
to avoid assigning these parameters if
<code>typ=Buildings.Templates.Components.Types.Chiller.None</code>.
If the chiller type is not <code>None</code> these values are unrealistic 
and must be overwritten, which is always the case when redeclaring or
reassigning the performance record <code>per</code>.
</p>
</p>
</html>"));
end Chiller;
