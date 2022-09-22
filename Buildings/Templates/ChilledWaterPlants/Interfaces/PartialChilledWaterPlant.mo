within Buildings.Templates.ChilledWaterPlants.Interfaces;
partial model PartialChilledWaterPlant "Interface class for CHW plant"
  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumCon=Modelica.Media.Interfaces.PartialMedium
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model for condenser cooling fluid";

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nChi(
    start=1,
    final min=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi_select(
    start=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel)
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=nChi>1));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi=
    if nChi==1 then Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    else typArrChi_select
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Boolean have_bypChiWatFix=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed
    "Set to true if the plant has a fixed CHW bypass"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_pumChiWatSec=
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 or
    typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
    "Set to true if the plant includes secondary CHW pumps"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  // The following parameter stores the user selection.
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri_select(
    start=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered)
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=nChi>1));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri=
    if nChi==1 then Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated else
    typArrPumChiWatPri_select
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter stores the user selection.
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumConWat_select(
    start=Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered)
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=nChi>1 and
      typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumConWat=
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None then
      Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered
    else typArrPumConWat_select
    "Type of CW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatPri=
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only or
      typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2 then
    Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant
    else Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    "Type of primary CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumChiWatSec=
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only or
      typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only then
      Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant
    else Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    "Type of secondary CHW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  /*
  The following parameter stores the user selection.
  We use the type PumpSingleSpeedControl instead of PumpMultipleSpeedControl because 
  the user may only select between constant and variable. 
  The choice between a single common speed point or multiple dedicated speed points 
  is constrained by the system configuration, see typCtrSpePumConWat.
  */
  parameter Buildings.Templates.Components.Types.PumpSingleSpeedControl typCtrSpePumConWat_select(
    start=Buildings.Templates.Components.Types.PumpSingleSpeedControl.Constant)
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled and
      typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));
  // The following parameter stores the actual configuration setting.
  final parameter Buildings.Templates.Components.Types.PumpMultipleSpeedControl typCtrSpePumConWat=
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None then
      Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    elseif typCtrSpePumConWat_select==Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable
      and typArrPumConWat==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Dedicated
      then Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableDedicated
    elseif typCtrSpePumConWat_select==Buildings.Templates.Components.Types.PumpSingleSpeedControl.Variable then
      Buildings.Templates.Components.Types.PumpMultipleSpeedControl.VariableCommon
    else Buildings.Templates.Components.Types.PumpMultipleSpeedControl.Constant
    "Type of CW pump speed control"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl typCtrHea(
    start=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn)
    "Type of head pressure control"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco(
    start=Buildings.Templates.ChilledWaterPlants.Types.Economizer.None)
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));

  parameter Buildings.Templates.Components.Types.Cooler typCoo(
    start=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen)
    "Condenser water cooling equipment"
    annotation(Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nCoo=nChi
    "Number of cooler units"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Integer nPumChiWatSec=nChi
    "Number of secondary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2
     or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2
     or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed));

  // Following parameters to be assigned by derived classes.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValConWatChiIso
    "Type of chiller CW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso
    "Cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso
    "Cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Data.ChilledWaterPlant dat(
    typChi=typChi,
    nChi=nChi,
    nCoo=nCoo,
    typCoo=typCoo,
    nPumChiWatSec=nPumChiWatSec,
    typDisChiWat=typDisChiWat,
    typCtrSpePumConWat=typCtrSpePumConWat,
    have_pumChiWatSec=have_pumChiWatSec)
    "Design and operating parameters";

  final parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal=
    sum(dat.pumChiWatPri.m_flow_nominal)
    "Primary CHW mass flow rate (total)";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=
    if typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only
      or typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only
      then mChiWatPri_flow_nominal else
    sum(dat.pumChiWatSec.m_flow_nominal)
    "CHW mass flow rate (total, distributed to consumers)";
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=
    sum(dat.chi.mConChi_flow_nominal)
    "Condenser cooling fluid mass flow rate (total)";
  final parameter Modelica.Units.SI.HeatFlowRate cap_nominal=
    sum(dat.chi.capChi_nominal)
    "Cooling capacity (total)";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    min(dat.chi.TChiWatChiSup_nominal)
    "Minimum CHW supply temperature";

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{290,-250},{310,-230}}),
        iconTransformation(extent={{192,-112},{212,-92}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumChiWat,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumChiWat.h_default, nominal = MediumChiWat.h_default))
    "CHW supply"
    annotation (Placement(transformation(extent={{290,-10},{310,10}}),
        iconTransformation(extent={{192,90},{212,110}})));
  Buildings.BoundaryConditions.WeatherData.Bus busWea
    "Weather data bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=180,
      origin={0,280}), iconTransformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,200})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "CHW plant control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-300,140}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-200,100})));

  Modelica.Units.SI.MassFlowRate m_flow(start=_m_flow_start)=port_a.m_flow
    "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";

  Modelica.Units.SI.PressureDifference dp(
    start=_dp_start,
    displayUnit="Pa")=port_a.p - port_b.p
    "Pressure difference between port_a and port_b";

  MediumChiWat.ThermodynamicState sta_a=
    if allowFlowReversal then
      MediumChiWat.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow)))
    else
      MediumChiWat.setState_phX(port_a.p,
                          noEvent(inStream(port_a.h_outflow)),
                          noEvent(inStream(port_a.Xi_outflow)))
      if show_T "Medium properties in port_a";

  MediumChiWat.ThermodynamicState sta_b=
    if allowFlowReversal then
      MediumChiWat.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow)))
    else
      MediumChiWat.setState_phX(port_b.p,
                          noEvent(port_b.h_outflow),
                          noEvent(port_b.Xi_outflow))
       if show_T "Medium properties in port_b";

protected
  final parameter Modelica.Units.SI.MassFlowRate _m_flow_start=0
    "Start value for m_flow, used to avoid a warning if not set in m_flow, and to avoid m_flow.start in parameter window";
  final parameter Modelica.Units.SI.PressureDifference _dp_start(
    displayUnit="Pa")=0
    "Start value for dp, used to avoid a warning if not set in dp, and to avoid dp.start in parameter window";

  annotation (
    defaultComponentName="plaChiWat",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-200},{200,200}}),
    graphics={
      Rectangle(
        extent={{-200,200},{202,-200}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-214},{151,-254}},
          textColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-300,-280},{300,280}})),
    Documentation(info="<html>
<p>
Current assumptions and limitations:
</p>
<ul>
<li>
The chillers are assumed to be of the same type as defined 
by the enumeration
<a href=\\\"modelica://Buildings.Templates.Components.Types.Chiller\\\">
Buildings.Templates.Components.Types.Chiller</a> (this is a limitation).
</li>
<li>
The number of installed chillers is supposed to be equal
to the number of chillers operating at design conditions (this is a limitation).
The same holds true for CW and CHW pump groups.
</li>
<li>
Inside the CW and CHW pump groups, the pumps are assumed to 
be equally sized.
</li>
<li>
Variable speed primary CHW pumps are controlled to the same speed, 
whether they are in a dedicated or headered arrangement. 
</li>
<li>
Variable speed CW pumps are controlled to different speeds 
if they are in a dedicated arrangement.
Otherwise they are controlled to the same speed.
</li>
<li>
A plant with a WSE requires variable speed CW pumps that must be
in a headered arrangement.
</li>
<li>
To allow for a WSE, the plant must have water-cooled chillers.
</li>
</ul>
</html>"));
end PartialChilledWaterPlant;
