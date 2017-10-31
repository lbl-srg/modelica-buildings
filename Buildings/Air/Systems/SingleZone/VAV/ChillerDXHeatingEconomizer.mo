within Buildings.Air.Systems.SingleZone.VAV;
model ChillerDXHeatingEconomizer
  "HVAC system model with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer control."
  replaceable package MediumA = Buildings.Media.Air "Medium model for air"
      annotation (choicesAllMatching = true);
  replaceable package MediumW = Buildings.Media.Water "Medium model for water"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.DimensionlessRatio COP_nominal = 5.5
    "Nominal COP of the chiller";

  parameter Modelica.SIunits.Temperature TSupChi_nominal
    "Design value for chiller leaving water temperature";

  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal "Design airflow rate of system"
    annotation(Dialog(group="Air design"));

  parameter Modelica.SIunits.Power QHea_flow_nominal(min=0) "Design heating capacity of heating coil"
    annotation(Dialog(group="Heating design"));

  parameter Real etaHea_nominal(min=0, max=1, unit="1") "Design heating efficiency of the heating coil"
    annotation(Dialog(group="Heating design"));

  parameter Modelica.SIunits.Power QCoo_flow_nominal(max=0) "Design heating capacity of cooling coil"
    annotation(Dialog(group="Cooling design"));

  parameter Modelica.SIunits.PressureDifference dp_nominal(displayUnit="Pa") = 500
    "Design pressure drop of flow leg with fan"
    annotation(Dialog(group="Air design"));

  final parameter Modelica.SIunits.MassFlowRate mChiEva_flow_nominal=
    -QCoo_flow_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/4
    "Design chilled water supply flow";

  final parameter Modelica.SIunits.MassFlowRate mChiCon_flow_nominal=
    -QCoo_flow_nominal*(1+1/COP_nominal)/Buildings.Utilities.Psychrometrics.Constants.cpAir/10
    "Design condenser air flow";

  Modelica.Blocks.Interfaces.BooleanInput chiOn "On signal for chiller plant"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}})));

  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}})));
  Modelica.Blocks.Interfaces.RealInput uHea(
    final unit="1") "Control input for heater"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}})));
  Modelica.Blocks.Interfaces.RealInput uCooVal(final unit="1")
    "Control signal for cooling valve"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}})));
  Modelica.Blocks.Interfaces.RealInput TSetChi(
    final unit="K",
    displayUnit="degC")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-240,-210},{-200,-170}})));
  Modelica.Blocks.Interfaces.RealInput uEco "Control signal for economizer"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}})));

  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(
    redeclare final package Medium = MediumA) "Supply air"
    annotation (Placement(transformation(extent={{190,30},{210,50}}),
        iconTransformation(extent={{190,30},{210,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(
    redeclare final package Medium = MediumA) "Return air"
    annotation (Placement(transformation(extent={{190,-50},{210,-30}}),
        iconTransformation(extent={{190,-50},{210,-30}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(final unit="W")
    "Electrical power consumed by the supply fan"
    annotation (Placement(transformation(extent={{200,130},{220,150}}),
        iconTransformation(extent={{200,130},{220,150}})));

  Modelica.Blocks.Interfaces.RealOutput QHea_flow(final unit="W")
    "Electrical power consumed by the heating equipment" annotation (Placement(
        transformation(extent={{200,110},{220,130}}), iconTransformation(extent={{200,110},
            {220,130}})));

  Modelica.Blocks.Interfaces.RealOutput PCoo(final unit="W")
    "Electrical power consumed by the cooling equipment" annotation (Placement(
        transformation(extent={{200,90},{220,110}}), iconTransformation(extent={{200,90},
            {220,110}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(transformation(extent={{200,70},{220,90}}),
        iconTransformation(extent={{200,70},{220,90}})));

  Modelica.Blocks.Interfaces.RealOutput TMixAir(
    final unit="K",
    displayUnit="degC") "Mixed air temperature"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}}),
        iconTransformation(extent={{200,-90},{220,-70}})));

  Modelica.Blocks.Interfaces.RealOutput TSup(
    final unit="K",
    displayUnit="degC")
    "Supply air temperature after cooling coil"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}}),
        iconTransformation(extent={{200,-120},{220,-100}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
  annotation (Placement(
        transformation(extent={{-200,20},{-160,60}}),   iconTransformation(
          extent={{-170,128},{-150,148}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTSup(
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumA) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{128,30},{148,50}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoi(
    m_flow_nominal=mAir_flow_nominal,
    Q_flow_nominal=QHea_flow_nominal,
    u(start=0),
    dp_nominal=0,
    allowFlowReversal=false,
    tau=90,
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true)
     "Air heating coil"
    annotation (Placement(transformation(extent={{52,30},{72,50}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow fanSup(
    m_flow_nominal=mAir_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=875,
    per(use_powerCharacteristic=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    use_inputFilter=false,
    redeclare package Medium = MediumA) "Supply fan"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

  Buildings.Fluid.FixedResistances.PressureDrop totalRes(
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dp_nominal,
    allowFlowReversal=false,
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));

  Modelica.Blocks.Math.Gain eff(k=1/etaHea_nominal)
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Fluid.Sources.Outside out(
    nPorts=3,
    redeclare package Medium = MediumA)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTMixAir(
    m_flow_nominal=mAir_flow_nominal,
    allowFlowReversal=false,
    tau=0,
    redeclare package Medium = MediumA)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    dp1_nominal=0,
    dp2_nominal=0,
    m2_flow_nominal=mAir_flow_nominal,
    Q_flow_nominal=-QCoo_flow_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    m1_flow_nominal=mChiEva_flow_nominal,
    show_T=true,
    T_a1_nominal=279.15,
    T_a2_nominal=298.15)
    "Cooling coil"
    annotation (Placement(transformation(extent={{110,44},{90,24}})));

  Buildings.Fluid.Sources.MassFlowSource_T souChiWat(
    redeclare package Medium = MediumA,
    nPorts=1,
    use_T_in=true,
    m_flow=mChiCon_flow_nominal)
    "Mass flow source for chiller"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={138,-174})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pumChiWat(
    use_inputFilter=false,
    allowFlowReversal=false,
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mChiEva_flow_nominal,
    addPowerToMedium=false,
    per(
      hydraulicEfficiency(eta={1}),
      motorEfficiency(eta={0.9}),
      motorCooledByFluid=false),
    dp_nominal=12000,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for chilled water loop"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-90})));

  Buildings.Fluid.Chillers.ElectricEIR chi(
    allowFlowReversal1=false,
    allowFlowReversal2=false,
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m2_flow_nominal=mChiEva_flow_nominal,
    dp1_nominal=0,
    m1_flow_nominal=mChiCon_flow_nominal,
    per(
      capFunT={1.0433811,0.0407077,0.0004506,-0.0041514,-8.86e-5,-0.0003467},
      PLRMax=1.2,
      EIRFunT={0.5961915,-0.0099496,0.0007888,0.0004506,0.0004875,-0.0007623},
      EIRFunPLR={1.6853121,-0.9993443,0.3140322},
      COP_nominal=COP_nominal,
      QEva_flow_nominal=QCoo_flow_nominal,
      mEva_flow_nominal=mChiEva_flow_nominal,
      mCon_flow_nominal=mChiCon_flow_nominal,
      TEvaLvg_nominal=TSupChi_nominal,
      PLRMinUnl=0.1,
      PLRMin=0.1,
      etaMotor=1,
      TEvaLvgMin=274.15,
      TEvaLvgMax=293.15,
      TConEnt_nominal=302.55,
      TConEntMin=274.15,
      TConEntMax=323.15),
    dp2_nominal=12E3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air cooled chiller"
    annotation (Placement(transformation(extent={{110,-158},{90,-178}})));

  Buildings.Fluid.Sources.FixedBoundary bouPreChi(
    redeclare package Medium = MediumW, nPorts=1)
    "Pressure boundary condition for chilled water loop"
    annotation (Placement(transformation(extent={{50,-172},{70,-152}})));

  Modelica.Blocks.Math.Gain gaiFan(k=mAir_flow_nominal)
    "Gain for fan mass flow rate"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

  IdealValve ideVal(
    redeclare package Medium = MediumW,
    final m_flow_nominal = mChiEva_flow_nominal) "Ideal valve"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));

  Modelica.Blocks.Math.BooleanToReal booleanToInteger(
    final realTrue=mChiEva_flow_nominal)
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  IdealValve ideEco(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal) "Ideal economizer" annotation (
      Placement(transformation(
        rotation=90,
        extent={{10,-10},{-10,10}},
        origin={-90,46})));
equation
  connect(fanSup.port_b, totalRes.port_a)
    annotation (Line(points={{-10,40},{10,40}},  color={0,127,255}));
  connect(fanSup.P, PFan) annotation (Line(points={{-9,49},{-6,49},{-6,140},{210,
          140}},             color={0,0,127}));
  connect(eff.y, QHea_flow) annotation (Line(points={{141,100},{160,100},{160,120},
          {210,120}}, color={0,0,127}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-180,40},{-140,40},{-140,40.2}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(senTMixAir.port_b, fanSup.port_a)
    annotation (Line(points={{-40,40},{-30,40}},          color={0,127,255}));
  connect(heaCoi.Q_flow, eff.u) annotation (Line(points={{73,46},{80,46},{80,92},
          {118,92},{118,100}},                    color={0,0,127}));
  connect(heaCoi.port_b, cooCoi.port_a2)
    annotation (Line(points={{72,40},{90,40}}, color={0,127,255}));
  connect(cooCoi.port_b2, senTSup.port_a)
    annotation (Line(points={{110,40},{128,40}},          color={0,127,255}));
  connect(cooCoi.port_b1, ideVal.port_1) annotation (Line(
      points={{90,28},{86,28},{86,19.8}},
      color={0,0,255},
      thickness=0.5));
  connect(chi.port_b2, pumChiWat.port_a) annotation (Line(points={{110,-162},{120,
          -162},{120,-100}},            color={0,0,255},
      thickness=0.5));
  connect(souChiWat.ports[1], chi.port_a1) annotation (Line(points={{128,-174},
          {128,-174},{110,-174}},       color={0,127,255}));
  connect(chi.port_b1, out.ports[1]) annotation (Line(points={{90,-174},{-112,
          -174},{-112,42.6667},{-120,42.6667}},                  color={0,127,255}));
  connect(weaBus.TDryBul, souChiWat.T_in) annotation (Line(
      points={{-180,40},{-180,-208},{160,-208},{160,-170},{150,-170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(pumChiWat.P, PPum) annotation (Line(points={{111,-79},{111,-52},{180,-52},
          {180,80},{210,80}},      color={0,0,127}));
  connect(chi.P, PCoo) annotation (Line(points={{89,-177},{84,-177},{84,-128},{98,
          -128},{98,-50},{178,-50},{178,100},{210,100}},
        color={0,0,127}));
  connect(ideVal.port_2, chi.port_a2)
    annotation (Line(points={{86,0.2},{86,-162},{90,-162}},
                                                          color={0,127,255}));
  connect(cooCoi.port_a1, pumChiWat.port_b) annotation (Line(points={{110,28},{120,
          28},{120,-80}},              color={0,127,255}));
  connect(cooCoi.port_a1, ideVal.port_3) annotation (Line(points={{110,28},{120,
          28},{120,10},{90,10}}, color={0,127,255}));
  connect(bouPreChi.ports[1], chi.port_a2) annotation (Line(points={{70,-162},{90,
          -162}},              color={0,127,255}));
  connect(totalRes.port_b, heaCoi.port_a)
    annotation (Line(points={{30,40},{52,40}}, color={0,127,255}));
  connect(senTSup.port_b, supplyAir) annotation (Line(points={{148,40},{200,40}},
                              color={0,127,255}));
  connect(gaiFan.y, fanSup.m_flow_in)
    annotation (Line(points={{-59,140},{-20,140},{-20,52}}, color={0,0,127}));

protected
  model IdealValve
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium in the component"
        annotation (choicesAllMatching = true);

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Design chilled water supply flow";
    Modelica.Fluid.Interfaces.FluidPort_a port_1(redeclare package Medium =
          Medium) annotation (Placement(transformation(extent={{50,88},
              {70,108}}), iconTransformation(extent={{50,88},{70,108}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_2(redeclare package Medium =
          Medium) annotation (Placement(transformation(extent={{50,-108},
              {70,-88}}), iconTransformation(extent={{50,-108},{70,-88}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_3(redeclare package Medium =
          Medium) annotation (Placement(transformation(extent={{90,-10},
              {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
          transformation(extent={{-120,-10},{-100,10}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium,
        allowFlowReversal=false)
      "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={0,-40})));
    Fluid.Movers.BaseClasses.IdealSource preMasFlo(
      redeclare package Medium = Medium,
      control_m_flow=true,
      control_dp=false,
      m_flow_small=m_flow_nominal*1E-5,
      show_V_flow=false,
      allowFlowReversal=false)
                        "Prescribed mass flow rate for the bypass" annotation (
        Placement(transformation(
          extent={{-10,10},{10,-10}},
          rotation=180,
          origin={50,0})));
    Modelica.Blocks.Math.Product pro "Product for mass flow rate computation"
      annotation (Placement(transformation(extent={{-28,6},{-8,26}})));
    Modelica.Blocks.Sources.Constant one(final k=1) "Outputs one"
      annotation (Placement(transformation(extent={{-90,12},{-70,32}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{-60,12},{-40,32}})));
  equation
    connect(senMasFlo.m_flow, pro.u2) annotation (Line(points={{-11,-40},{-40,
            -40},{-40,10},{-30,10}},      color={0,0,127}));
    connect(feedback.u1, one.y)
      annotation (Line(points={{-58,22},{-69,22}},
                                                 color={0,0,127}));
    connect(y, feedback.u2)
      annotation (Line(points={{-110,0},{-50,0},{-50,14}},color={0,0,127}));
    connect(preMasFlo.port_a, port_3)
      annotation (Line(points={{60,-1.33227e-15},{80,-1.33227e-15},{80,0},{100,
            0}},                                   color={0,127,255}));
    connect(feedback.y, pro.u1)
      annotation (Line(points={{-41,22},{-30,22}},
                                                 color={0,0,127}));
    connect(pro.y, preMasFlo.m_flow_in)
      annotation (Line(points={{-7,16},{56,16},{56,8}},    color={0,0,127}));
    connect(port_1, senMasFlo.port_a)
      annotation (Line(points={{60,98},{60,60},{4.44089e-16,60},{4.44089e-16,
            -30}},                                  color={0,127,255}));
    connect(senMasFlo.port_b, port_2)
      annotation (Line(points={{-4.44089e-16,-50},{0,-50},{0,-72},{60,-72},{60,
            -92},{60,-92},{60,-98},{60,-98}},      color={0,127,255}));
    connect(preMasFlo.port_b, senMasFlo.port_a) annotation (Line(points={{40,
            1.33227e-15},{4.44089e-16,1.33227e-15},{4.44089e-16,-30}},
                                    color={0,127,255}));
    annotation (
      Icon(
        graphics={
          Polygon(
            points={{60,0},{68,14},{52,14},{60,0}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{60,100},{60,-100}}, color={28,108,200}),
          Line(points={{102,0},{62,0}}, color={28,108,200}),
          Polygon(
            points={{60,0},{68,-14},{52,-14},{60,0}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{62,0},{-98,0}}, color={0,0,0}),
          Rectangle(
            visible=use_inputFilter,
            extent={{28,-10},{46,10}},
            lineColor={0,0,0},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{72,-8},{72,8},{60,0},{72,-8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}));
  end IdealValve;
equation
  connect(booleanToInteger.y, pumChiWat.m_flow_in)
    annotation (Line(points={{81,-90},{108,-90}}, color={0,0,127}));
  connect(booleanToInteger.u, chiOn) annotation (Line(points={{58,-90},{40,-90},
          {40,-140},{-220,-140}}, color={255,0,255}));
  connect(chiOn, chi.on) annotation (Line(points={{-220,-140},{40,-140},{40,-188},
          {120,-188},{120,-171},{112,-171}}, color={255,0,255}));
  connect(gaiFan.u, uFan)
    annotation (Line(points={{-82,140},{-220,140}}, color={0,0,127}));
  connect(heaCoi.u, uHea) annotation (Line(points={{50,46},{40,46},{40,80},{-220,
          80}}, color={0,0,127}));
  connect(ideVal.y, uCooVal)
    annotation (Line(points={{69,10},{-220,10}}, color={0,0,127}));
  connect(chi.TSet, TSetChi) annotation (Line(points={{112,-165},{124,-165},{124,
          -190},{-220,-190}}, color={0,0,127}));
  connect(senTMixAir.T, TMixAir) annotation (Line(points={{-50,51},{-50,70},{188,
          70},{188,-80},{210,-80}}, color={0,0,127}));
  connect(senTSup.T, TSup) annotation (Line(points={{138,51},{138,64},{170,64},{
          170,-110},{210,-110}}, color={0,0,127}));
  connect(out.ports[2], ideEco.port_1) annotation (Line(points={{-120,40},{
          -109.8,40},{-99.8,40}},      color={0,127,255}));
  connect(ideEco.port_2, senTMixAir.port_a)
    annotation (Line(points={{-80.2,40},{-60,40}}, color={0,127,255}));
  connect(ideEco.port_3, returnAir) annotation (Line(points={{-90,36},{-90,-40},
          {200,-40}}, color={0,127,255}));
  connect(returnAir, out.ports[3]) annotation (Line(points={{200,-40},{-116,-40},
          {-116,37.3333},{-120,37.3333}}, color={0,127,255}));
  connect(uEco, ideEco.y) annotation (Line(points={{-220,-60},{-148,-60},{-148,70},
          {-90,70},{-90,57}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-240},
            {200,160}}), graphics={
        Rectangle(
          extent={{-202,160},{200,-240}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{180,40},{-160,0}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,36},{-4,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{180,-72},{-160,-112}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,0},{-120,-72}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,36},{-14,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-38,26},{-24,12}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,40},{54,0}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{102,40},{116,0}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{42,54},{52,46}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{38,56},{56,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Line(points={{44,56},{44,60}}, color={0,0,0}),
        Line(points={{50,56},{50,60}}, color={0,0,0}),
        Line(points={{48,40},{48,48}}, color={0,0,0}),
        Rectangle(
          extent={{-140,40},{-126,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-140,-72},{-126,-112}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-100,-37},
          rotation=90),
        Line(points={{200,100},{86,100},{86,46}},   color={0,0,127}),
        Line(points={{198,118},{48,118},{48,68}}, color={0,0,127}),
        Line(points={{198,140},{-30,140},{-30,50}}, color={0,0,127}),
        Line(points={{104,0},{104,-66}}, color={0,0,255}),
        Line(points={{114,0},{114,-66}}, color={0,0,255}),
        Line(points={{104,-26},{114,-26}}, color={0,0,255}),
        Polygon(
          points={{-3,4},{-3,-4},{3,0},{-3,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={115,-24},
          rotation=-90),
        Polygon(
          points={{110,-22},{110,-30},{116,-26},{110,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-3},{4,-3},{0,3},{-4,-3}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={115,-28}),
        Line(points={{116,-26},{122,-26}}, color={0,0,0}),
        Line(points={{122,-24},{122,-30}}, color={0,0,0}),
        Ellipse(
          extent={{96,-124},{124,-152}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{110,-124},{98,-144},{122,-144},{110,-124}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{114,-116},{114,-124}},
                                         color={0,0,255}),
        Line(points={{104,-116},{104,-124}},
                                         color={0,0,255}),
        Ellipse(
          extent={{84,-148},{110,-158}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{110,-148},{136,-158}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{108,-48},{120,-58}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{114,-48},{110,-56},{118,-56},{114,-48}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{200,80},{132,80},{132,46}},   color={0,0,127}),
        Line(points={{124,-54},{132,-54},{132,-4}}, color={0,0,127}),
        Line(points={{92,-136},{86,-136},{86,-4}},  color={0,0,127})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-240},{200,160}})),
      Documentation(info="<html>
<p>
This is a conventional single zone VAV HVAC system model. The system contains
a variable speed supply fan, electric heating coil, water-based cooling coil,
economizer, and air-cooled chiller. The control of the system is that of
conventional VAV heating and cooling. During cooling, the supply air
temperature is held constant while the supply air flow is modulated from
maximum to minimum according to zone load. This is done by modulating the
fan speed. During heating, the supply air flow is held at a constant minimum
while the heating coil is modulated accoding to zone load. The mass flow of
chilled water through the cooling coil is controlled by a three-way valve to
maintain the supply air temperature setpoint during cooling.
The mixing box maintains the minimum outside airflow fraction unless
conditions for economizer are met, in which case the economizer controller
adjusts the outside airflow fraction to meet a mixed air temperature setpoint.
The economizer is enabled if the outside air drybulb temperature is lower
than the return air temperature and the system is not in heating mode.
</p>
<p>
There are a number of assumptions in the model. Pressure drops through the
system are collected into a single component. The mass flow of return air
is equal to the mass flow of supply air. The mass flow of outside air and
relief air in the mixing box is ideally controlled so that the supply air is
composed of the specified outside airflow fraction, rather than having
feedback control of damper positions. The cooling coil is a dry coil model.
</p>
</html>", revisions="<html>
<ul>
<li>
September 08, 2017, by Thierry S. Nouidui:<br/>
Removed experiment annotation.
</li>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerDXHeatingEconomizer;
