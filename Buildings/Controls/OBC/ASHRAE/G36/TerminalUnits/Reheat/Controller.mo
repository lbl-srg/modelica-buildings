within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat;
block Controller "Controller for room VAV box with reheat"

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
  parameter Real VHeaMin_flow(unit="m3/s")
    "Design zone heating minimum airflow rate, for the reheat box with water hot coil, it should be zero"
    annotation (Dialog(group="Design conditions"));
  parameter Real VHeaMax_flow(unit="m3/s")
    "Design zone heating maximum airflow rate"
    annotation (Dialog(group="Design conditions"));
  // ---------------- Control loop parameters ----------------
  parameter Real kCooCon=0.1
    "Gain of controller for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real TiCooCon(unit="s")=120
    "Time constant of integrator block for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real kHeaCon=0.1
    "Gain of controller for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  parameter Real TiHeaCon(unit="s")=120
    "Time constant of integrator block for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  // ---------------- Damper and valve control parameters ----------------
  parameter Real dTDisZonSetMax=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Dialog(tab="Damper and valve control"));
  parameter Real TDisMin=283.15 "Lowest discharge air temperature"
    annotation (Dialog(tab="Damper and valve control"));
  parameter CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
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
  parameter Real thrTDis_2(unit="K")=8
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
    annotation (Placement(transformation(extent={{-220,240},{-180,280}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, true if the window is open, false if it is closed"
    annotation (Placement(transformation(extent={{-220,150},{-180,190}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-220,-50},{-180,-10}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-220,-110},{-180,-70}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaOff
    "Override heating valve position, true: close heating valve"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-188},{-100,-148}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HotPla if have_hotWatCoi
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-220,-290},{-180,-250}}),
        iconTransformation(extent={{-140,-208},{-100,-168}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{200,250},{240,290}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final unit="1") "Damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{200,220},{240,260}}),
        iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(
    final min=0,
    final unit="1")
    "Heating valve commanded position, after considering override"
    annotation (Placement(transformation(extent={{200,190},{240,230}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{200,130},{240,170}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,70},{240,110}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{200,10},{240,50}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-50},{240,-10}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq
    if have_hotWatCoi
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq
    if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{200,-110},{240,-70}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{200,-170},{240,-130}}),
        iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{200,-230},{240,-190}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    if have_hotWatCoi
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-260},{240,-220}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.ActiveAirFlow actAirSet(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMin_flow=VHeaMin_flow,
    final VHeaMax_flow=VHeaMax_flow) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests sysReq(
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
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    final kCooCon=kCooCon,
    final TiCooCon=TiCooCon,
    final kHeaCon=kHeaCon,
    final TiHeaCon=TiHeaCon,
    final timChe=timChe,
    final dTHys=dTHys,
    final looHys=looHys) "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms ala(
    final have_hotWatCoi=have_hotWatCoi,
    final staPreMul=staPreMul,
    final hotWatRes=hotWatRes,
    final VCooMax_flow=VCooMax_flow,
    final lowFloTim=lowFloTim,
    final lowTemTim=lowTemTim,
    final fanOffTim=fanOffTim,
    final leaFloTim=leaFloTim,
    final valCloTim=valCloTim,
    final floHys=floHys,
    final dTHys=dTHys,
    final damPosHys=damPosHys,
    final valPosHys=valPosHys) "Generate alarms"
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides setOve
    "Override setpoints"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSup(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final have_parFanPowUni=false,
    final have_SZVAV=false,
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves damVal(
    final dTDisZonSetMax=dTDisZonSetMax,
    final TDisMin=TDisMin,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
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
    final looHys=looHys) "Damper and valve control"
    annotation (Placement(transformation(extent={{0,-52},{20,-12}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noVenStd(
    final k=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified)
    "No ventilation standard"
    annotation (Placement(transformation(extent={{-60,250},{-40,270}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,250},{0,270}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="Warning: Ventilation standard is not specified!")
    "Warning when the ventilation standard is not specified"
    annotation (Placement(transformation(extent={{20,250},{40,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerFlo(
    final k=0)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified
    "Zero flow when the ventilation standard is not specified"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
equation
  connect(TZon, timSup.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          246},{-142,246}}, color={0,0,127}));
  connect(TCooSet, timSup.TSet) annotation (Line(points={{-200,230},{-168,230},
          {-168,254},{-142,254}}, color={0,0,127}));
  connect(TCooSet, conLoo.TCooSet) annotation (Line(points={{-200,230},{-168,
          230},{-168,216},{-142,216}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          210},{-142,210}}, color={0,0,127}));
  connect(THeaSet, conLoo.THeaSet) annotation (Line(points={{-200,200},{-160,
          200},{-160,204},{-142,204}}, color={0,0,127}));
  connect(u1Win, setPoi.u1Win) annotation (Line(points={{-200,170},{-120,170},{
          -120,139},{-102,139}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-200,150},{-124,150},{
          -124,137},{-102,137}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-200,120},{-140,120},
          {-140,135},{-102,135}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-200,60},{-132,60},{-132,
          131},{-102,131}}, color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          123},{-102,123}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-200,30},{-128,30},{-128,
          121},{-102,121}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-200,120},{-140,
          120},{-140,56},{-62,56}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,134},{-72,134},{-72,44},{-62,44}}, color={0,0,127}));
  connect(VDis_flow, damVal.VDis_flow) annotation (Line(points={{-200,0},{-40,0},
          {-40,-16},{-2,-16}}, color={0,0,127}));
  connect(actAirSet.VActCooMin_flow, damVal.VActCooMin_flow) annotation (Line(
        points={{-38,54},{-10,54},{-10,-19},{-2,-19}}, color={0,0,127}));
  connect(conLoo.yCoo, damVal.uCoo) annotation (Line(points={{-118,216},{-14,
          216},{-14,-22},{-2,-22}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow) annotation (Line(
        points={{-38,58},{-18,58},{-18,-25},{-2,-25}}, color={0,0,127}));
  connect(TSup, damVal.TSup) annotation (Line(points={{-200,-30},{-48,-30},{-48,
          -28},{-2,-28}}, color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow) annotation (Line(points={{-38,50},
          {-22,50},{-22,-31},{-2,-31}},          color={0,0,127}));
  connect(TDis, damVal.TDis) annotation (Line(points={{-200,30},{-128,30},{-128,
          -34},{-2,-34}}, color={0,0,127}));
  connect(TSupSet, damVal.TSupSet) annotation (Line(points={{-200,-60},{-44,-60},
          {-44,-36},{-2,-36}}, color={0,0,127}));
  connect(THeaSet, damVal.THeaSet) annotation (Line(points={{-200,200},{-160,
          200},{-160,-38},{-2,-38}}, color={0,0,127}));
  connect(conLoo.yHea, damVal.uHea) annotation (Line(points={{-118,204},{-110,
          204},{-110,-41},{-2,-41}}, color={0,0,127}));
  connect(TZon, damVal.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          -43},{-2,-43}}, color={0,0,127}));
  connect(actAirSet.VActHeaMin_flow, damVal.VActHeaMin_flow) annotation (Line(
        points={{-38,46},{-26,46},{-26,-46},{-2,-46}}, color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damVal.VActHeaMax_flow) annotation (Line(
        points={{-38,42},{-30,42},{-30,-48},{-2,-48}}, color={0,0,127}));
  connect(uOpeMod, damVal.uOpeMod) annotation (Line(points={{-200,120},{-140,120},
          {-140,-51},{-2,-51}}, color={255,127,0}));
  connect(oveDamPos, setOve.oveDamPos) annotation (Line(points={{-200,-120},{20,
          -120},{20,-82},{58,-82}}, color={255,127,0}));
  connect(damVal.yDam, setOve.uDam) annotation (Line(points={{22,-23},{46,-23},
          {46,-86},{58,-86}},      color={0,0,127}));
  connect(uHeaOff, setOve.uHeaOff) annotation (Line(points={{-200,-150},{24,
          -150},{24,-94},{58,-94}}, color={255,0,255}));
  connect(damVal.yVal, setOve.uVal) annotation (Line(points={{22,-41},{42,-41},
          {42,-97},{58,-97}},      color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-118,250},{-68,
          250},{-68,-121},{118,-121}}, color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-200,230},{-168,
          230},{-168,-123},{118,-123}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          -125},{118,-125}}, color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-118,216},{-14,216},
          {-14,-127},{118,-127}}, color={0,0,127}));
  connect(VDis_flow, sysReq.VDis_flow) annotation (Line(points={{-200,0},{-40,0},
          {-40,-131},{118,-131}}, color={0,0,127}));
  connect(damVal.TDisSet, sysReq.TDisSet) annotation (Line(points={{22,-46},{38,
          -46},{38,-135},{118,-135}}, color={0,0,127}));
  connect(TDis, sysReq.TDis) annotation (Line(points={{-200,30},{-128,30},{-128,
          -137},{118,-137}}, color={0,0,127}));
  connect(VDis_flow, ala.VDis_flow) annotation (Line(points={{-200,0},{-40,0},{-40,
          -182},{118,-182}},      color={0,0,127}));
  connect(u1Fan, ala.u1Fan) annotation (Line(points={{-200,-240},{90,-240},{90,-186},
          {118,-186}}, color={255,0,255}));
  connect(TSup, ala.TSup) annotation (Line(points={{-200,-30},{-48,-30},{-48,-192},
          {118,-192}}, color={0,0,127}));
  connect(u1HotPla, ala.u1HotPla) annotation (Line(points={{-200,-270},{94,-270},
          {94,-194},{118,-194}}, color={255,0,255}));
  connect(TDis, ala.TDis) annotation (Line(points={{-200,30},{-128,30},{-128,-196},
          {118,-196}}, color={0,0,127}));
  connect(damVal.TDisSet, ala.TDisSet) annotation (Line(points={{22,-46},{38,-46},
          {38,-198},{118,-198}}, color={0,0,127}));
  connect(setOve.yDam, yDam) annotation (Line(points={{82,-86},{98,-86},{98,240},
          {220,240}},      color={0,0,127}));
  connect(setOve.yVal, yVal) annotation (Line(points={{82,-94},{104,-94},{104,210},
          {220,210}},          color={0,0,127}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{142,-122},
          {146,-122},{146,0},{220,0}},     color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{142,-127},
          {150,-127},{150,-30},{220,-30}}, color={255,127,0}));
  connect(sysReq.yHeaValResReq, yHeaValResReq) annotation (Line(points={{142,-133},
          {154,-133},{154,-60},{220,-60}}, color={255,127,0}));
  connect(sysReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{142,-138},
          {158,-138},{158,-90},{220,-90}}, color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{142,-182},{168,-182},
          {168,-120},{220,-120}}, color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{142,-186},{172,-186},
          {172,-150},{220,-150}}, color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{142,-190},{176,-190},
          {176,-180},{220,-180}}, color={255,127,0}));
  connect(ala.yLeaValAla, yLeaValAla) annotation (Line(points={{142,-194},{176,-194},
          {176,-210},{220,-210}}, color={255,127,0}));
  connect(ala.yLowTemAla, yLowTemAla) annotation (Line(points={{142,-198},{172,-198},
          {172,-240},{220,-240}}, color={255,127,0}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-200,90},{-136,
          90},{-136,133},{-102,133}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,87},{-72,87},{-72,44},{-62,44}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-200,170},{-120,170},{
          -120,99},{-102,99}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-200,150},{-124,150},{
          -124,96},{-102,96}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-200,120},{-140,120},
          {-140,93},{-102,93}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set)
    annotation (Line(points={{-200,90},{-102,90}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-200,60},{-132,60},{-132,
          87},{-102,87}}, color={0,0,127}));
  connect(damVal.VSet_flow, VSet_flow) annotation (Line(points={{22,-18},{90,-18},
          {90,270},{220,270}},      color={0,0,127}));
  connect(damVal.VSet_flow, sysReq.VSet_flow) annotation (Line(points={{22,-18},
          {90,-18},{90,-129},{118,-129}}, color={0,0,127}));
  connect(damVal.VSet_flow, ala.VActSet_flow) annotation (Line(points={{22,-18},
          {90,-18},{90,-184},{118,-184}}, color={0,0,127}));
  connect(oveFloSet, damVal.oveFloSet) annotation (Line(points={{-200,-90},{-34,
          -90},{-34,-13},{-2,-13}}, color={255,127,0}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-78,138},{60,138},{60,180},{220,180}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow) annotation (Line(
        points={{-78,130},{66,130},{66,150},{220,150}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-78,126},{60,
          126},{60,120},{220,120}}, color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{-78,
          99},{60,99},{60,90},{220,90}}, color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{-78,
          96},{54,96},{54,60},{220,60}}, color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-78,84},{48,84},{48,30},{
          220,30}}, color={0,0,127}));
  connect(noVenStd.y,not1. u)
    annotation (Line(points={{-38,260},{-22,260}}, color={255,0,255}));
  connect(not1.y,assMes1. u)
    annotation (Line(points={{2,260},{18,260}},    color={255,0,255}));
  connect(zerFlo.y, actAirSet.VOccMin_flow) annotation (Line(points={{-78,30},{-72,
          30},{-72,44},{-62,44}}, color={0,0,127}));
  connect(setOve.yDam, sysReq.uDam) annotation (Line(points={{82,-86},{98,-86},{
          98,-133},{118,-133}}, color={0,0,127}));
  connect(setOve.yDam, ala.uDam) annotation (Line(points={{82,-86},{98,-86},
          {98,-188},{118,-188}}, color={0,0,127}));
  connect(setOve.yVal, sysReq.uVal) annotation (Line(points={{82,-94},{104,-94},
          {104,-139},{118,-139}}, color={0,0,127}));
  connect(setOve.yVal, ala.uVal) annotation (Line(points={{82,-94},{104,-94},
          {104,-190},{118,-190}}, color={0,0,127}));
annotation (defaultComponentName="rehBoxCon",
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
          extent={{-96,6},{-54,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,26},{-72,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-94,66},{-52,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{-98,-12},{-72,-24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-34},{-56,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,198},{-72,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,178},{-58,164}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-98,158},{-56,144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          visible=have_winSen,
          extent={{-98,128},{-68,114}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-98,108},{-66,94}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-96,-180},{-60,-196}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          visible=have_hotWatCoi,
          textString="u1HotPla"),
        Text(
          extent={{-98,-162},{-72,-174}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{-98,-94},{-62,-110}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{-96,88},{-50,72}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-50},{-52,-66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-70},{-40,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{54,198},{96,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{56,178},{98,166}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam"),
        Text(
          extent={{56,158},{98,146}},
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
          extent={{18,-48},{96,-66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHeaValResReq",
          visible=have_hotWatCoi),
        Text(
          extent={{18,-68},{96,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatPlaReq",
          visible=have_hotWatCoi),
        Text(
          extent={{42,-100},{98,-118}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{40,-118},{98,-136}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{40,-138},{98,-156}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{44,-158},{98,-176}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{36,-178},{98,-196}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla",
          visible=have_hotWatCoi),
        Text(
          visible=have_CO2Sen,
          extent={{-100,46},{-58,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{12,132},{96,114}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{12,112},{96,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{36,92},{96,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016),
        Text(
          extent={{18,72},{96,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{18,50},{96,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016),
        Text(
          extent={{66,28},{96,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-280},{200,280}})),
  Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat according to Section 5.6 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow</code>,
damper position setpoint <code>yDam</code>, hot water valve position setpoint
<code>yVal</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>, hot water reset request <code>yHeaValResReq</code>
and <code>yHotWatPlaReq</code>. It also outputs the alarms about the low airflow
<code>yLowFloAla</code>, low discharge temperature <code>yLowTemAla</code>,
leaking damper <code>yLeaDamAla</code> and valve <code>yLeaValAla</code>, and
airflow sensor calibration alarm <code>yFloSenAla</code>.
</p>
<p>The sequence consists of following six subsequences.</p>
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
This sequence sets the active maximum and minimum airflow according to
Section 5.6.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Damper and valve control</h4>
<p>
This sequence sets the damper and valve position setpoints for VAV reheat terminal unit.
The implementation is according to Section 5.6.5. According to heating and cooling
control loop signal, it calculates the discharge air temperature setpoint
<code>TDisSet</code>. Along with the active maximum and minimum airflow setpoint, measured
zone temperature, the sequence outputs <code>yDam</code>, <code>yVal</code>,
<code>TDisSet</code> and discharge airflow rate setpoint <code>VDisSet_flow</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.6.8, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>, hot water reset
requests <code>yHeaValResReq</code>, and the hot water plant reset requests
<code>yHotWatPlaReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.6.6, this sequence outputs the alarms of low discharge flow,
low discharge temperature, leaking damper, leaking valve, and airflow sensor calibration
alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.6.7, this sequence allows the override the aiflow setpoints,
damper and valve position setpoints.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Overrides</a>.
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
