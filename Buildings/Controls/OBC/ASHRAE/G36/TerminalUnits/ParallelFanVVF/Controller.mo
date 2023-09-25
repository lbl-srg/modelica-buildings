within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF;
block Controller
  "Controller for variable-volume parallel fan-powered terminal unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venStd
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Boolean have_winSen=true
    "True: the zone has window sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_occSen=true
    "True: the zone has occupancy sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor"
    annotation (__cdl(ValueInReference=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (__cdl(ValueInReference=false));
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (__cdl(ValueInReference=false),
                Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
                              and have_occSen));
  parameter Real VOccMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for occupants"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  parameter Real VAreMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for building area"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24));
  // ---------------- Design parameters ----------------
  parameter Real VAreBreZon_flow(unit="m3/s")
    "Design area component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions",
                      enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VPopBreZon_flow(unit="m3/s")
    "Design population component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions",
                      enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real VMin_flow(unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation (Dialog(group="Design conditions"));
  parameter Real VCooMax_flow(unit="m3/s")
    "Design zone cooling maximum airflow rate"
    annotation (Dialog(group="Design conditions"));
  // ---------------- Control loop parameters ----------------
  parameter Real kCooCon=0.1
    "Gain of controller for cooling control loop"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Control loops", group="Cooling"));
  parameter Real TiCooCon(unit="s")=900
    "Time constant of integrator block for cooling control loop"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Control loops", group="Cooling"));
  parameter Real kHeaCon=0.1
    "Gain of controller for heating control loop"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Control loops", group="Heating"));
  parameter Real TiHeaCon(unit="s")=900
    "Time constant of integrator block for heating control loop"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Control loops", group="Heating"));
  // ---------------- Damper and valve control parameters ----------------
  parameter Real dTDisZonSetMax(unit="K")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Damper and valve control"));
  parameter Real minRat(unit="m3/s")
    "Lowest parallel fan rate when it receives the lowest signal from BAS"
    annotation (Dialog(tab="Damper and valve control"));
  parameter Real maxRat(unit="m3/s")
    "Maximum heating-fan airflow setpoint"
    annotation (Dialog(tab="Damper and valve control"));
  parameter CDL.Types.SimpleController controllerTypeVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real kVal=0.5
    "Gain of controller for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real TiVal(unit="s")=300
    "Time constant of integrator block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Damper"));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Damper"));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Damper",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Damper and valve control", group="Damper",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  // ---------------- System request parameters ----------------
  parameter Real thrTemDif(unit="K")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests"));
  parameter Real twoTemDif(unit="K")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests"));
  parameter Real thrTDis_1(unit="K")=17
    "Threshold difference between discharge air temperature and its setpoint for generating 3 hot water reset requests"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests",
                enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real thrTDis_2(unit="K")=8.3
    "Threshold difference between discharge air temperature and its setpoint for generating 2 hot water reset requests"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="System requests", enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real durTimTem(unit="s")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimFlo(unit="s")=60
    "Duration time of airflow rate less than setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimDisAir(unit="s")=300
    "Duration time of discharge air temperature less than setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="System requests", group="Duration time",
                       enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  // ---------------- Parameters for alarms ----------------
  parameter Real staPreMul=1
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Alarms"));
  parameter Real hotWatRes=1
    "Importance multiplier for the hot water reset control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Alarms",
                enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real lowFloTim(unit="s")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real lowTemTim(unit="s")=600
    "Threshold time to check low discharge temperature"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms",
                enable=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased));
  parameter Real comChaTim(unit="s")=15
    "Threshold time after fan command change"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real fanOffTim(unit="s")=600
    "Threshold time to check fan off"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real leaFloTim(unit="s")=600
    "Threshold time to check damper leaking airflow"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real valCloTim(unit="s")=900
    "Threshold time to check valve leaking water flow"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  // ---------------- Parameters for time-based suppression ----------------
  parameter Real samplePeriod(unit="s")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Time-based suppresion"));
  parameter Real chaRat=540
    "Gain factor to calculate suppression time based on the change of the setpoint, second per degC"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Time-based suppresion"));
  parameter Real maxSupTim(unit="s")=1800
    "Maximum suppression time"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Time-based suppresion"));
  // ---------------- Advanced parameters ----------------
  parameter Real dTHys(unit="K")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real floHys(unit="m3/s")=0.01*VMin_flow
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real damPosHys(unit="1")=0.005
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real valPosHys(unit="1")=0.005
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real staTim(
    final unit="s",
    final quantity="Time")=1800
    "Delay triggering alarms after enabling AHU supply fan"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real timChe(unit="s")=30
    "Threshold time to check the zone temperature status"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Advanced", group="Control loops"));
  parameter Real zonDisEff_cool(unit="1")=1.0
    "Zone cooling air distribution effectiveness"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real zonDisEff_heat(unit="1")=0.8
    "Zone heating air distribution effectiveness"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-280,300},{-240,340}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-280,270},{-240,310}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-280,230},{-240,270}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-280,200},{-240,240}}),
        iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-280,170},{-240,210}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VParFan_flow(
    final unit="m3/s",
    final min=0,
    final quantity="VolumeFlowRate") if have_CO2Sen
    "Parallel fan airflow rate"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-10},{-240,30}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-280,-40},{-240,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-280,-70},{-240,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-280,-100},{-240,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFan
    "Index of overriding terminal fan status, 1: turn fan off; 2: turn fan on"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-280,-190},{-240,-150}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,-290},{-240,-250}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1TerFan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-280,-320},{-240,-280}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-280,-350},{-240,-310}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{240,310},{280,350}}),
        iconTransformation(extent={{100,180},{140,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final unit="1") "Damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{240,280},{280,320}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final unit="1") "Heating valve commanded position"
    annotation (Placement(transformation(extent={{240,250},{280,290}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VFan_flow_Set(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Paralle fan flow rate setpoint"
    annotation (Placement(transformation(extent={{240,220},{280,260}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on status"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,140},{280,180}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,110},{280,150}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,80},{280,120}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,50},{280,90}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,20},{280,60}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1")
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{240,-10},{280,30}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,-60},{280,-20}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{240,-90},{280,-50}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{240,-120},{280,-80}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{240,-150},{280,-110}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,-190},{280,-150}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-220},{280,-180}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFanStaAla
    "Terminal fan status alarm"
    annotation (Placement(transformation(extent={{240,-250},{280,-210}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-280},{280,-240}}),
        iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{240,-310},{280,-270}}),
        iconTransformation(extent={{100,-200},{140,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-340},{280,-300}}),
        iconTransformation(extent={{100,-220},{140,-180}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.ActiveAirFlow
    actAirSet(
    final VCooMax_flow=VCooMax_flow) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.SystemRequests
    sysReq(
    final heaCoi=heaCoi,
    final thrTemDif=thrTemDif,
    final twoTemDif=twoTemDif,
    final thrTDis_1=thrTDis_1,
    final thrTDis_2=thrTDis_2,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final durTimDisAir=durTimDisAir,
    final dTHys=dTHys,
    final floHys=floHys,
    final looHys=looHys,
    final damPosHys=damPosHys,
    final valPosHys=valPosHys,
    final samplePeriod=samplePeriod) "Specify system requests "
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    final kCooCon=kCooCon,
    final TiCooCon=TiCooCon,
    final kHeaCon=kHeaCon,
    final TiHeaCon=TiHeaCon,
    final timChe=timChe,
    final dTHys=dTHys,
    final looHys=looHys) "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms
    ala(
    final heaCoi=heaCoi,
    final staPreMul=staPreMul,
    final hotWatRes=hotWatRes,
    final VCooMax_flow=VCooMax_flow,
    final lowFloTim=lowFloTim,
    final lowTemTim=lowTemTim,
    final comChaTim=comChaTim,
    final fanOffTim=fanOffTim,
    final leaFloTim=leaFloTim,
    final valCloTim=valCloTim,
    final floHys=floHys,
    final dTHys=dTHys,
    final damPosHys=damPosHys,
    final valPosHys=valPosHys,
    final staTim=staTim)       "Generate alarms"
    annotation (Placement(transformation(extent={{160,-260},{180,-240}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Overrides
    setOve "Override setpoints"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSup(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-200,290},{-180,310}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=false,
    final have_parFanPowUni=true,
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves damVal(
    final dTDisZonSetMax=dTDisZonSetMax,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final minRat=minRat,
    final maxRat=maxRat,
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTHys=dTHys,
    final looHys=looHys,
    final floHys=floHys,
    final iniDam=iniDam) "Damper and valve control"
    annotation (Placement(transformation(extent={{20,0},{40,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta(
    final uLow=looHys,
    final uHigh=2*looHys) if have_CO2Sen
    "Find if the zone is in heating, cooling, or deadband states"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1
    "Paralle fan airflow setpoint"
    annotation (Placement(transformation(extent={{200,230},{220,250}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_parFanPowUni=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
equation
  connect(TZon, timSup.TZon) annotation (Line(points={{-260,320},{-222,320},{-222,
          296},{-202,296}}, color={0,0,127}));
  connect(TCooSet, timSup.TSet) annotation (Line(points={{-260,290},{-228,290},
          {-228,304},{-202,304}}, color={0,0,127}));
  connect(TCooSet, conLoo.TCooSet) annotation (Line(points={{-260,290},{-228,
          290},{-228,266},{-202,266}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-260,320},{-222,320},{-222,
          260},{-202,260}}, color={0,0,127}));
  connect(THeaSet, conLoo.THeaSet) annotation (Line(points={{-260,250},{-216,
          250},{-216,254},{-202,254}}, color={0,0,127}));
  connect(u1Win, setPoi.u1Win) annotation (Line(points={{-260,220},{-186,220},{
          -186,179},{-102,179}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-260,190},{-192,190},{
          -192,177},{-102,177}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,175},{-102,175}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-260,100},{-198,100},
          {-198,171},{-102,171}},  color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-260,320},{-222,320},{-222,
          163},{-102,163}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-260,40},{-180,40},{-180,
          161},{-102,161}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-260,160},{-210,
          160},{-210,106},{-42,106}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,174},{-56,174},{-56,94},{-42,94}},   color={0,0,127}));
  connect(VPri_flow,damVal.VPri_flow)  annotation (Line(points={{-260,10},{-36,10},
          {-36,36},{18,36}}, color={0,0,127}));
  connect(conLoo.yCoo, damVal.uCoo) annotation (Line(points={{-178,266},{-154,266},
          {-154,33},{18,33}},color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow) annotation (Line(
        points={{-18,106},{0,106},{0,30},{18,30}},     color={0,0,127}));
  connect(TSup, damVal.TSup) annotation (Line(points={{-260,-20},{-30,-20},{-30,
          27},{18,27}},   color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow) annotation (Line(points={{-18,94},
          {-6,94},{-6,21},{18,21}},              color={0,0,127}));
  connect(TDis, damVal.TDis) annotation (Line(points={{-260,40},{-180,40},{-180,
          9},{18,9}},     color={0,0,127}));
  connect(TSupSet, damVal.TSupSet) annotation (Line(points={{-260,-50},{-24,-50},
          {-24,17},{18,17}},   color={0,0,127}));
  connect(THeaSet, damVal.THeaSet) annotation (Line(points={{-260,250},{-216,
          250},{-216,15},{18,15}},   color={0,0,127}));
  connect(conLoo.yHea, damVal.uHea) annotation (Line(points={{-178,254},{-160,254},
          {-160,12},{18,12}},   color={0,0,127}));
  connect(TZon, damVal.TZon) annotation (Line(points={{-260,320},{-222,320},{-222,
          24},{18,24}},   color={0,0,127}));
  connect(uOpeMod, damVal.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,1},{18,1}},     color={255,127,0}));
  connect(oveDamPos, setOve.oveDamPos) annotation (Line(points={{-260,-110},{-94,
          -110},{-94,-61},{78,-61}},color={255,127,0}));
  connect(damVal.yDam, setOve.uDam) annotation (Line(points={{42,29},{66,29},{66,
          -63},{78,-63}}, color={0,0,127}));
  connect(uHeaOff, setOve.uHeaOff) annotation (Line(points={{-260,-170},{12,-170},
          {12,-69},{78,-69}},     color={255,0,255}));
  connect(damVal.yVal, setOve.uVal) annotation (Line(points={{42,8},{62,8},{62,-71},
          {78,-71}},   color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-178,300},{
          -68,300},{-68,-141},{158,-141}},
                                       color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-260,290},{-228,
          290},{-228,-143},{158,-143}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-260,320},{-222,320},{
          -222,-145},{158,-145}},
                             color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-178,266},{-154,
          266},{-154,-147},{158,-147}},
                                  color={0,0,127}));
  connect(VPri_flow,sysReq.VPri_flow)  annotation (Line(points={{-260,10},{-36,
          10},{-36,-151},{158,-151}},
                                  color={0,0,127}));
  connect(TDis, sysReq.TDis) annotation (Line(points={{-260,40},{-180,40},{-180,
          -157},{158,-157}}, color={0,0,127}));
  connect(VPri_flow,ala.VPri_flow)  annotation (Line(points={{-260,10},{-36,10},
          {-36,-239},{158,-239}}, color={0,0,127}));
  connect(u1Fan, ala.u1Fan) annotation (Line(points={{-260,-270},{0,-270},{0,
          -243},{158,-243}},
                       color={255,0,255}));
  connect(TSup, ala.TSup) annotation (Line(points={{-260,-20},{-30,-20},{-30,
          -255},{158,-255}},
                       color={0,0,127}));
  connect(u1HotPla, ala.u1HotPla) annotation (Line(points={{-260,-330},{40,-330},
          {40,-257},{158,-257}}, color={255,0,255}));
  connect(TDis, ala.TDis) annotation (Line(points={{-260,40},{-180,40},{-180,
          -259},{158,-259}},
                       color={0,0,127}));
  connect(setOve.yDam, yDam) annotation (Line(points={{102,-62},{126,-62},{126,300},
          {260,300}},           color={0,0,127}));
  connect(setOve.yVal, yVal) annotation (Line(points={{102,-70},{132,-70},{132,270},
          {260,270}},          color={0,0,127}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{182,
          -142},{200,-142},{200,-40},{260,-40}}, color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{182,
          -147},{206,-147},{206,-70},{260,-70}}, color={255,127,0}));
  connect(sysReq.yHeaValResReq, yHeaValResReq) annotation (Line(points={{182,
          -153},{212,-153},{212,-100},{260,-100}}, color={255,127,0}));
  connect(sysReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{182,
          -158},{218,-158},{218,-130},{260,-130}},
                                             color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{182,-241},{200,
          -241},{200,-170},{260,-170}},
                                  color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{182,-244},{206,
          -244},{206,-200},{260,-200}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{182,-252},{212,
          -252},{212,-260},{260,-260}},
                                  color={255,127,0}));
  connect(ala.yLeaValAla, yLeaValAla) annotation (Line(points={{182,-255},{206,
          -255},{206,-290},{260,-290}},
                                  color={255,127,0}));
  connect(ala.yLowTemAla, yLowTemAla) annotation (Line(points={{182,-259},{200,
          -259},{200,-320},{260,-320}},
                                  color={255,127,0}));
  connect(conLoo.yCoo, zonSta.uCoo) annotation (Line(points={{-178,266},{-154,266},
          {-154,226},{-142,226}}, color={0,0,127}));
  connect(conLoo.yHea, zonSta.uHea) annotation (Line(points={{-178,254},{-160,254},
          {-160,234},{-142,234}}, color={0,0,127}));
  connect(zonSta.yZonSta, setPoi.uZonSta) annotation (Line(points={{-118,230},{-110,
          230},{-110,169},{-102,169}}, color={255,127,0}));
  connect(setPoi.VParFan_flow, VParFan_flow) annotation (Line(points={{-102,166},
          {-174,166},{-174,70},{-260,70}},   color={0,0,127}));
  connect(setPoi.VMinOA_flow, damVal.VOAMin_flow) annotation (Line(points={{-78,166},
          {-62,166},{-62,6},{18,6}},      color={0,0,127}));
  connect(damVal.THeaDisSet, sysReq.TDisSet) annotation (Line(points={{42,11},{
          58,11},{58,-155},{158,-155}},
                                     color={0,0,127}));
  connect(setOve.oveFan, oveFan) annotation (Line(points={{78,-77},{-88,-77},{-88,
          -140},{-260,-140}}, color={255,127,0}));
  connect(setOve.y1Fan, y1Fan) annotation (Line(points={{102,-78},{138,-78},{138,
          200},{260,200}}, color={255,0,255}));
  connect(ala.yFanStaAla, yFanStaAla) annotation (Line(points={{182,-248},{212,
          -248},{212,-230},{260,-230}},
                                  color={255,127,0}));
  connect(damVal.y1Fan, setOve.u1Fan) annotation (Line(points={{42,1},{54,1},{54,
          -79},{78,-79}}, color={255,0,255}));
  connect(damVal.y1Fan, ala.u1FanCom) annotation (Line(points={{42,1},{54,1},{
          54,-245},{158,-245}},
                             color={255,0,255}));
  connect(damVal.THeaDisSet, ala.TDisSet) annotation (Line(points={{42,11},{58,
          11},{58,-261},{158,-261}},
                                 color={0,0,127}));
  connect(damVal.VFan_flow_Set, mul1.u1) annotation (Line(points={{42,3.8},{114,
          3.8},{114,246},{198,246}}, color={0,0,127}));
  connect(setOve.y1Fan, booToRea1.u) annotation (Line(points={{102,-78},{138,-78},
          {138,220},{158,220}}, color={255,0,255}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{182,220},{190,220},{190,
          234},{198,234}}, color={0,0,127}));
  connect(mul1.y, VFan_flow_Set)
    annotation (Line(points={{222,240},{260,240}}, color={0,0,127}));
  connect(u1TerFan, ala.u1TerFan) annotation (Line(points={{-260,-300},{36,-300},
          {36,-247},{158,-247}}, color={255,0,255}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-260,130},{-204,
          130},{-204,173},{-102,173}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,127},{-56,127},{-56,94},{-42,94}},   color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, damVal.VOAMin_flow) annotation (Line(points={{
          -78,139},{-62,139},{-62,6},{18,6}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-260,220},{-186,220},{
          -186,139},{-102,139}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-260,190},{-192,190},{
          -192,136},{-102,136}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,133},{-102,133}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set)
    annotation (Line(points={{-260,130},{-102,130}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-260,100},{-198,100},
          {-198,127},{-102,127}}, color={0,0,127}));
  connect(zonSta.yZonSta, minFlo.uZonSta) annotation (Line(points={{-118,230},{-110,
          230},{-110,124},{-102,124}}, color={255,127,0}));
  connect(VParFan_flow, minFlo.VParFan_flow) annotation (Line(points={{-260,70},
          {-174,70},{-174,121},{-102,121}}, color={0,0,127}));
  connect(damVal.VPri_flow_Set, VSet_flow) annotation (Line(points={{42,34},{120,
          34},{120,330},{260,330}}, color={0,0,127}));
  connect(damVal.VPri_flow_Set, sysReq.VSet_flow) annotation (Line(points={{42,34},
          {120,34},{120,-149},{158,-149}}, color={0,0,127}));
  connect(damVal.VPri_flow_Set, ala.VActSet_flow) annotation (Line(points={{42,34},
          {120,34},{120,-241},{158,-241}}, color={0,0,127}));
  connect(oveFloSet, damVal.oveFloSet) annotation (Line(points={{-260,-80},{-100,
          -80},{-100,39},{18,39}}, color={255,127,0}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-78,178},{100,178},{100,160},{260,160}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow) annotation (Line(
        points={{-78,170},{94,170},{94,130},{260,130}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-78,166},{
          88,166},{88,100},{260,100}}, color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{
          -78,139},{82,139},{82,70},{260,70}}, color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{
          -78,136},{76,136},{76,40},{260,40}}, color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-78,124},{70,124},{70,10},
          {260,10}}, color={0,0,127}));
  connect(setOve.yDam, sysReq.uDam) annotation (Line(points={{102,-62},{126,-62},
          {126,-153},{158,-153}}, color={0,0,127}));
  connect(setOve.yDam, ala.uDam) annotation (Line(points={{102,-62},{126,-62},{
          126,-251},{158,-251}}, color={0,0,127}));
  connect(setOve.yVal, sysReq.uVal) annotation (Line(points={{102,-70},{132,-70},
          {132,-159},{158,-159}}, color={0,0,127}));
  connect(setOve.yVal, ala.uVal) annotation (Line(points={{102,-70},{132,-70},{
          132,-253},{158,-253}}, color={0,0,127}));
  connect(u1Fan, damVal.u1Fan) annotation (Line(points={{-260,-270},{0,-270},{0,
          19},{18,19}}, color={255,0,255}));
  connect(uOpeMod, ala.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,-249},{158,-249}}, color={255,127,0}));
annotation (defaultComponentName="parFanCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
            {100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-4},{-56,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,16},{-74,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,58},{-60,44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-98,-22},{-74,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-42},{-60,-56}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,178},{-56,164}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-98,158},{-58,144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          visible=have_winSen,
          extent={{-100,138},{-68,124}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-100,118},{-64,104}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-100,-142},{-68,-156}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{-98,-122},{-62,-138}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{-96,98},{-50,82}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-60},{-52,-76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-80},{-40,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{40,204},{96,190}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow_Set"),
        Text(
          extent={{56,188},{98,176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam"),
        Text(
          extent={{58,168},{100,156}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yVal"),
        Text(
          extent={{18,-8},{96,-26}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonTemResReq"),
        Text(
          extent={{18,-28},{96,-46}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonPreResReq"),
        Text(
          extent={{20,-48},{98,-66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHeaValResReq"),
        Text(
          extent={{24,-70},{96,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatPlaReq"),
        Text(
          extent={{42,-90},{96,-106}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{42,-110},{96,-126}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{38,-148},{96,-166}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{42,-168},{96,-186}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{38,-184},{96,-202}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla",
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased),
        Text(
          extent={{-96,-100},{-64,-118}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFan"),
        Text(
          extent={{-96,38},{-38,24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VParFan_flow",
          visible=have_CO2Sen),
        Text(
          extent={{48,130},{100,114}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="y1Fan"),
        Text(
          extent={{38,-130},{98,-146}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFanStaAla"),
        Text(
          extent={{40,148},{96,134}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VFan_flow_Set"),
        Text(
          extent={{-98,-160},{-52,-176}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1TerFan"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,80},{-44,64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{12,110},{96,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{12,90},{96,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{36,70},{96,50}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{18,50},{96,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{18,28},{96,10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{66,8},{96,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{-96,196},{-72,182}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-96,-180},{-50,-196}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HotPla",
          visible=heaCoi==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-340},{240,340}})),
  Documentation(info="<html>
<p>
Controller for variable-volume parallel fan-powered terminal unit according to Section 5.8 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow_Set</code>,
damper position setpoint <code>yDam</code>, hot water valve position setpoint
<code>yVal</code>, terminal fan command on status <code>y1Fan</code> and
the airflow setpoint <code>VFan_flow_Set</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>, hot water reset request <code>yHeaValResReq</code>
and <code>yHotWatPlaReq</code>. It also outputs the alarms about the low airflow
<code>yLowFloAla</code>, low discharge temperature <code>yLowTemAla</code>,
leaking damper <code>yLeaDamAla</code> and valve <code>yLeaValAla</code>,
airflow sensor calibration alarm <code>yFloSenAla</code> and the terminal fan status alarm
<code>yFanStaAla</code>.
</p>
<p>The sequence consists of six subsequences.</p>
<h4>a. Heating and cooling control loop</h4>
<p>
The subsequence is implementd according to Section 5.3.4. The measured zone
temperature <code>TZon</code>, zone setpoints temperatures <code>THeaSet</code> and
<code>TCooSet</code> are inputs to the instance of class 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates</a> to generate the
heating and cooling control loop signal. 
</p>
<h4>b. Active airflow setpoint calculation</h4>
<p>
This sequence sets the active cooling maximum and minimum airflow according to
Section 5.8.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position setpoints for the terminal unit.
It also sets the command on status of the terminal fan and the airflow setpoint.
The implementation is according to Section 5.8.5. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisSet</code>. Along with the active cooling maximum and minimum airflow setpoint, measured
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VDis_flow_Set</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.8.8, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the hot water plant reset requests
<code>yHotWatPlaReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.8.6, this sequence outputs the alarms of low discharge flow,
low discharge temperature, fan status alarm, leaking damper, leaking valve, and airflow sensor calibration
alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.8.7, this sequence allows the override the aiflow setpoints,
damper and valve position setpoints, terminal fan command.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Overrides</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2023, by Jianjun Hu:<br/>
Removed the parameter <code>have_preIndDam</code> to exclude the option of using pressure independant damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
