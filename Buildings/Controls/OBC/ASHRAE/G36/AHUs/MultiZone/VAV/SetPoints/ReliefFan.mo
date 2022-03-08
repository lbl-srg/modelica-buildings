within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReliefFan "Sequence for relief fan control for AHUs using actuated relief dampers with relief fan(s)"

  parameter Integer nSupFan = 2
    "Total number of AHU supply fans that are serving the same common space";
  parameter Integer nRelFan = 4
    "Total number of relief fans that are serving the same common space";
  parameter Real minSpe(
    final min=0,
    final max=1)= 0.1
    "Relief fan minimum speed";
  parameter Integer staVec[nRelFan] = {2,3,1,4}
    "Vector of the order for staging up relief fan, i.e. the 1st element means the 1st relief fan and its value showing its sequence when staging up";
  parameter Integer RelFanMat[nRelFan, nSupFan] = {{1,0},{1,0},{0,1},{0,1}}
    "Relief fan matrix with relief fan as row index and AHU supply fan as column index. It falgs which relief fan is associated with which supply fan";
  parameter Real dpBuiSet(
    final unit="Pa",
    final quantity="PressureDifference",
    final max=30) = 12
    "Building static pressure difference relative to ambient (positive to pressurize the building)";
  parameter Real k(
    final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(group="Pressure controller"));
  parameter Real hys = 0.005
    "Hysteresis for checking the controller output value"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan[nSupFan]
    "AHU supply fan proven on status"
    annotation (Placement(transformation(extent={{-520,310},{-480,350}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-520,210},{-480,250}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uRelFanAla[nRelFan]
    "Relief fan current alarm index"
    annotation (Placement(transformation(extent={{-520,30},{-480,70}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRelFan[nRelFan]
    "Relief fan proven on status"
    annotation (Placement(transformation(extent={{-520,-210},{-480,-170}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{540,300},{580,340}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe[nRelFan](
    final unit=fill("1", nRelFan),
    final max=fill(1,nRelFan)) "Relief fan speed setpoint"
    annotation (Placement(transformation(extent={{540,190},{580,230}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam[nRelFan](
    final unit=fill("1",nRelFan),
    final min=fill(0,nRelFan),
    final max=fill(1,nRelFan)) "Damper position setpoint"
    annotation (Placement(transformation(extent={{540,40},{580,80}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain enaRel(
    final K=RelFanMat)
    "Vector of relief fans with the enabled one denoted by 1"
    annotation (Placement(transformation(extent={{-420,320},{-400,340}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nSupFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-460,320},{-440,340}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai[nRelFan](
    final k=staVec)
    "Vector of enabling fan, along with its staging order"
    annotation (Placement(transformation(extent={{-380,320},{-360,340}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movMea(
    final delta=300)
    "Average building static pressure measurement"
    annotation (Placement(transformation(extent={{-460,220},{-440,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Normalized the control error"
    annotation (Placement(transformation(extent={{-360,180},{-340,200}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k,
    final reverseActing=false)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{-340,250},{-320,270}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr enaRelGro(
    final nin=nSupFan)
    "Relief group enabling status"
    annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-420,280},{-400,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro
    "Set controller output to zero when the relief system is disabled"
    annotation (Placement(transformation(extent={{180,274},{200,294}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.05,
    final h=hys)
    "Check if the controller output is greater than threshold"
    annotation (Placement(transformation(extent={{-280,140},{-260,160}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the controller output is greater than threshold and the relief system has been enabled"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Enable damper"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=0.005,
    final h=hys)
    "Check if the controller output is near zero"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check if the controller output has been near zero for threshold time"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nRelFan)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if a relief fan should be enabled"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDam[nRelFan]
    "Enable damper"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=minSpe + 0.15,
    final h=hys)
    "Check if the controller output is greater than minimum speed plus threshold"
    annotation (Placement(transformation(extent={{-280,-130},{-260,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer upTim(
    final t=420)
    "Check if the controller output has been greater than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre(
    final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-420,-36},{-400,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2[nRelFan]
    "Identify relief fans that have been enabled but not yet operating"
    annotation (Placement(transformation(extent={{-360,-30},{-340,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[nRelFan]
    "List of standby fans, along with their staging order"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nRelFan)
    "Identify current order of staging"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr1[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the input is less than threshold"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[nRelFan](
    final p=fill(nRelFan + 1, nRelFan))
    "Add value to the input"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1[nRelFan]
    "Find absolute value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nRelFan]
    "Targeted vector of operating relief fan after one new fan being turned on"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stage up next relief fan"
    annotation (Placement(transformation(extent={{280,-100},{300,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr3(
    final t=minSpe,
    final h=hys)
    "Check if the controller output is less than minimum speed"
    annotation (Placement(transformation(extent={{-280,-350},{-260,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Timer dowTim(
    final t=300)
    "Check if the controller output has been less than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-180,-350},{-160,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1(
    final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{40,-358},{60,-338}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro2[nRelFan]
    "List of operating fans, along with their staging order"
    annotation (Placement(transformation(extent={{-280,-240},{-260,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1[nRelFan](
    final p=fill(nRelFan + 1, nRelFan))
    "Add value to the input"
    annotation (Placement(transformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr4[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the input is less than threshold"
    annotation (Placement(transformation(extent={{-220,-270},{-200,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-180,-270},{-160,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin1(
    final nin=nRelFan)
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{0,-240},{20,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2[nRelFan]
    "Find absolute value"
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr5[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next fan to be off"
    annotation (Placement(transformation(extent={{80,-240},{100,-220}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nRelFan]
    "Vector of relief fan after one fan being turned off"
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{160,-278},{180,-258}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nRelFan]
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nRelFan)
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{240,-50},{260,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nRelFan]
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{200,-270},{220,-250}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nin=nRelFan)
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{240,-270},{260,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stage down lag fan"
    annotation (Placement(transformation(extent={{280,-310},{300,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{400,-100},{420,-80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{320,-100},{340,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nRelFan]
    "Vector of relief fan status after staging down"
    annotation (Placement(transformation(extent={{360,-310},{380,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{320,-310},{340,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{440,-100},{460,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=1,
    final uMin=minSpe)
    "Limit the controller output"
    annotation (Placement(transformation(extent={{120,250},{140,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep2(
    final nout=nRelFan)
    "Replicate real input"
    annotation (Placement(transformation(extent={{440,206},{460,226}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro3[nRelFan]
    "Relief fan speed"
    annotation (Placement(transformation(extent={{500,200},{520,220}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1 "Check if it is staging process"
    annotation (Placement(transformation(extent={{340,110},{360,130}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{380,110},{400,130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{440,110},{460,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-420,150},{-400,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-380,250},{-360,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Zero fan speed when it is in stage 0"
    annotation (Placement(transformation(extent={{220,180},{240,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch input values"
    annotation (Placement(transformation(extent={{400,206},{420,226}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=nRelFan)
    "Check if there is any relief fan enabled, but may not be running"
    annotation (Placement(transformation(extent={{120,206},{140,226}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{500,110},{520,130}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-220,-350},{-200,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,-358},{20,-338}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nRelFan]
    "Check if the relief fan is in level 2 alarm"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nRelFan](
    final k=fill(2, nRelFan))
    "Constant"
    annotation (Placement(transformation(extent={{-420,10},{-400,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nRelFan] "Logical not"
    annotation (Placement(transformation(extent={{-420,-90},{-400,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nRelFan]
    "Check if the relief fan is in level 2 alarm and it is proven off"
    annotation (Placement(transformation(extent={{-280,40},{-260,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5[nRelFan](
    final realTrue=fill(0, nRelFan),
    final realFalse=fill(1, nRelFan))
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nRelFan]
    "Product of inputs"
    annotation (Placement(transformation(extent={{500,50},{520,70}})));

  CDL.Continuous.GreaterThreshold                     greThr3[nRelFan](final t=
        fill(0.5, nRelFan)) "Check if the relief fan is enabled"
    annotation (Placement(transformation(extent={{0,206},{20,226}})));
  CDL.Logical.MultiAnd                        mulAnd1(nin=nRelFan)
    "Check if all the fans are not proven on"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));
  CDL.Continuous.Switch                        swi3
                                                  [nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  CDL.Routing.BooleanScalarReplicator                        booRep4(final nout
      =nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-240,-90},{-220,-70}})));
  CDL.Logical.And                        and5
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{340,-210},{360,-190}})));
  CDL.Logical.Not not4 "Not all the fans are proven off"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  CDL.Logical.Switch                        logSwi3[nRelFan]
    "Vector of relief fan status after staging down"
    annotation (Placement(transformation(extent={{400,-190},{420,-170}})));
  CDL.Logical.TrueDelay truDel[nRelFan](delayTime=fill(2, nRelFan))
    "Delay true input"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
equation
  connect(uSupFan, booToRea.u)
    annotation (Line(points={{-500,330},{-462,330}}, color={255,0,255}));
  connect(enaRel.u, booToRea.y)
    annotation (Line(points={{-422,330},{-438,330}}, color={0,0,127}));
  connect(enaRel.y, gai.u)
    annotation (Line(points={{-398,330},{-382,330}}, color={0,0,127}));
  connect(dpBui, movMea.u)
    annotation (Line(points={{-500,230},{-462,230}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-358,260},{-342,260}}, color={0,0,127}));
  connect(movMea.y, div1.u1) annotation (Line(points={{-438,230},{-380,230},{-380,
          196},{-362,196}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, div1.u2) annotation (Line(points={{-398,160},{-380,160},
          {-380,184},{-362,184}}, color={0,0,127}));
  connect(div1.y, conP.u_m) annotation (Line(points={{-338,190},{-330,190},{-330,
          248}}, color={0,0,127}));
  connect(uSupFan, enaRelGro.u) annotation (Line(points={{-500,330},{-470,330},{
          -470,290},{-462,290}}, color={255,0,255}));
  connect(booToRea1.y, pro.u1) annotation (Line(points={{-398,290},{178,290}},
                           color={0,0,127}));
  connect(enaRelGro.y, booToRea1.u)
    annotation (Line(points={{-438,290},{-422,290}}, color={255,0,255}));
  connect(conP.y, greThr.u) annotation (Line(points={{-318,260},{-300,260},{-300,
          150},{-282,150}}, color={0,0,127}));
  connect(enaRelGro.y, and2.u2) annotation (Line(points={{-438,290},{-430,290},{
          -430,122},{-222,122}}, color={255,0,255}));
  connect(greThr.y, and2.u1) annotation (Line(points={{-258,150},{-240,150},{-240,
          130},{-222,130}}, color={255,0,255}));
  connect(and2.y, lat.u)
    annotation (Line(points={{-198,130},{-182,130}}, color={255,0,255}));
  connect(conP.y, lesThr.u) annotation (Line(points={{-318,260},{-300,260},{-300,
          90},{-282,90}}, color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-258,90},{-222,90}},color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{-198,82},{-190,82},{-190,
          124},{-182,124}}, color={255,0,255}));
  connect(lat.y, booRep.u)
    annotation (Line(points={{-158,130},{-122,130}}, color={255,0,255}));
  connect(gai.y, greThr1.u) annotation (Line(points={{-358,330},{-140,330},{
          -140,160},{-122,160}},
                            color={0,0,127}));
  connect(greThr1.y, enaDam.u1)
    annotation (Line(points={{-98,160},{-42,160}},   color={255,0,255}));
  connect(booRep.y, enaDam.u2) annotation (Line(points={{-98,130},{-70,130},{
          -70,152},{-42,152}},
                           color={255,0,255}));
  connect(uRelFan, booToRea2.u) annotation (Line(points={{-500,-190},{-440,-190},
          {-440,-26},{-422,-26}}, color={255,0,255}));
  connect(enaRel.y, sub2.u1) annotation (Line(points={{-398,330},{-390,330},{-390,
          -14},{-362,-14}}, color={0,0,127}));
  connect(booToRea2.y, sub2.u2)
    annotation (Line(points={{-398,-26},{-362,-26}}, color={0,0,127}));
  connect(gai.y, pro1.u1) annotation (Line(points={{-358,330},{-310,330},{-310,6},
          {-282,6}},  color={0,0,127}));
  connect(sub2.y, pro1.u2) annotation (Line(points={{-338,-20},{-320,-20},{-320,
          -6},{-282,-6}}, color={0,0,127}));
  connect(mulMin.y, reaRep.u)
    annotation (Line(points={{-58,-80},{-42,-80}},   color={0,0,127}));
  connect(lesThr1.y, swi.u2)
    annotation (Line(points={{-198,-30},{-182,-30}}, color={255,0,255}));
  connect(pro1.y, swi.u3) annotation (Line(points={{-258,0},{-240,0},{-240,-50},
          {-190,-50},{-190,-38},{-182,-38}}, color={0,0,127}));
  connect(pro1.y, addPar.u)
    annotation (Line(points={{-258,0},{-222,0}},  color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{-198,0},{-190,0},{-190,-22},
          {-182,-22}}, color={0,0,127}));
  connect(gai.y, sub1.u1) annotation (Line(points={{-358,330},{-140,330},{-140,
          6},{-2,6}}, color={0,0,127}));
  connect(reaRep.y, sub1.u2) annotation (Line(points={{-18,-80},{-10,-80},{-10,
          -6},{-2,-6}},
                      color={0,0,127}));
  connect(sub1.y, abs1.u)
    annotation (Line(points={{22,0},{38,0}},   color={0,0,127}));
  connect(abs1.y, lesThr2.u)
    annotation (Line(points={{62,0},{78,0}}, color={0,0,127}));
  connect(lesThr2.y, or2.u1)
    annotation (Line(points={{102,0},{118,0}},
                                             color={255,0,255}));
  connect(booToRea2.y, pro2.u2) annotation (Line(points={{-398,-26},{-380,-26},
          {-380,-236},{-282,-236}},color={0,0,127}));
  connect(gai.y, pro2.u1) annotation (Line(points={{-358,330},{-310,330},{-310,
          -224},{-282,-224}},
                        color={0,0,127}));
  connect(pro2.y, addPar1.u)
    annotation (Line(points={{-258,-230},{-222,-230}}, color={0,0,127}));
  connect(pro2.y, lesThr4.u) annotation (Line(points={{-258,-230},{-240,-230},{
          -240,-260},{-222,-260}},
                              color={0,0,127}));
  connect(lesThr4.y, swi1.u2)
    annotation (Line(points={{-198,-260},{-182,-260}}, color={255,0,255}));
  connect(addPar1.y, swi1.u1) annotation (Line(points={{-198,-230},{-190,-230},
          {-190,-252},{-182,-252}},color={0,0,127}));
  connect(pro2.y, swi1.u3) annotation (Line(points={{-258,-230},{-240,-230},{
          -240,-280},{-190,-280},{-190,-268},{-182,-268}},
                                                      color={0,0,127}));
  connect(swi1.y, mulMin1.u)
    annotation (Line(points={{-158,-260},{-102,-260}}, color={0,0,127}));
  connect(mulMin1.y, reaRep1.u)
    annotation (Line(points={{-78,-260},{-42,-260}},   color={0,0,127}));
  connect(reaRep1.y, sub3.u2) annotation (Line(points={{-18,-260},{-10,-260},{
          -10,-236},{-2,-236}},
                             color={0,0,127}));
  connect(gai.y, sub3.u1) annotation (Line(points={{-358,330},{-140,330},{-140,
          -224},{-2,-224}},
                       color={0,0,127}));
  connect(sub3.y, abs2.u)
    annotation (Line(points={{22,-230},{38,-230}},   color={0,0,127}));
  connect(abs2.y, lesThr5.u)
    annotation (Line(points={{62,-230},{78,-230}},color={0,0,127}));
  connect(lesThr5.y, xor.u1)
    annotation (Line(points={{102,-230},{118,-230}},
                                                   color={255,0,255}));
  connect(xor.y, booToInt2.u) annotation (Line(points={{142,-230},{150,-230},{
          150,-268},{158,-268}},
                      color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{182,-40},{198,-40}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{182,-80},{190,-80},
          {190,-48},{198,-48}},color={255,127,0}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{222,-40},{238,-40}}, color={255,0,255}));
  connect(booToInt1.y, intEqu1.u1) annotation (Line(points={{182,-80},{190,-80},
          {190,-260},{198,-260}}, color={255,127,0}));
  connect(booToInt2.y, intEqu1.u2)
    annotation (Line(points={{182,-268},{198,-268}}, color={255,127,0}));
  connect(intEqu1.y, mulAnd2.u)
    annotation (Line(points={{222,-260},{238,-260}}, color={255,0,255}));
  connect(lat2.y, booRep1.u)
    annotation (Line(points={{302,-90},{318,-90}}, color={255,0,255}));
  connect(lat1.y, booRep2.u)
    annotation (Line(points={{302,-300},{318,-300}}, color={255,0,255}));
  connect(booRep2.y, logSwi1.u2)
    annotation (Line(points={{342,-300},{358,-300}}, color={255,0,255}));
  connect(mulAnd2.y, lat1.clr) annotation (Line(points={{262,-260},{270,-260},{
          270,-306},{278,-306}},
                             color={255,0,255}));
  connect(conP.y, lesThr3.u) annotation (Line(points={{-318,260},{-300,260},{
          -300,-340},{-282,-340}},
                              color={0,0,127}));
  connect(xor.y, logSwi1.u1) annotation (Line(points={{142,-230},{350,-230},{
          350,-292},{358,-292}},
                             color={255,0,255}));
  connect(conP.y, greThr2.u) annotation (Line(points={{-318,260},{-300,260},{
          -300,-120},{-282,-120}},
                            color={0,0,127}));
  connect(booRep1.y, logSwi.u2)
    annotation (Line(points={{342,-90},{398,-90}}, color={255,0,255}));
  connect(or2.y, logSwi.u1) annotation (Line(points={{142,0},{380,0},{380,-82},
          {398,-82}},
                 color={255,0,255}));
  connect(uRelFan, xor.u2) annotation (Line(points={{-500,-190},{110,-190},{110,
          -238},{118,-238}},
                      color={255,0,255}));
  connect(uRelFan, logSwi1.u3) annotation (Line(points={{-500,-190},{-440,-190},
          {-440,-320},{350,-320},{350,-308},{358,-308}}, color={255,0,255}));
  connect(uRelFan, booToInt1.u) annotation (Line(points={{-500,-190},{110,-190},
          {110,-80},{158,-80}},
                             color={255,0,255}));
  connect(uRelFan, or2.u2) annotation (Line(points={{-500,-190},{110,-190},{110,
          -8},{118,-8}},
                    color={255,0,255}));
  connect(logSwi.y, booToRea3.u)
    annotation (Line(points={{422,-90},{438,-90}}, color={255,0,255}));
  connect(conP.y, lim.u)
    annotation (Line(points={{-318,260},{118,260}},color={0,0,127}));
  connect(lim.y, pro.u2) annotation (Line(points={{142,260},{160,260},{160,278},
          {178,278}},color={0,0,127}));
  connect(booToRea3.y, pro3.u2) annotation (Line(points={{462,-90},{480,-90},{
          480,204},{498,204}},
                           color={0,0,127}));
  connect(lat2.y, or1.u1) annotation (Line(points={{302,-90},{308,-90},{308,120},
          {338,120}},color={255,0,255}));
  connect(or1.y, booRep3.u)
    annotation (Line(points={{362,120},{378,120}}, color={255,0,255}));
  connect(booRep3.y, logSwi2.u2)
    annotation (Line(points={{402,120},{438,120}}, color={255,0,255}));
  connect(pro3.y, yRelFanSpe)
    annotation (Line(points={{522,210},{560,210}}, color={0,0,127}));
  connect(reaRep2.y, pro3.u1)
    annotation (Line(points={{462,216},{498,216}}, color={0,0,127}));
  connect(con.y, swi2.u3) annotation (Line(points={{242,190},{360,190},{360,208},
          {398,208}}, color={0,0,127}));
  connect(mulOr.y, swi2.u2)
    annotation (Line(points={{142,216},{398,216}},color={255,0,255}));
  connect(movMea.y, yDpBui) annotation (Line(points={{-438,230},{-20,230},{-20,
          320},{560,320}},
                      color={0,0,127}));
  connect(logSwi2.y, booToRea4.u)
    annotation (Line(points={{462,120},{498,120}}, color={255,0,255}));
  connect(not1.y, pre.u)
    annotation (Line(points={{-58,-150},{-42,-150}}, color={255,0,255}));
  connect(and1.y, upTim.u)
    annotation (Line(points={{-198,-120},{-182,-120}},
                                                     color={255,0,255}));
  connect(greThr2.y, and1.u1)
    annotation (Line(points={{-258,-120},{-222,-120}},
                                                     color={255,0,255}));
  connect(not2.y, pre1.u)
    annotation (Line(points={{22,-348},{38,-348}},   color={255,0,255}));
  connect(lesThr3.y, and3.u1)
    annotation (Line(points={{-258,-340},{-222,-340}}, color={255,0,255}));
  connect(and3.y, dowTim.u)
    annotation (Line(points={{-198,-340},{-182,-340}}, color={255,0,255}));
  connect(uRelFanAla, intEqu2.u1)
    annotation (Line(points={{-500,50},{-362,50}}, color={255,127,0}));
  connect(conInt.y, intEqu2.u2) annotation (Line(points={{-398,20},{-380,20},{-380,
          42},{-362,42}}, color={255,127,0}));
  connect(uRelFan, not3.u) annotation (Line(points={{-500,-190},{-440,-190},{
          -440,-80},{-422,-80}},
                            color={255,0,255}));
  connect(intEqu2.y, and4.u1)
    annotation (Line(points={{-338,50},{-282,50}}, color={255,0,255}));
  connect(not3.y, and4.u2) annotation (Line(points={{-398,-80},{-330,-80},{-330,
          42},{-282,42}}, color={255,0,255}));
  connect(and4.y, booToRea5.u)
    annotation (Line(points={{-258,50},{-222,50}}, color={255,0,255}));
  connect(booToRea4.y, mul.u1) annotation (Line(points={{522,120},{530,120},{
          530,100},{460,100},{460,66},{498,66}},
                                             color={0,0,127}));
  connect(booToRea5.y, mul.u2) annotation (Line(points={{-198,50},{180,50},{180,
          54},{498,54}}, color={0,0,127}));
  connect(mul.y, yDam)
    annotation (Line(points={{522,60},{560,60}}, color={0,0,127}));

  connect(enaDam.y, logSwi2.u3) annotation (Line(points={{-18,160},{420,160},{
          420,112},{438,112}},
                           color={255,0,255}));
  connect(logSwi.y, logSwi2.u1) annotation (Line(points={{422,-90},{430,-90},{
          430,128},{438,128}},
                           color={255,0,255}));
  connect(upTim.passed, not1.u) annotation (Line(points={{-158,-128},{-120,-128},
          {-120,-150},{-82,-150}},color={255,0,255}));
  connect(upTim.passed, lat2.u) annotation (Line(points={{-158,-128},{260,-128},
          {260,-90},{278,-90}},
                           color={255,0,255}));
  connect(dowTim.passed, not2.u)
    annotation (Line(points={{-158,-348},{-2,-348}},  color={255,0,255}));
  connect(dowTim.passed, lat1.u) annotation (Line(points={{-158,-348},{-20,-348},
          {-20,-300},{278,-300}}, color={255,0,255}));
  connect(enaRel.y, greThr3.u) annotation (Line(points={{-398,330},{-390,330},{
          -390,216},{-2,216}},
                           color={0,0,127}));
  connect(greThr3.y, mulOr.u)
    annotation (Line(points={{22,216},{118,216}}, color={255,0,255}));
  connect(pro.y, swi2.u1) annotation (Line(points={{202,284},{360,284},{360,224},
          {398,224}}, color={0,0,127}));
  connect(swi2.y, reaRep2.u)
    annotation (Line(points={{422,216},{438,216}}, color={0,0,127}));
  connect(pro1.y, lesThr1.u) annotation (Line(points={{-258,0},{-240,0},{-240,-30},
          {-222,-30}}, color={0,0,127}));
  connect(not3.y, mulAnd1.u)
    annotation (Line(points={{-398,-80},{-282,-80}}, color={255,0,255}));
  connect(mulAnd1.y, booRep4.u)
    annotation (Line(points={{-258,-80},{-242,-80}}, color={255,0,255}));
  connect(booRep4.y, swi3.u2)
    annotation (Line(points={{-218,-80},{-122,-80}}, color={255,0,255}));
  connect(pro1.y, swi3.u1) annotation (Line(points={{-258,0},{-240,0},{-240,-50},
          {-190,-50},{-190,-72},{-122,-72}}, color={0,0,127}));
  connect(swi.y, swi3.u3) annotation (Line(points={{-158,-30},{-150,-30},{-150,
          -88},{-122,-88}}, color={0,0,127}));
  connect(swi3.y, mulMin.u)
    annotation (Line(points={{-98,-80},{-82,-80}}, color={0,0,127}));
  connect(pre1.y, and3.u2) annotation (Line(points={{62,-348},{80,-348},{80,
          -370},{-240,-370},{-240,-348},{-222,-348}}, color={255,0,255}));
  connect(lat1.y, and5.u2) annotation (Line(points={{302,-300},{312,-300},{312,
          -208},{338,-208}}, color={255,0,255}));
  connect(and5.y, or1.u2) annotation (Line(points={{362,-200},{370,-200},{370,
          100},{320,100},{320,112},{338,112}}, color={255,0,255}));
  connect(mulAnd1.y, not4.u) annotation (Line(points={{-258,-80},{-250,-80},{
          -250,-200},{158,-200}}, color={255,0,255}));
  connect(not4.y, and5.u1)
    annotation (Line(points={{182,-200},{338,-200}}, color={255,0,255}));
  connect(uRelFan, logSwi3.u1) annotation (Line(points={{-500,-190},{110,-190},
          {110,-172},{398,-172}}, color={255,0,255}));
  connect(booRep4.y, logSwi3.u2) annotation (Line(points={{-218,-80},{-190,-80},
          {-190,-180},{398,-180}}, color={255,0,255}));
  connect(logSwi1.y, logSwi3.u3) annotation (Line(points={{382,-300},{390,-300},
          {390,-188},{398,-188}}, color={255,0,255}));
  connect(logSwi3.y, logSwi.u3) annotation (Line(points={{422,-180},{430,-180},
          {430,-120},{380,-120},{380,-98},{398,-98}}, color={255,0,255}));
  connect(pre.y, and1.u2) annotation (Line(points={{-18,-150},{0,-150},{0,-170},
          {-240,-170},{-240,-128},{-222,-128}}, color={255,0,255}));
  connect(truDel.y, booToInt.u)
    annotation (Line(points={{142,-40},{158,-40}}, color={255,0,255}));
  connect(or2.y, truDel.u) annotation (Line(points={{142,0},{150,0},{150,-20},{
          100,-20},{100,-40},{118,-40}}, color={255,0,255}));
  connect(mulAnd.y, lat2.clr) annotation (Line(points={{262,-40},{270,-40},{270,
          -96},{278,-96}}, color={255,0,255}));
annotation (defaultComponentName="relFanCon",
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-54,72}},
          lineColor={255,0,255},
          textString="uSupFan"),
        Text(
          extent={{-96,-70},{-54,-90}},
          lineColor={255,0,255},
          textString="uRelFan"),
        Text(
          extent={{-98,42},{-56,22}},
          lineColor={0,0,127},
          textString="dpBui"),
        Text(
          extent={{60,70},{100,54}},
          lineColor={0,0,127},
          textString="yDpBui"),
        Text(
          extent={{40,12},{98,-8}},
          lineColor={0,0,127},
          textString="yRelFanSpe"),
        Text(
          extent={{60,-50},{100,-66}},
          lineColor={0,0,127},
          textString="yDam"),
        Text(
          extent={{-98,-20},{-46,-38}},
          lineColor={255,127,0},
          textString="uRelFanAla")}),
 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-480,-360},{480,360}}), graphics={
        Rectangle(
          extent={{-1072,-236},{-416,-412}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-1202,56},{-546,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-258,178},{178,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-92,-22},{84,-48}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-up: turning on a new relief fan"),
        Text(
          extent={{112,-354},{310,-382}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-down: turning off a lag relief fan"),
        Text(
          extent={{-84,108},{166,90}},
          lineColor={0,0,255},
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
(<code>uSupFan=true</code>), and shall be disabled otherwise.
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
Stage Up. When control loop is above minimum speed (<code>minSpe</code>) plus 15%, start
stage-up timer. Each time the timer reaches 7 minutes, start the next relief fan (and
open the associated damper) in the relief system group, per staging order, and reset
the timer to 0. The timer is reset to 0 and frozen if control loop is below minimum
speed plus 15%. Note, when staging from Stage 0 (no relief fans) to Stage 1 (one relief
fan), the discharge dampers of all nonoperating relief fans must be closed.
</li>
<li>
Stage Down. When PID loop is below minimum speed (<code>minSpe</code>), start stage-down
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
July 15, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefFan;
