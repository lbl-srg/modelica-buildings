within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block Controller
  "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"

  parameter Boolean have_winSen "Check if the zone has window status sensor";
  parameter Boolean have_occSen  "Set to true if zones have occupancy sensor";
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
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Cooling loop control"));
  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(group="Cooling loop control"));
  parameter Real TiCoo(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(group="Cooling loop control",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(group="Cooling loop control",
      enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Heating loop control"));
  parameter Real kHea(final unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(group="Heating loop control"));
  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(group="Heating loop control",
    enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(group="Heating loop control",
      enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Cooling coil control"));
  parameter Real kCooCoi(final unit="1/K")=0.1
    "Gain for cooling coil control signal"
    annotation(Dialog(group="Cooling coil control"));
  parameter Real TiCooCoil(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling coil control signal"
    annotation(Dialog(group="Cooling coil control",
    enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoil(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling coil control signal"
    annotation (Dialog(group="Cooling coil control",
      enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TSupSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="VAV Setpoints",group="Temperature limits"));
  parameter Real TSupSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="VAV Setpoints",group="Temperature limits"));
  parameter Real yHeaMax(min=0, max=1, unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));
  parameter Real yMin(min=0, max=1, unit="1")
    "Minimum fan speed"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));
  parameter Real yCooMax(min=0, max=1, unit="1") = 1
    "Maximum fan speed for cooling"
    annotation (Dialog(tab="VAV Setpoints",group="Speed"));
  parameter Real VOutPerAre_flow(final unit="m3/(s.m2)") = 3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Real VOutPerPer_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") = 2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Real AFlo(final unit="m2", final quantity="Area")
    "Floor area"
    annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
  parameter Real occDen(final unit="1/m2") = 0.05
    "Default number of person in unit area"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real zonDisEffHea(final unit="1") = 0.8
    "Zone air distribution effectiveness during heating"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Real zonDisEffCoo(final unit="1") = 1.0
    "Zone air distribution effectiveness during cooling"
    annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
  parameter Boolean use_enthalpy=false
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation(Dialog(tab="Economizer", group="General", enable=not use_fixed_plus_differential_drybulb));
  parameter Boolean use_fixed_plus_differential_drybulb=false
    "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
    annotation(Dialog(tab="Economizer", group="General", enable=not use_enthalpy));
  parameter Boolean use_TMix=true
    "Set to true if mixed air temperature measurement is enabled"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Boolean use_G36FrePro=false
    "Set to true if G36 freeze protection is implemented"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Real delEntHis(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
     annotation(Dialog(tab="Economizer", group="Advanced", enable = use_enthalpy));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
    annotation(Dialog(tab="Economizer", group="Modulation"));
  parameter Real TiMod(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uMin(
    final min=0,
    final max=1,
    final unit="1") = 0.1
    "Lower limit of controller output uTSup at which the dampers are at their limits"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Real uMax(
    final min=0,
    final max=1,
    final unit="1") = 0.9
    "Upper limit of controller output uTSup at which the dampers are at their limits"
    annotation(Dialog(tab="Economizer", group="General"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real TiFre(
    final unit="s",
    final quantity="Time")=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
     annotation(Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix
         and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
     "Time constant of derivative block for freeze protection"
     annotation (Dialog(tab="Economizer", group="Freeze protection",
       enable=use_TMix and
           (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TFreSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
     annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_minSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.4
    "OA damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_maxSpe(
    final min=outDamPhyPosMin,
    final max=outDamPhyPosMax,
    final unit="1") = 0.3
    "OA damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_minSpe(
    final min=yDam_VOutMin_minSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.9
    "OA damper position to supply design outdoor airflow at minimum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_maxSpe(
    final min=yDam_VOutMin_maxSpe,
    final max=outDamPhyPosMax,
    final unit="1") = 0.8
    "OA damper position to supply design outdoor airflow at maximum fan speed"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the outdoor air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the outdoor air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Dialog(tab="Economizer", group="Commissioning"));
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
    final quantity="ThermodynamicTemperature")=300.15 "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real TZonCooOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15 "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real TZonHeaOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15 "Maximum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real TZonHeaOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15 "Minimum heating setpoint during on"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real TZonCooSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15 "Cooling setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15 "Heating setpoint when window is open"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Limits"));
  parameter Real incTSetDem_1=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real incTSetDem_2=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real incTSetDem_3=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real decTSetDem_1=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real decTSetDem_2=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real decTSetDem_3=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Adjust temperature setpoint", group="Demand control adjustment"));
  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,230},{-200,270}}),
        iconTransformation(extent={{-240,230},{-200,270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-240,170},{-200,210}}),
        iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-240,200},{-200,240}}),
        iconTransformation(extent={{-240,170},{-200,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,110},{-200,150}}),
        iconTransformation(extent={{-240,110},{-200,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-240,50},{-200,90}}),
        iconTransformation(extent={{-240,50},{-200,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
        iconTransformation(extent={{-240,30},{-200,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-240,0},{-200,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Economizer high limit cutoff. Fixed dry bulb or differential dry bulb temeprature"
    annotation (Placement(transformation(extent={{-240,-40},{-200,0}}),
        iconTransformation(extent={{-240,-30},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection if use_TMix is true"
    annotation (Placement(transformation(extent={{-240,-70},{-200,-30}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") if
       have_occSen "Number of occupants"
    annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-240,-90},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-130},{-200,-90}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
        iconTransformation(extent={{-240,-150},{-200,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Economizer enthalpy high limit cutoff. Fixed enthalpy or differential enthalpy"
    annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-240,-190},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if
       use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-240,-230},{-200,-190}}),
        iconTransformation(extent={{-240,-230},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta if
       use_G36FrePro
    "Freeze protection status, used if use_G36FrePro=true"
    annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
        iconTransformation(extent={{-240,-270},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{200,230},{240,270}}),
        iconTransformation(extent={{200,200},{240,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{200,170},{240,210}}),
        iconTransformation(extent={{200,150},{240,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{200,140},{240,180}}),
        iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,90},{240,130}}),
      iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
      iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") "Heating coil control signal"
    annotation (Placement(transformation(extent={{200,-70},{240,-30}}),
        iconTransformation(extent={{200,-80},{240,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil control signal"
    annotation (Placement(transformation(extent={{200,-130},{240,-90}}),
        iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
        iconTransformation(extent={{200,-190},{240,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,-250},{240,-210}}),
        iconTransformation(extent={{200,-240},{240,-200}})));

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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
    setPoiVAV(
    final TSupSetMax=TSupSetMax,
    final TSupSetMin=TSupSetMin,
    final yHeaMax=yHeaMax,
    final yMin=yMin,
    final yCooMax=yCooMax)
    "Supply air set point and fan signal for single zone VAV system"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset cooPI(
    final reverseActing=false,
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPI(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea)
    "Zone heating control signal"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Average ave
    "Average of zone heating and cooling setpoint"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
    conEco(
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro,
    final delTOutHis=uHigh - uLow,
    final delEntHis=delEntHis,
    final controllerTypeMod=controllerTypeMod,
    final kMod=kMod,
    final TiMod=TiMod,
    final TdMod=TdMod,
    final uMin=uMin,
    final uMax=uMax,
    final controllerTypeFre=controllerTypeFre,
    final kFre=kFre,
    final TiFre=TiFre,
    final TdFre=TdFre,
    final TFreSet=TFreSet,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final use_enthalpy=use_enthalpy,
    final use_fixed_plus_differential_drybulb=use_fixed_plus_differential_drybulb,
    final yFanMin=0,
    final yFanMax=1)
    "Economizer control sequence"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
    outAirSetPoi(
    final AFlo=AFlo,
    final have_occSen=have_occSen,
    final VOutPerAre_flow=VOutPerAre_flow,
    final VOutPerPer_flow=VOutPerPer_flow,
    final occDen=occDen,
    final zonDisEffHea=zonDisEffHea,
    final zonDisEffCoo=zonDisEffCoo,
    final uLow=uLow,
    final uHigh=uHigh)
    "Output the minimum outdoor airflow rate setpoint "
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState zonSta "Zone state"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-100,-240},{-80,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Not switch
    "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-70,-240},{-50,-220}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil cooCoi(
    final controllerTypeCooCoi=controllerTypeCooCoi, kCooCoi=kCooCoi)
    "Controller for cooling coil valve"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant win(
    final k=false) if not have_winSen
    "Window status"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold havOcc(
    final t=0.5) if have_occSen "Check if there is occupant"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

equation
  connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-18,200},{-10,200},
          {-10,191.667},{38,191.667}}, color={0,0,127}));
  connect(TCut, conEco.TCut) annotation (Line(points={{-220,-20},{-180,-20},{-180,
          -32.2},{119,-32.2}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{119,-38.6},{-4,-38.6},{-4,
          10},{-220,10}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{62,195},
          {92,195},{92,-40.2},{119,-40.2}},   color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{62,185},{86,
          185},{86,-43},{119,-43}}, color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,-50},{-180,-50},{-180,
          -44.4},{119,-44.4}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{62,195},{160,
          195},{160,250},{220,250}}, color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{62,190},{220,190}},
          color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{62,185},{120,185},{120,160},
          {220,160}}, color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{141,-40},{168,
          -40},{168,-230},{220,-230}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{141,-44},{160,
          -44},{160,-170},{220,-170}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{38,27},{-4,27},{-4,
          10},{-220,10}}, color={0,0,127}));
  connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
      Line(points={{119,-41.6},{108,-41.6},{108,30},{62,30}}, color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,250},{10,250},{10,
          185},{38,185}},    color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{119,-30.6},{10,
          -30.6},{10,185},{38,185}}, color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{74,
          140},{74,-48.2},{119,-48.2}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-138,-230},{-120,-230},
          {-120,-238},{-102,-238}},color={255,127,0}));
  connect(intEqu.y, switch.u) annotation (Line(points={{-78,-230},{-72,-230}}, color={255,0,255}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{38,34},{8,34},{8,-110},
          {-220,-110}},color={255,0,255}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,130},{-30,130},{-30,148}},
          color={0,0,127}));
  connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-80},{-60,-80},
          {-60,38},{38,38}}, color={0,0,127}));
  connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-240},{-180,
          -240},{-180,-200},{40,-200},{40,-49.6},{119,-49.6}}, color={255,127,0}));
  connect(conEco.hOut, hOut) annotation (Line(points={{119,-35.4},{100,-35.4},{100,
          -150},{-220,-150}}, color={0,0,127}));
  connect(conEco.hCut, hCut) annotation (Line(points={{119,-37},{96,-37},{96,-180},
          {-220,-180}}, color={0,0,127}));
  connect(conEco.TRet, TRet) annotation (Line(points={{119,-33.8},{104,-33.8},{104,
          -210},{-220,-210}}, color={0,0,127}));
  connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{141,-36},{174,-36},
          {174,-50},{220,-50}}, color={0,0,127}));
  connect(cooCoi.yCooCoi, yCooCoi)   annotation (Line(points={{142,-120},{178,-120},{178,-110},{220,-110}},
          color={0,0,127}));
  connect(switch.y, cooCoi.uSupFan) annotation (Line(points={{-48,-230},{60,-230},
          {60,-128},{118,-128}},  color={255,0,255}));
  connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{61,140},{74,
          140},{74,-124},{118,-124}}, color={255,127,0}));
  connect(cooCoi.TSup, TSup) annotation (Line(points={{118,-116},{-4,-116},{-4,10},
          {-220,10}}, color={0,0,127}));
  connect(switch.y, outAirSetPoi.uSupFan) annotation (Line(points={{-48,-230},{-36,
          -230},{-36,24},{38,24}}, color={255,0,255}));
  connect(switch.y, conEco.uSupFan) annotation (Line(points={{-48,-230},{60,-230},
          {60,-45.6},{119,-45.6}}, color={255,0,255}));
  connect(switch.y, setPoiVAV.uFan) annotation (Line(points={{-48,-230},{28,
          -230},{28,181.667},{38,181.667}},
                                      color={255,0,255}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-58,220},{0,220},{
          0,198.333},{38,198.333}},
                                  color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-58,220},{0,220},{0,144},
          {38,144}}, color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-18,160},{20,160},{
          20,195},{38,195}}, color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-18,160},{20,160},{20,
          136},{38,136}}, color={0,0,127}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-48,-230},{-36,-230},
          {-36,84},{-76,84},{-76,208}}, color={255,0,255}));
  connect(switch.y, cooPI.trigger) annotation (Line(points={{-48,-230},{-36,-230},
          {-36,148}}, color={255,0,255}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-220,130},{-70,130},{-70,208}},
          color={0,0,127}));
  connect(setPoiVAV.TSupCoo, cooCoi.TSupCoo) annotation (Line(points={{62,190},{
          80,190},{80,-112},{118,-112}}, color={0,0,127}));
  connect(TZon, setPoiVAV.TZon) annotation (Line(points={{-220,130},{-70,130},{
          -70,180},{-10,180},{-10,188.333},{38,188.333}},  color={0,0,127}));
  connect(TZon, outAirSetPoi.TZon) annotation (Line(points={{-220,130},{-70,130},
          {-70,30},{38,30}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-118,152},{
          -100,152},{-100,220},{-82,220}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-118,152},{-100,
          152},{-100,194},{-42,194}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-118,152},
          {-100,152},{-100,110},{220,110}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-118,160},{-50,
          160},{-50,206},{-42,206}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-118,160},{
          -42,160}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-118,160},
          {-50,160},{-50,60},{220,60}}, color={0,0,127}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,130},{-168,130},{
          -168,164},{-142,164}}, color={0,0,127}));
  connect(tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-220,160},{-142,
          160}}, color={0,0,127}));
  connect(uOcc, modSetPoi.uOcc) annotation (Line(points={{-220,100},{-174,100},{
          -174,162},{-142,162}}, color={255,0,255}));
  connect(modSetPoi.yOpeMod, outAirSetPoi.uOpeMod) annotation (Line(points={{-118,
          168},{-110,168},{-110,21},{38,21}}, color={255,127,0}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-118,168},
          {-110,168},{-110,-47},{119,-47}}, color={255,127,0}));
  connect(modSetPoi.yOpeMod, intEqu.u1) annotation (Line(points={{-118,168},{-110,
          168},{-110,-230},{-102,-230}}, color={255,127,0}));
  connect(win.y, modSetPoi.uWin) annotation (Line(points={{-158,-130},{-150,-130},
          {-150,166},{-142,166}}, color={255,0,255}));
  connect(uWin, modSetPoi.uWin) annotation (Line(points={{-220,-110},{-150,-110},
          {-150,166},{-142,166}},color={255,0,255}));
  connect(win.y, outAirSetPoi.uWin) annotation (Line(points={{-158,-130},{8,-130},
          {8,34},{38,34}}, color={255,0,255}));
  connect(nOcc, havOcc.u) annotation (Line(points={{-220,-80},{-120,-80},{-120,60},
          {-102,60}}, color={0,0,127}));
  connect(havOcc.y, modSetPoi.uOccSen) annotation (Line(points={{-78,60},{-60,60},
          {-60,120},{-180,120},{-180,154},{-142,154}}, color={255,0,255}));
  connect(modSetPoi.warUpTim, warUpTim) annotation (Line(points={{-142,168},{-180,
          168},{-180,190},{-220,190}}, color={0,0,127}));
  connect(modSetPoi.cooDowTim, cooDowTim) annotation (Line(points={{-142,170},{-174,
          170},{-174,220},{-220,220}}, color={0,0,127}));
  connect(modSetPoi.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{-142,
          152},{-162,152},{-162,70},{-220,70}}, color={255,127,0}));
  connect(modSetPoi.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{-142,
          150},{-156,150},{-156,40},{-220,40}}, color={255,127,0}));

annotation (defaultComponentName="conVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,260}}),
        graphics={Rectangle(
        extent={{-200,-260},{200,260}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-204,354},{216,274}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-200,260},{-154,242}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-194,178},{-132,150}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-200,142},{-156,122}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          extent={{-198,116},{-152,96}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-200,0},{-152,-20}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCut"),
        Text(
          extent={{-200,32},{-152,10}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          visible=use_TMix,
          extent={{-200,-30},{-156,-50}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TMix"),
        Text(
          visible=have_occSen,
          extent={{-196,-82},{-150,-54}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="nOcc"),
        Text(
          visible=have_winSen,
          extent={{-196,-86},{-152,-108}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          visible=use_enthalpy,
          extent={{-192,-152},{-138,-190}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hCut"),
        Text(
          visible=use_enthalpy,
          extent={{-192,-114},{-138,-152}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hOut"),
        Text(
          visible=use_fixed_plus_differential_drybulb,
          extent={{-192,-190},{-138,-228}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TRet"),
        Text(
          visible=use_G36FrePro,
          extent={{-196,-230},{-112,-262}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFreProSta"),
        Text(
          extent={{104,238},{190,204}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEco"),
        Text(
          extent={{124,186},{190,152}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCoo"),
        Text(
          extent={{146,134},{194,110}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan"),
        Text(
          extent={{112,78},{190,44}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{114,22},{194,-16}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{140,-40},{194,-78}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi"),
        Text(
          extent={{140,-100},{194,-138}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{108,-156},{192,-188}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{106,-200},{194,-238}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos"),
        Text(
          extent={{-196,238},{-122,206}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-196,208},{-116,176}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-196,84},{-84,62}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-196,62},{-84,40}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev")}),
          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
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
for heating and economizer is the same; while the supply air temperature setpoint for cooling has
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
August 3, 2019, by David Blum &amp; Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
