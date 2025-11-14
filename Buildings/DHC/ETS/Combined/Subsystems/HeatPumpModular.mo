within Buildings.DHC.ETS.Combined.Subsystems;
model HeatPumpModular "Base subsystem with modular heat recovery heat pump"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,X_a=0.40)
    "Propylene glycol water, 40% mass fraction")));
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Buildings.DHC.ETS.Combined.Data.HeatPump dat
    "Heat pump performance data"
                               annotation (choicesAllMatching=true, Placement(
        transformation(extent={{60,160},{80,180}})));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Nominal pressure drop accross condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Nominal pressure drop accross evaporator"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpValCon_nominal=dpCon_nominal/2
    "Nominal pressure drop accross control valve on condenser side"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Pressure dpValEva_nominal=dpEva_nominal/2
    "Nominal pressure drop accross control valve on evaporator side"
    annotation (Dialog(group="Nominal condition"));
  parameter Real THeaWatSupSetMin(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Minimum value of heating water supply temperature set point"
    annotation (Dialog(group="Controls"));
  parameter Real TChiWatSupSetMax(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set point"
    annotation (Dialog(group="Controls"));
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetHea(
    min=0.5,
    displayUnit="K")
    "Temperature to be added to the set point in order to be slightly above what the heating load requires";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetCoo(
    max=-0.5,
    displayUnit="K")
    "Temperature to be added to the set point in order to be slightly below what the cooling load requires";

  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaSpa
    "True if space heating is required from tank" annotation (Placement(
        transformation(extent={{-240,170},{-200,210}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaDhw
    "True if domestic hot water heating is required from tank" annotation (
      Placement(transformation(extent={{-240,150},{-200,190}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "True if cooling is required from tank"
    annotation (Placement(transformation(extent={{-240,130},{-200,170}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point (may be reset down)"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for chilled water return"
    annotation (Placement(transformation(extent={{190,-70},{210,-50}}),
    iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChiWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for chilled water supply"
    annotation (Placement(transformation(extent={{-210,-70},{-190,-50}}),
    iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for heating water return"
    annotation (Placement(transformation(extent={{-210,50},{-190,70}}),
    iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Fluid port for heating water supply"
    annotation (Placement(transformation(extent={{190,50},{210,70}}),
    iconTransformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PChi(
    final unit="W")
    "Chiller power"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
    iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Pump power"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
    iconTransformation(extent={{100,-40},{140,0}})));
  // COMPONENTS
  Buildings.Fluid.HeatPumps.ModularReversible.Modular heaPum(
    redeclare package MediumCon = Medium,
    redeclare package MediumEva = Medium,
    redeclare model RefrigerantCycleHeatPumpCooling =
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling,
    redeclare model RefrigerantCycleHeatPumpHeating =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D
        (
        redeclare final
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        mCon_flow_nominal=dat.mCon_flow_nominal,
        mEva_flow_nominal=dat.mEva_flow_nominal,
        final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        final extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
        final datTab=dat.datHea),
    redeclare model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    final use_rev=false,
    final allowDifferentDeviceIdentifiers=true,
    final allowFlowReversalEva=allowFlowReversal,
    final allowFlowReversalCon=allowFlowReversal,
    final dTCon_nominal=dat.dTCon_nominal,
    final dTEva_nominal=dat.dTEva_nominal,
    final QHea_flow_nominal=dat.QHeaDes_flow_nominal,
    final TConHea_nominal=dat.THeaConLvg_nominal,
    final TEvaHea_nominal=dat.THeaEvaLvg_nominal,
    final TConCoo_nominal=dat.TCooConLvg_nominal,
    final TEvaCoo_nominal=dat.TCooEvaLvg_nominal,
    final dpCon_nominal(displayUnit="Pa") = dpCon_nominal,
    final dpEva_nominal(displayUnit="Pa") = dpEva_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    show_T=true,
    use_intSafCtr=false,
    limWarSca=0.98) "Heat recovery heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    use_riseTime=true,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final dp_nominal=dpCon_nominal + dpValCon_nominal + 2*0.05*dpValCon_nominal,
    dpMax=3*(dpCon_nominal + dpValCon_nominal + 2*0.05*dpValCon_nominal))
    "Condenser pump"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Buildings.DHC.ETS.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    use_riseTime=true,
    final m_flow_nominal=dat.mEva_flow_nominal,
    final dp_nominal=dpEva_nominal + dpValEva_nominal + dpEva_nominal*0.05,
    dpMax=3*(dpEva_nominal + dpValEva_nominal + dpEva_nominal*0.05))
    "Evaporator pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-100,-60})));
  Buildings.DHC.ETS.Combined.Controls.HeatPumpModular con(
    final PLRMin=dat.PLRMin,
    THeaWatSupSetMin=THeaWatSupSetMin,
    TChiWatSupSetMax=TChiWatSupSetMax,
    final dTOffSetHea=dTOffSetHea,
    final dTOffSetCoo=dTOffSetCoo) "Controller"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mCon_flow_nominal)
    "Condenser water leaving temperature"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=270,origin={20,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConEnt(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mCon_flow_nominal)
    "Condenser water entering temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-20,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaEnt(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mEva_flow_nominal)
    "Evaporator water entering temperature"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},rotation=270,origin={20,-40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEvaLvg(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.mEva_flow_nominal)
    "Evaporator water leaving temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-20,-40})));
  Buildings.DHC.ETS.BaseClasses.Junction splEva(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal=dat.mEva_flow_nominal*{1,-1,-1})
    "Flow splitter for the evaporator water circuit"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={-140,-60})));
  Buildings.DHC.ETS.BaseClasses.Junction splConMix(
    redeclare final package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    m_flow_nominal=dat.mCon_flow_nominal*{1,-1,-1})
    "Flow splitter"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={120,60})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valEva(
    redeclare final package Medium = Medium,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_strokeTime=false,
    final m_flow_nominal=dat.mEva_flow_nominal,
    final dpValve_nominal=dpValEva_nominal,
    linearized={true,true})
    "Control valve for maximum evaporator water entering temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={120,-60})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valCon(
    redeclare final package Medium = Medium,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_strokeTime=false,
    final m_flow_nominal=dat.mCon_flow_nominal,
    final dpValve_nominal=dpValCon_nominal,
    linearized={true,true})
    "Control valve for minimum condenser water entering temperature"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-140,60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Constant speed primary pumps control signal"
    annotation (Placement(transformation(extent={{-60,170},{-80,190}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{160,-150},{180,-130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(final k=dat.mCon_flow_nominal)
    "Scale to nominal mass flow rate" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-100,114})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(final k=dat.mEva_flow_nominal)
    "Scale to nominal mass flow rate" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,-22})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

protected
  final parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi])
    "Medium state at default properties";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
initial equation
  assert(dat.QCooAct_flow_nominal <= dat.QCooDes_flow_nominal,
    "In " + getInstanceName() + ": The heat pump is sized for heating.
    However, at the cooling design conditions,
    this results in a cooling capacity of QCooAct_flow_nominal = " + String(dat.QCooAct_flow_nominal) + " W,
    but the desired cooling capacity is QCooDes_flow_nominal = " + String(dat.QCooDes_flow_nominal) + " W.
    You need to size the heat pump for a bigger heating load.",
    level=AssertionLevel.warning);
equation
  connect(splConMix.port_3,valCon.port_3)
    annotation (Line(points={{120,70},{120,80},{-140,80},{-140,70}},color={0,127,255}));
  connect(valCon.port_2,pumCon.port_a)
    annotation (Line(points={{-130,60},{-110,60}},color={0,127,255}));
  connect(pumEva.port_b,splEva.port_1)
    annotation (Line(points={{-110,-60},{-130,-60}},color={0,127,255}));
  connect(splEva.port_3,valEva.port_3)
    annotation (Line(points={{-140,-70},{-140,-80},{120,-80},{120,-70}},color={0,127,255}));
  connect(con.yValEva,valEva.y)
    annotation (Line(points={{-48,133},{160,133},{160,-40},{120,-40},{120,-48}},                    color={0,0,127}));
  connect(con.yValCon,valCon.y)
    annotation (Line(points={{-48,137},{-44,137},{-44,90},{-160,90},{-160,40},{
          -140,40},{-140,48}},                                                                     color={0,0,127}));
  connect(uHeaSpa, con.uHeaSpa) annotation (Line(points={{-220,190},{-180,190},
          {-180,150},{-72,150}}, color={255,0,255}));
  connect(uCoo,con.uCoo)
    annotation (Line(points={{-220,150},{-186,150},{-186,146},{-72,146}},color={255,0,255}));
  connect(splConMix.port_2,port_bHeaWat)
    annotation (Line(points={{130,60},{200,60}},color={0,127,255}));
  connect(splEva.port_2,port_bChiWat)
    annotation (Line(points={{-150,-60},{-200,-60}},color={0,127,255}));
  connect(port_aHeaWat,valCon.port_1)
    annotation (Line(points={{-200,60},{-150,60}},color={0,127,255}));
  connect(port_aChiWat,valEva.port_1)
    annotation (Line(points={{200,-60},{130,-60}},color={0,127,255}));
  connect(valEva.port_2,senTEvaEnt.port_a)
    annotation (Line(points={{110,-60},{20,-60},{20,-50}},color={0,127,255}));
  connect(senTEvaLvg.port_b,pumEva.port_a)
    annotation (Line(points={{-20,-50},{-20,-60},{-90,-60}},color={0,127,255}));
  connect(senTEvaLvg.port_a, heaPum.port_b2)
    annotation (Line(points={{-20,-30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(senTEvaEnt.port_b, heaPum.port_a2)
    annotation (Line(points={{20,-30},{20,-6},{10,-6}}, color={0,127,255}));
  connect(heaPum.port_b1, senTConLvg.port_a)
    annotation (Line(points={{10,6},{20,6},{20,30}}, color={0,127,255}));
  connect(senTConLvg.port_b,splConMix.port_1)
    annotation (Line(points={{20,50},{20,60},{110,60}},color={0,127,255}));
  connect(pumCon.port_b,senTConEnt.port_a)
    annotation (Line(points={{-90,60},{-20,60},{-20,50}},color={0,127,255}));
  connect(senTConEnt.port_b, heaPum.port_a1)
    annotation (Line(points={{-20,30},{-20,6},{-10,6}}, color={0,127,255}));
  connect(heaPum.P, PChi)
    annotation (Line(points={{11,0},{220,0}}, color={0,0,127}));
  connect(add2.y,PPum)
    annotation (Line(points={{182,-140},{220,-140}},color={0,0,127}));
  connect(pumEva.P,add2.u2)
    annotation (Line(points={{-111,-51},{-120,-51},{-120,-146},{158,-146}},                      color={0,0,127}));
  connect(pumCon.P,add2.u1)
    annotation (Line(points={{-89,69},{80,69},{80,-134},{158,-134}},  color={0,0,127}));
  connect(con.yPum,booToRea.u)
    annotation (Line(points={{-48,148},{-36,148},{-36,180},{-58,180}},color={255,0,255}));
  connect(booToRea.y,gai2.u)
    annotation (Line(points={{-82,180},{-120,180},{-120,0},{-100,0},{-100,-10}},color={0,0,127}));
  connect(gai2.y,pumEva.m_flow_in)
    annotation (Line(points={{-100,-34},{-100,-48}},color={0,0,127}));
  connect(gai1.y,pumCon.m_flow_in)
    annotation (Line(points={{-100,102},{-100,72}},color={0,0,127}));
  connect(booToRea.y,gai1.u)
    annotation (Line(points={{-82,180},{-100,180},{-100,126}},color={0,0,127}));
  connect(con.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{-72,139},
          {-186,139},{-186,80},{-220,80}},   color={0,0,127}));
  connect(con.TEvaWatLvg, senTEvaLvg.T) annotation (Line(points={{-72,137},{-82,
          137},{-82,-40},{-31,-40}}, color={0,0,127}));
  connect(con.yCom, heaPum.ySet) annotation (Line(points={{-48,142},{-40,142},{
          -40,1.9},{-11.1,1.9}}, color={0,0,127}));
  connect(con.THeaWatSupSet, THeaWatSupSet) annotation (Line(points={{-72,144},
          {-192,144},{-192,110},{-220,110}}, color={0,0,127}));
  connect(senTConLvg.T, con.TConWatLvg) annotation (Line(points={{9,40},{4,40},
          {4,106},{-84,106},{-84,142},{-72,142}}, color={0,0,127}));
  connect(con.uHeaDhw, uHeaDhw) annotation (Line(points={{-72,148},{-184,148},{
          -184,170},{-220,170}}, color={255,0,255}));
  annotation (
    defaultComponentName="chi",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-110},{151,-150}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-30,38},{34,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-22},{26,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,0},{-18,-8},{-10,-8},{-14,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-14,0},{-18,8},{-10,8},{-14,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,18},{20,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,6},{28,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,6},{10,-6},{28,-6},{18,6}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-8},{-12,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,18},{-12,8}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,26},{24,18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-30},{34,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{84,-30},{88,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,-30},{-68,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,87},{2,-87}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-15,-60},
          rotation=90),
        Rectangle(
          extent={{70,58},{74,32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,4},{2,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-82,30},
          rotation=90),
        Rectangle(
          extent={{90,62},{60,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-56,38},{-38,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,38},{-48,20},{-38,30},{-48,38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-4},{-4,4},{4,4},{0,-4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-74,30},
          rotation=90),
        Polygon(
          points={{0,4},{-4,-4},{4,-4},{0,4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-66,30},
          rotation=90),
        Polygon(
          points={{0,4},{-4,-4},{4,-4},{0,4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-70,34},
          rotation=180),
        Rectangle(
          extent={{-86,60},{-82,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,3},{2,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-59,30},
          rotation=90),
        Rectangle(
          extent={{-2,4},{2,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-34,30},
          rotation=90),
        Rectangle(
          extent={{74,32},{34,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{64,62},{-72,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,62},{-68,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-4},{-4,4},{4,4},{0,-4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={72,-36},
          rotation=180),
        Polygon(
          points={{0,-4},{-4,4},{4,4},{0,-4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={68,-32},
          rotation=90),
        Polygon(
          points={{0,4},{-4,-4},{4,-4},{0,4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={76,-32},
          rotation=90),
        Ellipse(
          extent={{40,-24},{58,-42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-24},{50,-42},{40,-32},{50,-24}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,5},{2,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-87,60},
          rotation=90),
        Rectangle(
          extent={{64,-30},{58,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{86,-30},{80,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{90,-58},{84,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,20},{2,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-50,-32},
          rotation=90),
        Rectangle(
          extent={{70,-40},{74,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        extent={{-200,-200},{200,200}})),
    Documentation(
      revisions="<html>
<ul>
<li>
March 27, 2024, by David Blum:<br/>
Update icon and fix port orientation to align with convention.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a model for a chiller system with constant speed evaporator and
condenser pumps, and mixing valves modulated to maintain a minimum
condenser inlet temperature (resp. maximum evaporator inlet temperature).
</p>
<p>
The system is controlled based on the logic described in
<a href=\"modelica://Buildings.Obsolete.DHC.ETS.Combined.Controls.Chiller\">
Buildings.Obsolete.DHC.ETS.Combined.Controls.Chiller</a>.
The pump flow rate is considered proportional to the pump speed
under the assumption of a constant flow resistance for both the condenser
and the evaporator loops. This assumption is justified
by the connection of the loops to the buffer tanks, and the additional
assumption that the bypass branch of the mixing valves is balanced
with the direct branch.
</p>
<h4>ESTCP Adaptation</h4>
<p>
The chiller component is replaced, together with its parameterisation.
</p>
</html>"));
end HeatPumpModular;
