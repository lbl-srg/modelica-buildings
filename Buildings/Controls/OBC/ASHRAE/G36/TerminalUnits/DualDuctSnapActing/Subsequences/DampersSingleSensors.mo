within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block DampersSingleSensors
  "Output signals for controlling dampers of snap-acting controlled dual-duct terminal unit with single discharge airflow sensors"

  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Real VHeaMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone heating maximum airflow rate";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false));
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time",
    final min=1E-3)
    "Sample period of component"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,190},{-320,230}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,140},{-320,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,40},{-320,80}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-10},{-320,30}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,-40},{-320,0}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooAHU
    "Cooling air handler status"
    annotation (Placement(transformation(extent={{-360,-80},{-320,-40}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-360,-280},{-320,-240}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,160},{360,200}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooDam
    "Cooling damper command open"
    annotation (Placement(transformation(extent={{320,-40},{360,0}}),
      iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final max=1,
    final unit="1") "Cold duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-120},{360,-80}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaDam
    "Heating damper command open"
    annotation (Placement(transformation(extent={{320,-160},{360,-120}}),
        iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1") "Hot duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-220},{360,-180}}),
        iconTransformation(extent={{100,-200},{140,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,200},{-140,220}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conCooDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Cooling damper position controller"
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,230},{-260,250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,230},{-200,250}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch damPos "Output damper position"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer1(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-280,20},{-260,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne1(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooing or heating state"
    annotation (Placement(transformation(extent={{-220,-190},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "In deadband"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Becoming heating or cooling state"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samHea(
    final samplePeriod=samplePeriod)
    "Sample the heating loop output"
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samCoo(
    final samplePeriod=samplePeriod)
    "Sample the cooling loop output"
    annotation (Placement(transformation(extent={{-220,-140},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr5(
    final t=looHys,
    final h=0.5*looHys) "Check if it is heating state"
    annotation (Placement(transformation(extent={{-160,-250},{-140,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Changing from cooling state to deadband"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Changing from heating state to deadband"
    annotation (Placement(transformation(extent={{-40,-230},{-20,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch cooFloSet
    "Flow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch heaFloSet
    "Flow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if any air handler is proven on"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    "Check if it is in cooling state or in deadband that switched from cooling state"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch cooDamPos "Cooling damper position"
    annotation (Placement(transformation(extent={{280,-110},{300,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Ensure cooling damper closed when the cooling air handler is not proven on"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Make sure cooling damper is closed when the cooling air handler is not proven on"
    annotation (Placement(transformation(extent={{220,-80},{240,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if it is in heating state or in deadband that switched from heating state"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1)
    "Ensure heating damper closed when the heating air handler is not proven on"
    annotation (Placement(transformation(extent={{80,-270},{100,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    "Make sure heating damper is closed when the heating air handler is not proven on"
    annotation (Placement(transformation(extent={{220,-180},{240,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch heaDamPos
    "Heating damper position"
    annotation (Placement(transformation(extent={{280,-210},{300,-190}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if cooling damper is opening"
    annotation (Placement(transformation(extent={{280,-30},{300,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Check if heating damper is opening"
    annotation (Placement(transformation(extent={{280,-150},{300,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMax1(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMax1(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Nominal flow"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,210},{-162,210}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,240},{-240,240},{-240,218},{-162,218}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,240},{-180,240},{-180,206},{-162,206}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,160},{-180,160},{-180,202},{-162,202}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,210},{-300,210},{-300,
          180},{-282,180}}, color={0,0,127}));
  connect(VDis_flowNor.y, conCooDam.u_m)
    annotation (Line(points={{42,40},{120,40},{120,88}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conCooDam.u_s)
    annotation (Line(points={{42,100},{108,100}},  color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,120},{-170,120},{
          -170,214},{-162,214}}, color={0,0,127}));
  connect(conZer1.y, lin1.x1) annotation (Line(points={{-258,90},{-230,90},{-230,
          68},{-162,68}}, color={0,0,127}));
  connect(VActMin_flow, lin1.f1) annotation (Line(points={{-340,120},{-170,120},
          {-170,64},{-162,64}}, color={0,0,127}));
  connect(conOne1.y, lin1.x2) annotation (Line(points={{-198,90},{-180,90},{-180,
          56},{-162,56}},  color={0,0,127}));
  connect(uHea, lin1.u)
    annotation (Line(points={{-340,60},{-162,60}}, color={0,0,127}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,60},{-310,60},{-310,30},
          {-282,30}}, color={0,0,127}));
  connect(VActHeaMax_flow, lin1.f2) annotation (Line(points={{-340,10},{-180,10},
          {-180,52},{-162,52}},     color={0,0,127}));
  connect(greThr1.y, or2.u1) annotation (Line(points={{-258,180},{-240,180},{-240,
          -180},{-222,-180}}, color={255,0,255}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-258,30},{-250,30},{-250,
          -188},{-222,-188}}, color={255,0,255}));
  connect(or2.y, not1.u)
    annotation (Line(points={{-198,-180},{-162,-180}}, color={255,0,255}));
  connect(not1.y, falEdg.u)
    annotation (Line(points={{-138,-180},{-102,-180}}, color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{-138,-180},{-120,-180},{-120,
          -220},{-102,-220}}, color={255,0,255}));
  connect(not1.y, and3.u2) annotation (Line(points={{-138,-180},{-120,-180},{-120,
          -138},{-102,-138}}, color={255,0,255}));
  connect(uHea, samHea.u) annotation (Line(points={{-340,60},{-310,60},{-310,-240},
          {-222,-240}}, color={0,0,127}));
  connect(uCoo, samCoo.u) annotation (Line(points={{-340,210},{-300,210},{-300,-130},
          {-222,-130}}, color={0,0,127}));
  connect(samCoo.y, greThr4.u)
    annotation (Line(points={{-198,-130},{-162,-130}}, color={0,0,127}));
  connect(greThr4.y, and3.u1)
    annotation (Line(points={{-138,-130},{-102,-130}}, color={255,0,255}));
  connect(samHea.y, greThr5.u)
    annotation (Line(points={{-198,-240},{-162,-240}}, color={0,0,127}));
  connect(greThr5.y, and2.u2) annotation (Line(points={{-138,-240},{-120,-240},{
          -120,-228},{-102,-228}}, color={255,0,255}));
  connect(and3.y, lat.u)
    annotation (Line(points={{-78,-130},{-42,-130}}, color={255,0,255}));
  connect(falEdg.y, lat.clr) annotation (Line(points={{-78,-180},{-60,-180},{-60,
          -136},{-42,-136}}, color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{-78,-220},{-42,-220}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{-78,-180},{-60,-180},{-60,
          -226},{-42,-226}}, color={255,0,255}));
  connect(greThr1.y, cooFloSet.u2)
    annotation (Line(points={{-258,180},{-42,180}}, color={255,0,255}));
  connect(lin.y, cooFloSet.u1) annotation (Line(points={{-138,210},{-60,210},{-60,
          188},{-42,188}}, color={0,0,127}));
  connect(heaFloSet.y, cooFloSet.u3) annotation (Line(points={{-78,120},{-60,120},
          {-60,172},{-42,172}}, color={0,0,127}));
  connect(greThr2.y, heaFloSet.u2) annotation (Line(points={{-258,30},{-110,30},
          {-110,120},{-102,120}}, color={255,0,255}));
  connect(lin1.y, heaFloSet.u1) annotation (Line(points={{-138,60},{-120,60},{-120,
          128},{-102,128}}, color={0,0,127}));
  connect(VActMin_flow, heaFloSet.u3) annotation (Line(points={{-340,120},{-170,
          120},{-170,112},{-102,112}}, color={0,0,127}));
  connect(cooFloSet.y, VDis_flow_Set)
    annotation (Line(points={{-18,180},{340,180}}, color={0,0,127}));
  connect(cooFloSet.y, VDisSet_flowNor.u1) annotation (Line(points={{-18,180},{0,
          180},{0,106},{18,106}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,-20},{-20,-20},
          {-20,46},{18,46}}, color={0,0,127}));
  connect(u1CooAHU, or1.u1) annotation (Line(points={{-340,-60},{0,-60},{0,10},{78,
          10}}, color={255,0,255}));
  connect(u1HeaAHU, or1.u2) annotation (Line(points={{-340,-260},{40,-260},{40,2},
          {78,2}}, color={255,0,255}));
  connect(or1.y, conCooDam.trigger)
    annotation (Line(points={{102,10},{114,10},{114,88}}, color={255,0,255}));
  connect(or1.y, damPos.u2)
    annotation (Line(points={{102,10},{158,10}}, color={255,0,255}));
  connect(conCooDam.y, damPos.u1) annotation (Line(points={{132,100},{140,100},{
          140,18},{158,18}}, color={0,0,127}));
  connect(conZer3.y, damPos.u3) annotation (Line(points={{102,-160},{140,-160},{
          140,2},{158,2}}, color={0,0,127}));
  connect(greThr1.y, or3.u1) annotation (Line(points={{-258,180},{-240,180},{-240,
          -100},{78,-100}}, color={255,0,255}));
  connect(lat.y, or3.u2) annotation (Line(points={{-18,-130},{20,-130},{20,-108},
          {78,-108}}, color={255,0,255}));
  connect(u1CooAHU, booToRea.u)
    annotation (Line(points={{-340,-60},{78,-60}}, color={255,0,255}));
  connect(damPos.y, mul1.u1) annotation (Line(points={{182,10},{200,10},{200,-64},
          {218,-64}}, color={0,0,127}));
  connect(booToRea.y, mul1.u2) annotation (Line(points={{102,-60},{160,-60},{160,
          -76},{218,-76}}, color={0,0,127}));
  connect(or3.y, cooDamPos.u2)
    annotation (Line(points={{102,-100},{278,-100}}, color={255,0,255}));
  connect(mul1.y, cooDamPos.u1) annotation (Line(points={{242,-70},{260,-70},{260,
          -92},{278,-92}}, color={0,0,127}));
  connect(conZer3.y, cooDamPos.u3) annotation (Line(points={{102,-160},{140,-160},
          {140,-108},{278,-108}}, color={0,0,127}));
  connect(greThr2.y, or4.u1) annotation (Line(points={{-258,30},{-250,30},{-250,
          -200},{78,-200}}, color={255,0,255}));
  connect(lat1.y, or4.u2) annotation (Line(points={{-18,-220},{20,-220},{20,-208},
          {78,-208}}, color={255,0,255}));
  connect(u1HeaAHU, booToRea1.u)
    annotation (Line(points={{-340,-260},{78,-260}}, color={255,0,255}));
  connect(or4.y, heaDamPos.u2)
    annotation (Line(points={{102,-200},{278,-200}}, color={255,0,255}));
  connect(damPos.y, mul2.u1) annotation (Line(points={{182,10},{200,10},{200,-164},
          {218,-164}}, color={0,0,127}));
  connect(booToRea1.y, mul2.u2) annotation (Line(points={{102,-260},{200,-260},{
          200,-176},{218,-176}}, color={0,0,127}));
  connect(mul2.y, heaDamPos.u1) annotation (Line(points={{242,-170},{260,-170},{
          260,-192},{278,-192}}, color={0,0,127}));
  connect(conZer3.y, heaDamPos.u3) annotation (Line(points={{102,-160},{140,-160},
          {140,-208},{278,-208}}, color={0,0,127}));
  connect(u1CooAHU, and1.u1) annotation (Line(points={{-340,-60},{0,-60},{0,-20},
          {278,-20}}, color={255,0,255}));
  connect(or3.y, and1.u2) annotation (Line(points={{102,-100},{180,-100},{180,-28},
          {278,-28}}, color={255,0,255}));
  connect(and1.y, y1CooDam)
    annotation (Line(points={{302,-20},{340,-20}}, color={255,0,255}));
  connect(or4.y, and4.u2) annotation (Line(points={{102,-200},{180,-200},{180,-148},
          {278,-148}}, color={255,0,255}));
  connect(u1HeaAHU, and4.u1) annotation (Line(points={{-340,-260},{40,-260},{40,-140},
          {278,-140}}, color={255,0,255}));
  connect(and4.y, y1HeaDam)
    annotation (Line(points={{302,-140},{340,-140}}, color={255,0,255}));
  connect(cooDamPos.y, yCooDam)
    annotation (Line(points={{302,-100},{340,-100}}, color={0,0,127}));
  connect(heaDamPos.y, yHeaDam)
    annotation (Line(points={{302,-200},{340,-200}}, color={0,0,127}));
  connect(heaMax1.y,max2. u2) annotation (Line(points={{-78,40},{-70,40},{-70,54},
          {-62,54}},       color={0,0,127}));
  connect(cooMax1.y,max2. u1) annotation (Line(points={{-78,80},{-70,80},{-70,66},
          {-62,66}},       color={0,0,127}));
  connect(max2.y, VDisSet_flowNor.u2) annotation (Line(points={{-38,60},{0,60},{
          0,94},{18,94}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor.u2) annotation (Line(points={{-38,60},{0,60},{0,34},
          {18,34}}, color={0,0,127}));
annotation (
  defaultComponentName="dam",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-280},{320,280}}),
        graphics={
        Rectangle(
          extent={{-318,258},{-22,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-174,256},{-30,230}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Discharge airflow setpoint"),
        Rectangle(
          extent={{-318,-102},{-2,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-298,-140},{-104,-166}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Dampers control when in deadband state")}),
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,170},{-40,152}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-96,82},{-32,62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,136},{-52,122}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-98,198},{-78,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,108},{-76,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{46,-112},{98,-124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yCooDam"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{10,-22},{10,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
    Polygon(
      points={{-52,-58},{-30,-52},{-30,-64},{-52,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{10,-58},{-48,-58}}, color={95,95,95}),
    Line(points={{28,-58},{90,-58}},  color={95,95,95}),
    Polygon(
      points={{92,-58},{70,-52},{70,-64},{92,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{40,148},{98,136}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDis_flow_Set"),
        Text(
          extent={{-98,-144},{-66,-154}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooAHU"),
        Text(
          extent={{-98,-112},{-64,-128}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,-174},{-66,-184}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaAHU"),
        Text(
          extent={{44,-172},{96,-184}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaDam"),
        Line(
          points={{10,-22},{26,-22},{66,48}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{10,-22},{10,-48}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{54,26}}, color={28,108,200}),
        Line(
          points={{10,-48},{8,-22},{-38,36}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{64,-94},{96,-104}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="y1CooDam"),
        Text(
          extent={{64,-152},{96,-162}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="y1HeaDam")}),
  Documentation(info="<html>
<p>
This sequence sets the dampers for snap-acting controlled dual-duct terminal unit
with single discharge airflow sensors.
The implementation is according to Section 5.11.5.2 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall reset the discharge airflow setpoint
<code>VDis_flow_Set</code> from the minimum <code>VActMin_flow</code> to
cooling maximum setpoint <code>VActCooMax_flow</code>. The cooling damper shall be
modulated by a control loop to maintain the measured discharge aiflow
<code>VDis_flow</code> at setpoint. The heating damper shall be closed
<code>yHeaDam=0</code>.
</li>
<li>
When the zone state is deadband (<code>uCoo=0</code> and <code>uHea=0</code>), the
discharge airflow set point <code>VDis_flow_Set</code> shall be the zone minimum
<code>VActMin_flow</code>, maintained by the damper that was operative just before
entering deadband. The other damper shall remain closed. In other words, when going
from cooling to deadband, the cooling damper shall maintain the discharge airflow at
the zone minimum set point, and the heating damper shall be closed. When going from
heating to deadband, the heating damper shall maintain the discharge airflow at the
zone minimum set point, and the cooling damper shall be closed. 
</li>
<li>
When the zone state is heating (<code>uHea &gt; 0</code>), then the heating loop output
<code>uHea</code> shall reset the discharge airflow setpoint
<code>VDis_flow_Set</code> from the minimum <code>VActMin_flow</code> to
heating maximum setpoint <code>VActHeaMax_flow</code>. The heating damper shall be
modulated by a control loop to maintain the measured discharge aiflow
<code>VDis_flow</code> at setpoint. The cooling damper shall be closed
<code>yCooDam=0</code>.
</li>
<li>
Overriding above controls:
<ul>
<li>
If heating air handler is not proven ON (<code>u1HeaAHU=false</code>), the heating
damper shall be closed (<code>yHeaDam=0</code>).
</li>
<li>
If cooling air handler is not proven ON (<code>u1CooAHU=false</code>), the cooling
damper shall be closed (<code>yCooDam=0</code>).
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling dampers position for snap-acting controlled dual-duct terminal unit
with single discharge airflow sensors are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for snap-acting controlled dual-duct terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctSnapActing/Subsequences/Dampers.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2023, by Jianjun Hu:<br/>
Removed the parameter <code>have_preIndDam</code> to exclude the option of using pressure independant damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DampersSingleSensors;
