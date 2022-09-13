within Buildings.Templates.ChilledWaterPlants.Components.Routing;
model ChillersToPrimaryPumps
  "Hydronic interface between chillers (and optional WSE) and primary pumps"

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement typArrPumChiWatPri=
    Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered
    "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typArrChi<>Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series));
  parameter Buildings.Templates.ChilledWaterPlants.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Integer nPorts = nChi + (if
    typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None then 1 else 0)
    "Size of vectorized fluid connectors"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Buildings.Templates.Components.Data.Valve datValChiWatChiBypSer[nChi](
    each final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    each final m_flow_nominal=mChiWatPri_flow_nominal,
    each dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso)
    "Series chillers CHW bypass valve parameters"
    annotation (Dialog(enable=
    typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series));
  parameter Buildings.Templates.Components.Data.Valve datValChiWatChiBypPar(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso)
    "Parallel chillers CHW bypass valve parameters"
    annotation (Dialog(enable=
    typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
     and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW return from CHW distribution"
    annotation (Placement(transformation(extent={{190,-110},{210,-90}}),
    iconTransformation(extent={{190,-310},{208,-292}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bRet[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW return to chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,-140},{-190,-60}}),iconTransformation(extent={{-210,-340},
            {-190,-260}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bSup[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply to CHW distribution"
    annotation (Placement(
        transformation(extent={{190,80},{210,160}}),iconTransformation(extent={{188,260},
            {208,340}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aByp(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply from minimum flow bypass or common leg"    annotation (
      Placement(transformation(extent={{190,-10},{210,10}}),iconTransformation(
          extent={{190,-10},{210,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aSup[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply from chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,80},{-190,160}}), iconTransformation(extent={{-210,260},
            {-190,340}})));
  Buildings.Templates.ChilledWaterPlants.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(
          extent={{-20,180},{20,220}}), iconTransformation(extent={{-20,580},{
            20,620}})));

  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiWatChiBypSer[nChi](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiBypSer)
    if typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Series chillers CHW bypass valve" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-160,0})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiWatChiBypPar(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiBypPar)
    if typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
     and typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "Parallel chillers CHW bypass valve (only if WSE)"
    annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=270)));
  Buildings.Templates.Components.Routing.MultipleToMultiple rouSupPar(
    redeclare final package Medium = Medium,
    final nPorts_a=nChi,
    final nPorts_b=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final have_comLeg=
      typArrPumChiWatPri==Buildings.Templates.ChilledWaterPlants.Types.PumpArrangement.Headered)
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Hydronic routing  - Supply side - Parallel arrangement"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetEco(redeclare
      final package Medium = Medium)
    if typEco <> Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "Hydronic routing to WSE retrun - Parallel or series arrangement with WSE"
    annotation (Placement(transformation(extent={{160,-130},{140,-110}})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetNoECo(
    redeclare final package Medium = Medium)
    if typEco==Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "Hydronic routing - Return side - Parallel or series arrangement without WSE"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-70})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouRetChiPar(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau) if typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Hydronic routing to chiller return - Parallel arrangement"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoBef(
    redeclare final package Medium = Medium,
    final have_sen=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
     "CHW return temperature before WSE"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-140,-120})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouSupSer(
    redeclare final package Medium = Medium,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau)
    if typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Hydronic routing  - Supply side - Series arrangement"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoAft(
    redeclare final package Medium = Medium,
    final have_sen=true,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None
    "CHW return temperature after WSE"
    annotation (Placement(
        transformation(
        extent={{70,50},{90,70}},
        rotation=0)));
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiEnt(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chiller entering CHW return temperature (after bypass or common leg)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-100})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetChiSer(
      redeclare final package Medium = Medium) if typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Hydronic routing to chiller return - Series arrangement"
    annotation (Placement(transformation(extent={{10,-82},{-10,-62}})));

  Buildings.Templates.Components.Routing.PassThroughFluid rouSupRetSer[nChi - 1](
     redeclare final package Medium = Medium) if nChi > 1 and typArrChi ==
    Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Hydronic routing - Chiller return to supply - Series arrangement"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-120,0})));
  Fluid.FixedResistances.Junction junSupChiSer[nChi](
    redeclare each final package Medium = Medium,
    each final tau=tau,
    each final m_flow_nominal=mChiWatPri_flow_nominal*{1,-1,1},
    each final energyDynamics=energyDynamics,
    each dp_nominal=fill(0, 3),
    each final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering) if typArrChi ==
    Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Fluid junction at chiller supply - Series arrangement"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Fluid.FixedResistances.Junction junByp(
    redeclare final package Medium = Medium,
    final tau=tau,
    final m_flow_nominal=mChiWatPri_flow_nominal*{1,-1,1},
    final energyDynamics=energyDynamics,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction at minimum flow bypass or common leg" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={140,0})));
protected
  parameter Boolean have_controlVolume=
    energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "Boolean flag used to remove conditional components"
    annotation(Evaluate=true);
equation
  /* Control point connection - start */
  connect(bus.valChiWatChiByp, valChiWatChiBypSer.bus);
  connect(bus.valChiWatChiByp, valChiWatChiBypPar.bus);
  connect(bus.TChiWatEcoAft,TChiWatEcoAft.y);
  connect(bus.TChiWatEcoBef,TChiWatEcoBef.y);
  connect(bus.TChiWatChiEnt,TChiWatChiEnt.y);
  /* Control point connection - stop */
  connect(rouSupPar.ports_b, ports_bSup)
    annotation (Line(points={{10,120},{200,120}}, color={0,127,255}));
  connect(valChiWatChiBypPar.port_b, rouSupPar.port_aComLeg) annotation (Line(
        points={{1.77636e-15,10},{0,10},{0,120}}, color={0,127,255}));
  connect(ports_bRet[1:nChi], valChiWatChiBypSer[1:nChi].port_a) annotation (
      Line(points={{-200,-100},{-200,-80},{-160,-80},{-160,-10}}, color={0,127,255}));
  connect(TChiWatEcoBef.port_b, ports_bRet[nChi + 1]) annotation (Line(points={{-150,
          -120},{-200,-120},{-200,-100}},                  color={0,127,255}));
  connect(rouSupSer.ports_b, ports_bSup) annotation (Line(points={{10,140},{180,
          140},{180,120},{200,120}},
                               color={0,127,255}));
  connect(ports_aSup[nChi + 1], TChiWatEcoAft.port_a) annotation (Line(points={{-200,
          120},{-80,120},{-80,60},{70,60}},                  color={0,127,255}));
  connect(port_aRet, rouRetNoECo.port_a) annotation (Line(points={{200,-100},{180,
          -100},{180,-80}}, color={0,127,255}));
  connect(port_aRet, rouRetEco.port_a) annotation (Line(points={{200,-100},{180,
          -100},{180,-120},{160,-120}}, color={0,127,255}));
  connect(rouRetEco.port_b, TChiWatEcoBef.port_a)
    annotation (Line(points={{140,-120},{-130,-120}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, rouRetChiPar.port_a)
    annotation (Line(points={{70,-100},{10,-100}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, rouRetChiSer.port_a) annotation (Line(points={{
          70,-100},{20,-100},{20,-72},{10,-72}}, color={0,127,255}));
  connect(rouRetChiSer.port_b, ports_bRet[nChi]) annotation (Line(points={{-10,
          -72},{-20,-72},{-20,-100},{-200,-100}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, valChiWatChiBypPar.port_a) annotation (Line(
        points={{70,-100},{40,-100},{40,-40},{0,-40},{0,-10}}, color={0,127,255}));
  connect(rouSupRetSer.port_b, ports_bRet[1:nChi - 1])
    annotation (Line(points={{-120,-10},{-120,-100},{-200,-100}}, color={0,127,255}));
  connect(ports_aSup[1:nChi], junSupChiSer.port_1) annotation (Line(points={{-200,
          120},{-180,120},{-180,140},{-170,140}}, color={0,127,255}));
  connect(valChiWatChiBypSer.port_b, junSupChiSer.port_3)
    annotation (Line(points={{-160,10},{-160,130}}, color={0,127,255}));
  connect(junSupChiSer[1].port_2, rouSupSer.port_a)
    annotation (Line(points={{-150,140},{-10,140}}, color={0,127,255}));
  connect(junSupChiSer[2:nChi].port_2, rouSupRetSer.port_a) annotation (Line(
        points={{-150,140},{-120,140},{-120,10}}, color={0,127,255}));
  connect(junByp.port_2, TChiWatChiEnt.port_a) annotation (Line(points={{140,-10},
          {140,-100},{90,-100}}, color={0,127,255}));
  connect(port_aByp, junByp.port_3)
    annotation (Line(points={{200,0},{150,0}}, color={0,127,255}));
  connect(TChiWatEcoAft.port_b, junByp.port_1)
    annotation (Line(points={{90,60},{140,60},{140,10}}, color={0,127,255}));
  connect(rouRetNoECo.port_b, junByp.port_1) annotation (Line(points={{180,-60},
          {180,60},{140,60},{140,10}}, color={0,127,255}));
  connect(rouRetChiPar.ports_b, ports_bRet[1:nChi])
    annotation (Line(points={{-10,-100},{-200,-100}}, color={0,127,255}));
  connect(ports_aSup[1:nChi], rouSupPar.ports_a)
    annotation (Line(points={{-200,120},{-10,120}}, color={0,127,255}));
annotation (
  defaultComponentName="rou",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-600},{200,600}}), graphics={
        Text(
          extent={{-149,-614},{151,-654}},
          textColor={0,0,255},
          textString="%name"), Rectangle(extent={{-200,600},{200,-600}},
            lineColor={28,108,200})}),
 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end ChillersToPrimaryPumps;
