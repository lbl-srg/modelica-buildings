within Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Interfaces;
partial model PartialChillerSection "Partial chiller section model"
  replaceable package MediumConWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium 1 in the component"
      annotation (Dialog(enable=not isAirCoo));
  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium 2 in the component";

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Types.ChillerSection typ
    "Type of chiller section"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  outer parameter Boolean isAirCoo
    "= true, chillers are air cooled,
    = false, chillers are water cooled"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_parallel=
    typ ==Buildings.Templates.ChilledWaterPlants.Components.Types.ChillerSection.ChillerParallel
    "Set to true if chillers are connected in series";

  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nCooTow "Number of cooling towers";

  outer parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side";
  outer parameter Boolean have_dedConWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on condenser water side";

  parameter Boolean have_TPriRet
    "Set to true if plant chilled water return temperature is measured"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_VChiWatRet_flow
    "Set to true if primary flow is measured on return side"
    annotation(Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso[nChi]
    "Type of chiller chilled water side isolation valve";

  // Record

  parameter
    Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerSection dat(
    final typ=typ,
    final nChi=nChi,
    final isAirCoo=isAirCoo) "Chiller section data";
  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.PumpsPrimary
    datPumPri "Primary pump data";

  // Model configuration parameters

  parameter Boolean allowFlowReversal1 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 1"
    annotation(Dialog(tab="Assumptions", enable=not isAirCoo), Evaluate=true);
  parameter Boolean allowFlowReversal2 = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for medium 2"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter MediumConWat.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(dat.m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced", enable=not isAirCoo));
  parameter MediumChiWat.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(dat.m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  inner replaceable
    Buildings.Templates.ChilledWaterPlants.Components.Chillers.Electric chi[nChi]
    constrainedby
    Buildings.Templates.ChilledWaterPlants.Components.Chillers.Interfaces.PartialChiller(
    final dat=dat.chi,
    redeclare each final package Medium1 = MediumConWat,
    redeclare each final package Medium2 = MediumChiWat) "Chillers" annotation (
     Placement(transformation(extent={{-20,28},{20,68}})), choices(choice(
          redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Chillers.Electric
          chi[nChi] "Electric"), choice(redeclare
          Buildings.Templates.ChilledWaterPlants.Components.Chillers.Absorption
          chi[nChi] "Absorption")));

  // Evaporator side

  Buildings.Templates.Components.Sensors.VolumeFlowRate VPriRet_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=dat.m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS,
    final have_sen=have_VChiWatRet_flow)
    "Primary chilled water return volume flow rate"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-20,-60})));
  Buildings.Templates.Components.Sensors.Temperature TPriRet(
    redeclare final package Medium = MediumChiWat,
    final have_sen=have_TPriRet,
    final m_flow_nominal=dat.m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant chilled water return temperature (plant side of chilled water minimum flow bypass)"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},origin={20,-60})));
  Buildings.Fluid.FixedResistances.Junction mixMinFlowByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.m2_flow_nominal*{1,-1,1},
    final dp_nominal={0,0,0}) "Minimum flow bypass mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}},origin={60,-60})));
  Buildings.Fluid.FixedResistances.Junction splChiWatChiByp(
    redeclare package Medium = MediumChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=dat.m2_flow_nominal*{1,-1,-1},
    final dp_nominal={0,0,0}) "Chiller bypass splitter"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=180,origin={-60,-60})));

  // Condenser side

  Buildings.Fluid.Delays.DelayFirstOrder volConWat(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=dat.m1_flow_nominal,
    final nPorts=1+nChi) if not isAirCoo
    "Condenser water side mixing volume"
    annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},rotation=0,origin={80,80})));

  // Ports

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nChi](
    redeclare each final package Medium = MediumConWat,
    each m_flow(min=if allowFlowReversal1 then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumConWat.h_default, nominal=MediumConWat.h_default))
    if not isAirCoo "CW supply"
    annotation (Placement(transformation(extent={{-108,28},{-92,92}}),
        iconTransformation(extent={{-108,28},{-92,92}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = MediumConWat,
    m_flow(max=if allowFlowReversal1 then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumConWat.h_default, nominal = MediumConWat.h_default)) if not isAirCoo
    "CW return"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal2 then -Modelica.Constants.inf else 0),
    h_outflow(start = MediumChiWat.h_default, nominal = MediumChiWat.h_default))
    "CHW return"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = MediumChiWat,
    m_flow(max=if allowFlowReversal2 then +Modelica.Constants.inf else 0),
    h_outflow(start = MediumChiWat.h_default, nominal = MediumChiWat.h_default))
    "CHW supply"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  // Buses

  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus(final nChi=nChi,
      final nCooTow=nCooTow) "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  BoundaryConditions.WeatherData.Bus busWea if isAirCoo "Weather bus"
    annotation (Placement(transformation(
        extent={{-20,20},{20,-20}},
        rotation=180,
        origin={-40,100}), iconTransformation(
        extent={{-12.5,11.7677},{7.5,-8.23748}},
        rotation=180,
        origin={-42.5,101.768})));

equation

  connect(bus.chi, chi.bus) annotation (Line(
      points={{0.1,100.1},{0.1,68},{0,68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(TPriRet.y, bus.TPriRet);
  connect(VPriRet_flow.y, bus.VPriRet_flow);

  connect(volConWat.ports[1], port_b1)
    annotation (Line(points={{80,70},{80,60},{100,60}}, color={0,127,255}));
  connect(chi.port_b1, volConWat.ports[2:3])
    annotation (Line(points={{20,60},{80,60},{80,70}}, color={0,127,255}));

  connect(chi.port_a1, ports_a1)
    annotation (Line(points={{-20,60},{-100,60}}, color={0,127,255}));
  connect(mixMinFlowByp.port_1, TPriRet.port_a)
    annotation (Line(points={{50,-60},{30,-60}}, color={0,127,255}));
  connect(TPriRet.port_b, VPriRet_flow.port_a)
    annotation (Line(points={{10,-60},{-10,-60}}, color={0,127,255}));
  connect(VPriRet_flow.port_b, splChiWatChiByp.port_1)
    annotation (Line(points={{-30,-60},{-50,-60}}, color={0,127,255}));
  connect(port_a2, mixMinFlowByp.port_2)
    annotation (Line(points={{100,-60},{70,-60}}, color={0,127,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
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
end PartialChillerSection;
