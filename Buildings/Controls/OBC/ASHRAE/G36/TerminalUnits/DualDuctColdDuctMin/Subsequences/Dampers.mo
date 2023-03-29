within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences;
block Dampers
  "Output signals for controlling dampers of dual-duct terminal unit with cold-duct minimum control"

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
    "Type of controller";
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control";
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,200},{-320,240}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,150},{-320,190}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cold duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,120},{-320,160}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,90},{-320,130}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooAHU
    "Cooling air handler status"
    annotation (Placement(transformation(extent={{-360,30},{-320,70}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-30},{-320,10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-70},{-320,-30}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Hot duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-110},{-320,-70}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-170},{-320,-130}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-220},{-320,-180}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,-250},{-320,-210}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-360,-290},{-320,-250}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,240},{360,280}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VColDucDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Cold duct discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,190},{360,230}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final max=1,
    final unit="1")
    "Cold duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotDucDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Hot duct discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,-70},{360,-30}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1") "Hot duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-290},{360,-250}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cold duct airflow setpoint"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{20,230},{40,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,240},{-260,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,180},{-260,200}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Total discharge airflow setpoint"
    annotation (Placement(transformation(extent={{260,250},{280,270}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooing or heating state"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,-190},{-260,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer1(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,-130},{-180,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne1(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is less than room temperature"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conCooDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Cooling damper position controller"
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch cooDamPos
    "Output cooling damper position"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Not proven on"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor1
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conHeaDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Heating damper position controller"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor1
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch heaDamPos
    "Output heating damper position"
    annotation (Placement(transformation(extent={{280,-280},{300,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Cooing or deadband state"
    annotation (Placement(transformation(extent={{-60,-260},{-40,-240}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1)
    "Ensure heating damper is closed when it is in cooling or deadband state"
    annotation (Placement(transformation(extent={{20,-260},{40,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Ensure heating damper is closed when it is in cooling or deadband state"
    annotation (Placement(transformation(extent={{240,-240},{260,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMax1(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaMax1(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2 "Nominal flow"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,220},{-162,220}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,250},{-240,250},{-240,228},{-162,228}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,250},{-180,250},{-180,216},{-162,216}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,170},{-180,170},{-180,212},{-162,212}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,220},{-300,220},{-300,
          190},{-282,190}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,170},{-10,170},{-10,240},{18,240}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,220},{0,220},{0,232},{18,232}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{42,240},{60,240},{60,218},{78,218}},
      color={0,0,127}));
  connect(TColSup, sub2.u1) annotation (Line(points={{-340,140},{-280,140},{-280,
          146},{-162,146}}, color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,140},{-122,140}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,140},{-80,140},{-80,162},
          {-62,162}},      color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-258,190},{-80,190},{-80,
          170},{-62,170}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-258,190},{-80,190},{-80,
          210},{78,210}},  color={255,0,255}));
  connect(add2.y, VDis_flow_Set)
    annotation (Line(points={{282,260},{340,260}}, color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,-50},{-280,-50},{-280,134},
          {-162,134}},      color={0,0,127}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,248},{18,248}}, color={0,0,127}));
  connect(greThr1.y, or2.u1) annotation (Line(points={{-258,190},{-240,190},{-240,
          80},{-202,80}},   color={255,0,255}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-150},{-300,-150},{-300,
          -180},{-282,-180}}, color={0,0,127}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-258,-180},{-230,-180},{-230,
          72},{-202,72}},   color={255,0,255}));
  connect(uHea, lin1.u)
    annotation (Line(points={{-340,-150},{-62,-150}}, color={0,0,127}));
  connect(conZer1.y, lin1.x1) annotation (Line(points={{-178,-120},{-150,-120},{
          -150,-142},{-62,-142}}, color={0,0,127}));
  connect(conZer1.y, lin1.f1) annotation (Line(points={{-178,-120},{-150,-120},{
          -150,-146},{-62,-146}}, color={0,0,127}));
  connect(conOne1.y, lin1.x2) annotation (Line(points={{-118,-120},{-100,-120},{
          -100,-154},{-62,-154}}, color={0,0,127}));
  connect(VActHeaMax_flow, lin1.f2) annotation (Line(points={{-340,-200},{-180,-200},
          {-180,-158},{-62,-158}}, color={0,0,127}));
  connect(TZon, sub1.u1) annotation (Line(points={{-340,-50},{-280,-50},{-280,-74},
          {-202,-74}},        color={0,0,127}));
  connect(THotSup, sub1.u2) annotation (Line(points={{-340,-90},{-280,-90},{-280,
          -86},{-202,-86}},   color={0,0,127}));
  connect(sub1.y, greThr3.u)
    annotation (Line(points={{-178,-80},{-122,-80}},   color={0,0,127}));
  connect(greThr3.y, and1.u1)
    annotation (Line(points={{-98,-80},{-62,-80}},   color={255,0,255}));
  connect(greThr2.y, and1.u2) annotation (Line(points={{-258,-180},{-80,-180},{-80,
          -88},{-62,-88}},   color={255,0,255}));
  connect(VActMin_flow, swi2.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,-72},{-2,-72}},   color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-38,-80},{-2,-80}},   color={255,0,255}));
  connect(lin1.y, swi2.u3) annotation (Line(points={{-38,-150},{-20,-150},{-20,-88},
          {-2,-88}},  color={0,0,127}));
  connect(greThr2.y, swi3.u2) annotation (Line(points={{-258,-180},{-230,-180},{
          -230,-50},{58,-50}},   color={255,0,255}));
  connect(swi2.y, swi3.u1) annotation (Line(points={{22,-80},{40,-80},{40,-42},{
          58,-42}},  color={0,0,127}));
  connect(conZer3.y, swi3.u3) annotation (Line(points={{22,0},{50,0},{50,-58},{58,
          -58}},     color={0,0,127}));
  connect(swi3.y, VHotDucDis_flow_Set)
    annotation (Line(points={{82,-50},{340,-50}},   color={0,0,127}));
  connect(swi.y, VColDucDis_flow_Set)
    annotation (Line(points={{102,210},{340,210}}, color={0,0,127}));
  connect(swi.y, add2.u1) annotation (Line(points={{102,210},{120,210},{120,266},
          {258,266}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{102,210},{120,210},
          {120,176},{138,176}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conCooDam.u_s)
    annotation (Line(points={{162,170},{218,170}}, color={0,0,127}));
  connect(VColDucDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,110},
          {80,110},{80,116},{138,116}}, color={0,0,127}));
  connect(VDis_flowNor.y, conCooDam.u_m)
    annotation (Line(points={{162,110},{230,110},{230,158}}, color={0,0,127}));
  connect(u1CooAHU, conCooDam.trigger) annotation (Line(points={{-340,50},{224,50},
          {224,158}}, color={255,0,255}));
  connect(u1CooAHU, not3.u) annotation (Line(points={{-340,50},{160,50},{160,30},
          {178,30}}, color={255,0,255}));
  connect(not3.y, cooDamPos.u2) annotation (Line(points={{202,30},{250,30},{250,
          0},{278,0}},   color={255,0,255}));
  connect(conCooDam.y, cooDamPos.u3) annotation (Line(points={{242,170},{260,170},
          {260,-8},{278,-8}},   color={0,0,127}));
  connect(conZer3.y, cooDamPos.u1) annotation (Line(points={{22,0},{50,0},{50,8},
          {278,8}},    color={0,0,127}));
  connect(cooDamPos.y, yCooDam)
    annotation (Line(points={{302,0},{340,0}}, color={0,0,127}));
  connect(heaDamPos.y, yHeaDam)
    annotation (Line(points={{302,-270},{340,-270}}, color={0,0,127}));
  connect(u1HeaAHU, heaDamPos.u2)
    annotation (Line(points={{-340,-270},{278,-270}}, color={255,0,255}));
  connect(conZer3.y, heaDamPos.u3) annotation (Line(points={{22,0},{50,0},{50,-278},
          {278,-278}},       color={0,0,127}));
  connect(swi3.y, VDisSet_flowNor1.u1) annotation (Line(points={{82,-50},{100,-50},
          {100,-74},{118,-74}},   color={0,0,127}));
  connect(VDisSet_flowNor1.y, conHeaDam.u_s)
    annotation (Line(points={{142,-80},{198,-80}},   color={0,0,127}));
  connect(VHotDucDis_flow, VDis_flowNor1.u1) annotation (Line(points={{-340,-230},
          {0,-230},{0,-144},{118,-144}}, color={0,0,127}));
  connect(VDis_flowNor1.y, conHeaDam.u_m) annotation (Line(points={{142,-150},{210,
          -150},{210,-92}},  color={0,0,127}));
  connect(u1HeaAHU, conHeaDam.trigger) annotation (Line(points={{-340,-270},{204,
          -270},{204,-92}}, color={255,0,255}));
  connect(greThr1.y, or1.u1) annotation (Line(points={{-258,190},{-240,190},{-240,
          -250},{-62,-250}}, color={255,0,255}));
  connect(or2.y, or1.u2) annotation (Line(points={{-178,80},{-160,80},{-160,-258},
          {-62,-258}}, color={255,0,255}));
  connect(or1.y, booToRea1.u)
    annotation (Line(points={{-38,-250},{18,-250}}, color={255,0,255}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{42,-250},{160,-250},{160,
          -236},{238,-236}}, color={0,0,127}));
  connect(conHeaDam.y, mul1.u1) annotation (Line(points={{222,-80},{230,-80},{230,
          -224},{238,-224}},     color={0,0,127}));
  connect(mul1.y, heaDamPos.u1) annotation (Line(points={{262,-230},{270,-230},{
          270,-262},{278,-262}}, color={0,0,127}));
  connect(swi3.y, add2.u2) annotation (Line(points={{82,-50},{210,-50},{210,254},
          {258,254}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,-10},{-210,-10},{
          -210,224},{-162,224}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-340,-10},{-20,-10},{-20,
          202},{78,202}}, color={0,0,127}));
  connect(cooMax1.y, max2.u1) annotation (Line(points={{42,170},{60,170},{60,156},
          {78,156}}, color={0,0,127}));
  connect(heaMax1.y, max2.u2) annotation (Line(points={{42,130},{60,130},{60,144},
          {78,144}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor.u2) annotation (Line(points={{102,150},{120,150},
          {120,164},{138,164}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor.u2) annotation (Line(points={{102,150},{120,150},
          {120,104},{138,104}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor1.u2) annotation (Line(points={{102,150},{120,150},
          {120,-20},{90,-20},{90,-86},{118,-86}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor1.u2) annotation (Line(points={{102,150},{120,150},
          {120,-20},{90,-20},{90,-156},{118,-156}}, color={0,0,127}));
annotation (
  defaultComponentName="dam",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-300},{320,300}}),
        graphics={
        Rectangle(
          extent={{-318,278},{138,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-162,270},{-18,244}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Cold duct airflow setpoint"),
        Rectangle(
          extent={{-318,-32},{138,-208}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-46,-176},{98,-202}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Hot duct airflow setpoint")}),
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
          extent={{-96,-118},{-32,-138}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,26},{-52,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-98,198},{-78,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-92},{-76,-106}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,136},{-68,124}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TColSup"),
        Text(
          extent={{-98,-12},{-78,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{46,98},{98,86}},
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
          extent={{22,148},{98,134}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VColDucDis_flow_Set"),
        Text(
          extent={{-98,76},{-66,66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooAHU"),
        Text(
          extent={{-96,110},{-38,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow"),
        Text(
          extent={{-98,-64},{-68,-76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THotSup"),
        Text(
          extent={{-98,-150},{-40,-168}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow"),
        Text(
          extent={{-98,-184},{-66,-194}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaAHU"),
        Text(
          extent={{44,-132},{96,-144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaDam"),
        Text(
          extent={{20,-82},{96,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VHotDucDis_flow_Set"),
        Line(
          points={{10,-22},{26,-22},{66,48}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{10,-22},{-4,-48}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{54,26}}, color={28,108,200}),
        Line(
          points={{10,-48},{0,-30},{-38,36}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{44,186},{96,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDis_flow_Set")}),
  Documentation(info="<html>
<p>
This sequence sets the dampers for dual-duct terminal unit with cold-duct minimum control.
The implementation is according to Section 5.14.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall reset the cooling supply airflow setpoint
<code>VColDucDis_flow_Set</code> from the minimum <code>VActMin_flow</code> to
cooling maximum setpoint <code>VActCooMax_flow</code>. The cooling damper shall be
modulated by a control loop to maintain the measured cooling aiflow
<code>VColDucDis_flow</code> at setpoint. The heating damper shall be closed
<code>yHeaDam=0</code>.
<ul>
<li>
If the cold-deck supply air temperature <code>TColSup</code> from the cooling air handler
is greater than room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is deadband (<code>uCoo=0</code> and <code>uHea=0</code>), the cooling
airflow set point <code>VColDucDis_flow_Set</code> shall be the minimum set point
<code>VActMin_flow</code>. The cooling damper shall be modulated by a control loop
to maintain the measured cooling airflow at set point. The heating damper shall be closed.
</li>
<li>
When the zone state is heating (<code>uHea &gt; 0</code>), then the heating loop output
<code>uHea</code> shall reset the heating supply airflow setpoint
<code>VHotDucDis_flow_Set</code> from zero to
heating maximum setpoint <code>VActHeaMax_flow</code>. The heating damper shall be
modulated by a control loop to maintain the measured heating aiflow
<code>VHotDucDis_flow</code> at setpoint. 
The cooling airflow setpoint shall be the minimum setpoint <code>VActMin_flow</code>.
The cooling damper shall be controlled to maintain the set point.
<ul>
<li>
If the hot-deck supply air temperature <code>THotSup</code> from the heating air handler
is less than room temperature <code>TZon</code>, heating supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
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
<p>The sequences of controlling dampers position for dual-duct terminal unit
with cold-duct minimum control are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for dual-duct terminal unit with cold-duct minimum control\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctColdDuctMin/Subsequences/Dampers.png\"/>
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
end Dampers;
