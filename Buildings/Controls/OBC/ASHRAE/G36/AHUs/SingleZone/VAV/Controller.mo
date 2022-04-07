within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV;
block Controller
  "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneSta
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venSta
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon
    "Economizer high limit control device";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (Dialog(enable=eneSta==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (Dialog(enable=eneSta==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016));

  parameter Boolean have_winSen
    "Check if the zone has window status sensor";
  parameter Boolean have_occSen
    "Check if the zone has occupancy sensor";
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil";
  parameter Boolean have_eleHeaCoi=false
    "True: the AHU has electric heating coil";
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system";
  parameter Real AFlo(unit="m2")
    "Zone floor area"
    annotation (Dialog(group="Design conditions"));
  parameter Real desZonPop "Design zone population"
    annotation (Dialog(group="Design conditions"));
  parameter Real outAirRat_area=0.0003
    "Outdoor airflow rate per unit area, m3/s/m2"
    annotation (Dialog(group="Design conditions"));
  parameter Real outAirRat_occupant=0.0025
    "Outdoor airflow rate per occupant, m3/s/p"
    annotation (Dialog(group="Design conditions"));

  // ----------- parameters for setpoint adjustment -----------
  parameter Boolean have_locAdj=true
    "True: the zone has local setpoint adjustment knob"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean sepAdj=true
    "True: cooling and heating setpoint can be adjusted separately"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings", enable=have_locAdj));
  parameter Boolean ignDemLim=true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Real TZonCooOnMax(
    unit="K",
    displayUnit="degC")=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooOnMin(
    unit="K",
    displayUnit="degC")=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMax(
    unit="K",
    displayUnit="degC")=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMin(
    unit="K",
    displayUnit="degC")=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooSetWinOpe(
    unit="K",
    displayUnit="degC")=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaSetWinOpe(
    unit="K",
    displayUnit="degC")=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real incTSetDem_1(unit="K")=0.5
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_2(unit="K")=1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_3(unit="K")=2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_1(unit="K")=0.5
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_2(unit="K")=1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_3(unit="K")=2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real preWarCooTim(unit="s")=10800
    "Maximum cool-down or warm-up time"
    annotation (Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real TZonFreProOn(
    unit="K",
    displayUnit="degC")=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real TZonFreProOff(
    unit="K",
    displayUnit="degC")=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real bouLim=1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (Dialog(tab="Setpoints adjustment", group="Hysteresis"));
  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Setpoints adjustment", group="Hysteresis"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Setpoints adjustment", group="Hysteresis"));

  // ----------- parameters for cooling and heating loop -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooLooCon=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Cooling loop controller type"
    annotation (Dialog(tab="Loops control", group="Cooling loop"));
  parameter Real kCoo(unit="1/K")=0.1
    "Gain for cooling control loop signal"
    annotation(Dialog(tab="Loops control", group="Cooling loop"));
  parameter Real TiCoo(unit="s")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation(Dialog(tab="Loops control", group="Cooling loop",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(unit="s")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (Dialog(tab="Loops control", group="Cooling loop",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaLooCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating loop controller type"
    annotation(Dialog(tab="Loops control", group="Heating loop"));
  parameter Real kHea(unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation(Dialog(tab="Loops control", group="Heating loop"));
  parameter Real TiHea(unit="s")=900
    "Time constant of integrator block for heating control loop signal"
    annotation(Dialog(tab="Loops control", group="Heating loop",
      enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(unit="s")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (Dialog(tab="Loops control", group="Heating loop",
      enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ----------- parameters for supply setpoints settings -----------
  parameter Real TSupSetMax(unit="K", displayUnit="degC")
    "Maximum supply air temperature for heating"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSupSetMin(unit="K", displayUnit="degC")
    "Minimum supply air temperature for cooling"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TDewSupMax(unit="K", displayUnit="degC")
    "Maximum supply air dew-point temperature"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TMinSupDea(
    unit="K",
    displayUnit="degC")=294.15
    "Minimum supply temperature when it is in deadband state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TMaxSupDea(
    unit="K",
    displayUnit="degC")=297.15
    "Maximum supply temperature when it is in deadband state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiOne=0.5
    "Point 1 on x-axis of control map for temperature control, when it is in heating state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiTwo=0.25
    "Point 2 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiThr=0.5
    "Point 3 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiFou=0.75
    "Point 4 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real maxHeaSpe(unit="1")
    "Maximum fan speed for heating"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real maxCooSpe(unit="1")
    "Maximum fan speed for cooling"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real minSpe(unit="1")
    "Minimum fan speed"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiOne=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiTwo=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiThr=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiFou=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real looHys=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Supply setpoints", group="Hysteresis"));

  // ----------- parameters for minimum outdoor airflow setpoints -----------
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real zonDisEff_cool=1.0
    "Zone cooling air distribution effectiveness"
    annotation (Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real zonDisEff_heat=0.8
    "Zone heating air distribution effectiveness"
    annotation (Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real VOccMin_flow=0
    "Zone minimum outdoor airflow for occupants"
    annotation (Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real VAreMin_flow=0
    "Zone minimum outdoor airflow for building area"
    annotation (Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real VZonMin_flow=0
    "Design zone minimum airflow setpoint"
    annotation (Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));

  // ----------- parameters for economizer control -----------
  parameter Real uMin(unit="1")=0.1
    "Lower limit of controller output at which the dampers are at their limits"
    annotation (Dialog(tab="Economizer"));
  parameter Real uMax(unit="1")=0.9
    "Upper limit of controller output at which the dampers are at their limits"
    annotation (Dialog(tab="Economizer"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController ecoModCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod=1 "Gain of modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  parameter Real TiMod(unit="s")=300
    "Time constant of modulation controller integrator block"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(unit="s")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yFanMin(unit="1")=0.1
    "Minimum supply fan operation speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yFanMax(unit="1")=0.9
    "Maximum supply fan operation speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutMin_flow(unit="m3/s")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutDes_flow(unit="m3/s")=2.0
    "Calculated design outdoor airflow rate"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_minSpe(unit="1")=0.4
    "Outdoor air damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutMin_maxSpe(unit="1")=0.3
    "Outdoor air damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_minSpe(unit="1")=0.9
    "Outdoor air damper position to supply design outdoor airflow at minimum fan speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real yDam_VOutDes_maxSpe(unit="1")=0.8
    "Outdoor air damper position to supply design outdoor airflow at maximum fan speed"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning"));
  parameter Real delTOutHys(
    unit="K",
    displayUnit="K")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Economizer", group="Hysteresis"));

  // ----------- parameters for cooling coil control -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Cooling coil"));
  parameter Real kCooCoi(unit="1/K")=0.1
    "Gain for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil"));
  parameter Real TiCooCoi(unit="s")=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoi(unit="s")=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ----------- parameters for freeze protection -----------
  parameter Boolean have_freSta=false
    "True: the system has a physical freeze stat"
    annotation (Dialog(tab="Freeze protection"));
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (Dialog(tab="Freeze protection"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freHeaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi));
  parameter Real kFreHea=1 "Gain of coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi));
  parameter Real TiFreHea(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control",
      enable=have_hotWatCoi and (freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                                 or freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFreHea(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control",
      enable=have_hotWatCoi and (freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                                 or freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMaxFreHea=1
    "Upper limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control", enable=have_hotWatCoi));
  parameter Real yMinFreHea=0
    "Lower limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil control", enable=have_hotWatCoi));

  // ----------- parameters for building pressure control -----------
  parameter Real minRelPos(unit="1")
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is positioned to provide minimum outdoor air while the supply fan is at minimum speed"
    annotation (Dialog(tab="Pressure control", group="Relief damper",
                       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
  parameter Real maxRelPos(unit="1")
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is fully open and the fan speed is at cooling maximum"
    annotation (Dialog(tab="Pressure control", group="Relief damper",
                       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
  parameter Real speDif=-0.1
    "Speed difference between supply and return fan to maintain building pressure at desired pressure"
    annotation (Dialog(tab="Pressure control", group="Return fan",
                       enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
                            or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));

  // ----------- Advanced -----------
  parameter Real posHys=0.05 "Hysteresis for damper position check"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real Thys(unit="K")=0.25
    "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real delEntHys(unit="J/kg")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Dialog(tab="Advanced", group="Hysteresis",
                      enable = (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                             or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)));
  parameter Real floHys=0.01
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-300,470},{-260,510}}),
        iconTransformation(extent={{-240,370},{-200,410}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-300,440},{-260,480}}),
        iconTransformation(extent={{-240,340},{-200,380}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time")
    "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-300,410},{-260,450}}),
        iconTransformation(extent={{-240,320},{-200,360}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-300,380},{-260,420}}),
        iconTransformation(extent={{-240,290},{-200,330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-300,356},{-260,396}}),
        iconTransformation(extent={{-240,270},{-200,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
        iconTransformation(extent={{-240,240},{-200,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetOcc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone occupied heating setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,300},{-260,340}}),
        iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetOcc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone occupied cooling setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetUno(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone unoccupied heating setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,260},{-260,300}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetUno(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone unoccupied cooling setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-240,160},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj
    if have_locAdj and not sepAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-300,210},{-260,250}}),
      iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooSetAdj
    if have_locAdj and sepAdj
    "Cooling setpoint adjustment value"
    annotation (Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-240,120},{-200,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj
    if have_locAdj and sepAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-300,150},{-260,190}}),
      iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
      iconTransformation(extent={{-240,70},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-300,90},{-260,130}}),
        iconTransformation(extent={{-240,40},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-300,60},{-260,100}}),
        iconTransformation(extent={{-240,20},{-200,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-300,30},{-260,70}}),
        iconTransformation(extent={{-240,-10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-300,0},{-260,40}}),
      iconTransformation(extent={{-240,-30},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
    if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-300,-60},{-260,-20}}),
        iconTransformation(extent={{-240,-90},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
     or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneSta == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016
    and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy"
    annotation (Placement(transformation(extent={{-300,-130},{-260,-90}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-300,-160},{-260,-120}}),
        iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreSta
    if have_freSta
    "Freeze protection stat signal"
    annotation (Placement(transformation(extent={{-300,-190},{-260,-150}}),
        iconTransformation(extent={{-240,-190},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreStaRes
    if have_freSta
    "Freeze protection stat reset signal"
    annotation (Placement(transformation(extent={{-300,-220},{-260,-180}}),
        iconTransformation(extent={{-240,-210},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSofSwiRes
    if not have_freSta
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-300,-250},{-260,-210}}),
        iconTransformation(extent={{-240,-230},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed"
    annotation (Placement(transformation(extent={{-300,-290},{-260,-250}}),
        iconTransformation(extent={{-240,-260},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature") if have_hotWatCoi
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-300,-320},{-260,-280}}),
        iconTransformation(extent={{-240,-290},{-200,-250}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-300,-350},{-260,-310}}),
        iconTransformation(extent={{-240,-330},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-300,-390},{-260,-350}}),
        iconTransformation(extent={{-240,-360},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-300,-430},{-260,-390}}),
        iconTransformation(extent={{-240,-390},{-200,-350}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    if have_hotWatCoi
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-300,-470},{-260,-430}}),
        iconTransformation(extent={{-240,-410},{-200,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{260,430},{300,470}}),
        iconTransformation(extent={{200,290},{240,330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{260,350},{300,390}}),
        iconTransformation(extent={{200,240},{240,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{260,290},{300,330}}),
        iconTransformation(extent={{200,200},{240,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")  "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{260,250},{300,290}}),
        iconTransformation(extent={{200,170},{240,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{260,80},{300,120}}),
        iconTransformation(extent={{200,130},{240,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{260,40},{300,80}}),
        iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{260,10},{300,50}}),
        iconTransformation(extent={{200,70},{240,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
        iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan speed"
    annotation (Placement(transformation(extent={{260,-60},{300,-20}}),
        iconTransformation(extent={{200,10},{240,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed"
    annotation (Placement(transformation(extent={{260,-100},{300,-60}}),
        iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil control signal"
    annotation (Placement(transformation(extent={{260,-170},{300,-130}}),
        iconTransformation(extent={{200,-50},{240,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    if have_hotWatCoi
    "Heating coil control signal"
    annotation (Placement(transformation(extent={{260,-200},{300,-160}}),
        iconTransformation(extent={{200,-80},{240,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla
    "Alarm level"
    annotation (Placement(transformation(extent={{260,-230},{300,-190}}),
        iconTransformation(extent={{200,-110},{240,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Relief damper position setpoint"
    annotation (Placement(transformation(extent={{260,-280},{300,-240}}),
        iconTransformation(extent={{200,-150},{240,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yExhDam
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Exhaust damper"
    annotation (Placement(transformation(extent={{260,-320},{300,-280}}),
        iconTransformation(extent={{200,-180},{240,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{260,-380},{300,-340}}),
        iconTransformation(extent={{200,-232},{240,-192}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{260,-410},{300,-370}}),
        iconTransformation(extent={{200,-260},{240,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq
    if have_hotWatCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{260,-460},{300,-420}}),
        iconTransformation(extent={{200,-290},{240,-250}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{260,-500},{300,-460}}),
        iconTransformation(extent={{200,-320},{240,-280}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply setPoiVAV(
    final TSupSetMax=TSupSetMax,
    final TSupSetMin=TSupSetMin,
    final TDewSupMax=TDewSupMax,
    final TMinSupDea=TMinSupDea,
    final TMaxSupDea=TMaxSupDea,
    final maxHeaSpe=maxHeaSpe,
    final maxCooSpe=maxCooSpe,
    final minSpe=minSpe,
    final looHys=looHys,
    final temPoiOne=temPoiOne,
    final temPoiTwo=temPoiTwo,
    final temPoiThr=temPoiThr,
    final temPoiFou=temPoiFou,
    final spePoiOne=spePoiOne,
    final spePoiTwo=spePoiTwo,
    final spePoiThr=spePoiThr,
    final spePoiFou=spePoiFou)
    "Supply air set point and fan signal for single zone VAV system"
    annotation (Placement(transformation(extent={{-20,390},{0,410}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset cooPI(
    final controllerType=cooLooCon,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-90,350},{-70,370}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset heaPI(
    final controllerType=heaLooCon,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea)
    "Zone heating control signal"
    annotation (Placement(transformation(extent={{-130,420},{-110,440}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller conEco(
    final eneSta=eneSta,
    final ecoHigLimCon=ecoHigLimCon,
    final ashCliZon=ashCliZon,
    final tit24CliZon=tit24CliZon,
    final have_heaCoi=have_hotWatCoi or have_eleHeaCoi,
    final uMin=uMin,
    final uMax=uMax,
    final controllerTypeMod=ecoModCon,
    final kMod=kMod,
    final TiMod=TiMod,
    final TdMod=TdMod,
    final delTOutHys=delTOutHys,
    final delEntHys=delEntHys,
    final floHys=floHys,
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
    annotation (Placement(transformation(extent={{60,140},{80,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    outAirSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    have_SZVAV=true,
    final permit_occStandby=permit_occStandby,
    final AFlo=AFlo,
    final desZonPop=desZonPop,
    final outAirRat_area=outAirRat_area,
    final outAirRat_occupant=outAirRat_occupant,
    final VZonMin_flow=0,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=Thys) if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta
    "Zone state"
    annotation (Placement(transformation(extent={{-20,320},{0,340}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied)
    "Unoccupied mode"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is unoccupied mode"
    annotation (Placement(transformation(extent={{-150,-70},{-130,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not switch "If in unoccupied mode, switch off"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints modSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_locAdj=have_locAdj,
    final sepAdj=sepAdj,
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
    final bouLim=bouLim,
    final uLow=uLow,
    final uHigh=uHigh,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff)
    "Output zone setpoint with operation mode selection"
    annotation (Placement(transformation(extent={{-200,360},{-180,400}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.CoolingCoil cooCoi(
    final controllerTypeCooCoi=cooCoiCon,
    final kCooCoi=kCooCoi,
    final TiCooCoi=TiCooCoi,
    final TdCooCoi=TdCooCoi)
    "Controller for cooling coil valve"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection frePro(
    final buiPreCon=buiPreCon,
    final have_hotWatCoi=have_hotWatCoi,
    final have_freSta=have_freSta,
    final minHotWatReq=minHotWatReq,
    final heaCoiCon=freHeaCoiCon,
    final k=kFreHea,
    final Ti=TiFreHea,
    final Td=TdFreHea,
    final yMax=yMaxFreHea,
    final yMin=yMinFreHea,
    final Thys=Thys)
    "Freeze protection"
    annotation (Placement(transformation(extent={{140,-150},{160,-110}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.PlantRequests plaReq(
    final have_hotWatCoi=have_hotWatCoi,
    final Thys=Thys,
    final posHys=posHys)
    "Plant request"
    annotation (Placement(transformation(extent={{60,-420},{80,-400}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper relDam(
    final minRelPos=minRelPos,
    final maxRelPos=maxRelPos,
    final posHys=posHys)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Relief damper control"
    annotation (Placement(transformation(extent={{60,-270},{80,-250}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan retFan(
    final speDif=speDif)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
       or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    annotation (Placement(transformation(extent={{60,-340},{80,-320}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{200,-490},{220,-470}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold freProMod
    if have_hotWatCoi
    "Check if it is in freeze protection mode"
    annotation (Placement(transformation(extent={{120,-470},{140,-450}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_SZVAV=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VZonMin_flow=VZonMin_flow)
    if venSta == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));

equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-202,376},{-280,
          376}}, color={0,0,127}));
  connect(conEco.TSup, TSup) annotation (Line(points={{58,164},{-54,164},{-54,-10},
          {-280,-10}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco,conEco.TSupHeaEco)  annotation (Line(points={{2,400},
          {32,400},{32,161},{58,161}},  color={0,0,127}));
  connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{2,408},{26,408},
          {26,155},{58,155}},       color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{2,400},{100,
          400},{100,450},{280,450}},      color={0,0,127}));
  connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{2,394},{100,394},
          {100,370},{280,370}},      color={0,0,127}));
  connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{-22,241},{-54,241},
          {-54,-10},{-280,-10}},
                               color={0,0,127}));
  connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-280,490},{-50,490},{-50,
          404},{-22,404}},   color={0,0,127}));
  connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{58,179},{-50,179},
          {-50,404},{-22,404}},    color={0,0,127}));
  connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{2,330},{14,330},
          {14,143},{58,143}},       color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-198,-60},{-180,-60},{-180,
          -68},{-152,-68}},        color={255,127,0}));
  connect(intEqu.y, switch.u) annotation (Line(points={{-128,-60},{-122,-60}},
          color={255,0,255}));
  connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-178,372},{
          -140,372},{-140,430},{-132,430}}, color={0,0,127}));
  connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-178,380},{
          -100,380},{-100,360},{-92,360}},color={0,0,127}));
  connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{-22,259},{-208,259},
          {-208,-40},{-280,-40}},  color={255,0,255}));
  connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-202,378},{-228,378},{
          -228,400},{-280,400}},  color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-280,340},{-252,340},{
          -252,390},{-202,390}},  color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-280,340},{-80,340},{-80,348}},
                 color={0,0,127}));
  connect(conEco.hOut, hOut) annotation (Line(points={{58,174},{38,174},{38,-80},
          {-280,-80}},        color={0,0,127}));
  connect(conEco.TRet, TRet) annotation (Line(points={{58,177},{50,177},{50,-140},
          {-280,-140}},       color={0,0,127}));
  connect(switch.y, cooCoi.uSupFan) annotation (Line(points={{-98,-60},{0,-60},{
          0,42},{58,42}},              color={255,0,255}));
  connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{2,330},{14,330},
          {14,46},{58,46}},           color={255,127,0}));
  connect(cooCoi.TSup, TSup) annotation (Line(points={{58,54},{-54,54},{-54,-10},
          {-280,-10}},      color={0,0,127}));
  connect(switch.y, conEco.uSupFan) annotation (Line(points={{-98,-60},{0,-60},{
          0,149},{58,149}},          color={255,0,255}));
  connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-108,430},{-60,430},
          {-60,401},{-22,401}},color={0,0,127}));
  connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-108,430},{-60,430},{-60,
          334},{-22,334}},color={0,0,127}));
  connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-68,360},{-40,360},
          {-40,398},{-22,398}},color={0,0,127}));
  connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-68,360},{-40,360},{-40,
          326},{-22,326}},color={0,0,127}));
  connect(switch.y, heaPI.trigger) annotation (Line(points={{-98,-60},{-86,-60},
          {-86,280},{-126,280},{-126,418}},                 color={255,0,255}));
  connect(switch.y, cooPI.trigger) annotation (Line(points={{-98,-60},{-86,-60},
          {-86,348}},       color={255,0,255}));
  connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-178,380},
          {-100,380},{-100,270},{280,270}},                 color={0,0,127}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-280,340},{-120,340},{-120,
          418}}, color={0,0,127}));
  connect(intEqu.u1, modSetPoi.yOpeMod) annotation (Line(points={{-152,-60},{-160,
          -60},{-160,388},{-178,388}},       color={255,127,0}));
  connect(setPoiVAV.TSupCoo, cooCoi.TSupCoo) annotation (Line(points={{2,394},{20,
          394},{20,58},{58,58}},         color={0,0,127}));
  connect(TZon, setPoiVAV.TZon) annotation (Line(points={{-280,340},{-120,340},{
          -120,406.4},{-22,406.4}}, color={0,0,127}));
  connect(TZon, outAirSetPoi.TZon) annotation (Line(points={{-280,340},{-120,340},
          {-120,243},{-22,243}}, color={0,0,127}));
  connect(warUpTim, modSetPoi.warUpTim) annotation (Line(points={{-280,430},{-224,
          430},{-224,396},{-202,396}},      color={0,0,127}));
  connect(uWin, modSetPoi.uWin) annotation (Line(points={{-280,-40},{-208,-40},{
          -208,393},{-202,393}},  color={255,0,255}));
  connect(uOccSen, modSetPoi.uOccSen) annotation (Line(points={{-280,140},{-220,
          140},{-220,366},{-202,366}},     color={255,0,255}));
  connect(modSetPoi.TZonCooSet, setPoiVAV.TZonCooSet) annotation (Line(points={{-178,
          380},{-100,380},{-100,394},{-22,394}},    color={0,0,127}));
  connect(modSetPoi.TZonHeaSet, setPoiVAV.TZonHeaSet) annotation (Line(points={{-178,
          372},{-140,372},{-140,391},{-22,391}},    color={0,0,127}));
  connect(heaSetAdj, modSetPoi.heaSetAdj) annotation (Line(points={{-280,170},{-224,
          170},{-224,369},{-202,369}},     color={0,0,127}));
  connect(setAdj, modSetPoi.setAdj) annotation (Line(points={{-280,230},{-232,230},
          {-232,373},{-202,373}},      color={0,0,127}));
  connect(uOccSen, outAirSetPoi.uOcc) annotation (Line(points={{-280,140},{-220,
          140},{-220,257},{-22,257}}, color={255,0,255}));
  connect(outAirSetPoi.ppmCO2, ppmCO2) annotation (Line(points={{-22,251},{-58,251},
          {-58,20},{-280,20}},   color={0,0,127}));
  connect(outAirSetPoi.VMinOA_flow, conEco.VOutMinSet_flow) annotation (Line(
        points={{2,246},{8,246},{8,158},{58,158}},   color={0,0,127}));
  connect(conEco.yOutDamPosMin, frePro.uOutDamPosMin) annotation (Line(points={{
          82,176},{118,176},{118,-111},{138,-111}}, color={0,0,127}));
  connect(conEco.yOutDamPos, frePro.uOutDamPos) annotation (Line(points={{82,154},
          {112,154},{112,-113},{138,-113}}, color={0,0,127}));
  connect(conEco.yHeaCoi, frePro.uHeaCoi) annotation (Line(points={{82,166},{106,
          166},{106,-116},{138,-116}}, color={0,0,127}));
  connect(conEco.yRetDamPos, frePro.uRetDamPos) annotation (Line(points={{82,160},
          {100,160},{100,-122},{138,-122}}, color={0,0,127}));
  connect(TSup, frePro.TSup) annotation (Line(points={{-280,-10},{-54,-10},{-54,
          -125},{138,-125}}, color={0,0,127}));
  connect(frePro.uSofSwiRes, uSofSwiRes) annotation (Line(points={{138,-134},{-26,
          -134},{-26,-230},{-280,-230}}, color={255,0,255}));
  connect(frePro.uFreStaRes, uFreStaRes) annotation (Line(points={{138,-131},{-32,
          -131},{-32,-200},{-280,-200}}, color={255,0,255}));
  connect(frePro.uFreSta, uFreSta) annotation (Line(points={{138,-128},{-72,-128},
          {-72,-170},{-280,-170}}, color={255,0,255}));
  connect(setPoiVAV.y, frePro.uSupFanSpe) annotation (Line(points={{2,408},{26,408},
          {26,-137},{138,-137}}, color={0,0,127}));
  connect(uRelFanSpe, frePro.uRelFanSpe) annotation (Line(points={{-280,-270},{-20,
          -270},{-20,-143},{138,-143}}, color={0,0,127}));
  connect(cooCoi.yCooCoi, frePro.uCooCoi) annotation (Line(points={{82,50},{94,50},
          {94,-146},{138,-146}}, color={0,0,127}));
  connect(TMix, frePro.TMix) annotation (Line(points={{-280,-300},{-14,-300},{-14,
          -149},{138,-149}}, color={0,0,127}));
  connect(frePro.yEneCHWPum, yEneCHWPum) annotation (Line(points={{162,-111},{180,
          -111},{180,100},{280,100}}, color={255,0,255}));
  connect(frePro.yRetDamPos, yRetDamPos) annotation (Line(points={{162,-115},{188,
          -115},{188,60},{280,60}},   color={0,0,127}));
  connect(frePro.yOutDamPos, yOutDamPos) annotation (Line(points={{162,-119},{196,
          -119},{196,30},{280,30}}, color={0,0,127}));
  connect(frePro.ySupFanSpe, ySupFanSpe) annotation (Line(points={{162,-127},{204,
          -127},{204,0},{280,0}},   color={0,0,127}));
  connect(switch.y, relDam.uSupFan) annotation (Line(points={{-98,-60},{0,-60},{
          0,-267},{58,-267}}, color={255,0,255}));
  connect(switch.y, retFan.uSupFan) annotation (Line(points={{-98,-60},{0,-60},{
          0,-336},{58,-336}}, color={255,0,255}));
  connect(relDam.yRelDam, yRelDamPos) annotation (Line(points={{82,-260},{280,-260}},
                                  color={0,0,127}));
  connect(retFan.yExhDam, yExhDam) annotation (Line(points={{82,-324},{132,-324},
          {132,-300},{280,-300}}, color={255,0,255}));
  connect(retFan.uSupFanSpe, uSupFanSpe) annotation (Line(points={{58,-324},{40,
          -324},{40,-370},{-280,-370}},  color={0,0,127}));
  connect(frePro.yRetFanSpe, yRetFanSpe) annotation (Line(points={{162,-131},{212,
          -131},{212,-40},{280,-40}}, color={0,0,127}));
  connect(frePro.yRelFanSpe, yRelFanSpe) annotation (Line(points={{162,-135},{220,
          -135},{220,-80},{280,-80}}, color={0,0,127}));
  connect(frePro.yCooCoi, yCooCoi) annotation (Line(points={{162,-139},{204,-139},
          {204,-150},{280,-150}}, color={0,0,127}));
  connect(frePro.yHeaCoi, yHeaCoi) annotation (Line(points={{162,-142},{196,-142},
          {196,-180},{280,-180}}, color={0,0,127}));
  connect(retFan.yRetFanSpe, frePro.uRetFanSpe) annotation (Line(points={{82,-336},
          {100,-336},{100,-140},{138,-140}}, color={0,0,127}));
  connect(frePro.yFreProSta, conEco.uFreProSta) annotation (Line(points={{162,-145},
          {180,-145},{180,-170},{8,-170},{8,141},{58,141}}, color={255,127,0}));
  connect(TSup, plaReq.TSup) annotation (Line(points={{-280,-10},{-54,-10},{-54,
          -401},{58,-401}}, color={0,0,127}));
  connect(setPoiVAV.TSupCoo, plaReq.TSupCoo) annotation (Line(points={{2,394},{20,
          394},{20,-405},{58,-405}}, color={0,0,127}));
  connect(plaReq.uCooCoi, uCooCoi) annotation (Line(points={{58,-410},{-280,-410}},
                                   color={0,0,127}));
  connect(setPoiVAV.TSupHeaEco, plaReq.TSupHeaEco) annotation (Line(points={{2,400},
          {32,400},{32,-415},{58,-415}}, color={0,0,127}));
  connect(plaReq.uHeaCoi, uHeaCoi) annotation (Line(points={{58,-419},{40,-419},
          {40,-450},{-280,-450}},  color={0,0,127}));
  connect(plaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{82,-402},
          {200,-402},{200,-360},{280,-360}}, color={255,127,0}));
  connect(plaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{82,-407},{210,
          -407},{210,-390},{280,-390}}, color={255,127,0}));
  connect(plaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{82,-413},
          {200,-413},{200,-440},{280,-440}}, color={255,127,0}));
  connect(freProMod.y, intSwi.u2) annotation (Line(points={{142,-460},{160,-460},
          {160,-480},{198,-480}}, color={255,0,255}));
  connect(plaReq.yHotWatPlaReq, intSwi.u3) annotation (Line(points={{82,-418},{100,
          -418},{100,-488},{198,-488}}, color={255,127,0}));
  connect(frePro.yFreProSta, freProMod.u) annotation (Line(points={{162,-145},{180,
          -145},{180,-170},{106,-170},{106,-460},{118,-460}}, color={255,127,0}));
  connect(frePro.yHotWatPlaReq, intSwi.u1) annotation (Line(points={{162,-147},{
          170,-147},{170,-472},{198,-472}}, color={255,127,0}));
  connect(frePro.yAla, yAla) annotation (Line(points={{162,-149},{188,-149},{188,
          -210},{280,-210}}, color={255,127,0}));
  connect(intSwi.y, yHotWatPlaReq)
    annotation (Line(points={{222,-480},{280,-480}}, color={255,127,0}));
  connect(uOutDamPos, relDam.uOutDamPos) annotation (Line(points={{-280,-330},{-8,
          -330},{-8,-260},{58,-260}},  color={0,0,127}));
  connect(conEco.yOutDamPosMin, relDam.uOutDamPosMin) annotation (Line(points={{
          82,176},{118,176},{118,-100},{40,-100},{40,-253},{58,-253}}, color={0,
          0,127}));
  connect(cooSetAdj, modSetPoi.cooSetAdj) annotation (Line(points={{-280,200},{-228,
          200},{-228,371},{-202,371}},     color={0,0,127}));
  connect(ppmCO2Set, outAirSetPoi.ppmCO2Set) annotation (Line(points={{-280,50},
          {-62,50},{-62,253},{-22,253}},  color={0,0,127}));
  connect(hRet, conEco.hRet) annotation (Line(points={{-280,-110},{44,-110},{44,
          172},{58,172}},
                     color={0,0,127}));
  connect(uWin, minFlo.uWin) annotation (Line(points={{-280,-40},{-208,-40},{-208,
          219},{-22,219}}, color={255,0,255}));
  connect(uOccSen, minFlo.uOcc) annotation (Line(points={{-280,140},{-220,140},{
          -220,216},{-22,216}}, color={255,0,255}));
  connect(ppmCO2Set, minFlo.ppmCO2Set) annotation (Line(points={{-280,50},{-62,50},
          {-62,210},{-22,210}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-280,20},{-58,20},{-58,
          207},{-22,207}}, color={0,0,127}));
  connect(cooDowTim, modSetPoi.cooDowTim) annotation (Line(points={{-280,460},{-220,
          460},{-220,398},{-202,398}}, color={0,0,127}));
  connect(uCooDemLimLev, modSetPoi.uCooDemLimLev) annotation (Line(points={{-280,
          110},{-216,110},{-216,364},{-202,364}}, color={255,127,0}));
  connect(uHeaDemLimLev, modSetPoi.uHeaDemLimLev) annotation (Line(points={{-280,80},
          {-212,80},{-212,362},{-202,362}},     color={255,127,0}));
  connect(modSetPoi.yOpeMod, setPoiVAV.uOpeMod) annotation (Line(points={{-178,388},
          {-160,388},{-160,409},{-22,409}}, color={255,127,0}));
  connect(modSetPoi.yOpeMod, outAirSetPoi.uOpeMod) annotation (Line(points={{-178,
          388},{-160,388},{-160,255},{-22,255}}, color={255,127,0}));
  connect(modSetPoi.yOpeMod, minFlo.uOpeMod) annotation (Line(points={{-178,388},
          {-160,388},{-160,213},{-22,213}}, color={255,127,0}));
  connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-178,388},
          {-160,388},{-160,145},{58,145}}, color={255,127,0}));
  connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-178,372},
          {-140,372},{-140,310},{280,310}}, color={0,0,127}));
  connect(THeaSetOcc, modSetPoi.THeaSetOcc) annotation (Line(points={{-280,320},
          {-248,320},{-248,387},{-202,387}}, color={0,0,127}));
  connect(TCooSetOcc, modSetPoi.TCooSetOcc) annotation (Line(points={{-280,300},
          {-244,300},{-244,385},{-202,385}}, color={0,0,127}));
  connect(THeaSetUno, modSetPoi.THeaSetUno) annotation (Line(points={{-280,280},
          {-240,280},{-240,383},{-202,383}}, color={0,0,127}));
  connect(TCooSetUno, modSetPoi.TCooSetUno) annotation (Line(points={{-280,260},
          {-236,260},{-236,381},{-202,381}}, color={0,0,127}));
  connect(minFlo.VMinOA_flow, conEco.VOutMinSet_flow) annotation (Line(points={{
          2,201},{8,201},{8,158},{58,158}}, color={0,0,127}));
annotation (defaultComponentName="conVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-400},{200,400}}),
        graphics={Rectangle(
        extent={{-200,-400},{200,400}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,480},{200,400}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-198,400},{-166,384}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-196,370},{-134,354}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-198,350},{-136,334}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-202,322},{-154,302}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOcc"),
        Text(
          extent={{-196,302},{-144,282}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-198,270},{-166,254}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          visible=have_locAdj and not sepAdj,
          extent={{-200,170},{-160,154}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="setAdj"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-196,130},{-140,112}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-196,102},{-144,82}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOccSen"),
        Text(
          extent={{-196,72},{-100,54}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-196,48},{-100,30}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          visible=have_CO2Sen,
          extent={{-196,0},{-144,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ppmCO2"),
        Text(
          extent={{-200,-30},{-162,-46}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSup"),
        Text(
          visible=have_hotWatCoi,
          extent={{-202,-260},{-162,-276}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TMix"),
        Text(
          visible=have_winSen,
          extent={{-200,-60},{-158,-78}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uWin"),
        Text(
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb),
          extent={{-200,-110},{-160,-128}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hRet"),
        Text(
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb),
          extent={{-198,-90},{-166,-108}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hOut"),
        Text(
          extent={{-196,-128},{-164,-148}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TRet",
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb),
        Text(
          extent={{136,320},{196,302}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEco"),
        Text(
          extent={{148,268},{196,252}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCoo"),
        Text(
          extent={{130,70},{200,54}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ySupFanSpe"),
        Text(
          extent={{126,230},{198,214}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{136,198},{194,182}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{150,-50},{196,-66}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{152,-20},{194,-38}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{128,100},{196,82}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDamPos"),
        Text(
          extent={{124,132},{196,114}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDamPos"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-196,150},{-140,132}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooSetAdj"),
        Text(
          visible=have_freSta,
          extent={{-196,-158},{-144,-178}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFreSta"),
        Text(
          visible=have_freSta,
          extent={{-196,-180},{-122,-200}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uFreStaRes"),
        Text(
          visible=not have_freSta,
          extent={{-196,-202},{-124,-224}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSofSwiRes"),
        Text(
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          extent={{142,-148},{194,-168}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDam"),
        Text(
          visible=have_occSen,
          extent={{112,162},{196,144}},
          lineColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yEneCHWPum"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          extent={{-196,-230},{-126,-252}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRelFanSpe"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
          extent={{-196,-298},{-120,-318}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPos"),
        Text(
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          extent={{-196,-328},{-122,-350}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFanSpe"),
        Text(
          extent={{-196,-356},{-142,-378}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooCoi"),
        Text(
          visible=have_hotWatCoi,
          extent={{-196,-380},{-140,-402}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaCoi"),
        Text(
          extent={{128,42},{198,26}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetFanSpe",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
        Text(
          extent={{128,10},{198,-6}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRelFanSpe",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
        Text(
          extent={{130,-120},{200,-136}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRelDamPos",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper),
        Text(
          extent={{116,-200},{198,-218}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiWatResReq"),
        Text(
          extent={{114,-228},{196,-246}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiPlaReq"),
        Text(
          extent={{116,-260},{198,-278}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatResReq",
          visible=have_hotWatCoi),
        Text(
          extent={{116,-288},{198,-306}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
        Text(
          extent={{166,-76},{194,-96}},
          lineColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yAla"),
        Text(
          visible=have_CO2Sen,
          extent={{-196,20},{-144,2}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ppmCO2Set"),
        Text(
          extent={{-200,248},{-128,232}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="THeaSetOcc"),
        Text(
          extent={{-200,228},{-128,212}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCooSetOcc"),
        Text(
          extent={{-200,188},{-128,172}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TCooSetUno"),
        Text(
          extent={{-200,208},{-128,192}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="THeaSetUno")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-500},{260,500}})),
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
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.CoolingCoil\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.CoolingCoil</a>
for more detailed description.
</p>
<h4>Freeze protection</h4>
<p>
Based on the Section 5.18.11, the sequence enables freeze protection if the
measured supply air temperature belows certain thresholds. There are three
protection stages. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection</a>
for more detailed description.
</p>
<h4>Building pressure control</h4>
<p>
By selecting different building pressure control designs, which includes using actuated
relief dampers without fans, using actuated relief dampers with relief fan, using
return fans. See belows sequences for more detailed description:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper</a>
</li>
<li> Relief fan control
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan</a> is not
included in the AHU controller. This sequence controls all the relief fans that are
serving one common space, which may include multiple air handling units.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan</a>
</li>
</ul>
<h4>Plant request</h4>
<p>
According to the Section 5.18.15, the sequence send out heating or cooling plant requests
if the supply air temperature is below or above threshold value, or the heating or
cooling valves have been widely open for certain times. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.PlantRequests</a>
for more detailed description.
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
