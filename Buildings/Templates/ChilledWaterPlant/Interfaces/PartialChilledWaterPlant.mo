within Buildings.Templates.ChilledWaterPlant.Interfaces;
partial model PartialChilledWaterPlant
  parameter Buildings.Templates.Types.ChilledWaterPlant typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  replaceable package Medium = Buildings.Media.Water;

  inner parameter String id
    "System name"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  inner parameter Integer nChi "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // FIXME: should be further specified: CW or CHW pumps?
  parameter Boolean have_dedPum
    "Set to true if parallel chillers are connected to dedicated pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));

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
  parameter Modelica.Units.SI.Temperature TCHWSupSet_nominal=
    dat.getReal(varName=id + ".ChillerGroup.TCHWSupSet_nominal.value")
    "Design (minimum) CHW supply temperature setpoint";
  parameter Modelica.Units.SI.MassFlowRate mCHWChi_flow_nominal[nChi]=
    dat.getRealArray1D(varName=id + ".ChillerGroup.mCHWChi_flow_nominal.value", n=nChi)
    "Design (maximum) chiller CHW mass flow rate (for each chiller)";
  final parameter Modelica.Units.SI.MassFlowRate mCHWPri_flow_nominal=
    sum(mCHWChi_flow_nominal)
    "Design (maximum) primary CHW mass flow rate (for the plant)";
  // FIXME: For primary-secondary, add secondary CHW flow rate at design.

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium=Medium) "Chilled water supply"
    annotation (Placement(transformation(extent={{190,0},{210,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium=Medium) "Chilled water return"
    annotation (Placement(transformation(extent={{190,-80},{210,-60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather control bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={0,100})));

protected
  parameter Boolean isAirCoo=
    typ == Buildings.Templates.Types.ChilledWaterPlant.AirCooledParallel or
    typ == Buildings.Templates.Types.ChilledWaterPlant.AirCooledSeries
    "= true, chillers in group are air cooled,
    = false, chillers in group are water cooled";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},
            {200,100}}),                                        graphics={
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
