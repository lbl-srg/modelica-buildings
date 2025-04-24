within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block ReliefFanGroup
  "Sequence for relief fans control for AHUs using actuated relief dampers with relief fan(s)"

  parameter Integer nSupFan = 2
    "Total number of AHU supply fans that are serving the same common space"
    annotation (__cdl(ValueInReference=false));
  parameter Integer nRelFan = 4
    "Total number of relief fans that are serving the same common space"
    annotation (__cdl(ValueInReference=false));
  parameter Real relFanSpe_min(
    final min=0,
    final max=1)= 0.1
    "Relief fan minimum speed"
    annotation (__cdl(ValueInReference=false));
  parameter Integer staVec[nRelFan] = {2,3,1,4}
    "Vector of the order for staging up relief fan, i.e. the 1st element means the 1st relief fan and its value showing its sequence when staging up"
    annotation (__cdl(ValueInReference=false));
  parameter Integer relFanMat[nRelFan, nSupFan] = {{1,0},{1,0},{0,1},{0,1}}
    "Relief fan matrix with relief fan as row index and AHU supply fan as column index. It flags which relief fan is associated with which supply fan"
    annotation (__cdl(ValueInReference=false));
  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    final max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (__cdl(ValueInReference=true));
  parameter Real k(
    final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (__cdl(ValueInReference=false), Dialog(group="Pressure controller"));
  parameter Real hys = 0.005
    "Hysteresis for checking the controller output value"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan[nSupFan]
    "AHU supply fan proven on status"
    annotation (Placement(transformation(extent={{-560,330},{-520,370}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-560,230},{-520,270}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uRelFanAla[nRelFan]
    "Relief fan current alarm index"
    annotation (Placement(transformation(extent={{-560,50},{-520,90}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan[nRelFan]
    "Relief fan proven on status"
    annotation (Placement(transformation(extent={{-560,-190},{-520,-150}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{500,320},{540,360}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan[nRelFan](
    final unit=fill("1", nRelFan),
    final max=fill(1, nRelFan))
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{500,210},{540,250}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam[nRelFan](
    final unit=fill("1",nRelFan),
    final min=fill(0,nRelFan),
    final max=fill(1,nRelFan)) "Relief damper commanded position"
    annotation (Placement(transformation(extent={{500,60},{540,100}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Reals.MatrixGain enaRel(
    final K=relFanMat)
    "Vector of relief fans with the enabled one denoted by 1"
    annotation (Placement(transformation(extent={{-460,340},{-440,360}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSupFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-500,340},{-480,360}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nRelFan](
    final k=staVec)
    "Vector of enabling fan, along with its staging order"
    annotation (Placement(transformation(extent={{-420,340},{-400,360}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movMea(
    final delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-500,240},{-480,260}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "Normalized the control error"
    annotation (Placement(transformation(extent={{-400,200},{-380,220}})));
  Buildings.Controls.OBC.CDL.Reals.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    final reverseActing=false)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{-380,270},{-360,290}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaRelGro(
    final nin=nSupFan)
    "Relief group enabling status"
    annotation (Placement(transformation(extent={{-500,300},{-480,320}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-460,300},{-440,320}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Set controller output to zero when the relief system is disabled"
    annotation (Placement(transformation(extent={{140,294},{160,314}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.05,
    final h=hys)
    "Check if the controller output is greater than threshold"
    annotation (Placement(transformation(extent={{-320,160},{-300,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the controller output is greater than threshold and the relief system has been enabled"
    annotation (Placement(transformation(extent={{-260,140},{-240,160}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Enable damper"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr(
    final t=0.005,
    final h=hys)
    "Check if the controller output is near zero"
    annotation (Placement(transformation(extent={{-320,100},{-300,120}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the controller output has been near zero for threshold time"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nRelFan)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if a relief fan should be enabled"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDam[nRelFan]
    "Enable damper"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=relFanSpe_min + 0.15,
    final h=hys)
    "Check if the controller output is greater than minimum speed plus threshold"
    annotation (Placement(transformation(extent={{-320,-110},{-300,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer upTim(
    final t=420)
    "Check if the controller output has been greater than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre(
    final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-460,-16},{-440,4}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2[nRelFan]
    "Identify relief fans that have been enabled but not yet operating"
    annotation (Placement(transformation(extent={{-400,-10},{-380,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[nRelFan]
    "List of standby fans, along with their staging order"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nRelFan)
    "Identify current order of staging"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr1[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the input is less than threshold"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar[nRelFan](
    final p=fill(nRelFan + 1, nRelFan))
    "Add value to the input"
    annotation (Placement(transformation(extent={{-260,10},{-240,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs1[nRelFan]
    "Find absolute value"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr2[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nRelFan]
    "Targeted vector of operating relief fan after one new fan being turned on"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stage up next relief fan"
    annotation (Placement(transformation(extent={{240,-80},{260,-60}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr3(
    final t=relFanSpe_min,
    final h=hys)
    "Check if the controller output is less than minimum speed"
    annotation (Placement(transformation(extent={{-320,-330},{-300,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Timer dowTim(
    final t=300)
    "Check if the controller output has been less than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-220,-330},{-200,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1(
    final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{0,-338},{20,-318}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2[nRelFan]
    "List of operating fans, along with their staging order"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1[nRelFan](
    final p=fill(nRelFan + 1, nRelFan))
    "Add value to the input"
    annotation (Placement(transformation(extent={{-260,-220},{-240,-200}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr4[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the input is less than threshold"
    annotation (Placement(transformation(extent={{-260,-250},{-240,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin1(
    final nin=nRelFan) "Minimum staging order of the running relief fans"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Abs abs2[nRelFan]
    "Find absolute value"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr5[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next fan to be off"
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-80,-250},{-60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nRelFan]
    "Vector of relief fan after one fan being turned off"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{120,-258},{140,-238}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nRelFan]
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nRelFan)
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{200,-30},{220,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nRelFan]
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{160,-250},{180,-230}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nin=nRelFan)
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{200,-250},{220,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stage down lag fan"
    annotation (Placement(transformation(extent={{240,-290},{260,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{360,-80},{380,-60}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{280,-80},{300,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nRelFan]
    "Vector of relief fan status after staging down"
    annotation (Placement(transformation(extent={{320,-290},{340,-270}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{280,-290},{300,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{400,-80},{420,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Limiter lim(
    final uMax=1,
    final uMin=relFanSpe_min)
    "Limit the controller output"
    annotation (Placement(transformation(extent={{80,270},{100,290}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep2(
    final nout=nRelFan)
    "Replicate real input"
    annotation (Placement(transformation(extent={{400,226},{420,246}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro3[nRelFan]
    "Relief fan speed"
    annotation (Placement(transformation(extent={{460,220},{480,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{400,130},{420,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-460,170},{-440,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-420,270},{-400,290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0)
    "Zero fan speed when it is in stage 0"
    annotation (Placement(transformation(extent={{180,200},{200,220}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Switch input values"
    annotation (Placement(transformation(extent={{360,226},{380,246}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=nRelFan)
    "Check if there is any relief fan enabled, but may not be running"
    annotation (Placement(transformation(extent={{80,226},{100,246}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{460,130},{480,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-260,-330},{-240,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,-338},{-20,-318}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nRelFan]
    "Check if the relief fan is in level 2 alarm"
    annotation (Placement(transformation(extent={{-400,60},{-380,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nRelFan](
    final k=fill(2, nRelFan))
    "Constant"
    annotation (Placement(transformation(extent={{-460,30},{-440,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nRelFan] "Logical not"
    annotation (Placement(transformation(extent={{-460,-70},{-440,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nRelFan]
    "Check if the relief fan is in level 2 alarm and it is proven off"
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5[nRelFan](
    final realTrue=fill(0, nRelFan),
    final realFalse=fill(1, nRelFan))
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul[nRelFan]
    "Product of inputs"
    annotation (Placement(transformation(extent={{460,70},{480,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the relief fan is enabled"
    annotation (Placement(transformation(extent={{-40,226},{-20,246}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd1(
    final nin=nRelFan) "Check if all the fans are proven off"
    annotation (Placement(transformation(extent={{-320,-70},{-300,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep4(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi3[nRelFan]
    "Vector of relief fan status after staging down"
    annotation (Placement(transformation(extent={{360,-170},{380,-150}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel[nRelFan](
    final delayTime=fill(2, nRelFan))
    "Delay true input"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nRelFan)
    "Check if there is any fan is proven on"
    annotation (Placement(transformation(extent={{300,130},{320,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep5(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{340,130},{360,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5[nRelFan] "Logical not"
    annotation (Placement(transformation(extent={{0,-258},{20,-238}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6[nRelFan] "Logical not"
    annotation (Placement(transformation(extent={{80,-258},{100,-238}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[nRelFan](
    final delayTime=fill(2, nRelFan))
    "Delay true input"
    annotation (Placement(transformation(extent={{40,-258},{60,-238}})));

equation
  connect(u1SupFan, booToRea.u)
    annotation (Line(points={{-540,350},{-502,350}}, color={255,0,255}));
  connect(enaRel.u, booToRea.y)
    annotation (Line(points={{-462,350},{-478,350}}, color={0,0,127}));
  connect(enaRel.y, gai.u)
    annotation (Line(points={{-438,350},{-422,350}}, color={0,0,127}));
  connect(dpBui, movMea.u)
    annotation (Line(points={{-540,250},{-502,250}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-398,280},{-382,280}}, color={0,0,127}));
  connect(movMea.y, div1.u1) annotation (Line(points={{-478,250},{-420,250},{-420,
          216},{-402,216}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, div1.u2) annotation (Line(points={{-438,180},{-420,180},
          {-420,204},{-402,204}}, color={0,0,127}));
  connect(div1.y, conP.u_m) annotation (Line(points={{-378,210},{-370,210},{-370,
          268}}, color={0,0,127}));
  connect(u1SupFan, enaRelGro.u) annotation (Line(points={{-540,350},{-510,350},
          {-510,310},{-502,310}}, color={255,0,255}));
  connect(booToRea1.y, pro.u1) annotation (Line(points={{-438,310},{138,310}},
                           color={0,0,127}));
  connect(enaRelGro.y, booToRea1.u)
    annotation (Line(points={{-478,310},{-462,310}}, color={255,0,255}));
  connect(conP.y, greThr.u) annotation (Line(points={{-358,280},{-340,280},{-340,
          170},{-322,170}}, color={0,0,127}));
  connect(enaRelGro.y, and2.u2) annotation (Line(points={{-478,310},{-470,310},{
          -470,142},{-262,142}}, color={255,0,255}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-298,170},{-280,170},{-280,
          150},{-262,150}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-238,150},{-222,150}}, color={255,0,255}));
  connect(conP.y, lesThr.u) annotation (Line(points={{-358,280},{-340,280},{-340,
          110},{-322,110}}, color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-298,110},{-262,110}}, color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{-238,102},{-230,102},{-230,
          144},{-222,144}}, color={255,0,255}));
  connect(lat.y, booRep.u)
    annotation (Line(points={{-198,150},{-162,150}}, color={255,0,255}));
  connect(gai.y, greThr1.u) annotation (Line(points={{-398,350},{-180,350},{-180,
          180},{-162,180}},      color={0,0,127}));
  connect(greThr1.y, enaDam.u1)
    annotation (Line(points={{-138,180},{-82,180}},  color={255,0,255}));
  connect(booRep.y, enaDam.u2) annotation (Line(points={{-138,150},{-110,150},{-110,
          172},{-82,172}},     color={255,0,255}));
  connect(u1RelFan, booToRea2.u) annotation (Line(points={{-540,-170},{-480,-170},
          {-480,-6},{-462,-6}}, color={255,0,255}));
  connect(enaRel.y, sub2.u1) annotation (Line(points={{-438,350},{-430,350},{-430,
          6},{-402,6}},     color={0,0,127}));
  connect(booToRea2.y, sub2.u2)
    annotation (Line(points={{-438,-6},{-402,-6}},   color={0,0,127}));
  connect(gai.y, pro1.u1) annotation (Line(points={{-398,350},{-350,350},{-350,26},
          {-322,26}}, color={0,0,127}));
  connect(sub2.y, pro1.u2) annotation (Line(points={{-378,0},{-360,0},{-360,14},
          {-322,14}},     color={0,0,127}));
  connect(mulMin.y, reaRep.u)
    annotation (Line(points={{-98,-60},{-82,-60}},   color={0,0,127}));
  connect(lesThr1.y, swi.u2)
    annotation (Line(points={{-238,-10},{-222,-10}}, color={255,0,255}));
  connect(pro1.y, swi.u3) annotation (Line(points={{-298,20},{-280,20},{-280,-30},
          {-230,-30},{-230,-18},{-222,-18}}, color={0,0,127}));
  connect(pro1.y, addPar.u)
    annotation (Line(points={{-298,20},{-262,20}},color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{-238,20},{-230,20},{-230,-2},
          {-222,-2}},  color={0,0,127}));
  connect(gai.y, sub1.u1) annotation (Line(points={{-398,350},{-180,350},{-180,26},
          {-42,26}},  color={0,0,127}));
  connect(reaRep.y, sub1.u2) annotation (Line(points={{-58,-60},{-50,-60},{-50,14},
          {-42,14}},    color={0,0,127}));
  connect(sub1.y, abs1.u)
    annotation (Line(points={{-18,20},{-2,20}},color={0,0,127}));
  connect(abs1.y, lesThr2.u)
    annotation (Line(points={{22,20},{38,20}}, color={0,0,127}));
  connect(lesThr2.y, or2.u1)
    annotation (Line(points={{62,20},{78,20}}, color={255,0,255}));
  connect(booToRea2.y, pro2.u2) annotation (Line(points={{-438,-6},{-420,-6},{-420,
          -216},{-322,-216}},      color={0,0,127}));
  connect(gai.y, pro2.u1) annotation (Line(points={{-398,350},{-350,350},{-350,-204},
          {-322,-204}}, color={0,0,127}));
  connect(pro2.y, addPar1.u)
    annotation (Line(points={{-298,-210},{-262,-210}}, color={0,0,127}));
  connect(pro2.y, lesThr4.u) annotation (Line(points={{-298,-210},{-280,-210},{-280,
          -240},{-262,-240}}, color={0,0,127}));
  connect(lesThr4.y, swi1.u2)
    annotation (Line(points={{-238,-240},{-222,-240}}, color={255,0,255}));
  connect(addPar1.y, swi1.u1) annotation (Line(points={{-238,-210},{-230,-210},{
          -230,-232},{-222,-232}}, color={0,0,127}));
  connect(pro2.y, swi1.u3) annotation (Line(points={{-298,-210},{-280,-210},{-280,
          -260},{-230,-260},{-230,-248},{-222,-248}}, color={0,0,127}));
  connect(swi1.y, mulMin1.u)
    annotation (Line(points={{-198,-240},{-142,-240}}, color={0,0,127}));
  connect(mulMin1.y, reaRep1.u)
    annotation (Line(points={{-118,-240},{-82,-240}},  color={0,0,127}));
  connect(reaRep1.y, sub3.u2) annotation (Line(points={{-58,-240},{-50,-240},{-50,
          -216},{-42,-216}}, color={0,0,127}));
  connect(gai.y, sub3.u1) annotation (Line(points={{-398,350},{-180,350},{-180,-204},
          {-42,-204}}, color={0,0,127}));
  connect(sub3.y, abs2.u)
    annotation (Line(points={{-18,-210},{-2,-210}},  color={0,0,127}));
  connect(abs2.y, lesThr5.u)
    annotation (Line(points={{22,-210},{38,-210}},color={0,0,127}));
  connect(lesThr5.y, xor.u1)
    annotation (Line(points={{62,-210},{78,-210}}, color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{142,-20},{158,-20}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{142,-60},{150,-60},{
          150,-28},{158,-28}}, color={255,127,0}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{182,-20},{198,-20}}, color={255,0,255}));
  connect(booToInt1.y, intEqu1.u1) annotation (Line(points={{142,-60},{150,-60},
          {150,-240},{158,-240}}, color={255,127,0}));
  connect(booToInt2.y, intEqu1.u2)
    annotation (Line(points={{142,-248},{158,-248}}, color={255,127,0}));
  connect(intEqu1.y, mulAnd2.u)
    annotation (Line(points={{182,-240},{198,-240}}, color={255,0,255}));
  connect(lat2.y, booRep1.u)
    annotation (Line(points={{262,-70},{278,-70}}, color={255,0,255}));
  connect(lat1.y, booRep2.u)
    annotation (Line(points={{262,-280},{278,-280}}, color={255,0,255}));
  connect(booRep2.y, logSwi1.u2)
    annotation (Line(points={{302,-280},{318,-280}}, color={255,0,255}));
  connect(mulAnd2.y, lat1.clr) annotation (Line(points={{222,-240},{230,-240},{230,
          -286},{238,-286}}, color={255,0,255}));
  connect(conP.y, lesThr3.u) annotation (Line(points={{-358,280},{-340,280},{-340,
          -320},{-322,-320}}, color={0,0,127}));
  connect(xor.y, logSwi1.u1) annotation (Line(points={{102,-210},{310,-210},{310,
          -272},{318,-272}}, color={255,0,255}));
  connect(conP.y, greThr2.u) annotation (Line(points={{-358,280},{-340,280},{-340,
          -100},{-322,-100}}, color={0,0,127}));
  connect(booRep1.y, logSwi.u2)
    annotation (Line(points={{302,-70},{358,-70}}, color={255,0,255}));
  connect(or2.y, logSwi.u1) annotation (Line(points={{102,20},{340,20},{340,-62},
          {358,-62}}, color={255,0,255}));
  connect(u1RelFan, xor.u2) annotation (Line(points={{-540,-170},{70,-170},{70,-218},
          {78,-218}}, color={255,0,255}));
  connect(u1RelFan, logSwi1.u3) annotation (Line(points={{-540,-170},{-480,-170},
          {-480,-300},{310,-300},{310,-288},{318,-288}}, color={255,0,255}));
  connect(u1RelFan, booToInt1.u) annotation (Line(points={{-540,-170},{70,-170},
          {70,-60},{118,-60}}, color={255,0,255}));
  connect(u1RelFan, or2.u2) annotation (Line(points={{-540,-170},{70,-170},{70,12},
          {78,12}}, color={255,0,255}));
  connect(logSwi.y, booToRea3.u)
    annotation (Line(points={{382,-70},{398,-70}}, color={255,0,255}));
  connect(conP.y, lim.u)
    annotation (Line(points={{-358,280},{78,280}}, color={0,0,127}));
  connect(lim.y, pro.u2) annotation (Line(points={{102,280},{120,280},{120,298},
          {138,298}},color={0,0,127}));
  connect(booToRea3.y, pro3.u2) annotation (Line(points={{422,-70},{440,-70},{440,
          224},{458,224}}, color={0,0,127}));
  connect(pro3.y, yRelFan)
    annotation (Line(points={{482,230},{520,230}}, color={0,0,127}));
  connect(reaRep2.y, pro3.u1)
    annotation (Line(points={{422,236},{458,236}}, color={0,0,127}));
  connect(con.y, swi2.u3) annotation (Line(points={{202,210},{320,210},{320,228},
          {358,228}}, color={0,0,127}));
  connect(mulOr.y, swi2.u2)
    annotation (Line(points={{102,236},{358,236}},color={255,0,255}));
  connect(movMea.y, yDpBui) annotation (Line(points={{-478,250},{-60,250},{-60,340},
          {520,340}}, color={0,0,127}));
  connect(logSwi2.y, booToRea4.u)
    annotation (Line(points={{422,140},{458,140}}, color={255,0,255}));
  connect(not1.y, pre.u)
    annotation (Line(points={{-98,-130},{-82,-130}}, color={255,0,255}));
  connect(and1.y, upTim.u)
    annotation (Line(points={{-238,-100},{-222,-100}}, color={255,0,255}));
  connect(greThr2.y, and1.u1)
    annotation (Line(points={{-298,-100},{-262,-100}}, color={255,0,255}));
  connect(not2.y, pre1.u)
    annotation (Line(points={{-18,-328},{-2,-328}},  color={255,0,255}));
  connect(lesThr3.y, and3.u1)
    annotation (Line(points={{-298,-320},{-262,-320}}, color={255,0,255}));
  connect(and3.y, dowTim.u)
    annotation (Line(points={{-238,-320},{-222,-320}}, color={255,0,255}));
  connect(uRelFanAla, intEqu2.u1)
    annotation (Line(points={{-540,70},{-402,70}}, color={255,127,0}));
  connect(conInt.y, intEqu2.u2) annotation (Line(points={{-438,40},{-420,40},{-420,
          62},{-402,62}}, color={255,127,0}));
  connect(u1RelFan, not3.u) annotation (Line(points={{-540,-170},{-480,-170},{-480,
          -60},{-462,-60}}, color={255,0,255}));
  connect(intEqu2.y, and4.u1)
    annotation (Line(points={{-378,70},{-322,70}}, color={255,0,255}));
  connect(not3.y, and4.u2) annotation (Line(points={{-438,-60},{-370,-60},{-370,
          62},{-322,62}}, color={255,0,255}));
  connect(and4.y, booToRea5.u)
    annotation (Line(points={{-298,70},{-262,70}}, color={255,0,255}));
  connect(booToRea4.y, mul.u1) annotation (Line(points={{482,140},{490,140},{490,
          120},{420,120},{420,86},{458,86}}, color={0,0,127}));
  connect(booToRea5.y, mul.u2) annotation (Line(points={{-238,70},{140,70},{140,
          74},{458,74}}, color={0,0,127}));
  connect(mul.y, yDam)
    annotation (Line(points={{482,80},{520,80}}, color={0,0,127}));
  connect(enaDam.y, logSwi2.u3) annotation (Line(points={{-58,180},{380,180},{380,
          132},{398,132}}, color={255,0,255}));
  connect(logSwi.y, logSwi2.u1) annotation (Line(points={{382,-70},{390,-70},{390,
          148},{398,148}}, color={255,0,255}));
  connect(upTim.passed, not1.u) annotation (Line(points={{-198,-108},{-160,-108},
          {-160,-130},{-122,-130}}, color={255,0,255}));
  connect(upTim.passed, lat2.u) annotation (Line(points={{-198,-108},{220,-108},
          {220,-70},{238,-70}}, color={255,0,255}));
  connect(dowTim.passed, not2.u)
    annotation (Line(points={{-198,-328},{-42,-328}}, color={255,0,255}));
  connect(dowTim.passed, lat1.u) annotation (Line(points={{-198,-328},{-60,-328},
          {-60,-280},{238,-280}}, color={255,0,255}));
  connect(enaRel.y, greThr3.u) annotation (Line(points={{-438,350},{-430,350},{-430,
          236},{-42,236}}, color={0,0,127}));
  connect(greThr3.y, mulOr.u)
    annotation (Line(points={{-18,236},{78,236}}, color={255,0,255}));
  connect(pro.y, swi2.u1) annotation (Line(points={{162,304},{320,304},{320,244},
          {358,244}}, color={0,0,127}));
  connect(swi2.y, reaRep2.u)
    annotation (Line(points={{382,236},{398,236}}, color={0,0,127}));
  connect(pro1.y, lesThr1.u) annotation (Line(points={{-298,20},{-280,20},{-280,
          -10},{-262,-10}}, color={0,0,127}));
  connect(not3.y, mulAnd1.u)
    annotation (Line(points={{-438,-60},{-322,-60}}, color={255,0,255}));
  connect(mulAnd1.y, booRep4.u)
    annotation (Line(points={{-298,-60},{-282,-60}}, color={255,0,255}));
  connect(booRep4.y, swi3.u2)
    annotation (Line(points={{-258,-60},{-162,-60}}, color={255,0,255}));
  connect(pro1.y, swi3.u1) annotation (Line(points={{-298,20},{-280,20},{-280,-30},
          {-230,-30},{-230,-52},{-162,-52}}, color={0,0,127}));
  connect(swi.y, swi3.u3) annotation (Line(points={{-198,-10},{-190,-10},{-190,-68},
          {-162,-68}},      color={0,0,127}));
  connect(swi3.y, mulMin.u)
    annotation (Line(points={{-138,-60},{-122,-60}}, color={0,0,127}));
  connect(pre1.y, and3.u2) annotation (Line(points={{22,-328},{40,-328},{40,-350},
          {-280,-350},{-280,-328},{-262,-328}},       color={255,0,255}));
  connect(u1RelFan, logSwi3.u1) annotation (Line(points={{-540,-170},{70,-170},{
          70,-152},{358,-152}}, color={255,0,255}));
  connect(booRep4.y, logSwi3.u2) annotation (Line(points={{-258,-60},{-230,-60},
          {-230,-160},{358,-160}}, color={255,0,255}));
  connect(logSwi1.y, logSwi3.u3) annotation (Line(points={{342,-280},{350,-280},
          {350,-168},{358,-168}}, color={255,0,255}));
  connect(logSwi3.y, logSwi.u3) annotation (Line(points={{382,-160},{390,-160},{
          390,-100},{340,-100},{340,-78},{358,-78}},  color={255,0,255}));
  connect(pre.y, and1.u2) annotation (Line(points={{-58,-130},{-40,-130},{-40,-150},
          {-280,-150},{-280,-108},{-262,-108}}, color={255,0,255}));
  connect(truDel.y, booToInt.u)
    annotation (Line(points={{102,-20},{118,-20}}, color={255,0,255}));
  connect(or2.y, truDel.u) annotation (Line(points={{102,20},{110,20},{110,0},{60,
          0},{60,-20},{78,-20}},         color={255,0,255}));
  connect(mulAnd.y, lat2.clr) annotation (Line(points={{222,-20},{230,-20},{230,
          -76},{238,-76}}, color={255,0,255}));
  connect(logSwi.y, mulOr1.u) annotation (Line(points={{382,-70},{390,-70},{390,
          100},{280,100},{280,140},{298,140}}, color={255,0,255}));
  connect(mulOr1.y, booRep5.u)
    annotation (Line(points={{322,140},{338,140}}, color={255,0,255}));
  connect(booRep5.y, logSwi2.u2)
    annotation (Line(points={{362,140},{398,140}}, color={255,0,255}));
  connect(not6.y, booToInt2.u)
    annotation (Line(points={{102,-248},{118,-248}}, color={255,0,255}));
  connect(truDel1.y, not6.u)
    annotation (Line(points={{62,-248},{78,-248}},   color={255,0,255}));
  connect(not5.y, truDel1.u)
    annotation (Line(points={{22,-248},{38,-248}}, color={255,0,255}));
  connect(xor.y, not5.u) annotation (Line(points={{102,-210},{110,-210},{110,-228},
          {-20,-228},{-20,-248},{-2,-248}}, color={255,0,255}));

annotation (defaultComponentName="relFanCon",
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-54,72}},
          textColor={255,0,255},
          textString="u1SupFan"),
        Text(
          extent={{-96,-70},{-54,-90}},
          textColor={255,0,255},
          textString="u1RelFan"),
        Text(
          extent={{-98,42},{-56,22}},
          textColor={0,0,127},
          textString="dpBui"),
        Text(
          extent={{60,70},{100,54}},
          textColor={0,0,127},
          textString="yDpBui"),
        Text(
          extent={{40,12},{98,-8}},
          textColor={0,0,127},
          textString="yRelFan"),
        Text(
          extent={{60,-50},{100,-66}},
          textColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-98,-20},{-46,-38}},
          textColor={255,127,0},
          textString="uRelFanAla")}),
 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-520,-380},{500,380}}), graphics={
        Rectangle(
          extent={{-318,-182},{338,-358}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,38},{338,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,198},{138,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{136,-112},{312,-138}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-up: turning on a new relief fan"),
        Text(
          extent={{132,-332},{330,-360}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-down: turning off a lag relief fan"),
        Text(
          extent={{-124,128},{126,110}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage 0: open all the damper, but not turn on any relief fan")}),
Documentation(info="<html>
<p>
Sequence for controlling relief fans and their dampers for AHUs using actuated
relief dampers with relief fan(s). It is developed based on Section 5.16.9 of ASHRAE
Guideline 36, May 2020.
</p>
<ol>
<li>
All operating relief fans that serve a common or shared air volume shall be grouped
and controlled as if they were one system, running at the same speed and using the same
control loop, even if they are associated with different AHUs.
</li>
<li>
A relief fan shall be enabled when its associated supply fan is proven ON
(<code>u1SupFan=true</code>), and shall be disabled otherwise.
</li>
<li>
Building static pressure (<code>dpBui</code>) shall be time averaged with a sliding
5-minute window and 15 second sampling rate (to dampen fluctuations). The average
value shall be that displayed and used for control.
</li>
<li>
A P-only control loop maintains the building pressure at a set point (<code>dpBuiSet</code>)
of 12 Pa (0.05 in. of water) with an output ranging from 0% to 100%. The loop is disabled
and output set to zero when all fans in the relief system group are disabled.
</li>
<li>
Fan speed signal to all operating fans in the relief system group shall be the same
and shall be equal to the PID signal but no less than the minimum speed. Except for
Stage 0, discharge dampers of all relief fans shall be open only when fan is commanded
ON.
<ol type=\"a\">
<li>
Stage 0 (barometric relief). When relief system is enabled, and the control loop
output is above 5%, open the motorized dampers to all relief fans serving the relief
system group that are enabled; close the dampers when the loop output drops to 0% for
5 minutes.
</li>
<li>
Stage Up. When control loop is above minimum speed (<code>relFanSpe_min</code>) plus 15%, start
stage-up timer. Each time the timer reaches 7 minutes, start the next relief fan (and
open the associated damper) in the relief system group, per staging order, and reset
the timer to 0. The timer is reset to 0 and frozen if control loop is below minimum
speed plus 15%. Note, when staging from Stage 0 (no relief fans) to Stage 1 (one relief
fan), the discharge dampers of all nonoperating relief fans must be closed.
</li>
<li>
Stage Down. When PID loop is below minimum speed (<code>relFanSpe_min</code>), start stage-down
timer. Each time the timer reaches 5 minutes, shut off lag fan per staging order and
reset the timer to 0. The timer is reset to 0 and frozen if PID loop rises above minimum
speed or all fans are OFF. If all fans are OFF, go to Stage 0 (all dampers open and all
fans OFF).
</li>
</ol>
</li>
<li>
For fans in a Level 2 alarm and status is OFF, discharge damper shall be closed when
is above Stage 0.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
March 5, 2024, by Michael Wetter:<br/>
Corrected wrong use of <code>displayUnit</code>.
</li>
<li>
July 15, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefFanGroup;
