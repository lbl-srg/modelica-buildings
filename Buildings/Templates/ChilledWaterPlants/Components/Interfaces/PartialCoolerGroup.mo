within Buildings.Templates.ChilledWaterPlants.Components.Interfaces;
partial model PartialCoolerGroup
  "Interface class for cooler group"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal);

  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium model"
    annotation(__Linkage(enable=false));

  parameter Integer nCoo(final min=0)
    "Number of cooler units (count one unit for each cooling tower cell)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Type of cooler"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_varCom=true
    "Set to true for single common speed signal, false for dedicated signals"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso
    "Type of cooler inlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso
    "Type of cooler outlet isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.CoolerGroup dat(
    final typCoo=typCoo,
    final nCoo=nCoo)
    "Design and operating parameters";
  final parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal[nCoo]=
    dat.mConWatCoo_flow_nominal
    "CW mass flow rate - Each cooler unit";
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal=
    sum(mConWatCoo_flow_nominal)
    "Total CW mass flow rate (all units)";
  final parameter Modelica.Units.SI.PressureDifference dpConWatFriCoo_nominal[nCoo]=
    dat.dpConWatFriCoo_nominal
    "CW flow-friction losses through equipment and piping only - Each cooler unit (without elevation head or valve)";
  final parameter Modelica.Units.SI.PressureDifference dpConWatStaCoo_nominal[nCoo]=
    dat.dpConWatStaCoo_nominal
    "CW elevation head - Each cooler unit";
  final parameter Modelica.Units.SI.MassFlowRate mAirCoo_flow_nominal[nCoo]=
    dat.mAirCoo_flow_nominal
    "Air mass flow rate - Each cooler unit";

  final parameter Buildings.Templates.Components.Data.Cooler datCoo[nCoo](
    final typ=fill(typCoo, nCoo),
    final mConWat_flow_nominal=dat.mConWatCoo_flow_nominal,
    final dpConWatFri_nominal=if typValCooInlIso==Buildings.Templates.Components.Types.Valve.None and
      typValCooOutIso==Buildings.Templates.Components.Types.Valve.None then
      dat.dpConWatFriCoo_nominal else fill(0, nCoo),
    final dpConWatSta_nominal=dat.dpConWatStaCoo_nominal,
    final mAir_flow_nominal=dat.mAirCoo_flow_nominal,
    final TAirEnt_nominal=fill(dat.TAirEnt_nominal, nCoo),
    final TWetBulEnt_nominal=fill(dat.TWetBulEnt_nominal, nCoo),
    final TConWatRet_nominal=fill(dat.TConWatRet_nominal, nCoo),
    final TConWatSup_nominal=fill(dat.TConWatSup_nominal, nCoo),
    final PFan_nominal=dat.PFanCoo_nominal)
    "Parameter record - Each cooler unit";
  final parameter Buildings.Templates.Components.Data.Valve datValCooInlIso[nCoo](
    final typ=fill(typValCooInlIso, nCoo),
    final m_flow_nominal=mConWatCoo_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nCoo),
    dpFixed_nominal=if typValCooInlIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpConWatFriCoo_nominal else fill(0, nCoo))
    "Inlet isolation valve parameters"
    annotation (Dialog(enable=false));
  final parameter Buildings.Templates.Components.Data.Valve datValCooOutIso[nCoo](
    final typ=fill(typValCooOutIso, nCoo),
    final m_flow_nominal=mConWatCoo_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nCoo),
    dpFixed_nominal=
      if typValCooInlIso==Buildings.Templates.Components.Types.Valve.None and
      typValCooOutIso<>Buildings.Templates.Components.Types.Valve.None then
      dat.dpConWatFriCoo_nominal else fill(0, nCoo))
    "Outlet isolation valve parameters"
    annotation (Dialog(enable=false));

  parameter Modelica.Units.SI.Time tau=30
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(extent={{-20,280},{20,320}})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather data bus"
    annotation (Placement(transformation(extent={{-80,80},{-40,120}}),
        iconTransformation(extent={{-320,280},{-280,320}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repSpe(
    final nout=nCoo) if have_varCom
    "Replicate signal in case of common unique commanded speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,70})));
  Modelica.Blocks.Routing.RealPassThrough pasSpe[nCoo]
    if not have_varCom
    "Direct pass through for dedicated speed signal"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,70})));
  Modelica.Blocks.Routing.BooleanPassThrough pasSta[nCoo]
    "Direct pass through for Start/Stop signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,70})));
protected
  Buildings.Templates.Components.Interfaces.Bus busCoo[nCoo]
    "Cooler control bus"
    annotation (Placement(transformation(extent={{-20,20},
            {20,60}}),  iconTransformation(extent={{-350,6},{-310,46}})));
equation
  connect(repSpe.y, busCoo.y)
    annotation (Line(points={{0,58},{0,40}}, color={0,0,127}));
  connect(pasSpe.y, busCoo.y)
    annotation (Line(points={{40,59},{40,50},{0,50},{0,40}}, color={0,0,127}));
  connect(bus.yCoo, repSpe.u) annotation (Line(
      points={{0,100},{0,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bus.yCoo, pasSpe.u) annotation (Line(
      points={{0,100},{0,90},{40,90},{40,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCoo, bus.coo) annotation (Line(
      points={{0,40},{80,40},{80,96},{6,96},{6,100},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus.y1Coo, pasSta.u) annotation (Line(
      points={{0,100},{0,90},{-40,90},{-40,82}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pasSta.y, busCoo.y1) annotation (Line(points={{-40,59},{-40,40},{0,40}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-820,-300},{820,300}})),
    Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for cooler group models.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available for all
models inheriting from this interface.
</p>
<ul>
<li>
Cooler Start/Stop command (VFD Run) <code>y1Coo</code>: 
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Cooler speed command (VFD Speed) <code>yCoo</code>: 
<ul>
<li>
If <code>have_varCom</code>: AO signal common to all units, 
with a dimensionality of zero
</li>
<li>
If <code>not have_varCom</code>: AO signal dedicated to each unit, 
with a dimensionality of one
</li>
</ul>
</li>
<li>
Sub-bus <code>coo</code> storing all signals dedicated 
to each unit, with a dimensionality of one
<ul>
<li>
At least the cooler status (through VFD interface, VFD status contact, 
or current switch) should be available as <code>coo.y1_actual</code>: 
DI signal dedicated to each unit, with a dimensionality of one
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCoolerGroup;
