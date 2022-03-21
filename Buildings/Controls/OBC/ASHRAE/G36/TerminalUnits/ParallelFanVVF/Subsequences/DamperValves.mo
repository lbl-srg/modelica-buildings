within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences;
block DamperValves
  "Output signals for controlling variable-volume parallel fan-powered terminal unit"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Real minRat(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Lowest parallel fan rate when it receives the lowest signal from BAS";
  parameter Real maxRat(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Maximum heating-fan airflow setpoint";
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
    annotation (Placement(transformation(extent={{-380,410},{-340,450}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-380,350},{-340,390}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-380,300},{-340,340}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-380,260},{-340,300}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-380,230},{-340,270}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-380,200},{-340,240}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-380,114},{-340,154}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-380,80},{-340,120}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-380,40},{-340,80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-380,10},{-340,50}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-380,-170},{-340,-130}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-380,-120},{-340,-80}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDis_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{360,390},{400,430}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final max=1,
    final unit="1") "VAV damper position setpoint"
    annotation (Placement(transformation(extent={{360,170},{400,210}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{360,110},{400,150}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValSet(
    final min=0,
    final max=1,
    final unit="1") "Hot water valve position setpoint"
    annotation (Placement(transformation(extent={{360,60},{400,100}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VFan_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Paralle fan flow rate setpoint"
    annotation (Placement(transformation(extent={{360,-200},{400,-160}}),
        iconTransformation(extent={{100,-182},{140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{360,-260},{400,-220}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{-80,310},{-60,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Active airflow setpoint for cooling"
    annotation (Placement(transformation(extent={{-180,360},{-160,380}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Output active cooling airflow according to cooling control signal"
    annotation (Placement(transformation(extent={{100,350},{120,370}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5
    "Airflow setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{40,380},{60,400}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-300,390},{-280,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-240,390},{-220,410}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is cooling state"
    annotation (Placement(transformation(extent={{-240,330},{-220,350}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=dTHys,
    final h=0.5*dTHys)
    "Check if supply air temperature is greater than room temperature"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Calculate temperature difference between AHU supply air and room "
    annotation (Placement(transformation(extent={{-240,250},{-220,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2 "Hot water valve position"
    annotation (Placement(transformation(extent={{300,70},{320,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=V_flow_nominal)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{100,300},{120,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,330},{220,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    if not have_pressureIndependentDamper
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_pressureIndependentDamper
    "Damper position controller"
    annotation (Placement(transformation(extent={{240,330},{260,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{300,180},{320,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=dTDisZonSetMax)
    "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-280,90},{-260,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-200,90},{-180,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr2(
    final t=looHys,
    final h=0.5*looHys)
    "Check if it is heating state"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
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
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conZer3(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Hot water valve position, close the valve when the zone is not in heating state"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=1)
    if have_pressureIndependentDamper
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occ(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-130},{-260,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFan(
    final k=minRat) "Minimum fan rate"
    annotation (Placement(transformation(extent={{-280,-20},{-260,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.5) "Gain factor"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub "Temperature difference deadband"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=floHys)
    "Check if primary discharge airflow rate is below threshold"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Keep true output until condition change"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-180,-160},{-160,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "It is in occupied mode and the zone is in cooling state"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1(
    final h=floHys)
    "Check if primary discharge airflow rate is above threshold"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Parallel fan flow rate setpoint"
    annotation (Placement(transformation(extent={{260,-160},{280,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Fan flow rate setpoint"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 "Ensure positive value"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{200,-60},{220,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooHea "Cooling or heating state"
    annotation (Placement(transformation(extent={{-60,-250},{-40,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "In deadband state"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch                        swi6
    "Parallel fan flow rate setpoint when the zone is in deadband state"
    annotation (Placement(transformation(extent={{220,-250},{240,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre2(
    final h=floHys)
    "Check if primary discharge airflow rate setpoint is below threshold"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Fan rate when zone is in deadband state"
    annotation (Placement(transformation(extent={{160,-220},{180,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaFanRat
    "Parallel fan airflow setpoint when zone is in heating state"
    annotation (Placement(transformation(extent={{40,-360},{60,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2
    "Ensure the fan flow rate setpoint is greater than minimum value"
    annotation (Placement(transformation(extent={{-180,-330},{-160,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-60,-330},{-40,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-390},{-160,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxFan(
    final k=maxRat) "Maximum fan rate"
    annotation (Placement(transformation(extent={{-60,-390},{-40,-370}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{40,-300},{60,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Ensure zero rate when it is not in heating state"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uno(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-280,-410},{-260,-390}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{-180,-450},{-160,-430}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi7
    "Parallel fan flow rate setpoint"
    annotation (Placement(transformation(extent={{320,-190},{340,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{200,210},{220,230}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr3(
    final t=floHys,
    final h=floHys/2)
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{320,-250},{340,-230}})));

equation
  connect(uCoo, lin.u)
    annotation (Line(points={{-360,370},{-182,370}}, color={0,0,127}));
  connect(conZer.y, lin.x1)
    annotation (Line(points={{-278,400},{-260,400},{-260,378},{-182,378}},
      color={0,0,127}));
  connect(conOne.y, lin.x2)
    annotation (Line(points={{-218,400},{-200,400},{-200,366},{-182,366}},
      color={0,0,127}));
  connect(VActCooMax_flow, lin.f2)
    annotation (Line(points={{-360,320},{-200,320},{-200,362},{-182,362}},
      color={0,0,127}));
  connect(uCoo, greThr1.u) annotation (Line(points={{-360,370},{-300,370},{-300,
          340},{-242,340}}, color={0,0,127}));
  connect(and4.y, swi5.u2)
    annotation (Line(points={{-58,320},{0,320},{0,390},{38,390}},
        color={255,0,255}));
  connect(lin.y, swi5.u3)
    annotation (Line(points={{-158,370},{20,370},{20,382},{38,382}},
      color={0,0,127}));
  connect(swi5.y, swi.u1)
    annotation (Line(points={{62,390},{80,390},{80,368},{98,368}},
      color={0,0,127}));
  connect(TSup, sub2.u1)
    annotation (Line(points={{-360,280},{-280,280},{-280,266},{-242,266}},
        color={0,0,127}));
  connect(sub2.y, greThr.u)
    annotation (Line(points={{-218,260},{-202,260}}, color={0,0,127}));
  connect(greThr.y, and4.u2) annotation (Line(points={{-178,260},{-140,260},{-140,
          312},{-82,312}}, color={255,0,255}));
  connect(greThr1.y, and4.u1) annotation (Line(points={{-218,340},{-100,340},{-100,
          320},{-82,320}},     color={255,0,255}));
  connect(greThr1.y, swi.u2) annotation (Line(points={{-218,340},{-100,340},{-100,
          360},{98,360}},  color={255,0,255}));
  connect(VActMin_flow, swi5.u1) annotation (Line(points={{-360,220},{-20,220},{
          -20,398},{38,398}}, color={0,0,127}));
  connect(swi.y, VDis_flow_Set) annotation (Line(points={{122,360},{140,360},{140,
          410},{380,410}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-360,220},{-260,220},{
          -260,374},{-182,374}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-360,220},{80,220},{80,
          352},{98,352}},  color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-360,250},{-280,250},{-280,254},
          {-242,254}}, color={0,0,127}));
  connect(swi2.y, yValSet)
    annotation (Line(points={{322,80},{380,80}},   color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{122,360},{140,360},
          {140,346},{198,346}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{122,310},{180,
          310},{180,334},{198,334}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{222,340},{238,340}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-360,430},{-320,
          430},{-320,286},{198,286}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{122,310},{180,310},
          {180,274},{198,274}}, color={0,0,127}));
  connect(swi3.y, yDamSet)
    annotation (Line(points={{322,190},{380,190}}, color={0,0,127}));
  connect(VDis_flowNor.y, conDam.u_m)
    annotation (Line(points={{222,280},{250,280},{250,328}}, color={0,0,127}));
  connect(TZonHeaSet, addPar.u)
    annotation (Line(points={{-360,100},{-282,100}}, color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1) annotation (Line(points={{-258,170},{-160,
          170},{-160,138},{-142,138}}, color={0,0,127}));
  connect(TSupSet, conTDisHeaSet.f1)
    annotation (Line(points={{-360,134},{-142,134}}, color={0,0,127}));
  connect(uHea, conTDisHeaSet.u) annotation (Line(points={{-360,60},{-310,60},{-310,
          130},{-142,130}},     color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2) annotation (Line(points={{-178,100},{-160,
          100},{-160,126},{-142,126}}, color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2) annotation (Line(points={{-258,100},{-240,
          100},{-240,122},{-142,122}}, color={0,0,127}));
  connect(conTDisHeaSet.y, conVal.u_s) annotation (Line(points={{-118,130},{-80,
          130},{-80,100},{-62,100}},color={0,0,127}));
  connect(TDis, conVal.u_m) annotation (Line(points={{-360,30},{-50,30},{-50,88}},
                 color={0,0,127}));
  connect(uHea, greThr2.u)
    annotation (Line(points={{-360,60},{-282,60}}, color={0,0,127}));
  connect(greThr2.y, swi1.u2)
    annotation (Line(points={{-258,60},{78,60}}, color={255,0,255}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{102,60},{240,60},{240,72},{
          298,72}}, color={0,0,127}));
  connect(conZer3.y, swi2.u1) annotation (Line(points={{-258,170},{20,170},{20,88},
          {298,88}},  color={0,0,127}));
  connect(conTDisHeaSet.y, THeaDisSet)
    annotation (Line(points={{-118,130},{380,130}},color={0,0,127}));
  connect(gai.y, swi3.u3) annotation (Line(points={{222,160},{280,160},{280,182},
          {298,182}}, color={0,0,127}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{262,340},{280,340},{280,182},
          {298,182}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{222,340},{230,340},
          {230,260},{180,260},{180,160},{198,160}}, color={0,0,127}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-258,170},{20,170},{20,198},
          {298,198}},color={0,0,127}));
  connect(minFan.y, gai1.u)
    annotation (Line(points={{-258,-10},{-242,-10}}, color={0,0,127}));
  connect(gai1.y, sub.u2) annotation (Line(points={{-218,-10},{-200,-10},{-200,4},
          {-182,4}},   color={0,0,127}));
  connect(VOAMin_flow, sub.u1) annotation (Line(points={{-360,-100},{-300,-100},
          {-300,16},{-182,16}},   color={0,0,127}));
  connect(sub.y, gre.u1) annotation (Line(points={{-158,10},{-140,10},{-140,-30},
          {-62,-30}}, color={0,0,127}));
  connect(VDis_flow, gre.u2) annotation (Line(points={{-360,430},{-320,430},{-320,
          -38},{-62,-38}}, color={0,0,127}));
  connect(occ.y, isOcc.u2) annotation (Line(points={{-258,-120},{-220,-120},{-220,
          -158},{-182,-158}}, color={255,127,0}));
  connect(uOpeMod, isOcc.u1)
    annotation (Line(points={{-360,-150},{-182,-150}}, color={255,127,0}));
  connect(isOcc.y, and1.u1)
    annotation (Line(points={{-158,-150},{-62,-150}}, color={255,0,255}));
  connect(greThr1.y, and1.u2) annotation (Line(points={{-218,340},{-100,340},{-100,
          -158},{-62,-158}}, color={255,0,255}));
  connect(VOAMin_flow, gre1.u2) annotation (Line(points={{-360,-100},{-300,-100},
          {-300,-68},{-62,-68}}, color={0,0,127}));
  connect(VDis_flow, gre1.u1) annotation (Line(points={{-360,430},{-320,430},{-320,
          -60},{-62,-60}}, color={0,0,127}));
  connect(gre.y, lat.u)
    annotation (Line(points={{-38,-30},{38,-30}},   color={255,0,255}));
  connect(gre1.y, lat.clr) annotation (Line(points={{-38,-60},{0,-60},{0,-36},{38,
          -36}},     color={255,0,255}));
  connect(and1.y, swi4.u2)
    annotation (Line(points={{-38,-150},{258,-150}}, color={255,0,255}));
  connect(VOAMin_flow, sub1.u1) annotation (Line(points={{-360,-100},{-300,-100},
          {-300,-84},{38,-84}},   color={0,0,127}));
  connect(swi.y, sub1.u2) annotation (Line(points={{122,360},{140,360},{140,20},
          {-80,20},{-80,-96},{38,-96}},    color={0,0,127}));
  connect(sub1.y, max1.u2) annotation (Line(points={{62,-90},{80,-90},{80,-76},{
          98,-76}},   color={0,0,127}));
  connect(conZer3.y, max1.u1) annotation (Line(points={{-258,170},{20,170},{20,-64},
          {98,-64}},  color={0,0,127}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{62,-30},{98,-30}},    color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{122,-30},{160,-30},{160,
          -44},{198,-44}},       color={0,0,127}));
  connect(max1.y, mul.u2) annotation (Line(points={{122,-70},{140,-70},{140,-56},
          {198,-56}},        color={0,0,127}));
  connect(mul.y, swi4.u1) annotation (Line(points={{222,-50},{240,-50},{240,-142},
          {258,-142}},       color={0,0,127}));
  connect(VOAMin_flow, gre2.u1) annotation (Line(points={{-360,-100},{-300,-100},
          {-300,-200},{-62,-200}}, color={0,0,127}));
  connect(gre2.y, booToRea1.u)
    annotation (Line(points={{-38,-200},{38,-200}}, color={255,0,255}));
  connect(max1.y, mul1.u1) annotation (Line(points={{122,-70},{140,-70},{140,-204},
          {158,-204}},       color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{62,-200},{120,-200},{120,
          -216},{158,-216}},     color={0,0,127}));
  connect(greThr2.y, cooHea.u2) annotation (Line(points={{-258,60},{-120,60},{-120,
          -248},{-62,-248}},       color={255,0,255}));
  connect(greThr1.y, cooHea.u1) annotation (Line(points={{-218,340},{-100,340},{
          -100,-240},{-62,-240}},color={255,0,255}));
  connect(cooHea.y, not1.u)
    annotation (Line(points={{-38,-240},{38,-240}}, color={255,0,255}));
  connect(mul1.y, swi6.u1) annotation (Line(points={{182,-210},{200,-210},{200,-232},
          {218,-232}},       color={0,0,127}));
  connect(not1.y, swi6.u2)
    annotation (Line(points={{62,-240},{218,-240}}, color={255,0,255}));
  connect(swi6.y, swi4.u3) annotation (Line(points={{242,-240},{250,-240},{250,-158},
          {258,-158}},       color={0,0,127}));
  connect(swi.y, gre2.u2) annotation (Line(points={{122,360},{140,360},{140,20},
          {-80,20},{-80,-208},{-62,-208}},  color={0,0,127}));
  connect(conHal1.y, heaFanRat.x1) annotation (Line(points={{-38,-320},{20,-320},
          {20,-342},{38,-342}}, color={0,0,127}));
  connect(mul1.y, max2.u2) annotation (Line(points={{182,-210},{200,-210},{200,-262},
          {-260,-262},{-260,-326},{-182,-326}},       color={0,0,127}));
  connect(minFan.y, max2.u1) annotation (Line(points={{-258,-10},{-250,-10},{-250,
          -314},{-182,-314}},      color={0,0,127}));
  connect(max2.y, heaFanRat.f1) annotation (Line(points={{-158,-320},{-120,-320},
          {-120,-346},{38,-346}}, color={0,0,127}));
  connect(uHea, heaFanRat.u) annotation (Line(points={{-360,60},{-310,60},{-310,
          -350},{38,-350}},      color={0,0,127}));
  connect(conHal2.y, heaFanRat.x2) annotation (Line(points={{-158,-380},{-120,-380},
          {-120,-354},{38,-354}},       color={0,0,127}));
  connect(maxFan.y, heaFanRat.f2) annotation (Line(points={{-38,-380},{20,-380},
          {20,-358},{38,-358}}, color={0,0,127}));
  connect(greThr2.y, booToRea2.u) annotation (Line(points={{-258,60},{-120,60},{
          -120,-290},{38,-290}},  color={255,0,255}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{62,-290},{140,-290},{140,
          -304},{158,-304}},     color={0,0,127}));
  connect(heaFanRat.y, mul2.u2) annotation (Line(points={{62,-350},{140,-350},{140,
          -316},{158,-316}},     color={0,0,127}));
  connect(mul2.y, swi6.u3) annotation (Line(points={{182,-310},{210,-310},{210,-248},
          {218,-248}},       color={0,0,127}));
  connect(uno.y, isUno.u1) annotation (Line(points={{-258,-400},{-220,-400},{-220,
          -440},{-182,-440}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-360,-150},{-320,-150},{-320,
          -448},{-182,-448}}, color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{-158,-440},{130,-440},{130,
          80},{298,80}}, color={255,0,255}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{-158,-440},{130,-440},{130,
          190},{298,190}}, color={255,0,255}));
  connect(isUno.y, swi7.u2) annotation (Line(points={{-158,-440},{130,-440},{130,
          -180},{318,-180}}, color={255,0,255}));
  connect(swi4.y, swi7.u3) annotation (Line(points={{282,-150},{300,-150},{300,-188},
          {318,-188}}, color={0,0,127}));
  connect(conZer3.y, swi7.u1) annotation (Line(points={{-258,170},{20,170},{20,-172},
          {318,-172}}, color={0,0,127}));
  connect(swi7.y, VFan_flow_Set)
    annotation (Line(points={{342,-180},{380,-180}}, color={0,0,127}));
  connect(isUno.y, not2.u) annotation (Line(points={{-158,-440},{130,-440},{130,
          220},{198,220}}, color={255,0,255}));
  connect(not2.y, conDam.trigger) annotation (Line(points={{222,220},{244,220},{
          244,328}}, color={255,0,255}));
  connect(greThr2.y, conVal.trigger)
    annotation (Line(points={{-258,60},{-56,60},{-56,88}}, color={255,0,255}));
  connect(swi7.y, greThr3.u) annotation (Line(points={{342,-180},{350,-180},{350,
          -220},{300,-220},{300,-240},{318,-240}}, color={0,0,127}));
  connect(greThr3.y, yFan)
    annotation (Line(points={{342,-240},{380,-240}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,100},{0,100},{0,68},{
          78,68}}, color={0,0,127}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-258,170},{20,170},{20,52},
          {78,52}}, color={0,0,127}));

annotation (
  defaultComponentName="damValFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-340,-460},{360,460}}),
        graphics={
        Rectangle(
          extent={{-338,438},{118,222}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-74,264},{104,222}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Primary discharge airflow setpoint
and the damper position setpoint"),
        Rectangle(
          extent={{-338,178},{118,22}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-38,168},{106,140}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Hot water valve position"),
        Rectangle(
          extent={{-336,18},{118,-158}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-270,-84},{-94,-110}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in cooling state"),
        Rectangle(
          extent={{-336,-162},{118,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-298,-210},{-110,-236}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in deadband state"),
        Rectangle(
          extent={{-336,-264},{118,-398}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-302,-270},{-128,-294}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Parallel fan rate when in heating state")}),
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
          extent={{-98,-76},{-76,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-96,-46},{-58,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{-100,106},{-80,96}},
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
          extent={{-100,76},{-78,66}},
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
          extent={{68,-112},{98,-124}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yValSet"),
        Line(points={{-38,64},{-38,-48},{74,-48}}, color={95,95,95}),
        Line(
          points={{-16,60},{10,-48}},
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
          extent={{54,-84},{98,-96}},
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
          extent={{-100,-14},{-68,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{42,-152},{98,-168}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VFan_flow_Set"),
        Line(
          points={{-38,-22},{26,-22},{78,60}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-16,-6},{-38,26}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-16,60},{-38,60}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-16,-6},{26,-6}},
          color={28,108,200},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(
          points={{26,-6},{36,-28},{40,-28},{40,-48}},
          color={28,108,200},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Text(
          extent={{64,-180},{96,-194}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yFan")}),
  Documentation(info="<html>
<p>
This sequence sets the parallel fan flow rate setpoint, damper and valve position for
variable-volume parallel fan-powered terminal unit.
The implementation is according to Section 5.8.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the primary airflow
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
the primary airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yValSet=0</code>).
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>),
<ul>
<li>
As the heating-loop output <code>uHea</code> increases from 0% to 50%, it shall reset
the discharge temperature <code>THeaDisSet</code> from the current AHU setpoint
temperature <code>TSupSet</code> to a maximum of <code>dTDisZonSetMax</code>
above space temperature setpoint.
</li>
<li>
The primary airflow setpoint shall be the minimum flow <code>VActMin_flow</code>.
</li>
<li>
The heating coil shall be modulated to maintain the discharge temperature at setpoint.
</li>
</ul>
</li>
<li>
The VAV damper shall be modulated by a control loop to maintain the measured primary
airflow at the setpoint.
</li>
<li>
Fan control
<ul>
<li>
When the zone stats is cooling (<code>uCoo &gt; 0</code>), in occupied mode only, the
parallel fan starts when primary airflow (<code>VDis_flow</code>) drops below the
minimum airflow outdoor airflow <code>VOAMin_flow</code> minus half of the minium fan
rate <code>minRat</code> and shuts off when primary airflow rises above the
<code>VOAMin_flow</code>.
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), the
parallel fan starts when primary airflow (<code>VDis_flow</code>) is below the
minimum airflow outdoor airflow <code>VOAMin_flow</code>. The fan flow rate setpoint
is equal to <code>VOAMin_flow</code> minus the current primary airflow setpoint
<code>VDis_flow_Set</code>.
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>), fan shall run. As the
heating-loop output <code>uHea</code> increases from 50% to 100%, it shall reset
the fan airflow setpoint from the setpoint required in deadband proportionally
up to the maximum heating-fan airflow setpoint <code>maxRat</code>.
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
end DamperValves;
