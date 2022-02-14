within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model PartialChilledWaterPlant
  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration
    typ "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable package Medium = Buildings.Media.Water;

  inner parameter String id
    "System name"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  /*
  FIXME: Those parameters must be declared at the plant level, not within the chiller group
  (external parameter file to be updated)
  */
  parameter Modelica.Units.SI.HeatFlowRate QChi_flow_nominal[nChi](
    each final max=0)=
    -1 .* dat.getRealArray1D(varName=id + ".ChillerGroup.capacity.value", n=nChi)
    "Cooling heat flow rate of each chiller (<0 by convention)";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(final max=0)=
    sum(QChi_flow_nominal)
    "Cooling heat flow rate of the plant (<0 by convention)";
  parameter Modelica.Units.SI.Temperature TCHWSup_nominal=
    dat.getReal(varName=id + ".ChillerGroup.TCHWSup_nominal.value")
    "Design (minimum) CHW supply temperature (identical for all chillers)";
  parameter Modelica.Units.SI.MassFlowRate mCHWChi_flow_nominal[nChi]=
    dat.getRealArray1D(varName=id + ".ChillerGroup.mCHWChi_flow_nominal.value", n=nChi)
    "Design (maximum) chiller CHW mass flow rate (for each chiller)";
  final parameter Modelica.Units.SI.MassFlowRate mCHWPri_flow_nominal=
    sum(mCHWChi_flow_nominal)
    "Design (maximum) primary CHW mass flow rate (for the plant)";
  parameter Modelica.Units.SI.MassFlowRate mCHWSec_flow_nominal=
    if not have_secondary then mCHWPri_flow_nominal else
    dat.getReal(varName=id + ".ChilledWater.mCHWSec_flow_nominal.value")
    "CHW secondary mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpDem_nominal=
    dat.getReal(varName=id + ".ChilledWater.dpSetPoi.value")
    "Differential pressure setpoint on the demand side";

  inner parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumPri "Number of primary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumSec "Number of secondary pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nPumCon "Number of condenser pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Integer nCooTow = nChi "Number of cooling towers"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Boolean have_CHWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_CWDedPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_secondary
    "= true if plant has secondary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  inner parameter Boolean have_WSE
    "=true if plant has waterside economizer"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Chilled water supply"
    annotation (Placement(transformation(extent={{190,0},{210,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather control bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=180,
      origin={0,100})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon
    "Chilled water loop control bus"
    annotation (Placement(transformation(
      extent={{-20,20},{20,-20}},
      rotation=90,
      origin={200,60})));
protected
  final inner parameter Boolean isAirCoo=
    typ == Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.AirCooled
    "= true, chillers in group are air cooled, 
    = false, chillers in group are water cooled";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-100},{200,100}}),
    graphics={
      Rectangle(
        extent={{-200,100},{200,-100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
        preserveAspectRatio=false, extent={{-200,-100},{200,100}}), graphics={
      Rectangle(
        extent={{-200,80},{200,40}},
        lineColor={0,0,0},
        fillPattern=FillPattern.Solid,
        fillColor={245,239,184},
        pattern=LinePattern.None)}));
end PartialChilledWaterPlant;
