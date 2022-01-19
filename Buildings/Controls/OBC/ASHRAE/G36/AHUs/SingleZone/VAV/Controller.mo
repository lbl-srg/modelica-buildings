within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV;
block Controller
  "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"

  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor";
  parameter Boolean have_occSen=false
    "Check if the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=false
    "True: the zone has CO2 sensor";
  parameter Boolean have_heaCoi=true
    "True if the air handling unit has heating coil";
  parameter Real AFlo(
    final unit="m2",
    final quantity="Area") "Zone floor area"
    annotation (Dialog(group="Design conditions"));
  parameter Real desZonPop(
    final unit="1")
    "Design zone population"
    annotation (Dialog(group="Design conditions"));
  parameter Real outAirRat_area=0.0003
    "Outdoor airflow rate per unit area, m3/s/m2"
    annotation (Dialog(group="Design conditions"));
  parameter Real outAirRat_occupant=0.0025
    "Outdoor airflow rate per occupant, m3/s/p"
    annotation (Dialog(group="Design conditions"));
  parameter Real CO2Set=894 "CO2 concentration setpoint, ppm"
    annotation (Dialog(group="Design conditions", enable=have_CO2Sen));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooLooCon=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Cooling loop controller type"
    annotation (Dialog(group="Loops control"));
  parameter Real kCoo(final unit="1/K") = 0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(group="Loops control"));
  parameter Real TiCoo(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(group="Loops control",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(group="Loops control",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaLooCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating loop controller type"
    annotation(Dialog(group="Loops control"));
  parameter Real kHea(
    final unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(group="Loops control"));
  parameter Real TiHea(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(group="Loops control",
    enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(group="Loops control",
      enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real THeaSetOcc=293.15
    "Occupied heating setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real THeaSetUno=285.15
    "Unoccupied heating setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real TCooSetOcc=297.15
    "Occupied cooling setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real TCooSetUno=303.15
    "Unoccupied cooling setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings", enable=not (cooAdj or heaAdj)));
  parameter Boolean ignDemLim=false
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Real TZonCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooSetWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaSetWinOpe=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real incTSetDem_1(
    final unit="K")=0.5
    "Cooling setpoint increase value when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real incTSetDem_2(
    final unit="K")=1
    "Cooling setpoint increase value when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real incTSetDem_3(
    final unit="K")=2
    "Cooling setpoint increase value when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_1(
    final unit="K")=0.5
    "Heating setpoint decrease value when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_2(
    final unit="K")=1
    "Heating setpoint decrease value when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_3(
    final unit="K")=2
    "Heating setpoint decrease value when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time")=10800
    "Maximum cool-down or warm-up time"
    annotation (Dialog(tab="Operating mode"));
  parameter Real TZonFreProOn=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (Dialog(tab="Operating mode"));
  parameter Real TZonFreProOff=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (Dialog(tab="Operating mode"));
  parameter Real TSupSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSupSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TDewSupMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Maximum supply air dew-point temperature"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TMinSupDea=294.15
    "Minimum supply temperature when it is in deadband state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TMaxSupDea=297.15
    "Maximum supply temperature when it is in deadband state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for temperature control, when it is in heating state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real maxHeaSpe(
    final unit="1",
    final min=0,
    final max=1) "Maximum fan speed for heating"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real maxCooSpe(
    final unit="1") "Maximum fan speed for cooling"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real minSpe(
    final unit="1",
    final min=0,
    final max=1) "Minimum fan speed"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real spePoiOne(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real spePoiTwo(
    final unit="1",
    final min=0,
    final max=1)=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real spePoiThr(
    final unit="1",
    final min=0,
    final max=1)=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Real spePoiFou(
    final unit="1",
    final min=0,
    final max=1)=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Speed"));
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (Dialog(tab="Outdoor airflow"));
  parameter Real zonDisEff_cool(
    final unit="1")=1.0
    "Zone cooling air distribution effectiveness"
    annotation (Dialog(tab="Outdoor airflow"));
  parameter Real zonDisEff_heat(
    final unit="1")=0.8
    "Zone heating air distribution effectiveness"
    annotation (Dialog(tab="Outdoor airflow"));
  parameter Boolean use_enthalpy
    "Set to true if enthalpy measurement is used in addition to temperature measurement"
    annotation (Dialog(tab="Economizer", enable=not use_fixed_plus_differential_drybulb));
  parameter Boolean use_fixed_plus_differential_drybulb
    "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
    annotation (Dialog(tab="Economizer", enable=not use_enthalpy));
  parameter Boolean use_TMix
    "Set to true if mixed air temperature measurement is enabled"
    annotation (Dialog(tab="Economizer"));
  parameter Boolean use_G36FrePro
    "Set to true if G36 freeze protection is implemented"
    annotation (Dialog(tab="Economizer"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController ecoModCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Economizer modulation control"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod(
    final unit="1/K")=1
    "Gain of modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  parameter Real TiMod(
    final unit="s",
    final quantity="Time")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController ecoFreProCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Economizer freeze protection control"
    annotation (Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real kFre(final unit="1/K")=0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
    annotation (Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real TiFre(
    final unit="s",
    final quantity="Time")=120
    "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
    annotation (Dialog(tab="Economizer", group="Freeze protection",
      enable=use_TMix
        and (ecoFreProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or ecoFreProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFre(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for freeze protection"
    annotation (Dialog(tab="Economizer", group="Freeze protection",
      enable=use_TMix
        and (ecoFreProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or ecoFreProCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TFreSet=277.15
    "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
    annotation (Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));
  parameter Real yFanMin(
    final unit="1",
    final min=0,
    final max=1)=0.1
    "Minimum supply fan operation speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real yFanMax(
    final unit="1",
    final min=0,
    final max=1)=0.9
    "Maximum supply fan operation speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real VOutMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real VOutDes_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.0
    "Calculated design outdoor airflow rate"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real yDam_VOutMin_minSpe(
    final unit="1",
    final min=0,
    final max=1)=0.4
    "Outdoor air damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real yDam_VOutMin_maxSpe(
    final unit="1",
    final min=0,
    final max=1)=0.3
    "Outdoor air damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real yDam_VOutDes_minSpe(
    final unit="1",
    final min=0,
    final max=1)=0.9
    "Outdoor air damper position to supply design outdoor airflow at minimum fan speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real yDam_VOutDes_maxSpe(
    final unit="1",
    final min=0,
    final max=1)=0.8
    "Outdoor air damper position to supply design outdoor airflow at maximum fan speed"
    annotation (Dialog(tab="Economizer", group="Damper position limits commissioning"));
  parameter Real outDamPhyPosMax(
    final unit="1",
    final min=0,
    final max=1)=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Physical damper position limits commissioning"));
  parameter Real outDamPhyPosMin(
    final unit="1",
    final min=0,
    final max=1)=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Physical damper position limits commissioning"));
  parameter Real retDamPhyPosMax(
    final unit="1",
    final min=0,
    final max=1)=1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Physical damper position limits commissioning"));
  parameter Real retDamPhyPosMin(
    final unit="1",
    final min=0,
    final max=1)=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Physical damper position limits commissioning"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling coil controller"
    annotation (Dialog(tab="Cooling coil"));
  parameter Real kCooCoi(
    final unit="1/K")=0.1
    "Gain for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil"));
  parameter Real TiCooCoi(
    final unit="s",
    final quantity="Time")=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoi(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-240,270},{-200,310}}),
        iconTransformation(extent={{-240,230},{-200,270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-240,240},{-200,280}}),
        iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-240,210},{-200,250}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
        iconTransformation(extent={{-240,150},{-200,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-240,150},{-200,190}}),
        iconTransformation(extent={{-240,130},{-200,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj if cooAdj or sinAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
      iconTransformation(extent={{-240,70},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
      iconTransformation(extent={{-240,50},{-200,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-240,30},{-200,70}}),
      iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-240,-10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-240,-30},{-200,10}}),
        iconTransformation(extent={{-240,-30},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-240,-90},{-200,-50}}),
        iconTransformation(extent={{-240,-90},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Economizer high limit cutoff. Fixed dry bulb or differential dry bulb temeprature"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
        iconTransformation(extent={{-240,-110},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature") if use_TMix
    "Measured mixed air temperature, used for freeze protection if use_TMix is true"
    annotation (Placement(transformation(extent={{-240,-150},{-200,-110}}),
        iconTransformation(extent={{-240,-130},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-240,-210},{-200,-170}}),
        iconTransformation(extent={{-240,-190},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Economizer enthalpy high limit cutoff. Fixed enthalpy or differential enthalpy"
    annotation (Placement(transformation(extent={{-240,-240},{-200,-200}}),
        iconTransformation(extent={{-240,-210},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if use_fixed_plus_differential_drybulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-240,-270},{-200,-230}}),
        iconTransformation(extent={{-240,-240},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    if use_G36FrePro
    "Freeze protection status, used if use_G36FrePro=true"
    annotation (Placement(transformation(extent={{-240,-300},{-200,-260}}),
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
    annotation (Placement(transformation(extent={{200,150},{240,190}}),
        iconTransformation(extent={{200,150},{240,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
    final min=0,
    final max=1,
    final unit="1") "Fan speed"
    annotation (Placement(transformation(extent={{200,110},{240,150}}),
        iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{200,70},{240,110}}),
        iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")  "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{200,-10},{240,30}}),
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
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
        iconTransformation(extent={{200,-190},{240,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{200,-260},{240,-220}}),
        iconTransformation(extent={{200,-240},{240,-200}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply setPoiVAV(
    final TSupSetMax=TSupSetMax,
    final TSupSetMin=TSupSetMin,
    final TDewSupMax=TDewSupMax,
    final TMinSupDea=TMinSupDea,
    final TMaxSupDea=TMaxSupDea,
    final maxHeaSpe=maxHeaSpe,
    final maxCooSpe=maxCooSpe,
    final minSpe=minSpe,
    final temPoiOne=temPoiOne,
    final temPoiTwo=temPoiTwo,
    final temPoiThr=temPoiThr,
    final temPoiFou=temPoiFou,
    final spePoiOne=spePoiOne,
    final spePoiTwo=spePoiTwo,
    final spePoiThr=spePoiThr,
    final spePoiFou=spePoiFou)
    "Supply air set point and fan signal for single zone VAV system"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset cooPI(
    final controllerType=cooLooCon,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPI(
    final controllerType=heaLooCon,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea) "Zone heating control signal"
    annotation (Placement(transformation(extent={{-70,210},{-50,230}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller conEco(
    final have_heaCoi=have_heaCoi,
    final use_enthalpy=use_enthalpy,
    final use_fixed_plus_differential_drybulb=use_fixed_plus_differential_drybulb,
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro,
    final controllerTypeMod=ecoModCon,
    final kMod=kMod,
    final TiMod=TiMod,
    final TdMod=TdMod,
    final controllerTypeFre=ecoFreProCon,
    final kFre=kFre,
    final TiFre=TiFre,
    final TdFre=TdFre,
    final TFreSet=TFreSet,
    final yFanMin=yFanMin,
    final yFanMax=yFanMax,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final yDam_VOutMin_minSpe=yDam_VOutMin_minSpe,
    final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
    final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
    final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin)
    "Economizer control sequence"
    annotation (Placement(transformation(extent={{140,-60},{160,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    outAirSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_SZVAVWitCO2=true,
    final permit_occStandby=permit_occStandby,
    final AFlo=AFlo,
    final desZonPop=desZonPop,
    final outAirRat_area=outAirRat_area,
    final outAirRat_occupant=outAirRat_occupant,
    final VZonMin_flow=0,
    final VCooZonMax_flow=0,
    final CO2Set=CO2Set,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat)
    "Output the minimum outdoor airflow rate setpoint "
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta
    "Zone state"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-160,-290},{-140,-270}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-90,-290},{-70,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-60,-290},{-40,-270}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints modSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final THeaSetOcc=THeaSetOcc,
    final THeaSetUno=THeaSetUno,
    final TCooSetOcc=TCooSetOcc,
    final TCooSetUno=TCooSetUno,
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
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff)
    "Output zone setpoint with operation mode selection"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.CoolingCoil cooCoi(
    final controllerTypeCooCoi=cooCoiCon,
    final kCooCoi=kCooCoi,
    final TiCooCoi=TiCooCoi,
    final TdCooCoi=TdCooCoi)
    "Controller for cooling coil valve"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));

equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-142,170.833},{
          -182,170.833},{-182,170},{-220,170}},
                 color={0,0,127}));
  connect(TCut, conEco.TCut) annotation (Line(points={{-220,-100},{20,-100},{20,
          -24},{138,-24}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{138,-36},{0,-36},{0,-70},
          {-220,-70}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco,conEco.TSupHeaEco)  annotation (Line(points={{62,190},
          {92,190},{92,-39},{138,-39}}, color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{62,198},{86,
          198},{86,-45},{138,-45}}, color={0,0,127}));
  connect(TMix, conEco.TMix) annotation (Line(points={{-220,-130},{30,-130},{30,
          -48},{138,-48}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{62,190},{
          160,190},{160,250},{220,250}},  color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{62,184},{160,
          184},{160,170},{220,170}}, color={0,0,127}));
  connect(setPoiVAV.y, yFan) annotation (Line(points={{62,198},{120,198},{120,
          130},{220,130}}, color={0,0,127}));
  connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{162,-40},{
          184,-40},{184,-240},{220,-240}}, color={0,0,127}));
  connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{162,-46},{
          176,-46},{176,-180},{220,-180}}, color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{38,41},{0,41},{0,
          -70},{-220,-70}},    color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,290},{10,290},{
          10,194},{38,194}}, color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{138,-21},{10,
          -21},{10,194},{38,194}}, color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{74,
          140},{74,-57},{138,-57}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-138,-280},{-120,-280},
          {-120,-288},{-92,-288}}, color={255,127,0}));
  connect(intEqu.y, switch.u) annotation (Line(points={{-68,-280},{-62,-280}},
          color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-118,
          163.333},{-88,163.333},{-88,220},{-72,220}},
                                            color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-118,170},{
          -40,170},{-40,160},{-32,160}},  color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{38,59},{-150,59},{
          -150,-160},{-220,-160}}, color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-142,172.5},{-158,
          172.5},{-158,200},{-220,200}},
                                  color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,140},{-174,140},
          {-174,174.167},{-142,174.167}},
                                  color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-220,140},{-20,140},{-20,
          148}}, color={0,0,127}));
  connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-280},{
          -180,-280},{-180,-240},{40,-240},{40,-59},{138,-59}}, color={255,127,0}));
  connect(conEco.hOut, hOut) annotation (Line(points={{138,-30},{98,-30},{98,
          -190},{-220,-190}}, color={0,0,127}));
  connect(conEco.hCut, hCut) annotation (Line(points={{138,-33},{104,-33},{104,
          -220},{-220,-220}}, color={0,0,127}));
  connect(conEco.TRet, TRet) annotation (Line(points={{138,-27},{110,-27},{110,
          -250},{-220,-250}}, color={0,0,127}));
  connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{162,-34},{190,-34},
          {190,-50},{220,-50}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-118,
          163.333},{-88,163.333},{-88,90},{220,90}},
                                        color={0,0,127}));
  connect(cooCoi.yCooCoi, yCooCoi)
    annotation (Line(points={{162,-120},{220,-120}}, color={0,0,127}));
  connect(switch.y, cooCoi.uSupFan) annotation (Line(points={{-38,-280},{60,
          -280},{60,-128},{138,-128}}, color={255,0,255}));
  connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{61,140},{74,
          140},{74,-124},{138,-124}}, color={255,127,0}));
  connect(cooCoi.TSup, TSup) annotation (Line(points={{138,-116},{0,-116},{0,
          -70},{-220,-70}}, color={0,0,127}));
  connect(switch.y, conEco.uSupFan) annotation (Line(points={{-38,-280},{60,
          -280},{60,-51},{138,-51}}, color={255,0,255}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-48,220},{0,220},{
          0,191},{38,191}},    color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-48,220},{0,220},{0,
          144},{38,144}}, color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-8,160},{20,160},{
          20,188},{38,188}},   color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-8,160},{20,160},{20,
          136},{38,136}}, color={0,0,127}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-38,-280},{-26,
          -280},{-26,80},{-66,80},{-66,208}},               color={255,0,255}));
  connect(switch.y, cooPI.trigger) annotation (Line(points={{-38,-280},{-26,
          -280},{-26,148}}, color={255,0,255}));
  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-118,170},
          {-40,170},{-40,10},{220,10}},                     color={0,0,127}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-220,140},{-60,140},{-60,
          208}}, color={0,0,127}));
  connect(intEqu.u1, modSetPoi.yOpeMod) annotation (Line(points={{-92,-280},{
          -100,-280},{-100,176.667},{-118,176.667}},
                                             color={255,127,0}));
  connect(setPoiVAV.TSupCoo, cooCoi.TSupCoo) annotation (Line(points={{62,184},
          {80,184},{80,-112},{138,-112}},color={0,0,127}));
  connect(TZon, setPoiVAV.TZon) annotation (Line(points={{-220,140},{-60,140},{-60,
          196.4},{38,196.4}}, color={0,0,127}));
  connect(TZon, outAirSetPoi.TZon) annotation (Line(points={{-220,140},{-60,140},
          {-60,43},{38,43}}, color={0,0,127}));
  connect(modSetPoi.yOpeMod, outAirSetPoi.uOpeMod) annotation (Line(points={{-118,
          176.667},{-100,176.667},{-100,54},{38,54}},
                                              color={255,127,0}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-118,
          176.667},{-100,176.667},{-100,-55},{138,-55}},
                                            color={255,127,0}));
  connect(cooDowTim, modSetPoi.cooDowTim) annotation (Line(points={{-220,260},{
          -150,260},{-150,179.167},{-142,179.167}},
                                            color={0,0,127}));
  connect(warUpTim, modSetPoi.warUpTim) annotation (Line(points={{-220,230},{
          -154,230},{-154,177.5},{-142,177.5}},
                                            color={0,0,127}));
  connect(uWin, modSetPoi.uWin) annotation (Line(points={{-220,-160},{-150,-160},
          {-150,175.833},{-142,175.833}},
                                  color={255,0,255}));
  connect(uHeaDemLimLev, modSetPoi.uHeaDemLimLev) annotation (Line(points={{-220,
          -10},{-154,-10},{-154,160.833},{-142,160.833}},
                                                       color={255,127,0}));
  connect(uCooDemLimLev, modSetPoi.uCooDemLimLev) annotation (Line(points={{-220,20},
          {-158,20},{-158,162.5},{-142,162.5}},      color={255,127,0}));
  connect(uOccSen, modSetPoi.uOccSen) annotation (Line(points={{-220,50},{-162,
          50},{-162,164.167},{-142,164.167}},
                                      color={255,0,255}));
  connect(modSetPoi.yOpeMod, setPoiVAV.uOpeMod) annotation (Line(points={{-118,
          176.667},{-100,176.667},{-100,199},{38,199}},
                                                color={255,127,0}));
  connect(modSetPoi.TZonCooSet, setPoiVAV.TZonCooSet) annotation (Line(points={
          {-118,170},{-40,170},{-40,184},{38,184}}, color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, setPoiVAV.TZonHeaSet) annotation (Line(points={{-118,
          163.333},{-88,163.333},{-88,181},{38,181}},
                                                    color={0,0,127}));
  connect(heaSetAdj, modSetPoi.heaSetAdj) annotation (Line(points={{-220,80},{
          -166,80},{-166,165.833},{-142,165.833}},
                                           color={0,0,127}));
  connect(setAdj, modSetPoi.setAdj) annotation (Line(points={{-220,110},{-170,
          110},{-170,169.167},{-142,169.167}},
                                       color={0,0,127}));
  connect(uOccSen, outAirSetPoi.uOcc) annotation (Line(points={{-220,50},{-162,
          50},{-162,57},{38,57}}, color={255,0,255}));
  connect(outAirSetPoi.ppmCO2, ppmCO2) annotation (Line(points={{38,51},{-10,51},
          {-10,-40},{-220,-40}}, color={0,0,127}));
  connect(outAirSetPoi.VMinOA_flow, conEco.VOutMinSet_flow) annotation (Line(
        points={{62,46},{68,46},{68,-42},{138,-42}}, color={0,0,127}));

annotation (defaultComponentName="conVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,
            260}}),
        graphics={Rectangle(
        extent={{-200,-260},{200,260}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,340},{200,260}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-198,260},{-166,244}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-196,230},{-134,214}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-196,210},{-134,194}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-200,180},{-160,164}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-196,162},{-144,142}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-198,130},{-166,114}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          visible=cooAdj or sinAdj,
          extent={{-200,100},{-160,84}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="setAdj"),
        Text(
          visible=heaAdj,
          extent={{-196,78},{-140,60}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-196,52},{-144,32}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOccSen"),
        Text(
          extent={{-194,22},{-98,4}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-194,-2},{-98,-20}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          visible=have_CO2Sen,
          extent={{-196,-30},{-144,-48}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ppmCO2"),
        Text(
          extent={{-200,-60},{-162,-76}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          extent={{-200,-80},{-164,-96}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCut"),
        Text(
          visible=use_TMix,
          extent={{-202,-100},{-162,-116}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TMix"),
        Text(
          visible=have_winSen,
          extent={{-200,-128},{-158,-146}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          visible=use_enthalpy,
          extent={{-200,-180},{-160,-198}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hCut"),
        Text(
          visible=use_enthalpy,
          extent={{-198,-160},{-166,-178}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hOut"),
        Text(
          visible=use_fixed_plus_differential_drybulb,
          extent={{-196,-208},{-164,-228}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TRet"),
        Text(
          visible=use_G36FrePro,
          extent={{-198,-240},{-132,-258}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFreProSta"),
        Text(
          extent={{136,230},{196,212}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEco"),
        Text(
          extent={{148,178},{196,162}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCoo"),
        Text(
          extent={{166,128},{200,114}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yFan"),
        Text(
          extent={{134,66},{198,54}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{136,8},{194,-8}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{150,-50},{196,-66}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi"),
        Text(
          extent={{152,-110},{194,-128}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{132,-158},{194,-178}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{130,-212},{194,-226}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{200,300}})),
Documentation(info="<html>
<p>
Block for single zone VAV control. It outputs supply fan speed, supply air temperature
setpoints for heating, economizer and cooling, zone air heating and cooling setpoints,
outdoor and return air damper positions, and valve positions of heating and cooling coils.
It is implemented according to the ASHRAE Guideline 36, Section 5.18.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to Section 5.18.4. It outputs
the control signal <code>yFan</code> to adjust the speed of the supply fan.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoints</h4>
<p>
The supply air temperature setpoints control sequences are implemented based on Section 5.18.4.
They are implemented in the same control block as the supply fan speed control. The supply air temperature setpoint
for heating and economizer is the same; while the supply air temperature setpoint for cooling has
a separate control loop. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Economizer control</h4>
<p>
The Economizer control block outputs outdoor and return air damper position, i.e. <code>yOutDamPos</code> and
<code>yRetDamPos</code>, as well as control signal for heating coil <code>yHeaCoi</code>.
Optionally, there is also an override for freeze protection, which is not part of Guideline 36.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow</h4>
<p>
Control sequences are implemented to compute the minimum outdoor airflow
setpoint, which is used as an input for the economizer control. More detailed
information can be found at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints</a>.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
Zone air heating and cooling setpoints as well as system operation modes are detailed at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
