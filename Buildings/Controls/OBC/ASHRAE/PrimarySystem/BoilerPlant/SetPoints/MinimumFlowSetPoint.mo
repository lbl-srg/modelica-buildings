within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints;
block MinimumFlowSetPoint "Hot water minimum flow setpoint"

  parameter Integer nBoi(
    final min=1) = 3
    "Total number of boilers";

  parameter Integer nSta(
    final min=1) = 5
    "Total number of stages";

  parameter Integer staMat[nSta, nBoi] = {{1,0,0},{0,1,0},{1,1,0},{0,1,1},{1,1,1}}
    "Boiler staging matrix";

  parameter Real minFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6,
    final max=maxFloSet) = {0.005, 0.005, 0.005}
    "Design minimum hot water flow through each boiler";

  parameter Real maxFloSet[nBoi](
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate",
    final min=minFloSet) = {0.025, 0.025, 0.025}
    "Design maximum hot water flow through each boiler";

  parameter Real bypSetRat(
    final unit="m3/s2",
    displayUnit="m3/s2",
    final min=0) = 0.001
    "Rate at which to reset bypass valve setpoint during stage change";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Signal indicating stage change with boilers being both enabled and disabled"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaPro
    "Signal indicating completion of stage change process"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uStaSet
    "Staging setpoint"
    annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uLasDisBoi
    "Index of boiler being disabled"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWatMinSet_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Hot water minimum flow setpoint"
    annotation (Placement(transformation(extent={{320,-90},{360,-50}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Integer boiInd[nBoi]={i for i in 1:nBoi}
    "Boiler index, {1,2,...,n}";

  parameter Integer staInd[nSta]={i for i in 1:nSta}
    "Stage index, {1,2,...,n}";

  parameter Real minFloSetMat[nSta, nBoi] = {minFloSet[i] for i in 1:nBoi, j in 1:nSta}
    "Boiler minimum design flowrate expanded for element-wise multiplication
    with the staging matrix";

  parameter Real maxFloSetMat[nSta, nBoi] = {maxFloSet[i] for i in 1:nBoi, j in 1:nSta}
    "Boiler maximum design flowrate expanded for element-wise multiplication
    with the staging matrix";

  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes
    "Used to break algebraic loop and sample the minimum flow setpoint at the start
    of stage change process to use as reference for calculations"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1/bypSetRat)
    "Find time required for changing bypass position setpoint"
    annotation (Placement(transformation(extent={{210,-260},{230,-240}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3
    "Find difference between new and old setpoints"
    annotation (Placement(transformation(extent={{230,-210},{250,-190}})));

  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Ensure time required is positive"
    annotation (Placement(transformation(extent={{280,-260},{300,-240}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1e-6)
    "Calculate time required to reset setpoint"
    annotation (Placement(transformation(extent={{250,-260},{270,-240}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=0)
    "Check if time required for setpoint change has elapsed"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nSta,nBoi](
    final k=minFloSetMat)
    "Design minimum boiler flowrate"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[nSta,nBoi](
    final k=maxFloSetMat)
    "Design maximum boiler flowrate"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2[nSta,nBoi](
    final k=staMat)
    "Boiler staging matrix"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));

  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Detect change in stage setpoint"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Set minimum flow setpoint as per 5.3.8.2 if uOnOff=True, else as per 5.3.8.1"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical And"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[nSta,nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-80,-150},{-60,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[nSta,nBoi]
    "Element-wise product"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div[nSta,nBoi]
    "Element-wise division"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[nSta,nBoi](
    final p=fill(1e-8,nSta,nBoi))
    "Prevent divison by zero"
    annotation (Placement(transformation(extent={{-50,-190},{-30,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixMax matMax(
    final rowMax=true,
    final nRow=nSta,
    final nCol=nBoi)
    "Identify maximum flowrate ratio for all boilers operating in stage"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai(
    final K=staMat)
    "Sum of maximum flowrates of operating boilers"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3[nBoi](
    final k=maxFloSet)
    "Design maximum boiler flowrate"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro2
    "Product of flowrate ratio and maximum flowrate"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta)
    "Extract flow ratio of current setpoint during stage-up or stage-down"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig1(
    final nin=nSta)
    "Extract flow ratio of previous setpoint during stage-up"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Integers.Subtract subInt
    "Previous stage during stage change"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max
    "Max flowrate as per 5.3.8.2"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig2(
    final nin=nSta)
    "Extract max flowrate of current setpoint during stage-up or stage-down"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Max flowrate as per 5.3.8.2"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig3(
    final nin=nBoi)
    "Extract max flowrate of boiler being disabled during stage-up"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Pass minimum flow setpoint based on whether stage-up involves a boiler being disabled"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro3
    "Product of flowrate ratio and maximum flowrate"
    annotation (Placement(transformation(extent={{92,-100},{112,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Pass minimum flow setpoint based on whether the plant is being staged-up or staged-down"
    annotation (Placement(transformation(extent={{290,-80},{310,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical And"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Set minimum flow setpoint as per 5.3.8.2 if uOnOff=True, else as per 5.3.8.1"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Set minimum flow setpoint as per 5.3.8.2 if uOnOff=True, else as per 5.3.8.1"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Pass minimum flow setpoint based on whether stage-down involves a boiler being enabled"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{-130,-330},{-110,-310}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt1
    "Previous stage during stage change"
    annotation (Placement(transformation(extent={{-90,-310},{-70,-290}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig4(
    final nin=nSta)
    "Extract flow ratio of previous setpoint during stage-down"
    annotation (Placement(transformation(extent={{60,-280},{80,-260}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Max flowrate as per 5.3.8.2"
    annotation (Placement(transformation(extent={{100,-260},{120,-240}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig5(
    final nin=nBoi)
    "Extract max flowrate of boiler being disabled during stage-down"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Max flowrate as per 5.3.8.2"
    annotation (Placement(transformation(extent={{100,-310},{120,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro4
    "Product of flowrate ratio and maximum flowrate"
    annotation (Placement(transformation(extent={{140,-280},{160,-260}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat3
    "Turn on timer for slow change of setpoint"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Change setpoint over a finite amnount of time during stage change"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Change setpoint over a finite amnount of time during stage change"
    annotation (Placement(transformation(extent={{260,-150},{280,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con4(
    final k=0)
    "Constant Real source"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=0)
    "Timer for change of setpoint"
    annotation (Placement(transformation(extent={{228,-50},{248,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{228,-120},{248,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Detect start of change in minimum flow setpoint"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Pass new minimum flow setpoint based on whether the plant is being staged-up or staged-down"
    annotation (Placement(transformation(extent={{190,-210},{210,-190}})));

equation
  connect(uStaSet, cha.u)
    annotation (Line(points={{-160,-90},{-128,-90},{-128,-70},{-122,-70}},
                                                     color={255,127,0}));

  connect(lat.u, and2.y)
    annotation (Line(points={{-42,-30},{-58,-30}},
                                               color={255,0,255}));

  connect(uOnOff, and2.u1)
    annotation (Line(points={{-160,-10},{-124,-10},{-124,-30},{-82,-30}},
                                                color={255,0,255}));

  connect(cha.up, and2.u2) annotation (Line(points={{-98,-64},{-90,-64},{-90,-38},
          {-82,-38}},color={255,0,255}));

  connect(uStaChaPro, lat.clr) annotation (Line(points={{-160,-50},{-50,-50},{-50,
          -36},{-42,-36}},
                         color={255,0,255}));

  connect(con.y, pro.u1) annotation (Line(points={{-98,-140},{-90,-140},{-90,-134},
          {-82,-134}},color={0,0,127}));

  connect(con2.y, pro.u2) annotation (Line(points={{-98,-220},{-90,-220},{-90,-146},
          {-82,-146}},
                     color={0,0,127}));

  connect(con1.y, pro1.u1) annotation (Line(points={{-98,-180},{-92,-180},{-92,-174},
          {-82,-174}},
                    color={0,0,127}));

  connect(con2.y, pro1.u2) annotation (Line(points={{-98,-220},{-90,-220},{-90,-186},
          {-82,-186}},
                    color={0,0,127}));

  connect(pro.y, div.u1)
    annotation (Line(points={{-58,-140},{-40,-140},{-40,-144},{-22,-144}},
                                                   color={0,0,127}));

  connect(pro1.y, addPar.u)
    annotation (Line(points={{-58,-180},{-52,-180}},
                                                 color={0,0,127}));

  connect(addPar.y, div.u2) annotation (Line(points={{-28,-180},{-24,-180},{-24,
          -156},{-22,-156}},
                      color={0,0,127}));

  connect(con3.y, matGai.u)
    annotation (Line(points={{-58,-220},{-42,-220}},
                                                 color={0,0,127}));

  connect(div.y, matMax.u)
    annotation (Line(points={{2,-150},{18,-150}},
                                                color={0,0,127}));

  connect(matMax.y, extIndSig.u)
    annotation (Line(points={{42,-150},{52,-150},{52,-50},{58,-50}},
                                                 color={0,0,127}));

  connect(uStaSet, extIndSig.index) annotation (Line(points={{-160,-90},{70,-90},
          {70,-62}},                     color={255,127,0}));

  connect(matMax.y, extIndSig1.u) annotation (Line(points={{42,-150},{52,-150},
          {52,80},{58,80}},
                        color={0,0,127}));

  connect(conInt.y,subInt. u2) annotation (Line(points={{-98,70},{-72,70},{-72,
          74},{-62,74}},
                   color={255,127,0}));

  connect(uStaSet,subInt. u1) annotation (Line(points={{-160,-90},{-128,-90},{
          -128,100},{-72,100},{-72,86},{-62,86}},
                                               color={255,127,0}));

  connect(subInt.y, extIndSig1.index) annotation (Line(points={{-38,80},{40,80},
          {40,60},{70,60},{70,68}},color={255,127,0}));

  connect(matGai.y, extIndSig2.u)
    annotation (Line(points={{-18,-220},{-2,-220}},
                                                color={0,0,127}));

  connect(uStaSet, extIndSig2.index) annotation (Line(points={{-160,-90},{-128,-90},
          {-128,-240},{10,-240},{10,-232}}, color={255,127,0}));

  connect(con3.y, extIndSig3.u) annotation (Line(points={{-58,-220},{-54,-220},{
          -54,50},{-22,50}}, color={0,0,127}));

  connect(max.y, pro2.u1) annotation (Line(points={{122,100},{130,100},{130,76},
          {138,76}}, color={0,0,127}));

  connect(add2.y, pro2.u2) annotation (Line(points={{82,40},{130,40},{130,64},{138,
          64}}, color={0,0,127}));

  connect(pro3.y, swi.u3) annotation (Line(points={{114,-90},{120,-90},{120,2},{
          138,2}}, color={0,0,127}));

  connect(pro2.y, swi.u1) annotation (Line(points={{162,70},{170,70},{170,30},{130,
          30},{130,18},{138,18}}, color={0,0,127}));

  connect(extIndSig.y, pro3.u1) annotation (Line(points={{82,-50},{88,-50},{88,-84},
          {90,-84}}, color={0,0,127}));

  connect(extIndSig2.y, pro3.u2) annotation (Line(points={{22,-220},{46,-220},{46,
          -96},{90,-96}}, color={0,0,127}));

  connect(lat.y, swi.u2) annotation (Line(points={{-18,-30},{126,-30},{126,10},{
          138,10}}, color={255,0,255}));

  connect(swi1.y, VHotWatMinSet_flow)
    annotation (Line(points={{312,-70},{340,-70}}, color={0,0,127}));

  connect(cha.down, and1.u1) annotation (Line(points={{-98,-76},{-90,-76},{-90,-110},
          {-82,-110}}, color={255,0,255}));

  connect(and1.y, lat1.u)
    annotation (Line(points={{-58,-110},{-42,-110}}, color={255,0,255}));

  connect(uStaChaPro, lat1.clr) annotation (Line(points={{-160,-50},{-50,-50},{-50,
          -116},{-42,-116}}, color={255,0,255}));

  connect(cha.up, lat2.u) annotation (Line(points={{-98,-64},{-90,-64},{-90,-70},
          {-82,-70}}, color={255,0,255}));

  connect(cha.down, lat2.clr)
    annotation (Line(points={{-98,-76},{-82,-76}}, color={255,0,255}));

  connect(lat2.y, swi1.u2)
    annotation (Line(points={{-58,-70},{288,-70}}, color={255,0,255}));

  connect(lat1.y, swi2.u2) annotation (Line(points={{-18,-110},{126,-110},{126,-150},
          {138,-150}}, color={255,0,255}));

  connect(uOnOff, and1.u2) annotation (Line(points={{-160,-10},{-124,-10},{-124,
          -118},{-82,-118}}, color={255,0,255}));

  connect(pro3.y, swi2.u3) annotation (Line(points={{114,-90},{120,-90},{120,-158},
          {138,-158}}, color={0,0,127}));

  connect(extIndSig3.y, add2.u1) annotation (Line(points={{2,50},{40,50},{40,46},
          {58,46}}, color={0,0,127}));

  connect(extIndSig2.y, add2.u2) annotation (Line(points={{22,-220},{46,-220},{46,
          34},{58,34}}, color={0,0,127}));

  connect(uLasDisBoi, extIndSig3.index)
    annotation (Line(points={{-160,30},{-10,30},{-10,38}}, color={255,127,0}));

  connect(extIndSig.y, max.u2) annotation (Line(points={{82,-50},{88,-50},{88,94},
          {98,94}}, color={0,0,127}));

  connect(extIndSig1.y, max.u1) annotation (Line(points={{82,80},{84,80},{84,106},
          {98,106}}, color={0,0,127}));

  connect(conInt1.y, addInt1.u2) annotation (Line(points={{-108,-320},{-100,-320},
          {-100,-306},{-92,-306}}, color={255,127,0}));

  connect(uStaSet, addInt1.u1) annotation (Line(points={{-160,-90},{-128,-90},{-128,
          -294},{-92,-294}}, color={255,127,0}));

  connect(matMax.y, extIndSig4.u) annotation (Line(points={{42,-150},{52,-150},{
          52,-270},{58,-270}}, color={0,0,127}));

  connect(addInt1.y, extIndSig4.index) annotation (Line(points={{-68,-300},{70,-300},
          {70,-282}}, color={255,127,0}));

  connect(extIndSig4.y, max1.u2) annotation (Line(points={{82,-270},{88,-270},{88,
          -256},{98,-256}}, color={0,0,127}));

  connect(extIndSig.y, max1.u1) annotation (Line(points={{82,-50},{88,-50},{88,-244},
          {98,-244}}, color={0,0,127}));

  connect(con3.y, extIndSig5.u) annotation (Line(points={{-58,-220},{-54,-220},{
          -54,-260},{-42,-260}}, color={0,0,127}));

  connect(extIndSig2.y, add1.u1) annotation (Line(points={{22,-220},{46,-220},{46,
          -294},{98,-294}}, color={0,0,127}));

  connect(extIndSig5.y, add1.u2) annotation (Line(points={{-18,-260},{0,-260},{0,
          -306},{98,-306}}, color={0,0,127}));

  connect(max1.y, pro4.u1) annotation (Line(points={{122,-250},{130,-250},{130,-264},
          {138,-264}}, color={0,0,127}));

  connect(add1.y, pro4.u2) annotation (Line(points={{122,-300},{130,-300},{130,-276},
          {138,-276}}, color={0,0,127}));

  connect(pro4.y, swi2.u1) annotation (Line(points={{162,-270},{166,-270},{166,-170},
          {132,-170},{132,-142},{138,-142}}, color={0,0,127}));

  connect(uLasDisBoi, extIndSig5.index) annotation (Line(points={{-160,30},{-134,
          30},{-134,-280},{-30,-280},{-30,-272}}, color={255,127,0}));

  connect(swi.y, lin.f2) annotation (Line(points={{162,10},{166,10},{166,-8},{258,
          -8}}, color={0,0,127}));
  connect(swi2.y, lin1.f2) annotation (Line(points={{162,-150},{254,-150},{254,-148},
          {258,-148}}, color={0,0,127}));
  connect(lat3.y, tim.u)
    annotation (Line(points={{222,-40},{226,-40}}, color={255,0,255}));
  connect(tim.y, lin.u) annotation (Line(points={{250,-40},{254,-40},{254,0},{258,
          0}}, color={0,0,127}));
  connect(tim.y, lin1.u) annotation (Line(points={{250,-40},{254,-40},{254,-140},
          {258,-140}}, color={0,0,127}));
  connect(lin1.y, swi1.u3) annotation (Line(points={{282,-140},{286,-140},{286,-78},
          {288,-78}}, color={0,0,127}));
  connect(lin.y, swi1.u1) annotation (Line(points={{282,0},{286,0},{286,-62},{288,
          -62}}, color={0,0,127}));
  connect(con4.y, lin.x1) annotation (Line(points={{182,110},{188,110},{188,8},{
          258,8}}, color={0,0,127}));
  connect(con4.y, lin1.x1) annotation (Line(points={{182,110},{188,110},{188,-132},
          {258,-132}}, color={0,0,127}));
  connect(pre1.y, lat3.clr) annotation (Line(points={{250,-110},{260,-110},{260,
          -60},{192,-60},{192,-46},{198,-46}}, color={255,0,255}));
  connect(uStaChaPro, or2.u2) annotation (Line(points={{-160,-50},{-50,-50},{-50,
          -8},{-42,-8}}, color={255,0,255}));
  connect(cha.y, or2.u1) annotation (Line(points={{-98,-70},{-94,-70},{-94,0},{-42,
          0}}, color={255,0,255}));
  connect(or2.y, lat3.u) annotation (Line(points={{-18,0},{100,0},{100,-20},{192,
          -20},{192,-40},{198,-40}}, color={255,0,255}));

  connect(swi.y, swi3.u1) annotation (Line(points={{162,10},{166,10},{166,-8},{180,
          -8},{180,-192},{188,-192}}, color={0,0,127}));
  connect(swi2.y, swi3.u3) annotation (Line(points={{162,-150},{172,-150},{172,-208},
          {188,-208}}, color={0,0,127}));
  connect(lat2.y, swi3.u2) annotation (Line(points={{-58,-70},{176,-70},{176,-200},
          {188,-200}}, color={255,0,255}));
  connect(pre1.u, gre.y)
    annotation (Line(points={{226,-110},{222,-110}}, color={255,0,255}));
  connect(tim.y, gre.u1) annotation (Line(points={{250,-40},{254,-40},{254,-88},
          {192,-88},{192,-110},{198,-110}}, color={0,0,127}));
  connect(addPar1.y, abs.u)
    annotation (Line(points={{272,-250},{278,-250}}, color={0,0,127}));
  connect(abs.y, lin1.x2) annotation (Line(points={{302,-250},{310,-250},{310,-180},
          {184,-180},{184,-144},{258,-144}},       color={0,0,127}));
  connect(abs.y, gre.u2) annotation (Line(points={{302,-250},{310,-250},{310,-180},
          {184,-180},{184,-118},{198,-118}},       color={0,0,127}));
  connect(abs.y, lin.x2) annotation (Line(points={{302,-250},{310,-250},{310,-180},
          {184,-180},{184,-4},{258,-4}},       color={0,0,127}));

  connect(sub3.y, gai.u) annotation (Line(points={{252,-200},{260,-200},{260,-230},
          {200,-230},{200,-250},{208,-250}}, color={0,0,127}));
  connect(gai.y, addPar1.u)
    annotation (Line(points={{232,-250},{248,-250}}, color={0,0,127}));
  connect(swi3.y, sub3.u1) annotation (Line(points={{212,-200},{224,-200},{224,-194},
          {228,-194}}, color={0,0,127}));
  connect(con4.y, intWitRes.u) annotation (Line(points={{182,110},{188,110},{188,
          -80},{132,-80},{132,-100},{138,-100}}, color={0,0,127}));
  connect(swi1.y, intWitRes.y_reset_in) annotation (Line(points={{312,-70},{316,
          -70},{316,-164},{128,-164},{128,-108},{138,-108}}, color={0,0,127}));
  connect(gre.y, intWitRes.trigger) annotation (Line(points={{222,-110},{224,-110},
          {224,-124},{150,-124},{150,-112}}, color={255,0,255}));
  connect(intWitRes.y, lin.f1) annotation (Line(points={{162,-100},{172,-100},{172,
          4},{258,4}}, color={0,0,127}));
  connect(intWitRes.y, lin1.f1) annotation (Line(points={{162,-100},{172,-100},{
          172,-136},{258,-136}}, color={0,0,127}));
  connect(intWitRes.y, sub3.u2) annotation (Line(points={{162,-100},{172,-100},{
          172,-136},{220,-136},{220,-206},{228,-206}}, color={0,0,127}));
annotation (
  defaultComponentName="minBoiFloSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-36,42},{0,28}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,28},{0,14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,14},{0,0}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,0},{0,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,-14},{0,-28}}, lineColor={28,108,200}),
        Text(
          extent={{-32,38},{-12,32}},
          textColor={28,108,200},
          textString="Stage #"),
        Text(
          extent={{-30,24},{-10,18}},
          textColor={28,108,200},
          textString="0"),
        Text(
          extent={{-30,10},{-10,4}},
          textColor={28,108,200},
          textString="1"),
        Text(
          extent={{-30,-4},{-10,-10}},
          textColor={28,108,200},
          textString="2"),
        Rectangle(extent={{-36,-28},{0,-42}}, lineColor={28,108,200}),
        Text(
          extent={{-30,-18},{-10,-24}},
          textColor={28,108,200},
          textString="..."),
        Text(
          extent={{-30,-32},{-10,-38}},
          textColor={28,108,200},
          textString="n"),
        Rectangle(extent={{2,42},{38,28}}, lineColor={28,108,200}),
        Rectangle(extent={{2,28},{38,14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,14},{38,0}}, lineColor={28,108,200}),
        Rectangle(extent={{2,0},{38,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,-14},{38,-28}}, lineColor={28,108,200}),
        Text(
          extent={{8,38},{34,32}},
          textColor={28,108,200},
          textString="Min flow"),
        Text(
          extent={{6,24},{34,18}},
          textColor={28,108,200},
          textString="minFloSet[1]"),
        Rectangle(extent={{2,-28},{38,-42}}, lineColor={28,108,200}),
        Text(
          extent={{8,-18},{28,-24}},
          textColor={28,108,200},
          textString="..."),
        Text(
          extent={{6,10},{34,4}},
          textColor={28,108,200},
          textString="minFloSet[2]"),
        Text(
          extent={{6,-32},{34,-38}},
          textColor={28,108,200},
          textString="minFloSet[n]"),
        Text(
          extent={{6,-4},{34,-10}},
          textColor={28,108,200},
          textString="minFloSet[3]")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-340},{320,140}})),
  Documentation(info="<html>
<p>
Block that outputs hot water minimum flow setpoint for primary-only plants with
a minimum flow bypass valve, according to ASHRAE RP-1711, March, 2020 draft,
sections 5.3.8.1 and 5.3.8.2.
</p>
<ol>
<li>
For plants with parallel boilers, bypass valve shall modulate to maintain minimum
flow as measured by the hot water flow meter at a setpoint <code>VHotWatMinSet_flow</code>
that ensures minimum flow through all operating boilers, as follows:
<ul>
<li>
For the operating boilers in current stage, identify the boiler with the
highest ratio of design minimum flowrate <code>minFloSet</code> to design maximum
flowrate <code>maxFloSet</code>.
</li>
<li>
Calculate <code>VHotWatMinSet_flow</code> as the highest ratio multiplied by the sum
of <code>maxFloSet</code> for the operating boilers.
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Boiler </th>
<th> Minimum flow </th>
<th> Maximum flow </th>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
<td align=\"center\"><code>maxFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
<td align=\"center\"><code>maxFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>
</li>
<li>
If there is any stage change requiring a boiler on and another boiler off,
<code>VHotWatMinSet_flow</code> shall temporarily change to account for the
<code>minFloSet</code> of both the boiler to be enabled and to be disabled
prior to starting the newly enabled boiler.
</li>
</ol>
<p>
Note that when there is a stage change requiring a change in <code>VHotWatMinSet_flow</code>, 
the change should be slowly made at a rate <code>bypSetRat</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 09, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end MinimumFlowSetPoint;
