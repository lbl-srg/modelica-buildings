within Buildings.Controls.OBC.ASHRAE.FanCoilUnit;
block Controller
  "Fan coil unit controller that comprises subsequences for controlling fan speed and supply air temperature"

  parameter Boolean have_cooCoi
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

  parameter Real heaDea(
    final unit="1",
    displayUnit="1")=0.05
    "Heating loop signal limit at which deadband mode transitions to heating mode";

  parameter Real cooDea(
    final unit="1",
    displayUnit="1")=0.05
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

  parameter Real chiWatPlaReqLim0(
    final unit = "1",
    displayUnit="1")=0.1
    "Valve position limit below which zero chilled water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatResReqLim0(
    final unit = "1",
    displayUnit="1")=0.85
    "Valve position limit below which zero chilled water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatPlaReqLim1(
    final unit = "1",
    displayUnit="1")=0.95
    "Valve position limit above which one chilled water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatResReqLim2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=2.78
    "Temperature difference limit between setpoint and supply air temperature above which two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=300
    "Time period for which chiWatResReqLim2 has to be exceeded before two chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatResReqLim3(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=5.56
    "Temperature difference limit between setpoint and supply air temperature above which three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real chiWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=300
    "Time period for which chiWatResReqLim3 has to be exceeded before three chilled water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Chilled water requests", enable=have_cooCoi));

  parameter Real hotWatPlaReqLim0(
    final unit = "1",
    displayUnit="1")=0.1
    "Valve position limit below which zero hot water plant requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatResReqLim0(
    final unit = "1",
    displayUnit="1")=0.85
    "Valve position limit below which zero hot water reset requests are sent when one request was previously being sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatPlaReqLim1(
    final unit = "1",
    displayUnit="1")=0.95
    "Valve position limit above which one hot water plant request is sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatResReqLim2(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=8
    "Temperature difference limit between setpoint and supply air temperature above which two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatResReqTimLim2(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=300
    "Time period for which hotWatResReqLim2 has to be exceeded before two hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatResReqLim3(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=17
    "Temperature difference limit between setpoint and supply air temperature above which three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real hotWatResReqTimLim3(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=300
    "Time period for which hotWatResReqLim3 has to be exceeded before three hot water reset requests are sent"
    annotation(Dialog(tab="Request limits", group="Hot water requests", enable=have_heatingCoil));

  parameter Real uLow(
    final unit="1",
    displayUnit="1")=-0.1
    "Lower limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  parameter Real uHigh(
    final unit="1",
    displayUnit="1")=0.1
    "Higher limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  parameter Real deaHysLim(
    final unit="1",
    displayUnit="1")=0.01
    "Hysteresis limits for cooling and heating loop signals for deadband mode transitions"
    annotation (Dialog(tab="Advanced"));

  parameter Real preWarCooTim(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=10800
    "Maximum cool-down or warm-up time"
    annotation(Dialog(tab="Advanced", group="Operation mode"));

  parameter Real Thys(
    final unit="1",
    displayUnit="1")=0.1
    "Hysteresis for checking temperature difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real posHys(
    final unit="1",
    displayUnit="1")=0.05
    "Hysteresis for checking valve position difference"
    annotation(Dialog(tab="Advanced"));

  parameter Real dFanSpe(
    final unit="1",
    displayUnit="1")=0.05
    "Fan speed hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
      iconTransformation(extent={{-240,60},{-200,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
      iconTransformation(extent={{-240,-220},{-200,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
      iconTransformation(extent={{-240,-180},{-200,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,20},{-200,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-240,-20},{-200,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-240,170},{-200,210}}),
        iconTransformation(extent={{-240,260},{-200,300}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    displayUnit="min",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-240,200},{-200,240}}),
        iconTransformation(extent={{-240,220},{-200,260}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    displayUnit="min",
    final quantity="Time") "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,180},{-200,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    displayUnit="degC",
    final quantity="TemperatureDifference") if cooAdj or sinAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
      iconTransformation(extent={{-240,140},{-200,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    displayUnit="degC",
    final quantity="TemperatureDifference") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-240,100},{-200,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final unit="1",
    displayUnit="1") if have_heatingCoil
    "Measured heating coil control action"
    annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
        iconTransformation(extent={{-240,-260},{-200,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Measured cooling coil control action"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
        iconTransformation(extent={{-240,-300},{-200,-260}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{200,180},{240,220}}),
      iconTransformation(extent={{200,180},{240,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq if have_cooCoi
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{200,-120},{240,-80}}),
        iconTransformation(extent={{200,-100},{240,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq if have_cooCoi
    "Chiller plant requests"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
        iconTransformation(extent={{200,-140},{240,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_heatingCoil
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
        iconTransformation(extent={{200,-180},{240,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_heatingCoil
    "Hot water plant requests"
    annotation (Placement(transformation(extent={{200,-240},{240,-200}}),
        iconTransformation(extent={{200,-220},{240,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,-40},{240,0}}),
      iconTransformation(extent={{200,-60},{240,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
      iconTransformation(extent={{200,140},{240,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
      iconTransformation(extent={{200,100},{240,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
      iconTransformation(extent={{200,60},{240,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") if have_cooCoi
    "Cooling coil control signal"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
      iconTransformation(extent={{200,-20},{240,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heatingCoil
    "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
      iconTransformation(extent={{200,20},{240,60}})));

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
    bouLim=Thys,
    final uLow=uLow,
    final uHigh=uHigh,
    preWarCooTim=preWarCooTim)
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

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) if not have_cooCoi
    "Constant zero signal source if cooling coil is absent"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.PlantRequests fcuPlaReq(
    final have_hotWatCoi=have_heatingCoil,
    final have_chiWatCoi=have_cooCoi,
    final cooSpeMax=cooSpeMax,
    final heaSpeMax=heaSpeMax,
    final chiWatPlaReqLim0=chiWatPlaReqLim0,
    final chiWatResReqLim0=chiWatResReqLim0,
    final chiWatPlaReqLim1=chiWatPlaReqLim1,
    final chiWatResReqLim2=chiWatResReqLim2,
    final chiWatResReqTimLim2=chiWatResReqTimLim2,
    final chiWatResReqLim3=chiWatResReqLim3,
    final chiWatResReqTimLim3=chiWatResReqTimLim3,
    final hotWatPlaReqLim0=hotWatPlaReqLim0,
    final hotWatResReqLim0=hotWatResReqLim0,
    final hotWatPlaReqLim1=hotWatPlaReqLim1,
    final hotWatResReqLim2=hotWatResReqLim2,
    final hotWatResReqTimLim2=hotWatResReqTimLim2,
    final hotWatResReqLim3=hotWatResReqLim3,
    final hotWatResReqTimLim3=hotWatResReqTimLim3,
    final Thys=Thys,
    final posHys=posHys,
    final dFanSpe=dFanSpe)
    "Block for generating chilled water requests and hot water requests for their respective plants"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOccMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isUnOcc
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-100,-180},{-80,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Not isOcc
    "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-70,-180},{-50,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    final k=false) if not have_winSen
    "Window status"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold havOcc(
    final t=1) if have_occSen
    "Check if there is occupant"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature TSupAir(
    final have_cooCoi=have_cooCoi,
    final have_heatingCoil=have_heatingCoil,
    final THeaSupAirMax=TSupSetMax,
    final TCooSupAirMin=TSupSetMin,
    final heaPerMax=heaPerMin,
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
    annotation (Placement(transformation(extent={{100,-2},{120,22}})));

  Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed fanSpe(
    final have_cooCoi=have_cooCoi,
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0) if not have_heatingCoil
    "Constant zero signal source if heating coil is absent"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

equation
  connect(unOccMod.y, isUnOcc.u2) annotation (Line(points={{-138,-170},{-120,-170},
          {-120,-178},{-102,-178}}, color={255,127,0}));

  connect(isUnOcc.y, isOcc.u)
    annotation (Line(points={{-78,-170},{-72,-170}}, color={255,0,255}));

  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,-50},{-30,-50},{-30,148}},
          color={0,0,127}));

  connect(isOcc.y, heaPI.trigger) annotation (Line(points={{-48,-170},{-36,-170},
          {-36,84},{-76,84},{-76,208}}, color={255,0,255}));

  connect(isOcc.y, cooPI.trigger) annotation (Line(points={{-48,-170},{-36,-170},
          {-36,148}}, color={255,0,255}));

  connect(TZon, heaPI.u_m) annotation (Line(points={{-220,-50},{-70,-50},{-70,208}},
          color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-118,152},{
          -100,152},{-100,220},{-82,220}}, color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-118,152},
          {-54,152},{-54,120},{220,120}},   color={0,0,127}));

  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-118,160},
          {-42,160}},color={0,0,127}));

  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-118,160},
          {-50,160},{-50,80},{220,80}}, color={0,0,127}));

  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,-50},{-168,-50},{
          -168,164},{-142,164}}, color={0,0,127}));

  connect(tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-220,160},{-142,
          160}}, color={0,0,127}));

  connect(uOcc, modSetPoi.uOcc) annotation (Line(points={{-220,70},{-174,70},{-174,
          162},{-142,162}},      color={255,0,255}));

  connect(modSetPoi.yOpeMod, isUnOcc.u1) annotation (Line(points={{-118,168},{-110,
          168},{-110,-170},{-102,-170}}, color={255,127,0}));

  connect(win.y, modSetPoi.uWin) annotation (Line(points={{-158,-70},{-150,-70},
          {-150,166},{-142,166}}, color={255,0,255}));

  connect(uWin, modSetPoi.uWin) annotation (Line(points={{-220,-150},{-150,-150},
          {-150,166},{-142,166}},color={255,0,255}));

  connect(havOcc.y, modSetPoi.uOccSen) annotation (Line(points={{-78,60},{-60,60},
          {-60,112},{-180,112},{-180,154},{-142,154}}, color={255,0,255}));

  connect(modSetPoi.warUpTim, warUpTim) annotation (Line(points={{-142,168},{-180,
          168},{-180,190},{-220,190}}, color={0,0,127}));

  connect(modSetPoi.cooDowTim, cooDowTim) annotation (Line(points={{-142,170},{-174,
          170},{-174,220},{-220,220}}, color={0,0,127}));

  connect(modSetPoi.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{-142,
          152},{-162,152},{-162,40},{-220,40}}, color={255,127,0}));

  connect(modSetPoi.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{-142,
          150},{-156,150},{-156,10},{-220,10}}, color={255,127,0}));

  connect(TSupAir.yCooCoi, yCooCoi) annotation (Line(points={{122,4},{160,4},{160,
          -60},{220,-60}},        color={0,0,127}));

  connect(TSupAir.yHeaCoi, yHeaCoi) annotation (Line(points={{122,16},{160,16},{
          160,20},{220,20}},    color={0,0,127}));

  connect(TSupAir.TAirSupSet, TAirSupSet) annotation (Line(points={{122,10},{180,
          10},{180,-20},{220,-20}}, color={0,0,127}));

  connect(fanSpe.yFanSpe, yFanSpe) annotation (Line(points={{142,178},{160,178},
          {160,160},{220,160}}, color={0,0,127}));

  connect(fanSpe.yFan, yFan) annotation (Line(points={{142,182},{160,182},{160,200},
          {220,200}}, color={255,0,255}));

  connect(modSetPoi.yOpeMod, fanSpe.opeMod) annotation (Line(points={{-118,168},
          {-60,168},{-60,180},{20,180},{20,186},{118,186}}, color={255,127,0}));

  connect(TSup, TSupAir.TAirSup) annotation (Line(points={{-220,-20},{-60,-20},{
          -60,8},{98,8}},  color={0,0,127}));

  connect(uFan, fanSpe.uFanPro) annotation (Line(points={{-220,-120},{28,-120},{
          28,182},{118,182}}, color={255,0,255}));

  connect(heaPI.y, fanSpe.uHea) annotation (Line(points={{-58,220},{0,220},{0,178},
          {118,178}}, color={0,0,127}));

  connect(cooPI.y, fanSpe.uCoo) annotation (Line(points={{-18,160},{20,160},{20,
          174},{118,174}}, color={0,0,127}));

  connect(modSetPoi.TZonCooSet, TSupAir.TZonSetCoo) annotation (Line(points={{-118,
          160},{-50,160},{-50,0},{98,0}},      color={0,0,127}));

  connect(modSetPoi.TZonHeaSet, TSupAir.TZonSetHea) annotation (Line(points={{-118,
          152},{-54,152},{-54,16},{98,16}},    color={0,0,127}));

  connect(cooPI.y, TSupAir.uCoo) annotation (Line(points={{-18,160},{20,160},{20,
          4},{98,4}},      color={0,0,127}));

  connect(heaPI.y, TSupAir.uHea) annotation (Line(points={{-58,220},{0,220},{0,12},
          {98,12}},   color={0,0,127}));

  connect(TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{220,120},{220,120}}, color={0,0,127}));

  connect(uFan, TSupAir.uFan) annotation (Line(points={{-220,-120},{28,-120},{28,
          20},{98,20}},           color={255,0,255}));

  connect(nOcc, havOcc.u) annotation (Line(points={{-220,-90},{-120,-90},{-120,60},
          {-102,60}}, color={255,127,0}));

  connect(setAdj, modSetPoi.setAdj) annotation (Line(points={{-220,130},{-184,130},
          {-184,158},{-142,158}}, color={0,0,127}));

  connect(heaSetAdj, modSetPoi.heaSetAdj) annotation (Line(points={{-220,100},{-152,
          100},{-152,156},{-142,156}}, color={0,0,127}));

  connect(TSup, fcuPlaReq.TAirSup) annotation (Line(points={{-220,-20},{-60,-20},
          {-60,-86},{98,-86}},           color={0,0,127}));

  connect(uCooCoi, fcuPlaReq.uCooCoi_actual) annotation (Line(points={{-220,-240},
          {80,-240},{80,-93.8},{98,-93.8}},       color={0,0,127}));

  connect(uHeaCoi, fcuPlaReq.uHeaCoi_actual) annotation (Line(points={{-220,-200},
          {90,-200},{90,-98},{98,-98}},           color={0,0,127}));

  connect(con.y, fcuPlaReq.uCooCoi_actual) annotation (Line(points={{62,-50},{80,
          -50},{80,-93.8},{98,-93.8}},       color={0,0,127}));

  connect(fcuPlaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{122,-84},
          {160,-84},{160,-100},{220,-100}},      color={255,127,0}));

  connect(fcuPlaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{122,-88},{
          156,-88},{156,-140},{220,-140}},       color={255,127,0}));

  connect(fcuPlaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{122,-92},
          {150,-92},{150,-180},{220,-180}},                color={255,127,0}));

  connect(fcuPlaReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{122,-96},
          {144,-96},{144,-220},{220,-220}},      color={255,127,0}));

  connect(TSupAir.TAirSupSet, fcuPlaReq.TSupSet) annotation (Line(points={{122,10},
          {130,10},{130,-70},{94,-70},{94,-90},{98,-90}}, color={0,0,127}));

  connect(fanSpe.yFanSpe, fcuPlaReq.uFanSpe) annotation (Line(points={{142,178},
          {150,178},{150,-60},{90,-60},{90,-82},{98,-82}},           color={0,0,
          127}));

  connect(con1.y, fcuPlaReq.uHeaCoi_actual) annotation (Line(points={{62,-120},{
          90,-120},{90,-98},{98,-98}}, color={0,0,127}));

annotation (defaultComponentName="conFCU",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{200,300}}),
        graphics={Rectangle(
        extent={{-200,-300},{200,300}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,380},{200,300}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-196,216},{-134,188}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-200,-68},{-156,-88}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-200,92},{-154,72}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-200,-28},{-152,-50}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          extent={{-198,-132},{-152,-104}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="nOcc"),
        Text(
          visible=have_winSen,
          extent={{-198,-186},{-154,-208}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          extent={{132,-22},{198,-56}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirSup"),
        Text(
          extent={{150,174},{198,150}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFanSpe"),
        Text(
          extent={{116,136},{194,102}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{116,98},{196,60}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{142,60},{196,22}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi"),
        Text(
          extent={{142,20},{196,-18}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{-194,298},{-120,266}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-194,258},{-114,226}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-194,54},{-82,32}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-194,12},{-82,-10}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          extent={{-202,-150},{-156,-170}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFan"),
        Text(
          extent={{158,212},{202,190}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan"),
        Text(
          extent={{-196,174},{-134,146}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="setAdj"),
        Text(
          extent={{-196,134},{-134,106}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="heaSetAdj"),
        Text(
          extent={{-196,-228},{-148,-250}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaCoi"),
        Text(
          extent={{-196,-268},{-148,-290}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooCoi"),
        Text(
          extent={{106,-90},{198,-66}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiWatResReq"),
        Text(
          extent={{132,-130},{198,-108}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiPlaReq"),
        Text(
          extent={{104,-170},{196,-146}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatResReq"),
        Text(
          extent={{106,-210},{198,-186}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatPlaReq")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-260},{200,240}})),
Documentation(info="<html>
<p>
Block for fan coil unit control. It outputs supply fan enable signal and speed signal,
the supply air temperature setpoint, the zone air heating and cooling setpoints,
and valve positions of heating and cooling coils.
</p>
<p>
It is implemented according to the ASHRAE Guideline 36, Part 5.22.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan control</h4>
<p>
The supply fan control is implemented according to Part 5.22.4. It outputs
the control signals for supply fan enable <code>yFan</code> and the fan speed 
<code>yFanSpe</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed\">
Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.FanSpeed</a> for more detailed 
description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
The supply air temperature setpoint control sequences are implemented based on Part 5.22.4.
The block outputs a supply air temperature setpoint signal <code>TAirSupSet</code>,
and control signals for the heating coil <code>yHeaCoi</code> and the cooling coil 
<code>yCooCoi</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature\">
Buildings.Controls.OBC.ASHRAE.FanCoilUnit.Subsequences.SupplyAirTemperature</a>
for more detailed description.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
The zone air heating setpoint <code>TZonHeaSet</code>and cooling setpoint <code>TZonHeaSet</code>
as well as system operation mode signal <code>modSetPoi.yOpeMod</code> are detailed at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 22, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
