within Buildings.Templates.Plants.Chillers.Components.Interfaces;
partial model PartialCoolerGroup
  "Interface class for cooler group"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumConWat,
    final m_flow_nominal=mConWat_flow_nominal);

  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium model"
    annotation(__Linkage(enable=false));

  parameter Integer nCoo(final min=0)
    "Number of cooler units (count one unit for each cooling tower cell)"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Type of cooler"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Boolean have_varCom = true
    "Set to true for single common speed signal, false for dedicated signals"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCooInlIso =
    Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Type of cooler inlet isolation valve"
    annotation(Evaluate=true,
      Dialog(group="Configuration"),
      choices(
        choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
          "Two-way two-position valve",
        choice=Buildings.Templates.Components.Types.Valve.None "No Valve"));
  parameter Buildings.Templates.Components.Types.Valve typValCooOutIso =
    typValCooInlIso
    "Type of cooler outlet isolation valve"
    annotation(Evaluate=true,
      Dialog(group="Configuration"),
      choices(
        choice=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
          "Two-way two-position valve",
        choice=Buildings.Templates.Components.Types.Valve.None "No Valve"));
  parameter Buildings.Templates.Plants.Chillers.Components.Data.CoolerGroup dat(
    final typCoo=typCoo,
    final nCoo=nCoo)
    "Design and operating parameters";
  final parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal[nCoo] =
    dat.mConWatCoo_flow_nominal
    "CW mass flow rate - Each cooler unit";
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal =
    sum(mConWatCoo_flow_nominal)
    "Total CW mass flow rate (all units)";
  final parameter Modelica.Units.SI.PressureDifference dpConWatFriCoo_nominal[nCoo] =
    dat.dpConWatFriCoo_nominal
    "CW flow-friction losses through equipment and piping only - Each cooler unit (without elevation head or valve)";
  final parameter Modelica.Units.SI.PressureDifference dpConWatStaCoo_nominal[nCoo] =
    dat.dpConWatStaCoo_nominal
    "CW elevation head - Each cooler unit";
  final parameter Modelica.Units.SI.MassFlowRate mAirCoo_flow_nominal[nCoo] =
    dat.mAirCoo_flow_nominal
    "Air mass flow rate - Each cooler unit";
  final parameter Buildings.Templates.Components.Data.Cooler datCoo[nCoo](
    final typ=fill(typCoo, nCoo),
    final mConWat_flow_nominal=dat.mConWatCoo_flow_nominal,
    final dpConWatFri_nominal=if typValCooInlIso ==
      Buildings.Templates.Components.Types.Valve.None
      and typValCooOutIso == Buildings.Templates.Components.Types.Valve.None
      then dat.dpConWatFriCoo_nominal else fill(0, nCoo),
    final dpConWatSta_nominal=dat.dpConWatStaCoo_nominal,
    final mAir_flow_nominal=dat.mAirCoo_flow_nominal,
    final TAirEnt_nominal=fill(dat.TAirEnt_nominal, nCoo),
    final TWetBulEnt_nominal=fill(dat.TWetBulEnt_nominal, nCoo),
    final TConWatRet_nominal=fill(dat.TConWatRet_nominal, nCoo),
    final TConWatSup_nominal=fill(dat.TConWatSup_nominal, nCoo),
    final PFan_nominal=dat.PFanCoo_nominal,
    final y_min=fill(dat.y_min, nCoo))
    "Parameter record - Each cooler unit";
  final parameter Buildings.Templates.Components.Data.Valve datValCooInlIso[nCoo](
    final typ=fill(typValCooInlIso, nCoo),
    final m_flow_nominal=dat.mConWatCoo_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nCoo),
    dpFixed_nominal=if typValCooInlIso <>
      Buildings.Templates.Components.Types.Valve.None
      then dat.dpConWatFriCoo_nominal else fill(0, nCoo))
    "Inlet isolation valve parameters";
  final parameter Buildings.Templates.Components.Data.Valve datValCooOutIso[nCoo](
    final typ=fill(typValCooOutIso, nCoo),
    final m_flow_nominal=dat.mConWatCoo_flow_nominal,
    dpValve_nominal=fill(Buildings.Templates.Data.Defaults.dpValIso, nCoo),
    dpFixed_nominal=if typValCooInlIso ==
      Buildings.Templates.Components.Types.Valve.None
      and typValCooOutIso <> Buildings.Templates.Components.Types.Valve.None
      then dat.dpConWatFriCoo_nominal else fill(0, nCoo))
    "Outlet isolation valve parameters";
  final parameter Modelica.Units.SI.PressureDifference dpTotCoo_nominal[nCoo] =
    (if typValCooInlIso <> Buildings.Templates.Components.Types.Valve.None
    then datValCooInlIso.dpValve_nominal else fill(0, nCoo)) .+
      (if typValCooOutIso <> Buildings.Templates.Components.Types.Valve.None
      then datValCooOutIso.dpValve_nominal else fill(0, nCoo)) .+
      dat.dpConWatFriCoo_nominal
    "Total pressure drop across each cooler, including isolation valves";
  parameter Modelica.Units.SI.Time tau = 30
    "Time constant at nominal flow"
    annotation(Dialog(tab="Dynamics",
      group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics",
      enable=false));
  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
    "Plant control bus"
    annotation(Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=0,
      origin={0,100}),
      iconTransformation(extent={{-20,280},{20,320}})));
  BoundaryConditions.WeatherData.Bus busWea
    "Weather data bus"
    annotation(Placement(transformation(extent={{-100,80},{-60,120}}),
      iconTransformation(extent={{-320,280},{-280,320}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repSpe(
    final nout=nCoo)
    if have_varCom
    "Replicate signal in case of common unique commanded speed"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={0,60})));
  Modelica.Blocks.Routing.RealPassThrough pasSpe[nCoo]
    if not have_varCom
    "Direct pass through for dedicated speed signal"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={30,60})));
  // The pass-through blocks pasEna and pasSta are required for proper expansion
  // of expandable connector variables. Compiler inference fails by simply
  // connecting busCoo.y1 to busCooUni.y1.
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasEna(
    nin=nCoo,
    final nout=nCoo)
    "Pass-through for enable signal"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-30,60})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pasSta(
    nin=nCoo,
    final nout=nCoo)
    "Pass-through for status signal"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=-90,
      origin={60,60})));
  protected
  Buildings.Templates.Components.Interfaces.Bus busCoo
    "Cooler group control bus"
    annotation(Placement(transformation(extent={{-20,60},{20,100}}),
      iconTransformation(extent={{-350,6},{-310,46}})));
  Buildings.Templates.Components.Interfaces.Bus busCooUni[nCoo]
    "Cooler control bus – Each unit"
    annotation(Placement(transformation(extent={{-20,10},{20,50}}),
      iconTransformation(extent={{-350,6},{-310,46}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooInlIso[nCoo]
    if typValCooInlIso <> Buildings.Templates.Components.Types.Valve.None
    "Cooler inlet isolation valve control bus"
    annotation(Placement(transformation(extent={{-80,60},{-40,100}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
  Buildings.Templates.Components.Interfaces.Bus busValCooOutIso[nCoo]
    if typValCooOutIso <> Buildings.Templates.Components.Types.Valve.None
    "Cooler outlet isolation valve control bus"
    annotation(Placement(transformation(extent={{60,60},{100,100}}),
      iconTransformation(extent={{-756,150},{-716,190}})));
equation
  connect(busCoo, bus.coo)
    annotation(Line(points={{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5),
      Text(string="%second",
        index=-1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
  connect(repSpe.u, busCoo.y)
    annotation(Line(points={{0,72},{0,80}},
      color={0,0,127}));
  connect(pasSpe.u, busCoo.y)
    annotation(Line(points={{30,72},{30,80},{0,80}},
      color={0,0,127}));
  connect(repSpe.y, busCooUni.y)
    annotation(Line(points={{0,48},{0,30}},
      color={0,0,127}));
  connect(pasSpe.y, busCooUni.y)
    annotation(Line(points={{30,49},{30,30},{0,30}},
      color={0,0,127}));
  connect(bus.valCooInlIso, busValCooInlIso)
    annotation(Line(points={{0,100},{-60,100},{-60,80}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.valCooOutIso, busValCooOutIso)
    annotation(Line(points={{0,100},{80,100},{80,80}},
      color={255,204,51},
      thickness=0.5));
  connect(busCoo.y1, pasEna.u)
    annotation(Line(points={{0,80},{-30,80},{-30,72}},
      color={255,204,51},
      thickness=0.5));
  connect(pasEna.y, busCooUni.y1)
    annotation(Line(points={{-30,48},{-30,30},{0,30}},
      color={255,0,255}));
  connect(pasSta.y, busCoo.y1_actual)
    annotation(Line(points={{60,72},{60,80},{0,80}},
      color={255,0,255}));
  connect(busCooUni.y1_actual, pasSta.u)
    annotation(Line(points={{0,30},{60,30},{60,48}},
      color={255,204,51},
      thickness=0.5));
annotation(Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-820,-300},{820,300}})),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(
    info="<html>
<p>
  This partial class provides a standard interface for cooler group models.
</p>
<h4>Control points</h4>
<p>
  The following input and output points are available for all models
  inheriting from this interface.
</p>
<ul>
  <li>
    Connector <code>bus.coo</code>, with a dimensionality of zero,
    storing the following cooler control points.
    <ul>
      <li>
        Start/Stop command (VFD Run): <code>y1</code> DO signal dedicated to
        each unit, with a dimensionality of one
      </li>
      <li>
        Speed command (VFD Speed): <code>y</code>
        <ul>
          <li>
            If <code>have_varCom</code>: AO signal common to all units, with a
            dimensionality of zero
          </li>
          <li>
            If <code>not have_varCom</code>: AO signal dedicated to each unit,
            with a dimensionality of one
          </li>
        </ul>
      </li>
      <li>
        Status (VFD status): <code>y1_actual</code>, DI signal dedicated to
        each unit, with a dimensionality of one
      </li>
    </ul>
  </li>
  <li>
    Connector <code>bus.valCooInlIso</code> (respectively
    <code>bus.valCooOutIso</code>), with a dimensionality of one, storing
    each unit's inlet (respectively outlet) isolation valve control points as
    specified in the documentation of
    <a href=\"modelica://Buildings.Templates.Components.Actuators.Valve\">
      Buildings.Templates.Components.Actuators.Valve</a> for
    two-position valves.
  </li>
</ul>
</html>",
    revisions="<html>
<ul>
  <li>
    November 18, 2022, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PartialCoolerGroup;
