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
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-520,210},{-480,250}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRelFan[nRelFan]
    "Relief fan proven on status"
    annotation (Placement(transformation(extent={{-520,-180},{-480,-140}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{480,300},{520,340}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe[nRelFan](
    final unit=fill("1", nRelFan),
    final max=fill(1,nRelFan)) "Relief fan speed setpoint"
    annotation (Placement(transformation(extent={{480,190},{520,230}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam[nRelFan](
    final unit=fill("1",nRelFan),
    final min=fill(0,nRelFan),
    final max=fill(1,nRelFan)) "Damper position setpoint"
    annotation (Placement(transformation(extent={{480,40},{520,80}}),
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
    annotation (Placement(transformation(extent={{-420,220},{-400,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Normalized the control error"
    annotation (Placement(transformation(extent={{-360,200},{-340,220}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final k=k)
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
    annotation (Placement(transformation(extent={{120,274},{140,294}})));
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
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if a relief fan should be enabled"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.And enaDam[nRelFan]
    "Enable damper"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=minSpe + 0.15,
    final h=hys)
    "Check if the controller output is greater than minimum speed plus threshold"
    annotation (Placement(transformation(extent={{-280,-100},{-260,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Timer upTim(
    final t=420)
    "Check if the controller output has been greater than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre(final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Output rising edge when input becomes true"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-420,-36},{-400,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2[nRelFan]
    "Identify relief fans that have been enabled but not yet operating"
    annotation (Placement(transformation(extent={{-360,-30},{-340,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[nRelFan]
    "List of standby fans, along with their staging order"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    final nin=nRelFan)
    "Identify current order of staging"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
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
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr2[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nRelFan]
    "Targeted vector of operating relief fan after one new fan being turned on"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat2
    "Stage up next relief fan"
    annotation (Placement(transformation(extent={{220,-100},{240,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr3(
    final t=minSpe,
    final h=hys)
    "Check if the controller output is less than minimum speed"
    annotation (Placement(transformation(extent={{-280,-320},{-260,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Timer dowTim(
    final t=300)
    "Check if the controller output has been less than threshold for sufficient long time"
    annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1(final pre_u_start=true)
    "Break algebraic loop"
    annotation (Placement(transformation(extent={{-20,-330},{0,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    annotation (Placement(transformation(extent={{-120,-280},{-100,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro2[nRelFan]
    "List of operating fans, along with their staging order"
    annotation (Placement(transformation(extent={{-280,-210},{-260,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1[nRelFan](
    final p=fill(nRelFan + 1, nRelFan))
    "Add value to the input"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr4[nRelFan](
    final t=fill(0.5, nRelFan))
    "Check if the input is less than threshold"
    annotation (Placement(transformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nRelFan]
    "Switch input values"
    annotation (Placement(transformation(extent={{-180,-240},{-160,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin1(
    final nin=nRelFan)
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub3[nRelFan]
    "Identify next operating fan"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs2[nRelFan]
    "Find absolute value"
    annotation (Placement(transformation(extent={{-20,-210},{0,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr5[nRelFan](
    final t=fill(0.5, nRelFan))
    "Identify next fan to be off"
    annotation (Placement(transformation(extent={{20,-210},{40,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    final nout=nRelFan)
    "Replicate real number"
    annotation (Placement(transformation(extent={{-100,-240},{-80,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nRelFan]
    "Vector of relief fan after one fan being turned off"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2[nRelFan]
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{100,-248},{120,-228}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nRelFan]
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=nRelFan)
    "Check if newly started fan has become proven on"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nRelFan]
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{140,-240},{160,-220}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd2(
    final nin=nRelFan)
    "Check if newly turned off fan has become off"
    annotation (Placement(transformation(extent={{180,-240},{200,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Stage down lag fan"
    annotation (Placement(transformation(extent={{220,-280},{240,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{340,-100},{360,-80}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{260,-100},{280,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[nRelFan]
    "Vector of relief fan status after staging down"
    annotation (Placement(transformation(extent={{300,-280},{320,-260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep2(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{260,-280},{280,-260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{380,-100},{400,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=1,
    final uMin=minSpe)
    "Limit the controller output"
    annotation (Placement(transformation(extent={{60,250},{80,270}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep2(
    final nout=nRelFan)
    "Replicate real input"
    annotation (Placement(transformation(extent={{380,206},{400,226}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro3[nRelFan]
    "Relief fan speed"
    annotation (Placement(transformation(extent={{440,200},{460,220}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{280,50},{300,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep3(
    final nout=nRelFan)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{320,50},{340,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[nRelFan]
    "Vector of relief fan status after staging up"
    annotation (Placement(transformation(extent={{380,50},{400,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpBuiSetPoi(
    final k=dpBuiSet)
    "Building pressure setpoint"
    annotation (Placement(transformation(extent={{-420,170},{-400,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-380,250},{-360,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Zero fan speed when it is in stage 0"
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Switch input values"
    annotation (Placement(transformation(extent={{340,206},{360,226}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nRelFan)
    "Check if there is any relief fan is proven on"
    annotation (Placement(transformation(extent={{60,206},{80,226}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4[nRelFan]
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{440,50},{460,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Start timer, and reset to zero if the threshold time has passed"
    annotation (Placement(transformation(extent={{-220,-320},{-200,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-60,-330},{-40,-310}})));

equation
  connect(uSupFan, booToRea.u)
    annotation (Line(points={{-500,330},{-462,330}}, color={255,0,255}));
  connect(enaRel.u, booToRea.y)
    annotation (Line(points={{-422,330},{-438,330}}, color={0,0,127}));
  connect(enaRel.y, gai.u)
    annotation (Line(points={{-398,330},{-382,330}}, color={0,0,127}));
  connect(dpBui, movMea.u)
    annotation (Line(points={{-500,230},{-422,230}}, color={0,0,127}));
  connect(conOne.y, conP.u_s)
    annotation (Line(points={{-358,260},{-342,260}}, color={0,0,127}));
  connect(movMea.y, div1.u1) annotation (Line(points={{-398,230},{-380,230},{-380,
          216},{-362,216}}, color={0,0,127}));
  connect(dpBuiSetPoi.y, div1.u2) annotation (Line(points={{-398,180},{-380,180},
          {-380,204},{-362,204}}, color={0,0,127}));
  connect(div1.y, conP.u_m) annotation (Line(points={{-338,210},{-330,210},{-330,
          248}}, color={0,0,127}));
  connect(uSupFan, enaRelGro.u) annotation (Line(points={{-500,330},{-470,330},{
          -470,290},{-462,290}}, color={255,0,255}));
  connect(booToRea1.y, pro.u1) annotation (Line(points={{-398,290},{118,290}},
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
    annotation (Line(points={{-158,130},{-142,130}}, color={255,0,255}));
  connect(gai.y, greThr1.u) annotation (Line(points={{-358,330},{-150,330},{-150,
          160},{-142,160}}, color={0,0,127}));
  connect(greThr1.y, enaDam.u1)
    annotation (Line(points={{-118,160},{-102,160}}, color={255,0,255}));
  connect(booRep.y, enaDam.u2) annotation (Line(points={{-118,130},{-110,130},{-110,
          152},{-102,152}},color={255,0,255}));
  connect(uRelFan, booToRea2.u) annotation (Line(points={{-500,-160},{-440,-160},
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
    annotation (Line(points={{-118,-30},{-102,-30}}, color={0,0,127}));
  connect(lesThr1.y, swi.u2)
    annotation (Line(points={{-198,-30},{-182,-30}}, color={255,0,255}));
  connect(pro1.y, lesThr1.u) annotation (Line(points={{-258,0},{-240,0},{-240,-30},
          {-222,-30}}, color={0,0,127}));
  connect(pro1.y, swi.u3) annotation (Line(points={{-258,0},{-240,0},{-240,-50},
          {-190,-50},{-190,-38},{-182,-38}}, color={0,0,127}));
  connect(pro1.y, addPar.u)
    annotation (Line(points={{-258,0},{-222,0}},  color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{-198,0},{-190,0},{-190,-22},
          {-182,-22}}, color={0,0,127}));
  connect(swi.y, mulMin.u)
    annotation (Line(points={{-158,-30},{-142,-30}}, color={0,0,127}));
  connect(gai.y, sub1.u1) annotation (Line(points={{-358,330},{-150,330},{-150,6},
          {-62,6}},   color={0,0,127}));
  connect(reaRep.y, sub1.u2) annotation (Line(points={{-78,-30},{-70,-30},{-70,-6},
          {-62,-6}},  color={0,0,127}));
  connect(sub1.y, abs1.u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(abs1.y, lesThr2.u)
    annotation (Line(points={{2,0},{18,0}},  color={0,0,127}));
  connect(lesThr2.y, or2.u1)
    annotation (Line(points={{42,0},{58,0}}, color={255,0,255}));
  connect(dowTim.passed, edg1.u) annotation (Line(points={{-158,-318},{-140,-318},
          {-140,-270},{-122,-270}}, color={255,0,255}));
  connect(booToRea2.y, pro2.u2) annotation (Line(points={{-398,-26},{-380,-26},{
          -380,-206},{-282,-206}}, color={0,0,127}));
  connect(gai.y, pro2.u1) annotation (Line(points={{-358,330},{-310,330},{-310,-194},
          {-282,-194}}, color={0,0,127}));
  connect(pro2.y, addPar1.u)
    annotation (Line(points={{-258,-200},{-222,-200}}, color={0,0,127}));
  connect(pro2.y, lesThr4.u) annotation (Line(points={{-258,-200},{-240,-200},{-240,
          -230},{-222,-230}}, color={0,0,127}));
  connect(lesThr4.y, swi1.u2)
    annotation (Line(points={{-198,-230},{-182,-230}}, color={255,0,255}));
  connect(addPar1.y, swi1.u1) annotation (Line(points={{-198,-200},{-190,-200},{
          -190,-222},{-182,-222}}, color={0,0,127}));
  connect(pro2.y, swi1.u3) annotation (Line(points={{-258,-200},{-240,-200},{-240,
          -250},{-190,-250},{-190,-238},{-182,-238}}, color={0,0,127}));
  connect(swi1.y, mulMin1.u)
    annotation (Line(points={{-158,-230},{-142,-230}}, color={0,0,127}));
  connect(mulMin1.y, reaRep1.u)
    annotation (Line(points={{-118,-230},{-102,-230}}, color={0,0,127}));
  connect(reaRep1.y, sub3.u2) annotation (Line(points={{-78,-230},{-70,-230},{-70,
          -206},{-62,-206}}, color={0,0,127}));
  connect(gai.y, sub3.u1) annotation (Line(points={{-358,330},{-150,330},{-150,-194},
          {-62,-194}}, color={0,0,127}));
  connect(sub3.y, abs2.u)
    annotation (Line(points={{-38,-200},{-22,-200}}, color={0,0,127}));
  connect(abs2.y, lesThr5.u)
    annotation (Line(points={{2,-200},{18,-200}}, color={0,0,127}));
  connect(lesThr5.y, xor.u1)
    annotation (Line(points={{42,-200},{58,-200}}, color={255,0,255}));
  connect(or2.y, booToInt.u) annotation (Line(points={{82,0},{90,0},{90,-30},{98,
          -30}}, color={255,0,255}));
  connect(xor.y, booToInt2.u) annotation (Line(points={{82,-200},{90,-200},{90,-238},
          {98,-238}}, color={255,0,255}));
  connect(booToInt.y, intEqu.u1)
    annotation (Line(points={{122,-30},{138,-30}}, color={255,127,0}));
  connect(booToInt1.y, intEqu.u2) annotation (Line(points={{122,-70},{130,-70},{
          130,-38},{138,-38}}, color={255,127,0}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{162,-30},{178,-30}}, color={255,0,255}));
  connect(booToInt1.y, intEqu1.u1) annotation (Line(points={{122,-70},{130,-70},
          {130,-230},{138,-230}}, color={255,127,0}));
  connect(booToInt2.y, intEqu1.u2)
    annotation (Line(points={{122,-238},{138,-238}}, color={255,127,0}));
  connect(intEqu1.y, mulAnd2.u)
    annotation (Line(points={{162,-230},{178,-230}}, color={255,0,255}));
  connect(lat2.y, booRep1.u)
    annotation (Line(points={{242,-90},{258,-90}}, color={255,0,255}));
  connect(lat1.y, booRep2.u)
    annotation (Line(points={{242,-270},{258,-270}}, color={255,0,255}));
  connect(booRep2.y, logSwi1.u2)
    annotation (Line(points={{282,-270},{298,-270}}, color={255,0,255}));
  connect(edg1.y, lat1.u)
    annotation (Line(points={{-98,-270},{218,-270}}, color={255,0,255}));
  connect(mulAnd2.y, lat1.clr) annotation (Line(points={{202,-230},{210,-230},{210,
          -276},{218,-276}}, color={255,0,255}));
  connect(conP.y, lesThr3.u) annotation (Line(points={{-318,260},{-300,260},{-300,
          -310},{-282,-310}}, color={0,0,127}));
  connect(xor.y, logSwi1.u1) annotation (Line(points={{82,-200},{290,-200},{290,
          -262},{298,-262}}, color={255,0,255}));
  connect(conP.y, greThr2.u) annotation (Line(points={{-318,260},{-300,260},{-300,
          -90},{-282,-90}}, color={0,0,127}));
  connect(edg.y, lat2.u)
    annotation (Line(points={{-98,-90},{218,-90}}, color={255,0,255}));
  connect(mulAnd.y, lat2.clr) annotation (Line(points={{202,-30},{210,-30},{210,
          -96},{218,-96}}, color={255,0,255}));
  connect(booRep1.y, logSwi.u2)
    annotation (Line(points={{282,-90},{338,-90}}, color={255,0,255}));
  connect(or2.y, logSwi.u1) annotation (Line(points={{82,0},{320,0},{320,-82},{338,
          -82}}, color={255,0,255}));
  connect(logSwi1.y, logSwi.u3) annotation (Line(points={{322,-270},{330,-270},{
          330,-98},{338,-98}}, color={255,0,255}));
  connect(uRelFan, xor.u2) annotation (Line(points={{-500,-160},{50,-160},{50,-208},
          {58,-208}}, color={255,0,255}));
  connect(uRelFan, logSwi1.u3) annotation (Line(points={{-500,-160},{-440,-160},
          {-440,-290},{290,-290},{290,-278},{298,-278}}, color={255,0,255}));
  connect(uRelFan, booToInt1.u) annotation (Line(points={{-500,-160},{50,-160},{
          50,-70},{98,-70}}, color={255,0,255}));
  connect(uRelFan, or2.u2) annotation (Line(points={{-500,-160},{50,-160},{50,-8},
          {58,-8}}, color={255,0,255}));
  connect(logSwi.y, booToRea3.u)
    annotation (Line(points={{362,-90},{378,-90}}, color={255,0,255}));
  connect(conP.y, lim.u)
    annotation (Line(points={{-318,260},{58,260}}, color={0,0,127}));
  connect(lim.y, pro.u2) annotation (Line(points={{82,260},{100,260},{100,278},{
          118,278}}, color={0,0,127}));
  connect(booToRea3.y, pro3.u2) annotation (Line(points={{402,-90},{420,-90},{420,
          204},{438,204}}, color={0,0,127}));
  connect(lat2.y, or1.u1) annotation (Line(points={{242,-90},{248,-90},{248,60},
          {278,60}}, color={255,0,255}));
  connect(lat1.y, or1.u2) annotation (Line(points={{242,-270},{254,-270},{254,52},
          {278,52}}, color={255,0,255}));
  connect(or1.y, booRep3.u)
    annotation (Line(points={{302,60},{318,60}}, color={255,0,255}));
  connect(booRep3.y, logSwi2.u2)
    annotation (Line(points={{342,60},{378,60}}, color={255,0,255}));
  connect(logSwi.y, logSwi2.u3) annotation (Line(points={{362,-90},{370,-90},{370,
          52},{378,52}}, color={255,0,255}));
  connect(enaDam.y, logSwi2.u1) annotation (Line(points={{-78,160},{370,160},{370,
          68},{378,68}}, color={255,0,255}));
  connect(pro3.y, yRelFanSpe)
    annotation (Line(points={{462,210},{500,210}}, color={0,0,127}));
  connect(pro.y, swi2.u1) annotation (Line(points={{142,284},{300,284},{300,224},
          {338,224}}, color={0,0,127}));
  connect(reaRep2.y, pro3.u1)
    annotation (Line(points={{402,216},{438,216}}, color={0,0,127}));
  connect(swi2.y, reaRep2.u)
    annotation (Line(points={{362,216},{378,216}}, color={0,0,127}));
  connect(con.y, swi2.u3) annotation (Line(points={{182,190},{300,190},{300,208},
          {338,208}}, color={0,0,127}));
  connect(uRelFan, mulOr.u) annotation (Line(points={{-500,-160},{50,-160},{50,216},
          {58,216}}, color={255,0,255}));
  connect(mulOr.y, swi2.u2)
    annotation (Line(points={{82,216},{338,216}}, color={255,0,255}));
  connect(movMea.y, yDpBui) annotation (Line(points={{-398,230},{-80,230},{-80,320},
          {500,320}}, color={0,0,127}));
  connect(logSwi2.y, booToRea4.u)
    annotation (Line(points={{402,60},{438,60}}, color={255,0,255}));
  connect(booToRea4.y, yDam)
    annotation (Line(points={{462,60},{500,60}}, color={0,0,127}));
  connect(upTim.passed, edg.u) annotation (Line(points={{-158,-98},{-140,-98},{-140,
          -90},{-122,-90}}, color={255,0,255}));
  connect(edg.y, not1.u) annotation (Line(points={{-98,-90},{-80,-90},{-80,-120},
          {-62,-120}}, color={255,0,255}));
  connect(not1.y, pre.u)
    annotation (Line(points={{-38,-120},{-22,-120}}, color={255,0,255}));
  connect(and1.y, upTim.u)
    annotation (Line(points={{-198,-90},{-182,-90}}, color={255,0,255}));
  connect(greThr2.y, and1.u1)
    annotation (Line(points={{-258,-90},{-222,-90}}, color={255,0,255}));
  connect(pre.y, and1.u2) annotation (Line(points={{2,-120},{20,-120},{20,-140},
          {-240,-140},{-240,-98},{-222,-98}}, color={255,0,255}));
  connect(edg1.y, not2.u) annotation (Line(points={{-98,-270},{-80,-270},{-80,-320},
          {-62,-320}}, color={255,0,255}));
  connect(not2.y, pre1.u)
    annotation (Line(points={{-38,-320},{-22,-320}}, color={255,0,255}));
  connect(lesThr3.y, and3.u1)
    annotation (Line(points={{-258,-310},{-222,-310}}, color={255,0,255}));
  connect(and3.y, dowTim.u)
    annotation (Line(points={{-198,-310},{-182,-310}}, color={255,0,255}));
  connect(pre1.y, and3.u2) annotation (Line(points={{2,-320},{20,-320},{20,-340},
          {-240,-340},{-240,-318},{-222,-318}}, color={255,0,255}));

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
          extent={{-96,72},{-54,52}},
          lineColor={255,0,255},
          textString="uSupFan"),
        Text(
          extent={{-96,-50},{-54,-70}},
          lineColor={255,0,255},
          textString="uRelFan"),
        Text(
          extent={{-98,12},{-56,-8}},
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
          textString="yDam")}),
 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-480,-360},{480,360}}), graphics={
        Rectangle(
          extent={{-318,-182},{338,-358}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,18},{338,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-318,178},{118,82}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{54,-110},{230,-136}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-up: turning on a new relief fan"),
        Text(
          extent={{52,-324},{250,-352}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Stage-down: turning off a lag relief fan"),
        Text(
          extent={{-144,108},{106,90}},
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
