within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block ZoneSetpoint "Block outputs thermal zone cooling and heating setpoint"

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
    annotation (Placement(transformation(extent={{-420,160},{-380,200}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  CDL.Interfaces.RealInput occHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-420,120},{-380,160}}),
      iconTransformation(extent={{-240,120},{-200,160}})));
  CDL.Interfaces.RealInput unoCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-420,60},{-380,100}}),
      iconTransformation(extent={{-240,80},{-200,120}})));
  CDL.Interfaces.RealInput unoHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Unoccupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-420,30},{-380,70}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  CDL.Interfaces.RealInput setAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-420,-60},{-380,-20}}),
      iconTransformation(extent={{-240,0},{-200,40}})));
  CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-420,-130},{-380,-90}}),
      iconTransformation(extent={{-240,-40},{-200,0}})));
  CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-420,200},{-380,240}}),
      iconTransformation(extent={{-240,-120},{-200,-80}})));
  CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-420,-250},{-380,-210}}),
      iconTransformation(extent={{-240,-160},{-200,-120}})));
  CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-420,-430},{-380,-390}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  CDL.Interfaces.BooleanInput uOccSen if occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
      rotation=0, origin={-60,330}), iconTransformation(
      extent={{-20,-20},{20,20}},origin={-60,-220},rotation=90)));
  CDL.Interfaces.BooleanInput uWinSta if winStaSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{100,310},{140,350}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,
      origin={60,-220})));
  CDL.Interfaces.RealOutput THeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")  "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{420,-30},{440,-10}}),
      iconTransformation(extent={{200,-100},{240,-60}})));
  CDL.Interfaces.RealOutput TCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")  "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{420,10},{440,30}}),
      iconTransformation(extent={{200,-20},{240,20}})));
  CDL.Interfaces.IntegerOutput yAla if winStaSen "Alarm level"
    annotation (Placement(transformation(extent={{420,210},{440,230}}),
      iconTransformation(extent={{200,80},{240,120}})));

  CDL.Logical.Switch swi
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-340,92},{-320,112}})));
  CDL.Logical.Switch swi1
    "Switch between occupied and unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-240,92},{-220,112}})));
  CDL.Logical.Or3 or3
    "Current operation mode is occupied, warm-up, or cool-down mode"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  CDL.Logical.Switch swi2
    "Setpoint can only be adjusted in occupied mode"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-70}})));
  CDL.Continuous.Add add2 "Adjust cooling setpoint"
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  CDL.Continuous.Add add1 "Adjust heating setpoint"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  CDL.Logical.Switch swi3
    "Setpoint can only be adjusted in occupied mode"
    annotation (Placement(transformation(extent={{100,-50},{120,-70}})));
  CDL.Logical.Switch swi4
    "If there is no cooling adjustment, zero adjust"
    annotation (Placement(transformation(extent={{-300,-70},{-280,-50}})));
  CDL.Logical.Switch swi6
    "If there is only one common adjust for both heating and cooling, use the adjust value from cooling one"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  CDL.Logical.Switch swi5
    "If there is no heating adjustment, zero adjust"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  CDL.Continuous.Limiter cooSetLim(
    final uMax=TCooOnMax,
    final uMin=TCooOnMin)
    "Limit occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  CDL.Continuous.Limiter heaSetLim(
    final uMax=THeaOnMax,
    final uMin=THeaOnMin)
    "Limit occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  CDL.Continuous.AddParameter addPar(p=-0.56, k=1)
    "Cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  CDL.Logical.GreaterEqual grtEqu
    "Check whether heating setpoint exceeds cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  CDL.Logical.Switch swi7
    "Ensure heating setpoint being not higher than cooling setpoint minus 0.56 degC"
    annotation (Placement(transformation(extent={{340,10},{360,-10}})));
  CDL.Logical.LessEqual lesEqu
    "Check if occupied heating setpoint is lower than unoccupied one"
    annotation (Placement(transformation(extent={{280,40},{300,60}})));
  CDL.Logical.Switch swi8
    "Ensure unoccupied heating setppint being lower than occupied one"
    annotation (Placement(transformation(extent={{340,40},{360,60}})));
  CDL.Logical.GreaterEqual grtEqu1
    "Check if occupied cooling setpoint is higher than unoccupied one"
    annotation (Placement(transformation(extent={{280,80},{300,100}})));
  CDL.Logical.Switch swi9
    "Ensure unoccupied cooling setppint being higher than occupied one"
    annotation (Placement(transformation(extent={{340,80},{360,100}})));
  CDL.Logical.Or or2
    "Check if there is cooling/heating demand limit being imposed"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));
  CDL.Logical.GreaterThreshold greThr2
    "Check if cooling demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-240,-190},{-220,-170}})));
  CDL.Logical.GreaterThreshold greThr3
    "Check if heating demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-200,-190},{-180,-170}})));
  CDL.Discrete.TriggeredSampler cooSetFre
    "Freeze current cooling setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  CDL.Discrete.TriggeredSampler heaSetFre
    "Freeze current heating setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  CDL.Continuous.AddParameter addPar1(
    p=incSetDem_2,
    k=1)
    "Increase setpoint by 1.1 degC"
    annotation (Placement(transformation(extent={{60,-290},{80,-270}})));
  CDL.Continuous.AddParameter addPar2(
    p=incSetDem_1,
    k=1)
    "Increase setpoint by 0.56 degC"
    annotation (Placement(transformation(extent={{60,-260},{80,-240}})));
  CDL.Continuous.AddParameter addPar3(
    p=incSetDem_3,
    k=1)
    "Increase setpoint by 2.2 degC"
    annotation (Placement(transformation(extent={{60,-320},{80,-300}})));
  CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{120,-260},{140,-240}})));
  CDL.Continuous.Product pro1
    annotation (Placement(transformation(extent={{120,-290},{140,-270}})));
  CDL.Continuous.Product pro2
    annotation (Placement(transformation(extent={{120,-320},{140,-300}})));
  CDL.Continuous.MultiSum mulSum(nu=4)
    annotation (Placement(transformation(extent={{160,-260},{180,-240}})));
  CDL.Continuous.AddParameter addPar4(
    k=1,
    p=(-1.0)*decSetDem_3)
    "Decrease setpoint by 2.2 degC"
    annotation (Placement(transformation(extent={{60,-480},{80,-460}})));
  CDL.Continuous.AddParameter addPar5(
    k=1,
    p=(-1.0)*decSetDem_2)
    "Decrease setpoint by 1.1 degC"
    annotation (Placement(transformation(extent={{60,-450},{80,-430}})));
  CDL.Continuous.AddParameter addPar6(
    k=1,
    p=(-1.0)*decSetDem_1)
    "Decrease setpoint by 0.56 degC"
    annotation (Placement(transformation(extent={{60,-420},{80,-400}})));
  CDL.Continuous.Product pro3
    annotation (Placement(transformation(extent={{120,-420},{140,-400}})));
  CDL.Continuous.Product pro4
    annotation (Placement(transformation(extent={{120,-450},{140,-430}})));
  CDL.Continuous.Product pro5
    annotation (Placement(transformation(extent={{120,-480},{140,-460}})));
  CDL.Continuous.MultiSum mulSum1(nu=4)
    annotation (Placement(transformation(extent={{160,-420},{180,-400}})));
  CDL.Logical.Edge edg "If demand limit is imposed"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  CDL.Logical.Or3 or1
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));
  CDL.Continuous.Product pro6
    annotation (Placement(transformation(extent={{120,-230},{140,-210}})));
  CDL.Logical.Or3 or4
    annotation (Placement(transformation(extent={{0,-390},{20,-370}})));
  CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{40,-390},{60,-370}})));
  CDL.Continuous.Product pro7
    annotation (Placement(transformation(extent={{120,-390},{140,-370}})));
  CDL.Logical.Not not3
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));
  CDL.Logical.Or or5
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  CDL.Logical.Switch swi10
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{200,-160},{220,-140}})));
  CDL.Logical.Switch swi11
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{200,-202},{220,-182}})));
  CDL.Logical.Timer tim
    "Measure unpopulated time when the zone is in occupied mode"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-20,210},{0,230}})));
  CDL.Logical.And and10
    "Check if the zone becomes unpopulated during occupied mode"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  CDL.Logical.GreaterThreshold greThr11(threshold=300)
    "Check whether the zone has been unpopulated for 5 minutes continuously during occupied mode"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  CDL.Logical.Edge edg1
    "Instant when the zone becomes more than 5 minutes"
    annotation (Placement(transformation(extent={{60,150},{80,170}})));
  CDL.Continuous.AddParameter heaSetDec(p=-1.1, k=1)
    "Heating setpoint decrease due to the 5 minutes unpopulation under occupied mode"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  CDL.Continuous.AddParameter cooSetInc(p=1.1, k=1)
    "Heating setpoint increase due to the 5 minutes unpopulation under occupied mode"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  CDL.Discrete.TriggeredSampler cooSetSam
    "Sample current cooling setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  CDL.Discrete.TriggeredSampler heaSetSam
    "Sample current heating setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  CDL.Logical.Switch swi12
    "Increase cooling setpoint when the zone is unpopulated by more than 5 minutes"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  CDL.Logical.Switch swi13
    "Decrease heating setpoint when the zone is unpopulated by more than 5 minutes"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  CDL.Logical.TrueHoldWithReset truHol(duration=60)
    "When the zone is unpopulated by more than 5 minute and then becomes populated, hold the change by 1 minute"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  CDL.Logical.Switch swi14
    "Switch to TCooSetWinOpe when window is open"
    annotation (Placement(transformation(extent={{202,170},{222,190}})));
  CDL.Logical.Switch swi15
    "Switch to THeaSetWinOpe when window is open"
    annotation (Placement(transformation(extent={{202,130},{222,150}})));
  CDL.Logical.And and11
    "Check if window is open during operation modes other than occupied"
    annotation (Placement(transformation(extent={{260,210},{280,230}})));
  CDL.Logical.Not not5  "Other than occupied mode"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  CDL.Logical.Switch swi16
    "Generate level 4 alarm when window is open during modes other than occupied"
    annotation (Placement(transformation(extent={{300,210},{320,230}})));

protected
  CDL.Logical.Sources.Constant cooSetAdjCon(k=(cooAdj or sinAdj))
    "Cooling setpoint adjustable"
    annotation (Placement(transformation(extent={{-360,-70},{-340,-50}})));
  CDL.Logical.Sources.Constant heaSetAdjCon(k=heaAdj)
    "Heating setpoint adjustable"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  CDL.Continuous.Sources.Constant con(k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));
  CDL.Continuous.Sources.Constant con1(k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  CDL.Logical.Sources.Constant sinSetAdjCon(k=sinAdj)
    "Single common setpoint adjustable"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  CDL.Continuous.Sources.Constant alaZer(k=-0.2)
    "Alarm level 0"
    annotation (Placement(transformation(extent={{260,170},{280,190}})));
  CDL.Continuous.Sources.Constant alaFou(k=3.8)
    "Alarm level 4"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  CDL.Logical.Sources.Constant con2(k=ignDemLim)
    "Check whether the zone should exempt from setpoint adjustment due to the demand limit"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  CDL.Continuous.Sources.Constant cooSetWinOpe(k=TCooWinOpe)
    "Cooling setpoint when window is open"
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  CDL.Continuous.Sources.Constant heaSetWinOpe(k=THeaWinOpe)
    "Heating setpoint when window is open"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  CDL.Conversions.IntegerToReal intToRea "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-360,210},{-340,230}})));
  CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{340,210},{360,230}})));
  CDL.Conversions.IntegerToReal intToRea1
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-280,-240},{-260,-220}})));
  CDL.Conversions.IntegerToReal intToRea2
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-280,-420},{-260,-400}})));
  CDL.Conversions.BooleanToReal booToRea "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-140,-340},{-120,-320}})));
  CDL.Conversions.BooleanToReal booToRea1 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-60,-340},{-40,-320}})));
  CDL.Conversions.BooleanToReal booToRea2 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{20,-340},{40,-320}})));
  CDL.Conversions.BooleanToReal booToRea3 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-140,-500},{-120,-480}})));
  CDL.Conversions.BooleanToReal booToRea4 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-60,-500},{-40,-480}})));
  CDL.Conversions.BooleanToReal booToRea5 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{20,-500},{40,-480}})));
  CDL.Conversions.BooleanToReal booToRea6 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  CDL.Conversions.BooleanToReal booToRea7 "Convert boolean to real value"
    annotation (Placement(transformation(extent={{80,-390},{100,-370}})));
  CDL.Logical.GreaterThreshold greThr(
    threshold=Constants.OperationModes.occModInd- 0.5)
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-300,210},{-280,230}})));
  CDL.Logical.LessThreshold lesThr(
    threshold=Constants.OperationModes.occModInd + 0.5)
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-260,210},{-240,230}})));
  CDL.Logical.And and1 "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  CDL.Logical.GreaterThreshold greThr1(
    threshold=Constants.OperationModes.cooDowInd - 0.5)
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-160,210},{-140,230}})));
  CDL.Logical.LessThreshold lesThr1(
    threshold=Constants.OperationModes.cooDowInd + 0.5)
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-160,170},{-140,190}})));
  CDL.Logical.And and2 "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  CDL.Logical.GreaterThreshold greThr4(
    threshold=Constants.OperationModes.warUpInd - 0.5)
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  CDL.Logical.LessThreshold lesThr4(
    threshold=Constants.OperationModes.warUpInd + 0.5)
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));
  CDL.Logical.And and4 "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  CDL.Logical.GreaterThreshold greThr5(
    threshold=Constants.DemandLimitLevel.cooDemLimLev1 - 0.5)
    "Check if the cooling demand limit level is level 1"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  CDL.Logical.LessThreshold lesThr2(
    threshold=Constants.DemandLimitLevel.cooDemLimLev1 + 0.5)
    "Check if the cooling demand limit level is level 1"
    annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
  CDL.Logical.And and3 "Check if the cooling demand limit level is level 1"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  CDL.Logical.GreaterThreshold greThr6(
    threshold=Constants.DemandLimitLevel.cooDemLimLev2 - 0.5)
    "Check if the cooling demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-280},{-80,-260}})));
  CDL.Logical.LessThreshold lesThr3(
    threshold=Constants.DemandLimitLevel.cooDemLimLev2 + 0.5)
    "Check if the cooling demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-320},{-80,-300}})));
  CDL.Logical.And and5 "Check if the cooling demand limit level is level 2"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  CDL.Logical.GreaterThreshold greThr7(
    threshold=Constants.DemandLimitLevel.cooDemLimLev3 - 0.5)
    "Check if the cooling demand limit level is level 3"
    annotation (Placement(transformation(extent={{-20,-280},{0,-260}})));
  CDL.Logical.LessThreshold lesThr5(
    threshold=Constants.DemandLimitLevel.cooDemLimLev3 + 0.5)
    "Check if the cooling demand limit level is level 3"
    annotation (Placement(transformation(extent={{-20,-320},{0,-300}})));
  CDL.Logical.And and6 "Check if the cooling demand limit level is level 3"
    annotation (Placement(transformation(extent={{20,-280},{40,-260}})));
  CDL.Logical.GreaterThreshold greThr8(
    threshold=Constants.DemandLimitLevel.heaDemLimLev1 - 0.5)
    "Check if the heating demand limit level is level 1"
    annotation (Placement(transformation(extent={{-180,-440},{-160,-420}})));
  CDL.Logical.LessThreshold lesThr6(
    threshold=Constants.DemandLimitLevel.heaDemLimLev1 + 0.5)
    "Check if the heating demand limit level is level 1"
    annotation (Placement(transformation(extent={{-180,-480},{-160,-460}})));
  CDL.Logical.And and7 "Check if the heating demand limit level is level 1"
    annotation (Placement(transformation(extent={{-140,-440},{-120,-420}})));
  CDL.Logical.LessThreshold lesThr7(
    threshold=Constants.DemandLimitLevel.heaDemLimLev2 + 0.5)
    "Check if the heating demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-480},{-80,-460}})));
  CDL.Logical.GreaterThreshold greThr9(
    threshold=Constants.DemandLimitLevel.heaDemLimLev2 - 0.5)
    "Check if the heating demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-440},{-80,-420}})));
  CDL.Logical.And and8 "Check if the heating demand limit level is level 2"
    annotation (Placement(transformation(extent={{-60,-440},{-40,-420}})));
  CDL.Logical.LessThreshold lesThr8(
    threshold=Constants.DemandLimitLevel.heaDemLimLev3 + 0.5)
    "Check if the heating demand limit level is level 3"
    annotation (Placement(transformation(extent={{-20,-480},{0,-460}})));
  CDL.Logical.GreaterThreshold greThr10(
    threshold=Constants.DemandLimitLevel.heaDemLimLev3 - 0.5)
    "Check if the heating demand limit level is level 3"
    annotation (Placement(transformation(extent={{-20,-440},{0,-420}})));
  CDL.Logical.And and9 "Check if the heating demand limit level is level 3"
    annotation (Placement(transformation(extent={{20,-440},{40,-420}})));
  CDL.Logical.Switch swi17
    "If it is occupied mode, cooling setpoint should be limited"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  CDL.Logical.Switch swi18
    "If it is occupied mode, heating setpoint should be limited"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  CDL.Logical.Switch swi19
    "If there is occupancy sensor, update heating setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{60,260},{80,280}})));
  CDL.Logical.Switch swi20
    "If there is occupancy sensor, update cooling setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{60,290},{80,310}})));
  CDL.Logical.Sources.Constant occSenCon(k=occSen)
    "Check if there is occupancy sensor"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));
  CDL.Logical.Switch swi21
    "If there is window status sensor, update heating setpoint according to the window status"
    annotation (Placement(transformation(extent={{220,260},{240,280}})));
  CDL.Logical.Switch swi22
    "If there is window status sensor, update cooling setpoint according to the window status"
    annotation (Placement(transformation(extent={{220,290},{240,310}})));
  CDL.Logical.Sources.Constant winSenCon(k=winStaSen)
    "Check if there is window status sensor"
    annotation (Placement(transformation(extent={{160,290},{180,310}})));

  CDL.Continuous.Sources.Constant con3(k=0) if not (cooAdj or sinAdj)
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-360,-30},{-340,-10}})));
  CDL.Continuous.Sources.Constant con4(k=0) if not heaAdj
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-300,-100},{-280,-80}})));
  CDL.Logical.Sources.Constant conTru(k=true) if not occSen
    "Constant true"
    annotation (Placement(transformation(extent={{-20,258},{0,278}})));
  CDL.Logical.Sources.Constant conFal(k=false) if not winStaSen
    "Constant false"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
equation
  connect(intToRea.y, greThr.u)
    annotation (Line(points={{-339,220},{-302,220}}, color={0,0,127}));
  connect(lesThr.y, and1.u1)
    annotation (Line(points={{-239,220},{-222,220}}, color={255,0,255}));
  connect(greThr.y, and1.u2)
    annotation (Line(points={{-279,220},{-274,220},{-274,204},{-230,204},
      {-230,212},{-222,212}}, color={255,0,255}));
  connect(cooSetAdjCon.y, swi4.u2)
    annotation (Line(points={{-339,-60},{-302,-60}}, color={255,0,255}));
  connect(con.y, swi4.u3)
    annotation (Line(points={{-339,-90},{-320,-90},{-320,-68},{-302,-68}},
      color={0,0,127}));
  connect(addPar.y, grtEqu.u2)
    annotation (Line(points={{261,0},{268,0},{268,-8},{278,-8}}, color={0,0,127}));
  connect(addPar.y, swi7.u1)
    annotation (Line(points={{261,0},{268,0},{268,-14},{320,-14},{320,-8},{338,-8}},
      color={0,0,127}));
  connect(heaSetAdjCon.y, swi5.u2)
    annotation (Line(points={{-39,-100},{-32,-100},{-32,-60},{-22,-60}},
      color={255,0,255}));
  connect(grtEqu.y, swi7.u2)
    annotation (Line(points={{301,0},{338,0}}, color={255,0,255}));
  connect(swi4.y, add2.u2)
    annotation (Line(points={{-279,-60},{-260,-60},{-260,-66},{-242,-66}},
      color={0,0,127}));
  connect(intToRea.y, greThr4.u)
    annotation (Line(points={{-339,220},{-320,220},{-320,180},{-302,180}},
      color={0,0,127}));
  connect(lesThr4.y, and4.u1)
    annotation (Line(points={{-239,180},{-222,180}}, color={255,0,255}));
  connect(greThr4.y, and4.u2)
    annotation (Line(points={{-279,180},{-274,180},{-274,164},{-230,164},
      {-230,172},{-222,172}}, color={255,0,255}));
  connect(lesThr1.y, and2.u2)
    annotation (Line(points={{-139,180},{-130,180},{-130,212},{-122,212}},
      color={255,0,255}));
  connect(greThr1.y, and2.u1)
    annotation (Line(points={{-139,220},{-122,220}}, color={255,0,255}));
  connect(intToRea.y, lesThr.u)
    annotation (Line(points={{-339,220},{-320,220},{-320,160},{-270,160},
      {-270,220},{-262,220}}, color={0,0,127}));
  connect(intToRea.y, lesThr4.u)
    annotation (Line(points={{-339,220},{-320,220},{-320,160},{-270,160},
      {-270,180},{-262,180}}, color={0,0,127}));
  connect(intToRea.y, greThr1.u)
    annotation (Line(points={{-339,220},{-320,220},{-320,160},{-174,160},
      {-174,220},{-162,220}}, color={0,0,127}));
  connect(intToRea.y, lesThr1.u)
    annotation (Line(points={{-339,220},{-320,220},{-320,160},{-174,160},
      {-174,180},{-162,180}}, color={0,0,127}));
  connect(intToRea1.y, greThr2.u)
    annotation (Line(points={{-259,-230},{-254,-230},{-250,-230},{-250,-180},
      {-242,-180}}, color={0,0,127}));
  connect(intToRea2.y, greThr3.u)
    annotation (Line(points={{-259,-410},{-236,-410},{-210,-410},{-210,-180},
      {-202,-180}}, color={0,0,127}));
  connect(greThr5.y, and3.u1)
    annotation (Line(points={{-159,-270},{-154,-270},{-142,-270}},
      color={255,0,255}));
  connect(lesThr2.y, and3.u2)
    annotation (Line(points={{-159,-310},{-152,-310},{-152,-278},{-142,-278}},
      color={255,0,255}));
  connect(greThr6.y, and5.u1)
    annotation (Line(points={{-79,-270},{-70.5,-270},{-62,-270}},
      color={255,0,255}));
  connect(greThr7.y, and6.u1)
    annotation (Line(points={{1,-270},{9.5,-270},{18,-270}}, color={255,0,255}));
  connect(lesThr3.y, and5.u2)
    annotation (Line(points={{-79,-310},{-72,-310},{-72,-278},{-62,-278}},
      color={255,0,255}));
  connect(lesThr5.y, and6.u2)
    annotation (Line(points={{1,-310},{8,-310},{8,-278},{18,-278}}, color={255,0,255}));
  connect(addPar2.y, pro.u1)
    annotation (Line(points={{81,-250},{90,-250},{90,-244},{118,-244}},
      color={0,0,127}));
  connect(addPar1.y, pro1.u1)
    annotation (Line(points={{81,-280},{90,-280},{90,-274},{118,-274}},
      color={0,0,127}));
  connect(addPar3.y, pro2.u1)
    annotation (Line(points={{81,-310},{90,-310},{90,-304},{118,-304}},
      color={0,0,127}));
  connect(pro.y, mulSum.u[1])
    annotation (Line(points={{141,-250},{158,-250},{158,-244.75}},
      color={0,0,127}));
  connect(pro1.y, mulSum.u[2])
    annotation (Line(points={{141,-280},{148,-280},{148,-248.25},{158,-248.25}},
      color={0,0,127}));
  connect(pro2.y, mulSum.u[3])
    annotation (Line(points={{141,-310},{152,-310},{152,-251.75},{158,-251.75}},
      color={0,0,127}));
  connect(intToRea2.y, greThr8.u)
    annotation (Line(points={{-259,-410},{-259,-410},{-190,-410},{-190,-430},
      {-182,-430}}, color={0,0,127}));
  connect(intToRea2.y, lesThr6.u)
    annotation (Line(points={{-259,-410},{-224,-410},{-190,-410},{-190,-470},
      {-182,-470}}, color={0,0,127}));
  connect(greThr8.y, and7.u1)
    annotation (Line(points={{-159,-430},{-142,-430}}, color={255,0,255}));
  connect(lesThr6.y, and7.u2)
    annotation (Line(points={{-159,-470},{-152,-470},{-152,-438},{-142,-438}},
      color={255,0,255}));
  connect(greThr9.y, and8.u1)
    annotation (Line(points={{-79,-430},{-62,-430}}, color={255,0,255}));
  connect(lesThr7.y, and8.u2)
    annotation (Line(points={{-79,-470},{-72,-470},{-72,-438},{-62,-438}},
      color={255,0,255}));
  connect(greThr10.y, and9.u1)
    annotation (Line(points={{1,-430},{18,-430}},  color={255,0,255}));
  connect(lesThr8.y, and9.u2)
    annotation (Line(points={{1,-470},{8,-470},{8,-438},{18,-438}},
      color={255,0,255}));
  connect(intToRea2.y, greThr9.u)
    annotation (Line(points={{-259,-410},{-108,-410},{-108,-430},{-102,-430}},
      color={0,0,127}));
  connect(intToRea2.y, lesThr7.u)
    annotation (Line(points={{-259,-410},{-184,-410},{-108,-410},{-108,-470},
      {-102,-470}}, color={0,0,127}));
  connect(intToRea2.y, greThr10.u)
    annotation (Line(points={{-259,-410},{-144,-410},{-28,-410},{-28,-430},
      {-22,-430}}, color={0,0,127}));
  connect(intToRea2.y, lesThr8.u)
    annotation (Line(points={{-259,-410},{-144,-410},{-28,-410},{-28,-470},
      {-22,-470}}, color={0,0,127}));
  connect(and7.y, booToRea3.u)
    annotation (Line(points={{-119,-430},{-114,-430},{-114,-470},{-148,-470},
      {-148,-490},{-142,-490}}, color={255,0,255}));
  connect(and8.y, booToRea4.u)
    annotation (Line(points={{-39,-430},{-34,-430},{-34,-470},{-68,-470},{-68,-490},
      {-62,-490}}, color={255,0,255}));
  connect(and9.y, booToRea5.u)
    annotation (Line(points={{41,-430},{46,-430},{46,-470},{10,-470},{10,-490},
      {18,-490}}, color={255,0,255}));
  connect(addPar6.y, pro3.u1)
    annotation (Line(points={{81,-410},{90,-410},{90,-404},{118,-404}},
      color={0,0,127}));
  connect(addPar5.y, pro4.u1)
    annotation (Line(points={{81,-440},{92,-440},{92,-434},{118,-434}},
      color={0,0,127}));
  connect(addPar4.y, pro5.u1)
    annotation (Line(points={{81,-470},{92,-470},{92,-464},{118,-464}},
      color={0,0,127}));
  connect(booToRea5.y, pro5.u2)
    annotation (Line(points={{41,-490},{96,-490},{96,-476},{118,-476}},
      color={0,0,127}));
  connect(booToRea4.y, pro4.u2)
    annotation (Line(points={{-39,-490},{-30,-490},{-30,-502},{102,-502},
      {102,-446},{118,-446}}, color={0,0,127}));
  connect(booToRea3.y, pro3.u2)
    annotation (Line(points={{-119,-490},{-108,-490},{-108,-506},{108,-506},
      {108,-416},{118,-416}}, color={0,0,127}));
  connect(pro3.y, mulSum1.u[1])
    annotation (Line(points={{141,-410},{158,-410},{158,-404.75}},
      color={0,0,127}));
  connect(pro4.y, mulSum1.u[2])
    annotation (Line(points={{141,-440},{148,-440},{148,-408.25},{158,-408.25}},
      color={0,0,127}));
  connect(pro5.y, mulSum1.u[3])
    annotation (Line(points={{141,-470},{152,-470},{152,-411.75},{158,-411.75}},
      color={0,0,127}));
  connect(or1.y, not1.u)
    annotation (Line(points={{21,-220},{26,-220},{38,-220}}, color={255,0,255}));
  connect(not1.y, booToRea6.u)
    annotation (Line(points={{61,-220},{66,-220},{78,-220}}, color={255,0,255}));
  connect(booToRea6.y, pro6.u2)
    annotation (Line(points={{101,-220},{106,-220},{106,-226},{118,-226}},
      color={0,0,127}));
  connect(cooSetFre.y, pro6.u1)
    annotation (Line(points={{-59,-220},{-40,-220},{-40,-202},{108,-202},{108,-214},
      {118,-214}}, color={0,0,127}));
  connect(pro6.y, mulSum.u[4])
    annotation (Line(points={{141,-220},{148,-220},{148,-255.25},{158,-255.25}},
      color={0,0,127}));
  connect(and3.y, booToRea.u)
    annotation (Line(points={{-119,-270},{-116,-270},{-116,-310},{-148,-310},
      {-148,-330},{-142,-330}}, color={255,0,255}));
  connect(and5.y, booToRea1.u)
    annotation (Line(points={{-39,-270},{-34,-270},{-34,-310},{-68,-310},{-68,-330},
      {-62,-330}}, color={255,0,255}));
  connect(and6.y, booToRea2.u)
    annotation (Line(points={{41,-270},{46,-270},{46,-310},{12,-310},{12,-330},
      {18,-330}}, color={255,0,255}));
  connect(booToRea2.y, pro2.u2)
    annotation (Line(points={{41,-330},{68,-330},{94,-330},{94,-316},{118,-316}},
      color={0,0,127}));
  connect(booToRea1.y, pro1.u2)
    annotation (Line(points={{-39,-330},{-26,-330},{-26,-342},{100,-342},{100,-286},
      {118,-286}}, color={0,0,127}));
  connect(booToRea.y, pro.u2)
    annotation (Line(points={{-119,-330},{-100,-330},{-100,-346},{106,-346},
      {106,-256},{118,-256}}, color={0,0,127}));
  connect(cooSetFre.y, addPar2.u)
    annotation (Line(points={{-59,-220},{-40,-220},{-40,-240},{50,-240},{50,-250},
      {58,-250}}, color={0,0,127}));
  connect(cooSetFre.y, addPar1.u)
    annotation (Line(points={{-59,-220},{-40,-220},{-40,-240},{50,-240},{50,-280},
      {58,-280}}, color={0,0,127}));
  connect(cooSetFre.y, addPar3.u)
    annotation (Line(points={{-59,-220},{-40,-220},{-40,-240},{50,-240},{50,-310},
      {58,-310}}, color={0,0,127}));
  connect(intToRea1.y, greThr7.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-30,-250},
      {-30,-270},{-22,-270}},color={0,0,127}));
  connect(intToRea1.y, lesThr5.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-30,-250},
      {-30,-310},{-22,-310}},color={0,0,127}));
  connect(intToRea1.y, greThr6.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-108,-250},
      {-108,-270},{-102,-270}}, color={0,0,127}));
  connect(intToRea1.y, lesThr3.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-108,-250},
      {-108,-310},{-102,-310}}, color={0,0,127}));
  connect(intToRea1.y, greThr5.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-190,-250},
      {-190,-270},{-182,-270}}, color={0,0,127}));
  connect(intToRea1.y, lesThr2.u)
    annotation (Line(points={{-259,-230},{-250,-230},{-250,-250},{-190,-250},
      {-190,-310},{-182,-310}}, color={0,0,127}));
  connect(or2.y, edg.u)
    annotation (Line(points={{-139,-180},{-120,-180},{-120,-200},{-160,-200},
      {-160,-220},{-142,-220}}, color={255,0,255}));
  connect(edg.y, cooSetFre.trigger)
    annotation (Line(points={{-119,-220},{-112,-220},{-112,-238},{-70,-238},
      {-70,-231.8}}, color={255,0,255}));
  connect(edg.y, heaSetFre.trigger)
    annotation (Line(points={{-119,-220},{-112,-220},{-112,-398},{-70,-398},
      {-70,-391.8}}, color={255,0,255}));
  connect(greThr3.y, or2.u2)
    annotation (Line(points={{-179,-180},{-174,-180},{-174,-188},{-162,-188}},
      color={255,0,255}));
  connect(greThr2.y, or2.u1)
    annotation (Line(points={{-219,-180},{-216,-180},{-216,-160},{-170,-160},
      {-170,-180},{-162,-180}}, color={255,0,255}));
  connect(and3.y, or1.u1)
    annotation (Line(points={{-119,-270},{-116,-270},{-116,-242},{-18,-242},
      {-18,-212},{-2,-212}}, color={255,0,255}));
  connect(and5.y, or1.u2)
    annotation (Line(points={{-39,-270},{-34,-270},{-34,-246},{-12,-246},{-12,-220},
      {-2,-220}}, color={255,0,255}));
  connect(and6.y, or1.u3)
    annotation (Line(points={{41,-270},{46,-270},{46,-246},{-8,-246},{-8,-228},
      {-2,-228}}, color={255,0,255}));
  connect(heaSetFre.y, pro7.u1)
    annotation (Line(points={{-59,-380},{-40,-380},{-40,-360},{108,-360},{108,-374},
      {118,-374}}, color={0,0,127}));
  connect(booToRea7.y, pro7.u2)
    annotation (Line(points={{101,-380},{108,-380},{108,-386},{118,-386}},
      color={0,0,127}));
  connect(not2.y, booToRea7.u)
    annotation (Line(points={{61,-380},{69.5,-380},{78,-380}}, color={255,0,255}));
  connect(or4.y, not2.u)
    annotation (Line(points={{21,-380},{38,-380}}, color={255,0,255}));
  connect(and7.y, or4.u1)
    annotation (Line(points={{-119,-430},{-114,-430},{-114,-402},{-20,-402},
      {-20,-372},{-2,-372}}, color={255,0,255}));
  connect(and8.y, or4.u2)
    annotation (Line(points={{-39,-430},{-34,-430},{-34,-406},{-16,-406},{-16,-380},
      {-2,-380}}, color={255,0,255}));
  connect(and9.y, or4.u3)
    annotation (Line(points={{41,-430},{46,-430},{46,-406},{-12,-406},{-12,-388},
      {-2,-388}}, color={255,0,255}));
  connect(heaSetFre.y, addPar6.u)
    annotation (Line(points={{-59,-380},{-50,-380},{-40,-380},{-40,-400},{50,-400},
      {50,-410},{58,-410}}, color={0,0,127}));
  connect(heaSetFre.y, addPar5.u)
    annotation (Line(points={{-59,-380},{-50,-380},{-40,-380},{-40,-400},{50,-400},
      {50,-440},{58,-440}}, color={0,0,127}));
  connect(heaSetFre.y, addPar4.u)
    annotation (Line(points={{-59,-380},{-50,-380},{-40,-380},{-40,-400},{50,-400},
      {50,-470},{58,-470}}, color={0,0,127}));
  connect(pro7.y, mulSum1.u[4])
    annotation (Line(points={{141,-380},{148,-380},{148,-415.25},{158,-415.25}},
      color={0,0,127}));
  connect(or2.y, not3.u)
    annotation (Line(points={{-139,-180},{-94,-180},{38,-180}}, color={255,0,255}));
  connect(con2.y, or5.u1)
    annotation (Line(points={{61,-150},{88,-150},{118,-150}}, color={255,0,255}));
  connect(not3.y, or5.u2)
    annotation (Line(points={{61,-180},{80,-180},{80,-158},{118,-158}},
      color={255,0,255}));
  connect(or5.y, swi10.u2)
    annotation (Line(points={{141,-150},{198,-150}}, color={255,0,255}));
  connect(mulSum.y, swi10.u3)
    annotation (Line(points={{181.7,-250},{186,-250},{186,-158},{198,-158}},
      color={0,0,127}));
  connect(mulSum1.y, swi11.u3)
    annotation (Line(points={{181.7,-410},{190,-410},{190,-200},{198,-200}},
      color={0,0,127}));
  connect(cooSetSam.y, cooSetInc.u)
    annotation (Line(points={{1,130},{1,130},{18,130}}, color={0,0,127}));
  connect(heaSetSam.y, heaSetDec.u)
    annotation (Line(points={{1,90},{1,90},{18,90}}, color={0,0,127}));
  connect(setAdj, swi4.u1)
    annotation (Line(points={{-400,-40},{-320,-40},{-320,-52},{-302,-52}},
      color={0,0,127}));
  connect(add2.y, swi2.u1)
    annotation (Line(points={{-219,-60},{-200,-60},{-200,-68},{-182,-68}},
      color={0,0,127}));
  connect(and1.y, or3.u3)
    annotation (Line(points={{-199,220},{-180,220},{-180,142},{-82,142}},
      color={255,0,255}));
  connect(and4.y, or3.u2)
    annotation (Line(points={{-199,180},{-180,180},{-180,150},{-82,150}},
      color={255,0,255}));
  connect(and2.y, or3.u1)
    annotation (Line(points={{-99,220},{-90,220},{-90,158},{-82,158}},
      color={255,0,255}));
  connect(or3.y, swi.u2)
    annotation (Line(points={{-59,150},{-50,150},{-50,128},{-350,128},
      {-350,102},{-342,102}}, color={255,0,255}));
  connect(or3.y, swi1.u2)
    annotation (Line(points={{-59,150},{-50,150},{-50,128},{-252,128},
      {-252,102},{-242,102}}, color={255,0,255}));
  connect(occCooSet, swi.u1)
    annotation (Line(points={{-400,180},{-360,180},{-360,110},{-342,110}},
      color={0,0,127}));
  connect(occHeaSet, swi1.u1)
    annotation (Line(points={{-400,140},{-260,140},{-260,110},{-242,110}},
      color={0,0,127}));
  connect(unoCooSet, swi.u3)
    annotation (Line(points={{-400,80},{-360,80},{-360,94},{-342,94}},
      color={0,0,127}));
  connect(unoHeaSet, swi1.u3)
    annotation (Line(points={{-400,50},{-260,50},{-260,94},{-242,94}},
      color={0,0,127}));
  connect(swi4.y, swi6.u1)
    annotation (Line(points={{-279,-60},{-260,-60},{-260,-80},{8,-80},
      {8,-52},{18,-52}}, color={0,0,127}));
  connect(heaSetAdj, swi5.u1)
    annotation (Line(points={{-400,-110},{-80,-110},{-80,-52},{-22,-52}},
      color={0,0,127}));
  connect(con1.y, swi5.u3)
    annotation (Line(points={{1,-100},{8,-100},{8,-82},{-28,-82},{-28,-68},
      {-22,-68}}, color={0,0,127}));
  connect(sinSetAdjCon.y, swi6.u2)
    annotation (Line(points={{41,-100},{46,-100},{46,-82},{12,-82},{12,-60},
      {18,-60}}, color={255,0,255}));
  connect(swi5.y, swi6.u3)
    annotation (Line(points={{1,-60},{4,-60},{4,-68},{18,-68}}, color={0,0,127}));
  connect(swi6.y, add1.u2)
    annotation (Line(points={{41,-60},{50,-60},{50,-66},{58,-66}}, color={0,0,127}));
  connect(add1.y, swi3.u1)
    annotation (Line(points={{81,-60},{84,-60},{84,-68},{98,-68}}, color={0,0,127}));
  connect(and1.y, swi3.u2)
    annotation (Line(points={{-199,220},{-180,220},{-180,-40},{88,-40},
      {88,-60},{98,-60}}, color={255,0,255}));
  connect(and1.y, swi2.u2)
    annotation (Line(points={{-199,220},{-180,220},{-180,-40},{-192,-40},
      {-192,-60},{-182,-60}}, color={255,0,255}));
  connect(swi.y, add2.u1)
    annotation (Line(points={{-319,102},{-280,102},{-280,-40},{-260,-40},
      {-260,-54},{-242,-54}}, color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{-319,102},{-280,102},{-280,-40},{-200,-40},
      {-200,-52},{-182,-52}}, color={0,0,127}));
  connect(swi1.y, add1.u1)
    annotation (Line(points={{-219,102},{-200,102},{-200,-36},{48,-36},
      {48,-54},{58,-54}}, color={0,0,127}));
  connect(swi1.y, swi3.u3)
    annotation (Line(points={{-219,102},{-200,102},{-200,-36},{92,-36},
      {92,-52},{98,-52}},  color={0,0,127}));
  connect(or5.y, swi11.u2)
    annotation (Line(points={{141,-150},{141,-150},{180,-150},{180,-192},{198,-192}},
      color={255,0,255}));
  connect(swi2.y, cooSetFre.u)
    annotation (Line(points={{-159,-60},{-100,-60},{-100,-220},{-82,-220}},
      color={0,0,127}));
  connect(swi3.y, heaSetFre.u)
    annotation (Line(points={{121,-60},{140,-60},{140,-120},{-292,-120},{-292,-380},
      {-82,-380}}, color={0,0,127}));
  connect(and10.y, tim.u)
    annotation (Line(points={{41,220},{50,220},{50,200},{-30,200},{-30,180},
      {-22,180}}, color={255,0,255}));
  connect(and1.y, and10.u1)
    annotation (Line(points={{-199,220},{-180,220},{-180,240},{10,240},
      {10,220},{18,220}}, color={255,0,255}));
  connect(tim.y, greThr11.u)
    annotation (Line(points={{1,180},{8,180},{18,180}}, color={0,0,127}));
  connect(cooSetInc.y, swi12.u1)
    annotation (Line(points={{41,130},{46,130},{46,138},{58,138}}, color={0,0,127}));
  connect(heaSetDec.y, swi13.u1)
    annotation (Line(points={{41,90},{46,90},{46,98},{58,98}}, color={0,0,127}));
  connect(edg1.y, cooSetSam.trigger)
    annotation (Line(points={{81,160},{81,160},{90,160},{90,114},{-10,114},
      {-10,118.2}}, color={255,0,255}));
  connect(edg1.y, heaSetSam.trigger)
    annotation (Line(points={{81,160},{90,160},{90,74},{-10,74},{-10,78.2}},
      color={255,0,255}));
  connect(swi2.y, swi10.u1)
    annotation (Line(points={{-159,-60},{-100,-60},{-100,-126},{186,-126},
      {186,-142},{198,-142}}, color={0,0,127}));
  connect(swi3.y, swi11.u1)
    annotation (Line(points={{121,-60},{121,-60},{160,-60},{160,-184},{198,-184}},
      color={0,0,127}));
  connect(swi10.y, cooSetSam.u)
    annotation (Line(points={{221,-150},{230,-150},{230,-30},{-30,-30},{-30,130},
      {-22,130}}, color={0,0,127}));
  connect(swi10.y, swi12.u3)
    annotation (Line(points={{221,-150},{230,-150},{230,-30},{-30,-30},{-30,110},
      {58,110},{58,122}}, color={0,0,127}));
  connect(swi11.y, heaSetSam.u)
    annotation (Line(points={{221,-192},{228,-192},{236,-192},{236,-24},{-22,-24},
      {-22,90}}, color={0,0,127}));
  connect(swi11.y, swi13.u3)
    annotation (Line(points={{221,-192},{236,-192},{236,-24},{-22,-24},{-22,72},
      {58,72},{58,82}}, color={0,0,127}));
  connect(uOccSen, not4.u)
    annotation (Line(points={{-60,330},{-30,330},{-30,220},{-22,220}},
      color={255,0,255}));
  connect(cooSetWinOpe.y, swi14.u1)
    annotation (Line(points={{181,190},{194,190},{194,188},{200,188}},
      color={0,0,127}));
  connect(heaSetWinOpe.y, swi15.u1)
    annotation (Line(points={{181,150},{194,150},{194,148},{200,148}},
      color={0,0,127}));
  connect(grtEqu1.y, swi9.u2)
    annotation (Line(points={{301,90},{338,90}}, color={255,0,255}));
  connect(lesEqu.y, swi8.u2)
    annotation (Line(points={{301,50},{338,50}}, color={255,0,255}));
  connect(swi9.y, addPar.u)
    annotation (Line(points={{361,90},{384,90},{384,22},{230,22},{230,0},{238,0}},
      color={0,0,127}));
  connect(swi8.y, grtEqu.u1)
    annotation (Line(points={{361,50},{376,50},{376,18},{272,18},{272,0},{278,0}},
      color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{361,50},{376,50},{376,18},{320,18},{320,8},{338,8}},
      color={0,0,127}));
  connect(not5.y, and11.u1)
    annotation (Line(points={{181,220},{258,220}}, color={255,0,255}));
  connect(and1.y, not5.u)
    annotation (Line(points={{-199,220},{-180,220},{-180,240},{80,240},{80,220},
      {158,220}}, color={255,0,255}));
  connect(and11.y, swi16.u2)
    annotation (Line(points={{281,220},{298,220}}, color={255,0,255}));
  connect(alaZer.y, swi16.u3)
    annotation (Line(points={{281,180},{288,180},{288,212},{298,212}},
      color={0,0,127}));
  connect(alaFou.y, swi16.u1)
    annotation (Line(points={{281,150},{292,150},{292,228},{298,228}},
      color={0,0,127}));
  connect(swi16.y, reaToInt.u)
    annotation (Line(points={{321,220},{338,220}}, color={0,0,127}));
  connect(reaToInt.y, yAla)
    annotation (Line(points={{361,220},{430,220}}, color={255,127,0}));
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-400,220},{-362,220}}, color={255,127,0}));
  connect(uCooDemLimLev, intToRea1.u)
    annotation (Line(points={{-400,-230},{-282,-230}}, color={255,127,0}));
  connect(uHeaDemLimLev, intToRea2.u)
    annotation (Line(points={{-400,-410},{-282,-410}}, color={255,127,0}));
  connect(not4.y, and10.u2)
    annotation (Line(points={{1,220},{6,220},{6,212},{18,212}}, color={255,0,255}));
  connect(greThr11.y, truHol.u)
    annotation (Line(points={{41,180},{50,180},{50,190},{59,190}}, color={255,0,255}));
  connect(greThr11.y, edg1.u)
    annotation (Line(points={{41,180},{50,180},{50,160},{58,160}}, color={255,0,255}));
  connect(truHol.y, swi13.u2)
    annotation (Line(points={{81,190},{88,190},{88,176},{48,176},{48,90},{58,90}},
      color={255,0,255}));
  connect(truHol.y, swi12.u2)
    annotation (Line(points={{81,190},{88,190},{88,176},{48,176},{48,130},{58,130}},
      color={255,0,255}));
  connect(cooSetLim.y, swi17.u1)
    annotation (Line(points={{121,50},{130,50},{130,58},{158,58}},
      color={0,0,127}));
  connect(heaSetLim.y, swi18.u1)
    annotation (Line(points={{121,10},{130,10},{130,18},{158,18}},
      color={0,0,127}));
  connect(and1.y, swi17.u2)
    annotation (Line(points={{-199,220},{-180,220},{-180,30},{140,30},
      {140,50},{158,50}}, color={255,0,255}));
  connect(and1.y, swi18.u2)
    annotation (Line(points={{-199,220},{-180,220},{-180,30},{140,30},
      {140,10},{158,10}}, color={255,0,255}));
  connect(swi17.y, grtEqu1.u1)
    annotation (Line(points={{181,50},{230,50},{230,90},{278,90}},
      color={0,0,127}));
  connect(swi18.y, lesEqu.u1)
    annotation (Line(points={{181,10},{220,10},{220,32},{260,32},{260,50},{278,50}},
      color={0,0,127}));
  connect(swi17.y, swi9.u3)
    annotation (Line(points={{181,50},{230,50},{230,74},{320,74},{320,82},{338,82}},
      color={0,0,127}));
  connect(swi18.y, swi8.u3)
    annotation (Line(points={{181,10},{220,10},{220,32},{320,32},{320,42},
      {338,42}}, color={0,0,127}));
  connect(unoHeaSet, lesEqu.u2)
    annotation (Line(points={{-400,50},{-260,50},{-260,-18},{226,-18},
      {226,26},{270,26},{270,42},{278,42}}, color={0,0,127}));
  connect(unoHeaSet, swi8.u1)
    annotation (Line(points={{-400,50},{-260,50},{-260,-18},{226,-18},
      {226,26},{312,26},{312,58},{338,58}}, color={0,0,127}));
  connect(unoCooSet, grtEqu1.u2)
    annotation (Line(points={{-400,80},{-360,80},{-360,68},{270,68},
      {270,82},{278,82}}, color={0,0,127}));
  connect(unoCooSet, swi9.u1)
    annotation (Line(points={{-400,80},{-360,80},{-360,68},{312,68},{312,98},
      {338,98}}, color={0,0,127}));
  connect(swi7.y, THeaSet)
    annotation (Line(points={{361,0},{384,0},{384,-20},{430,-20}}, color={0,0,127}));
  connect(swi9.y, TCooSet)
    annotation (Line(points={{361,90},{384,90},{384,20},{430,20}},
      color={0,0,127}));
  connect(occSenCon.y, swi20.u2)
    annotation (Line(points={{1,300},{58,300}}, color={255,0,255}));
  connect(occSenCon.y, swi19.u2)
    annotation (Line(points={{1,300},{28,300},{28,270},{58,270}}, color={255,0,255}));
  connect(winSenCon.y, swi22.u2)
    annotation (Line(points={{181,300},{218,300}}, color={255,0,255}));
  connect(winSenCon.y, swi21.u2)
    annotation (Line(points={{181,300},{190,300},{190,270},{218,270}},
      color={255,0,255}));
  connect(uWinSta, swi15.u2)
    annotation (Line(points={{120,330},{154,330},{154,240},{188,240},
      {188,140},{200,140}}, color={255,0,255}));
  connect(uWinSta, swi14.u2)
    annotation (Line(points={{120,330},{154,330},{154,240},{188,240},
      {188,180},{200,180}}, color={255,0,255}));
  connect(uWinSta, and11.u2)
    annotation (Line(points={{120,330},{154,330},{154,240},{188,240},
      {188,212},{258,212}}, color={255,0,255}));
  connect(swi10.y, swi20.u3)
    annotation (Line(points={{221,-150},{392,-150},{392,244},{20,244},
      {20,292},{58,292}}, color={0,0,127}));
  connect(swi11.y, swi19.u3)
    annotation (Line(points={{221,-192},{221,-190},{400,-190},{400,248},
      {48,248},{48,262},{58,262}}, color={0,0,127}));
  connect(swi12.y, swi20.u1)
    annotation (Line(points={{81,130},{94,130},{94,252},{12,252},{12,308},
      {58,308}}, color={0,0,127}));
  connect(swi13.y, swi19.u1)
    annotation (Line(points={{81,90},{100,90},{100,256},{40,256},{40,278},
      {58,278}}, color={0,0,127}));
  connect(swi20.y, swi14.u3)
    annotation (Line(points={{81,300},{112,300},{112,172},{200,172}},
      color={0,0,127}));
  connect(swi19.y, swi15.u3)
    annotation (Line(points={{81,270},{106,270},{106,132},{200,132}},
      color={0,0,127}));
  connect(swi20.y, swi22.u3)
    annotation (Line(points={{81,300},{112,300},{112,280},{196,280},
      {196,292},{218,292}}, color={0,0,127}));
  connect(swi19.y, swi21.u3)
    annotation (Line(points={{81,270},{106,270},{106,260},{150,260},
      {150,262},{218,262}}, color={0,0,127}));
  connect(swi14.y, swi22.u1)
    annotation (Line(points={{223,180},{234,180},{234,252},{202,252},
      {202,308},{218,308}}, color={0,0,127}));
  connect(swi15.y, swi21.u1)
    annotation (Line(points={{223,140},{240,140},{240,256},{208,256},
      {208,278},{218,278}}, color={0,0,127}));
  connect(swi22.y, cooSetLim.u)
    annotation (Line(points={{241,300},{252,300},{252,120},{208,120},
      {208,34},{90,34},{90,50},{98,50}}, color={0,0,127}));
  connect(swi22.y, swi17.u3)
    annotation (Line(points={{241,300},{252,300},{252,120},{208,120},
      {208,34},{150,34},{150,42},{158,42}}, color={0,0,127}));
  connect(swi21.y, heaSetLim.u)
    annotation (Line(points={{241,270},{246,270},{246,124},{200,124},
      {200,-8},{90,-8},{90,10},{98,10}}, color={0,0,127}));
  connect(swi21.y, swi18.u3)
    annotation (Line(points={{241,270},{246,270},{246,124},{200,124},
      {200,-8},{150,-8},{150,2},{158,2}}, color={0,0,127}));
  connect(con3.y, swi4.u1)
    annotation (Line(points={{-339,-20},{-320,-20},{-320,-52},{-302,-52}},
      color={0,0,127}));
  connect(con4.y, swi5.u1)
    annotation (Line(points={{-279,-90},{-260,-90},{-260,-110},{-80,-110},
      {-80,-52},{-22,-52}}, color={0,0,127}));
  connect(conTru.y, not4.u)
    annotation (Line(points={{1,268},{8,268},{8,246},{-30,246},{-30,220},
      {-22,220}}, color={255,0,255}));
  connect(conFal.y, swi15.u2)
    annotation (Line(points={{141,300},{154,300},{154,240},{188,240},
      {188,140},{200,140}}, color={255,0,255}));
  connect(conFal.y, swi14.u2)
    annotation (Line(points={{141,300},{154,300},{154,240},{188,240},
      {188,180},{200,180}}, color={255,0,255}));
  connect(conFal.y, and11.u2)
    annotation (Line(points={{141,300},{154,300},{154,240},{188,240},
      {188,212},{258,212}}, color={255,0,255}));

  annotation (
  defaultComponentName="zonSetpoint",
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-380,-520},{420,320}}), graphics={
        Rectangle(
          extent={{-372,248},{-54,136}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-36,340},{108,76}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{150,338},{364,124}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{230,108},{370,-18}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{80,70},{198,-14}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-364,-38},{168,-120}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-334,-132},{226,-512}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{208,-284},{584,-352}},
          lineColor={0,0,255},
          textString="Adjust setpoint according 
to demand limit level",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{172,-46},{340,-108}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Local knob adjustment"),
        Text(
          extent={{406,84},{532,34}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Prevent overlap"),
        Text(
          extent={{278,324},{606,270}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Adjust setpoint according 
to window status
"),     Text(
          extent={{-370,320},{-42,266}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Right,
          textString="Adjust setpoint according 
to occupancy status
"),     Text(
          extent={{-306,280},{-148,240}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Right,
          textString="Check operation status"),
        Text(
          extent={{-56,52},{78,6}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Right,
          textString="Limited 
setpoint")}),
    Icon(coordinateSystem(extent={{-200,
            -200},{200,200}}, initialScale=0.1), graphics={
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
 Documentation(info="<html>      
<p>
This atomic sequence sets thermal zone cooling and heating setpoint. The implementation
is according to the ASHRAE Guideline 36 (G36), PART5.B.3. The calculation is done 
following steps below.
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
to exempt individual zones from this adjustment through the normal BAS user
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
end ZoneSetpoint;
