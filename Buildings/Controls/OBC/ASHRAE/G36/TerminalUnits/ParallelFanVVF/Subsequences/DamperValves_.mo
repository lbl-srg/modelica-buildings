within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences;
block DamperValves_
  "Output signals for controlling variable-volume parallel fan-powered terminal unit"

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
    final quantity="VolumeFlowRate") if not have_pressureIndependentDamper
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
    "Supply air temperature from central air handler"
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
    annotation (Placement(transformation(extent={{-360,-280},{-320,-240}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-360,-230},{-320,-190}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDisSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Discharge airflow setpoint"
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

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{120,240},{140,260}})));
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
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{280,-40},{300,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{280,70},{300,90}})));

  CDL.Continuous.Line                        conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.AddParameter                        addPar(final p=
        dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-20},{-240,0}})));
  CDL.Continuous.Sources.Constant                        conHal(final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  CDL.Continuous.GreaterThreshold                        greThr2(final t=looHys,
      final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  CDL.Continuous.PIDWithReset                        conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Continuous.Sources.Constant                        conZer3(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  CDL.Continuous.Switch                        swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  CDL.Continuous.MultiplyByParameter                        gai(final k=1)
    if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));
  CDL.Integers.Sources.Constant occ(final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-260,-240},{-240,-220}})));
  CDL.Continuous.Sources.Constant minFan(final k=minRat) "Minimum fan rate"
    annotation (Placement(transformation(extent={{-260,-130},{-240,-110}})));
  CDL.Continuous.MultiplyByParameter gai1(final k=0.5) "Gain factor"
    annotation (Placement(transformation(extent={{-220,-130},{-200,-110}})));
  CDL.Continuous.Subtract sub "Temperature difference deadband"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  CDL.Continuous.Greater gre(final h=floHys)
    "Check if primary discharge airflow rate is below threshold"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{60,-150},{80,-130}})));
  CDL.Integers.Equal                        isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-160,-270},{-140,-250}})));
  CDL.Logical.And                        and1
    "It is in occupied mode and the zone is in cooling state"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));
  CDL.Continuous.Greater gre1(final h=floHys)
    "Check if primary discharge airflow rate is above threshold"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  CDL.Continuous.Switch                        swi4
    "Parallel fan flow rate setpoint"
    annotation (Placement(transformation(extent={{280,-270},{300,-250}})));
  CDL.Continuous.Subtract sub1 "Fan flow rate setpoint"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  CDL.Continuous.Max max1 "Ensure positive value"
    annotation (Placement(transformation(extent={{120,-190},{140,-170}})));
  CDL.Conversions.BooleanToReal booToRea "Convert boolean to real"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  CDL.Logical.Or cooHea "Cooling or heating state"
    annotation (Placement(transformation(extent={{-40,-360},{-20,-340}})));
  CDL.Logical.Not not1 "In deadband state"
    annotation (Placement(transformation(extent={{60,-360},{80,-340}})));
  CDL.Continuous.Switch                        swi6
    "Parallel fan flow rate setpoint when the zone is in deadband state"
    annotation (Placement(transformation(extent={{240,-360},{260,-340}})));
  CDL.Continuous.Greater gre2(final h=floHys)
    "Check if primary discharge airflow rate is below threshold"
    annotation (Placement(transformation(extent={{-40,-320},{-20,-300}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert boolean to real"
    annotation (Placement(transformation(extent={{60,-320},{80,-300}})));
  CDL.Continuous.Multiply mul1
    annotation (Placement(transformation(extent={{180,-320},{200,-300}})));
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
    annotation (Line(points={{82,280},{100,280},{100,258},{118,258}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-340,170},{-260,170},{-260,156},{-222,156}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-198,150},{-182,150}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-158,150},{-120,150},{
          -120,202},{-62,202}},
                           color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-198,230},{-80,230},{-80,
          210},{-62,210}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-198,230},{-80,230},{-80,
          250},{118,250}}, color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-340,110},{0,110},{0,
          288},{58,288}}, color={0,0,127}));
  connect(swi.y, VDisSet_flow) annotation (Line(points={{142,250},{160,250},{
          160,300},{340,300}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-340,110},{-240,110},{
          -240,264},{-162,264}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-340,110},{100,110},{
          100,242},{118,242}},
                           color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-340,140},{-260,140},{-260,
          144},{-222,144}},
                       color={0,0,127}));
  connect(swi2.y, yValSet)
    annotation (Line(points={{302,-30},{340,-30}}, color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{142,250},{160,
          250},{160,236},{218,236}},
                                color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{142,200},{
          200,200},{200,224},{218,224}},
                                     color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{242,230},{258,230}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-340,320},{-300,
          320},{-300,176},{218,176}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{142,200},{200,
          200},{200,164},{218,164}},
                                color={0,0,127}));
  connect(swi3.y, yDamSet)
    annotation (Line(points={{302,80},{340,80}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{242,170},{270,170},{270,218}}, color={0,0,127}));

  connect(TZonHeaSet, addPar.u)
    annotation (Line(points={{-340,-10},{-262,-10}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-238,60},{-140,
          60},{-140,28},{-122,28}}, color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-340,24},{-122,24}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-340,-50},{-280,-50},
          {-280,20},{-122,20}}, color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-158,-10},{-140,
          -10},{-140,16},{-122,16}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-238,-10},{-220,
          -10},{-220,12},{-122,12}}, color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-98,20},{-60,
          20},{-60,-10},{-42,-10}}, color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-340,-80},{-30,-80},{-30,
          -22}}, color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-340,-50},{-262,-50}}, color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-238,-50},{98,-50}}, color={255,0,255}));
  connect(conZer3.y, swi1.u1) annotation (Line(points={{-238,60},{40,60},{40,
          -42},{98,-42}}, color={0,0,127}));
  connect(conVal.y, swi1.u3) annotation (Line(points={{-18,-10},{20,-10},{20,
          -58},{98,-58}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{122,-50},{260,-50},{260,
          -38},{278,-38}}, color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-238,60},{40,60},{40,
          -22},{278,-22}}, color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-98,20},{340,20}}, color={0,0,127}));
  connect(gai.y, swi3.u3) annotation (Line(points={{242,50},{260,50},{260,72},{
          278,72}}, color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{282,230},{300,230},{300,
          140},{260,140},{260,72},{278,72}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{242,230},{250,230},
          {250,150},{200,150},{200,50},{218,50}}, color={0,0,127}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-238,60},{40,60},{40,88},
          {278,88}}, color={0,0,127}));
  connect(minFan.y, gai1.u)
    annotation (Line(points={{-238,-120},{-222,-120}}, color={0,0,127}));
  connect(gai1.y, sub.u2) annotation (Line(points={{-198,-120},{-180,-120},{
          -180,-106},{-162,-106}}, color={0,0,127}));
  connect(VOAMin_flow, sub.u1) annotation (Line(points={{-340,-210},{-280,-210},
          {-280,-94},{-162,-94}}, color={0,0,127}));
  connect(sub.y, gre.u1) annotation (Line(points={{-138,-100},{-120,-100},{-120,
          -140},{-42,-140}}, color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-340,320},{-300,320},{
          -300,-148},{-42,-148}}, color={0,0,127}));
  connect(occ.y, isOcc.u2) annotation (Line(points={{-238,-230},{-200,-230},{
          -200,-268},{-162,-268}}, color={255,127,0}));
  connect(uOpeMod, isOcc.u1)
    annotation (Line(points={{-340,-260},{-162,-260}}, color={255,127,0}));
  connect(isOcc.y, and1.u1)
    annotation (Line(points={{-138,-260},{-42,-260}}, color={255,0,255}));
  connect(greThr1.y, and1.u2) annotation (Line(points={{-198,230},{-80,230},{
          -80,-268},{-42,-268}}, color={255,0,255}));
  connect(VOAMin_flow, gre1.u2) annotation (Line(points={{-340,-210},{-280,-210},
          {-280,-178},{-42,-178}}, color={0,0,127}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-340,320},{-300,320},{
          -300,-170},{-42,-170}}, color={0,0,127}));
  connect(gre.y, lat.u)
    annotation (Line(points={{-18,-140},{58,-140}}, color={255,0,255}));
  connect(gre1.y, lat.clr) annotation (Line(points={{-18,-170},{20,-170},{20,
          -146},{58,-146}}, color={255,0,255}));
  connect(and1.y, swi4.u2)
    annotation (Line(points={{-18,-260},{278,-260}}, color={255,0,255}));
  connect(VOAMin_flow, sub1.u1) annotation (Line(points={{-340,-210},{-280,-210},
          {-280,-194},{58,-194}}, color={0,0,127}));
  connect(swi.y, sub1.u2) annotation (Line(points={{142,250},{160,250},{160,-90},
          {-60,-90},{-60,-206},{58,-206}}, color={0,0,127}));
  connect(sub1.y, max1.u2) annotation (Line(points={{82,-200},{100,-200},{100,
          -186},{118,-186}}, color={0,0,127}));
  connect(conZer3.y, max1.u1) annotation (Line(points={{-238,60},{40,60},{40,
          -174},{118,-174}}, color={0,0,127}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{82,-140},{118,-140}}, color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{142,-140},{160,-140},{
          160,-154},{178,-154}}, color={0,0,127}));
  connect(max1.y, mul.u2) annotation (Line(points={{142,-180},{160,-180},{160,
          -166},{178,-166}}, color={0,0,127}));
  connect(mul.y, swi4.u1) annotation (Line(points={{202,-160},{220,-160},{220,
          -252},{278,-252}}, color={0,0,127}));
  connect(VOAMin_flow, gre2.u1) annotation (Line(points={{-340,-210},{-280,-210},
          {-280,-310},{-42,-310}}, color={0,0,127}));
  connect(VDis_flow, gre2.u2) annotation (Line(points={{-340,320},{-300,320},{
          -300,-318},{-42,-318}}, color={0,0,127}));
  connect(gre2.y, booToRea1.u)
    annotation (Line(points={{-18,-310},{58,-310}}, color={255,0,255}));
  connect(max1.y, mul1.u1) annotation (Line(points={{142,-180},{160,-180},{160,
          -304},{178,-304}}, color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{82,-310},{140,-310},{
          140,-316},{178,-316}}, color={0,0,127}));
  connect(greThr2.y, cooHea.u2) annotation (Line(points={{-238,-50},{-100,-50},
          {-100,-358},{-42,-358}}, color={255,0,255}));
  connect(greThr1.y, cooHea.u1) annotation (Line(points={{-198,230},{-80,230},{
          -80,-350},{-42,-350}}, color={255,0,255}));
  connect(cooHea.y, not1.u)
    annotation (Line(points={{-18,-350},{58,-350}}, color={255,0,255}));
  connect(mul1.y, swi6.u1) annotation (Line(points={{202,-310},{220,-310},{220,
          -342},{238,-342}}, color={0,0,127}));
  connect(not1.y, swi6.u2)
    annotation (Line(points={{82,-350},{238,-350}}, color={255,0,255}));
  connect(swi6.y, swi4.u3) annotation (Line(points={{262,-350},{270,-350},{270,
          -268},{278,-268}}, color={0,0,127}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-340},{320,340}})),
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
          pattern=LinePattern.Dash),
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
          textString="VDisSet_flow"),
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
          pattern=LinePattern.Dash),
        Line(points={{10,-2},{44,-2},{44,-48}}, color={28,108,200})}),
  Documentation(info="<html>
<p>
This sequence sets the fan status, damper and valve position for constant-volume fan-powered
terminal unit.
The implementation is according to Section 5.7.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo>0</code>), then the cooling loop output
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
When the zone state is Heating (<code>uHea>0</code>),
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
<p>The sequences of controlling damper and valve position for VAV reheat terminal
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for VAV reheat terminal unit\"
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
end DamperValves_;
