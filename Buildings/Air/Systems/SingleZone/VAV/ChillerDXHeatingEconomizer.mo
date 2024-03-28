within Buildings.Air.Systems.SingleZone.VAV;
model ChillerDXHeatingEconomizer
  "HVAC system model with a dry cooling coil, air-cooled chiller, electric heating coil,
   variable speed fan, and mixing box with economizer control."
  replaceable package MediumA = Buildings.Media.Air "Medium model for air"
      annotation (choicesAllMatching = true);
  replaceable package MediumW = Buildings.Media.Water "Medium model for water"
      annotation (choicesAllMatching = true);

  parameter Modelica.Units.SI.DimensionlessRatio COP_nominal=5.5
    "Nominal COP of the chiller";
  parameter Modelica.Units.SI.Temperature TSupChi_nominal
    "Design value for chiller leaving water temperature";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Design airflow rate of system" annotation (Dialog(group="Air design"));
  parameter Modelica.Units.SI.Power QHea_flow_nominal(min=0)
    "Design capacity of heating coil"
    annotation (Dialog(group="Heating design"));
  parameter Real etaHea_nominal(min=0, max=1, unit="1")
    "Design heating efficiency of the heating coil"
    annotation(Dialog(group="Heating design"));
  parameter Modelica.Units.SI.Power QCoo_flow_nominal(max=0)
    "Design capacity of cooling coil"
    annotation (Dialog(group="Cooling design"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")=
       500 "Design pressure drop of flow leg with fan"
    annotation (Dialog(group="Air design"));
  final parameter Modelica.Units.SI.MassFlowRate mChiEva_flow_nominal=-
      QCoo_flow_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/4
    "Design chilled water supply flow";
  final parameter Modelica.Units.SI.MassFlowRate mChiCon_flow_nominal=-
      QCoo_flow_nominal*(1 + 1/COP_nominal)/Buildings.Utilities.Psychrometrics.Constants.cpAir
      /10 "Design condenser air flow";

  Modelica.Blocks.Interfaces.BooleanInput chiOn "On signal for chiller plant"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Modelica.Blocks.Interfaces.RealInput uHea(
    final unit="1") "Control input for heater"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  Modelica.Blocks.Interfaces.RealInput uCooVal(final unit="1")
    "Control signal for cooling valve"
    annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
        iconTransformation(extent={{-240,10},{-200,50}})));
  Modelica.Blocks.Interfaces.RealInput TSetChi(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));
  Modelica.Blocks.Interfaces.RealInput uEco
    "Control signal for economizer"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Modelica.Fluid.Interfaces.FluidPort_a supplyAir(
    redeclare final package Medium = MediumA) "Supply air"
    annotation (Placement(transformation(extent={{192,50},{212,70}}),
        iconTransformation(extent={{192,50},{212,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b returnAir(
    redeclare final package Medium = MediumA) "Return air"
    annotation (Placement(transformation(extent={{192,-30},{212,-10}}),
        iconTransformation(extent={{192,-30},{212,-10}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(final unit="W")
    "Electrical power consumed by the supply fan"
    annotation (Placement(transformation(extent={{200,140},{220,160}}),
        iconTransformation(extent={{200,140},{220,160}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(final unit="W")
    "Electrical power consumed by the heating equipment" annotation (Placement(
        transformation(extent={{200,120},{220,140}}), iconTransformation(extent={{200,120},
            {220,140}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(final unit="W")
    "Electrical power consumed by the cooling equipment" annotation (Placement(
        transformation(extent={{200,100},{220,120}}),iconTransformation(extent={{200,100},
            {220,120}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(transformation(extent={{200,80},{220,100}}),
        iconTransformation(extent={{200,80},{220,100}})));
  Modelica.Blocks.Interfaces.RealOutput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Mixed air temperature" annotation (Placement(transformation(extent={{200,-70},
            {220,-50}}), iconTransformation(extent={{202,-70},{222,-50}})));
  Modelica.Blocks.Interfaces.RealOutput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature after coils"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}}),
        iconTransformation(extent={{202,-110},{222,-90}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(
        transformation(extent={{-200,20},{-160,60}}),   iconTransformation(
          extent={{-168,148},{-148,168}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTSup(
    final m_flow_nominal=mAir_flow_nominal,
    final allowFlowReversal=false,
    final tau=0,
    redeclare package Medium = MediumA)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{128,30},{148,50}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoi(
    final m_flow_nominal=mAir_flow_nominal,
    final Q_flow_nominal=QHea_flow_nominal,
    final u(start=0),
    final dp_nominal=0,
    final allowFlowReversal=false,
    final tau=90,
    redeclare package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final show_T=true)
    "Air heating coil"
    annotation (Placement(transformation(extent={{52,30},{72,50}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fanSup(
    final m_flow_nominal=mAir_flow_nominal,
    final nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=875,
    final per(
      final etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
      final etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=false,
    final use_inputFilter=false,
    redeclare package Medium = MediumA)
    "Supply fan"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Fluid.FixedResistances.PressureDrop totalRes(
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dp_nominal,
    final allowFlowReversal=false,
    redeclare package Medium = MediumA)
    "Total resistance"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.Blocks.Math.Gain eff(k=1/etaHea_nominal)
    "Heating efficiency"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Fluid.Sources.Outside out(
    final C=fill(0.0004, MediumA.nC),
    final nPorts=3,
    redeclare package Medium = MediumA)
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTMixAir(
    final m_flow_nominal=mAir_flow_nominal,
    final allowFlowReversal=false,
    final tau=0,
    redeclare package Medium = MediumA)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final m2_flow_nominal=mAir_flow_nominal,
    final Q_flow_nominal=QCoo_flow_nominal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final allowFlowReversal1=false,
    final allowFlowReversal2=false,
    final m1_flow_nominal=mChiEva_flow_nominal,
    final show_T=true,
    final T_a1_nominal=279.15,
    final T_a2_nominal=298.15)
    "Cooling coil"
    annotation (Placement(transformation(extent={{110,44},{90,24}})));
  Buildings.Fluid.Sources.MassFlowSource_T souChiWat(
    redeclare package Medium = MediumA,
    final nPorts=1,
    final use_T_in=true,
    final m_flow=mChiCon_flow_nominal)
    "Mass flow source for chiller"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={138,-174})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumChiWat(
    final use_inputFilter=false,
    final allowFlowReversal=false,
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=mChiEva_flow_nominal,
    final addPowerToMedium=false,
    final per(
      efficiency(eta={1}),
      motorEfficiency(eta={0.9}),
      motorCooledByFluid=false),
    final dp_nominal=12000,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final nominalValuesDefineDefaultPressureCurve=true)
    "Pump for chilled water loop"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-90})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    final allowFlowReversal1=false,
    final allowFlowReversal2=false,
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    final m2_flow_nominal=mChiEva_flow_nominal,
    final dp1_nominal=0,
    final m1_flow_nominal=mChiCon_flow_nominal,
    final per(
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
    final dp2_nominal=12E3,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air cooled chiller"
    annotation (Placement(transformation(extent={{110,-158},{90,-178}})));
  Buildings.Fluid.Sources.Boundary_pT bouPreChi(
    redeclare package Medium = MediumW, nPorts=1)
    "Pressure boundary condition for chilled water loop"
    annotation (Placement(transformation(extent={{50,-172},{70,-152}})));
  Modelica.Blocks.Math.Gain gaiFan(k=mAir_flow_nominal)
    "Gain for fan mass flow rate"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  IdealValve ideVal(
    redeclare package Medium = MediumW,
    final m_flow_nominal = mChiEva_flow_nominal)
    "Ideal valve"
    annotation (Placement(transformation(extent={{70,0},{90,20}})));
  Modelica.Blocks.Math.BooleanToReal booToInt(
    final realTrue=mChiEva_flow_nominal)
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  IdealValve ideEco(
    redeclare package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Ideal economizer" annotation (
      Placement(transformation(
        rotation=90,
        extent={{10,-10},{-10,10}},
        origin={-90,46})));
  Fluid.Sensors.TemperatureTwoPort senTRetAir(
    final m_flow_nominal=mAir_flow_nominal,
    final allowFlowReversal=false,
    final tau=0,
    redeclare package Medium = MediumA)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Return air temperature" annotation (Placement(transformation(extent={{200,-90},
            {220,-70}}),       iconTransformation(extent={{202,-90},{222,-70}})));
  Fluid.Sensors.TraceSubstancesTwoPort senTraSub(
    redeclare package Medium=MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final tau=0)
    "Sensor for trace substance"
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));

  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual supply fan speed"
    annotation (Placement(transformation(extent={{200,162},{220,182}})));
protected
  model IdealValve
    extends Modelica.Blocks.Icons.Block;
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choicesAllMatching = true);
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
      "Design chilled water supply flow";
    Modelica.Fluid.Interfaces.FluidPort_a port_1(
      redeclare package Medium = Medium) annotation (Placement(transformation(extent={{50,88},
              {70,108}}), iconTransformation(extent={{50,88},{70,108}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_2(
      redeclare package Medium = Medium) annotation (Placement(transformation(extent={{50,-108},
              {70,-88}}), iconTransformation(extent={{50,-108},{70,-88}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_3(
      redeclare package Medium = Medium) annotation (Placement(transformation(extent={{90,-10},
              {110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) annotation (Placement(
          transformation(extent={{-120,-10},{-100,10}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    Fluid.Sensors.MassFlowRate senMasFlo(
      redeclare package Medium = Medium,
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
    connect(feedback.u1, one.y)     annotation (Line(points={{-58,22},{-69,22}},
                                                 color={0,0,127}));
    connect(y, feedback.u2)    annotation (Line(points={{-110,0},{-50,0},{-50,14}},color={0,0,127}));
    connect(preMasFlo.port_a, port_3)     annotation (Line(points={{60,-1.33227e-15},{80,-1.33227e-15},{80,0},{100,
            0}},                                   color={0,127,255}));
    connect(feedback.y, pro.u1)     annotation (Line(points={{-41,22},{-30,22}},
                                                 color={0,0,127}));
    connect(pro.y, preMasFlo.m_flow_in)     annotation (Line(points={{-7,16},{56,16},{56,8}},    color={0,0,127}));
    connect(port_1, senMasFlo.port_a)      annotation (Line(points={{60,98},{60,60},{4.44089e-16,60},{4.44089e-16,
            -30}},                                  color={0,127,255}));
    connect(senMasFlo.port_b, port_2)     annotation (Line(points={{-4.44089e-16,-50},{0,-50},{0,-72},{60,-72},{60,
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
  connect(fanSup.port_b, totalRes.port_a)    annotation (Line(points={{-10,40},
          {10,40}},                                                                       color={0,127,255}));
  connect(fanSup.P, PFan) annotation (Line(points={{-9,49},{-6,49},{-6,150},{
          210,150}},         color={0,0,127}));
  connect(eff.y, QHea_flow) annotation (Line(points={{141,110},{166,110},{166,
          130},{210,130}},
                      color={0,0,127}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-180,40},{-140,40},{-140,40.2}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(senTMixAir.port_b, fanSup.port_a)   annotation (Line(points={{-40,40},
          {-30,40}},                                                                                color={0,127,255}));
  connect(heaCoi.Q_flow, eff.u) annotation (Line(points={{73,46},{80,46},{80,
          110},{118,110}},                        color={0,0,127}));
  connect(heaCoi.port_b, cooCoi.port_a2)    annotation (Line(points={{72,40},{90,40}}, color={0,127,255}));
  connect(cooCoi.port_b2, senTSup.port_a)    annotation (Line(points={{110,40},{128,40}},          color={0,127,255}));
  connect(cooCoi.port_b1, ideVal.port_1) annotation (Line(
      points={{90,28},{86,28},{86,19.8}},
      color={0,0,255},
      thickness=0.5));
  connect(chi.port_b2, pumChiWat.port_a) annotation (Line(points={{110,-162},{120,
          -162},{120,-100}},            color={0,0,255},
      thickness=0.5));
  connect(souChiWat.ports[1], chi.port_a1) annotation (Line(points={{128,-174},
          {128,-174},{110,-174}},       color={0,127,255}));
  connect(chi.port_b1, out.ports[1]) annotation (Line(points={{90,-174},{-116,
          -174},{-116,38.6667},{-120,38.6667}},                  color={0,127,255}));
  connect(weaBus.TDryBul, souChiWat.T_in) annotation (Line(
      points={{-180,40},{-180,-208},{160,-208},{160,-170},{150,-170}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(pumChiWat.P, PPum) annotation (Line(points={{111,-79},{111,-52},{180,
          -52},{180,90},{210,90}}, color={0,0,127}));
  connect(chi.P, PCoo) annotation (Line(points={{89,-177},{80,-177},{80,-128},{
          98,-128},{98,-50},{178,-50},{178,110},{210,110}},
        color={0,0,127}));
  connect(ideVal.port_2, chi.port_a2)    annotation (Line(points={{86,0.2},{86,-162},{90,-162}},
                                                          color={0,127,255}));
  connect(cooCoi.port_a1, pumChiWat.port_b) annotation (Line(points={{110,28},{120,
          28},{120,-80}},              color={0,127,255}));
  connect(cooCoi.port_a1, ideVal.port_3) annotation (Line(points={{110,28},{120,
          28},{120,10},{90,10}}, color={0,127,255}));
  connect(bouPreChi.ports[1], chi.port_a2) annotation (Line(points={{70,-162},{90,
          -162}},              color={0,127,255}));
  connect(totalRes.port_b, heaCoi.port_a)    annotation (Line(points={{30,40},{52,40}}, color={0,127,255}));
  connect(senTSup.port_b, supplyAir) annotation (Line(points={{148,40},{174,40},
          {174,60},{202,60}}, color={0,127,255}));
  connect(gaiFan.y, fanSup.m_flow_in)    annotation (Line(points={{-59,140},{
          -20,140},{-20,52}},                                                                    color={0,0,127}));
  connect(booToInt.y, pumChiWat.m_flow_in)   annotation (Line(points={{81,-90},{108,-90}}, color={0,0,127}));
  connect(booToInt.u, chiOn) annotation (Line(points={{58,-90},{40,-90},{40,-120},
          {-220,-120}}, color={255,0,255}));
  connect(chiOn, chi.on) annotation (Line(points={{-220,-120},{40,-120},{40,-188},
          {120,-188},{120,-171},{112,-171}}, color={255,0,255}));
  connect(gaiFan.u, uFan)   annotation (Line(points={{-82,140},{-152,140},{-152,160},{-220,160}},
                                                    color={0,0,127}));
  connect(heaCoi.u, uHea) annotation (Line(points={{50,46},{40,46},{40,100},{-220,
          100}},color={0,0,127}));
  connect(ideVal.y, uCooVal)   annotation (Line(points={{69,10},{-76,10},{-76,30},{-220,30}},
                                                 color={0,0,127}));
  connect(chi.TSet, TSetChi) annotation (Line(points={{112,-165},{124,-165},{124,
          -200},{-220,-200}}, color={0,0,127}));
  connect(senTMixAir.T, TMix) annotation (Line(points={{-50,51},{-50,70},{188,
          70},{188,-60},{210,-60}}, color={0,0,127}));
  connect(senTSup.T, TSup) annotation (Line(points={{138,51},{138,64},{170,64},
          {170,-100},{210,-100}},color={0,0,127}));
  connect(out.ports[2], ideEco.port_1) annotation (Line(points={{-120,40},{-120,
          40},{-99.8,40}},             color={0,127,255}));
  connect(ideEco.port_2, senTMixAir.port_a)   annotation (Line(points={{-80.2,40},{-60,40}}, color={0,127,255}));
  connect(uEco, ideEco.y) annotation (Line(points={{-220,-40},{-148,-40},{-148,70},
          {-90,70},{-90,57}}, color={0,0,127}));
  connect(ideEco.port_3, senTRetAir.port_b) annotation (Line(points={{-90,36},{
          -90,-40},{-40,-40}}, color={0,127,255}));
  connect(senTRetAir.port_b, out.ports[3]) annotation (Line(points={{-40,-40},{
          -112,-40},{-112,36},{-120,36},{-120,41.3333}}, color={0,127,255}));
  connect(TRet, senTRetAir.T) annotation (Line(points={{210,-80},{174,-80},{174,
          -20},{-30,-20},{-30,-29}},     color={0,0,127}));
  connect(senTRetAir.port_a, senTraSub.port_b)    annotation (Line(points={{-20,-40},{20,-40}}, color={0,127,255}));
  connect(senTraSub.port_a, returnAir)   annotation (Line(points={{40,-40},{192,
          -40},{192,-20},{202,-20}},              color={0,127,255}));

  connect(fanSup.y_actual, y_actual) annotation (Line(points={{-9,47},{0,47},{0,
          172},{210,172}}, color={0,0,127}));
  annotation (defaultComponentName="chiDXHeaEco",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},
            {200,180}}), graphics={
        Rectangle(
          extent={{-200,180},{202,-220}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{182,60},{-158,20}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,56},{-2,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{182,-52},{-158,-92}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,20},{-118,-52}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,56},{-12,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,46},{-22,32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,60},{56,20}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{104,60},{118,20}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{44,74},{54,66}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{40,76},{58,74}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Backward),
        Line(points={{46,76},{46,80}}, color={0,0,0}),
        Line(points={{52,76},{52,80}}, color={0,0,0}),
        Line(points={{50,60},{50,68}}, color={0,0,0}),
        Rectangle(
          extent={{-138,60},{-124,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,-52},{-124,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-98,-17},
          rotation=90),
        Line(points={{202,120},{88,120},{88,66}},   color={0,0,127}),
        Line(points={{200,138},{50,138},{50,88}}, color={0,0,127}),
        Line(points={{200,160},{-28,160},{-28,70}}, color={0,0,127}),
        Line(points={{106,20},{106,-46}},color={0,0,255}),
        Line(points={{116,20},{116,-46}},color={0,0,255}),
        Line(points={{106,-6},{116,-6}},   color={0,0,255}),
        Polygon(
          points={{-3,4},{-3,-4},{3,0},{-3,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={117,-4},
          rotation=-90),
        Polygon(
          points={{112,-2},{112,-10},{118,-6},{112,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,-3},{4,-3},{0,3},{-4,-3}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={117,-8}),
        Line(points={{118,-6},{124,-6}},   color={0,0,0}),
        Line(points={{124,-4},{124,-10}},  color={0,0,0}),
        Ellipse(
          extent={{98,-104},{126,-132}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{112,-104},{100,-124},{124,-124},{112,-104}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{116,-96},{116,-104}},
                                         color={0,0,255}),
        Line(points={{106,-96},{106,-104}},
                                         color={0,0,255}),
        Ellipse(
          extent={{86,-128},{112,-138}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{112,-128},{138,-138}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{110,-28},{122,-38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{116,-28},{112,-36},{120,-36},{116,-28}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{202,100},{134,100},{134,66}}, color={0,0,127}),
        Line(points={{126,-34},{134,-34},{134,16}}, color={0,0,127}),
        Line(points={{94,-116},{88,-116},{88,16}},  color={0,0,127}),
                                        Text(
        extent={{-154,260},{164,196}},
        textString="%name",
        textColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{200,180}})),
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
March 27, 2024, by Michael Wetter:<br/>
Corrected wrong assignment of <code>out.C</code>.
</li>
<li>
November 1, 2021, by Hongxiang Fu:<br/>
Refactored the model by replacing <code>not use_powerCharacteristic</code>
with the enumeration
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
<li>
February 25, 2021, by Baptiste Ravache:<br/>
Inverse the sign of <code>cooCoi.Q_flow_nominal</code> to respect the heat flow convention.
</li>
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
