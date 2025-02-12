within Buildings.Templates.Plants.Chillers.Components.Routing;
model ChillersToPrimaryPumps
  "Hydronic interface between chillers (and optional WSE) and primary CHW pumps"

  replaceable package MediumChiWat = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  parameter Integer icon_dy = 360
    "Distance in y-direction between each branch in icon layer";

  parameter Integer nChi
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.ChillerArrangement typArrChi
    "Type of chiller arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.Distribution typDisChiWat
    "Type of CHW distribution system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPumChiWatPri(
    start=1,
    final min=1)=nChi
    "Number of primary CHW pumps"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered));
  parameter Buildings.Templates.Components.Types.PumpArrangement
    typArrPumChiWatPri "Type of primary CHW pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.Economizer typEco
    "Type of WSE"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senVChiWatPri=false
    "Set to true for primary CHW flow sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Plants.Chillers.Types.SensorLocation locSenFloChiWatPri=
     Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return
     "Location of primary CHW flow sensor"
     annotation (Evaluate=true, Dialog(group="Configuration", enable=have_senVChiWatPri));
  parameter Boolean have_senTChiWatPlaRet=false
    "Set to true for plant CHW return temperature sensor"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // The following parameter is only for graphical feedback.
  // The valves are modeled in the chiller group component.
  parameter Buildings.Templates.Components.Types.Valve typValChiWatChiIso=
    Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Type of chiller CHW isolation valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  final parameter Integer nPorts=nChi + 1
    "Size of vectorized fluid connectors on chiller side"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_valChiWatChiBypPar=
    typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    and (typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only or
     typDisChiWat==Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only)
    and typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered
    and typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
    "Set to true for parallel chillers with chiller CHW bypass valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate mChiWatPri_flow_nominal
    "Primary CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Buildings.Templates.Components.Data.Valve datValChiWatChiByp(
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    dpValve_nominal=Buildings.Templates.Data.Defaults.dpValIso)
    "Chiller CHW bypass valve parameters (identical for all valves in case of series chillers)"
    annotation (Dialog(enable=have_valChiWatChiBypPar));

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

  Modelica.Fluid.Interfaces.FluidPorts_b ports_bRet[nPorts](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return to chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,-140},{-190,-60}}),iconTransformation(extent={{-210,-1340},
            {-190,-1260}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bSup[nPumChiWatPri](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply to CHW pumps"
    annotation (Placement(
        transformation(extent={{190,80},{210,160}}),iconTransformation(extent={{190,
            1260},{210,1340}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aByp(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply from minimum flow bypass or common leg"    annotation (Placement(
        transformation(extent={{190,-10},{210,10}}), iconTransformation(extent={{-210,
            -1010},{-190,-990}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aSup[nPorts](
    redeclare each final package Medium = MediumChiWat,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW supply from chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,80},{-190,160}}), iconTransformation(extent={{-210,1260},
            {-190,1340}})));
  Buildings.Templates.Plants.Chillers.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(
          extent={{-20,180},{20,220}}), iconTransformation(extent={{-20,1320},{20,
            1360}})));

  Buildings.Templates.Components.Actuators.Valve valChiWatChiBypPar(
    redeclare final package Medium = MediumChiWat,
    final typ=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition,
    final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiByp)
    if have_valChiWatChiBypPar
    "Chiller CHW bypass valve - Parallel chillers with WSE and primary-only distribution)"
    annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=270)));
  Buildings.Templates.Components.Routing.MultipleToMultiple rouSupPar(
    redeclare final package Medium = MediumChiWat,
    final nPorts_a=nChi,
    final nPorts_b=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    final have_comLeg=typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered,
    icon_dy=0)
    if typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    "Hydronic routing  - Supply side - Parallel arrangement"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRet(
    redeclare final package Medium = MediumChiWat) "CHW return line"
    annotation (Placement(transformation(extent={{160,-130},{140,-110}})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouRetChiPar(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nChi,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    icon_dy=0)
    if typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    "Hydronic routing to chiller return - Parallel arrangement"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoBef(
    redeclare final package Medium = MediumChiWat,
    final have_sen=typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "CHW return temperature before optional WSE"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-140,-120})));
  Buildings.Templates.Components.Routing.SingleToMultiple rouSupSer(
    redeclare final package Medium = MediumChiWat,
    final nPorts=nPumChiWatPri,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final energyDynamics=energyDynamics,
    final tau=tau,
    icon_dy=0)
    if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Hydronic routing  - Supply side - Series arrangement"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoAft(
    redeclare final package Medium = MediumChiWat,
    final have_sen=typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "CHW return temperature after optional WSE"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,60})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatPlaRet(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final have_sen=have_senTChiWatPlaRet,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Plant CHW return temperature (after bypass or common leg)"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-100})));
  Buildings.Templates.Components.Routing.PassThroughFluid rouRetChiSer(
    redeclare final package Medium = MediumChiWat)
    if typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Hydronic routing to chiller return - Series arrangement"
    annotation (Placement(transformation(extent={{10,-82},{-10,-62}})));

  Buildings.Templates.Components.Routing.PassThroughFluid rouSupRetSer[nChi - 1](
    redeclare final package Medium = MediumChiWat) if nChi > 1 and typArrChi ==
    Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Hydronic routing - Chiller return to supply - Series arrangement"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-120,0})));
  Fluid.FixedResistances.Junction junSupChiSer[nChi](
    redeclare each final package Medium = MediumChiWat,
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
    Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Fluid junction at chiller supply - Series arrangement"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Fluid.FixedResistances.Junction junByp(
    redeclare final package Medium = MediumChiWat,
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
    "Fluid junction at minimum flow bypass or common leg"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={140,0})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate VChiWatPri_flow(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=mChiWatPri_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final have_sen=have_senVChiWatPri and
      locSenFloChiWatPri==Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return,
    final text_flip=true,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.FlowMeter)
    "Primary CHW volume flow rate"
    annotation (Placement(transformation(extent={{130,-110},{110,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare final package Medium = MediumChiWat,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumChiWat.h_default, nominal=MediumChiWat.h_default))
    "CHW return from CHW distribution"
    annotation (Placement(transformation(extent={{190,-110},{210,-90}}),
    iconTransformation(extent={{190,-1310},{210,-1290}})));
initial equation
  if typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None then
    assert(typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered,
      "In " + getInstanceName() + ": " +
      "The configuration with WSE and dedicated primary CHW pumps is not supported.");
  end if;
  if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series then
    assert(typArrPumChiWatPri == Buildings.Templates.Components.Types.PumpArrangement.Headered,
      "In " + getInstanceName() + ": " +
      "The configuration with series chillers and dedicated primary CHW pumps is not supported.");
  end if;
equation
  /* Control point connection - start */
  connect(bus.valChiWatChiByp, valChiWatChiBypPar.bus);
  connect(bus.TChiWatEcoAft,TChiWatEcoAft.y);
  connect(bus.TChiWatEcoBef,TChiWatEcoBef.y);
  connect(bus.TChiWatPlaRet,TChiWatPlaRet.y);
  connect(bus.VChiWatPri_flow, VChiWatPri_flow.y);
  /* Control point connection - stop */
  connect(rouSupPar.ports_b, ports_bSup)
    annotation (Line(points={{10,120},{200,120}}, color={0,127,255}));
  connect(valChiWatChiBypPar.port_b, rouSupPar.port_aComLeg) annotation (Line(
        points={{1.77636e-15,10},{0,10},{0,120}}, color={0,127,255}));
  connect(TChiWatEcoBef.port_b, ports_bRet[nChi + 1]) annotation (Line(points={{-150,
          -120},{-200,-120},{-200,-100}},                  color={0,127,255}));
  connect(rouSupSer.ports_b, ports_bSup) annotation (Line(points={{10,140},{140,
          140},{140,120},{200,120}},
                               color={0,127,255}));
  connect(ports_aSup[nChi + 1], TChiWatEcoAft.port_a) annotation (Line(points={{-200,
          120},{-200,100},{140,100},{140,70}},               color={0,127,255}));
  connect(port_aRet, rouRet.port_a) annotation (Line(points={{200,-100},{180,-100},
          {180,-120},{160,-120}}, color={0,127,255}));
  connect(rouRet.port_b, TChiWatEcoBef.port_a)
    annotation (Line(points={{140,-120},{-130,-120}}, color={0,127,255}));
  connect(TChiWatPlaRet.port_b, rouRetChiPar.port_a)
    annotation (Line(points={{70,-100},{10,-100}}, color={0,127,255}));
  connect(TChiWatPlaRet.port_b, rouRetChiSer.port_a) annotation (Line(points={{
          70,-100},{20,-100},{20,-72},{10,-72}}, color={0,127,255}));
  connect(rouRetChiSer.port_b, ports_bRet[nChi]) annotation (Line(points={{-10,
          -72},{-20,-72},{-20,-100},{-200,-100}}, color={0,127,255}));
  connect(TChiWatPlaRet.port_b, valChiWatChiBypPar.port_a) annotation (Line(
        points={{70,-100},{40,-100},{40,-40},{0,-40},{0,-10}}, color={0,127,255}));
  connect(rouSupRetSer.port_b, ports_bRet[1:nChi - 1])
    annotation (Line(points={{-120,-10},{-120,-100},{-200,-100}}, color={0,127,255}));
  connect(ports_aSup[1:nChi], junSupChiSer.port_1) annotation (Line(points={{-200,
          120},{-200,140},{-170,140}},            color={0,127,255}));
  connect(junSupChiSer[1].port_2, rouSupSer.port_a)
    annotation (Line(points={{-150,140},{-10,140}}, color={0,127,255}));
  connect(junSupChiSer[2:nChi].port_2, rouSupRetSer.port_a)
    annotation (Line(points={{-150,140},{-120,140},{-120,10}}, color={0,127,255}));
  connect(port_aByp, junByp.port_3)
    annotation (Line(points={{200,0},{150,0}}, color={0,127,255}));
  connect(TChiWatEcoAft.port_b, junByp.port_1)
    annotation (Line(points={{140,50},{140,10}},         color={0,127,255}));
  connect(rouRetChiPar.ports_b, ports_bRet[1:nChi])
    annotation (Line(points={{-10,-100},{-200,-100}}, color={0,127,255}));
  connect(ports_aSup[1:nChi], rouSupPar.ports_a)
    annotation (Line(points={{-200,120},{-10,120}}, color={0,127,255}));
  connect(junByp.port_2, VChiWatPri_flow.port_a) annotation (Line(points={{140,-10},
          {140,-100},{130,-100}}, color={0,127,255}));
  connect(VChiWatPri_flow.port_b,TChiWatPlaRet. port_a)
    annotation (Line(points={{110,-100},{90,-100}}, color={0,127,255}));

annotation (
  defaultComponentName="int",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-1340},{200,1340}}),
    graphics={
    Line( points=if typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      then {{-200,1300},{-200,-1140}} else {{-200,1180},{-200,-1140}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
    Text(
      extent={{-149,-1350},{151,-1390}},
      textColor={0,0,255},
      textString="%name"),
    Bitmap(
      visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 1,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=360,
      origin={-200,1240}),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 1,
      extent={{-140,1202},{-60,1282}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 1,
      extent={{-140,1202},{-60,1282}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 2,
          extent={{-140,1240 - 1*icon_dy - 40},{-60,1240 - 1*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 2,
          extent={{-140,1240 - 1*icon_dy - 40},{-60,1240 - 1*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 2,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,1240 - icon_dy}),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 3,
          extent={{-140,1240 - 2*icon_dy - 40},{-60,1240 - 2*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 3,
          extent={{-140,1240 - 2*icon_dy - 40},{-60,1240 - 2*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 3,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,1240 - 2*icon_dy}),
    Bitmap(
          visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 4,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,1240 - 3*icon_dy}),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 4,
          extent={{-140,1240 - 3*icon_dy - 40},{-60,1240 - 3*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 4,
          extent={{-140,1240 - 3*icon_dy - 40},{-60,1240 - 3*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 1,
          points={{-200,1240},{-140,1240}},
          color={0,0,0}),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 2,
          points={{-200,1240 - 1*icon_dy},{-140,1240 - 1*icon_dy}},
          color={0,0,0}),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 3,
          points={{-200,1240 - 2*icon_dy},{-140,1240 - 2*icon_dy}},
          color={0,0,0}),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 4,
          points={{-200,1240 - 3*icon_dy},{-140,1240 - 3*icon_dy}},
          color={0,0,0}),
    Line( points={{-200,1300},{200,1300}},
          color={0,0,0},
          thickness=5),
    Line( points={{-200,-1300},{200,-1300}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 5,
          extent={{-140,1240 - 4*icon_dy - 40},{-60,1240 - 4*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 5,
          extent={{-140,1240 - 4*icon_dy - 40},{-60,1240 - 4*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
          visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 5,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,1240 - 4*icon_dy}),
    Bitmap(
          visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 6,
          extent={{-100,-100},{100,100}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=360,
          origin={-200,1240-5*icon_dy}),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 6,
          extent={{-140,1240 - 5*icon_dy - 40},{-60,1240 - 5*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
          visible=typValChiWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 6,
          extent={{-140,1240 - 5*icon_dy - 40},{-60,1240 - 5*icon_dy + 40}},
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 5,
          points={{-200,1240 - 4*icon_dy},{-140,1240 - 4*icon_dy}},
          color={0,0,0}),
    Line( visible=typValChiWatChiIso<>Buildings.Templates.Components.Types.Valve.None
      and typArrChi==Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
      and nChi >= 6,
          points={{-200,1240 - 5*icon_dy},{-140,1240 - 5*icon_dy}},
          color={0,0,0}),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
               and nChi >= 2,
          points={{-200,1300 - icon_dy},{200,1300 - icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
               and nChi >= 3,
          points={{-200,1300 - 2*icon_dy},{200,1300 - 2*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
               and nChi >= 4,
          points={{-200,1300 - 3*icon_dy},{200,1300 - 3*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
               and nChi >= 5,
          points={{-200,1300 - 4*icon_dy},{200,1300 - 4*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
               and nChi >= 6,
          points={{-200,1300 - 5*icon_dy},{200,1300 - 5*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
               and nChi >= 2,
          points={{100,1300 - icon_dy},{200,1300 - icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
               and nChi >= 3,
          points={{100,1300 - 2*icon_dy},{200,1300 - 2*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
               and nChi >= 4,
          points={{100,1300 - 3*icon_dy},{200,1300 - 3*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
               and nChi >= 5,
          points={{100,1300 - 4*icon_dy},{200,1300 - 4*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
               and nChi >= 6,
          points={{100,1300 - 5*icon_dy},{200,1300 - 5*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=typArrPumChiWatPri==Buildings.Templates.Components.Types.PumpArrangement.Headered,
          points={{100,1300},{100,1300 - (nChi - 1)*icon_dy}},
          color={0,0,0},
          thickness=5),
    Line( visible=have_valChiWatChiBypPar,
          points={{-200,1100},{100,1100}},
          color={0,0,0},
          thickness=5),
    Bitmap(
          visible=have_valChiWatChiBypPar,
          extent={{-100,-100},{100,100}},
          fileName=
              "modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
          rotation=-90,
          origin={-40,1100}),
    Line(
      visible=have_valChiWatChiBypPar,
      points={{-30,0},{30,0}}, color={0,0,0},
      origin={-40,1070},
      rotation=-90),
    Bitmap(
      visible=have_valChiWatChiBypPar,
      extent={{-80,960},{0,1040}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      extent={{-40,-1120},{40,-1040}},
      visible=typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
    Bitmap(extent={{-100,-100},{100,100}},
      visible=typEco<>Buildings.Templates.Plants.Chillers.Types.Economizer.None,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg",
          origin={-140,-1080},
          rotation=-90),
    Bitmap(
          extent={{-100,-100},{100,100}},
          visible=true or have_senTChiWatPlaRet,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg",
          origin={-140,-760},
          rotation=-90),
    Bitmap(
          extent={{-40,-800},{40,-720}},
          visible=true or have_senTChiWatPlaRet,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
    Bitmap(
          extent={{-100,-100},{100,100}},
          visible=typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/ProbeInWell.svg",
          origin={120,-1240},
          rotation=360),
    Bitmap(
          extent={{80,-1140},{160,-1060}},
          visible=typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/Temperature.svg"),
    Bitmap(
          extent={{-100,-100},{100,100}},
          visible=have_senVChiWatPri and
      locSenFloChiWatPri==Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRateFlowMeter.svg",
          origin={-200,-910},
          rotation=-90),
    Bitmap(
          extent={{-40,-950},{40,-870}},
          visible=have_senVChiWatPri and
      locSenFloChiWatPri==Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
    Line(
      visible=have_senVChiWatPri and
      locSenFloChiWatPri==Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return,
      points={{-166,-910},{-40,-910}},color={0,0,0})}),
 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})),
    Documentation(info="<html>
<p>
This model represents the hydronic interface between
</p>
<ul>
<li>
the CHW supply and return connections of the plant components
(chillers and optional waterside economizer),
</li>
<li>
the inlet manifold of the primary CHW pumps (where the pumps are
assumed to be on the CHW supply side),
</li>
<li>
the CHW return pipe, and
</li>
<li>
the optional bypass (common leg for primary-secondary systems
and bypass with modulating valve for variable primary-only systems).
</li>
</ul>
<h4>Implementation details</h4>
<p>
In the case of series chillers, the chiller CHW bypass valves that 
serve 
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillersToPrimaryPumps;
