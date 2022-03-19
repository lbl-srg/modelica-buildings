within Buildings.Controls.OBC.ASHRAE.FanCoilUnit;
block Controller
  "Fan coil unit controller that comprises subsequences for controlling fan speed and supply air temperature"

  parameter Boolean have_coolingCoil
    "Does the fan coil unit have a cooling coil?";

  parameter Boolean have_heatingCoil
    "Does the fan coil unit have a heating coil?";

  parameter Boolean have_winSen
    "Check if the zone has window status sensor";

  parameter Boolean have_occSen
    "Set to true if zones have occupancy sensor";

  parameter Real TZonHeaOn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=293.15
    "Heating setpoint during on"
    annotation (Dialog(group="Zone setpoints"));

  parameter Real TZonHeaOff(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Heating setpoint during off"
    annotation (Dialog(group="Zone setpoints"));

  parameter Real TZonCooOn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Cooling setpoint during on"
    annotation (Dialog(group="Zone setpoints"));

  parameter Real TZonCooOff(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=303.15
    "Cooling setpoint during off"
    annotation (Dialog(group="Zone setpoints"));


  parameter Real heaDea=0.05
    "Heating loop signal limit at which deadband mode transitions to heating mode";

  parameter Real cooDea=0.05
    "Cooling loop signal limit at which deadband mode transitions to cooling mode";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="PID parameters", group="Cooling loop control"));

  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(tab="PID parameters", group="Cooling loop control"));

  parameter Real TiCoo(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(tab="PID parameters", group="Cooling loop control",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(tab="PID parameters", group="Cooling loop control",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PID parameters", group="Heating loop control"));

  parameter Real kHea(final unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(tab="PID parameters", group="Heating loop control"));

  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(tab="PID parameters", group="Heating loop control",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(tab="PID parameters", group="Heating loop control",
      enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control"));

  parameter Real kCooCoi(final unit="1/K")=0.1
    "Gain for cooling coil control signal"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control"));

  parameter Real TiCooCoi(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling coil control signal"
    annotation(Dialog(tab="PID parameters", group="Cooling coil control",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCooCoi(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling coil control signal"
    annotation (Dialog(tab="PID parameters", group="Cooling coil control",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHeaCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PID parameters", group="Heating coil control"));

  parameter Real kHeaCoi(
    final unit="1/K")=0.1
    "Gain for heating coil control signal"
    annotation(Dialog(tab="PID parameters", group="Heating coil control"));

  parameter Real TiHeaCoi(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating coil control signal"
    annotation(Dialog(tab="PID parameters", group="Heating coil control",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHeaCoi(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heatinging coil control signal"
    annotation (Dialog(tab="PID parameters", group="Heating coil control",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real cooPerMin(
    final min=0,
    final max=1,
    final unit="1")=0.5
    "Cooling loop signal limit at which supply air temperature is at minimum and
    fan speed starts to be modified"
    annotation (Dialog(tab="Supply air setpoints"));

  parameter Real heaPerMin(
    final min=0,
    final max=1,
    final unit="1")=0.5
    "Heating loop signal limit at which supply air temperature is at maximum and
    fan speed starts to be modified"
    annotation (Dialog(tab="Supply air setpoints"));

  parameter Real TSupSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="Supply air setpoints",group="Temperature limits"));

  parameter Real TSupSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="Supply air setpoints",group="Temperature limits"));


  parameter Real deaSpe(
    final unit="1",
    displayUnit="1")=0.1
    "Deadband mode fan speed"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed"));

  parameter Real heaPerMaxFanSpe(
    final min=0,
    final max=1,
    final unit="1")=1
    "Maximum heating loop signal at which fan speed is modified"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Heating"));

  parameter Real heaSpeMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Heating"));

  parameter Real heaSpeMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum fan speed for heating"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Heating"));

  parameter Real cooPerMaxFanSpe(
    final min=0,
    final max=1,
    final unit="1")=1
    "Maximum cooling loop signal at which fan speed is modified"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Cooling"));

  parameter Real cooSpeMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Maximum fan speed for cooling"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Cooling"));

  parameter Real cooSpeMin(
    final min=0,
    final max=1,
    final unit="1")
    "Minimum fan speed for cooling"
    annotation (Dialog(tab="Supply air setpoints",group="Fan speed - Cooling"));

  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Boolean ignDemLim=false
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Adjust temperature setpoint", group="General"));

  parameter Real TZonCooOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TZonCooOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TZonHeaOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TZonHeaOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TZonCooSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));

  parameter Real incTSetDem_1(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real incTSetDem_2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real incTSetDem_3(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_1(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real decTSetDem_3(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));

  parameter Real uLow(
    final unit="1",
    displayUnit="1")=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  parameter Real uHigh(
    final unit="1",
    displayUnit="1")=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));


  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1")=0.01
    "Hysteresis limits for cooling and heating loop signals for deadband mode transitions"
    annotation (Dialog(tab="Advanced"));


  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
      iconTransformation(extent={{-240,20},{-200,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-160},{-200,-120}}),
      iconTransformation(extent={{-240,-220},{-200,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal" annotation (Placement(
        transformation(extent={{-240,-120},{-200,-80}}),  iconTransformation(
          extent={{-240,-140},{-200,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
        iconTransformation(extent={{-240,-20},{-200,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-240,170},{-200,210}}),
        iconTransformation(extent={{-240,180},{-200,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-240,200},{-200,240}}),
        iconTransformation(extent={{-240,140},{-200,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,100},{-200,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-240,60},{-200,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
      iconTransformation(extent={{200,100},{240,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,-40},{240,0}}),
        iconTransformation(extent={{200,-140},{240,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Fan speed signal" annotation (Placement(transformation(
          extent={{200,140},{240,180}}), iconTransformation(extent={{200,60},{240,
            100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
      iconTransformation(extent={{200,20},{240,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{200,-20},{240,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") if have_coolingCoil
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{200,-100},{240,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{200,-60},{240,-20}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    modSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final THeaSetOcc=TZonHeaOn,
    final THeaSetUno=TZonHeaOff,
    final TCooSetOcc=TZonCooOn,
    final TCooSetUno=TZonCooOff,
    final cooAdj=cooAdj,
    final heaAdj=heaAdj,
    final sinAdj=sinAdj,
    final ignDemLim=ignDemLim,
    final TZonCooOnMax=TZonCooOnMax,
    final TZonCooOnMin=TZonCooOnMin,
    final TZonHeaOnMax=TZonHeaOnMax,
    final TZonHeaOnMin=TZonHeaOnMin,
    final TZonCooSetWinOpe=TZonCooSetWinOpe,
    final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
    final incTSetDem_1=incTSetDem_1,
    final incTSetDem_2=incTSetDem_2,
    final incTSetDem_3=incTSetDem_3,
    final decTSetDem_1=decTSetDem_1,
    final decTSetDem_2=decTSetDem_2,
    final decTSetDem_3=decTSetDem_3,
    final uLow=uLow,
    final uHigh=uHigh)
    "Zone setpoint and operation mode"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset cooPI(
    final reverseActing=false,
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPI(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea)
    "Zone heating control signal"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Not switch
    "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-70,-180},{-50,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    final k=false) if not have_winSen
    "Window status"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold havOcc(
    final t=1) if have_occSen
    "Check if there is occupant"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir(
    final have_coolingCoil=have_coolingCoil,
    final have_heatingCoil=have_heatingCoil,
    final THeaSupAirHi=TSupSetMax,
    final heaPerMax=heaPerMin,
    final TCooSupAirHi=TSupSetMin,
    final cooPerMax=cooPerMin,
    final heaDea=heaDea,
    final cooDea=cooDea,
    final controllerTypeCooCoi=controllerTypeCooCoi,
    final kCooCoi=kCooCoi,
    final TiCooCoi=TiCooCoi,
    final TdCooCoi=TdCooCoi,
    final controllerTypeHeaCoi=controllerTypeHeaCoi,
    final kHeaCoi=kHeaCoi,
    final TiHeaCoi=TiHeaCoi,
    final TdHeaCoi=TdHeaCoi,
    final deaHysLim=deaHysLim)
    "Supply air temperature setpoint controller"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe(
    final have_coolingCoil=have_coolingCoil,
    final have_heatingCoil=have_heatingCoil,
    final deaSpe=deaSpe,
    final heaSpeMin=heaSpeMin,
    final heaPerMin=heaPerMin,
    final heaSpeMax=heaSpeMax,
    final heaPerMax=heaPerMaxFanSpe,
    final cooSpeMin=cooSpeMin,
    final cooPerMin=cooPerMin,
    final cooSpeMax=cooSpeMax,
    final cooPerMax=cooPerMaxFanSpe,
    final heaDea=heaDea,
    final cooDea=cooDea,
    final deaHysLim=deaHysLim)
    "Fan speed controller"
    annotation (Placement(transformation(extent={{120,170},{140,190}})));

equation
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-138,-170},{-120,-170},
          {-120,-178},{-102,-178}},color={255,127,0}));

  connect(intEqu.y, switch.u) annotation (Line(points={{-78,-170},{-72,-170}}, color={255,0,255}));

  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,-20},{-30,-20},{-30,148}},
          color={0,0,127}));

  connect(switch.y, heaPI.trigger) annotation (Line(points={{-48,-170},{-36,-170},
          {-36,84},{-76,84},{-76,208}}, color={255,0,255}));

  connect(switch.y, cooPI.trigger) annotation (Line(points={{-48,-170},{-36,-170},
          {-36,148}}, color={255,0,255}));

  connect(TZon, heaPI.u_m) annotation (Line(points={{-220,-20},{-70,-20},{-70,208}},
          color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-118,152},{
          -100,152},{-100,220},{-82,220}}, color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-118,152},
          {-54,152},{-54,120},{220,120}},   color={0,0,127}));

  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-118,160},
          {-42,160}},color={0,0,127}));

  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-118,160},
          {-50,160},{-50,80},{220,80}}, color={0,0,127}));

  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,-20},{-168,-20},{
          -168,164},{-142,164}}, color={0,0,127}));

  connect(tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-220,160},{-142,
          160}}, color={0,0,127}));

  connect(uOcc, modSetPoi.uOcc) annotation (Line(points={{-220,120},{-174,120},{
          -174,162},{-142,162}}, color={255,0,255}));

  connect(modSetPoi.yOpeMod, intEqu.u1) annotation (Line(points={{-118,168},{-110,
          168},{-110,-170},{-102,-170}}, color={255,127,0}));

  connect(win.y, modSetPoi.uWin) annotation (Line(points={{-158,-40},{-150,-40},
          {-150,166},{-142,166}}, color={255,0,255}));

  connect(uWin, modSetPoi.uWin) annotation (Line(points={{-220,-140},{-150,-140},
          {-150,166},{-142,166}},color={255,0,255}));

  connect(havOcc.y, modSetPoi.uOccSen) annotation (Line(points={{-78,60},{-60,60},
          {-60,112},{-180,112},{-180,154},{-142,154}}, color={255,0,255}));

  connect(modSetPoi.warUpTim, warUpTim) annotation (Line(points={{-142,168},{-180,
          168},{-180,190},{-220,190}}, color={0,0,127}));

  connect(modSetPoi.cooDowTim, cooDowTim) annotation (Line(points={{-142,170},{-174,
          170},{-174,220},{-220,220}}, color={0,0,127}));

  connect(modSetPoi.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{-142,
          152},{-162,152},{-162,70},{-220,70}}, color={255,127,0}));

  connect(modSetPoi.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{-142,
          150},{-156,150},{-156,40},{-220,40}}, color={255,127,0}));

  connect(TSupAir.yCooCoi, yCooCoi) annotation (Line(points={{122,5},{160,5},{160,
          -60},{220,-60}},        color={0,0,127}));

  connect(TSupAir.yHeaCoi, yHeaCoi) annotation (Line(points={{122,15},{160,15},{
          160,20},{220,20}},    color={0,0,127}));

  connect(TSupAir.TAirSupSet, TAirSup) annotation (Line(points={{122,10},{180,10},
          {180,-20},{220,-20}}, color={0,0,127}));

  connect(fanSpe.yFanSpe, yFanSpe) annotation (Line(points={{142,178},{160,178},
          {160,160},{220,160}}, color={0,0,127}));

  connect(fanSpe.yFan, yFan) annotation (Line(points={{142,182},{160,182},{160,200},
          {220,200}}, color={255,0,255}));

  connect(modSetPoi.yOpeMod, fanSpe.opeMod) annotation (Line(points={{-118,168},
          {-60,168},{-60,180},{20,180},{20,188},{118,188}}, color={255,127,0}));

  connect(TSup, TSupAir.TAirSup) annotation (Line(points={{-220,10},{-62,10},{-62,
          8.33333},{98,8.33333}},
                           color={0,0,127}));

  connect(uFan, fanSpe.uFanPro) annotation (Line(points={{-220,-100},{28,-100},{
          28,184},{118,184}}, color={255,0,255}));

  connect(heaPI.y, fanSpe.uHea) annotation (Line(points={{-58,220},{0,220},{0,178},
          {118,178}}, color={0,0,127}));

  connect(cooPI.y, fanSpe.uCoo) annotation (Line(points={{-18,160},{20,160},{20,
          174},{118,174}}, color={0,0,127}));

  connect(modSetPoi.TZonCooSet, TSupAir.TZonSetCoo) annotation (Line(points={{-118,
          160},{-50,160},{-50,1.66667},{98,1.66667}},
                                               color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, TSupAir.TZonSetHea) annotation (Line(points={{-118,
          152},{-54,152},{-54,15},{98,15}},    color={0,0,127}));

  connect(cooPI.y, TSupAir.uCoo) annotation (Line(points={{-18,160},{20,160},{20,
          5},{98,5}},      color={0,0,127}));

  connect(heaPI.y, TSupAir.uHea) annotation (Line(points={{-58,220},{0,220},{0,
          11.6667},{98,11.6667}},
                      color={0,0,127}));

  connect(TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{220,120},{220,120}}, color={0,0,127}));

  connect(uFan, TSupAir.uFan) annotation (Line(points={{-220,-100},{28,-100},{
          28,18.3333},{98,18.3333}},
                                  color={255,0,255}));
  connect(nOcc, havOcc.u) annotation (Line(points={{-220,-60},{-120,-60},{-120,60},
          {-102,60}}, color={255,127,0}));
annotation (defaultComponentName="conFCU",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{200,220}}),
        graphics={Rectangle(
        extent={{-200,-220},{200,220}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-210,300},{210,220}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-198,136},{-136,108}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-200,92},{-156,72}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-200,52},{-154,32}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-200,-68},{-152,-90}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          visible=have_occSen,
          extent={{-196,-172},{-150,-144}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="nOcc"),
        Text(
          visible=have_winSen,
          extent={{-196,-186},{-152,-208}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          extent={{132,-102},{198,-136}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirSup"),
        Text(
          extent={{150,96},{198,72}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFanSpe"),
        Text(
          extent={{118,56},{196,22}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{118,18},{198,-20}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{144,-20},{198,-58}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi"),
        Text(
          extent={{144,-60},{198,-98}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{-196,218},{-122,186}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-196,178},{-116,146}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-196,14},{-84,-8}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-196,-28},{-84,-50}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          extent={{-200,-110},{-154,-130}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFan"),
        Text(
          extent={{158,134},{202,112}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-200},{200,240}})),
Documentation(info="<html>
<p>
Block for single zone VAV control. It outputs supply fan speed, supply air temperature
setpoints for heating, economizer and cooling, zone air heating and cooling setpoints,
outdoor and return air damper positions, and valve positions of heating and cooling coils.
</p>
<p>
It is implemented according to the ASHRAE Guideline 36, Part 5.18.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART 5.18.4. It outputs
the control signal <code>yFan</code> to adjust the speed of the supply fan.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoints</h4>
<p>
The supply air temperature setpoints control sequences are implemented based on PART 5.18.4.
They are implemented in the same control block as the supply fan speed control. The supply air temperature setpoint
for heating and economizer is the same;

 while the supply air temperature setpoint for cooling has
a separate control loop. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Economizer control</h4>
<p>
The Economizer control block outputs outdoor and return air damper position, i.e. <code>yOutDamPos</code> and
<code>yRetDamPos</code>, as well as control signal for heating coil <code>yHeaCoi</code>.
Optionally, there is also an override for freeze protection, which is not part of Guideline 36.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow</h4>
<p>
Control sequences are implemented to compute the minimum outdoor airflow
setpoint, which is used as an input for the economizer control. More detailed
information can be found at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
Zone air heating and cooling setpoints as well as system operation modes are detailed at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2020, by Jianjun Hu:<br/>
Updated the block of specifying operating mode and setpoints.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">#1893</a>.
</li>
<li>
March 10, 2020, by Jianjun Hu:<br/>
Replaced the block for calculating the operation mode and setpoint temperature with the one
from the terminal unit package. The new block does not have vector-valued calculations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
</li>
<li>
August 3, 2019, by David Blum &amp;

 Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
