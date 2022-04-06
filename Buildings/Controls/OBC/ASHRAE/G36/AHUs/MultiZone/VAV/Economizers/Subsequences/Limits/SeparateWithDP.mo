within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits;
block SeparateWithDP
  "Outdoor air and return air damper position limits for units with separated minimum outdoor air damper and differential pressure control"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venSta
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Boolean have_CO2Sen=false
    "True: there are zones have CO2 sensor"
    annotation (Dialog(enable=venSta==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real dpAbsOutDam_min(
    unit="Pa",
    displayUnit="Pa")=0
    "Absolute pressure difference across the minimum outdoor air damper"
    annotation (Dialog(enable=venSta==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real dpDesOutDam_min(unit="Pa", displayUnit="Pa")
    "Design pressure difference across the minimum outdoor air damper";
  parameter Real minSpe(unit="1")
     "Minimum supply fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of differential pressure setpoint controller"
    annotation (Dialog(group="DP control"));
  parameter Real kDp(unit="1")=1
                      "Gain of controller"
    annotation (Dialog(group="DP control"));
  parameter Real TiDp(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="DP control",
      enable=dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
             dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdDp(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="DP control",
      enable=dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
             dpCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real retDamPhyPosMax(unit="1")=1
                        "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real outDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput effAbsOutAir_normalized(
    final unit="1")
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Effective minimum outdoor airflow setpoint, normalized by the absolute outdoor air rate "
    annotation (Placement(transformation(extent={{-260,280},{-220,320}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxCO2(
    final unit="1")
    if have_CO2Sen and venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Maximum Zone CO2 control loop"
    annotation (Placement(transformation(extent={{-260,250},{-220,290}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput effDesOutAir_normalized(
    final unit="1")
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Effective minimum outdoor airflow setpoint, normalized by the design outdoor air rate "
    annotation (Placement(transformation(extent={{-260,210},{-220,250}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-260,90},{-220,130}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOutMinSet_flow_normalized(
    final unit="1") if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-260,130},{-220,170}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status signal"
    annotation (Placement(transformation(extent={{-260,50},{-220,90}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-260,10},{-220,50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-260,-50},{-220,-10}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-260,-110},{-220,-70}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMinOutDam
    "Status of minimum outdoor air damper position, true means it's open"
    annotation (Placement(transformation(extent={{220,50},{260,90}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMin(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Physically minimum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{220,-190},{260,-150}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") "Physically maximum outdoor air damper position limit"
    annotation (Placement(transformation(extent={{220,-230},{260,-190}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMin(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Minimum return air damper position limit"
    annotation (Placement(transformation(extent={{220,-270},{260,-230}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMax(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Maximum return air damper position limit"
    annotation (Placement(transformation(extent={{220,-320},{260,-280}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Physical maximum return air damper position limit. Required as an input for the economizer enable disable sequence"
    annotation (Placement(transformation(extent={{220,-360},{260,-320}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply minDp if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Minimum pressure difference setpoint when complying with ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minDesDp(
    final k=dpDesOutDam_min)
    "Design minimum outdoor air damper pressure difference"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Square of the normalized minimum airflow"
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final h=1)
    "Check if the minimum pressure difference setpoint is greater than zero"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=0.05)
    "Check if economizer outdoor air damper is less than projected position"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1.1)
    "Projected position with a gain factor"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=0.05)
    "Check if the economizer outdoor air damper is greater than threshold"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaDis
    "Enable or disable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.And enaRetDamMin
    "Enable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or disRetDamMin
    "Disable return air damper minimum outdoor air control"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not disMinDam "Check if the minimum outdoor air damper is closed"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset maxRetDam(
    final controllerType=dpCon,
    final k=kDp,
    final Ti=TiDp,
    final Td=TdDp) "Maximum return air damper position"
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-200,0},{-180,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Logical.And3 enaMinDam
    "Check if the minimum outdoor air damper should be enabled"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) "Constant"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFanSpe(
    final k=minSpe) "Minimum fan speed"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.05) "Constant"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0.8) "Constant"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Line moaP(
    final limitBelow=true,
    final limitAbove=true)
    "Linear mapping of the supply fan speed to the control signal"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMinSig(
    final k=outDamPhyPosMin)
    "Physically fixed minimum position of the outdoor air damper. This is the initial position of the economizer damper"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physically fixed maximum position of the outdoor air damper."
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMinSig(
    final k=retDamPhyPosMin)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMaxSig(
    final k=retDamPhyPosMax)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-200,-300},{-180,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamPosMaxSwi
    "A switch to deactivate the return air damper maximum outdoor airflow control"
    annotation (Placement(transformation(extent={{180,-310},{200,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch retDamPosMinSwi
    "A switch to deactivate the return air damper minimal outdoor airflow control"
    annotation (Placement(transformation(extent={{180,-260},{200,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Square of the normalized minimum airflow"
    annotation (Placement(transformation(extent={{-180,290},{-160,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply  pro2
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Square of the normalized minimum airflow"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minAbsDp(
    final k=dpAbsOutDam_min)
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Absolute minimum outdoor air damper pressure difference"
    annotation (Placement(transformation(extent={{-180,330},{-160,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Line minDp1(
    final limitAbove=true)
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Minimum pressure difference setpoint when complying with Title 24"
    annotation (Placement(transformation(extent={{20,260},{40,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(
    final k=1)
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Design fan speed"
    annotation (Placement(transformation(extent={{-60,230},{-40,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(
    final k=0.5)
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Constant"
    annotation (Placement(transformation(extent={{-60,290},{-40,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one2(
    final k=1)
    if not have_CO2Sen and venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Design fan speed"
    annotation (Placement(transformation(extent={{-120,240},{-100,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply actAbsMinDp
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Active absolute minimum pressure difference setpoint"
    annotation (Placement(transformation(extent={{-120,300},{-100,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply actDesMinDp
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Active design minimum pressure difference setpoint"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
equation
  connect(VOutMinSet_flow_normalized, pro.u1) annotation (Line(points={{-240,150},
          {-200,150},{-200,156},{-182,156}}, color={0,0,127}));
  connect(VOutMinSet_flow_normalized, pro.u2) annotation (Line(points={{-240,150},
          {-200,150},{-200,144},{-182,144}}, color={0,0,127}));
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-240,30},{-162,30}},   color={255,127,0}));
  connect(conInt1.y, intEqu.u2) annotation (Line(points={{-178,10},{-170,10},{-170,
          22},{-162,22}},        color={255,127,0}));
  connect(minDp.y, greThr.u) annotation (Line(points={{-98,170},{-90,170},{-90,150},
          {-82,150}}, color={0,0,127}));
  connect(minFanSpe.y, moaP.x1) annotation (Line(points={{-138,-60},{-130,-60},{
          -130,-82},{-122,-82}}, color={0,0,127}));
  connect(con1.y, moaP.f1) annotation (Line(points={{-178,-60},{-170,-60},{-170,
          -86},{-122,-86}}, color={0,0,127}));
  connect(con.y, moaP.f2) annotation (Line(points={{-138,-120},{-130,-120},{-130,
          -98},{-122,-98}},
                      color={0,0,127}));
  connect(one.y, moaP.x2) annotation (Line(points={{-178,-120},{-170,-120},{-170,
          -94},{-122,-94}},
                      color={0,0,127}));
  connect(uSupFanSpe, moaP.u)
    annotation (Line(points={{-240,-90},{-122,-90}}, color={0,0,127}));
  connect(uOutDamPos, les.u1)
    annotation (Line(points={{-240,-30},{-42,-30}},color={0,0,127}));
  connect(moaP.y, les.u2) annotation (Line(points={{-98,-90},{-90,-90},{-90,-38},
          {-42,-38}}, color={0,0,127}));
  connect(uOutDamPos, gre.u1) annotation (Line(points={{-240,-30},{-60,-30},{-60,
          -90},{-42,-90}},color={0,0,127}));
  connect(gai.y, gre.u2) annotation (Line(points={{-58,-120},{-50,-120},{-50,-98},
          {-42,-98}}, color={0,0,127}));
  connect(moaP.y, gai.u) annotation (Line(points={{-98,-90},{-90,-90},{-90,-120},
          {-82,-120}}, color={0,0,127}));
  connect(enaMinDam.y, enaRetDamMin.u1) annotation (Line(points={{-18,70},{-10,70},
          {-10,10},{38,10}},         color={255,0,255}));
  connect(les.y, enaRetDamMin.u2) annotation (Line(points={{-18,-30},{10,-30},{10,
          2},{38,2}},      color={255,0,255}));
  connect(enaRetDamMin.y, enaDis.u)
    annotation (Line(points={{62,10},{78,10}},  color={255,0,255}));
  connect(enaMinDam.y, disMinDam.u) annotation (Line(points={{-18,70},{-10,70},{
          -10,-60},{-2,-60}}, color={255,0,255}));
  connect(disMinDam.y, disRetDamMin.u1)
    annotation (Line(points={{22,-60},{38,-60}}, color={255,0,255}));
  connect(gre.y, disRetDamMin.u2) annotation (Line(points={{-18,-90},{30,-90},{30,
          -68},{38,-68}},color={255,0,255}));
  connect(disRetDamMin.y, enaDis.clr) annotation (Line(points={{62,-60},{70,-60},
          {70,4},{78,4}},   color={255,0,255}));
  connect(greThr.y, enaMinDam.u1) annotation (Line(points={{-58,150},{-50,150},{
          -50,78},{-42,78}},   color={255,0,255}));
  connect(intEqu.y, enaMinDam.u3) annotation (Line(points={{-138,30},{-60,30},{-60,
          62},{-42,62}},   color={255,0,255}));
  connect(minDp.y, maxRetDam.u_s) annotation (Line(points={{-98,170},{118,170}},
                                color={0,0,127}));
  connect(dpMinOutDam, maxRetDam.u_m)
    annotation (Line(points={{-240,110},{130,110},{130,158}}, color={0,0,127}));
  connect(enaDis.y, maxRetDam.trigger)
    annotation (Line(points={{102,10},{124,10},{124,158}},color={255,0,255}));
  connect(retDamPhyPosMaxSig.y, yRetDamPhyPosMax) annotation (Line(points={{-178,
          -290},{-140,-290},{-140,-340},{240,-340}}, color={0,0,127}));
  connect(enaDis.y, retDamPosMaxSwi.u2) annotation (Line(points={{102,10},{124,10},
          {124,-300},{178,-300}}, color={255,0,255}));
  connect(maxRetDam.y, retDamPosMaxSwi.u1) annotation (Line(points={{142,170},{160,
          170},{160,-292},{178,-292}}, color={0,0,127}));
  connect(retDamPosMaxSwi.y, yRetDamPosMax)
    annotation (Line(points={{202,-300},{240,-300}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMaxSwi.u3) annotation (Line(points={{-178,
          -290},{-140,-290},{-140,-308},{178,-308}}, color={0,0,127}));
  connect(enaDis.y, retDamPosMinSwi.u2) annotation (Line(points={{102,10},{124,10},
          {124,-250},{178,-250}}, color={255,0,255}));
  connect(retDamPhyPosMinSig.y, retDamPosMinSwi.u1) annotation (Line(points={{-178,
          -250},{-140,-250},{-140,-242},{178,-242}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, retDamPosMinSwi.u3) annotation (Line(points={{-178,
          -290},{-140,-290},{-140,-258},{178,-258}}, color={0,0,127}));
  connect(retDamPosMinSwi.y, yRetDamPosMin)
    annotation (Line(points={{202,-250},{240,-250}}, color={0,0,127}));
  connect(outDamPhyPosMinSig.y, yOutDamPosMin)
    annotation (Line(points={{-178,-170},{240,-170}}, color={0,0,127}));
  connect(outDamPhyPosMaxSig.y, yOutDamPosMax)
    annotation (Line(points={{-178,-210},{240,-210}}, color={0,0,127}));
  connect(enaMinDam.y, yMinOutDam)
    annotation (Line(points={{-18,70},{240,70}},   color={255,0,255}));
  connect(uSupFan, enaMinDam.u2)
    annotation (Line(points={{-240,70},{-42,70}},   color={255,0,255}));
  connect(effAbsOutAir_normalized, pro1.u1) annotation (Line(points={{-240,300},
          {-200,300},{-200,306},{-182,306}}, color={0,0,127}));
  connect(effAbsOutAir_normalized, pro1.u2) annotation (Line(points={{-240,300},
          {-200,300},{-200,294},{-182,294}}, color={0,0,127}));
  connect(effDesOutAir_normalized, pro2.u1) annotation (Line(points={{-240,230},
          {-200,230},{-200,236},{-182,236}}, color={0,0,127}));
  connect(effDesOutAir_normalized, pro2.u2) annotation (Line(points={{-240,230},
          {-200,230},{-200,224},{-182,224}}, color={0,0,127}));
  connect(pro1.y, actAbsMinDp.u2) annotation (Line(points={{-158,300},{-140,300},
          {-140,304},{-122,304}}, color={0,0,127}));
  connect(minAbsDp.y, actAbsMinDp.u1) annotation (Line(points={{-158,340},{-140,
          340},{-140,316},{-122,316}}, color={0,0,127}));
  connect(minDesDp.y, actDesMinDp.u2) annotation (Line(points={{-158,190},{-140,
          190},{-140,204},{-122,204}}, color={0,0,127}));
  connect(pro2.y, actDesMinDp.u1) annotation (Line(points={{-158,230},{-140,230},
          {-140,216},{-122,216}}, color={0,0,127}));
  connect(pro.y, minDp.u2) annotation (Line(points={{-158,150},{-140,150},{-140,
          164},{-122,164}}, color={0,0,127}));
  connect(minDesDp.y, minDp.u1) annotation (Line(points={{-158,190},{-140,190},{
          -140,176},{-122,176}}, color={0,0,127}));
  connect(uMaxCO2, minDp1.u)
    annotation (Line(points={{-240,270},{18,270}}, color={0,0,127}));
  connect(actAbsMinDp.y, minDp1.f1) annotation (Line(points={{-98,310},{-80,310},
          {-80,274},{18,274}}, color={0,0,127}));
  connect(actDesMinDp.y, minDp1.f2) annotation (Line(points={{-98,210},{0,210},{
          0,262},{18,262}}, color={0,0,127}));
  connect(hal.y, minDp1.x1) annotation (Line(points={{-38,300},{-20,300},{-20,278},
          {18,278}}, color={0,0,127}));
  connect(one1.y, minDp1.x2) annotation (Line(points={{-38,240},{-20,240},{-20,266},
          {18,266}}, color={0,0,127}));
  connect(minDp1.y, maxRetDam.u_s) annotation (Line(points={{42,270},{60,270},{60,
          170},{118,170}}, color={0,0,127}));
  connect(minDp1.y, greThr.u) annotation (Line(points={{42,270},{60,270},{60,
          170},{-90,170},{-90,150},{-82,150}},
                                          color={0,0,127}));
  connect(one2.y, minDp1.u) annotation (Line(points={{-98,250},{-80,250},{-80,270},
          {18,270}}, color={0,0,127}));
annotation (
  defaultComponentName="ecoLim",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
                 Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,38},{-48,22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dpMinOutDam"),
        Text(
          extent={{-98,20},{6,2}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOutMinSet_flow_normalized",
          visible=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{-98,-60},{-42,-76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOutDamPos"),
        Text(
          extent={{-98,-82},{-42,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uSupFanSpe"),
        Text(
          extent={{36,60},{98,42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDamPosMin"),
        Text(
          extent={{36,40},{98,22}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yOutDamPosMax"),
        Text(
          extent={{38,-40},{98,-58}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPosMax"),
        Text(
          extent={{38,-20},{98,-38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPosMin"),
        Text(
          extent={{30,-78},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yRetDamPhyPosMax"),
        Text(
          extent={{-100,-12},{-58,-26}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uSupFan"),
        Text(
          extent={{-100,-32},{-50,-46}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{52,94},{98,70}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yMinOutDam"),
        Text(
          extent={{-96,98},{-4,84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="effAbsOutAir_normalized",
          visible=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{-96,58},{-4,44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="effDesOutAir_normalized",
          visible=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{-96,78},{-56,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uMaxCO2",
          visible=have_CO2Sen and venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-360},{220,360}})),
  Documentation(info="<html>
<p>
Block that outputs the position limits of the return and outdoor air damper for units
with a separated minimum outdoor air damper and differential pressure control.
It is implemented according to Section 5.16.4 of the ASHRAE Guideline 36, May 2020.
</p>
<h4>Differential pressure setpoint across the minimum outdoor air damper</h4>
<ul>
<li>
Per Section 3.2.1, designer should provide the design minimum pressure difference across
the minimum outdoor air damper, <code>dpDesOutDam_min</code>. The absolute minimum
pressure difference should also be provided if complying with California Title 24
requirements.
</li>
<li>
Calculate the outdoor air set point with
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU</a>
if complying with ASHRAE 62.1 requirements. Otherwise, see the set points in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU</a>
if complying with Title 24 requirements.
</li>
<li>
The minimum outdoor air differential pressure set point shall be calculated per
Section 5.16.4.1 (if complying with ASHRAE 62.1 requirements) or Section 5.16.4.2
(if complying with Title 24 requirements).
</li>
</ul>
<h4>Open minimum outdoor air damper</h4>
<p>
Open minimum outdoor air damper when the supply air fan is proven ON and the system
is in occupied mode and the minimum differential pressure set point is greater
than zero. Damper shall be closed otherwise.
</p>
<h4>Return air damper</h4>
<ul>
<li>
Return air damper minimum outdoor air control is enabled when the minimum outdoor
air damper is open and the economizer outdoor air damper is less than a projected
position limit, which is 5% when supply fan speed is at 100% design speed proportionally
up to 80% when the fan is at minimum speed.
</li>
<li>
Return air damper minimum outdoor air control is disabled when the minimum outdoor
air damper is closed or the economizer outdoor air damper is 10% above the projected
position limit as determined above.
</li>
<li>
When enabled, the maximum return air damper set point is modulated from 100% to 0%
to maintain the differential pressure across the minimum outdoor air damper at set
point.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SeparateWithDP;
