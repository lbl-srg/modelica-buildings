within Buildings.Templates.ChilledWaterPlants.Components.Routing;
model ChillersToPrimaryPumps
  "Hydronic interface between chillers (and optional WSE) and primary pumps"

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  outer parameter Integer nChi
    "Number of chillers";
  outer parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side";
  outer parameter Boolean have_eco
    "Set to true if plant has waterside economizer";
  outer Buildings.Templates.ChilledWaterPlants.Types.EconomizerFlowControl
    typEcoFloCtr "Equipment for CHW flow control through WSE";
  outer parameter Boolean have_parChi
    "Set to true if plant chillers are in parallel";
  final parameter Integer nPorts = nChi + (if have_eco then 1 else 0)
    "Size of vectorized fluid connectors"
    annotation (Evaluate=true, Dialog(group="Configuration"));




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
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiBypSer[nChi](
    redeclare each final package Medium = Medium)
    if not have_parChi
    "Series chillers CHW bypass valve" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-160,0})));
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
  Buildings.Templates.Components.Routing.MultipleToMultiple rouSupPar(
    redeclare final package Medium = Medium,
    final nPorts_a=nPorts,
    final nPorts_b=nChi,
    final have_comLeg=not have_dedChiWatPum) if have_parChi
    "Hydronic routing  - Supply side - Parallel arrangement"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetSerEco
    if have_eco
    "Hydronic routing - Return side - Parallel or series arrangement with WSE"
    annotation (Placement(transformation(extent={{160,-130},{140,-110}})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetNoECo
    if not have_eco
    "Hydronic routing - Return side - Parallel or series arrangement without WSE"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-70})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouRetPar(
    redeclare final package Medium = Medium,
    final nPorts=nPorts) if have_parChi
    "Hydronic routing - Return side - Parallel arrangement"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiBypPar(
    redeclare final package Medium = Medium)
    if have_parChi and have_eco
    "Parallel chillers CHW bypass valve (only if WSE)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270)));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoBef(
    redeclare final package Medium = Medium,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_eco "CHW return temperature before WSE"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-140,-120})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouSupSer(
    redeclare final package Medium = Medium,
    final nPorts=nChi) if not have_parChi
    "Hydronic routing  - Supply side - Series arrangement"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoAft(redeclare
      final package Medium = Medium, final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    if have_eco "CHW return temperature after WSE" annotation (Placement(
        transformation(
        extent={{70,-10},{90,10}},
        rotation=0)));
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiEnt(
    redeclare final package Medium = Medium,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chillers entering CHW return temperature (after bypass or common leg)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-100})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetSer if not have_parChi
    "Hydronic routing - Return side - Series arrangement"
    annotation (Placement(transformation(extent={{10,-82},{-10,-62}})));
equation
  connect(ports_aSup, rouSupPar.ports_a)
    annotation (Line(points={{-200,120},{-10,120}}, color={0,127,255}));
  connect(rouSupPar.ports_b, ports_bSup)
    annotation (Line(points={{10,120},{200,120}}, color={0,127,255}));
  connect(valChiBypPar.port_b, rouSupPar.port_aComLeg)
    annotation (Line(points={{1.77636e-15,10},{0,10},{0,120}},
                                                         color={0,127,255}));
  connect(ports_bRet[1:nChi], valChiBypSer[1:nChi].port_a) annotation (Line(
        points={{-200,-100},{-200,-80},{-160,-80},{-160,-10}}, color={0,127,255}));
  connect(valChiBypSer[1:nChi].port_b, ports_aSup[1:nChi]) annotation (Line(
        points={{-160,10},{-160,120},{-200,120}}, color={0,127,255}));
  connect(rouRetPar.ports_b[1:nChi], ports_bRet[1:nChi])
    annotation (Line(points={{-10,-100},{-200,-100}}, color={0,127,255}));
  connect(TChiWatEcoBef.port_b, ports_bRet[nChi + 1]) annotation (Line(points={{-150,
          -120},{-200,-120},{-200,-100}},                  color={0,127,255}));
  connect(ports_aSup[1], rouSupSer.port_a) annotation (Line(points={{-200,120},{
          -200,140},{-10,140}}, color={0,127,255}));
  connect(rouSupSer.ports_b, ports_bSup) annotation (Line(points={{10,140},{20,140},
          {20,120},{200,120}}, color={0,127,255}));
  connect(ports_aSup[nChi + 1], TChiWatEcoAft.port_a) annotation (Line(points={{-200,
          120},{-200,100},{60,100},{60,0},{70,0}},           color={0,127,255}));
  connect(TChiWatEcoAft.port_b, port_aByp) annotation (Line(points={{90,0},{200,
          0}},                color={0,127,255}));
  connect(port_aByp, TChiWatChiEnt.port_a) annotation (Line(points={{200,0},{
          140,0},{140,-100},{90,-100}},
                                   color={0,127,255}));
  connect(port_aRet, rouRetNoECo.port_a) annotation (Line(points={{200,-100},{
          180,-100},{180,-80}},
                            color={0,127,255}));
  connect(rouRetNoECo.port_b, port_aByp) annotation (Line(points={{180,-60},{
          180,0},{200,0}},       color={0,127,255}));
  connect(port_aRet, rouRetSerEco.port_a) annotation (Line(points={{200,-100},{
          180,-100},{180,-120},{160,-120}},
                                        color={0,127,255}));
  connect(rouRetSerEco.port_b, TChiWatEcoBef.port_a)
    annotation (Line(points={{140,-120},{-130,-120}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, rouRetPar.port_a)
    annotation (Line(points={{70,-100},{10,-100}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, rouRetSer.port_a) annotation (Line(points={{70,-100},
          {20,-100},{20,-72},{10,-72}}, color={0,127,255}));
  connect(rouRetSer.port_b, ports_bRet[nChi]) annotation (Line(points={{-10,-72},
          {-20,-72},{-20,-100},{-200,-100}}, color={0,127,255}));
  connect(TChiWatChiEnt.port_b, valChiBypPar.port_a) annotation (Line(points={{
          70,-100},{40,-100},{40,-40},{0,-40},{0,-10}}, color={0,127,255}));
annotation (
  defaultComponentName="rou",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-600},{200,600}}), graphics={
        Text(
          extent={{-149,-614},{151,-654}},
          textColor={0,0,255},
          textString="%name")}),
 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end ChillersToPrimaryPumps;
