within Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces;
partial model PartialPrimaryPump "Partial primary pump model"

  replaceable package Medium = Buildings.Media.Water;

  // Structure parameters

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPump
    typ "Type of primary pumping"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Integer nPum "Number of pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  parameter Boolean have_conSpePum
    "= true if pumps are constant speed";
  final parameter Boolean have_byp = not have_secondary and not have_conSpePum
    "= true if chilled water loop has a minimum flow bypass";
  final parameter Boolean have_decoupler = have_secondary
    "= true if there is a commong leg";

  parameter Boolean have_decouplerFloSen = have_decoupler
    "= true if decoupler flow is measured"
    annotation(Dialog(enable=have_decoupler));

  parameter Boolean have_parChi
    "= true if chillers in inlet are connected in parallel";
  parameter Boolean have_chiByp = have_eco
    "= true if chilled water loop has a chiller bypass"
    annotation(Dialog(enable=is_series or not have_secondary));
  parameter Boolean have_floSen = true
    "= true if primary flow is measured"
    annotation(Dialog(enable=not have_secondary));
  parameter Boolean have_supFloSen = have_floSen
    "= true if primary flow is measured on supply side"
    annotation(Dialog(enable=have_floSen));

  outer parameter Boolean have_secondary
    "= true if plant has secondary pumping";
  outer parameter Boolean have_eco
    "= true if plant has waterside economizer";
  outer parameter Boolean is_series
    "= true if chillers are in series";

  parameter Boolean have_TChiWatPriSup = not have_secondary
    "= true if primary chilled water supply temperature is measured"
    annotation(Dialog(enable=have_secondary));

  // Record

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.PrimaryPumps.Interfaces.Data
    dat(
    final typ=typ,
    final nPum=nPum,
    final have_chiByp=have_chiByp,
    final have_byp=have_byp) "Primary pumps data";

  // Model configuration parameters

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum
    constrainedby Buildings.Templates.Components.Pumps.MultipleVariable(
      redeclare final package Medium = Medium,
      final nPum=nPum,
      final have_singlePort_b=true,
      final dat=dat.pum)
    "Primary pumps"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Fluid.FixedResistances.Junction splByp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=fill(dat.m_flow_nominal, 3),
    final dp_nominal=fill(0, 3))
    "Bypass splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,0})));
  Buildings.Templates.Components.Valves.TwoWayModulating valByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=dat.m_flow_nominal,
    final dpValve_nominal=dat.dpByp_nominal) if have_byp
    "Bypass valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-50})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPriSup_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_supFloSen,
    final m_flow_nominal=dat.m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary chilled water supply volume flow rate"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Templates.BaseClasses.PassThroughFluid pas(
    redeclare each final package Medium = Medium) if have_decoupler
    "Decoupler passthrough"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,-60})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VDec_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_decouplerFloSen,
    final m_flow_nominal=dat.m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    if have_decoupler
    "Decoupler volume flow rate"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPriSup(
    redeclare final package Medium = Medium,
    final have_sen=have_TChiWatPriSup,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final m_flow_nominal=dat.m_flow_nominal)
    "Primary chilled water supply temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow)
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_parallel[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_parChi
    "Pump group inlet for chiller connected in parallel"
    annotation (Placement(
      transformation(extent={{-108,-30},{-92,30}}),
      iconTransformation(extent={{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_ChiByp(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_chiByp
    "Pump group inlet for waterside economizer bypass"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_series(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if not have_parChi
    "Pump group inlet for chiller connected in series"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group outlet"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_byp(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if have_byp or have_decoupler
    "Pump group outlet for bypass or commong leg"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
equation
  connect(splByp.port_2, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(splByp.port_3,valByp. port_a)
    annotation (Line(
      points={{70,-10},{70,-30},{0,-30},{0,-36},{0,-40}},
      color={0,127,255}));
  connect(valByp.port_b, port_byp)
    annotation (Line(points={{0,-60},{0,-80},{0,-100}},color={0,127,255}));
  connect(VChiWatPriSup_flow.port_b,splByp. port_1)
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  connect(VChiWatPriSup_flow.y, busCon.VChiWatPriSup_flow)
    annotation (Line(points={{40,12},{40,80},{0,80},{0,100}}, color={0,0,127}),
    Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(splByp.port_3,pas. port_a)
    annotation (Line(points={{70,-10},{70,-50}}, color={0,127,255}));
  connect(port_byp,VDec_flow. port_a)
    annotation (Line(points={{0,-100},{0,-80},{30,-80}}, color={0,127,255}));
  connect(VDec_flow.port_b,pas. port_b)
    annotation (Line(points={{50,-80},{70,-80},{70,-70}}, color={0,127,255}));
  connect(VDec_flow.y, busCon.VDec_flow)
    annotation (Line(
      points={{40,-68},{40,-40},{20,-40},{20,80},{0,80},{0,100}},
      color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b,TChiWatPriSup. port_a)
    annotation (Line(points={{-30,0},{-10,0}},color={0,127,255}));
  connect(TChiWatPriSup.port_b,VChiWatPriSup_flow. port_a)
    annotation (Line(points={{10,0},{30,0}},color={0,127,255}));
  connect(TChiWatPriSup.y, busCon.TChiWatPriSup)
    annotation (Line(points={{0,12},{0,100}},color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(valByp.bus, busCon.valByp)
    annotation (Line(points={{-10,-50},{-20,-50},{-20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pum.bus, busCon.pumPri)
    annotation (Line(
      points={{-40,10},{-40,80},{0.1,80},{0.1,100.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPrimaryPump;
