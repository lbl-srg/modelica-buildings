within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences;
block Dampers
  "Output signals for controlling dampers of dual-duct terminal unit using mixing control with inlet flow sensor"

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
    annotation(__cdl(ValueInReference=false),
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
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1") = 0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
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
    annotation (Placement(transformation(extent={{-360,120},{-320,160}}),
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
    annotation (Placement(transformation(extent={{-360,-30},{-320,10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,-120},{-320,-80}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Hot duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-220},{-320,-180}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active heating maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,-270},{-320,-230}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-360,-300},{-320,-260}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-360,-340},{-320,-300}}),
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
    annotation (Placement(transformation(extent={{320,220},{360,260}}),
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
    annotation (Placement(transformation(extent={{320,-120},{360,-80}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1") "Hot duct damper commanded position"
    annotation (Placement(transformation(extent={{320,-340},{360,-300}}),
        iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,240},{-140,260}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Output active cold duct airflow setpoint"
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{20,260},{40,280}})));
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
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Total discharge airflow setpoint"
    annotation (Placement(transformation(extent={{260,280},{280,300}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Cooing or heating state"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-280,-240},{-260,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "In deadband state"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Active cold duct airflow setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin1
    "Active airflow setpoint for heating"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer1(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOne1(
    final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is less than room temperature"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Logical and"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Airflow setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Calculate flow rate difference between minimum flow setpoint and the heating setpoint"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Ensure positive flow"
    annotation (Placement(transformation(extent={{180,-50},{200,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2(
    final realTrue=1,
    final realFalse=0)
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul3
    "Cold duct flow setpoint when in heating state"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{140,190},{160,210}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conCooDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=iniDam)
    "Cooling damper position controller"
    annotation (Placement(transformation(extent={{220,190},{240,210}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{140,130},{160,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch cooDamPos
    "Output cooling damper position"
    annotation (Placement(transformation(extent={{280,20},{300,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Not proven on"
    annotation (Placement(transformation(extent={{180,50},{200,70}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDisSet_flowNor1
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conHeaDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=iniDam)
    "Heating damper position controller"
    annotation (Placement(transformation(extent={{200,-140},{220,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Divide VDis_flowNor1
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{120,-210},{140,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch heaDamPos
    "Output heating damper position"
    annotation (Placement(transformation(extent={{280,-330},{300,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Cooing or deadband state"
    annotation (Placement(transformation(extent={{-60,-310},{-40,-290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1)
    "Ensure heating damper is closed when it is in cooling or deadband state"
    annotation (Placement(transformation(extent={{20,-310},{40,-290}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Ensure heating damper is closed when it is in cooling or deadband state"
    annotation (Placement(transformation(extent={{240,-290},{260,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMax1(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMax1(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{20,150},{40,170}})));
  Buildings.Controls.OBC.CDL.Reals.Max max2
    "Nominal flow"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
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
    annotation (Line(points={{-38,200},{-10,200},{-10,270},{18,270}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,250},{0,250},{0,262},{18,262}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{42,270},{60,270},{60,248},{78,248}},
      color={0,0,127}));
  connect(TColSup, sub2.u1) annotation (Line(points={{-340,170},{-280,170},{-280,
          176},{-162,176}}, color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,170},{-122,170}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,170},{-80,170},{-80,192},
          {-62,192}},      color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-258,220},{-80,220},{-80,
          200},{-62,200}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-258,220},{-80,220},{-80,
          240},{78,240}},  color={255,0,255}));
  connect(add2.y, VDis_flow_Set)
    annotation (Line(points={{282,290},{340,290}}, color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,-100},{-280,-100},{-280,
          164},{-162,164}}, color={0,0,127}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,278},{18,278}}, color={0,0,127}));
  connect(greThr1.y, or2.u1) annotation (Line(points={{-258,220},{-240,220},{-240,
          110},{-202,110}}, color={255,0,255}));
  connect(uHea, greThr2.u) annotation (Line(points={{-340,-200},{-300,-200},{-300,
          -230},{-282,-230}}, color={0,0,127}));
  connect(greThr2.y, or2.u2) annotation (Line(points={{-258,-230},{-230,-230},{-230,
          102},{-202,102}}, color={255,0,255}));
  connect(or2.y, not1.u)
    annotation (Line(points={{-178,110},{-122,110}}, color={255,0,255}));
  connect(not1.y, swi1.u2)
    annotation (Line(points={{-98,110},{18,110}}, color={255,0,255}));
  connect(VActMin_flow, swi1.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,118},{18,118}}, color={0,0,127}));
  connect(swi1.y, swi.u3) annotation (Line(points={{42,110},{60,110},{60,232},{78,
          232}}, color={0,0,127}));
  connect(uHea, lin1.u)
    annotation (Line(points={{-340,-200},{-62,-200}}, color={0,0,127}));
  connect(conZer1.y, lin1.x1) annotation (Line(points={{-178,-170},{-150,-170},{
          -150,-192},{-62,-192}}, color={0,0,127}));
  connect(conZer1.y, lin1.f1) annotation (Line(points={{-178,-170},{-150,-170},{
          -150,-196},{-62,-196}}, color={0,0,127}));
  connect(conOne1.y, lin1.x2) annotation (Line(points={{-118,-170},{-100,-170},{
          -100,-204},{-62,-204}}, color={0,0,127}));
  connect(VActHeaMax_flow, lin1.f2) annotation (Line(points={{-340,-250},{-180,-250},
          {-180,-208},{-62,-208}}, color={0,0,127}));
  connect(TZon, sub1.u1) annotation (Line(points={{-340,-100},{-280,-100},{-280,
          -124},{-202,-124}}, color={0,0,127}));
  connect(THotSup, sub1.u2) annotation (Line(points={{-340,-140},{-280,-140},{-280,
          -136},{-202,-136}}, color={0,0,127}));
  connect(sub1.y, greThr3.u)
    annotation (Line(points={{-178,-130},{-122,-130}}, color={0,0,127}));
  connect(greThr3.y, and1.u1)
    annotation (Line(points={{-98,-130},{-62,-130}}, color={255,0,255}));
  connect(greThr2.y, and1.u2) annotation (Line(points={{-258,-230},{-80,-230},{-80,
          -138},{-62,-138}}, color={255,0,255}));
  connect(VActMin_flow, swi2.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,-122},{-2,-122}}, color={0,0,127}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-38,-130},{-2,-130}}, color={255,0,255}));
  connect(lin1.y, swi2.u3) annotation (Line(points={{-38,-200},{-20,-200},{-20,-138},
          {-2,-138}}, color={0,0,127}));
  connect(greThr2.y, swi3.u2) annotation (Line(points={{-258,-230},{-230,-230},{
          -230,-100},{58,-100}}, color={255,0,255}));
  connect(swi2.y, swi3.u1) annotation (Line(points={{22,-130},{40,-130},{40,-92},
          {58,-92}}, color={0,0,127}));
  connect(conZer3.y, swi3.u3) annotation (Line(points={{22,0},{50,0},{50,-108},{
          58,-108}}, color={0,0,127}));
  connect(VActMin_flow, sub3.u1) annotation (Line(points={{-340,-10},{-20,-10},{
          -20,-64},{118,-64}}, color={0,0,127}));
  connect(swi3.y, sub3.u2) annotation (Line(points={{82,-100},{100,-100},{100,-76},
          {118,-76}}, color={0,0,127}));
  connect(sub3.y, max1.u2) annotation (Line(points={{142,-70},{160,-70},{160,-46},
          {178,-46}}, color={0,0,127}));
  connect(conZer3.y, max1.u1) annotation (Line(points={{22,0},{50,0},{50,-34},{178,
          -34}}, color={0,0,127}));
  connect(greThr2.y, booToRea2.u) annotation (Line(points={{-258,-230},{-230,-230},
          {-230,20},{-202,20}}, color={255,0,255}));
  connect(booToRea2.y, mul3.u1) annotation (Line(points={{-178,20},{-120,20},{-120,
          56},{-82,56}}, color={0,0,127}));
  connect(max1.y, mul3.u2) annotation (Line(points={{202,-40},{220,-40},{220,20},
          {-100,20},{-100,44},{-82,44}}, color={0,0,127}));
  connect(mul3.y, swi1.u3) annotation (Line(points={{-58,50},{0,50},{0,102},{18,
          102}}, color={0,0,127}));
  connect(swi3.y, VHotDucDis_flow_Set)
    annotation (Line(points={{82,-100},{340,-100}}, color={0,0,127}));
  connect(swi.y, VColDucDis_flow_Set)
    annotation (Line(points={{102,240},{340,240}}, color={0,0,127}));
  connect(swi.y, add2.u1) annotation (Line(points={{102,240},{120,240},{120,296},
          {258,296}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{102,240},{120,240},
          {120,206},{138,206}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conCooDam.u_s)
    annotation (Line(points={{162,200},{218,200}}, color={0,0,127}));
  connect(VColDucDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,140},
          {80,140},{80,146},{138,146}}, color={0,0,127}));
  connect(VDis_flowNor.y, conCooDam.u_m)
    annotation (Line(points={{162,140},{230,140},{230,188}}, color={0,0,127}));
  connect(u1CooAHU, conCooDam.trigger) annotation (Line(points={{-340,80},{224,80},
          {224,188}}, color={255,0,255}));
  connect(u1CooAHU, not3.u) annotation (Line(points={{-340,80},{160,80},{160,60},
          {178,60}}, color={255,0,255}));
  connect(not3.y, cooDamPos.u2) annotation (Line(points={{202,60},{250,60},{250,
          30},{278,30}}, color={255,0,255}));
  connect(conCooDam.y, cooDamPos.u3) annotation (Line(points={{242,200},{260,200},
          {260,22},{278,22}}, color={0,0,127}));
  connect(conZer3.y, cooDamPos.u1) annotation (Line(points={{22,0},{50,0},{50,38},
          {278,38}}, color={0,0,127}));
  connect(cooDamPos.y, yCooDam)
    annotation (Line(points={{302,30},{340,30}}, color={0,0,127}));
  connect(heaDamPos.y, yHeaDam)
    annotation (Line(points={{302,-320},{340,-320}}, color={0,0,127}));
  connect(u1HeaAHU, heaDamPos.u2)
    annotation (Line(points={{-340,-320},{278,-320}}, color={255,0,255}));
  connect(conZer3.y, heaDamPos.u3) annotation (Line(points={{22,0},{50,0},{50,-328},
          {278,-328}}, color={0,0,127}));
  connect(swi3.y, VDisSet_flowNor1.u1) annotation (Line(points={{82,-100},{100,-100},
          {100,-124},{118,-124}}, color={0,0,127}));
  connect(VDisSet_flowNor1.y, conHeaDam.u_s)
    annotation (Line(points={{142,-130},{198,-130}}, color={0,0,127}));
  connect(VHotDucDis_flow, VDis_flowNor1.u1) annotation (Line(points={{-340,-280},
          {0,-280},{0,-194},{118,-194}}, color={0,0,127}));
  connect(VDis_flowNor1.y, conHeaDam.u_m) annotation (Line(points={{142,-200},{210,
          -200},{210,-142}}, color={0,0,127}));
  connect(u1HeaAHU, conHeaDam.trigger) annotation (Line(points={{-340,-320},{204,
          -320},{204,-142}}, color={255,0,255}));
  connect(greThr1.y, or1.u1) annotation (Line(points={{-258,220},{-240,220},{-240,
          -300},{-62,-300}}, color={255,0,255}));
  connect(or2.y, or1.u2) annotation (Line(points={{-178,110},{-160,110},{-160,-308},
          {-62,-308}}, color={255,0,255}));
  connect(or1.y, booToRea1.u)
    annotation (Line(points={{-38,-300},{18,-300}}, color={255,0,255}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{42,-300},{160,-300},{160,
          -286},{238,-286}}, color={0,0,127}));
  connect(conHeaDam.y, mul1.u1) annotation (Line(points={{222,-130},{230,-130},{
          230,-274},{238,-274}}, color={0,0,127}));
  connect(mul1.y, heaDamPos.u1) annotation (Line(points={{262,-280},{270,-280},{
          270,-312},{278,-312}}, color={0,0,127}));
  connect(swi3.y, add2.u2) annotation (Line(points={{82,-100},{210,-100},{210,284},
          {258,284}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,-10},{-210,-10},{
          -210,254},{-162,254}}, color={0,0,127}));
  connect(heaMax1.y,max2. u2) annotation (Line(points={{42,160},{70,160},{70,174},
          {78,174}}, color={0,0,127}));
  connect(cooMax1.y,max2. u1) annotation (Line(points={{42,200},{70,200},{70,186},
          {78,186}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor.u2) annotation (Line(points={{102,180},{120,180},
          {120,194},{138,194}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor.u2) annotation (Line(points={{102,180},{120,180},
          {120,134},{138,134}}, color={0,0,127}));
  connect(max2.y, VDisSet_flowNor1.u2) annotation (Line(points={{102,180},{120,180},
          {120,-20},{90,-20},{90,-136},{118,-136}}, color={0,0,127}));
  connect(max2.y, VDis_flowNor1.u2) annotation (Line(points={{102,180},{120,180},
          {120,-20},{90,-20},{90,-206},{118,-206}}, color={0,0,127}));
annotation (
  defaultComponentName="dam",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-340},{320,340}}),
        graphics={
        Rectangle(
          extent={{-318,298},{138,44}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-162,300},{-18,274}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Cold duct airflow setpoint"),
        Rectangle(
          extent={{-318,-82},{138,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-46,-226},{98,-252}},
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
This sequence sets the dampers for dual-duct terminal unit using mixing control with
inlet flow sensor.
The implementation is according to Section 5.12.5 of ASHRAE Guideline 36, May 2020. The
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
The cooling damper shall be controlled to maintain the sum of the measured inlet
airflows at the minimum airflow set point <code>VActMin_flow</code>.
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
using mixing control with inlet flow sensor are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for dual-duct terminal unit using mixing control with inlet flow sensor\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctMixConInletSensor/Subsequences/Dampers.png\"/>
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
