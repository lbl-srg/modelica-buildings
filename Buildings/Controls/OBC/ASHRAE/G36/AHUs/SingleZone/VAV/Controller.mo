within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV;
block Controller
  "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard eneStd
    "Energy standard, ASHRAE 90.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venStd
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer ecoHigLimCon=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb
    "Economizer high limit control device"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=eneStd==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24));
  parameter Boolean have_frePro=true
    "True: enable freeze protection"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat freSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
    "Type of freeze stat"
    annotation (__cdl(ValueInReference=false), Dialog(enable=have_frePro));

  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_occSen=false
    "Check if the zone has occupancy sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_hotWatCoi=true
    "True: the AHU has hot water heating coil"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_eleHeaCoi=false
    "True: the AHU has electric heating coil"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon=
    Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.BarometricRelief
    "Type of building pressure control system"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_ahuRelFan=true
    "True: relief fan is part of AHU; False: the relief fans group that may associate multiple AHUs"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real VAreBreZon_flow(unit="m3/s")=0
    "Design area component of the breathing zone outdoor airflow"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Design conditions",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VPopBreZon_flow(unit="m3/s")=0
    "Design population component of the breathing zone outdoor airflow"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Design conditions",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));

  // ----------- parameters for setpoint adjustment -----------
  parameter Boolean have_locAdj=true
    "True: the zone has local setpoint adjustment knob"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean sepAdj=true
    "True: cooling and heating setpoint can be adjusted separately"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Setpoints adjustment", group="Adjustable settings", enable=have_locAdj));
  parameter Boolean ignDemLim=true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Real TActCoo_max(
    unit="K",
    displayUnit="degC")=300.15
    "Maximum cooling setpoint during on"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActCoo_min(
    unit="K",
    displayUnit="degC")=295.15
    "Minimum cooling setpoint during on"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActHea_max(
    unit="K",
    displayUnit="degC")=295.15
    "Maximum heating setpoint during on"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TActHea_min(
    unit="K",
    displayUnit="degC")=291.15
    "Minimum heating setpoint during on"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TWinOpeCooSet(
    unit="K",
    displayUnit="degC")=322.15
    "Cooling setpoint when window is open"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TWinOpeHeaSet(
    unit="K",
    displayUnit="degC")=277.15
    "Heating setpoint when window is open"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real incTSetDem_1(unit="K")=0.5
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_2(unit="K")=1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real incTSetDem_3(unit="K")=2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_1(unit="K")=0.5
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_2(unit="K")=1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real decTSetDem_3(unit="K")=2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Demand control adjustment", enable=not ignDemLim));
  parameter Real preWarCooTim(unit="s")=10800
    "Maximum cool-down or warm-up time"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real TZonFreProOn(
    unit="K",
    displayUnit="degC")=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real TZonFreProOff(
    unit="K",
    displayUnit="degC")=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Operation mode"));
  parameter Real bouLim=1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Setpoints adjustment", group="Hysteresis"));
  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Setpoints adjustment", group="Hysteresis"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Setpoints adjustment", group="Hysteresis"));

  // ----------- parameters for cooling and heating loop -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooLooCon=
     Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Cooling loop controller type"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Cooling loop"));
  parameter Real kCoo(unit="1/K")=0.1
    "Gain for cooling control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Cooling loop"));
  parameter Real TiCoo(unit="s")=900
    "Time constant of integrator block for cooling control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Cooling loop",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCoo(unit="s")=0.1
    "Time constant of derivative block for cooling control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Cooling loop",
      enable=cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaLooCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating loop controller type"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Heating loop"));
  parameter Real kHea(unit="1/K")=0.1
    "Gain for heating control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Heating loop"));
  parameter Real TiHea(unit="s")=900
    "Time constant of integrator block for heating control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Heating loop",
      enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdHea(unit="s")=0.1
    "Time constant of derivative block for heating control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Loops control", group="Heating loop",
      enable=heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or heaLooCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ----------- parameters for supply setpoints settings -----------
  parameter Real TSup_max(
    unit="K",
    displayUnit="degC")=303.15
    "Maximum supply air temperature for heating"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSup_min(
    unit="K",
    displayUnit="degC")=291.15
    "Minimum supply air temperature for cooling"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSupDew_max(
    unit="K",
    displayUnit="degC")=290.15
    "Maximum supply air dew-point temperature. It's typically only needed in humid type “A” climates. A typical value is 17°C.
    For mild and dry climates, a high set point (e.g. 24°C) should be entered for maximum efficiency"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSupDea_min(
    unit="K",
    displayUnit="degC")=294.15
    "Minimum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real TSupDea_max(
    unit="K",
    displayUnit="degC")=297.15
    "Maximum supply temperature when it is in deadband state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiOne=0.5
    "Point 1 on x-axis of control map for temperature control, when it is in heating state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiTwo=0.25
    "Point 2 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiThr=0.5
    "Point 3 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real temPoiFou=0.75
    "Point 4 on x-axis of control map for temperature control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Temperature"));
  parameter Real maxHeaSpe(unit="1")=1
    "Maximum fan speed for heating"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real maxCooSpe(unit="1")=1
    "Maximum fan speed for cooling"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real minSpe(unit="1")=0.1
    "Minimum fan speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiOne=0.5
    "Point 1 on x-axis of control map for speed control, when it is in heating state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiTwo=0.25
    "Point 2 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiThr=0.5
    "Point 3 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real spePoiFou=0.75
    "Point 4 on x-axis of control map for speed control, when it is in cooling state"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Supply setpoints", group="Fan speed"));
  parameter Real looHys=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Supply setpoints", group="Hysteresis"));

  // ----------- parameters for minimum outdoor airflow setpoints -----------
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
                              and have_occSen));
  parameter Real zonDisEff_cool=1.0
    "Zone cooling air distribution effectiveness"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real zonDisEff_heat=0.8
    "Zone heating air distribution effectiveness"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Outdoor airflow", group="ASHRAE62.1",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VOccMin_flow=0
    "Zone minimum outdoor airflow for occupants"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Real VAreMin_flow=0
    "Zone minimum outdoor airflow for building area"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Real VZonMin_flow=0
    "Design zone minimum airflow setpoint"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Outdoor airflow", group="Title 24",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));

  // ----------- parameters for economizer control -----------
  parameter Real uMin(unit="1")=0.1
    "Lower limit of controller output at which the dampers are at their limits"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer"));
  parameter Real uMax(unit="1")=0.9
    "Upper limit of controller output at which the dampers are at their limits"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController ecoModCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer", group="Modulation"));
  parameter Real kMod=1 "Gain of modulation controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer", group="Modulation"));
  parameter Real TiMod(unit="s")=300
    "Time constant of modulation controller integrator block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdMod(unit="s")=0.1
    "Time constant of derivative block for modulation controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer", group="Modulation",
      enable=ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or ecoModCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real supFanSpe_min(unit="1")=0.1
    "Minimum supply fan operation speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Economizer", group="Commissioning"));
  parameter Real supFanSpe_max(unit="1")=0.9
    "Maximum supply fan operation speed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutMin_flow(unit="m3/s")=1.0
    "Calculated minimum outdoor airflow rate"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real VOutDes_flow(unit="m3/s")=2.0
    "Calculated design outdoor airflow rate"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamMinFloMinSpe(unit="1")=0.4
    "Outdoor air damper position to supply minimum outdoor airflow at minimum fan speed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamMinFloMaxSpe(unit="1")=0.3
    "Outdoor air damper position to supply minimum outdoor airflow at maximum fan speed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamDesFloMinSpe(unit="1")=0.9
    "Outdoor air damper position to supply design outdoor airflow at minimum fan speed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamDesFloMaxSpe(unit="1")=0.8
    "Outdoor air damper position to supply design outdoor airflow at maximum fan speed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real outDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhy_max(unit="1")=1.0
    "Physically fixed maximum position of the return air damper"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real retDamPhy_min(unit="1")=0.0
    "Physically fixed minimum position of the return air damper"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Commissioning"));
  parameter Real delTOutHys(
    unit="K",
    displayUnit="K")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Economizer", group="Hysteresis"));

  // ----------- parameters for cooling coil control -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Cooling coil"));
  parameter Real kCooCoi(unit="1/K")=0.1
    "Gain for cooling coil control loop signal"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Cooling coil"));
  parameter Real TiCooCoi(unit="s")=900
    "Time constant of integrator block for cooling coil control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdCooCoi(unit="s")=0.1
    "Time constant of derivative block for cooling coil control loop signal"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Cooling coil",
      enable=cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or cooCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // ----------- parameters for freeze protection -----------
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Freeze protection", enable=have_frePro));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freHeaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Heating coil controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi and have_frePro));
  parameter Real kFreHea=1 "Gain of coil controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi and have_frePro));
  parameter Real TiFreHea(unit="s")=0.5
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
      enable=have_hotWatCoi and have_frePro and
            (freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
             or freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdFreHea(unit="s")=0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
      enable=have_hotWatCoi and have_frePro and
             (freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or freHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yMaxFreHea=1
    "Upper limit of output"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi and have_frePro));
  parameter Real yMinFreHea=0
    "Lower limit of output"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Freeze protection", group="Heating coil control",
                       enable=have_hotWatCoi and have_frePro));

  // ----------- parameters for building pressure control -----------
  parameter Real relDam_min(unit="1")=0.1
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is positioned to provide minimum outdoor air while the supply fan is at minimum speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Pressure control", group="Relief damper",
                       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
  parameter Real relDam_max(unit="1")=1
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is fully open and the fan speed is at cooling maximum"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Pressure control", group="Relief damper",
                       enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
  parameter Real speDif=-0.1
    "Speed difference between supply and return fan to maintain building pressure at desired pressure"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Pressure control", group="Return fan",
                       enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                            or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)));
  parameter Real dpBuiSet(
    unit="Pa",
    displayUnit="Pa")=12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Pressure control",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan and have_ahuRelFan));
  parameter Real relFanSpe_min(
    final min=0,
    final max=1)= 0.1
    "Relief fan minimum speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Pressure control", group="Relief fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan and have_ahuRelFan));
  parameter Real kRelFan(unit="1")=1
    "Gain of relief fan controller, normalized using dpBuiSet"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Pressure control", group="Relief fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan and have_ahuRelFan));

  // ----------- Advanced -----------
  parameter Real posHys=0.01 "Hysteresis for damper position check"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real Thys(unit="K")=0.25
    "Hysteresis for checking temperature difference"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real delEntHys(unit="J/kg")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis",
                      enable = (ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                             or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb)));
  parameter Real floHys(unit="m3/s")=0.01*VOutMin_flow
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis"));

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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone occupied heating setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,300},{-260,340}}),
        iconTransformation(extent={{-240,220},{-200,260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOccCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone occupied cooling setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-240,200},{-200,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone unoccupied heating setpoint temperatures"
    annotation (Placement(transformation(extent={{-300,260},{-260,300}}),
        iconTransformation(extent={{-240,180},{-200,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUnoCooSet(
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OccSen if have_occSen
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-300,-30},{-260,10}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hAirRet(
    final unit="J/kg",
    final quantity="SpecificEnergy")
    if (eneStd == Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1
     and ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb)
    "Return air enthalpy"
    annotation (Placement(transformation(extent={{-300,-130},{-260,-90}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb
    "Used only for fixed plus differential dry bulb temperature high limit cutoff"
    annotation (Placement(transformation(extent={{-300,-160},{-260,-120}}),
        iconTransformation(extent={{-240,-160},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1FreSta if freSta ==
    Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS
    "Freeze protection stat signal. The stat is normally close (the input is normally true), when enabling freeze protection, the input becomes false"
    annotation (Placement(transformation(extent={{-300,-190},{-260,-150}}),
        iconTransformation(extent={{-240,-190},{-200,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SofSwiRes
    if (freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
     or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment)
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-300,-220},{-260,-180}}),
        iconTransformation(extent={{-240,-210},{-200,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if have_ahuRelFan and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Measured building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-300,-248},{-260,-208}}),
        iconTransformation(extent={{-240,-240},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and not have_ahuRelFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{-300,-270},{-260,-230}}),
        iconTransformation(extent={{-240,-260},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFan(
    final min=0,
    final max=1,
    final unit="1") if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
     and not have_ahuRelFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{-300,-300},{-260,-260}}),
      iconTransformation(extent={{-240,-280},{-200,-240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    if have_hotWatCoi
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-300,-330},{-260,-290}}),
        iconTransformation(extent={{-240,-310},{-200,-270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-300,-360},{-260,-320}}),
        iconTransformation(extent={{-240,-330},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan_actual(
    final min=0,
    final max=1,
    final unit="1")
    "Actual supply fan speed"
    annotation (Placement(transformation(extent={{-300,-390},{-260,-350}}),
        iconTransformation(extent={{-240,-360},{-200,-320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi_actual(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve actual position"
    annotation (Placement(transformation(extent={{-300,-430},{-260,-390}}),
        iconTransformation(extent={{-240,-390},{-200,-350}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi_actual(
    final min=0,
    final max=1,
    final unit="1") if have_hotWatCoi "Heating coil valve actual position"
    annotation (Placement(transformation(extent={{-300,-470},{-260,-430}}),
        iconTransformation(extent={{-240,-410},{-200,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEcoSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature setpoint for heating coil and for economizer"
    annotation (Placement(transformation(extent={{260,340},{300,380}}),
        iconTransformation(extent={{200,290},{240,330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling supply air temperature setpoint"
    annotation (Placement(transformation(extent={{260,310},{300,350}}),
        iconTransformation(extent={{200,240},{240,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{260,280},{300,320}}),
        iconTransformation(extent={{200,200},{240,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{260,250},{300,290}}),
        iconTransformation(extent={{200,170},{240,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EneCHWPum
 if have_frePro
    "Commanded on to energize chilled water pump"
    annotation (Placement(transformation(extent={{260,160},{300,200}}),
        iconTransformation(extent={{200,130},{240,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper commanded position"
    annotation (Placement(transformation(extent={{260,120},{300,160}}),
        iconTransformation(extent={{200,100},{240,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper commanded position"
    annotation (Placement(transformation(extent={{260,90},{300,130}}),
        iconTransformation(extent={{200,70},{240,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan commanded on"
    annotation (Placement(transformation(extent={{260,50},{300,90}}),
        iconTransformation(extent={{200,40},{240,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{260,20},{300,60}}),
        iconTransformation(extent={{200,20},{240,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded on"
    annotation (Placement(transformation(extent={{260,-20},{300,20}}),
        iconTransformation(extent={{200,-10},{240,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{260,-50},{300,-10}}),
        iconTransformation(extent={{200,-30},{240,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RelFan
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded on"
    annotation (Placement(transformation(extent={{260,-90},{300,-50}}),
        iconTransformation(extent={{200,-60},{240,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFan(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan commanded speed"
    annotation (Placement(transformation(extent={{260,-120},{300,-80}}),
        iconTransformation(extent={{200,-80},{240,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil valve commanded position"
    annotation (Placement(transformation(extent={{260,-170},{300,-130}}),
        iconTransformation(extent={{200,-130},{240,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1")
    if have_hotWatCoi "Heating coil valve commanded position"
    annotation (Placement(transformation(extent={{260,-200},{300,-160}}),
        iconTransformation(extent={{200,-160},{240,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yAla if have_frePro
    "Alarm level"
    annotation (Placement(transformation(extent={{260,-230},{300,-190}}),
        iconTransformation(extent={{200,-190},{240,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final min=0,
    final max=1,
    final unit="1") if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
     or (have_ahuRelFan and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan)
    "Relief damper commanded position"
    annotation (Placement(transformation(extent={{260,-290},{300,-250}}),
        iconTransformation(extent={{200,-230},{240,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ExhDam
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Exhaust damper command on"
    annotation (Placement(transformation(extent={{260,-320},{300,-280}}),
        iconTransformation(extent={{200,-260},{240,-220}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{260,-380},{300,-340}}),
        iconTransformation(extent={{200,-312},{240,-272}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{260,-410},{300,-370}}),
        iconTransformation(extent={{200,-340},{240,-300}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq
    if have_hotWatCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{260,-460},{300,-420}}),
        iconTransformation(extent={{200,-370},{240,-330}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{260,-500},{300,-460}}),
        iconTransformation(extent={{200,-400},{240,-360}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Supply setPoiVAV(
    final TSup_max=TSup_max,
    final TSup_min=TSup_min,
    final TSupDew_max=TSupDew_max,
    final TSupDea_min=TSupDea_min,
    final TSupDea_max=TSupDea_max,
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
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset cooPI(
    final controllerType=cooLooCon,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "Zone cooling control signal"
    annotation (Placement(transformation(extent={{-90,350},{-70,370}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset heaPI(
    final controllerType=heaLooCon,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea)
    "Zone heating control signal"
    annotation (Placement(transformation(extent={{-130,420},{-110,440}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Controller conEco(
    final eneStd=eneStd,
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
    final supFanSpe_min=supFanSpe_min,
    final supFanSpe_max=supFanSpe_max,
    final VOutMin_flow=VOutMin_flow,
    final VOutDes_flow=VOutDes_flow,
    final outDamMinFloMinSpe=outDamMinFloMinSpe,
    final outDamMinFloMaxSpe=outDamMinFloMaxSpe,
    final outDamDesFloMinSpe=outDamDesFloMinSpe,
    final outDamDesFloMaxSpe=outDamDesFloMaxSpe,
    final outDamPhy_max=outDamPhy_max,
    final outDamPhy_min=outDamPhy_min,
    final retDamPhy_max=retDamPhy_max,
    final retDamPhy_min=retDamPhy_min) "Economizer control sequence"
    annotation (Placement(transformation(extent={{60,140},{80,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    outAirSetPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_SZVAV=true,
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=0,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=Thys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta "Zone state"
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
    final TActCoo_max=TActCoo_max,
    final TActCoo_min=TActCoo_min,
    final TActHea_max=TActHea_max,
    final TActHea_min=TActHea_min,
    final TWinOpeCooSet=TWinOpeCooSet,
    final TWinOpeHeaSet=TWinOpeHeaSet,
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
    final TdCooCoi=TdCooCoi) "Controller for cooling coil valve"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection frePro(
    final buiPreCon=buiPreCon,
    final freSta=freSta,
    final have_hotWatCoi=have_hotWatCoi,
    final minHotWatReq=minHotWatReq,
    final heaCoiCon=freHeaCoiCon,
    final k=kFreHea,
    final Ti=TiFreHea,
    final Td=TdFreHea,
    final yMax=yMaxFreHea,
    final yMin=yMinFreHea,
    final Thys=Thys) "Freeze protection"
    annotation (Placement(transformation(extent={{140,-150},{160,-110}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.PlantRequests plaReq(
    final have_hotWatCoi=have_hotWatCoi,
    final Thys=Thys,
    final posHys=posHys) "Plant request"
    annotation (Placement(transformation(extent={{60,-420},{80,-400}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefDamper relDam(
    final relDam_min=relDam_min,
    final relDam_max=relDam_max,
    final posHys=posHys) if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    "Relief damper control"
    annotation (Placement(transformation(extent={{60,-280},{80,-260}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReturnFan retFan(
    final speDif=speDif) if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
     or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan control"
    annotation (Placement(transformation(extent={{60,-372},{80,-352}})));
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
    final VMin_flow=VZonMin_flow) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ReliefFan relFanCon(
    final relFanSpe_min=relFanSpe_min,
    final dpBuiSet=dpBuiSet,
    final k=kRelFan)
    if have_ahuRelFan and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Control of relief fan when it is part of AHU"
    annotation (Placement(transformation(extent={{60,-220},{80,-200}})));

equation
  connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-202,376},{-280,
          376}}, color={0,0,127}));
  connect(conEco.TAirSup, TAirSup) annotation (Line(points={{58,164},{-54,164},{
          -54,-10},{-280,-10}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEcoSet, conEco.TSupHeaEcoSet) annotation (Line(
        points={{2,400},{32,400},{32,161},{58,161}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEcoSet, TSupHeaEcoSet) annotation (Line(points={{2,400},
          {44,400},{44,360},{280,360}},   color={0,0,127}));
  connect(setPoiVAV.TSupCooSet, TSupCooSet) annotation (Line(points={{2,394},{38,
          394},{38,330},{280,330}},  color={0,0,127}));
  connect(outAirSetPoi.TDis, TAirSup) annotation (Line(points={{-22,241},{-54,241},
          {-54,-10},{-280,-10}}, color={0,0,127}));
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
  connect(modSetPoi.THeaSet, heaPI.u_s) annotation (Line(points={{-178,372},{-140,
          372},{-140,430},{-132,430}}, color={0,0,127}));
  connect(modSetPoi.TCooSet, cooPI.u_s) annotation (Line(points={{-178,380},{-100,
          380},{-100,360},{-92,360}}, color={0,0,127}));
  connect(outAirSetPoi.u1Win, u1Win) annotation (Line(points={{-22,259},{-208,
          259},{-208,-40},{-280,-40}}, color={255,0,255}));
  connect(modSetPoi.u1Occ, u1Occ) annotation (Line(points={{-202,378},{-228,378},
          {-228,400},{-280,400}}, color={255,0,255}));
  connect(TZon, modSetPoi.TZon) annotation (Line(points={{-280,340},{-252,340},{
          -252,390},{-202,390}},  color={0,0,127}));
  connect(TZon, cooPI.u_m) annotation (Line(points={{-280,340},{-80,340},{-80,348}},
                 color={0,0,127}));
  connect(conEco.hOut, hOut) annotation (Line(points={{58,174},{38,174},{38,-80},
          {-280,-80}},        color={0,0,127}));
  connect(conEco.TAirRet, TAirRet) annotation (Line(points={{58,177},{50,177},{50,
          -140},{-280,-140}}, color={0,0,127}));
  connect(switch.y, cooCoi.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,42},{58,42}}, color={255,0,255}));
  connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{2,330},{14,330},
          {14,46},{58,46}},           color={255,127,0}));
  connect(cooCoi.TAirSup, TAirSup) annotation (Line(points={{58,54},{-54,54},{-54,
          -10},{-280,-10}}, color={0,0,127}));
  connect(switch.y, conEco.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,149},{58,149}}, color={255,0,255}));
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
  connect(modSetPoi.TCooSet, TZonCooSet) annotation (Line(points={{-178,380},{-100,
          380},{-100,270},{280,270}}, color={0,0,127}));
  connect(TZon, heaPI.u_m) annotation (Line(points={{-280,340},{-120,340},{-120,
          418}}, color={0,0,127}));
  connect(intEqu.u1, modSetPoi.yOpeMod) annotation (Line(points={{-152,-60},{-160,
          -60},{-160,388},{-178,388}},       color={255,127,0}));
  connect(setPoiVAV.TSupCooSet, cooCoi.TSupCooSet) annotation (Line(points={{2,394},
          {20,394},{20,58},{58,58}}, color={0,0,127}));
  connect(TZon, setPoiVAV.TZon) annotation (Line(points={{-280,340},{-120,340},{
          -120,406.4},{-22,406.4}}, color={0,0,127}));
  connect(TZon, outAirSetPoi.TZon) annotation (Line(points={{-280,340},{-120,340},
          {-120,243},{-22,243}}, color={0,0,127}));
  connect(warUpTim, modSetPoi.warUpTim) annotation (Line(points={{-280,430},{-224,
          430},{-224,396},{-202,396}},      color={0,0,127}));
  connect(u1Win, modSetPoi.u1Win) annotation (Line(points={{-280,-40},{-208,-40},
          {-208,393},{-202,393}}, color={255,0,255}));
  connect(u1OccSen, modSetPoi.u1OccSen) annotation (Line(points={{-280,140},{-220,
          140},{-220,366},{-202,366}}, color={255,0,255}));
  connect(modSetPoi.TCooSet, setPoiVAV.TCooSet) annotation (Line(points={{-178,380},
          {-100,380},{-100,394},{-22,394}}, color={0,0,127}));
  connect(modSetPoi.THeaSet, setPoiVAV.THeaSet) annotation (Line(points={{-178,372},
          {-140,372},{-140,391},{-22,391}}, color={0,0,127}));
  connect(heaSetAdj, modSetPoi.heaSetAdj) annotation (Line(points={{-280,170},{-224,
          170},{-224,369},{-202,369}},     color={0,0,127}));
  connect(setAdj, modSetPoi.setAdj) annotation (Line(points={{-280,230},{-232,230},
          {-232,373},{-202,373}},      color={0,0,127}));
  connect(u1OccSen, outAirSetPoi.u1Occ) annotation (Line(points={{-280,140},{-220,
          140},{-220,257},{-22,257}}, color={255,0,255}));
  connect(outAirSetPoi.ppmCO2, ppmCO2) annotation (Line(points={{-22,251},{-58,251},
          {-58,20},{-280,20}},   color={0,0,127}));
  connect(outAirSetPoi.VMinOA_flow, conEco.VOutMinSet_flow) annotation (Line(
        points={{2,246},{8,246},{8,158},{58,158}},   color={0,0,127}));
  connect(conEco.yOutDam_min, frePro.uOutDamPosMin) annotation (Line(points={{82,
          176},{118,176},{118,-111},{138,-111}}, color={0,0,127}));
  connect(conEco.yOutDam, frePro.uOutDam) annotation (Line(points={{82,154},{112,
          154},{112,-113},{138,-113}}, color={0,0,127}));
  connect(conEco.yHeaCoi, frePro.uHeaCoi) annotation (Line(points={{82,166},{106,
          166},{106,-116},{138,-116}}, color={0,0,127}));
  connect(conEco.yRetDam, frePro.uRetDam) annotation (Line(points={{82,160},{100,
          160},{100,-119},{138,-119}}, color={0,0,127}));
  connect(TAirSup, frePro.TAirSup) annotation (Line(points={{-280,-10},{-54,-10},
          {-54,-122},{138,-122}}, color={0,0,127}));
  connect(frePro.u1SofSwiRes, u1SofSwiRes) annotation (Line(points={{138,-128},{
          -26,-128},{-26,-200},{-280,-200}}, color={255,0,255}));
  connect(frePro.u1FreSta, u1FreSta) annotation (Line(points={{138,-125},{-72,-125},
          {-72,-170},{-280,-170}}, color={255,0,255}));
  connect(setPoiVAV.y, frePro.uSupFan) annotation (Line(points={{2,408},{26,408},
          {26,-133},{138,-133}}, color={0,0,127}));
  connect(uRelFan, frePro.uRelFan) annotation (Line(points={{-280,-280},{-20,-280},
          {-20,-143},{138,-143}}, color={0,0,127}));
  connect(cooCoi.yCooCoi, frePro.uCooCoi) annotation (Line(points={{82,50},{94,50},
          {94,-146},{138,-146}}, color={0,0,127}));
  connect(TAirMix, frePro.TAirMix) annotation (Line(points={{-280,-310},{-14,-310},
          {-14,-149},{138,-149}}, color={0,0,127}));
  connect(frePro.y1EneCHWPum, y1EneCHWPum) annotation (Line(points={{162,-111},{
          176,-111},{176,180},{280,180}}, color={255,0,255}));
  connect(frePro.yRetDam, yRetDam) annotation (Line(points={{162,-115},{184,-115},
          {184,140},{280,140}}, color={0,0,127}));
  connect(frePro.yOutDam, yOutDam) annotation (Line(points={{162,-119},{192,-119},
          {192,110},{280,110}}, color={0,0,127}));
  connect(frePro.ySupFan, ySupFan) annotation (Line(points={{162,-125.2},{208,-125.2},
          {208,40},{280,40}}, color={0,0,127}));
  connect(switch.y, relDam.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,-277},{58,-277}}, color={255,0,255}));
  connect(switch.y, retFan.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,-368},{58,-368}}, color={255,0,255}));
  connect(relDam.yRelDam, yRelDam)
    annotation (Line(points={{82,-270},{280,-270}}, color={0,0,127}));
  connect(retFan.y1ExhDam, y1ExhDam) annotation (Line(points={{82,-356},{132,-356},
          {132,-300},{280,-300}}, color={255,0,255}));
  connect(retFan.uSupFan_actual, uSupFan_actual) annotation (Line(points={{58,-356},
          {-50,-356},{-50,-370},{-280,-370}}, color={0,0,127}));
  connect(frePro.yRetFan, yRetFan) annotation (Line(points={{162,-130},{224,-130},
          {224,-30},{280,-30}}, color={0,0,127}));
  connect(frePro.yRelFan, yRelFan) annotation (Line(points={{162,-135},{240,-135},
          {240,-100},{280,-100}}, color={0,0,127}));
  connect(frePro.yCooCoi, yCooCoi) annotation (Line(points={{162,-139},{204,-139},
          {204,-150},{280,-150}}, color={0,0,127}));
  connect(frePro.yHeaCoi, yHeaCoi) annotation (Line(points={{162,-142},{196,-142},
          {196,-180},{280,-180}}, color={0,0,127}));
  connect(retFan.yRetFan, frePro.uRetFan) annotation (Line(points={{82,-362},{100,
          -362},{100,-138},{138,-138}}, color={0,0,127}));
  connect(frePro.yFreProSta, conEco.uFreProSta) annotation (Line(points={{162,-145},
          {180,-145},{180,-170},{8,-170},{8,141},{58,141}}, color={255,127,0}));
  connect(TAirSup, plaReq.TAirSup) annotation (Line(points={{-280,-10},{-54,-10},
          {-54,-401},{58,-401}}, color={0,0,127}));
  connect(setPoiVAV.TSupCooSet, plaReq.TSupCoo) annotation (Line(points={{2,394},
          {20,394},{20,-405},{58,-405}}, color={0,0,127}));
  connect(plaReq.uCooCoi_actual, uCooCoi_actual)
    annotation (Line(points={{58,-410},{-280,-410}}, color={0,0,127}));
  connect(setPoiVAV.TSupHeaEcoSet, plaReq.TSupHeaEco) annotation (Line(points={{
          2,400},{32,400},{32,-415},{58,-415}}, color={0,0,127}));
  connect(plaReq.uHeaCoi_actual, uHeaCoi_actual) annotation (Line(points={{58,-419},
          {40,-419},{40,-450},{-280,-450}}, color={0,0,127}));
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
  connect(uOutDam, relDam.uOutDam) annotation (Line(points={{-280,-340},{-8,-340},
          {-8,-270},{58,-270}}, color={0,0,127}));
  connect(conEco.yOutDam_min, relDam.uOutDam_min) annotation (Line(points={{82,176},
          {118,176},{118,-100},{40,-100},{40,-263},{58,-263}}, color={0,0,127}));
  connect(cooSetAdj, modSetPoi.cooSetAdj) annotation (Line(points={{-280,200},{-228,
          200},{-228,371},{-202,371}},     color={0,0,127}));
  connect(ppmCO2Set, outAirSetPoi.ppmCO2Set) annotation (Line(points={{-280,50},
          {-62,50},{-62,253},{-22,253}},  color={0,0,127}));
  connect(hAirRet, conEco.hAirRet) annotation (Line(points={{-280,-110},{44,-110},
          {44,172},{58,172}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-280,-40},{-208,-40},{
          -208,219},{-22,219}}, color={255,0,255}));
  connect(u1OccSen, minFlo.u1Occ) annotation (Line(points={{-280,140},{-220,140},
          {-220,216},{-22,216}}, color={255,0,255}));
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
  connect(modSetPoi.THeaSet, TZonHeaSet) annotation (Line(points={{-178,372},{-140,
          372},{-140,300},{280,300}}, color={0,0,127}));
  connect(TOccHeaSet,modSetPoi.TOccHeaSet)  annotation (Line(points={{-280,320},
          {-248,320},{-248,387},{-202,387}}, color={0,0,127}));
  connect(TOccCooSet,modSetPoi.TOccCooSet)  annotation (Line(points={{-280,300},
          {-244,300},{-244,385},{-202,385}}, color={0,0,127}));
  connect(TUnoHeaSet,modSetPoi.TUnoHeaSet)  annotation (Line(points={{-280,280},
          {-240,280},{-240,383},{-202,383}}, color={0,0,127}));
  connect(TUnoCooSet,modSetPoi.TUnoCooSet)  annotation (Line(points={{-280,260},
          {-236,260},{-236,381},{-202,381}}, color={0,0,127}));
  connect(minFlo.VMinOA_flow, conEco.VOutMinSet_flow) annotation (Line(points={{
          2,201},{8,201},{8,158},{58,158}}, color={0,0,127}));
  connect(uSupFan_actual, conEco.uSupFan_actual) annotation (Line(points={{-280,
          -370},{-50,-370},{-50,155},{58,155}}, color={0,0,127}));
  connect(switch.y, frePro.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,-131},{138,-131}}, color={255,0,255}));
  connect(retFan.y1RetFan, frePro.u1RetFan) annotation (Line(points={{82,-368},{
          112,-368},{112,-136},{138,-136}}, color={255,0,255}));
  connect(u1RelFan, frePro.u1RelFan) annotation (Line(points={{-280,-250},{118,-250},
          {118,-141},{138,-141}}, color={255,0,255}));
  connect(frePro.y1RetFan, y1RetFan) annotation (Line(points={{162,-128},{216,
          -128},{216,0},{280,0}}, color={255,0,255}));
  connect(frePro.y1RelFan, y1RelFan) annotation (Line(points={{162,-133},{232,
          -133},{232,-70},{280,-70}}, color={255,0,255}));
  connect(frePro.y1SupFan, y1SupFan) annotation (Line(points={{162,-123.2},{200,
          -123.2},{200,70},{280,70}}, color={255,0,255}));
  connect(relFanCon.y1RelFan, frePro.u1RelFan) annotation (Line(points={{82,-218},
          {118,-218},{118,-141},{138,-141}}, color={255,0,255}));
  connect(relFanCon.yRelFan, frePro.uRelFan) annotation (Line(points={{82,-213},
          {88,-213},{88,-143},{138,-143}}, color={0,0,127}));
  connect(switch.y, relFanCon.u1SupFan) annotation (Line(points={{-98,-60},{0,-60},
          {0,-213},{58,-213}}, color={255,0,255}));
  connect(dpBui, relFanCon.dpBui) annotation (Line(points={{-280,-228},{12,-228},
          {12,-207},{58,-207}}, color={0,0,127}));
  connect(relFanCon.yDam, yRelDam) annotation (Line(points={{82,-207},{122,-207},
          {122,-270},{280,-270}}, color={0,0,127}));
    annotation (Dialog(enable=have_frePro),
            defaultComponentName="conVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-400},{200,400}}),
        graphics={Rectangle(
        extent={{-200,-400},{200,400}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,480},{200,400}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-198,400},{-166,384}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOut"),
        Text(
          extent={{-196,370},{-134,354}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooDowTim"),
        Text(
          extent={{-198,350},{-136,334}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="warUpTim"),
        Text(
          extent={{-200,322},{-152,302}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Occ"),
        Text(
          extent={{-196,302},{-144,282}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="tNexOcc"),
        Text(
          extent={{-198,270},{-166,254}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZon"),
        Text(
          visible=have_locAdj and not sepAdj,
          extent={{-200,170},{-160,154}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="setAdj"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-196,130},{-140,112}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-196,102},{-144,82}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1OccSen"),
        Text(
          extent={{-196,72},{-100,54}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooDemLimLev"),
        Text(
          extent={{-196,48},{-100,30}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaDemLimLev"),
        Text(
          visible=have_CO2Sen,
          extent={{-196,0},{-144,-18}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ppmCO2"),
        Text(
          extent={{-196,-30},{-158,-46}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirSup"),
        Text(
          visible=have_hotWatCoi,
          extent={{-202,-280},{-146,-300}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirMix"),
        Text(
          visible=have_winSen,
          extent={{-200,-60},{-158,-78}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Win"),
        Text(
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb),
          extent={{-194,-110},{-154,-128}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hAirRet"),
        Text(
          visible=(ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb
                or ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb),
          extent={{-198,-90},{-166,-108}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="hOut"),
        Text(
          extent={{-196,-128},{-164,-148}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=ecoHigLimCon == Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb,
          textString="TAirRet"),
        Text(
          extent={{110,322},{196,302}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupHeaEcoSet"),
        Text(
          extent={{118,272},{196,252}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupCooSet"),
        Text(
          extent={{130,50},{200,34}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ySupFan"),
        Text(
          extent={{126,230},{198,214}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet"),
        Text(
          extent={{136,198},{194,182}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet"),
        Text(
          extent={{150,-130},{196,-146}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi",
          visible=have_hotWatCoi),
        Text(
          extent={{152,-100},{194,-118}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi"),
        Text(
          extent={{128,100},{196,82}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yOutDam"),
        Text(
          extent={{124,132},{196,114}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetDam"),
        Text(
          visible=have_locAdj and sepAdj,
          extent={{-196,150},{-140,132}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="cooSetAdj"),
        Text(
          visible=freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS,
          extent={{-198,-158},{-146,-178}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1FreSta"),
        Text(
          visible=(freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat
               or freSta == Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment),
          extent={{-196,-180},{-124,-202}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1SofSwiRes"),
        Text(
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
                or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          extent={{142,-228},{194,-248}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1ExhDam"),
        Text(
          visible=have_occSen,
          extent={{112,162},{196,144}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1EneCHWPum"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and not have_ahuRelFan,
          extent={{-198,-250},{-134,-272}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uRelFan"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper,
          extent={{-196,-298},{-130,-320}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDam"),
        Text(
          extent={{-194,-326},{-66,-356}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan_actual"),
        Text(
          extent={{-196,-354},{-94,-376}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCooCoi_actual"),
        Text(
          visible=have_hotWatCoi,
          extent={{-196,-378},{-90,-400}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHeaCoi_actual"),
        Text(
          extent={{130,-2},{200,-18}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="yRetFan"),
        Text(
          extent={{128,-50},{198,-66}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yRelFan"),
        Text(
          extent={{130,-200},{200,-216}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
               or (have_ahuRelFan and buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
          textString="yRelDam"),
        Text(
          extent={{116,-280},{198,-298}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiWatResReq"),
        Text(
          extent={{114,-308},{196,-326}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yChiPlaReq"),
        Text(
          extent={{116,-340},{198,-358}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatResReq",
          visible=have_hotWatCoi),
        Text(
          extent={{116,-368},{198,-386}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
        Text(
          extent={{166,-156},{194,-176}},
          textColor={255,127,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yAla"),
        Text(
          visible=have_CO2Sen,
          extent={{-196,20},{-144,2}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="ppmCO2Set"),
        Text(
          extent={{-200,248},{-128,232}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOccHeaSet"),
        Text(
          extent={{-200,228},{-128,212}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TOccCooSet"),
        Text(
          extent={{-200,188},{-128,172}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TUnoCooSet"),
        Text(
          extent={{-200,208},{-128,192}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TUnoHeaSet"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and not have_ahuRelFan,
          extent={{-196,-228},{-144,-248}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1RelFan"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          extent={{144,-30},{196,-50}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1RelFan"),
        Text(
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanMeasuredAir
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          extent={{144,22},{196,2}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1RetFan"),
        Text(
          extent={{144,72},{196,52}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1SupFan"),
        Text(
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               and not have_ahuRelFan,
          extent={{-198,-206},{-134,-228}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="dpBui")}),
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
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
