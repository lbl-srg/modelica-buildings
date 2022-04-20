within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences;
block DamperValves
  "Output signals for controlling variable-volume series fan-powered terminal unit"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint";
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
  parameter Boolean have_preIndDam = true
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
    annotation(Dialog(group="Damper", enable=not have_preIndDam));
  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper", enable=not have_preIndDam));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=not have_preIndDam
           and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=not have_preIndDam
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
  parameter Real damPosHys(
    final unit="m3/s") = 0.05
    "Hysteresis for checking damper position"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
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
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-380,80},{-340,120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-380,40},{-340,80}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-380,10},{-340,50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOAMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-380,-100},{-340,-60}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-380,-310},{-340,-270}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-380,-350},{-340,-310}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam_actual(
    final min=0,
    final unit="1")
    "Actual damper position"
    annotation (Placement(transformation(extent={{-380,-400},{-340,-360}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VPri_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint"
    annotation (Placement(transformation(extent={{360,390},{400,430}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final max=1,
    final unit="1") "VAV damper commanded position"
    annotation (Placement(transformation(extent={{360,150},{400,190}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaDisSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Discharge airflow setpoint temperature for heating"
    annotation (Placement(transformation(extent={{360,110},{400,150}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final max=1,
    final unit="1") "Hot water valve commanded position"
    annotation (Placement(transformation(extent={{360,60},{400,100}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VFan_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Series fan flow rate setpoint"
    annotation (Placement(transformation(extent={{360,-140},{400,-100}}),
        iconTransformation(extent={{100,-182},{140,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{360,-400},{400,-360}}),
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
  Buildings.Controls.OBC.CDL.Continuous.Divide VPri_flowNor
    if not have_preIndDam
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{200,270},{220,290}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conDam(
    final controllerType=controllerTypeDam,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final yMax=1,
    final yMin=0,
    final y_reset=0) if not have_preIndDam
    "Damper position controller"
    annotation (Placement(transformation(extent={{240,330},{260,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 "Air damper position"
    annotation (Placement(transformation(extent={{260,180},{280,200}})));
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
    if have_preIndDam
    "Block that can be disabled so remove the connection"
    annotation (Placement(transformation(extent={{200,150},{220,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line heaFanRat
    "Parallel fan airflow setpoint when zone is in heating state"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal1(
    final k=0.5)
    "Constant real value"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conHal2(
    final k=1)
    "Constant real value"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxFan(
    final k=maxRat) "Maximum fan rate"
    annotation (Placement(transformation(extent={{-20,-230},{0,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant uno(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno
    "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not in unoccupied mode"
    annotation (Placement(transformation(extent={{200,210},{220,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Fan setpoint when it is in cooling state and the supply air temperture is high"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Larger of minimum outdoor airflow setpoint and primary discharge airflow setpoint"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi6
    "Fan setpoint when it is in cooling state"
    annotation (Placement(transformation(extent={{240,-70},{260,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or cooHea
    "Cooling or heating state"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "In deadband state"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi7
    "Fan setpoint when it is in deadband state"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi8
    "Fan setpoint when it is in heating state"
    annotation (Placement(transformation(extent={{100,-250},{120,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cloDam(
    final t=damPosHys,
    final h=damPosHys/2)
    "Check if the damper is fully closed before turning on fan"
    annotation (Placement(transformation(extent={{-280,-390},{-260,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=15)
    "Check if the fan has been proven on for a fixed time"
    annotation (Placement(transformation(extent={{-280,-340},{-260,-320}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occ(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Constant signal for occupied mode"
    annotation (Placement(transformation(extent={{-280,-280},{-260,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isOcc
    "Output true if the operation mode is occupied"
    annotation (Placement(transformation(extent={{-220,-280},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if it is in heating, cooling state, or it is in occupied mode"
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge"
    annotation (Placement(transformation(extent={{20,-320},{40,-300}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the fan can turn on"
    annotation (Placement(transformation(extent={{20,-390},{40,-370}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg
    "Falling edge"
    annotation (Placement(transformation(extent={{20,-430},{40,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    "Hold fan on status"
    annotation (Placement(transformation(extent={{80,-390},{100,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat "Close damper"
    annotation (Placement(transformation(extent={{80,-320},{100,-300}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=0,
    final realFalse=1)
    "Boolean to real"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Ensure damper is fully closed before turning on the fan"
    annotation (Placement(transformation(extent={{320,160},{340,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to real"
    annotation (Placement(transformation(extent={{160,-362},{180,-342}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Ensure damper is fully closed before turning on the fan"
    annotation (Placement(transformation(extent={{320,-130},{340,-110}})));

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
  connect(swi.y, VPri_flow_Set) annotation (Line(points={{122,360},{140,360},{140,
          410},{380,410}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-360,220},{-260,220},{
          -260,374},{-182,374}}, color={0,0,127}));
  connect(VActMin_flow, swi.u3) annotation (Line(points={{-360,220},{80,220},{80,
          352},{98,352}},  color={0,0,127}));
  connect(TZon, sub2.u2) annotation (Line(points={{-360,250},{-280,250},{-280,254},
          {-242,254}}, color={0,0,127}));
  connect(swi2.y, yVal)
    annotation (Line(points={{322,80},{380,80}},   color={0,0,127}));
  connect(swi.y, VDisSet_flowNor.u1) annotation (Line(points={{122,360},{140,360},
          {140,346},{198,346}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{122,310},{180,
          310},{180,334},{198,334}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conDam.u_s)
    annotation (Line(points={{222,340},{238,340}}, color={0,0,127}));
  connect(VPri_flow, VPri_flowNor.u1) annotation (Line(points={{-360,430},{-320,
          430},{-320,286},{198,286}}, color={0,0,127}));
  connect(nomFlow.y, VPri_flowNor.u2) annotation (Line(points={{122,310},{180,310},
          {180,274},{198,274}}, color={0,0,127}));
  connect(VPri_flowNor.y, conDam.u_m)
    annotation (Line(points={{222,280},{250,280},{250,328}}, color={0,0,127}));
  connect(THeaSet, addPar.u)
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
  connect(gai.y, swi3.u3) annotation (Line(points={{222,160},{240,160},{240,182},
          {258,182}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, gai.u) annotation (Line(points={{222,340},{230,340},
          {230,260},{180,260},{180,160},{198,160}}, color={0,0,127}));
  connect(conZer3.y, swi3.u1) annotation (Line(points={{-258,170},{20,170},{20,198},
          {258,198}},color={0,0,127}));
  connect(conHal1.y, heaFanRat.x1) annotation (Line(points={{2,-160},{20,-160},{
          20,-182},{38,-182}},  color={0,0,127}));
  connect(uHea, heaFanRat.u) annotation (Line(points={{-360,60},{-310,60},{-310,
          -190},{38,-190}},      color={0,0,127}));
  connect(conHal2.y, heaFanRat.x2) annotation (Line(points={{-158,-220},{-120,-220},
          {-120,-194},{38,-194}},       color={0,0,127}));
  connect(maxFan.y, heaFanRat.f2) annotation (Line(points={{2,-220},{20,-220},{20,
          -198},{38,-198}},     color={0,0,127}));
  connect(uno.y, isUno.u1) annotation (Line(points={{-58,-270},{18,-270}},
                              color={255,127,0}));
  connect(isUno.y, swi2.u2) annotation (Line(points={{42,-270},{130,-270},{130,80},
          {298,80}},     color={255,0,255}));
  connect(isUno.y, swi3.u2) annotation (Line(points={{42,-270},{130,-270},{130,190},
          {258,190}},      color={255,0,255}));
  connect(isUno.y, not2.u) annotation (Line(points={{42,-270},{130,-270},{130,220},
          {198,220}},      color={255,0,255}));
  connect(not2.y, conDam.trigger) annotation (Line(points={{222,220},{244,220},{
          244,328}}, color={255,0,255}));
  connect(greThr2.y, conVal.trigger)
    annotation (Line(points={{-258,60},{-56,60},{-56,88}}, color={255,0,255}));
  connect(conVal.y, swi1.u1) annotation (Line(points={{-38,100},{-20,100},{-20,68},
          {78,68}}, color={0,0,127}));
  connect(conZer3.y, swi1.u3) annotation (Line(points={{-258,170},{20,170},{20,52},
          {78,52},{78,52}}, color={0,0,127}));
  connect(and4.y, swi4.u2) annotation (Line(points={{-58,320},{0,320},{0,-20},{38,
          -20}}, color={255,0,255}));
  connect(VOAMin_flow, swi4.u1) annotation (Line(points={{-360,-80},{-300,-80},{
          -300,-12},{38,-12}}, color={0,0,127}));
  connect(swi.y, max1.u1) annotation (Line(points={{122,360},{140,360},{140,20},
          {-200,20},{-200,-34},{-162,-34}}, color={0,0,127}));
  connect(VOAMin_flow, max1.u2) annotation (Line(points={{-360,-80},{-300,-80},{
          -300,-46},{-162,-46}}, color={0,0,127}));
  connect(max1.y, swi4.u3) annotation (Line(points={{-138,-40},{20,-40},{20,-28},
          {38,-28}}, color={0,0,127}));
  connect(swi4.y, swi6.u1) annotation (Line(points={{62,-20},{220,-20},{220,-52},
          {238,-52}}, color={0,0,127}));
  connect(greThr1.y, swi6.u2) annotation (Line(points={{-218,340},{-100,340},{-100,
          -60},{238,-60}}, color={255,0,255}));
  connect(greThr1.y, cooHea.u2) annotation (Line(points={{-218,340},{-100,340},{
          -100,-128},{-2,-128}}, color={255,0,255}));
  connect(greThr2.y, cooHea.u1) annotation (Line(points={{-258,60},{-56,60},{-56,
          -120},{-2,-120}}, color={255,0,255}));
  connect(cooHea.y, not1.u)
    annotation (Line(points={{22,-120},{58,-120}}, color={255,0,255}));
  connect(not1.y, swi7.u2) annotation (Line(points={{82,-120},{100,-120},{100,-100},
          {178,-100}}, color={255,0,255}));
  connect(swi7.y, swi6.u3) annotation (Line(points={{202,-100},{220,-100},{220,-68},
          {238,-68}}, color={0,0,127}));
  connect(VOAMin_flow, swi7.u1) annotation (Line(points={{-360,-80},{60,-80},{60,
          -92},{178,-92}}, color={0,0,127}));
  connect(VOAMin_flow, heaFanRat.f1) annotation (Line(points={{-360,-80},{-300,-80},
          {-300,-186},{38,-186}}, color={0,0,127}));
  connect(heaFanRat.y, swi8.u1) annotation (Line(points={{62,-190},{80,-190},{80,
          -232},{98,-232}}, color={0,0,127}));
  connect(greThr2.y, swi8.u2) annotation (Line(points={{-258,60},{-56,60},{-56,-240},
          {98,-240}}, color={255,0,255}));
  connect(VOAMin_flow, swi8.u3) annotation (Line(points={{-360,-80},{-300,-80},{
          -300,-248},{98,-248}}, color={0,0,127}));
  connect(swi8.y, swi7.u3) annotation (Line(points={{122,-240},{160,-240},{160,-108},
          {178,-108}}, color={0,0,127}));
  connect(occ.y, isOcc.u1)
    annotation (Line(points={{-258,-270},{-222,-270}}, color={255,127,0}));
  connect(uOpeMod, isOcc.u2) annotation (Line(points={{-360,-290},{-240,-290},{-240,
          -278},{-222,-278}}, color={255,127,0}));
  connect(uOpeMod, isUno.u2) annotation (Line(points={{-360,-290},{0,-290},{0,-278},
          {18,-278}}, color={255,127,0}));
  connect(greThr1.y, or3.u1) annotation (Line(points={{-218,340},{-100,340},{-100,
          -302},{-62,-302}}, color={255,0,255}));
  connect(greThr2.y, or3.u2) annotation (Line(points={{-258,60},{-110,60},{-110,
          -310},{-62,-310}}, color={255,0,255}));
  connect(isOcc.y, or3.u3) annotation (Line(points={{-198,-270},{-120,-270},{-120,
          -318},{-62,-318}}, color={255,0,255}));
  connect(or3.y, edg.u)
    annotation (Line(points={{-38,-310},{18,-310}}, color={255,0,255}));
  connect(edg.y, lat.u)
    annotation (Line(points={{42,-310},{78,-310}}, color={255,0,255}));
  connect(lat.y, booToRea.u)
    annotation (Line(points={{102,-310},{158,-310}}, color={255,0,255}));
  connect(u1Fan, tim.u)
    annotation (Line(points={{-360,-330},{-282,-330}}, color={255,0,255}));
  connect(tim.passed, lat.clr) annotation (Line(points={{-258,-338},{60,-338},{60,
          -316},{78,-316}}, color={255,0,255}));
  connect(uDam_actual, cloDam.u)
    annotation (Line(points={{-360,-380},{-282,-380}}, color={0,0,127}));
  connect(cloDam.y, and2.u1)
    annotation (Line(points={{-258,-380},{18,-380}}, color={255,0,255}));
  connect(or3.y, and2.u2) annotation (Line(points={{-38,-310},{0,-310},{0,-388},
          {18,-388}}, color={255,0,255}));
  connect(or3.y, falEdg.u) annotation (Line(points={{-38,-310},{0,-310},{0,-420},
          {18,-420}}, color={255,0,255}));
  connect(and2.y, lat1.u)
    annotation (Line(points={{42,-380},{78,-380}}, color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{42,-420},{60,-420},{60,-386},
          {78,-386}}, color={255,0,255}));
  connect(conDam.y, swi3.u3) annotation (Line(points={{262,340},{280,340},{280,210},
          {240,210},{240,182},{258,182}}, color={0,0,127}));
  connect(swi3.y, mul.u1) annotation (Line(points={{282,190},{300,190},{300,176},
          {318,176}}, color={0,0,127}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{182,-310},{280,-310},{280,
          164},{318,164}}, color={0,0,127}));
  connect(mul.y, yDam)
    annotation (Line(points={{342,170},{380,170}}, color={0,0,127}));
  connect(lat1.y, y1Fan)
    annotation (Line(points={{102,-380},{380,-380}}, color={255,0,255}));
  connect(lat1.y, booToRea1.u) annotation (Line(points={{102,-380},{140,-380},{140,
          -352},{158,-352}}, color={255,0,255}));
  connect(swi6.y, mul1.u1) annotation (Line(points={{262,-60},{300,-60},{300,-114},
          {318,-114}}, color={0,0,127}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{182,-352},{300,-352},{
          300,-126},{318,-126}}, color={0,0,127}));
  connect(mul1.y, VFan_flow_Set)
    annotation (Line(points={{342,-120},{380,-120}}, color={0,0,127}));

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
          extent={{-336,-4},{118,-78}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-288,-48},{-112,-74}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in cooling state"),
        Rectangle(
          extent={{-336,-82},{118,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-300,-86},{-112,-112}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in deadband state"),
        Rectangle(
          extent={{-336,-142},{118,-258}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-292,-142},{-118,-166}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan rate when in heating state"),
        Rectangle(
          extent={{-336,-282},{118,-438}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-296,-406},{-122,-430}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Series fan command on setpoint")}),
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
          extent={{-96,-102},{-46,-118}},
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
          extent={{-98,-46},{-76,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,-16},{-62,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
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
          origin={-87.5,-80}),
        Text(
          extent={{-100,76},{-78,66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_preIndDam,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VPri_flow"),
        Text(
          extent={{68,96},{98,86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDam"),
        Text(
          extent={{68,-112},{98,-124}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal"),
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
          textString="VPri_flow_Set"),
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
          textString="VPri_flow"),
        Text(
          extent={{-100,16},{-68,6}},
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
          textString="y1Fan"),
        Text(
          extent={{-98,-160},{-74,-174}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="u1Fan"),
        Text(
          extent={{-98,-184},{-44,-196}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam_actual")}),
  Documentation(info="<html>
<p>
This sequence sets the series fan flow rate setpoint, damper and valve position for
variable-volume series fan-powered terminal unit.
The implementation is according to Section 5.10.5 of ASHRAE Guideline 36, May 2020. The
calculation is done following the steps below.
</p>
<ol>
<li>
When the zone state is cooling (<code>uCoo &gt; 0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the primary airflow
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
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the primary airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
The heating coil is disabled (<code>yVal=0</code>).
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
Fan shall run whenever zone state is heating or cooling state, or if the associated
zone group is in occupied mode. Prior to starting fan, the damper is first driven
fully closed to ensure that the fan is not rotating backward. Once the fan is
proven on (<code>u1Fan=true</code>) for a fixed time delay (15 seconds), the damper
override is released.
</li>
<li>
When the zone stats is cooling (<code>uCoo &gt; 0</code>), the series fan airflow setpoint
shall be the larger of <code>VOAMin_flow</code> and the <code>VPri_flow_Set</code>.
If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, the series fan airflow setpoint shall be no higher
than <code>VOAMin_flow</code>.
</li>
<li>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>),
the series fan airflow setpoint shall be equal to <code>VOAMin_flow</code>.
</li>
<li>
When the zone state is Heating (<code>uHea &gt; 0</code>), as the
heating-loop output <code>uHea</code> increases from 50% to 100%, it shall reset
the series fan airflow setpoint from <code>VOAMin_flow</code> to the maximum heating-fan
airflow setpoint <code>maxRat</code>.
</li>
</ul>
</li>
</ol>
<p>The sequences of controlling fan, damper and valve position for variable-volume
series fan-powered terminal unit are described in the following figure below.</p>
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
