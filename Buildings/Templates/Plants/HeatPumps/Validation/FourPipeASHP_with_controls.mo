within Buildings.Templates.Plants.HeatPumps.Validation;
model FourPipeASHP_with_controls "Validation of AWHP plant template"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium);
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Main medium (common for CHW and HW)";
  parameter Real mHeaWatPri_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal;
  parameter Real mChiWatPri_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal;
  parameter Boolean have_chiWat=true
    "Set to true if the plant provides CHW"
    annotation (Evaluate=true,
    Dialog(group="Configuration"));
  inner parameter UserProject.Data.AllSystems datAll
    "Plant parameters"
    annotation (Placement(transformation(extent={{142,40},{162,60}})));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),
    Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"));

  Fluid.HeatPumps.ModularReversible.Modular4Pipe           hp1(
    redeclare package MediumCon = Medium,
    redeclare package MediumCon1 = MediumAir,
    redeclare package MediumEva = Medium,
    use_rev=true,
    allowDifferentDeviceIdentifiers=true,
    use_intSafCtr=false,
    mCon_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dTCon1_nominal=40,
    dpCon1_nominal=6000,
    use_con1Cap=false,
    mEva_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    QHeaCoo_flow_nominal=datAll.pla.hp.capHeaHp_nominal,
    QCoo_flow_nominal=-datAll.pla.hp.capCooHp_nominal,
    redeclare model RefrigerantCycleHeatPumpHeating =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
        (TAppCon_nominal=0, TAppEva_nominal=0),
    redeclare model RefrigerantCycleHeatPumpCooling =
        Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare
          Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        mCon_flow_nominal=hp1.mCon_flow_nominal,
        mEva_flow_nominal=hp1.mEva_flow_nominal,
        datTab=
            Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()),
    redeclare model RefrigerantCycleHeatPumpHeatingCooling =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D2 (
        redeclare
          Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        mCon_flow_nominal=hp1.mCon1_flow_nominal,
        mEva_flow_nominal=hp1.mEva_flow_nominal,
        datTab=
            Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()),
    redeclare model RefrigerantCycleInertia =
        Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        refIneFreConst=1/300,
        nthOrd=1,
        initType=Modelica.Blocks.Types.Init.InitialState),
    TConCoo_nominal=308.15,
    dpCon_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[1],
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaCoo_nominal=279.95,
    dTEva_nominal=6,
    dTCon_nominal=20,
    dpEva_nominal(displayUnit="Pa") = 0.75*datAll.pla.pumChiWatPri.dp_nominal[1],
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    QHea_flow_nominal=datAll.pla.hp.capHeaHp_nominal,
    TEvaHea_nominal=273.15,
    TConHea_nominal=313.15,
    TConHeaCoo_nominal=333.15,
    TEvaHeaCoo_nominal=279.95,
    con1(T_start=298.15),
    con(T_start=313.15),
    eva(T_start=283.15))    "Modular reversible 4pipe heat pump instance"
    annotation (Placement(transformation(extent={{16,-260},{36,-280}})));
public
  Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dpValve_nominal=1e-9)
    annotation (Placement(transformation(extent={{-48,-290},{-28,-270}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov1(redeclare package
      Medium = Medium, m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal,
    dp_nominal=datAll.pla.pumChiWatPri.dp_nominal[1])
    annotation (Placement(transformation(extent={{-20,-270},{0,-290}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov2(redeclare package
      Medium = Medium,
    addPowerToMedium=false,
    m_flow_nominal=4*datAll.pla.hp.mChiWatHp_flow_nominal,
    dp_nominal=datAll.pla.pumChiWatPri.dp_nominal[1])
    annotation (Placement(transformation(extent={{72,-270},{52,-250}})));
  Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = Medium,
    m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal,
    dpValve_nominal=1e-9)
    annotation (Placement(transformation(extent={{110,-270},{90,-250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientCooling)
    annotation (Placement(transformation(extent={{-248,-320},{-228,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-208,-320},{-188,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientHeating)
    annotation (Placement(transformation(extent={{-248,-350},{-228,-330}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-208,-350},{-188,-330}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{-258,-234},{-238,-214}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{-258,-204},{-238,-184}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    annotation (Placement(transformation(extent={{-218,-204},{-198,-184}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{-218,-234},{-198,-214}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    annotation (Placement(transformation(extent={{-98,-250},{-78,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{-98,-200},{-78,-180}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset
                                       conPIDCoo(
    k=0.2,
    Ti=15,                                       reverseActing=false)
    annotation (Placement(transformation(extent={{-18,-174},{-38,-154}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-68,-220},{-48,-200}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset
                                       conPIDHea(k=0.05, Ti=60)
    annotation (Placement(transformation(extent={{60,-340},{80,-320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{152,-230},{132,-210}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{42,-250},{22,-230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(t=0.05, h=0.02)
    annotation (Placement(transformation(extent={{-18,-354},{-38,-334}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(t=50, h=10)
    annotation (Placement(transformation(extent={{132,-264},{152,-244}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{152,-300},{132,-280}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor extIndInt(nin=3)
    annotation (Placement(transformation(extent={{-320,-330},{-300,-310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientCooling,
        Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.AmbientHeating,
        Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.HeatingCooling})
    annotation (Placement(transformation(extent={{-358,-330},{-338,-310}})));
  Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,-194})));
  Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium = Medium,
      m_flow_nominal=datAll.pla.hp.mHeaWatHp_flow_nominal) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={48,-280})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{62,-174},{82,-154}})));
  Fluid.Sources.Outside out(redeclare package Medium = MediumAir, nPorts=2)
    annotation (Placement(transformation(extent={{-478,-174},{-458,-154}})));
  Fluid.Movers.Preconfigured.SpeedControlled_y     mov5(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=10*hp1.mCon1_flow_nominal,
    dp_nominal=2*hp1.dpCon_nominal)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-86,-318})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    annotation (Placement(transformation(extent={{-158,-324},{-138,-304}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea7
    annotation (Placement(transformation(extent={{-132,-324},{-112,-304}})));

  Fluid.Sensors.TemperatureTwoPort senTem8(redeclare package Medium = MediumAir,
      m_flow_nominal=datAll.pla.hp.mChiWatHp_flow_nominal)   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-308,-166})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    annotation (Placement(transformation(extent={{-208,-454},{-188,-434}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(k=Buildings.Fluid.HeatPumps.ModularReversible.Types.Modes.HeatingCooling)
    annotation (Placement(transformation(extent={{-250,-440},{-230,-420}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-138,-364},{-118,-344}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul5
    annotation (Placement(transformation(extent={{-158,-234},{-138,-214}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(t=278)
    annotation (Placement(transformation(extent={{-78,-114},{-98,-94}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea9
    annotation (Placement(transformation(extent={{-118,-114},{-138,-94}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul4
    annotation (Placement(transformation(extent={{-158,-204},{-138,-184}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(t=273.15 + 70)
    annotation (Placement(transformation(extent={{-98,-464},{-78,-444}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea10
    annotation (Placement(transformation(extent={{-58,-464},{-38,-444}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uPlaOpeMod annotation (
      Placement(transformation(extent={{-580,-320},{-540,-280}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumEvaEna annotation (
      Placement(transformation(extent={{-580,-260},{-540,-220}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumConEna annotation (
      Placement(transformation(extent={{-580,-360},{-540,-320}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPumEna annotation (
      Placement(transformation(extent={{-580,-140},{-540,-100}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet annotation (Placement(
        transformation(extent={{-580,-400},{-540,-360}}), iconTransformation(
          extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHPEnaPro annotation (
      Placement(transformation(extent={{180,-120},{220,-80}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumEvaEnaPro annotation
    (Placement(transformation(extent={{180,-180},{220,-140}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumConEnaPro annotation
    (Placement(transformation(extent={{180,-240},{220,-200}}),
        iconTransformation(extent={{100,20},{140,60}})));
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-510,
            -100},{-436,-30}}), iconTransformation(extent={{-424,-132},{-350,
            -62}})));
equation
  if have_chiWat then
  end if;
  connect(cheVal.port_b, mov1.port_a)
    annotation (Line(points={{-28,-280},{-20,-280}},   color={0,127,255}));
  connect(mov1.port_b, hp1.port_a1)
    annotation (Line(points={{0,-280},{16,-280}},      color={0,127,255}));
  connect(cheVal1.port_b, mov2.port_a)
    annotation (Line(points={{90,-260},{72,-260}},   color={0,127,255}));
  connect(mov2.port_b, hp1.port_a2)
    annotation (Line(points={{52,-260},{36,-260}},     color={0,127,255}));
  connect(conInt.y, extIndInt.u)
    annotation (Line(points={{-336,-320},{-322,-320}},
                                                 color={255,127,0}));

  connect(conInt2.y, intEqu2.u1)
    annotation (Line(points={{-226,-310},{-210,-310}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u1)
    annotation (Line(points={{-226,-340},{-210,-340}}, color={255,127,0}));
  connect(extIndInt.y, intEqu2.u2) annotation (Line(points={{-298,-320},{-290,-320},
          {-290,-290},{-218,-290},{-218,-318},{-210,-318}},
                              color={255,127,0}));
  connect(extIndInt.y, intEqu1.u2) annotation (Line(points={{-298,-320},{-262,-320},
          {-262,-358},{-210,-358},{-210,-348}},
                  color={255,127,0}));
  connect(mov2.y_actual, greThr.u) annotation (Line(points={{51,-253},{44,-253},
          {44,-240}},   color={0,0,127}));
  connect(mov1.y_actual, greThr1.u) annotation (Line(points={{1,-287},{1,-286},{
          6,-286},{6,-344},{-16,-344}},                                 color={0,
          0,127}));
  connect(hp1.P, greThr2.u) annotation (Line(points={{37,-270},{37,-298},{66,-298},
          {66,-286},{122,-286},{122,-254},{130,-254}},
                                                   color={0,0,127}));
  connect(extIndInt.y, hp1.mod) annotation (Line(points={{-298,-320},{-290,-320},
          {-290,-290},{-62,-290},{-62,-258},{6,-258},{6,-267.9},{14.9,-267.9}},
                                                            color={255,127,0}));
  connect(and3.y, booToRea4.u)
    annotation (Line(points={{-236,-224},{-220,-224}}, color={255,0,255}));
  connect(and1.y, booToRea3.u)
    annotation (Line(points={{-236,-194},{-220,-194}}, color={255,0,255}));
  connect(conPIDCoo.y, mul.u2) annotation (Line(points={{-40,-164},{-110,-164},{
          -110,-196},{-100,-196}},                          color={0,0,127}));
  connect(mul.y, add2.u1) annotation (Line(points={{-76,-190},{-70,-190},{-70,-204}},
                  color={0,0,127}));
  connect(mul1.y, add2.u2) annotation (Line(points={{-76,-240},{-74,-240},{-74,-226},
          {-70,-226},{-70,-216}},         color={0,0,127}));
  connect(add2.y, hp1.ySet) annotation (Line(points={{-46,-210},{14.9,-210},{14.9,
          -271.9}},        color={0,0,127}));
  connect(hp1.port_b2, senTem.port_a) annotation (Line(points={{16,-260},{2,-260},
          {2,-204}},          color={0,127,255}));
  connect(senTem1.port_a, hp1.port_b1)
    annotation (Line(points={{38,-280},{36,-280}},     color={0,127,255}));
  connect(conPIDHea.y, mul1.u2) annotation (Line(points={{82,-330},{92,-330},{92,
          -304},{-60,-304},{-60,-256},{-72,-256},{-72,-260},{-108,-260},{-108,-246},
          {-100,-246}},                                   color={0,0,127}));
  connect(senTem.T, swi.u1) annotation (Line(points={{-9,-194},{-18,-194},{-18,-214},
          {42,-214},{42,-156},{60,-156}},             color={0,0,127}));
  connect(senTem1.T, swi.u3) annotation (Line(points={{48,-291},{48,-300},{80,-300},
          {80,-208},{54,-208},{54,-172},{60,-172}},
                                          color={0,0,127}));
  connect(swi.y, conPIDCoo.u_m) annotation (Line(points={{84,-164},{90,-164},{90,
          -182},{46,-182},{46,-218},{-22,-218},{-22,-186},{-28,-186},{-28,-176}},
                        color={0,0,127}));
  connect(swi.y, conPIDHea.u_m) annotation (Line(points={{84,-164},{92,-164},{92,
          -184},{48,-184},{48,-224},{60,-224},{60,-232},{84,-232},{84,-312},{96,
          -312},{96,-352},{70,-352},{70,-342}},
                                              color={0,0,127}));

  connect(booToRea.y, mov2.y) annotation (Line(points={{130,-220},{130,-222},{62,
          -222},{62,-248}},   color={0,0,127}));
  connect(booToRea1.y, mov1.y) annotation (Line(points={{130,-290},{60,-290},{60,
          -292},{-10,-292}},       color={0,0,127}));

  connect(out.ports[1], mov5.port_a) annotation (Line(points={{-458,-165},{-458,
          -264},{-106,-264},{-106,-318},{-96,-318}},              color={0,127,255}));
  connect(mov5.port_b, hp1.port_a3) annotation (Line(points={{-76,-318},{26,-318},
          {26,-282}},   color={0,127,255}));
  connect(xor.y, booToRea7.u)
    annotation (Line(points={{-136,-314},{-134,-314}}, color={255,0,255}));
  connect(booToRea7.y, mov5.y) annotation (Line(points={{-110,-314},{-98,-314},{
          -98,-306},{-86,-306}},    color={0,0,127}));
  connect(booToRea.u, xor.u1) annotation (Line(points={{154,-220},{162,-220},{162,
          -134},{-172,-134},{-172,-314},{-160,-314}},
                              color={255,0,255}));
  connect(booToRea1.u, xor.u2) annotation (Line(points={{154,-290},{158,-290},{158,
          -346},{106,-346},{106,-394},{-2,-394},{-2,-386},{-170,-386},{-170,-322},
          {-160,-322}},       color={255,0,255}));
  connect(booToRea.u, conPIDCoo.trigger) annotation (Line(points={{154,-220},{154,
          -222},{162,-222},{162,-134},{-54,-134},{-54,-186},{-38,-186},{-38,-190},
          {-18,-190},{-18,-182},{-22,-182},{-22,-176}},           color={255,0,
          255}));
  connect(booToRea1.u, conPIDHea.trigger) annotation (Line(points={{154,-290},{160,
          -290},{160,-348},{108,-348},{108,-356},{64,-356},{64,-342}},
                                                                color={255,0,
          255}));
  connect(out.ports[2], senTem8.port_b) annotation (Line(points={{-458,-163},{-388,
          -163},{-388,-166},{-318,-166}},           color={0,127,255}));
  connect(senTem8.port_a, hp1.port_b3) annotation (Line(points={{-298,-166},{-184,
          -165.333},{-184,-122},{10,-122},{10,-257.9},{26,-257.9}},
        color={0,127,255}));
  connect(conInt4.y, intEqu3.u1)
    annotation (Line(points={{-228,-430},{-228,-432},{-220,-432},{-220,-444},{-210,
          -444}},                                      color={255,127,0}));
  connect(extIndInt.y, intEqu3.u2) annotation (Line(points={{-298,-320},{-290,-320},
          {-290,-452},{-210,-452}},                   color={255,127,0}));
  connect(intEqu3.y, or2.u2) annotation (Line(points={{-186,-444},{-186,-446},{-158,
          -446},{-158,-362},{-140,-362}},      color={255,0,255}));
  connect(mul5.y, mul1.u1) annotation (Line(points={{-136,-224},{-110,-224},{-110,
          -234},{-100,-234}},      color={0,0,127}));
  connect(booToRea4.y, mul5.u1) annotation (Line(points={{-196,-224},{-170,-224},
          {-170,-218},{-160,-218}}, color={0,0,127}));
  connect(senTem.T, greThr4.u) annotation (Line(points={{-9,-194},{-66,-194},{-66,
          -104},{-76,-104}},        color={0,0,127}));
  connect(greThr4.y, booToRea9.u)
    annotation (Line(points={{-100,-104},{-116,-104}}, color={255,0,255}));
  connect(booToRea9.y, mul5.u2) annotation (Line(points={{-140,-104},{-174,-104},
          {-174,-230},{-160,-230}}, color={0,0,127}));
  connect(mul4.y, mul.u1) annotation (Line(points={{-136,-194},{-118,-194},{-118,
          -184},{-100,-184}},      color={0,0,127}));
  connect(booToRea3.y, mul4.u1) annotation (Line(points={{-196,-194},{-170,-194},
          {-170,-188},{-160,-188}}, color={0,0,127}));
  connect(lesThr.y, booToRea10.u)
    annotation (Line(points={{-76,-454},{-60,-454}},   color={255,0,255}));
  connect(booToRea10.y, mul4.u2) annotation (Line(points={{-36,-454},{-30,-454},
          {-30,-390},{-282,-390},{-282,-282},{-258,-282},{-258,-246},{-186,-246},
          {-186,-210},{-170,-210},{-170,-200},{-160,-200}},            color={0,
          0,127}));
  connect(senTem1.T, lesThr.u) annotation (Line(points={{48,-291},{46,-291},{46,
          -314},{-62,-314},{-62,-382},{-54,-382},{-54,-438},{-114,-438},{-114,-454},
          {-100,-454}},                   color={0,0,127}));
  connect(intEqu1.y, and3.u1) annotation (Line(points={{-186,-340},{-186,-342},{
          -178,-342},{-178,-250},{-254,-250},{-254,-242},{-266,-242},{-266,-224},
          {-260,-224}},       color={255,0,255}));
  connect(or2.y, and1.u1) annotation (Line(points={{-116,-354},{-110,-354},{-110,
          -334},{-174,-334},{-174,-318},{-170,-318},{-170,-238},{-178,-238},{-178,
          -190},{-190,-190},{-190,-178},{-266,-178},{-266,-194},{-260,-194}},
                  color={255,0,255}));
  connect(intEqu2.y, or2.u1) annotation (Line(points={{-186,-310},{-182,-310},{-182,
          -334},{-174,-334},{-174,-354},{-140,-354}},      color={255,0,255}));
  connect(or2.y, swi.u2) annotation (Line(points={{-116,-354},{-110,-354},{-110,
          -334},{-174,-334},{-174,-318},{-170,-318},{-170,-238},{-178,-238},{-178,
          -190},{-190,-190},{-190,-86},{10,-86},{10,-118},{18,-118},{18,-164},{60,
          -164}},                   color={255,0,255}));
  connect(cheVal.port_a, port_a2) annotation (Line(points={{-48,-280},{-56,-280},
          {-56,-236},{-32,-236},{-32,-184},{-48,-184},{-48,-60},{100,-60}},
        color={0,127,255}));
  connect(senTem1.port_b, port_b2) annotation (Line(points={{58,-280},{120,-280},
          {120,-44},{-100,-44},{-100,-60}}, color={0,127,255}));
  connect(cheVal1.port_a, port_a1) annotation (Line(points={{110,-260},{116,-260},
          {116,-80},{-120,-80},{-120,60},{-100,60}}, color={0,127,255}));
  connect(senTem.port_b, port_b1)
    annotation (Line(points={{2,-184},{2,60},{100,60}}, color={0,127,255}));
  connect(uPumEvaEna, xor.u1) annotation (Line(points={{-560,-240},{-480,-240},{
          -480,-270},{-174,-270},{-174,-314},{-160,-314}}, color={255,0,255}));
  connect(uPumConEna, xor.u2) annotation (Line(points={{-560,-340},{-400,-340},{
          -400,-370},{-170,-370},{-170,-322},{-160,-322}}, color={255,0,255}));
  connect(uHeaPumEna, and1.u2) annotation (Line(points={{-560,-120},{-280,-120},
          {-280,-202},{-260,-202}}, color={255,0,255}));
  connect(uHeaPumEna, and3.u2) annotation (Line(points={{-560,-120},{-280,-120},
          {-280,-232},{-260,-232}}, color={255,0,255}));
  connect(uPlaOpeMod, extIndInt.index) annotation (Line(points={{-560,-300},{-380,
          -300},{-380,-354},{-310,-354},{-310,-332}}, color={255,127,0}));
  connect(TSupSet, conPIDHea.u_s) annotation (Line(points={{-560,-380},{52,-380},
          {52,-330},{58,-330}}, color={0,0,127}));
  connect(TSupSet, conPIDCoo.u_s) annotation (Line(points={{-560,-380},{-288,-380},
          {-288,-164},{-16,-164}}, color={0,0,127}));
  connect(greThr2.y, yHPEnaPro) annotation (Line(points={{154,-254},{168,-254},{
          168,-100},{200,-100}}, color={255,0,255}));
  connect(greThr1.y, yPumConEnaPro) annotation (Line(points={{-40,-344},{-48,-344},
          {-48,-390},{172,-390},{172,-220},{200,-220}}, color={255,0,255}));
  connect(greThr.y, yPumEvaEnaPro) annotation (Line(points={{20,-240},{6,-240},{
          6,-200},{150,-200},{150,-160},{200,-160}}, color={255,0,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-473,-65},{-472,-65},{-472,-148},{-488,-148},{-488,-163.8},{-478,
          -163.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/HeatPumps/Validation/AirToWater.mos"
        "Simulate and plot"),
    experiment(
      StartTime=11145600,
      StopTime=11750400,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.AirToWater\">
Buildings.Templates.Plants.HeatPumps.AirToWater</a>
by simulating a <i>24</i>-hour period with overlapping heating and
cooling loads.
The heating loads reach their peak value first, the cooling loads reach it last.
</p>
<p>
Three equally sized heat pumps are modeled, which can all be lead/lag alternated.
A heat recovery chiller is included (<code>pla.have_hrc_select=true</code>) 
and connected to the HW and CHW return pipes (sidestream integration).
A unique aggregated load is modeled on each loop by means of a cooling or heating
component controlled to maintain a constant <i>&Delta;T</i>
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
The user can toggle the top-level parameter <code>have_chiWat</code>
to switch between a cooling and heating system (the default setting)
to a heating-only system.
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
<p>
Simulating this model shows how the plant responds to a varying load by
</p>
<ul>
<li>
staging or unstaging the AWHPs and associated primary pumps,
</li>
<li>
rotating lead/lag alternate equipment to ensure even wear,
</li>
<li>
resetting the supply temperature and remote differential pressure
in both the CHW and HW loops based on the valve position,
</li>
<li>
staging and controlling the secondary pumps to meet the
remote differential pressure setpoint.
</li>
</ul>
<h4>Details</h4>
<p>
By default, all valves within the plant are modeled considering a linear
variation of the pressure drop with the flow rate (<code>pla.linearized=true</code>),
as opposed to the quadratic relationship usually considered for
a turbulent flow regime.
By limiting the size of the system of nonlinear equations, this setting
reduces the risk of solver failure and the time to solution for testing
various plant configurations.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added sidestream HRC and refactored the model after updating the HP plant template.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3808\">#3808</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        extent={{-540,-480},{180,80}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-34},{100,-88}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,84},{100,30}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end FourPipeASHP_with_controls;
