within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences;
block DampersDualSensors
  "Output signals for controlling dampers of snap-acting controlled dual-duct terminal unit with dual inlet airflow sensors"

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
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,230},{-320,270}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cold duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,150},{-320,190}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,110},{-320,150}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooAHU
    "Cooling air handler status"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,-80},{-320,-40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-110},{-320,-70}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Hot duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-150},{-320,-110}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-210},{-320,-170}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-260},{-320,-220}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,-290},{-320,-250}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-360,-330},{-320,-290}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,270},{360,310}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VColDucDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Cold duct discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,210},{360,250}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final max=1,
    final unit="1") "Cold duct damper commanded position"
    annotation (Placement(transformation(extent={{320,10},{360,50}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotDucDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Hot duct discharge airflow setpoint"
    annotation (Placement(transformation(extent={{320,-90},{360,-50}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1") "Hot duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-290},{360,-250}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conCooDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Cooling damper position controller"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output active cold duct airflow setpoint"
    annotation (Placement(transformation(extent={{100,230},{120,250}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{40,260},{60,280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,270},{-260,290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,270},{-200,290}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch cooDamPos
    "Output cooling damper position"
    annotation (Placement(transformation(extent={{280,20},{300,40}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,120},{260,140}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,190},{260,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer1(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,-170},{-260,-150}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-280,-230},{-260,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne1(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is less than room temperature"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooing or heating state"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "In deadband"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Becoming heating or cooling state"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Logical and"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samHea(
    final samplePeriod=samplePeriod)
    "Sample the heating loop output"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samCoo(
    final samplePeriod=samplePeriod)
    "Sample the cooling loop output"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr4(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr5(
    final t=looHys,
    final h=0.5*looHys) "Check if it is heating state"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Changing from cooling state to deadband"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Changing from heating state to deadband"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Cold duct airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer2(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Hot duct airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "Output active hot duct airflow setpoint"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conHeaDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Heating damper position controller"
    annotation (Placement(transformation(extent={{280,-110},{300,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch heaDamPos
    "Output heating damper position"
    annotation (Placement(transformation(extent={{280,-280},{300,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor1
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,-180},{260,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor1
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Not proven on"
    annotation (Placement(transformation(extent={{200,-320},{220,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Not proven on"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Make sure heating damper is closed when it is in cooling state"
    annotation (Placement(transformation(extent={{180,-80},{200,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Ensure heating damper closed when it is in cooling state"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Make sure heating damper is closed when it is in cooling state"
    annotation (Placement(transformation(extent={{220,-250},{240,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1)
    "Ensure cooling damper closed when it is in heating state"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    "Make sure cooling damper is closed when it is in heating state"
    annotation (Placement(transformation(extent={{160,220},{180,240}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul3
    "Make sure cooling damper is closed when it is in heating state"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Total discharge airflow setpoint"
    annotation (Placement(transformation(extent={{260,280},{280,300}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMax1(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMax1(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Nominal flow"
    annotation (Placement(transformation(extent={{180,160},{200,180}})));
equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,250},{-162,250}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,280},{-240,280},{-240,258},{-162,258}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,280},{-180,280},{-180,246},{-162,246}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,200},{-180,200},{-180,242},{-162,242}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,250},{-300,250},{-300,
          220},{-282,220}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,200},{10,200},{10,270},{38,270}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,250},{20,250},{20,262},{38,262}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{62,270},{80,270},{80,248},{98,248}},
      color={0,0,127}));
  connect(TColSup, sub2.u1) annotation (Line(points={{-340,170},{-280,170},{-280,
          176},{-162,176}}, color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,170},{-122,170}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,170},{-80,170},{-80,192},
          {-62,192}},      color={255,0,255}));
  connect(cooDamPos.y, yCooDam)
    annotation (Line(points={{302,30},{340,30}}, color={0,0,127}));
  connect(VColDucDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,130},
          {180,130},{180,136},{238,136}}, color={0,0,127}));
  connect(VDis_flowNor.y, conCooDam.u_m)
    annotation (Line(points={{262,130},{290,130},{290,188}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conCooDam.u_s)
    annotation (Line(points={{262,200},{278,200}}, color={0,0,127}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-258,220},{-80,220},{-80,
          200},{-62,200}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-258,220},{-80,220},{-80,
          240},{98,240}},  color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,-60},{0,-60},{0,
          278},{38,278}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,-60},{-190,-60},{
          -190,254},{-162,254}}, color={0,0,127}));
  connect(conZer1.y, lin1.x1) annotation (Line(points={{-258,-160},{-230,-160},{
          -230,-182},{-162,-182}}, color={0,0,127}));
  connect(VActMin_flow, lin1.f1) annotation (Line(points={{-340,-60},{-190,-60},
          {-190,-186},{-162,-186}}, color={0,0,127}));
  connect(conOne1.y, lin1.x2) annotation (Line(points={{-198,-160},{-180,-160},{
          -180,-194},{-162,-194}}, color={0,0,127}));
  connect(uHea, lin1.u)
    annotation (Line(points={{-340,-190},{-162,-190}}, color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,-90},{-280,-90},{-280,164},
          {-162,164}}, color={0,0,127}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-190},{-300,-190},{-300,
          -220},{-282,-220}}, color={0,0,127}));
  connect(VActHeaMax_flow, lin1.f2) annotation (Line(points={{-340,-240},{-180,-240},
          {-180,-198},{-162,-198}}, color={0,0,127}));
  connect(TZon, sub1.u1) annotation (Line(points={{-340,-90},{-280,-90},{-280,-114},
          {-162,-114}}, color={0,0,127}));
  connect(sub1.y, greThr3.u)
    annotation (Line(points={{-138,-120},{-122,-120}}, color={0,0,127}));
  connect(THotSup, sub1.u2) annotation (Line(points={{-340,-130},{-280,-130},{-280,
          -126},{-162,-126}}, color={0,0,127}));
  connect(greThr3.y, and1.u1)
    annotation (Line(points={{-98,-120},{-62,-120}}, color={255,0,255}));
  connect(greThr2.y, and1.u2) annotation (Line(points={{-258,-220},{-80,-220},{-80,
          -128},{-62,-128}}, color={255,0,255}));
  connect(and1.y, swi1.u2)
    annotation (Line(points={{-38,-120},{18,-120}}, color={255,0,255}));
  connect(VActMin_flow, swi1.u1) annotation (Line(points={{-340,-60},{0,-60},{0,
          -112},{18,-112}}, color={0,0,127}));
  connect(lin1.y, swi1.u3) annotation (Line(points={{-138,-190},{0,-190},{0,-128},
          {18,-128}}, color={0,0,127}));
  connect(greThr1.y, or2.u1) annotation (Line(points={{-258,220},{-250,220},{-250,
          10},{-222,10}}, color={255,0,255}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-258,-220},{-240,-220},{-240,
          2},{-222,2}}, color={255,0,255}));
  connect(or2.y, not1.u)
    annotation (Line(points={{-198,10},{-182,10}}, color={255,0,255}));
  connect(not1.y, falEdg.u)
    annotation (Line(points={{-158,10},{-122,10}}, color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{-158,10},{-140,10},{-140,-30},
          {-122,-30}}, color={255,0,255}));
  connect(not1.y, and3.u2) annotation (Line(points={{-158,10},{-140,10},{-140,42},
          {-122,42}}, color={255,0,255}));
  connect(uHea, samHea.u) annotation (Line(points={{-340,-190},{-300,-190},{-300,
          -40},{-222,-40}}, color={0,0,127}));
  connect(uCoo, samCoo.u) annotation (Line(points={{-340,250},{-300,250},{-300,50},
          {-222,50}}, color={0,0,127}));
  connect(samCoo.y, greThr4.u)
    annotation (Line(points={{-198,50},{-182,50}}, color={0,0,127}));
  connect(greThr4.y, and3.u1)
    annotation (Line(points={{-158,50},{-122,50}}, color={255,0,255}));
  connect(samHea.y, greThr5.u)
    annotation (Line(points={{-198,-40},{-182,-40}}, color={0,0,127}));
  connect(greThr5.y, and2.u2) annotation (Line(points={{-158,-40},{-140,-40},{-140,
          -38},{-122,-38}}, color={255,0,255}));
  connect(and3.y, lat.u)
    annotation (Line(points={{-98,50},{-62,50}}, color={255,0,255}));
  connect(falEdg.y, lat.clr) annotation (Line(points={{-98,10},{-80,10},{-80,44},
          {-62,44}}, color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{-98,-30},{-62,-30}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{-98,10},{-80,10},{-80,-36},
          {-62,-36}}, color={255,0,255}));
  connect(lat.y, swi2.u2)
    annotation (Line(points={{-38,50},{18,50}}, color={255,0,255}));
  connect(VActMin_flow, swi2.u1) annotation (Line(points={{-340,-60},{0,-60},{0,
          58},{18,58}}, color={0,0,127}));
  connect(conZer2.y, swi2.u3) annotation (Line(points={{-38,10},{-20,10},{-20,42},
          {18,42}}, color={0,0,127}));
  connect(lat1.y, swi3.u2)
    annotation (Line(points={{-38,-30},{18,-30}}, color={255,0,255}));
  connect(VActMin_flow, swi3.u1) annotation (Line(points={{-340,-60},{0,-60},{0,
          -22},{18,-22}}, color={0,0,127}));
  connect(conZer2.y, swi3.u3) annotation (Line(points={{-38,10},{-20,10},{-20,-38},
          {18,-38}}, color={0,0,127}));
  connect(swi2.y, swi.u3) annotation (Line(points={{42,50},{80,50},{80,232},{98,
          232}}, color={0,0,127}));
  connect(greThr2.y, swi4.u2) annotation (Line(points={{-258,-220},{-80,-220},{-80,
          -70},{78,-70}},  color={255,0,255}));
  connect(swi1.y, swi4.u1) annotation (Line(points={{42,-120},{70,-120},{70,-62},
          {78,-62}},  color={0,0,127}));
  connect(swi3.y, swi4.u3) annotation (Line(points={{42,-30},{60,-30},{60,-78},{
          78,-78}},  color={0,0,127}));
  connect(heaDamPos.y, yHeaDam)
    annotation (Line(points={{302,-270},{340,-270}}, color={0,0,127}));
  connect(VDis_flowNor1.y, conHeaDam.u_m) annotation (Line(points={{262,-170},{290,
          -170},{290,-112}}, color={0,0,127}));
  connect(VDisSet_flowNor1.y, conHeaDam.u_s)
    annotation (Line(points={{262,-100},{278,-100}}, color={0,0,127}));
  connect(VHotDucDis_flow, VDis_flowNor1.u1) annotation (Line(points={{-340,-270},
          {100,-270},{100,-164},{238,-164}}, color={0,0,127}));
  connect(conZer3.y, cooDamPos.u1) annotation (Line(points={{102,10},{120,10},{120,
          38},{278,38}}, color={0,0,127}));
  connect(conZer3.y, heaDamPos.u1) annotation (Line(points={{102,10},{120,10},{120,
          -262},{278,-262}}, color={0,0,127}));
  connect(u1HeaAHU, not2.u)
    annotation (Line(points={{-340,-310},{198,-310}}, color={255,0,255}));
  connect(not2.y, heaDamPos.u2) annotation (Line(points={{222,-310},{260,-310},{
          260,-270},{278,-270}}, color={255,0,255}));
  connect(u1HeaAHU, conHeaDam.trigger) annotation (Line(points={{-340,-310},{180,
          -310},{180,-140},{284,-140},{284,-112}}, color={255,0,255}));
  connect(u1CooAHU, not3.u) annotation (Line(points={{-340,80},{160,80},{160,0},{
          178,0}}, color={255,0,255}));
  connect(not3.y, cooDamPos.u2) annotation (Line(points={{202,0},{220,0},{220,30},
          {278,30}}, color={255,0,255}));
  connect(u1CooAHU, conCooDam.trigger) annotation (Line(points={{-340,80},{284,80},
          {284,188}}, color={255,0,255}));
  connect(greThr1.y, booToRea.u) annotation (Line(points={{-258,220},{-250,220},
          {-250,-140},{78,-140}}, color={255,0,255}));
  connect(swi4.y, mul.u1) annotation (Line(points={{102,-70},{160,-70},{160,-64},
          {178,-64}}, color={0,0,127}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{102,-140},{160,-140},{160,
          -76},{178,-76}}, color={0,0,127}));
  connect(mul.y, VHotDucDis_flow_Set)
    annotation (Line(points={{202,-70},{340,-70}}, color={0,0,127}));
  connect(mul.y, VDisSet_flowNor1.u1) annotation (Line(points={{202,-70},{220,-70},
          {220,-94},{238,-94}}, color={0,0,127}));
  connect(booToRea.y, mul1.u2) annotation (Line(points={{102,-140},{160,-140},{160,
          -246},{218,-246}}, color={0,0,127}));
  connect(mul1.y, heaDamPos.u3) annotation (Line(points={{242,-240},{270,-240},{
          270,-278},{278,-278}}, color={0,0,127}));
  connect(conHeaDam.y, mul1.u1) annotation (Line(points={{302,-100},{310,-100},{
          310,-220},{200,-220},{200,-234},{218,-234}}, color={0,0,127}));
  connect(greThr2.y, booToRea1.u) annotation (Line(points={{-258,-220},{-240,-220},
          {-240,150},{38,150}}, color={255,0,255}));
  connect(swi.y, mul2.u1) annotation (Line(points={{122,240},{140,240},{140,236},
          {158,236}}, color={0,0,127}));
  connect(booToRea1.y, mul2.u2) annotation (Line(points={{62,150},{120,150},{120,
          224},{158,224}}, color={0,0,127}));
  connect(mul2.y, VColDucDis_flow_Set)
    annotation (Line(points={{182,230},{340,230}}, color={0,0,127}));
  connect(mul2.y, VDisSet_flowNor.u1) annotation (Line(points={{182,230},{220,230},
          {220,206},{238,206}}, color={0,0,127}));
  connect(booToRea1.y, mul3.u2) annotation (Line(points={{62,150},{120,150},{120,
          54},{178,54}}, color={0,0,127}));
  connect(conCooDam.y, mul3.u1) annotation (Line(points={{302,200},{310,200},{310,
          84},{170,84},{170,66},{178,66}}, color={0,0,127}));
  connect(mul3.y, cooDamPos.u3) annotation (Line(points={{202,60},{260,60},{260,
          22},{278,22}}, color={0,0,127}));
  connect(mul2.y, add2.u2) annotation (Line(points={{182,230},{200,230},{200,284},
          {258,284}}, color={0,0,127}));
  connect(mul.y, add2.u1) annotation (Line(points={{202,-70},{220,-70},{220,-20},
          {130,-20},{130,296},{258,296}}, color={0,0,127}));
  connect(add2.y, VDis_flow_Set)
    annotation (Line(points={{282,290},{340,290}}, color={0,0,127}));
  connect(cooMax1.y,max2. u1) annotation (Line(points={{162,190},{170,190},{170,
          176},{178,176}}, color={0,0,127}));
  connect(heaMax1.y,max2. u2) annotation (Line(points={{162,150},{170,150},{170,
          164},{178,164}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor.u2) annotation (Line(points={{202,170},{230,170},
          {230,194},{238,194}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor.u2) annotation (Line(points={{202,170},{230,170},
          {230,124},{238,124}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor1.u2) annotation (Line(points={{202,170},{230,170},
          {230,-106},{238,-106}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor1.u2) annotation (Line(points={{202,170},{230,170},
          {230,-176},{238,-176}}, color={0,0,127}));
annotation (
  defaultComponentName="dam",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-340},{320,340}}),
        graphics={
        Rectangle(
          extent={{-318,298},{138,122}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-26,194},{118,168}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Cold duct airflow setpoint"),
        Rectangle(
          extent={{-318,-102},{138,-278}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-50,-210},{94,-236}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Hot duct airflow setpoint"),
        Rectangle(
          extent={{-318,98},{138,-78}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-182,108},{96,76}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Cold and hot duct airflow setpoint when in deadband state")}),
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
          extent={{44,186},{96,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDis_flow_Set")}),
  Documentation(info="<html>
<p>
This sequence sets the dampers for snap-acting controlled dual-duct terminal unit
with dual inlet airflow sensors.
The implementation is according to Section 5.11.5.1 of ASHRAE Guideline 36, May 2020. The
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
and heating airflow set points shall be their last set points just before entering deadband.
In other words, when going from cooling to deadband, the cooling airflow set point is
equal to the zone minimum <code>VActMin_flow</code>, and the heating set point is zero
When going from heating to deadband, the heating airflow set point is equal to the
zone minimum <code>VActMin_flow</code>, and the cooling set point is zero. 
</li>
<li>
When the zone state is heating (<code>uHea &gt; 0</code>), then the heating loop output
<code>uHea</code> shall reset the heating supply airflow setpoint
<code>VHotDucDis_flow_Set</code> from the minimum <code>VActMin_flow</code> to
heating maximum setpoint <code>VActHeaMax_flow</code>. The heating damper shall be
modulated by a control loop to maintain the measured heating aiflow
<code>VHotDucDis_flow</code> at setpoint. The cooling damper shall be closed
<code>yCooDam=0</code>.
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
<p>The sequences of controlling dampers position for snap-acting controlled dual-duct terminal unit
with dual inlet airflow sensors are described in the following figure below.</p>
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
end DampersDualSensors;
