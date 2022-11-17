within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF;
block Controller
  "Controller for variable-volume series fan-powered terminal unit"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venStd=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Boolean have_winSen=true
    "True: the zone has window sensor";
  parameter Boolean have_occSen=true
    "True: the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor";
  parameter Boolean have_hotWatCoi=true
    "True: the unit has the hot water coil";
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
                              and have_occSen));
  parameter Real VOccMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for occupants"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  parameter Real VAreMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for building area"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016));
  // ---------------- Design parameters ----------------
  parameter Real VAreBreZon_flow(unit="m3/s")
    "Design area component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions",
                      enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real VPopBreZon_flow(unit="m3/s")
    "Design population component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions",
                      enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real VMin_flow(unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation (Dialog(group="Design conditions"));
  parameter Real VCooMax_flow(unit="m3/s")
    "Design zone cooling maximum airflow rate"
    annotation (Dialog(group="Design conditions"));
  // ---------------- Control loop parameters ----------------
  parameter Real kCooCon=0.1
    "Gain of controller for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real TiCooCon(unit="s")=900
    "Time constant of integrator block for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real kHeaCon=0.1
    "Gain of controller for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  parameter Real TiHeaCon(unit="s")=900
    "Time constant of integrator block for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  // ---------------- Damper and valve control parameters ----------------
  parameter Real dTDisZonSetMax(unit="K")=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Dialog(tab="Damper and valve control"));
  parameter Real maxRat(unit="m3/s")
    "Maximum heating-fan airflow setpoint"
    annotation (Dialog(tab="Damper and valve control"));
  parameter CDL.Types.SimpleController controllerTypeVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                                                         "Type of controller"
    annotation (Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real kVal=0.5
    "Gain of controller for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real TiVal(unit="s")=300
    "Time constant of integrator block for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Boolean have_preIndDam=false
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation (Dialog(tab="Damper and valve control", group="Damper"));
  parameter CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_preIndDam));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_preIndDam));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_preIndDam
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                  or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_preIndDam
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  // ---------------- System request parameters ----------------
  parameter Real thrTemDif(unit="K")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real twoTemDif(unit="K")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real thrTDis_1(unit="K")=17
    "Threshold difference between discharge air temperature and its setpoint for generating 3 hot water reset requests"
    annotation (Dialog(tab="System requests", enable=have_hotWatCoi));
  parameter Real thrTDis_2(unit="K")=8.3
    "Threshold difference between discharge air temperature and its setpoint for generating 2 hot water reset requests"
    annotation (Dialog(tab="System requests", enable=have_hotWatCoi));
  parameter Real durTimTem(unit="s")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimFlo(unit="s")=60
    "Duration time of airflow rate less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimDisAir(unit="s")=300
    "Duration time of discharge air temperature less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration time", enable=have_hotWatCoi));
  // ---------------- Parameters for alarms ----------------
  parameter Real staPreMul=1
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (Dialog(tab="Alarms"));
  parameter Real hotWatRes=1
    "Importance multiplier for the hot water reset control loop"
    annotation (Dialog(tab="Alarms", enable=have_hotWatCoi));
  parameter Real lowFloTim(unit="s")=300
    "Threshold time to check low flow rate"
    annotation (Dialog(tab="Alarms"));
  parameter Real lowTemTim(unit="s")=600
    "Threshold time to check low discharge temperature"
    annotation (Dialog(tab="Alarms", enable=have_hotWatCoi));
  parameter Real comChaTim(unit="s")=15
    "Threshold time after fan command change"
    annotation (Dialog(tab="Alarms"));
  parameter Real fanOffTim(unit="s")=600
    "Threshold time to check fan off"
    annotation (Dialog(tab="Alarms"));
  parameter Real leaFloTim(unit="s")=600
    "Threshold time to check damper leaking airflow"
    annotation (Dialog(tab="Alarms"));
  parameter Real valCloTim(unit="s")=900
    "Threshold time to check valve leaking water flow"
    annotation (Dialog(tab="Alarms"));
  // ---------------- Parameters for time-based suppression ----------------
  parameter Real samplePeriod(unit="s")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (Dialog(tab="Time-based suppresion"));
  parameter Real chaRat=540
    "Gain factor to calculate suppression time based on the change of the setpoint, second per degC"
    annotation (Dialog(tab="Time-based suppresion"));
  parameter Real maxSupTim(unit="s")=1800
    "Maximum suppression time"
    annotation (Dialog(tab="Time-based suppresion"));
  // ---------------- Advanced parameters ----------------
  parameter Real dTHys(unit="K")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real floHys(unit="m3/s")=0.01
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(unit="1")=0.05
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real valPosHys(unit="1")=0.05
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real timChe(unit="s")=30
    "Threshold time to check the zone temperature status"
    annotation (Dialog(tab="Advanced", group="Control loops"));
  parameter Real zonDisEff_cool(unit="1")=1.0
    "Zone cooling air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));
  parameter Real zonDisEff_heat(unit="1")=0.8
    "Zone heating air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016));

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
    "Window status, true if the window is open, false if it is closed"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPri_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured primary airflow rate"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFan
    "Index of overriding terminal fan status, 1: turn fan off; 2: turn fan on"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-280,-190},{-240,-150}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-280,-290},{-240,-250}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1TerFan
    "Terminal fan status"
    annotation (Placement(transformation(extent={{-280,-320},{-240,-280}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if have_hotWatCoi
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
    final quantity="VolumeFlowRate") "Terminal fan flow rate setpoint"
    annotation (Placement(transformation(extent={{240,220},{280,260}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Fan
    "Terminal fan command on"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,150},{280,190}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,120},{280,160}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,30},{280,70}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{240,0},{280,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,-70},{280,-30}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{240,-100},{280,-60}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{240,-130},{280,-90}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{240,-160},{280,-120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-230},{280,-190}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFanStaAla
    "Terminal fan status alarm"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{240,-290},{280,-250}}),
        iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{240,-320},{280,-280}}),
        iconTransformation(extent={{100,-200},{140,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{240,-350},{280,-310}}),
        iconTransformation(extent={{100,-220},{140,-180}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.ActiveAirFlow
    actAirSet(final VCooMax_flow=VCooMax_flow) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.SystemRequests
    sysReq(
    final have_hotWatCoi=have_hotWatCoi,
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
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms
    ala(
    final have_hotWatCoi=have_hotWatCoi,
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
    final valPosHys=valPosHys) "Generate alarms"
    annotation (Placement(transformation(extent={{160,-260},{180,-240}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Overrides
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
    final have_typTerUni=true,
    final have_parFanPowUni=false,
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves
    damVal(
    final dTDisZonSetMax=dTDisZonSetMax,
    final maxRat=maxRat,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final have_preIndDam=have_preIndDam,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTHys=dTHys,
    final looHys=looHys,
    final floHys=floHys) "Damper and valve control"
    annotation (Placement(transformation(extent={{20,0},{40,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Paralle fan airflow setpoint"
    annotation (Placement(transformation(extent={{200,230},{220,250}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noVenStd(
    final k=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified)
    "No ventilation standard"
    annotation (Placement(transformation(extent={{-60,310},{-40,330}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,310},{0,330}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: Ventilation standard is not specified!")
    "Warning when the ventilation standard is not specified"
    annotation (Placement(transformation(extent={{20,310},{40,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerFlo(
    final k=0)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified
    "Zero flow when the ventilation standard is not specified"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
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
  connect(u1Win, setPoi.u1Win) annotation (Line(points={{-260,220},{-180,220},{
          -180,179},{-122,179}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-260,190},{-186,190},{
          -186,177},{-122,177}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,175},{-122,175}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-260,100},{-198,100},
          {-198,171},{-122,171}},  color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-260,320},{-222,320},{-222,
          163},{-122,163}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-260,70},{-192,70},{-192,
          161},{-122,161}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-260,160},{-210,
          160},{-210,106},{-42,106}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-98,174},{-56,174},{-56,94},{-42,94}},   color={0,0,127}));
  connect(VPri_flow, damVal.VPri_flow) annotation (Line(points={{-260,20},{-36,
          20},{-36,37},{18,37}}, color={0,0,127}));
  connect(conLoo.yCoo, damVal.uCoo) annotation (Line(points={{-178,266},{-154,
          266},{-154,34},{18,34}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow) annotation (Line(
        points={{-18,106},{0,106},{0,31},{18,31}},     color={0,0,127}));
  connect(TSup, damVal.TSup) annotation (Line(points={{-260,-10},{-30,-10},{-30,
          28},{18,28}},   color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow) annotation (Line(points={{-18,94},
          {-6,94},{-6,23},{18,23}},              color={0,0,127}));
  connect(TDis, damVal.TDis) annotation (Line(points={{-260,70},{-192,70},{-192,
          12},{18,12}},   color={0,0,127}));
  connect(TSupSet, damVal.TSupSet) annotation (Line(points={{-260,-40},{-24,-40},
          {-24,20},{18,20}},   color={0,0,127}));
  connect(THeaSet, damVal.THeaSet) annotation (Line(points={{-260,250},{-216,
          250},{-216,18},{18,18}},   color={0,0,127}));
  connect(conLoo.yHea, damVal.uHea) annotation (Line(points={{-178,254},{-160,254},
          {-160,15},{18,15}},   color={0,0,127}));
  connect(TZon, damVal.TZon) annotation (Line(points={{-260,320},{-222,320},{
          -222,26},{18,26}}, color={0,0,127}));
  connect(uOpeMod, damVal.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,6},{18,6}},     color={255,127,0}));
  connect(oveDamPos, setOve.oveDamPos) annotation (Line(points={{-260,-100},{
          -94,-100},{-94,-61},{78,-61}}, color={255,127,0}));
  connect(damVal.yDam, setOve.uDam) annotation (Line(points={{42,29},{66,29},{
          66,-63},{78,-63}},       color={0,0,127}));
  connect(uHeaOff, setOve.uHeaOff) annotation (Line(points={{-260,-170},{12,
          -170},{12,-69},{78,-69}}, color={255,0,255}));
  connect(damVal.yVal, setOve.uVal) annotation (Line(points={{42,8},{62,8},{62,
          -71},{78,-71}},          color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-178,300},{
          -148,300},{-148,-141},{158,-141}},
                                       color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-260,290},{-228,
          290},{-228,-143},{158,-143}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-260,320},{-222,320},{
          -222,-145},{158,-145}},
                             color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-178,266},{-154,
          266},{-154,-147},{158,-147}},
                                  color={0,0,127}));
  connect(VPri_flow,sysReq.VPri_flow)  annotation (Line(points={{-260,20},{-36,
          20},{-36,-151},{158,-151}},
                                  color={0,0,127}));
  connect(TDis, sysReq.TDis) annotation (Line(points={{-260,70},{-192,70},{-192,
          -157},{158,-157}}, color={0,0,127}));
  connect(VPri_flow,ala.VPri_flow)  annotation (Line(points={{-260,20},{-36,20},
          {-36,-240},{158,-240}}, color={0,0,127}));
  connect(u1Fan, ala.u1Fan) annotation (Line(points={{-260,-270},{0,-270},{0,
          -244},{158,-244}},
                       color={255,0,255}));
  connect(TSup, ala.TSup) annotation (Line(points={{-260,-10},{-30,-10},{-30,
          -254},{158,-254}},
                       color={0,0,127}));
  connect(u1HotPla, ala.u1HotPla) annotation (Line(points={{-260,-330},{40,-330},
          {40,-256},{158,-256}}, color={255,0,255}));
  connect(TDis, ala.TDis) annotation (Line(points={{-260,70},{-192,70},{-192,
          -258},{158,-258}},
                       color={0,0,127}));
  connect(setOve.yDam, yDam) annotation (Line(points={{102,-63},{126,-63},{126,300},
          {260,300}},           color={0,0,127}));
  connect(setOve.yVal, yVal) annotation (Line(points={{102,-70},{132,-70},{132,270},
          {260,270}},          color={0,0,127}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{182,
          -142},{200,-142},{200,-50},{260,-50}},
                                           color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{182,
          -147},{206,-147},{206,-80},{260,-80}},
                                           color={255,127,0}));
  connect(sysReq.yHeaValResReq, yHeaValResReq) annotation (Line(points={{182,
          -153},{212,-153},{212,-110},{260,-110}},
                                             color={255,127,0}));
  connect(sysReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{182,
          -158},{218,-158},{218,-140},{260,-140}},
                                             color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{182,-241},{200,
          -241},{200,-180},{260,-180}},
                                  color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{182,-244},{206,
          -244},{206,-210},{260,-210}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{182,-252},{212,
          -252},{212,-270},{260,-270}},
                                  color={255,127,0}));
  connect(ala.yLeaValAla, yLeaValAla) annotation (Line(points={{182,-255},{206,
          -255},{206,-300},{260,-300}},
                                  color={255,127,0}));
  connect(ala.yLowTemAla, yLowTemAla) annotation (Line(points={{182,-259},{200,
          -259},{200,-330},{260,-330}},
                                  color={255,127,0}));
  connect(setPoi.VMinOA_flow, damVal.VOAMin_flow) annotation (Line(points={{-98,166},
          {-62,166},{-62,9},{18,9}},      color={0,0,127}));
  connect(damVal.THeaDisSet, sysReq.TDisSet) annotation (Line(points={{42,11},{
          58,11},{58,-155},{158,-155}},
                                     color={0,0,127}));
  connect(setOve.oveFan, oveFan) annotation (Line(points={{78,-77},{-88,-77},{
          -88,-130},{-260,-130}}, color={255,127,0}));
  connect(setOve.y1Fan, y1Fan) annotation (Line(points={{102,-77},{140,-77},{140,
          200},{260,200}},   color={255,0,255}));
  connect(ala.yFanStaAla, yFanStaAla) annotation (Line(points={{182,-248},{212,
          -248},{212,-240},{260,-240}},
                                  color={255,127,0}));
  connect(damVal.y1Fan, setOve.u1Fan) annotation (Line(points={{42,1},{54,1},{
          54,-79},{78,-79}}, color={255,0,255}));
  connect(damVal.y1Fan, ala.u1FanCom) annotation (Line(points={{42,1},{54,1},{
          54,-246},{158,-246}},
                             color={255,0,255}));
  connect(damVal.THeaDisSet, ala.TDisSet) annotation (Line(points={{42,11},{58,
          11},{58,-260},{158,-260}},
                                 color={0,0,127}));
  connect(damVal.VFan_flow_Set, mul1.u1) annotation (Line(points={{42,3.8},{114,
          3.8},{114,246},{198,246}}, color={0,0,127}));
  connect(setOve.y1Fan, booToRea1.u) annotation (Line(points={{102,-77},{140,-77},
          {140,220},{158,220}},    color={255,0,255}));
  connect(booToRea1.y, mul1.u2) annotation (Line(points={{182,220},{190,220},{190,
          234},{198,234}}, color={0,0,127}));
  connect(mul1.y, VFan_flow_Set)
    annotation (Line(points={{222,240},{260,240}}, color={0,0,127}));
  connect(u1Fan, damVal.u1Fan) annotation (Line(points={{-260,-270},{0,-270},{0,
          3},{18,3}}, color={255,0,255}));
  connect(u1TerFan, ala.u1TerFan) annotation (Line(points={{-260,-300},{32,-300},
          {32,-248},{158,-248}}, color={255,0,255}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-260,130},{-204,
          130},{-204,173},{-122,173}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-98,127},{-56,127},{-56,94},{-42,94}},   color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, damVal.VOAMin_flow) annotation (Line(points={{
          -98,139},{-62,139},{-62,9},{18,9}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-260,220},{-180,220},{
          -180,139},{-122,139}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-260,190},{-186,190},{
          -186,136},{-122,136}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-260,160},{-210,160},
          {-210,133},{-122,133}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set)
    annotation (Line(points={{-260,130},{-122,130}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-260,100},{-198,100},
          {-198,127},{-122,127}}, color={0,0,127}));
  connect(damVal.VPri_flow_Set, VSet_flow) annotation (Line(points={{42,34},{120,
          34},{120,330},{260,330}},     color={0,0,127}));
  connect(damVal.VPri_flow_Set, sysReq.VSet_flow) annotation (Line(points={{42,34},
          {120,34},{120,-149},{158,-149}},     color={0,0,127}));
  connect(damVal.VPri_flow_Set, ala.VActSet_flow) annotation (Line(points={{42,34},
          {120,34},{120,-242},{158,-242}},     color={0,0,127}));
  connect(oveFloSet, damVal.oveFloSet) annotation (Line(points={{-260,-70},{
          -100,-70},{-100,39},{18,39}}, color={255,127,0}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-98,178},{100,178},{100,170},{260,170}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow) annotation (Line(
        points={{-98,170},{94,170},{94,140},{260,140}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-98,166},{
          88,166},{88,110},{260,110}}, color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{
          -98,136},{76,136},{76,50},{260,50}}, color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{
          -98,139},{82,139},{82,80},{260,80}}, color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-98,124},{70,124},{70,20},
          {260,20}}, color={0,0,127}));
  connect(noVenStd.y,not1. u)
    annotation (Line(points={{-38,320},{-22,320}}, color={255,0,255}));
  connect(not1.y,assMes1. u)
    annotation (Line(points={{2,320},{18,320}},    color={255,0,255}));
  connect(zerFlo.y, actAirSet.VOccMin_flow) annotation (Line(points={{-98,70},{-56,
          70},{-56,94},{-42,94}}, color={0,0,127}));
  connect(setOve.yDam, damVal.uDam) annotation (Line(points={{102,-63},{126,-63},
          {126,-20},{6,-20},{6,1},{18,1}}, color={0,0,127}));
  connect(setOve.yDam, sysReq.uDam) annotation (Line(points={{102,-63},{126,-63},
          {126,-153},{158,-153}}, color={0,0,127}));
  connect(setOve.yDam, ala.uDam) annotation (Line(points={{102,-63},{126,-63},{
          126,-250},{158,-250}}, color={0,0,127}));
  connect(setOve.yVal, sysReq.uVal) annotation (Line(points={{102,-70},{132,-70},
          {132,-159},{158,-159}}, color={0,0,127}));
  connect(setOve.yVal, ala.uVal) annotation (Line(points={{102,-70},{132,-70},{
          132,-252},{158,-252}}, color={0,0,127}));
annotation (defaultComponentName="serFanCon",
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
          extent={{-98,16},{-56,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VPri_flow"),
        Text(
          extent={{-100,36},{-74,24}},
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
          extent={{-98,-2},{-74,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-22},{-60,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,192},{-72,180}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,178},{-56,162}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-98,158},{-52,142}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          visible=have_winSen,
          extent={{-98,138},{-72,126}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-98,118},{-72,106}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-98,-182},{-52,-198}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="u1HotPla"),
        Text(
          extent={{-98,-142},{-64,-158}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{-98,-102},{-62,-118}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{-96,98},{-50,82}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-40},{-52,-56}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-60},{-40,-76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{40,202},{96,188}},
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
          visible=have_hotWatCoi),
        Text(
          extent={{-96,-80},{-64,-98}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFan"),
        Text(
          extent={{46,130},{98,114}},
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
          extent={{-98,-162},{-48,-178}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1TerFan"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,76},{-46,62}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{12,112},{96,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{12,92},{96,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{36,72},{96,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{18,52},{96,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{18,30},{96,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{66,10},{96,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-340},{240,340}})),
  Documentation(info="<html>
<p>
Controller for variable-volume series fan-powered terminal unit according to Section 5.8 of ASHRAE
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
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position setpoints for the terminal unit.
It also sets the command on status of the terminal fan and the airflow setpoint.
The implementation is according to Section 5.8.5. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisSet</code>. Along with the active cooling maximum and minimum airflow setpoint, measured
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VPri_flow_Set</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.8.8, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the hot water plant reset requests
<code>yHotWatPlaReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.8.6, this sequence outputs the alarms of low discharge flow,
low discharge temperature, fan status alarm, leaking damper, leaking valve, and airflow sensor calibration
alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.8.7, this sequence allows the override the aiflow setpoints,
damper and valve position setpoints, terminal fan command.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Overrides</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
