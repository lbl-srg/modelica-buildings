within Buildings.Controls.OBC.ASHRAE.G36.ThermalZones;
block Setpoints
  "Block outputs thermal zone cooling and heating active setpoint"

  parameter Boolean have_occSen "Check if the zone has occupancy sensor"
    annotation (__cdl(ValueInReference=false), Dialog(group="Sensors"));
  parameter Boolean have_winSen
    "Check if the zone has window status sensor"
    annotation (__cdl(ValueInReference=false), Dialog(group="Sensors"));
  parameter Boolean have_locAdj=true
    "True: the zone has local setpoint adjustment knob"
    annotation (__cdl(ValueInReference=false), Dialog(group="Setpoint adjustable setting"));
  parameter Boolean sepAdj=true
    "True: cooling and heating setpoint can be adjusted separately"
    annotation (__cdl(ValueInReference=false), Dialog(group="Setpoint adjustable setting", enable=have_locAdj));
  parameter Boolean ignDemLim = true
    "True: exempt the individual zone from demand limit setpoint adjustment"
    annotation (__cdl(ValueInReference=false), Dialog(group="Setpoint adjustable setting"));
  parameter Real TActCoo_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=300.15
    "Maximum active cooling setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoints limits setting"));
  parameter Real TActCoo_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Minimum active cooling setpoint"
    annotation (__cdl(ValueInReference=true), Dialog(group="Setpoints limits setting"));
  parameter Real TActHea_max(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Maximum active heating setpoint"
    annotation (__cdl(ValueInReference=true), Dialog(group="Setpoints limits setting"));
  parameter Real TActHea_min(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Minimum active heating setpoint"
    annotation (__cdl(ValueInReference=true), Dialog(group="Setpoints limits setting"));
  parameter Real TWinOpeCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15
    "Cooling setpoint when window is open"
    annotation (__cdl(ValueInReference=true), Dialog(group="Setpoints limits setting", enable=have_winSen));
  parameter Real TWinOpeHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Heating setpoint when window is open"
    annotation (__cdl(ValueInReference=true), Dialog(group="Setpoints limits setting", enable=have_winSen));
  parameter Real incTSetDem_1(unit="K")=0.5
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));
  parameter Real incTSetDem_2(unit="K")=1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));
  parameter Real incTSetDem_3(unit="K")=2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));
  parameter Real decTSetDem_1(unit="K")=0.5
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));
  parameter Real decTSetDem_2(unit="K")=1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));
  parameter Real decTSetDem_3(unit="K")=2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Setpoint adjustment", tab="Demand control", enable=not ignDemLim));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-460,610},{-420,650}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-460,510},{-420,550}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-460,470},{-420,510}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-460,430},{-420,470}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-460,390},{-420,430}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    final quantity="TemperatureDifference")
    if have_locAdj and not sepAdj
    "The adjustment value for both heating and cooling setpoints if it allows only single setpoint adjustment"
    annotation (Placement(transformation(extent={{-460,330},{-420,370}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooSetAdj(
    final unit="K",
    final quantity="TemperatureDifference")
    if have_locAdj and sepAdj
    "Cooling setpoint adjustment value"
    annotation (Placement(transformation(extent={{-460,290},{-420,330}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    final quantity="TemperatureDifference")
    if have_locAdj and sepAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-460,250},{-420,290}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-460,110},{-420,150}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-460,-110},{-420,-70}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-460,-290},{-420,-250}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-460,-430},{-420,-390}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{340,-20},{380,20}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{340,-120},{380,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla "Alarm level"
    annotation (Placement(transformation(extent={{340,-410},{380,-370}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if there is cooling/heating demand limit being imposed"
    annotation (Placement(transformation(extent={{-280,-40},{-260,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg "If demand limit is imposed"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler cooSetFre
    "Freeze current cooling setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5
    "Check if demand limit should be ignored or if there is no demand limit"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check if cooling demand limit level is imposed"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logic not"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar3(
    final p=incTSetDem_3)
    "Increase cooling setpoint when at demand limit level 3"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=incTSetDem_2)
    "Increase cooling setpoint when at demand limit level 2"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar2(
    final p=incTSetDem_1)
    "Increase cooling setpoint when at demand limit level 1"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro6
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler heaSetFre
    "Freeze current heating setpoint when demand limit is imposed"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if heating demand limit level is imposed"
    annotation (Placement(transformation(extent={{-60,-74},{-40,-54}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro7
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar6(
    final p=-decTSetDem_1)
    "Decrease heating setpoint when at demand limit level 1"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar5(
    final p=-decTSetDem_2)
    "Decrease heating setpoint when at demand limit level 2"
    annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar4(
    final p=-decTSetDem_3)
    "Decrease heating setpoint when at demand limit level 3"
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro5
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,-200},{100,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro4
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,-160},{100,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro3
    "Output product of the two inputs"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=300)
    "Check whether the zone has been unpopulated for 5 minutes continuously during occupied mode"
    annotation (Placement(transformation(extent={{-220,-280},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHold truHol(
    final duration=60)
    "When the zone is unpopulated by more than threshold time and then becomes populated, hold the change by short period"
    annotation (Placement(transformation(extent={{-100,-280},{-80,-260}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Instant when the zone becomes more than 5 minutes"
    annotation (Placement(transformation(extent={{-40,-280},{-20,-260}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter heaSetDec(
    final p=-0.5)
    "Heating setpoint decrease due to continuously unpopulated under occupied mode"
    annotation (Placement(transformation(extent={{100,-320},{120,-300}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter cooSetInc(
    final p=0.5)
    "Cooling setpoint increase due to continuously unpopulated under occupied mode"
    annotation (Placement(transformation(extent={{100,-280},{120,-260}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler cooSetSam
    "Sample current cooling setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{40,-280},{60,-260}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler heaSetSam
    "Sample current heating setpoint when zone becomes unpopulated by 5 minutes"
    annotation (Placement(transformation(extent={{40,-320},{60,-300}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Adjusted heating setpoint"
    annotation (Placement(transformation(extent={{140,240},{160,260}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Adjusted cooling setpoint"
    annotation (Placement(transformation(extent={{-200,340},{-180,360}})));
  Buildings.Controls.OBC.CDL.Reals.Limiter cooSetLim(
    final uMax=TActCoo_max,
    final uMin=TActCoo_min)
    "Limit occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-240,-530},{-220,-510}})));
  Buildings.Controls.OBC.CDL.Reals.Limiter heaSetLim(
    final uMax=TActHea_max,
    final uMin=TActHea_min)
    "Limit occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-240,-590},{-220,-570}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-0.5)
    "Cooling setpoint minus the minimum difference between cooling and heating setpoints"
    annotation (Placement(transformation(extent={{160,-590},{180,-570}})));
  Buildings.Controls.OBC.CDL.Logical.Or or6
    "Current operation mode is occupied, warm-up, or cooldown mode"
    annotation (Placement(transformation(extent={{-80,610},{-60,630}})));
  Buildings.Controls.OBC.CDL.Logical.Or or7
    "Check if cooling demand limit level is imposed"
    annotation (Placement(transformation(extent={{-30,140},{-10,160}})));
  Buildings.Controls.OBC.CDL.Logical.Or or8
    "Check if heating demand limit level is imposed"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is warm-up mode"
    annotation (Placement(transformation(extent={{-300,600},{-280,620}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-200,600},{-180,620}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-120,580},{-100,600}})));
  Buildings.Controls.OBC.CDL.Logical.Or or9
    "Current operation mode is occupied, warm-up, or cooldown mode"
    annotation (Placement(transformation(extent={{-20,600},{0,620}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm-up mode"
    annotation (Placement(transformation(extent={{-340,570},{-320,590}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cooldown mode"
    annotation (Placement(transformation(extent={{-240,570},{-220,590}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-180,570},{-160,590}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooSetAdjCon(
    final k=have_locAdj)
    "Cooling setpoint adjustable"
    annotation (Placement(transformation(extent={{-340,320},{-320,340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-340,280},{-320,300}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=0) if not have_locAdj
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-340,360},{-320,380}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    final k=0) if not have_locAdj
    "Zero adjustment"
    annotation (Placement(transformation(extent={{-60,280},{-40,300}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant heaSetAdjCon(
    final k=have_locAdj)
    "Heating setpoint adjustable"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=0) "Zero adjustment"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=ignDemLim)
    "Check whether the zone should exempt from setpoint adjustment due to the demand limit"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conTru(
    final k=true) if not have_occSen
    "Constant true"
    annotation (Placement(transformation(extent={{-380,-360},{-360,-340}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conFal(
    final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-380,-480},{-360,-460}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSenCon(
    final k=have_winSen)
    "Check if there is window status sensor"
    annotation (Placement(transformation(extent={{40,-480},{60,-460}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant have_occSenCon(
    final k=have_occSen)
    "Check if there is occupancy sensor"
    annotation (Placement(transformation(extent={{160,-360},{180,-340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooSetWinOpe(
    final k=TWinOpeCooSet)
    "Cooling setpoint when window is open"
    annotation (Placement(transformation(extent={{-240,-480},{-220,-460}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaSetWinOpe(
    final k=TWinOpeHeaSet)
    "Heating setpoint when window is open"
    annotation (Placement(transformation(extent={{-120,-480},{-100,-460}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant alaZer(
    final k=-0.2)
    "Alarm level 0"
    annotation (Placement(transformation(extent={{-180,-400},{-160,-380}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant alaFou(
    final k=3.8)
    "Alarm level 4"
    annotation (Placement(transformation(extent={{-140,-400},{-120,-380}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{160,-400},{180,-380}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea6
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea5
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea7
    "Convert boolean to real value"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.And and11
    "Check if window is open during operation modes other than occupied"
    annotation (Placement(transformation(extent={{-220,-420},{-200,-400}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5  "Other than occupied mode"
    annotation (Placement(transformation(extent={{-280,-400},{-260,-380}})));
  Buildings.Controls.OBC.CDL.Reals.Less les
    "Check if occupied cooling setpoint is less than unoccupied one"
    annotation (Placement(transformation(extent={{20,-550},{40,-530}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if occupied heating setpoint is greater than unoccupied one"
    annotation (Placement(transformation(extent={{20,-610},{40,-590}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2
    "Check if the difference between cooling and heating setpoints is less than the minimum value"
    annotation (Placement(transformation(extent={{220,-590},{240,-570}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-300,520},{-280,540}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between occupied and unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-300,440},{-280,460}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2
    "Adjustment shall only affect occupied set point"
    annotation (Placement(transformation(extent={{-120,360},{-100,340}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Setpoint can only be adjusted in occupied mode"
    annotation (Placement(transformation(extent={{220,260},{240,240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4
    "If there is no cooling adjustment, zero adjust"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "If there is no heating adjustment, zero adjust"
    annotation (Placement(transformation(extent={{80,240},{100,260}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi7
    "Ensure heating setpoint being not higher than cooling setpoint minus 0.5 degC"
    annotation (Placement(transformation(extent={{280,-590},{300,-570}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi8
    "Ensure unoccupied heating setppint being lower than occupied one"
    annotation (Placement(transformation(extent={{100,-610},{120,-590}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi9
    "Ensure unoccupied cooling setppint being higher than occupied one"
    annotation (Placement(transformation(extent={{100,-550},{120,-530}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi10
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{220,80},{240,100}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi11
    "Switch between occupied and unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{220,-140},{240,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi12
    "Increase cooling setpoint when the zone is continuously unpopulated"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi13
    "Decrease heating setpoint when the zone is continuously unpopulated"
    annotation (Placement(transformation(extent={{160,-320},{180,-300}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi14
    "Switch to TWinOpeCooSet when window is open"
    annotation (Placement(transformation(extent={{-180,-460},{-160,-440}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi15
    "Switch to TWinOpeHeaSet when window is open"
    annotation (Placement(transformation(extent={{-60,-460},{-40,-440}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi16
    "Generate level 4 alarm when window is open during modes other than occupied"
    annotation (Placement(transformation(extent={{-100,-420},{-80,-400}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi17
    "If it is occupied mode, cooling setpoint should be limited"
    annotation (Placement(transformation(extent={{-180,-550},{-160,-530}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi18
    "If it is occupied mode, heating setpoint should be limited"
    annotation (Placement(transformation(extent={{-180,-610},{-160,-590}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi19
    "If there is occupancy sensor, update heating setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{220,-320},{240,-300}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi20
    "If there is occupancy sensor, update cooling setpoint according to the occupancy"
    annotation (Placement(transformation(extent={{220,-280},{240,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi21
    "If there is window status sensor, update heating setpoint according to the window status"
    annotation (Placement(transformation(extent={{160,-480},{180,-460}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi22
    "If there is window status sensor, update cooling setpoint according to the window status"
    annotation (Placement(transformation(extent={{100,-460},{120,-440}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu7
    "Check if the heating demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt8(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.heating3)
    "Heat demand limit level 3"
    annotation (Placement(transformation(extent={{-160,-200},{-140,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu8
    "Check if the heating demand limit level is level 3"
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-340,-280},{-320,-260}})));
  Buildings.Controls.OBC.CDL.Logical.And and10
    "Check if the zone becomes unpopulated during occupied mode"
    annotation (Placement(transformation(extent={{-280,-280},{-260,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt6(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.heating1)
    "Heat demand limit level 1"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu6
    "Check if the heating demand limit level is level 1"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt7(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.heating2)
    "Heat demand limit level 2"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr
    "Check if cooling demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-340,-20},{-320,0}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr1
    "Check if heating demand limit level is higher than level zero"
    annotation (Placement(transformation(extent={{-340,-60},{-320,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.cooling1)
    "Cool demand limit level 1"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if the cooling demand limit level is level 1"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.cooling2)
    "Cool demand limit level 2"
    annotation (Placement(transformation(extent={{-160,62},{-140,82}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if the cooling demand limit level is level 2"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.DemandLimitLevels.cooling3)
    "Cool demand limit level 3"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu5
    "Check if the cooling demand limit level is level 3"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Add real inputs"
    annotation (Placement(transformation(extent={{120,118},{140,138}})));
  Buildings.Controls.OBC.CDL.Reals.Add add4 "Add real inputs"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Buildings.Controls.OBC.CDL.Reals.Add add5 "Add real inputs"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
  Buildings.Controls.OBC.CDL.Reals.Add add6 "Add real inputs"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Add add7 "Add real inputs"
    annotation (Placement(transformation(extent={{120,-180},{140,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Add add8 "Add real inputs"
    annotation (Placement(transformation(extent={{160,-140},{180,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not winOpe if have_winSen "Window is open"
    annotation (Placement(transformation(extent={{-380,-420},{-360,-400}})));
equation
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-440,630},{-320,630},{-320,610},{-302,610}},
      color={255,127,0}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-440,630},{-220,630},{-220,610},{-202,610}},
      color={255,127,0}));
  connect(uOpeMod, intEqu2.u1)
    annotation (Line(points={{-440,630},{-140,630},{-140,590},{-122,590}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-318,580},{-310,580},{-310,602},{-302,602}},
      color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-218,580},{-210,580},{-210,602},{-202,602}},
      color={255,127,0}));
  connect(conInt2.y, intEqu2.u2)
    annotation (Line(points={{-158,580},{-140,580},{-140,582},{-122,582}},
      color={255,127,0}));
  connect(TOccCooSet, swi.u1) annotation (Line(points={{-440,530},{-360,530},{-360,
          538},{-302,538}}, color={0,0,127}));
  connect(TUnoCooSet, swi.u3) annotation (Line(points={{-440,490},{-360,490},{-360,
          522},{-302,522}}, color={0,0,127}));
  connect(TOccHeaSet, swi1.u1) annotation (Line(points={{-440,450},{-360,450},{-360,
          458},{-302,458}}, color={0,0,127}));
  connect(TUnoHeaSet, swi1.u3) annotation (Line(points={{-440,410},{-360,410},{-360,
          442},{-302,442}}, color={0,0,127}));
  connect(or9.y, swi.u2)
    annotation (Line(points={{2,610},{20,610},{20,560},{-320,560},{-320,530},
      {-302,530}},   color={255,0,255}));
  connect(or9.y, swi1.u2)
    annotation (Line(points={{2,610},{20,610},{20,560},{-320,560},{-320,450},
      {-302,450}},   color={255,0,255}));
  connect(cooSetAdjCon.y, swi4.u2)
    annotation (Line(points={{-318,330},{-282,330}}, color={255,0,255}));
  connect(setAdj, swi4.u1)
    annotation (Line(points={{-440,350},{-300,350},{-300,338},{-282,338}},
      color={0,0,127}));
  connect(con3.y, swi4.u1)
    annotation (Line(points={{-318,370},{-300,370},{-300,338},{-282,338}},
      color={0,0,127}));
  connect(con.y, swi4.u3)
    annotation (Line(points={{-318,290},{-300,290},{-300,322},{-282,322}},
      color={0,0,127}));
  connect(swi4.y, add2.u2)
    annotation (Line(points={{-258,330},{-220,330},{-220,344},{-202,344}},
      color={0,0,127}));
  connect(swi.y, add2.u1)
    annotation (Line(points={{-278,530},{-220,530},{-220,356},{-202,356}},
      color={0,0,127}));
  connect(add2.y, swi2.u1)
    annotation (Line(points={{-178,350},{-160,350},{-160,342},{-122,342}},
      color={0,0,127}));
  connect(swi.y, swi2.u3)
    annotation (Line(points={{-278,530},{-220,530},{-220,380},{-160,380},{-160,358},
          {-122,358}}, color={0,0,127}));
  connect(swi6.y, add1.u2)
    annotation (Line(points={{102,250},{120,250},{120,244},{138,244}},
      color={0,0,127}));
  connect(add1.y, swi3.u1)
    annotation (Line(points={{162,250},{180,250},{180,242},{218,242}},
      color={0,0,127}));
  connect(swi1.y, add1.u1)
    annotation (Line(points={{-278,450},{120,450},{120,256},{138,256}},
      color={0,0,127}));
  connect(swi1.y, swi3.u3)
    annotation (Line(points={{-278,450},{120,450},{120,280},{180,280},{180,258},
          {218,258}}, color={0,0,127}));
  connect(intEqu2.y, swi3.u2)
    annotation (Line(points={{-98,590},{-60,590},{-60,380},{200,380},{200,250},{
          218,250}}, color={255,0,255}));
  connect(uCooDemLimLev, intGreThr.u)
    annotation (Line(points={{-440,130},{-360,130},{-360,-10},{-342,-10}},
      color={255,127,0}));
  connect(uHeaDemLimLev, intGreThr1.u)
    annotation (Line(points={{-440,-90},{-360,-90},{-360,-50},{-342,-50}},
      color={255,127,0}));
  connect(intGreThr1.y, or2.u2)
    annotation (Line(points={{-318,-50},{-300,-50},{-300,-38},{-282,-38}},
      color={255,0,255}));
  connect(intGreThr.y, or2.u1)
    annotation (Line(points={{-318,-10},{-300,-10},{-300,-30},{-282,-30}},
      color={255,0,255}));
  connect(or2.y, edg.u)
    annotation (Line(points={{-258,-30},{-240,-30},{-240,0},{-222,0}},
      color={255,0,255}));
  connect(intEqu3.y, booToRea.u)
    annotation (Line(points={{-78,110},{-42,110}}, color={255,0,255}));
  connect(intEqu4.y, booToRea1.u)
    annotation (Line(points={{-78,70},{-42,70}}, color={255,0,255}));
  connect(intEqu5.y, booToRea2.u)
    annotation (Line(points={{-78,30},{-42,30}}, color={255,0,255}));
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
    annotation (Line(points={{-138,110},{-128,110},{-128,102},{-102,102}},
      color={255,127,0}));
  connect(conInt4.y, intEqu4.u2)
    annotation (Line(points={{-138,72},{-128,72},{-128,62},{-102,62}},
      color={255,127,0}));
  connect(conInt5.y, intEqu5.u2)
    annotation (Line(points={{-138,30},{-128,30},{-128,22},{-102,22}},
      color={255,127,0}));
  connect(intEqu3.y, or1.u1)
    annotation (Line(points={{-78,110},{-70,110},{-70,160},{-62,160}},
      color={255,0,255}));
  connect(intEqu4.y, or1.u2)
    annotation (Line(points={{-78,70},{-70,70},{-70,152},{-62,152}},
      color={255,0,255}));
  connect(not1.y, booToRea6.u)
    annotation (Line(points={{22,150},{38,150}}, color={255,0,255}));
  connect(booToRea.y, pro.u2)
    annotation (Line(points={{-18,110},{0,110},{0,92},{70,92},{70,104},{78,104}},
      color={0,0,127}));
  connect(cooSetFre.y, addPar2.u)
    annotation (Line(points={{-138,150},{-100,150},{-100,132},{20,132},{20,110},
          {38,110}}, color={0,0,127}));
  connect(cooSetFre.y, addPar1.u)
    annotation (Line(points={{-138,150},{-100,150},{-100,132},{20,132},{20,70},{
          38,70}}, color={0,0,127}));
  connect(cooSetFre.y, addPar3.u)
    annotation (Line(points={{-138,150},{-100,150},{-100,132},{20,132},{20,30},{
          38,30}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2)
    annotation (Line(points={{-18,70},{0,70},{0,52},{72,52},{72,64},{78,64}},
      color={0,0,127}));
  connect(booToRea2.y, pro2.u2)
    annotation (Line(points={{-18,30},{0,30},{0,12},{70,12},{70,24},{78,24}},
      color={0,0,127}));
  connect(addPar2.y, pro.u1)
    annotation (Line(points={{62,110},{70,110},{70,116},{78,116}},
      color={0,0,127}));
  connect(cooSetFre.y, pro6.u2)
    annotation (Line(points={{-138,150},{-100,150},{-100,132},{70,132},{70,144},
          {78,144}}, color={0,0,127}));
  connect(booToRea6.y, pro6.u1)
    annotation (Line(points={{62,150},{70,150},{70,156},{78,156}},
      color={0,0,127}));
  connect(addPar1.y, pro1.u1)
    annotation (Line(points={{62,70},{72,70},{72,76},{78,76}},
      color={0,0,127}));
  connect(addPar3.y, pro2.u1)
    annotation (Line(points={{62,30},{70,30},{70,36},{78,36}},
      color={0,0,127}));
  connect(or2.y, not3.u)
    annotation (Line(points={{-258,-30},{-102,-30}}, color={255,0,255}));
  connect(con2.y, or5.u1)
    annotation (Line(points={{-138,-10},{158,-10}}, color={255,0,255}));
  connect(not3.y, or5.u2)
    annotation (Line(points={{-78,-30},{-60,-30},{-60,-18},{158,-18}},
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
    annotation (Line(points={{-138,-110},{-130,-110},{-130,-118},{-102,-118}},
      color={255,127,0}));
  connect(conInt7.y, intEqu7.u2)
    annotation (Line(points={{-138,-150},{-130,-150},{-130,-158},{-102,-158}},
      color={255,127,0}));
  connect(conInt8.y, intEqu8.u2)
    annotation (Line(points={{-138,-190},{-130,-190},{-130,-198},{-102,-198}},
      color={255,127,0}));
  connect(intEqu6.y, booToRea3.u)
    annotation (Line(points={{-78,-110},{-42,-110}}, color={255,0,255}));
  connect(intEqu7.y, booToRea4.u)
    annotation (Line(points={{-78,-150},{-42,-150}}, color={255,0,255}));
  connect(intEqu8.y, booToRea5.u)
    annotation (Line(points={{-78,-190},{-42,-190}}, color={255,0,255}));
  connect(intEqu6.y, or4.u1)
    annotation (Line(points={{-78,-110},{-70,-110},{-70,-64},{-62,-64}},
      color={255,0,255}));
  connect(intEqu7.y, or4.u2)
    annotation (Line(points={{-78,-150},{-70,-150},{-70,-72},{-62,-72}},
      color={255,0,255}));
  connect(not2.y, booToRea7.u)
    annotation (Line(points={{22,-70},{38,-70}}, color={255,0,255}));
  connect(booToRea7.y, pro7.u1)
    annotation (Line(points={{62,-70},{70,-70},{70,-64},{78,-64}},
      color={0,0,127}));
  connect(heaSetFre.y, pro7.u2)
    annotation (Line(points={{-138,-70},{-100,-70},{-100,-88},{70,-88},{70,-76},
          {78,-76}}, color={0,0,127}));
  connect(heaSetFre.y, addPar6.u)
    annotation (Line(points={{-138,-70},{-100,-70},{-100,-88},{20,-88},{20,-110},
          {38,-110}}, color={0,0,127}));
  connect(heaSetFre.y, addPar5.u)
    annotation (Line(points={{-138,-70},{-100,-70},{-100,-88},{20,-88},{20,-150},
          {38,-150}}, color={0,0,127}));
  connect(heaSetFre.y, addPar4.u)
    annotation (Line(points={{-138,-70},{-100,-70},{-100,-88},{20,-88},{20,-190},
          {38,-190}}, color={0,0,127}));
  connect(addPar6.y, pro3.u1)
    annotation (Line(points={{62,-110},{70,-110},{70,-104},{78,-104}},
      color={0,0,127}));
  connect(addPar5.y, pro4.u1)
    annotation (Line(points={{62,-150},{70,-150},{70,-144},{78,-144}},
      color={0,0,127}));
  connect(addPar4.y, pro5.u1)
    annotation (Line(points={{62,-190},{70,-190},{70,-184},{78,-184}},
      color={0,0,127}));
  connect(booToRea3.y, pro3.u2)
    annotation (Line(points={{-18,-110},{0,-110},{0,-126},{70,-126},{70,-116},{
          78,-116}}, color={0,0,127}));
  connect(booToRea4.y, pro4.u2)
    annotation (Line(points={{-18,-150},{0,-150},{0,-166},{70,-166},{70,-156},{
          78,-156}}, color={0,0,127}));
  connect(booToRea5.y, pro5.u2)
    annotation (Line(points={{-18,-190},{0,-190},{0,-206},{70,-206},{70,-196},{
          78,-196}}, color={0,0,127}));
  connect(edg.y, cooSetFre.trigger)
    annotation (Line(points={{-198,0},{-180,0},{-180,134},{-150,134},{-150,138}},
      color={255,0,255}));
  connect(edg.y, heaSetFre.trigger)
    annotation (Line(points={{-198,0},{-180,0},{-180,-86},{-150,-86},{-150,-82}},
      color={255,0,255}));
  connect(or5.y, swi10.u2)
    annotation (Line(points={{182,-10},{200,-10},{200,90},{218,90}},
      color={255,0,255}));
  connect(or5.y, swi11.u2)
    annotation (Line(points={{182,-10},{200,-10},{200,-130},{218,-130}},
      color={255,0,255}));
  connect(swi2.y, cooSetFre.u)
    annotation (Line(points={{-98,350},{-80,350},{-80,180},{-180,180},{-180,150},
          {-162,150}}, color={0,0,127}));
  connect(swi2.y, swi10.u1)
    annotation (Line(points={{-98,350},{-80,350},{-80,180},{200,180},{200,98},
      {218,98}}, color={0,0,127}));
  connect(swi3.y, heaSetFre.u)
    annotation (Line(points={{242,250},{260,250},{260,186},{-186,186},{-186,-70},
          {-162,-70}}, color={0,0,127}));
  connect(swi3.y, swi11.u1)
    annotation (Line(points={{242,250},{260,250},{260,186},{-186,186},{-186,-48},
          {208,-48},{208,-122},{218,-122}}, color={0,0,127}));
  connect(u1Occ, not4.u)
    annotation (Line(points={{-440,-270},{-342,-270}}, color={255,0,255}));
  connect(conTru.y, not4.u)
    annotation (Line(points={{-358,-350},{-350,-350},{-350,-270},{-342,-270}},
      color={255,0,255}));
  connect(and10.y, tim.u)
    annotation (Line(points={{-258,-270},{-222,-270}}, color={255,0,255}));
  connect(truHol.y, edg1.u)
    annotation (Line(points={{-78,-270},{-42,-270}}, color={255,0,255}));
  connect(edg1.y, cooSetSam.trigger)
    annotation (Line(points={{-18,-270},{0,-270},{0,-288},{50,-288},{50,-282}},
      color={255,0,255}));
  connect(edg1.y, heaSetSam.trigger)
    annotation (Line(points={{-18,-270},{0,-270},{0,-330},{50,-330},{50,-322}},
      color={255,0,255}));
  connect(cooSetSam.y, cooSetInc.u)
    annotation (Line(points={{62,-270},{98,-270}}, color={0,0,127}));
  connect(heaSetSam.y, heaSetDec.u)
    annotation (Line(points={{62,-310},{98,-310}}, color={0,0,127}));
  connect(cooSetInc.y, swi12.u1)
    annotation (Line(points={{122,-270},{136,-270},{136,-262},{158,-262}},
      color={0,0,127}));
  connect(heaSetDec.y, swi13.u1)
    annotation (Line(points={{122,-310},{136,-310},{136,-302},{158,-302}},
      color={0,0,127}));
  connect(truHol.y, swi12.u2)
    annotation (Line(points={{-78,-270},{-60,-270},{-60,-250},{140,-250},{140,-270},
          {158,-270}},  color={255,0,255}));
  connect(truHol.y, swi13.u2)
    annotation (Line(points={{-78,-270},{-60,-270},{-60,-250},{140,-250},{140,-310},
          {158,-310}}, color={255,0,255}));
  connect(swi11.y, swi13.u3)
    annotation (Line(points={{242,-130},{260,-130},{260,-240},{144,-240},{144,-318},
          {158,-318}},  color={0,0,127}));
  connect(swi10.y, swi12.u3)
    annotation (Line(points={{242,90},{264,90},{264,-244},{148,-244},{148,-278},
          {158,-278}}, color={0,0,127}));
  connect(intEqu2.y, and10.u1)
    annotation (Line(points={{-98,590},{-60,590},{-60,380},{280,380},{280,-220},
          {-300,-220},{-300,-270},{-282,-270}}, color={255,0,255}));
  connect(not4.y, and10.u2)
    annotation (Line(points={{-318,-270},{-308,-270},{-308,-278},{-282,-278}},
      color={255,0,255}));
  connect(swi11.y, heaSetSam.u)
    annotation (Line(points={{242,-130},{260,-130},{260,-240},{20,-240},{20,-310},
          {38,-310}}, color={0,0,127}));
  connect(swi10.y, cooSetSam.u)
    annotation (Line(points={{242,90},{264,90},{264,-244},{24,-244},{24,-270},{38,
          -270}}, color={0,0,127}));
  connect(have_occSenCon.y, swi20.u2)
    annotation (Line(points={{182,-350},{200,-350},{200,-270},{218,-270}},
      color={255,0,255}));
  connect(have_occSenCon.y, swi19.u2)
    annotation (Line(points={{182,-350},{200,-350},{200,-310},{218,-310}},
      color={255,0,255}));
  connect(swi12.y, swi20.u1)
    annotation (Line(points={{182,-270},{196,-270},{196,-262},{218,-262}},
      color={0,0,127}));
  connect(swi13.y, swi19.u1)
    annotation (Line(points={{182,-310},{196,-310},{196,-302},{218,-302}},
      color={0,0,127}));
  connect(swi10.y, swi20.u3)
    annotation (Line(points={{242,90},{264,90},{264,-244},{208,-244},{208,-278},
          {218,-278}}, color={0,0,127}));
  connect(swi11.y, swi19.u3)
    annotation (Line(points={{242,-130},{260,-130},{260,-240},{204,-240},{204,-318},
          {218,-318}}, color={0,0,127}));
  connect(intEqu2.y, not5.u)
    annotation (Line(points={{-98,590},{-60,590},{-60,380},{280,380},{280,-220},
          {-300,-220},{-300,-390},{-282,-390}}, color={255,0,255}));
  connect(not5.y, and11.u1)
    annotation (Line(points={{-258,-390},{-240,-390},{-240,-410},{-222,-410}},
      color={255,0,255}));
  connect(and11.y, swi16.u2)
    annotation (Line(points={{-198,-410},{-102,-410}}, color={255,0,255}));
  connect(alaFou.y, swi16.u1)
    annotation (Line(points={{-118,-390},{-112,-390},{-112,-402},{-102,-402}},
      color={0,0,127}));
  connect(alaZer.y, swi16.u3)
    annotation (Line(points={{-158,-390},{-150,-390},{-150,-418},{-102,-418}},
      color={0,0,127}));
  connect(swi16.y, reaToInt.u)
    annotation (Line(points={{-78,-410},{-64,-410},{-64,-390},{158,-390}},
      color={0,0,127}));
  connect(cooSetWinOpe.y, swi14.u1)
    annotation (Line(points={{-218,-470},{-204,-470},{-204,-442},{-182,-442}},
      color={0,0,127}));
  connect(heaSetWinOpe.y, swi15.u1)
    annotation (Line(points={{-98,-470},{-84,-470},{-84,-442},{-62,-442}},
      color={0,0,127}));
  connect(winSenCon.y, swi22.u2)
    annotation (Line(points={{62,-470},{80,-470},{80,-450},{98,-450}},
      color={255,0,255}));
  connect(winSenCon.y, swi21.u2)
    annotation (Line(points={{62,-470},{158,-470}}, color={255,0,255}));
  connect(swi19.y, swi15.u3)
    annotation (Line(points={{242,-310},{260,-310},{260,-432},{-76,-432},{-76,-458},
          {-62,-458}}, color={0,0,127}));
  connect(swi19.y, swi21.u3)
    annotation (Line(points={{242,-310},{260,-310},{260,-432},{140,-432},{140,-478},
          {158,-478}},  color={0,0,127}));
  connect(swi20.y, swi14.u3)
    annotation (Line(points={{242,-270},{256,-270},{256,-428},{-196,-428},{-196,
          -458},{-182,-458}}, color={0,0,127}));
  connect(swi20.y, swi22.u3)
    annotation (Line(points={{242,-270},{256,-270},{256,-428},{84,-428},{84,-458},
          {98,-458}}, color={0,0,127}));
  connect(swi14.y, swi22.u1)
    annotation (Line(points={{-158,-450},{-140,-450},{-140,-424},{88,-424},{88,-442},
          {98,-442}}, color={0,0,127}));
  connect(swi15.y, swi21.u1)
    annotation (Line(points={{-38,-450},{-20,-450},{-20,-420},{144,-420},{144,-462},
          {158,-462}}, color={0,0,127}));
  connect(conFal.y, and11.u2)
    annotation (Line(points={{-358,-470},{-340,-470},{-340,-410},{-260,-410},{-260,
          -418},{-222,-418}}, color={255,0,255}));
  connect(conFal.y, swi14.u2)
    annotation (Line(points={{-358,-470},{-340,-470},{-340,-410},{-260,-410},{-260,
          -450},{-182,-450}}, color={255,0,255}));
  connect(conFal.y, swi15.u2)
    annotation (Line(points={{-358,-470},{-340,-470},{-340,-410},{-260,-410},{-260,
          -432},{-80,-432},{-80,-450},{-62,-450}}, color={255,0,255}));
  connect(swi22.y, cooSetLim.u)
    annotation (Line(points={{122,-450},{136,-450},{136,-500},{-260,-500},{-260,
          -520},{-242,-520}}, color={0,0,127}));
  connect(swi21.y, heaSetLim.u)
    annotation (Line(points={{182,-470},{200,-470},{200,-496},{-264,-496},{-264,
          -580},{-242,-580}}, color={0,0,127}));
  connect(cooSetLim.y, swi17.u1)
    annotation (Line(points={{-218,-520},{-192,-520},{-192,-532},{-182,-532}},
      color={0,0,127}));
  connect(heaSetLim.y, swi18.u1)
    annotation (Line(points={{-218,-580},{-192,-580},{-192,-592},{-182,-592}},
      color={0,0,127}));
  connect(swi22.y, swi17.u3)
    annotation (Line(points={{122,-450},{136,-450},{136,-500},{-198,-500},{-198,
          -548},{-182,-548}}, color={0,0,127}));
  connect(swi21.y, swi18.u3)
    annotation (Line(points={{182,-470},{200,-470},{200,-496},{-204,-496},{-204,
          -608},{-182,-608}}, color={0,0,127}));
  connect(intEqu2.y, swi17.u2)
    annotation (Line(points={{-98,590},{-60,590},{-60,380},{280,380},{280,-220},
          {-300,-220},{-300,-540},{-182,-540}}, color={255,0,255}));
  connect(intEqu2.y, swi18.u2)
    annotation (Line(points={{-98,590},{-60,590},{-60,380},{280,380},{280,-220},
          {-300,-220},{-300,-600},{-182,-600}}, color={255,0,255}));
  connect(swi17.y, les.u1)
    annotation (Line(points={{-158,-540},{18,-540}}, color={0,0,127}));
  connect(les.y, swi9.u2)
    annotation (Line(points={{42,-540},{98,-540}}, color={255,0,255}));
  connect(swi18.y, gre.u1)
    annotation (Line(points={{-158,-600},{18,-600}}, color={0,0,127}));
  connect(gre.y, swi8.u2)
    annotation (Line(points={{42,-600},{98,-600}}, color={255,0,255}));
  connect(swi17.y, swi9.u1)
    annotation (Line(points={{-158,-540},{-100,-540},{-100,-520},{80,-520},{80,-532},
          {98,-532}},       color={0,0,127}));
  connect(swi18.y, swi8.u1)
    annotation (Line(points={{-158,-600},{-100,-600},{-100,-580},{80,-580},{80,-592},
          {98,-592}}, color={0,0,127}));
  connect(TUnoCooSet, les.u2) annotation (Line(points={{-440,490},{-400,490},{-400,
          -560},{0,-560},{0,-548},{18,-548}}, color={0,0,127}));
  connect(TUnoCooSet, swi9.u3) annotation (Line(points={{-440,490},{-400,490},{-400,
          -560},{80,-560},{80,-548},{98,-548}}, color={0,0,127}));
  connect(TUnoHeaSet, gre.u2) annotation (Line(points={{-440,410},{-406,410},{-406,
          -620},{0,-620},{0,-608},{18,-608}}, color={0,0,127}));
  connect(TUnoHeaSet, swi8.u3) annotation (Line(points={{-440,410},{-406,410},{-406,
          -620},{80,-620},{80,-608},{98,-608}}, color={0,0,127}));
  connect(swi9.y, addPar.u)
    annotation (Line(points={{122,-540},{140,-540},{140,-580},{158,-580}},
      color={0,0,127}));
  connect(gre2.y, swi7.u2)
    annotation (Line(points={{242,-580},{278,-580}}, color={255,0,255}));
  connect(swi8.y, gre2.u1) annotation (Line(points={{122,-600},{206,-600},{206,-580},
          {218,-580}}, color={0,0,127}));
  connect(addPar.y, gre2.u2) annotation (Line(points={{182,-580},{200,-580},{200,
          -588},{218,-588}}, color={0,0,127}));
  connect(swi8.y, swi7.u3)
    annotation (Line(points={{122,-600},{260,-600},{260,-588},{278,-588}},
      color={0,0,127}));
  connect(addPar.y, swi7.u1)
    annotation (Line(points={{182,-580},{200,-580},{200,-560},{260,-560},{260,-572},
          {278,-572}},        color={0,0,127}));
  connect(swi7.y, THeaSet) annotation (Line(points={{302,-580},{320,-580},{320,-100},
          {360,-100}}, color={0,0,127}));
  connect(swi9.y, TCooSet) annotation (Line(points={{122,-540},{300,-540},{300,0},
          {360,0}}, color={0,0,127}));
  connect(reaToInt.y, yAla)
    annotation (Line(points={{182,-390},{360,-390}}, color={255,127,0}));
  connect(pro6.y, add3.u1) annotation (Line(points={{102,150},{110,150},{110,
          134},{118,134}}, color={0,0,127}));
  connect(pro.y, add3.u2) annotation (Line(points={{102,110},{110,110},{110,122},
          {118,122}}, color={0,0,127}));
  connect(pro1.y, add4.u1) annotation (Line(points={{102,70},{110,70},{110,56},
          {118,56}}, color={0,0,127}));
  connect(pro2.y, add4.u2) annotation (Line(points={{102,30},{110,30},{110,44},
          {118,44}}, color={0,0,127}));
  connect(add3.y, add5.u1) annotation (Line(points={{142,128},{150,128},{150,96},
          {158,96}}, color={0,0,127}));
  connect(add4.y, add5.u2) annotation (Line(points={{142,50},{150,50},{150,84},
          {158,84}}, color={0,0,127}));
  connect(add5.y, swi10.u3) annotation (Line(points={{182,90},{190,90},{190,82},
          {218,82}}, color={0,0,127}));
  connect(pro7.y, add6.u1) annotation (Line(points={{102,-70},{110,-70},{110,
          -84},{118,-84}}, color={0,0,127}));
  connect(pro3.y, add6.u2) annotation (Line(points={{102,-110},{110,-110},{110,
          -96},{118,-96}}, color={0,0,127}));
  connect(pro4.y, add7.u1) annotation (Line(points={{102,-150},{110,-150},{110,
          -164},{118,-164}}, color={0,0,127}));
  connect(pro5.y, add7.u2) annotation (Line(points={{102,-190},{110,-190},{110,
          -176},{118,-176}}, color={0,0,127}));
  connect(add6.y, add8.u1) annotation (Line(points={{142,-90},{150,-90},{150,
          -124},{158,-124}}, color={0,0,127}));
  connect(add7.y, add8.u2) annotation (Line(points={{142,-170},{150,-170},{150,
          -136},{158,-136}}, color={0,0,127}));
  connect(add8.y, swi11.u3) annotation (Line(points={{182,-130},{190,-130},{190,
          -138},{218,-138}}, color={0,0,127}));
  connect(or9.y, swi2.u2) annotation (Line(points={{2,610},{20,610},{20,400},{-140,
          400},{-140,350},{-122,350}}, color={255,0,255}));
  connect(tim.passed, truHol.u) annotation (Line(points={{-198,-278},{-160,-278},
          {-160,-270},{-102,-270}}, color={255,0,255}));
  connect(cooSetAdj, swi4.u1) annotation (Line(points={{-440,310},{-360,310},{-360,
          350},{-300,350},{-300,338},{-282,338}}, color={0,0,127}));
  connect(heaSetAdjCon.y, swi6.u2)
    annotation (Line(points={{-38,250},{78,250}}, color={255,0,255}));
  connect(heaSetAdj, swi6.u1) annotation (Line(points={{-440,270},{60,270},{60,258},
          {78,258}}, color={0,0,127}));
  connect(con1.y, swi6.u3) annotation (Line(points={{-38,210},{60,210},{60,242},
          {78,242}}, color={0,0,127}));
  connect(setAdj, swi6.u1) annotation (Line(points={{-440,350},{-380,350},{-380,
          270},{60,270},{60,258},{78,258}}, color={0,0,127}));
  connect(con4.y, swi6.u1) annotation (Line(points={{-38,290},{60,290},{60,258},
          {78,258}}, color={0,0,127}));
  connect(u1Win, winOpe.u)
    annotation (Line(points={{-440,-410},{-382,-410}}, color={255,0,255}));
  connect(winOpe.y, and11.u2) annotation (Line(points={{-358,-410},{-260,-410},{
          -260,-418},{-222,-418}}, color={255,0,255}));
  connect(winOpe.y, swi14.u2) annotation (Line(points={{-358,-410},{-260,-410},{
          -260,-450},{-182,-450}}, color={255,0,255}));
  connect(winOpe.y, swi15.u2) annotation (Line(points={{-358,-410},{-260,-410},{
          -260,-432},{-80,-432},{-80,-450},{-62,-450}}, color={255,0,255}));
  connect(intEqu.y, or6.u1) annotation (Line(points={{-278,610},{-260,610},{-260,
          640},{-90,640},{-90,620},{-82,620}}, color={255,0,255}));
  connect(intEqu1.y, or6.u2) annotation (Line(points={{-178,610},{-160,610},{-160,
          612},{-82,612}}, color={255,0,255}));
  connect(or6.y,or9. u1) annotation (Line(points={{-58,620},{-40,620},{-40,610},
          {-22,610}}, color={255,0,255}));
  connect(intEqu2.y,or9. u2) annotation (Line(points={{-98,590},{-40,590},{-40,602},
          {-22,602}}, color={255,0,255}));
  connect(intEqu5.y, or7.u2) annotation (Line(points={{-78,30},{-70,30},{-70,142},
          {-32,142}}, color={255,0,255}));
  connect(or1.y, or7.u1) annotation (Line(points={{-38,160},{-36,160},{-36,150},
          {-32,150}}, color={255,0,255}));
  connect(not2.u, or8.y)
    annotation (Line(points={{-2,-70},{-8,-70}}, color={255,0,255}));
  connect(or7.y, not1.u)
    annotation (Line(points={{-8,150},{-2,150}}, color={255,0,255}));
  connect(or4.y, or8.u1) annotation (Line(points={{-38,-64},{-34,-64},{-34,-70},
          {-32,-70}}, color={255,0,255}));
  connect(intEqu8.y, or8.u2) annotation (Line(points={{-78,-190},{-70,-190},{-70,
          -78},{-32,-78}}, color={255,0,255}));
annotation (
  defaultComponentName="TZonSet",
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,148},{-32,132}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccCooSet"),
        Text(
          extent={{-98,70},{-36,50}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TOccHeaSet"),
        Text(
          extent={{-96,40},{-38,20}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoHeaSet"),
        Text(
          extent={{-96,116},{-32,100}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TUnoCooSet"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-96,-30},{-40,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          visible=have_locAdj and not sepAdj,
          extent={{-100,12},{-54,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          extent={{-96,188},{-46,174}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-96,-70},{-4,-90}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uCooDemLimLev"),
        Text(
          extent={{-96,-100},{-8,-120}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uHeaDemLimLev"),
        Text(
          extent={{-18.5,8},{18.5,-8}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          origin={-78.5,-150},
          textString="u1Occ"),
        Text(
          extent={{-18,7.5},{18,-7.5}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          origin={-80,-178.5},
          textString="u1Win"),
        Text(
          extent={{68,-70},{100,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yAla"),
        Text(
          extent={{54,92},{96,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{50,10},{96,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-120,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-96,-10},{-40,-28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooSetAdj")}),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-420,-620},{340,640}}), graphics={
        Rectangle(
          extent={{-412,638},{330,560}},
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
          extent={{-412,386},{330,182}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,178},{332,-208}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-410,-228},{332,-366}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-412,-382},{330,-496}},
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
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Operation mode recognition"),
        Text(
          extent={{176,550},{324,506}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Setpoints recognition"),
        Text(
          extent={{-350,214},{-188,188}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Local setpoints adjustment"),
        Text(
          extent={{-232,-336},{-28,-358}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Adjust setpoints due to occupancy"),
        Text(
          extent={{26,-396},{236,-420}},
          textColor={0,0,255},
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
          extent={{-388,-542},{-228,-572}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Setpoints limited
in the range"),
        Text(
          extent={{-88,-502},{60,-540}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Limit occupied by
unoccupied"),
        Text(
          extent={{152,-506},{298,-564}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Confine cooling setpoint
by heating one"),
        Text(
          extent={{-384,-150},{-188,-190}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Demand limit setpoints
adjustment")}),
  Documentation(info="<html>
<p>
This sequence sets the thermal zone cooling and heating active setpoints. The implementation
is according to the ASHRAE Guideline 36, Section 5.3.2. The calculation is done
following the steps below.
</p>
<ol>
<li>
According to Guideline 36, Section 3.1.1.1, zone setpoints shall be based on zone
type.
<table border = \"1\" summary=\"Peak load\">
<tr>
<th rowspan=\"2\">Zone Type</th>
<th colspan=\"2\">Occupied</th>
<th colspan=\"2\">Unoccupied</th>
</tr>
<tr>
<td>Heating</td><td>Cooling</td>
<td>Heating</td><td>Cooling</td>
</tr>
<tr>
<td>VAV</td>
<td>21 &deg;C (70 &deg;F)</td>
<td>24 &deg;C (75 &deg;F)</td>
<td>16 &deg;C (60 &deg;F)</td>
<td>32 &deg;C (90 &deg;F)</td>
</tr>
<tr>
<td>Mechanical/electrical rooms</td>
<td>18 &deg;C (65 &deg;F)</td>
<td>29 &deg;C (85 &deg;F)</td>
<td>18 &deg;C (65 &deg;F)</td>
<td>29 &deg;C (85 &deg;F)</td>
</tr>
<tr>
<td>Networking/computer</td>
<td>18 &deg;C (65 &deg;F)</td>
<td>24 &deg;C (75 &deg;F)</td>
<td>18 &deg;C (65 &deg;F)</td>
<td>24 &deg;C (75 &deg;F)</td>
</tr>
</table>
<br/>
</li>
<li>Each zone shall have separate occupied and unoccupied heating and cooling
setpoints.</li>
<li>The active setpoints shall be determined by the operating mode of the zone
group.
<ul>
<li>The setpoints shall be the occupied setpoints during occupied, warm-up, and
cooldown modes.</li>
<li>The setpoints shall be the unoccupied setpoints during unoccupied, setback,
and setup modes.</li>
</ul>
</li>
<li>
The software shall prevent,
<ul>
<li>The heating setpoint from exceeding the cooling setpoint minus 0.5 &deg;C
(1 &deg;F), i.e. the minimum difference between heating and cooling setpoint
shall be 0.5 &deg;C (1 &deg;F).</li>
<li>The unoccupied heating setpoint from exceeding the occupied heating
setpoint.</li>
<li>The unoccupied cooling setpoint from being less than occupied cooling
setpoint.</li>
</ul>
</li>
<li>
Where the zone has a local setpoint adjustment knob/button,
<ul>
<li>The setpoint adjustment offsets established by the occupant shall be software
points that are persistent (e.g. not reset daily), but the actual offset used
in control logic shall be adjusted based on limits and modes as described below.</li>
<li>The adjustment shall be capable of being limited in software.
<ol type=\"i\">
<li>As a default, the active occupied cooling setpoint shall be limited between 22 &deg;C
(72 &deg;F) and 27 &deg;C (80 &deg;F);</li>
<li>As a default, the active occupied heating setpoint shall be limited between
18 &deg;C (65 &deg;F) and 22 &deg;C (72 &deg;F);</li>
</ol>
</li>
<li>The active heating and cooling setpoint shall be independently adjustable,
respecting the limits and anti-overlap logic described above. If zone thermostat
provides only a single setpoint adjustment, then the adjustment shall move both
the same amount, within the limits described above.</li>
<li>The adjustment shall only affect occupied setpoints in occupied mode, warm-up mode
and cool-down mode and shall have no impact on setpoints in all other modes.</li>
<li>At the onset of demand limiting, the local setpoint adjustment value shall
be frozen. Further adjustment of the setpoint by local controls shall be suspended
for the duration of the demand limit event.</li>
</ul>
</li>
<li>Cooling demand limit setpoint adjustment.
The active cooling setpoints for all zones shall be increased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal
Building Automation System (BAS) user interface. Changes due to demand limits
are not cumulative.
<ul>
<li>At Demand Limit Level 1, increase setpoint by 0.5 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, increase setpoint by 1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 3, increase setpoint by 2 &deg;C (4 &deg;F).</li>
</ul>
</li>
<li>Heating demand limit setpoint adjustment.
The active heating setpoints for all zones shall be decreased when a demand limit
is imposed on the associated zone group. The operator shall have the ability
to exempt individual zones from this adjustment through the normal BAS user
interface. Changes due to demand limits are not cumulative.
<ul>
<li>At Demand Limit Level 1, decrease setpoint by 0.5 &deg;C (1 &deg;F).</li>
<li>At Demand Limit Level 2, decrease setpoint by 1 &deg;C (2 &deg;F).</li>
<li>At Demand Limit Level 3, decrease setpoint by 2 &deg;C (4 &deg;F).</li>
</ul>
</li>
<li>Window switches.
For zones that have operable windows with indicator switches, when the window
switch indicates the window is open, the heating setpoint shall be temporarily
set to 4 &deg;C (40 &deg;F) and the cooling setpoint shall be temporarily
set to 49 &deg;C (120 &deg;F). When the window switch indicates the window is
open during other than Occupied Mode, a Level 4 alarm shall be generated.
</li>
<li>Occupancy sensor
<ul>
<li>When the switch indicates the space has been unpopulated for 5 minutes
continuously during the Occupied Mode, the active heating setpoint shall be
decreased by 0.5 &deg;C (1 &deg;F) and the cooling setpoint shall be increased
by 0.5 &deg;C (1 &deg;F).</li>
<li>When the switch indicated that the space has been populated for 1 minute
continuously, the active heating and cooling setpoints shall be restored to
their previously values.</li>
</ul>
</li>
<li>Hierarchy of setpoint adjustments: the following adjustment restrictions
shall prevail in order from highest to lowest priority.
<ol type=\"i\">
<li>Setpoint overlap restriction</li>
<li>Absolute limits on local setpoint adjustment</li>
<li>Window swtiches</li>
<li>Demand limit (a. Occupancy sensors; b. Local setpoint adjustment)</li>
<li>Scheduled setpoints based on zone group mode</li>
</ol>
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
June 3, 2020, by Jianjun Hu:<br/>
Upgraded according to G36 official release.
</li>
<li>
October 11, 2017, by Michael Wetter:<br/>
Removed wrong conditional on <code>yAla</code>.
</li>
<li>
August 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoints;
