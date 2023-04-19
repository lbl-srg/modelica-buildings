within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences;
block DamperValves
  "Output signals for controlling constant-volume parallel fan-powered terminal unit"

  parameter Real dTDisZonSetMax(unit="K")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (__cdl(ValueInReference=True));
  parameter Real VMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=False), Dialog(group="Valve"));
  parameter Real kVal(unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation (__cdl(ValueInReference=False), Dialog(group="Valve"));
  parameter Real TiVal(unit="s")=300
    "Time constant of integrator block for valve control"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=False), Dialog(group="Damper"));
  parameter Real kDam(unit="1")=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=False), Dialog(group="Damper"));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Damper",
    enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
         or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=False),
                Dialog(group="Damper",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dTHys(unit="K")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));
  parameter Real floHys(unit="m3/s")=0.01
    "Hysteresis for checking airflow rate"
    annotation (__cdl(ValueInReference=False), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-360,260},{-320,300}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured primary airflow rate"
    annotation (Placement(transformation(extent={{-360,220},{-320,260}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,160},{-320,200}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active primary cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,110},{-320,150}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-360,70},{-320,110}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,40},{-320,80}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active primary minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,10},{-320,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-360,-76},{-320,-36}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-110},{-320,-70}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-150},{-320,-110}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,-180},{-320,-140}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-240},{-320,-200}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-360,-328},{-320,-288}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPri_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Primary airflow setpoint"
    annotation (Placement(transformation(extent={{320,230},{360,270}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1")
    "VAV damper commanded position"
    annotation (Placement(transformation(extent={{320,-20},{360,20}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{320,-80},{360,-40}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1")
    "Hot water valve commanded position"
    annotation (Placement(transformation(extent={{320,-130},{360,-90}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{320,-260},{360,-220}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{20,190},{40,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,200},{-260,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-260,-140},{-240,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-100},{-240,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOcc(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(final k=
        VCooMax_flow)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,140},{240,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,80},{240,100}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0)
    "Damper position controller"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if the discharge airflow rate is less than minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-260,-310},{-240,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=60)
    "Check if the discharge flow rate has been less than minimum outdoor airflow setpoint for a threshold time"
    annotation (Placement(transformation(extent={{-200,-310},{-180,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Hold fan On status"
    annotation (Placement(transformation(extent={{-100,-310},{-80,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=1.1) "Gain factor"
    annotation (Placement(transformation(extent={{-260,-380},{-240,-360}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "Check if the discharge airflow rate is greater than minimum outdoor airflow setpoint by 10%"
    annotation (Placement(transformation(extent={{-200,-350},{-180,-330}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=180)
    "Check if the discharge flow rate has been greater than minimum outdoor airflow setpoint by 10% for a threshold time"
    annotation (Placement(transformation(extent={{-160,-350},{-140,-330}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch fan control depending on if the zone state is heating"
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Terminal fan status"
    annotation (Placement(transformation(extent={{280,-250},{300,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "Constant false"
    annotation (Placement(transformation(extent={{180,-220},{200,-200}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-140,330},{-120,350}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-80,350},{-60,370}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-80,310},{-60,330}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-140,290},{-120,310}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-80,270},{-60,290}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-140,250},{-120,270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-20,350},{0,370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-20,310},{0,330}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-20,270},{0,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add up two inputs"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add up inputs"
    annotation (Placement(transformation(extent={{100,330},{120,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{160,240},{180,260}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{100,240},{120,260}})));

equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,180},{-162,180}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,210},{-240,210},{-240,188},{-162,188}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,210},{-180,210},{-180,176},{-162,176}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,130},{-180,130},{-180,172},{-162,172}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,180},{-280,180},{-280,
          150},{-222,150}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,130},{0,130},{0,200},{18,200}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,180},{-40,180},{-40,192},{18,192}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{42,200},{60,200},{60,178},{98,178}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,90},{-260,90},{-260,76},{-162,76}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,70},{-122,70}},   color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,70},{-80,70},{-80,122},
          {-62,122}},      color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-198,150},{-80,150},{-80,
          130},{-62,130}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-198,150},{-80,150},{-80,
          170},{98,170}},  color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,30},{-20,30},{-20,
          208},{18,208}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,30},{-240,30},{-240,
          184},{-162,184}},      color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-340,-130},{-262,-130}},  color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-340,30},{-20,30},{-20,
          162},{98,162}},  color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,-20},{-140,
          -20},{-140,-52},{-122,-52}}, color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-340,-56},{-122,-56}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-130},{-280,-130},
          {-280,-60},{-122,-60}}, color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-90},{-140,
          -90},{-140,-64},{-122,-64}}, color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-90},{-262,-90}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-90},{-220,
          -90},{-220,-68},{-122,-68}}, color={0,0,127}));
  connect(greThr2.y, conVal.trigger) annotation (Line(points={{-238,-130},{-56,-130},
          {-56,-102}},color={255,0,255}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,60},{-260,60},{-260,64},
          {-162,64}},  color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,-160},{-50,-160},{-50,
          -102}}, color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-98,-60},{-80,-60},
          {-80,-90},{-62,-90}}, color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-98,-60},{340,-60}}, color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-238,-130},{98,-130}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,-90},{20,-90},{20,-122},
          {98,-122}},color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{62,-190},{98,-190}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-340,-220},{80,-220},{80,
          -198},{98,-198}}, color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{122,-190},{140,-190},{140,
          -110},{278,-110}}, color={255,0,255}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-238,-20},{40,-20},{40,-138},
          {98,-138}},color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-238,-20},{40,-20},{40,-102},
          {278,-102}},color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{122,-130},{200,-130},{200,-118},
          {278,-118}},color={0,0,127}));
  connect(swi2.y, yVal)
    annotation (Line(points={{302,-110},{340,-110}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{182,120},{200,
          120},{200,144},{218,144}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{242,150},{258,150}}, color={0,0,127}));
  connect(VPri_flow, VDis_flowNor.u1) annotation (Line(points={{-340,240},{-300,
          240},{-300,96},{218,96}},   color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{182,120},{200,120},
          {200,84},{218,84}},   color={0,0,127}));
  connect(swi3.y, yDam)
    annotation (Line(points={{302,0},{340,0}},   color={0,0,127}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{122,-190},{140,-190},{140,
          0},{278,0}},   color={255,0,255}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-238,-20},{40,-20},{40,8},
          {278,8}},  color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{282,150},{300,150},{300,60},
          {220,60},{220,-8},{278,-8}},  color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{242,90},{270,90},{270,138}},   color={0,0,127}));
  connect(isUno.y, not1.u) annotation (Line(points={{122,-190},{140,-190},{140,40},
          {178,40}},  color={255,0,255}));
  connect(not1.y, conDam.trigger) annotation (Line(points={{202,40},{264,40},{264,
          138}},     color={255,0,255}));
  connect(VOAMin_flow, les.u2)
    annotation (Line(points={{-340,-308},{-262,-308}}, color={0,0,127}));
  connect(les.y, truDel7.u)
    annotation (Line(points={{-238,-300},{-202,-300}}, color={255,0,255}));
  connect(truDel7.y, lat.u)
    annotation (Line(points={{-178,-300},{-102,-300}}, color={255,0,255}));
  connect(VOAMin_flow, gai1.u) annotation (Line(points={{-340,-308},{-280,-308},
          {-280,-370},{-262,-370}}, color={0,0,127}));
  connect(VPri_flow, gre.u1) annotation (Line(points={{-340,240},{-300,240},{-300,
          -340},{-202,-340}}, color={0,0,127}));
  connect(gai1.y, gre.u2) annotation (Line(points={{-238,-370},{-220,-370},{-220,
          -348},{-202,-348}}, color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-178,-340},{-162,-340}}, color={255,0,255}));
  connect(truDel1.y, lat.clr) annotation (Line(points={{-138,-340},{-120,-340},{
          -120,-306},{-102,-306}}, color={255,0,255}));
  connect(greThr2.y, logSwi.u2) annotation (Line(points={{-238,-130},{-56,-130},
          {-56,-280},{98,-280}}, color={255,0,255}));
  connect(con.y, logSwi.u1) annotation (Line(points={{22,-240},{60,-240},{60,-272},
          {98,-272}}, color={255,0,255}));
  connect(lat.y, logSwi.u3) annotation (Line(points={{-78,-300},{60,-300},{60,-288},
          {98,-288}}, color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{122,-280},{200,-280},{
          200,-248},{278,-248}}, color={255,0,255}));
  connect(isUno.y, logSwi1.u2) annotation (Line(points={{122,-190},{140,-190},{140,
          -240},{278,-240}}, color={255,0,255}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{202,-210},{260,-210},{260,
          -232},{278,-232}}, color={255,0,255}));
  connect(logSwi1.y, y1Fan)
    annotation (Line(points={{302,-240},{340,-240}}, color={255,0,255}));
  connect(VPri_flow, les.u1) annotation (Line(points={{-340,240},{-300,240},{-300,
          -300},{-262,-300}}, color={0,0,127}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-340,280},{-160,280},{-160,360},{-82,360}},
          color={255,127,0}));
  connect(conInt.y,forZerFlo. u2) annotation (Line(points={{-118,340},{-100,340},
          {-100,352},{-82,352}}, color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-340,280},{-160,280},
          {-160,320},{-82,320}}, color={255,127,0}));
  connect(conInt1.y,forCooMax. u2) annotation (Line(points={{-118,300},{-100,300},
          {-100,312},{-82,312}},color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-340,280},{-82,280}},
         color={255,127,0}));
  connect(conInt2.y,forMinFlo. u2) annotation (Line(points={{-118,260},{-100,260},
          {-100,272},{-82,272}},color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-58,360},{-22,360}}, color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-58,320},{-22,320}}, color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-58,280},{-22,280}}, color={255,0,255}));
  connect(cooMax.y,add2. u1) annotation (Line(points={{2,320},{40,320},{40,306},
          {58,306}},color={0,0,127}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{2,360},{60,360},{60,346},
          {98,346}}, color={0,0,127}));
  connect(forZerFlo.y,or3. u1) annotation (Line(points={{-58,360},{-40,360},{-40,
          258},{98,258}}, color={255,0,255}));
  connect(forCooMax.y,or3. u2) annotation (Line(points={{-58,320},{-40,320},{-40,
          250},{98,250}}, color={255,0,255}));
  connect(forMinFlo.y,or3. u3) annotation (Line(points={{-58,280},{-40,280},{-40,
          242},{98,242}},color={255,0,255}));
  connect(add1.y, swi4.u1) annotation (Line(points={{122,340},{140,340},{140,258},
          {158,258}}, color={0,0,127}));
  connect(add2.y,add1. u2) annotation (Line(points={{82,300},{90,300},{90,334},{
          98,334}}, color={0,0,127}));
  connect(minFlo.y,add2. u2) annotation (Line(points={{2,280},{40,280},{40,294},
          {58,294}}, color={0,0,127}));
  connect(or3.y, swi4.u2)
    annotation (Line(points={{122,250},{158,250}}, color={255,0,255}));
  connect(swi.y, swi4.u3) annotation (Line(points={{122,170},{140,170},{140,242},
          {158,242}}, color={0,0,127}));
  connect(swi4.y, VPri_flow_Set)
    annotation (Line(points={{182,250},{340,250}}, color={0,0,127}));
  connect(swi4.y, VDisSet_flowNor.u1) annotation (Line(points={{182,250},{200,250},
          {200,156},{218,156}}, color={0,0,127}));
annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-400},{320,400}}),
        graphics={
        Rectangle(
          extent={{-318,378},{138,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-152,238},{-24,216}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Primary airflow setpoint"),
        Rectangle(
          extent={{-318,-42},{138,-178}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-10,-152},{106,-168}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Heating coil control"),
        Rectangle(
          extent={{-318,-262},{138,-398}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{10,-370},{126,-386}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Terminal fan control")}),
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
          extent={{-98,96},{-46,82}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,-182},{-48,-198}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOAMin_flow"),
        Text(
          extent={{-98,4},{-54,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,126},{-80,116}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-96},{-80,-104}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,-66},{-68,-74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,64},{-80,56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,-130}),
        Text(
          extent={{-100,34},{-80,26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{68,96},{98,86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDam"),
        Text(
          extent={{76,-132},{98,-144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{10,-2},{10,-48}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-38,60},{10,-48}},
          color={95,95,95},
          thickness=0.5),
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
          extent={{56,148},{98,136}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VPri_flow_Set"),
        Text(
          extent={{60,-84},{98,-96}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-154},{-70,-166}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,156},{-68,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,-36},{-68,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{64,-180},{96,-194}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="y1Fan"),
        Line(
          points={{-38,-22},{26,-22},{78,60}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{10,-2},{-38,-2}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(points={{10,-2},{44,-2},{44,-48}}, color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-96,196},{-64,184}},
          textColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="oveFloSet")}),
  Documentation(info="<html>
<p>
This sequence sets the fan status, damper and valve position for constant-volume
parallel fan-powered terminal unit.
The implementation is according to Section 5.7.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the minimum <code>VActMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints.
The heating coil is disabled (<code>yVal=0</code>).
<ul>
<li>
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yVal=0</code>).
</li>
<li>
When the zone state is heating (<code>uHea &gt; 0</code>),
<ul>
<li>
As the heating-loop output <code>uHea</code> increases from 0% to 100%, it shall reset
the discharge temperature <code>THeaDisSet</code> from the current AHU setpoint
temperature <code>TSupSet</code> to a maximum of <code>dTDisZonSetMax</code>
above space temperature setpoint.
</li>
<li>
The airflow setpoint shall be the minimum flow <code>VActMin_flow</code>.
</li>
<li>
The heating coil shall be modulated to maintain the discharge temperature at setpoint.
</li>
</ul>
</li>
<li>
The VAV damper shall be modulated by a control loop to maintain the measured
airflow at the active setpoint.
</li>
<li>
Fan control
<ul>
<li>
Fan shall run whenever zone state is heating.
</li>
<li>
The fan shall run in deadband and cooling zone state when the primary airflow rate
<code>VPri_flow</code> is less than the minimum outdoor airflow setpoint <code>VOAMin_flow</code>
(if using California Title 24, it should be the zone absolute minimum outdoor airflow
rate) for 1 minute, and shall shut off when the <code>VPri_flow</code> is above <code>VOAMin_flow</code>
(or the zone absolute minimum outdoor airflow rate) by 10% for 3 minutes.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling fan, damper position for constant-volume
parallel fan-powered terminal unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for constant-volume parallel fan-powered terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/ParallelFanCVF/Subsequences/Dampers.png\"/>
</p>
<p>
As specified in Section 5.7.7 of ASHRAE Guideline 36, the airflow setpoint could be
override by providing software switches that interlock to a system-level point to:
</p>
<ol>
<li>
when <code>oveFloSet</code> equals to 1, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zero,
</li>
<li>
when <code>oveFloSet</code> equals to 2, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zone cooling maximum airflow rate
<code>VCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VPri_flow_Set</code> to zone minimum airflow setpoint
<code>VMin_flow</code>.
</li>
</ol>
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
end DamperValves;
