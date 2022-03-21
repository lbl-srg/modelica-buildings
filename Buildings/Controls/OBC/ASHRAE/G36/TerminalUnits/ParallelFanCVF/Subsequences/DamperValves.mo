within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences;
block DamperValves
  "Output signals for controlling constant-volume parallel fan-powered terminal unit"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Valve"));
  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation(Dialog(group="Valve"));
  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Boolean have_pressureIndependentDamper = true
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation(Dialog(group="Damper"));
  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper", enable=not have_pressureIndependentDamper));
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper", enable=not have_pressureIndependentDamper));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=not have_pressureIndependentDamper
           and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=not have_pressureIndependentDamper
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
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
  parameter Real floHys(
    final unit="m3/s") = 0.01
    "Hysteresis for checking airflow rate"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-360,300},{-320,340}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-360,240},{-320,280}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-360,190},{-320,230}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-360,150},{-320,190}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-360,120},{-320,160}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-360,90},{-320,130}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-360,4},{-320,44}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-30},{-320,10}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-70},{-320,-30}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,-100},{-320,-60}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-360,-248},{-320,-208}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Discharge primary airflow setpoint"
    annotation (Placement(transformation(extent={{320,280},{360,320}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final max=1,
    final unit="1") "VAV damper position setpoint"
    annotation (Placement(transformation(extent={{320,60},{360,100}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{320,0},{360,40}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValSet(
    final min=0,
    final max=1,
    final unit="1") "Hot water valve position setpoint"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Terminal fan status setpoint"
    annotation (Placement(transformation(extent={{320,-180},{360,-140}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{160,240},{180,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{60,270},{80,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-280,280},{-260,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-220,280},{-200,300}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
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
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOcc(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{280,-40},{300,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,220},{240,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    if not have_pressureIndependentDamper
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_pressureIndependentDamper
    "Damper position controller"
    annotation (Placement(transformation(extent={{260,220},{280,240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=1)
    if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{280,70},{300,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les(
    final h=floHys)
    "Check if the discharge airflow rate is less than minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-260,-230},{-240,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel7(
    final delayTime=60)
    "Check if the discharge flow rate has been less than minimum outdoor airflow setpoint for a threshold time"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Hold fan On status"
    annotation (Placement(transformation(extent={{-100,-230},{-80,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=1.1) "Gain factor"
    annotation (Placement(transformation(extent={{-260,-300},{-240,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "Check if the discharge airflow rate is greater than minimum outdoor airflow setpoint by 10%"
    annotation (Placement(transformation(extent={{-200,-270},{-180,-250}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=180)
    "Check if the discharge flow rate has been greater than minimum outdoor airflow setpoint by 10% for a threshold time"
    annotation (Placement(transformation(extent={{-160,-270},{-140,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Constant true"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1
    "Terminal fan status"
    annotation (Placement(transformation(extent={{280,-170},{300,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "Constant false"
    annotation (Placement(transformation(extent={{180,-140},{200,-120}})));

equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-340,260},{-162,260}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-258,290},{-240,290},{-240,268},{-162,268}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-198,290},{-180,290},{-180,256},{-162,256}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-340,210},{-180,210},{-180,252},{-162,252}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-340,260},{-280,260},{-280,
          230},{-222,230}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-38,210},{20,210},{20,280},{58,280}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-138,260},{40,260},{40,272},{58,272}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{82,280},{140,280},{140,258},{158,258}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,170},{-260,170},{-260,156},{-162,156}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-138,150},{-122,150}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-98,150},{-80,150},{-80,202},
          {-62,202}},      color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-198,230},{-80,230},{-80,
          210},{-62,210}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-198,230},{-80,230},{-80,
          250},{158,250}}, color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,110},{0,110},{0,
          288},{58,288}}, color={0,0,127}));
  connect(swi.y, VDis_flow_Set) annotation (Line(points={{182,250},{200,250},{
          200,300},{340,300}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,110},{-240,110},{
          -240,264},{-162,264}}, color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-340,-50},{-262,-50}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-340,110},{100,110},{100,
          242},{158,242}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,60},{-140,
          60},{-140,28},{-122,28}}, color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-340,24},{-122,24}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-50},{-280,-50},
          {-280,20},{-122,20}}, color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-10},{-140,
          -10},{-140,16},{-122,16}}, color={0,0,127}));
  connect(TZonHeaSet, addPar.u)
    annotation (Line(points={{-340,-10},{-262,-10}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-10},{-220,
          -10},{-220,12},{-122,12}}, color={0,0,127}));
  connect(greThr2.y, conVal.trigger) annotation (Line(points={{-238,-50},{-56,-50},
          {-56,-22}}, color={255,0,255}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,140},{-260,140},{-260,144},
          {-162,144}}, color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,-80},{-50,-80},{-50,-22}},
        color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-98,20},{-80,20},
          {-80,-10},{-62,-10}}, color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-98,20},{340,20}}, color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-238,-50},{98,-50}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,-10},{20,-10},{20,-42},
          {98,-42}}, color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{62,-110},{98,-110}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-340,-140},{80,-140},{80,
          -118},{98,-118}}, color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{122,-110},{140,-110},{140,
          -30},{278,-30}}, color={255,0,255}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-238,60},{40,60},{40,-58},
          {98,-58}}, color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-238,60},{40,60},{40,-22},
          {278,-22}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{122,-50},{200,-50},{200,-38},
          {278,-38}}, color={0,0,127}));
  connect(swi2.y, yValSet)
    annotation (Line(points={{302,-30},{340,-30}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{182,250},{200,250},
          {200,236},{218,236}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{182,200},{200,
          200},{200,224},{218,224}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{242,230},{258,230}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,320},{-300,
          320},{-300,176},{218,176}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{182,200},{200,200},
          {200,164},{218,164}}, color={0,0,127}));
  connect(swi3.y, yDamSet)
    annotation (Line(points={{302,80},{340,80}}, color={0,0,127}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{122,-110},{140,-110},{140,
          80},{278,80}}, color={255,0,255}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-238,60},{40,60},{40,88},
          {278,88}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{242,230},{250,230},
          {250,150},{160,150},{160,50},{178,50}}, color={0,0,127}));
  connect(gai.y, swi3.u3) annotation (Line(points={{202,50},{220,50},{220,72},{278,
          72}}, color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{282,230},{300,230},{300,140},
          {220,140},{220,72},{278,72}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{242,170},{270,170},{270,218}}, color={0,0,127}));
  connect(isUno.y, not1.u) annotation (Line(points={{122,-110},{140,-110},{140,120},
          {178,120}}, color={255,0,255}));
  connect(not1.y, conDam.trigger) annotation (Line(points={{202,120},{264,120},{
          264,218}}, color={255,0,255}));
  connect(VOAMin_flow, les.u2)
    annotation (Line(points={{-340,-228},{-262,-228}}, color={0,0,127}));
  connect(les.y, truDel7.u)
    annotation (Line(points={{-238,-220},{-202,-220}}, color={255,0,255}));
  connect(truDel7.y, lat.u)
    annotation (Line(points={{-178,-220},{-102,-220}}, color={255,0,255}));
  connect(VOAMin_flow, gai1.u) annotation (Line(points={{-340,-228},{-280,-228},
          {-280,-290},{-262,-290}}, color={0,0,127}));
  connect(VDis_flow, gre.u1) annotation (Line(points={{-340,320},{-300,320},{-300,
          -260},{-202,-260}}, color={0,0,127}));
  connect(gai1.y, gre.u2) annotation (Line(points={{-238,-290},{-220,-290},{-220,
          -268},{-202,-268}}, color={0,0,127}));
  connect(gre.y, truDel1.u)
    annotation (Line(points={{-178,-260},{-162,-260}}, color={255,0,255}));
  connect(truDel1.y, lat.clr) annotation (Line(points={{-138,-260},{-120,-260},{
          -120,-226},{-102,-226}}, color={255,0,255}));
  connect(greThr2.y, logSwi.u2) annotation (Line(points={{-238,-50},{-56,-50},{-56,
          -200},{98,-200}}, color={255,0,255}));
  connect(con.y, logSwi.u1) annotation (Line(points={{22,-160},{60,-160},{60,-192},
          {98,-192}}, color={255,0,255}));
  connect(lat.y, logSwi.u3) annotation (Line(points={{-78,-220},{60,-220},{60,-208},
          {98,-208}}, color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{122,-200},{200,-200},{
          200,-168},{278,-168}}, color={255,0,255}));
  connect(isUno.y, logSwi1.u2) annotation (Line(points={{122,-110},{140,-110},{140,
          -160},{278,-160}}, color={255,0,255}));
  connect(con1.y, logSwi1.u1) annotation (Line(points={{202,-130},{260,-130},{260,
          -152},{278,-152}}, color={255,0,255}));
  connect(logSwi1.y, yFan)
    annotation (Line(points={{302,-160},{340,-160}}, color={255,0,255}));
  connect(VDis_flow, les.u1) annotation (Line(points={{-340,320},{-300,320},{-300,
          -220},{-262,-220}}, color={0,0,127}));

annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-340},{320,340}}),
        graphics={
        Rectangle(
          extent={{-318,318},{138,122}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-152,318},{-24,296}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Discharge airflow setpoint"),
        Rectangle(
          extent={{-318,38},{138,-98}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-10,-72},{106,-88}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Heating coil control"),
        Rectangle(
          extent={{-318,-182},{138,-318}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{10,-290},{126,-306}},
          lineColor={0,0,127},
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
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,136},{-46,122}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-96,-162},{-46,-178}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOAMin_flow"),
        Text(
          extent={{-98,44},{-54,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,166},{-80,156}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-76},{-80,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-98,-46},{-60,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{-100,104},{-80,96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-13.5,4},{13.5,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-87.5,-110}),
        Text(
          extent={{-100,74},{-80,66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_pressureIndependentDamper,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
        Text(
          extent={{68,96},{98,86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDamSet"),
        Text(
          extent={{66,-132},{98,-146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yValSet"),
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
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDis_flow_Set"),
        Text(
          extent={{60,-84},{98,-96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-96,-134},{-70,-146}},
          lineColor={255,127,27},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,196},{-68,186}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,-16},{-68,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{64,-180},{96,-194}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yFan"),
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
          thickness=0.5)}),
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
The heating coil is disabled (<code>yValSet=0</code>).
<ul>
<li>
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yValSet=0</code>).
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>),
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
The fan shall run in deadband and cooling zone state when the discharge airflow rate
<code>VDis_flow</code> is less than the minimum outdoor airflow setpoint <code>VOAMin_flow</code>
for 1 minute, and shall shut off when the <code>VDis_flow</code> is above <code>VOAMin_flow</code>
by 10% for 3 minutes.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling fan, damper and valve position for constant-volume
parallel fan-powered terminal unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for constant-volume parallel fan-powered terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/DamperValves.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValves;
