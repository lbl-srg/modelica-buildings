within Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints;
block ZoneTSet "Block outputs thermal zone cooling and heating setpoint"

  parameter Modelica.SIunits.Temperature TCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Modelica.SIunits.Temperature TCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Modelica.SIunits.Temperature THeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Modelica.SIunits.Temperature THeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation(Dialog(group="Setpoints limits setting"));
  parameter Modelica.SIunits.Temperature TCooWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation(Dialog(group="Setpoints limits setting", enable=winStaSen));
  parameter Modelica.SIunits.Temperature THeaWinOpe=277.15
    "Heating setpoint when window is open"
    annotation(Dialog(group="Setpoints limits setting", enable=winStaSen));
  parameter Boolean cooAdj = false
    "Check if both cooling and heating setpoint are adjustable separately"
    annotation(Dialog(group="Setpoint adjustable setting"));
  parameter Boolean heaAdj = cooAdj
    "Heating setpoint adjustable"
    annotation(Dialog(group="Setpoint adjustable setting",enable=false));
  parameter Boolean sinAdj = false
    "Check if both cooling and heating setpoint are adjustable through a single common knob"
    annotation(Dialog(group="Setpoint adjustable setting",enable=not (cooAdj or heaAdj)));
  parameter Boolean ignDemLim = true
    "Exempt individual zone from demand limit setpoint adjustment, exempt=true"
    annotation(Dialog(group="Setpoint adjustable setting"));
  parameter Boolean occSen = false
    "Check if the zone has occupancy sensor"
    annotation(Dialog(group="Sensors"));
  parameter Boolean winStaSen = false
    "Check if the zone has window status sensor"
    annotation(Dialog(group="Sensors"));
  parameter Real incSetDem_1=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));
  parameter Real incSetDem_2=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));
  parameter Real incSetDem_3=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));
  parameter Real decSetDem_1=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));
  parameter Real decSetDem_2=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));
  parameter Real decSetDem_3=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation(Dialog(group="Setpoint adjustment", tab="Demand Settings"));

  CDL.Interfaces.RealInput occCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-460,510},{-420,550}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  CDL.Interfaces.RealInput occHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-460,430},{-420,470}}),
      iconTransformation(extent={{-240,120},{-200,160}})));
  CDL.Interfaces.RealInput unoCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-460,470},{-420,510}}),
      iconTransformation(extent={{-240,80},{-200,120}})));
  CDL.Interfaces.RealInput unoHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-460,390},{-420,430}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  CDL.Interfaces.RealInput setAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-460,330},{-420,370}}),
      iconTransformation(extent={{-240,0},{-200,40}})));
  CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-460,250},{-420,290}}),
      iconTransformation(extent={{-240,-40},{-200,0}})));
  CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-460,610},{-420,650}}),
      iconTransformation(extent={{-240,-120},{-200,-80}})));
  CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-460,110},{-420,150}}),
      iconTransformation(extent={{-240,-160},{-200,-120}})));
  CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-460,-110},{-420,-70}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  CDL.Interfaces.BooleanInput uOccSen if occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=0, origin={-440,-270}),iconTransformation(
      extent={{-20,-20},{20,20}},origin={-60,-220},rotation=90)));
  CDL.Interfaces.BooleanInput uWinSta if winStaSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{-460,-430},{-420,-390}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={60,-220})));
  CDL.Interfaces.RealOutput TCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")  "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{340,-10},{360,10}}),
      iconTransformation(extent={{200,-20},{240,20}})));
  CDL.Interfaces.RealOutput THeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")  "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{340,-110},{360,-90}}),
      iconTransformation(extent={{200,-100},{240,-60}})));
  CDL.Interfaces.IntegerOutput yAla if winStaSen "Alarm level"
    annotation (Placement(transformation(extent={{340,-400},{360,-380}}),
      iconTransformation(extent={{200,80},{240,120}})));

  CDL.Logical.Or or2
    "Check if there is cooling/heating demand limit being imposed"
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  CDL.Logical.Edge edg "If demand limit is imposed"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  CDL.Discrete.TriggeredSampler cooSetFre
    "Freeze current cooling setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Logical.Or or5
    "Check if demand limit should be ignored or if there is no demand limit"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  CDL.Logical.Or3 or1
    "Check if cooling demand limit level is imposed"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  CDL.Logical.Not not1 "Logic not"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  CDL.Continuous.AddParameter addPar3(
    p=incSetDem_3,
    k=1)
    "Increase setpoint by 2.2 degC"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  CDL.Continuous.AddParameter addPar1(
    p=incSetDem_2,
    k=1)
    "Increase setpoint by 1.1 degC"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  CDL.Continuous.AddParameter addPar2(
    p=incSetDem_1,
    k=1)
    "Increase setpoint by 0.56 degC"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  CDL.Continuous.Product pro6
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  CDL.Continuous.Product pro
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  CDL.Continuous.Product pro1
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  CDL.Continuous.Product pro2
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Continuous.MultiSum mulSum(nu=4)
    "Sum of inputs"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  CDL.Discrete.TriggeredSampler heaSetFre
    "Freeze current heating setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  CDL.Logical.Or3 or4 "Check if heating demand limit level is imposed"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  CDL.Continuous.Product pro7
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  CDL.Continuous.AddParameter addPar6(
    k=1,
    p=(-1.0)*decSetDem_1)
    "Decrease setpoint by 0.56 degC"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Continuous.AddParameter addPar5(
    k=1,
    p=(-1.0)*decSetDem_2)
    "Decrease setpoint by 1.1 degC"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  CDL.Continuous.AddParameter addPar4(
    k=1,
    p=(-1.0)*decSetDem_3)
    "Decrease setpoint by 2.2 degC"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  CDL.Continuous.Product pro5
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  CDL.Continuous.Product pro4
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));
  CDL.Continuous.Product pro3
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  CDL.Continuous.MultiSum mulSum1(nu=4)
    "Sum of inputs"
    annotation (Placement(transformation(extent={{160,-140},{180,-120}})));
  CDL.Logical.Timer tim
    "Measure unpopulated time when the zone is in occupied mode"
    annotation (Placement(transformation(extent={{-220,-280},{-200,-260}})));
  CDL.Logical.TrueHoldWithReset truHol(duration=60)
    "When the zone is unpopulated by more than 5 minute and then becomes populated, hold the change by 1 minute"
    annotation (Placement(transformation(extent={{-100,-280},{-80,-260}})));
  CDL.Logical.Edge edg1
    "Instant when the zone becomes more than 5 minutes"
    annotation (Placement(transformation(extent={{-40,-280},{-20,-260}})));
  CDL.Continuous.AddParameter heaSetDec(p=-1.1, k=1)
    "Heating setpoint decrease due to the 5 minutes unpopulation under occupied mode"
    annotation (Placement(transformation(extent={{100,-320},{120,-300}})));
  CDL.Continuous.AddParameter cooSetInc(p=1.1, k=1)
    "Heating setpoint increase due to the 5 minutes unpopulation under occupied mode"
    annotation (Placement(transformation(extent={{100,-280},{120,-260}})));
  CDL.Discrete.TriggeredSampler cooSetSam
    "Sample current cooling setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  CDL.Discrete.TriggeredSampler heaSetSam
    "Sample current heating setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{40,-320},{60,-300}})));
  CDL.Continuous.GreaterEqualThreshold greThr(threshold=300)
    "Check whether the zone has been unpopulated for 5 minutes continuously during occupied mode"
    annotation (Placement(transformation(extent={{-160,-280},{-140,-260}})));
  CDL.Continuous.Add add1 "Adjust heating setpoint"
    annotation (Placement(transformation(extent={{140,240},{160,260}})));
  CDL.Continuous.Add add2 "Adjust cooling setpoint"
    annotation (Placement(transformation(extent={{-200,340},{-180,360}})));
  CDL.Continuous.Limiter cooSetLim(
    final uMax=TCooOnMax,
    final uMin=TCooOnMin)
    "Limit occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-240,-530},{-220,-510}})));
  CDL.Continuous.Limiter heaSetLim(
    final uMax=THeaOnMax,
    final uMin=THeaOnMin)
    "Limit occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-240,-590},{-220,-570}})));
  CDL.Continuous.AddParameter addPar(p=-0.56, k=1)
    "Cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{160,-590},{180,-570}})));

protected
  CDL.Integers.Equal intEqu "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-300,600},{-280,620}})));
  CDL.Integers.Equal intEqu1
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-200,600},{-180,620}})));
  CDL.Integers.Equal intEqu2 "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-98,600},{-78,620}})));
  CDL.Logical.Or3 or3
    "Current operation mode is occupied, warm-up, or cool-down mode"
    annotation (Placement(transformation(extent={{-20,600},{0,620}})));
  CDL.Integers.Sources.Constant conInt(
    k=Constants.OperationModes.warUpInd)
    "Warm-up mode index"
    annotation (Placement(transformation(extent={{-340,570},{-320,590}})));
  CDL.Integers.Sources.Constant conInt1(
    k=Constants.OperationModes.cooDowInd)
    "Cool-down mode index"
    annotation (Placement(transformation(extent={{-240,570},{-220,590}})));
  CDL.Integers.Sources.Constant conInt2(
    k=Constants.OperationModes.occModInd)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-140,570},{-120,590}})));
  CDL.Logical.Sources.Constant cooSetAdjCon(k=(cooAdj or sinAdj))
    "Cooling setpoint adjustable"
    annotation (Placement(transformation(extent={{-340,320},{-320,340}})));
  CDL.Continuous.Sources.Constant con(k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-340,280},{-320,300}})));
  CDL.Continuous.Sources.Constant con3(k=0) if not (cooAdj or sinAdj)
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-340,360},{-320,380}})));
  CDL.Continuous.Sources.Constant con4(k=0) if not heaAdj
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-340,240},{-320,260}})));
  CDL.Logical.Sources.Constant heaSetAdjCon(k=heaAdj)
    "Heating setpoint adjustable"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  CDL.Continuous.Sources.Constant con1(k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  CDL.Logical.Sources.Constant sinSetAdjCon(k=sinAdj)
    "Single common setpoint adjustable"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  CDL.Logical.Sources.Constant con2(k=ignDemLim)
    "Check whether the zone should exempt from setpoint adjustment due to the demand limit"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  CDL.Logical.Sources.Constant conTru(k=true) if not occSen
    "Constant true"
    annotation (Placement(transformation(extent={{-380,-360},{-360,-340}})));
  CDL.Logical.Sources.Constant conFal(k=false) if not winStaSen
    "Constant false"
    annotation (Placement(transformation(extent={{-380,-480},{-360,-460}})));
  CDL.Logical.Sources.Constant winSenCon(k=winStaSen)
    "Check if there is window status sensor"
    annotation (Placement(transformation(extent={{40,-480},{60,-460}})));
  CDL.Logical.Sources.Constant occSenCon(k=occSen)
    "Check if there is occupancy sensor"
    annotation (Placement(transformation(extent={{160,-360},{180,-340}})));
  CDL.Continuous.Sources.Constant cooSetWinOpe(k=TCooWinOpe)
    "Cooling setpoint when window is open"
    annotation (Placement(transformation(extent={{-240,-480},{-220,-460}})));
  CDL.Continuous.Sources.Constant heaSetWinOpe(k=THeaWinOpe)
    "Heating setpoint when window is open"
    annotation (Placement(transformation(extent={{-120,-480},{-100,-460}})));
  CDL.Continuous.Sources.Constant alaZer(k=-0.2)
    "Alarm level 0"
    annotation (Placement(transformation(extent={{-180,-400},{-160,-380}})));
  CDL.Continuous.Sources.Constant alaFou(k=3.8)
    "Alarm level 4"
    annotation (Placement(transformation(extent={{-140,-400},{-120,-380}})));
  CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-400},{180,-380}})));
  CDL.Conversions.BooleanToReal booToRea "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  CDL.Conversions.BooleanToReal booToRea6 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  CDL.Conversions.BooleanToReal booToRea2 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Conversions.BooleanToReal booToRea3 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  CDL.Conversions.BooleanToReal booToRea4 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Conversions.BooleanToReal booToRea5 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  CDL.Conversions.BooleanToReal booToRea7 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  CDL.Logical.And and11
    "Check if window is open during operation modes other than occupied"
    annotation (Placement(transformation(extent={{-220,-420},{-200,-400}})));
  CDL.Logical.Not not5  "Other than occupied mode"
    annotation (Placement(transformation(extent={{-280,-400},{-260,-380}})));
  CDL.Continuous.LessEqual lesEqu
    "Check if occupied cooling setpoint is less than unoccupied one"
    annotation (Placement(transformation(extent={{20,-550},{40,-530}})));
  CDL.Continuous.GreaterEqual greEqu1
    "Check if occupied heating setpoint is greater than unoccupied one"
    annotation (Placement(transformation(extent={{20,-610},{40,-590}})));
  CDL.Continuous.GreaterEqual greEqu2
    "Check whether heating setpoint exceeds cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{220,-590},{240,-570}})));
  CDL.Logical.Switch swi
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,520},{-280,540}})));
  CDL.Logical.Switch swi1
    "Switch between occupied and unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-300,440},{-280,460}})));
  CDL.Logical.Switch swi2
    "Setpoint can only be adjusted in occupied mode"
    annotation (Placement(transformation(extent={{-120,360},{-100,340}})));
  CDL.Logical.Switch swi3
    "Setpoint can only be adjusted in occupied mode"
    annotation (Placement(transformation(extent={{220,260},{240,240}})));
  CDL.Logical.Switch swi4
    "If there is no cooling adjustment, zero adjust"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  CDL.Logical.Switch swi5
    "If there is no heating adjustment, zero adjust"
    annotation (Placement(transformation(extent={{0,240},{20,260}})));
  CDL.Logical.Switch swi6
    "If there is only one common adjust for both heating and cooling, use the adjust value from cooling one"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  CDL.Logical.Switch swi7
    "Ensure heating setpoint being not higher than cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{280,-590},{300,-570}})));
  CDL.Logical.Switch swi8
    "Ensure unoccupied heating setppint being lower than occupied one"
    annotation (Placement(transformation(extent={{100,-610},{120,-590}})));
  CDL.Logical.Switch swi9
    "Ensure unoccupied cooling setppint being higher than occupied one"
    annotation (Placement(transformation(extent={{100,-550},{120,-530}})));
  CDL.Logical.Switch swi10
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{220,80},{240,100}})));
  CDL.Logical.Switch swi11
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{220,-140},{240,-120}})));
  CDL.Logical.Switch swi12
    "Increase cooling setpoint when the zone is unpopulated by more than 5 minutes"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  CDL.Logical.Switch swi13
    "Decrease heating setpoint when the zone is unpopulated by more than 5 minutes"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));
  CDL.Logical.Switch swi14
    "Switch to TCooSetWinOpe when window is open"
    annotation (Placement(transformation(extent={{-180,-460},{-160,-440}})));
  CDL.Logical.Switch swi15
    "Switch to THeaSetWinOpe when window is open"
    annotation (Placement(transformation(extent={{-60,-460},{-40,-440}})));
  CDL.Logical.Switch swi16
    "Generate level 4 alarm when window is open during modes other than occupied"
    annotation (Placement(transformation(extent={{-100,-420},{-80,-400}})));
  CDL.Logical.Switch swi17
    "If it is occupied mode, cooling setpoint should be limited"
    annotation (Placement(transformation(extent={{-180,-550},{-160,-530}})));
  CDL.Logical.Switch swi18
    "If it is occupied mode, heating setpoint should be limited"
    annotation (Placement(transformation(extent={{-180,-610},{-160,-590}})));
  CDL.Logical.Switch swi19
    "If there is occupancy sensor, update heating setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{220,-320},{240,-300}})));
  CDL.Logical.Switch swi20
    "If there is occupancy sensor, update cooling setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{220,-280},{240,-260}})));
  CDL.Logical.Switch swi21
    "If there is window status sensor, update heating setpoint according to the window status"
    annotation (Placement(transformation(extent={{160,-480},{180,-460}})));
  CDL.Logical.Switch swi22
    "If there is window status sensor, update cooling setpoint according to the window status"
    annotation (Placement(transformation(extent={{100,-460},{120,-440}})));
  CDL.Integers.Equal intEqu7
    "Check if the heating demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  CDL.Integers.Sources.Constant conInt8(
    k=Constants.DemandLimitLevel.heaDemLimLev3)
    "Heat demand limit level 3"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  CDL.Integers.Equal intEqu8
    "Check if the heating demand limit level is level 3"
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-340,-280},{-320,-260}})));
  CDL.Logical.And and10
    "Check if the zone becomes unpopulated during occupied mode"
    annotation (Placement(transformation(extent={{-280,-280},{-260,-260}})));
  CDL.Integers.Sources.Constant conInt6(
    k=Constants.DemandLimitLevel.heaDemLimLev1)
    "Heat demand limit level 1"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  CDL.Integers.Equal intEqu6
    "Check if the heating demand limit level is level 1"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Integers.Sources.Constant conInt7(
    k=Constants.DemandLimitLevel.heaDemLimLev2)
    "Heat demand limit level 2"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  CDL.Integers.GreaterThreshold intGreThr
    "Check if cooling demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-340,-20},{-320,0}})));
  CDL.Integers.GreaterThreshold intGreThr1
    "Check if heating demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-340,-60},{-320,-40}})));
  CDL.Integers.Sources.Constant conInt3(
    k=Constants.DemandLimitLevel.cooDemLimLev1)
    "Cool demand limit level 1"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  CDL.Integers.Equal intEqu3
    "Check if the cooling demand limit level is level 1"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Integers.Sources.Constant conInt4(
    k=Constants.DemandLimitLevel.cooDemLimLev2)
    "Cool demand limit level 2"
    annotation (Placement(transformation(extent={{-160,62},{-140,82}})));
  CDL.Integers.Equal intEqu4
    "Check if the cooling demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Integers.Sources.Constant conInt5(
    k=Constants.DemandLimitLevel.cooDemLimLev3)
    "Cool demand limit level 3"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  CDL.Integers.Equal intEqu5
    "Check if the cooling demand limit level is level 3"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

equation
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-440,630},{-320,630},{-320,610},{-302,610}},
      color={255,127,0}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-440,630},{-220,630},{-220,610},{-202,610}},
      color={255,127,0}));
  connect(uOpeMod, intEqu2.u1)
    annotation (Line(points={{-440,630},{-120,630},{-120,610},{-100,610}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-319,580},{-310,580},{-310,602},{-302,602}},
      color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-219,580},{-210,580},{-210,602},{-202,602}},
      color={255,127,0}));
  connect(conInt2.y, intEqu2.u2)
    annotation (Line(points={{-119,580},{-110,580},{-110,602},{-100,602}},
      color={255,127,0}));
  connect(intEqu.y, or3.u1)
    annotation (Line(points={{-279,610},{-260,610},{-260,640},{-34,640},{-34,618},
      {-22,618}}, color={255,0,255}));
  connect(intEqu1.y, or3.u2)
    annotation (Line(points={{-179,610},{-160,610},{-160,634},{-40,634},{-40,610},
      {-22,610}}, color={255,0,255}));
  connect(intEqu2.y, or3.u3)
    annotation (Line(points={{-77,610},{-60,610},{-60,602},{-22,602}},
      color={255,0,255}));
  connect(occCooSet, swi.u1)
    annotation (Line(points={{-440,530},{-360,530},{-360,538},{-302,538}},
      color={0,0,127}));
  connect(unoCooSet, swi.u3)
    annotation (Line(points={{-440,490},{-360,490},{-360,522},{-302,522}},
      color={0,0,127}));
  connect(occHeaSet, swi1.u1)
    annotation (Line(points={{-440,450},{-360,450},{-360,458},{-302,458}},
      color={0,0,127}));
  connect(unoHeaSet, swi1.u3)
    annotation (Line(points={{-440,410},{-360,410},{-360,442},{-302,442}},
      color={0,0,127}));
  connect(or3.y, swi.u2)
    annotation (Line(points={{1,610},{20,610},{20,560},{-320,560},{-320,530},
      {-302,530}}, color={255,0,255}));
  connect(or3.y, swi1.u2)
    annotation (Line(points={{1,610},{20,610},{20,560},{-320,560},{-320,450},
      {-302,450}}, color={255,0,255}));
  connect(cooSetAdjCon.y, swi4.u2)
    annotation (Line(points={{-319,330},{-282,330}}, color={255,0,255}));
  connect(setAdj, swi4.u1)
    annotation (Line(points={{-440,350},{-300,350},{-300,338},{-282,338}},
      color={0,0,127}));
  connect(con3.y, swi4.u1)
    annotation (Line(points={{-319,370},{-300,370},{-300,338},{-282,338}},
      color={0,0,127}));
  connect(con.y, swi4.u3)
    annotation (Line(points={{-319,290},{-300,290},{-300,322},{-282,322}},
      color={0,0,127}));
  connect(swi4.y, add2.u2)
    annotation (Line(points={{-259,330},{-220,330},{-220,344},{-202,344}},
      color={0,0,127}));
  connect(swi.y, add2.u1)
    annotation (Line(points={{-279,530},{-220,530},{-220,356},{-202,356}},
      color={0,0,127}));
  connect(add2.y, swi2.u1)
    annotation (Line(points={{-179,350},{-160,350},{-160,342},{-122,342}},
      color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{-279,530},{-220,530},{-220,380},{-160,380},{-160,358},
      {-122,358}}, color={0,0,127}));
  connect(intEqu2.y, swi2.u2)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{-140,380},{-140,350},
      {-122,350}}, color={255,0,255}));
  connect(heaSetAdjCon.y, swi5.u2)
    annotation (Line(points={{-39,250},{-2,250}}, color={255,0,255}));
  connect(con1.y, swi5.u3)
    annotation (Line(points={{-39,210},{-20,210},{-20,242},{-2,242}},
      color={0,0,127}));
  connect(swi5.y, swi6.u3)
    annotation (Line(points={{21,250},{40,250},{40,242},{78,242}},
      color={0,0,127}));
  connect(sinSetAdjCon.y, swi6.u2)
    annotation (Line(points={{41,210},{60,210},{60,250},{78,250}},
      color={255,0,255}));
  connect(swi6.y, add1.u2)
    annotation (Line(points={{101,250},{120,250},{120,244},{138,244}},
      color={0,0,127}));
  connect(add1.y, swi3.u1)
    annotation (Line(points={{161,250},{180,250},{180,242},{218,242}},
      color={0,0,127}));
  connect(heaSetAdj, swi5.u1)
    annotation (Line(points={{-440,270},{-20,270},{-20,258},{-2,258}},
      color={0,0,127}));
  connect(con4.y, swi5.u1)
    annotation (Line(points={{-319,250},{-300,250},{-300,270},{-20,270},{-20,258},
      {-2,258}}, color={0,0,127}));
  connect(swi4.y, swi6.u1)
    annotation (Line(points={{-259,330},{-220,330},{-220,280},{60,280},{60,258},
      {78,258}}, color={0,0,127}));
  connect(swi1.y, add1.u1)
    annotation (Line(points={{-279,450},{120,450},{120,256},{138,256}},
      color={0,0,127}));
  connect(swi1.y, swi3.u3)
    annotation (Line(points={{-279,450},{120,450},{120,280},{180,280},{180,258},
      {218,258}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{200,380},{200,250},
      {218,250}}, color={255,0,255}));
  connect(uCooDemLimLev, intGreThr.u)
    annotation (Line(points={{-440,130},{-360,130},{-360,-10},{-342,-10}},
      color={255,127,0}));
  connect(uHeaDemLimLev, intGreThr1.u)
    annotation (Line(points={{-440,-90},{-360,-90},{-360,-50},{-342,-50}},
      color={255,127,0}));
  connect(intGreThr1.y, or2.u2)
    annotation (Line(points={{-319,-50},{-300,-50},{-300,-38},{-282,-38}},
      color={255,0,255}));
  connect(intGreThr.y, or2.u1)
    annotation (Line(points={{-319,-10},{-300,-10},{-300,-30},{-282,-30}},
      color={255,0,255}));
  connect(or2.y, edg.u)
    annotation (Line(points={{-259,-30},{-240,-30},{-240,0},{-222,0}},
      color={255,0,255}));
  connect(intEqu3.y, booToRea.u)
    annotation (Line(points={{-79,110},{-42,110}}, color={255,0,255}));
  connect(intEqu4.y, booToRea1.u)
    annotation (Line(points={{-79,70},{-42,70}}, color={255,0,255}));
  connect(intEqu5.y, booToRea2.u)
    annotation (Line(points={{-79,30},{-42,30}}, color={255,0,255}));
  connect(uCooDemLimLev, intEqu3.u1)
    annotation (Line(points={{-440,130},{-120,130},{-120,110},{-102,110}},
      color={255,127,0}));
  connect(uCooDemLimLev, intEqu4.u1)
    annotation (Line(points={{-440,130},{-120,130},{-120,70},{-102,70}},
      color={255,127,0}));
  connect(uCooDemLimLev, intEqu5.u1)
    annotation (Line(points={{-440,130},{-120,130},{-120,30},{-102,30}},
      color={255,127,0}));
  connect(conInt3.y, intEqu3.u2)
    annotation (Line(points={{-139,110},{-128,110},{-128,102},{-102,102}},
      color={255,127,0}));
  connect(conInt4.y, intEqu4.u2)
    annotation (Line(points={{-139,72},{-128,72},{-128,62},{-102,62}},
      color={255,127,0}));
  connect(conInt5.y, intEqu5.u2)
    annotation (Line(points={{-139,30},{-128,30},{-128,22},{-102,22}},
      color={255,127,0}));
  connect(intEqu3.y, or1.u1)
    annotation (Line(points={{-79,110},{-66,110},{-66,158},{-42,158}},
      color={255,0,255}));
  connect(intEqu4.y, or1.u2)
    annotation (Line(points={{-79,70},{-60,70},{-60,150},{-42,150}},
      color={255,0,255}));
  connect(intEqu5.y, or1.u3)
    annotation (Line(points={{-79,30},{-54,30},{-54,142},{-42,142}},
      color={255,0,255}));
  connect(or1.y, not1.u)
    annotation (Line(points={{-19,150},{-2,150}}, color={255,0,255}));
  connect(not1.y, booToRea6.u)
    annotation (Line(points={{21,150},{38,150}}, color={255,0,255}));
  connect(booToRea.y, pro.u2)
    annotation (Line(points={{-19,110},{0,110},{0,94},{80,94},{80,104},{98,104}},
      color={0,0,127}));
  connect(cooSetFre.y, addPar2.u)
    annotation (Line(points={{-139,150},{-100,150},{-100,132},{20,132},{20,110},
      {38,110}}, color={0,0,127}));
  connect(cooSetFre.y, addPar1.u)
    annotation (Line(points={{-139,150},{-100,150},{-100,132},{20,132},{20,70},
      {38,70}}, color={0,0,127}));
  connect(cooSetFre.y, addPar3.u)
    annotation (Line(points={{-139,150},{-100,150},{-100,132},{20,132},{20,30},
      {38,30}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2)
    annotation (Line(points={{-19,70},{0,70},{0,54},{80,54},{80,64},{98,64}},
      color={0,0,127}));
  connect(booToRea2.y, pro2.u2)
    annotation (Line(points={{-19,30},{0,30},{0,14},{80,14},{80,24},{98,24}},
      color={0,0,127}));
  connect(addPar2.y, pro.u1)
    annotation (Line(points={{61,110},{80,110},{80,116},{98,116}},
      color={0,0,127}));
  connect(cooSetFre.y, pro6.u2)
    annotation (Line(points={{-139,150},{-100,150},{-100,132},{80,132},{80,144},
      {98,144}}, color={0,0,127}));
  connect(booToRea6.y, pro6.u1)
    annotation (Line(points={{61,150},{80,150},{80,156},{98,156}},
      color={0,0,127}));
  connect(addPar1.y, pro1.u1)
    annotation (Line(points={{61,70},{80,70},{80,76},{98,76}},
      color={0,0,127}));
  connect(addPar3.y, pro2.u1)
    annotation (Line(points={{61,30},{80,30},{80,36},{98,36}},
      color={0,0,127}));
  connect(or2.y, not3.u)
    annotation (Line(points={{-259,-30},{-102,-30}}, color={255,0,255}));
  connect(con2.y, or5.u1)
    annotation (Line(points={{-139,-10},{158,-10}}, color={255,0,255}));
  connect(not3.y, or5.u2)
    annotation (Line(points={{-79,-30},{-60,-30},{-60,-18},{158,-18}},
      color={255,0,255}));
  connect(uHeaDemLimLev, intEqu6.u1)
    annotation (Line(points={{-440,-90},{-120,-90},{-120,-110},{-102,-110}},
      color={255,127,0}));
  connect(uHeaDemLimLev, intEqu7.u1)
    annotation (Line(points={{-440,-90},{-120,-90},{-120,-150},{-102,-150}},
      color={255,127,0}));
  connect(uHeaDemLimLev, intEqu8.u1)
    annotation (Line(points={{-440,-90},{-120,-90},{-120,-190},{-102,-190}},
      color={255,127,0}));
  connect(conInt6.y, intEqu6.u2)
    annotation (Line(points={{-139,-110},{-130,-110},{-130,-118},{-102,-118}},
      color={255,127,0}));
  connect(conInt7.y, intEqu7.u2)
    annotation (Line(points={{-139,-150},{-130,-150},{-130,-158},{-102,-158}},
      color={255,127,0}));
  connect(conInt8.y, intEqu8.u2)
    annotation (Line(points={{-139,-190},{-130,-190},{-130,-198},{-102,-198}},
      color={255,127,0}));
  connect(intEqu6.y, booToRea3.u)
    annotation (Line(points={{-79,-110},{-42,-110}}, color={255,0,255}));
  connect(intEqu7.y, booToRea4.u)
    annotation (Line(points={{-79,-150},{-42,-150}}, color={255,0,255}));
  connect(intEqu8.y, booToRea5.u)
    annotation (Line(points={{-79,-190},{-42,-190}}, color={255,0,255}));
  connect(intEqu6.y, or4.u1)
    annotation (Line(points={{-79,-110},{-66,-110},{-66,-62},{-42,-62}},
      color={255,0,255}));
  connect(intEqu7.y, or4.u2)
    annotation (Line(points={{-79,-150},{-60,-150},{-60,-70},{-42,-70}},
      color={255,0,255}));
  connect(intEqu8.y, or4.u3)
    annotation (Line(points={{-79,-190},{-54,-190},{-54,-78},{-42,-78}},
      color={255,0,255}));
  connect(or4.y, not2.u)
    annotation (Line(points={{-19,-70},{-2,-70}}, color={255,0,255}));
  connect(not2.y, booToRea7.u)
    annotation (Line(points={{21,-70},{38,-70}}, color={255,0,255}));
  connect(booToRea7.y, pro7.u1)
    annotation (Line(points={{61,-70},{80,-70},{80,-64},{98,-64}},
      color={0,0,127}));
  connect(heaSetFre.y, pro7.u2)
    annotation (Line(points={{-139,-70},{-100,-70},{-100,-88},{80,-88},{80,-76},
      {98,-76}}, color={0,0,127}));
  connect(heaSetFre.y, addPar6.u)
    annotation (Line(points={{-139,-70},{-100,-70},{-100,-88},{20,-88},{20,-110},
      {38,-110}}, color={0,0,127}));
  connect(heaSetFre.y, addPar5.u)
    annotation (Line(points={{-139,-70},{-100,-70},{-100,-88},{20,-88},{20,-150},
      {38,-150}}, color={0,0,127}));
  connect(heaSetFre.y, addPar4.u)
    annotation (Line(points={{-139,-70},{-100,-70},{-100,-88},{20,-88},{20,-190},
      {38,-190}}, color={0,0,127}));
  connect(addPar6.y, pro3.u1)
    annotation (Line(points={{61,-110},{80,-110},{80,-104},{98,-104}},
      color={0,0,127}));
  connect(addPar5.y, pro4.u1)
    annotation (Line(points={{61,-150},{80,-150},{80,-144},{98,-144}},
      color={0,0,127}));
  connect(addPar4.y, pro5.u1)
    annotation (Line(points={{61,-190},{80,-190},{80,-184},{98,-184}},
      color={0,0,127}));
  connect(booToRea3.y, pro3.u2)
    annotation (Line(points={{-19,-110},{0,-110},{0,-126},{80,-126},{80,-116},
      {98,-116}}, color={0,0,127}));
  connect(booToRea4.y, pro4.u2)
    annotation (Line(points={{-19,-150},{0,-150},{0,-166},{80,-166},{80,-156},
      {98,-156}}, color={0,0,127}));
  connect(booToRea5.y, pro5.u2)
    annotation (Line(points={{-19,-190},{0,-190},{0,-206},{80,-206},{80,-196},
      {98,-196}}, color={0,0,127}));
  connect(edg.y, cooSetFre.trigger)
    annotation (Line(points={{-199,0},{-180,0},{-180,134},{-150,134},{-150,138.2}},
      color={255,0,255}));
  connect(edg.y, heaSetFre.trigger)
    annotation (Line(points={{-199,0},{-180,0},{-180,-86},{-150,-86},{-150,-81.8}},
      color={255,0,255}));
  connect(pro6.y, mulSum.u[1])
    annotation (Line(points={{121,150},{146,150},{146,95.25},{158,95.25}},
      color={0,0,127}));
  connect(pro.y, mulSum.u[2])
    annotation (Line(points={{121,110},{142,110},{142,91.75},{158,91.75}},
      color={0,0,127}));
  connect(pro1.y, mulSum.u[3])
    annotation (Line(points={{121,70},{140,70},{140,88.25},{158,88.25}},
      color={0,0,127}));
  connect(pro2.y, mulSum.u[4])
    annotation (Line(points={{121,30},{136,30},{136,84.75},{158,84.75}},
      color={0,0,127}));
  connect(pro7.y, mulSum1.u[1])
    annotation (Line(points={{121,-70},{146,-70},{146,-124.75},{158,-124.75}},
      color={0,0,127}));
  connect(pro3.y, mulSum1.u[2])
    annotation (Line(points={{121,-110},{142,-110},{142,-128.25},{158,-128.25}},
      color={0,0,127}));
  connect(pro4.y, mulSum1.u[3])
    annotation (Line(points={{121,-150},{138,-150},{138,-131.75},{158,-131.75}},
      color={0,0,127}));
  connect(pro5.y, mulSum1.u[4])
    annotation (Line(points={{121,-190},{132,-190},{132,-135.25},{158,-135.25}},
      color={0,0,127}));
  connect(mulSum.y, swi10.u3)
    annotation (Line(points={{181.7,90},{194,90},{194,82},{218,82}},
      color={0,0,127}));
  connect(mulSum1.y, swi11.u3)
    annotation (Line(points={{181.7,-130},{194,-130},{194,-138},{218,-138}},
      color={0,0,127}));
  connect(or5.y, swi10.u2)
    annotation (Line(points={{181,-10},{200,-10},{200,90},{218,90}},
      color={255,0,255}));
  connect(or5.y, swi11.u2)
    annotation (Line(points={{181,-10},{200,-10},{200,-130},{218,-130}},
      color={255,0,255}));
  connect(swi2.y, cooSetFre.u)
    annotation (Line(points={{-99,350},{-80,350},{-80,180},{-180,180},{-180,150},
      {-162,150}}, color={0,0,127}));
  connect(swi2.y, swi10.u1)
    annotation (Line(points={{-99,350},{-80,350},{-80,180},{200,180},{200,98},{218,98}},
      color={0,0,127}));
  connect(swi3.y, heaSetFre.u)
    annotation (Line(points={{241,250},{260,250},{260,186},{-186,186},{-186,-70},
      {-162,-70}}, color={0,0,127}));
  connect(swi3.y, swi11.u1)
    annotation (Line(points={{241,250},{260,250},{260,186},{-186,186},{-186,-48},
      {208,-48},{208,-122},{218,-122}}, color={0,0,127}));
  connect(uOccSen, not4.u)
    annotation (Line(points={{-440,-270},{-342,-270}}, color={255,0,255}));
  connect(conTru.y, not4.u)
    annotation (Line(points={{-359,-350},{-350,-350},{-350,-270},{-342,-270}},
      color={255,0,255}));
  connect(and10.y, tim.u)
    annotation (Line(points={{-259,-270},{-222,-270}}, color={255,0,255}));
  connect(tim.y, greThr.u)
    annotation (Line(points={{-199,-270},{-162,-270}}, color={0,0,127}));
  connect(greThr.y, truHol.u)
    annotation (Line(points={{-139,-270},{-101,-270}}, color={255,0,255}));
  connect(truHol.y, edg1.u)
    annotation (Line(points={{-79,-270},{-42,-270}}, color={255,0,255}));
  connect(edg1.y, cooSetSam.trigger)
    annotation (Line(points={{-19,-270},{0,-270},{0,-288},{50,-288},{50,-281.8}},
      color={255,0,255}));
  connect(edg1.y, heaSetSam.trigger)
    annotation (Line(points={{-19,-270},{0,-270},{0,-330},{50,-330},{50,-321.8}},
      color={255,0,255}));
  connect(cooSetSam.y, cooSetInc.u)
    annotation (Line(points={{61,-270},{98,-270}}, color={0,0,127}));
  connect(heaSetSam.y, heaSetDec.u)
    annotation (Line(points={{61,-310},{98,-310}}, color={0,0,127}));
  connect(cooSetInc.y, swi12.u1)
    annotation (Line(points={{121,-270},{136,-270},{136,-262},{158,-262}},
      color={0,0,127}));
  connect(heaSetDec.y, swi13.u1)
    annotation (Line(points={{121,-310},{136,-310},{136,-302},{158,-302}},
      color={0,0,127}));
  connect(truHol.y, swi12.u2)
    annotation (Line(points={{-79,-270},{-60,-270},{-60,-250},{140,-250},{140,-270},
      {158,-270}}, color={255,0,255}));
  connect(truHol.y, swi13.u2)
    annotation (Line(points={{-79,-270},{-60,-270},{-60,-250},{140,-250},{140,-310},
      {158,-310}}, color={255,0,255}));
  connect(swi11.y, swi13.u3)
    annotation (Line(points={{241,-130},{260,-130},{260,-240},{144,-240},{144,-318},
      {158,-318}}, color={0,0,127}));
  connect(swi10.y, swi12.u3)
    annotation (Line(points={{241,90},{264,90},{264,-244},{148,-244},{148,-278},
      {158,-278}}, color={0,0,127}));
  connect(intEqu2.y, and10.u1)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{280,380},{280,-220},
      {-300,-220},{-300,-270},{-282,-270}}, color={255,0,255}));
  connect(not4.y, and10.u2)
    annotation (Line(points={{-319,-270},{-308,-270},{-308,-278},{-282,-278}},
      color={255,0,255}));
  connect(swi11.y, heaSetSam.u)
    annotation (Line(points={{241,-130},{260,-130},{260,-240},{20,-240},{20,-310},
      {38,-310}}, color={0,0,127}));
  connect(swi10.y, cooSetSam.u)
    annotation (Line(points={{241,90},{264,90},{264,-244},{24,-244},{24,-270},
      {38,-270}}, color={0,0,127}));
  connect(occSenCon.y, swi20.u2)
    annotation (Line(points={{181,-350},{200,-350},{200,-270},{218,-270}},
      color={255,0,255}));
  connect(occSenCon.y, swi19.u2)
    annotation (Line(points={{181,-350},{200,-350},{200,-310},{218,-310}},
      color={255,0,255}));
  connect(swi12.y, swi20.u1)
    annotation (Line(points={{181,-270},{196,-270},{196,-262},{218,-262}},
      color={0,0,127}));
  connect(swi13.y, swi19.u1)
    annotation (Line(points={{181,-310},{196,-310},{196,-302},{218,-302}},
      color={0,0,127}));
  connect(swi10.y, swi20.u3)
    annotation (Line(points={{241,90},{264,90},{264,-244},{208,-244},{208,-278},
      {218,-278}}, color={0,0,127}));
  connect(swi11.y, swi19.u3)
    annotation (Line(points={{241,-130},{260,-130},{260,-240},{204,-240},{204,-318},
      {218,-318}}, color={0,0,127}));
  connect(intEqu2.y, not5.u)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{280,380},{280,-220},
      {-300,-220},{-300,-390},{-282,-390}}, color={255,0,255}));
  connect(uWinSta, and11.u2)
    annotation (Line(points={{-440,-410},{-260,-410},{-260,-418},{-222,-418}},
      color={255,0,255}));
  connect(not5.y, and11.u1)
    annotation (Line(points={{-259,-390},{-240,-390},{-240,-410},{-222,-410}},
      color={255,0,255}));
  connect(and11.y, swi16.u2)
    annotation (Line(points={{-199,-410},{-102,-410}}, color={255,0,255}));
  connect(alaFou.y, swi16.u1)
    annotation (Line(points={{-119,-390},{-112,-390},{-112,-402},{-102,-402}},
      color={0,0,127}));
  connect(alaZer.y, swi16.u3)
    annotation (Line(points={{-159,-390},{-150,-390},{-150,-418},{-102,-418}},
      color={0,0,127}));
  connect(swi16.y, reaToInt.u)
    annotation (Line(points={{-79,-410},{-64,-410},{-64,-390},{158,-390}},
      color={0,0,127}));
  connect(uWinSta, swi14.u2)
    annotation (Line(points={{-440,-410},{-260,-410},{-260,-432},{-200,-432},
      {-200,-450},{-182,-450}}, color={255,0,255}));
  connect(uWinSta, swi15.u2)
    annotation (Line(points={{-440,-410},{-260,-410},{-260,-432},{-80,-432},
      {-80,-450},{-62,-450}}, color={255,0,255}));
  connect(cooSetWinOpe.y, swi14.u1)
    annotation (Line(points={{-219,-470},{-204,-470},{-204,-442},{-182,-442}},
      color={0,0,127}));
  connect(heaSetWinOpe.y, swi15.u1)
    annotation (Line(points={{-99,-470},{-84,-470},{-84,-442},{-62,-442}},
      color={0,0,127}));
  connect(winSenCon.y, swi22.u2)
    annotation (Line(points={{61,-470},{80,-470},{80,-450},{98,-450}},
      color={255,0,255}));
  connect(winSenCon.y, swi21.u2)
    annotation (Line(points={{61,-470},{158,-470}}, color={255,0,255}));
  connect(swi19.y, swi15.u3)
    annotation (Line(points={{241,-310},{260,-310},{260,-432},{-76,-432},{-76,-458},
      {-62,-458}}, color={0,0,127}));
  connect(swi19.y, swi21.u3)
    annotation (Line(points={{241,-310},{260,-310},{260,-432},{140,-432},{140,-478},
      {158,-478}}, color={0,0,127}));
  connect(swi20.y, swi14.u3)
    annotation (Line(points={{241,-270},{256,-270},{256,-428},{-196,-428},{-196,-458},
      {-182,-458}}, color={0,0,127}));
  connect(swi20.y, swi22.u3)
    annotation (Line(points={{241,-270},{256,-270},{256,-428},{84,-428},{84,-458},
      {98,-458}}, color={0,0,127}));
  connect(swi14.y, swi22.u1)
    annotation (Line(points={{-159,-450},{-140,-450},{-140,-424},{88,-424},{88,-442},
      {98,-442}}, color={0,0,127}));
  connect(swi15.y, swi21.u1)
    annotation (Line(points={{-39,-450},{-20,-450},{-20,-420},{144,-420},{144,-462},
      {158,-462}}, color={0,0,127}));
  connect(conFal.y, and11.u2)
    annotation (Line(points={{-359,-470},{-340,-470},{-340,-410},{-260,-410},{-260,-418},
      {-222,-418}}, color={255,0,255}));
  connect(conFal.y, swi14.u2)
    annotation (Line(points={{-359,-470},{-340,-470},{-340,-410},{-260,-410},{-260,-432},
      {-200,-432},{-200,-450},{-182,-450}}, color={255,0,255}));
  connect(conFal.y, swi15.u2)
    annotation (Line(points={{-359,-470},{-340,-470},{-340,-410},{-260,-410},{-260,-432},
      {-80,-432},{-80,-450},{-62,-450}}, color={255,0,255}));
  connect(swi22.y, cooSetLim.u)
    annotation (Line(points={{121,-450},{136,-450},{136,-500},{-260,-500},{-260,-520},
      {-242,-520}}, color={0,0,127}));
  connect(swi21.y, heaSetLim.u)
    annotation (Line(points={{181,-470},{200,-470},{200,-496},{-264,-496},{-264,-580},
      {-242,-580}}, color={0,0,127}));
  connect(cooSetLim.y, swi17.u1)
    annotation (Line(points={{-219,-520},{-192,-520},{-192,-532},{-182,-532}},
      color={0,0,127}));
  connect(heaSetLim.y, swi18.u1)
    annotation (Line(points={{-219,-580},{-192,-580},{-192,-592},{-182,-592}},
      color={0,0,127}));
  connect(swi22.y, swi17.u3)
    annotation (Line(points={{121,-450},{136,-450},{136,-500},{-198,-500},{-198,-548},
      {-182,-548}}, color={0,0,127}));
  connect(swi21.y, swi18.u3)
    annotation (Line(points={{181,-470},{200,-470},{200,-496},{-204,-496},{-204,-608},
      {-182,-608}}, color={0,0,127}));
  connect(intEqu2.y, swi17.u2)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{280,380},{280,-220},
      {-300,-220},{-300,-540},{-182,-540}}, color={255,0,255}));
  connect(intEqu2.y, swi18.u2)
    annotation (Line(points={{-77,610},{-60,610},{-60,380},{280,380},{280,-220},
      {-300,-220},{-300,-600},{-182,-600}}, color={255,0,255}));
  connect(swi17.y,lesEqu. u1)
    annotation (Line(points={{-159,-540},{18,-540}}, color={0,0,127}));
  connect(lesEqu.y, swi9.u2)
    annotation (Line(points={{41,-540},{98,-540}}, color={255,0,255}));
  connect(swi18.y, greEqu1.u1)
    annotation (Line(points={{-159,-600},{18,-600}}, color={0,0,127}));
  connect(greEqu1.y, swi8.u2)
    annotation (Line(points={{41,-600},{98,-600}}, color={255,0,255}));
  connect(swi17.y, swi9.u1)
    annotation (Line(points={{-159,-540},{-100,-540},{-100,-520},{80,-520},
      {80,-532},{98,-532}}, color={0,0,127}));
  connect(swi18.y, swi8.u1)
    annotation (Line(points={{-159,-600},{-100,-600},{-100,-580},{80,-580},
      {80,-592},{98,-592}}, color={0,0,127}));
  connect(unoCooSet,lesEqu. u2)
    annotation (Line(points={{-440,490},{-400,490},{-400,-560},{0,-560},
      {0,-548},{18,-548}}, color={0,0,127}));
  connect(unoCooSet, swi9.u3)
    annotation (Line(points={{-440,490},{-400,490},{-400,-560},{80,-560},
      {80,-548},{98,-548}}, color={0,0,127}));
  connect(unoHeaSet, greEqu1.u2)
    annotation (Line(points={{-440,410},{-406,410},{-406,-620},{0,-620},
      {0,-608},{18,-608}}, color={0,0,127}));
  connect(unoHeaSet, swi8.u3)
    annotation (Line(points={{-440,410},{-406,410},{-406,-620},{80,-620},
      {80,-608},{98,-608}}, color={0,0,127}));
  connect(swi9.y, addPar.u)
    annotation (Line(points={{121,-540},{140,-540},{140,-580},{158,-580}},
      color={0,0,127}));
  connect(greEqu2.y, swi7.u2)
    annotation (Line(points={{241,-580},{278,-580}}, color={255,0,255}));
  connect(swi8.y, greEqu2.u1)
    annotation (Line(points={{121,-600},{206,-600},{206,-580},{218,-580}},
      color={0,0,127}));
  connect(addPar.y, greEqu2.u2)
    annotation (Line(points={{181,-580},{200,-580},{200,-588},{218,-588}},
      color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{121,-600},{260,-600},{260,-588},{278,-588}},
      color={0,0,127}));
  connect(addPar.y, swi7.u1)
    annotation (Line(points={{181,-580},{200,-580},{200,-560},{260,-560},
      {260,-572},{278,-572}}, color={0,0,127}));
  connect(swi7.y, THeaSet)
    annotation (Line(points={{301,-580},{320,-580},{320,-100},{350,-100}},
      color={0,0,127}));
  connect(swi9.y, TCooSet)
    annotation (Line(points={{121,-540},{300,-540},{300,0},{350,0}},
      color={0,0,127}));
  connect(reaToInt.y, yAla)
    annotation (Line(points={{181,-390},{350,-390}}, color={255,127,0}));

annotation (
  defaultComponentName="zonSetpoint",
  Icon(coordinateSystem(extent={{-200,-200},{200,200}}, initialScale=0.1),
       graphics={
        Rectangle(
        extent={{-200,-200},{200,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-192,196},{-114,166}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="occCooSet"),
        Text(
          extent={{-192,154},{-110,130}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="occHeaSet"),
        Text(
          extent={{-192,72},{-112,50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="unoHeaSet"),
        Text(
          extent={{-192,118},{-112,86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="unoCooSet"),
        Text(
          extent={{-192,-12},{-122,-32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          extent={{-192,30},{-150,12}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          extent={{-190,-90},{-126,-108}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-190,-122},{-88,-156}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooDemLimLev"),
        Text(
          extent={{-192,-170},{-92,-190}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHeaDemLimLev"),
        Text(
          extent={{-28.5,8.5},{28.5,-8.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOccSen",
          origin={-30.5,-212.5},
          rotation=90),
        Text(
          extent={{-26.5,9.5},{26.5,-9.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWinSta",
          origin={90.5,-212.5},
          rotation=90),
        Text(
          extent={{152,110},{194,92}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yAla"),
        Text(
          extent={{140,6},{192,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{140,-70},{194,-88}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-156,286},{124,208}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-420,-620},{340,640}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-412,636},{330,558}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,548},{330,402}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,390},{330,186}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,174},{330,-216}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,-230},{330,-366}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,-376},{330,-490}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,-502},{-138,-614}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{124,632},{322,596}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Operation mode recognition"),
        Text(
          extent={{176,550},{324,506}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setpoints recognition"),
        Text(
          extent={{132,382},{324,332}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Local setpoints adjustment"),
        Text(
          extent={{-288,-264},{-36,-358}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Adjust setpoints due to occupancy"),
        Text(
          extent={{-34,-384},{252,-430}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Adjust setpoints due to window status"),
        Rectangle(
          extent={{-126,-504},{122,-614}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{134,-504},{330,-614}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-394,-540},{-184,-584}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Setpoints limited
in the range"),
        Text(
          extent={{-124,-526},{76,-594}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Limit occupied by
unoccupied"),
        Text(
          extent={{34,-478},{298,-564}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Confine cooling setpoint
by heating one"),
        Text(
          extent={{74,192},{326,98}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Demand limit setpoints
adjustment")}),
  Documentation(info="<html>
<p>
This sequence sets the thermal zone cooling and heating setpoints. The implementation
is according to the ASHRAE Guideline 36 (G36), PART5.B.3. The calculation is done
following the steps below.
</p>
<p>a. Each zone shall have separate occupied and unoccupied heating and cooling
setpoints.</p>
<p>b. The active setpoints shall be determined by the Operation Mode of the zone
group.</p>
<ul>
<li>The setpoints shall be the occupied setpoints during Occupied, Warm up, and
Cool-down modes.</li>
<li>The setpoints shall be the unoccupied setpoints during Unoccupied, Setback,
and Setup modes.</li>
</ul>
<p>c. The software shall prevent</p>
<ul>
<li>The heating setpoint from exceeding the cooling setpoint minus 0.56 &deg;C
(1 &deg;F).</li>
<li>The unoccupied heating setpoint from exceeding the occupied heating
setpoint.</li>
<li>The unoccupied cooling setpoint from being less than occupied cooling
setpoint.</li>
</ul>
<p>d. Where the zone has a local setpoint adjustment knob/button </p>
<ul>
<li>The setpoint adjustment offsets established by the occupant shall be software
points that are persistent (e.g. not reset daily), but the actual offset used
in control logic shall be adjusted based on limits and modes as described below.</li>
<li>The adjustment shall be capable of being limited in softare. (a. As a default,
the active occupied cooling setpoint shall be limited between 22 &deg;C
(72 &deg;F) and 27 &deg;C (80 &deg;F); b. As a default, the active occupied
heating setpoint shall be limited between 18 &deg;C (65 &deg;F) and 22 &deg;C
(72 &deg;F);)</li>
<li>The active heating and cooling setpoint shall be independently adjustable,
respecting the limits and anti-overlap logic described above. If zone thermostat
provides only a single setpoint adjustment, then the adjustment shall move both
the same amount, within the limits described above.</li>
<li>The adjustment shall only affect occupied setpoints in Occupied mode, and
shall have no impact on setpoints in all other modes.</li>
<li>At the onset of demand limiting, the local setpoint adjustment value shall
be frozen. Further adjustment of the setpoint by local controls shall be suspended
for the duration of the demand limit event.</li>
</ul>
<p>e. Cooling demand limit setpoint adjustment</p>
The active cooling setpoints for all zones shall be increased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal
Building Automation System (BAS) user
interface. Changes due to demand limits are not cumulative.
<ul>
<li>At Demand Limit Level 1, increase setpoint by 0.56 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, increase setpoint by 1.1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 1, increase setpoint by 2.2 &deg;C (4 &deg;F).</li>
</ul>
<p>f. Heating demand limit setpoint adjustment</p>
The active heating setpoints for all zones shall be decreased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal BAS user
interface. Changes due to demand limits are not cumulative.
<ul>
<li>At Demand Limit Level 1, decrease setpoint by 0.56 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, decrease setpoint by 1.1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 1, decrease setpoint by 2.2 &deg;C (4 &deg;F).</li>
</ul>
<p>g. Window switches</p>
For zones that have operable windows with indicator switches, when the window
switch indicates the window is open, the heating setpoint shall be temporarily
set to 4.4 &deg;C (40 &deg;F) and the cooling setpoint shall be temporarily
set to 49 &deg;C (120 &deg;F). When the window switch indicates the window is
open during other than Occupied Mode, a Level 4 alarm shall be generated.
<p>h. Occupancy sensor</p>
<ul>
<li>When the switch indicates the space has been unpopulated for 5 minutes
continuously during the Occupied Mode, the active heating setpoint shall be
decreased by 1.1 &deg;C (2 &deg;F) and the cooling setpoint shall be increased
by 1.1 &deg;C (2 &deg;F).</li>
<li>When the switch indicated that the space has been populated for 1 minute
continuously, the active heating and cooling setpoints shall be restored to
their previously values.</li>
</ul>
<p>Hierarchy of setpoint adjustments: the following adjustment restrictions
shall prevail in order from highest to lowest priority.</p>
<ul>
<li>Setpoint overlap restriction (Part c)</li>
<li>Absolute limits on local setpoint adjustment (Part d)</li>
<li>Window swtiches (Part g)</li>
<li>Demand limit (a. Occupancy sensors; b. Local setpoint adjustment)</li>
<li>Scheduled setpoints based on zone group mode</li>
</ul>

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of
Standards Review)/ASHRAE Guideline 36P,
<i>High Performance Sequences of Operation for HVAC systems</i>.
First Public Review Draft (June 2016)</a>
</p>

</html>", revisions="<html>
<ul>
<li>
August 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneTSet;
