within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF;
block Controller_new "Controller for constant-volume fan-powered terminal unit"

  parameter Boolean have_winSen=true
    "True: the zone has window sensor";
  parameter Boolean have_occSen=true
    "True: the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor";
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted";
  parameter Boolean have_hotWatCoi=true
    "True: the system has hot water coil";
  // ---------------- Design parameters ----------------
  parameter Real AFlo(
    final quantity="Area",
    final unit="m2")
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
  parameter Real CO2Set=894
    "CO2 concentration setpoint, ppm"
    annotation (Dialog(group="Design conditions"));
  parameter Real VZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation (Dialog(group="Design conditions"));
  parameter Real VCooZonMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate"
    annotation (Dialog(group="Design conditions"));
  // ---------------- Control loop parameters ----------------
  parameter Real kCooCon=1
    "Gain of controller for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real TiCooCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for cooling control loop"
    annotation (Dialog(tab="Control loops", group="Cooling"));
  parameter Real kHeaCon=1
    "Gain of controller for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  parameter Real TiHeaCon(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for heating control loop"
    annotation (Dialog(tab="Control loops", group="Heating"));
  // ---------------- Damper and valve control parameters ----------------
  parameter Real dTDisZonSetMax=11
    "Zone maximum discharge air temperature above heating setpoint"
    annotation (Dialog(tab="Damper and valve control"));
  parameter CDL.Types.SimpleController controllerTypeVal
    "Type of controller"
    annotation (Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real kVal=0.5
    "Gain of controller for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve"));
  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(tab="Damper and valve control", group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Boolean have_pressureIndependentDamper=false
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation (Dialog(tab="Damper and valve control", group="Damper"));
  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation (Dialog(tab="Damper and valve control", group="Damper"));
  parameter CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_pressureIndependentDamper));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_pressureIndependentDamper));
  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_pressureIndependentDamper
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                  or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(tab="Damper and valve control", group="Damper",
      enable=not have_pressureIndependentDamper
             and (controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                  or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  // ---------------- System request parameters ----------------
  parameter Real thrTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real twoTemDif(
    final unit="K",
    final quantity="TemperatureDifference")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real thrTDis_1(
    final unit="K",
    final quantity="TemperatureDifference")=17
    "Threshold difference between discharge air temperature and its setpoint for generating 3 hot water reset requests"
    annotation (Dialog(tab="System requests", enable=have_hotWatCoi));
  parameter Real thrTDis_2(
    final unit="K",
    final quantity="TemperatureDifference")=8
    "Threshold difference between discharge air temperature and its setpoint for generating 2 hot water reset requests"
    annotation (Dialog(tab="System requests", enable=have_hotWatCoi));
  parameter Real durTimTem(
    final unit="s",
    final quantity="Time")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimFlo(
    final unit="s",
    final quantity="Time")=60
    "Duration time of airflow rate less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimDisAir(
    final unit="s",
    final quantity="Time")=300
    "Duration time of discharge air temperature less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration time", enable=have_hotWatCoi));
  // ---------------- Parameters for alarms ----------------
  parameter Real staPreMul
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (Dialog(tab="Alarms"));
  parameter Real hotWatRes
    "Importance multiplier for the hot water reset control loop"
    annotation (Dialog(tab="Alarms"));
  parameter Real lowFloTim(
    final unit="s",
    final quantity="Time")=300
    "Threshold time to check low flow rate"
    annotation (Dialog(tab="Alarms"));
  parameter Real lowTemTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check low discharge temperature"
    annotation (Dialog(tab="Alarms"));
  parameter Real comChaTim(
    final unit="s",
    final quantity="Time")=15
    "Threshold time after fan command change"
    annotation (Dialog(tab="Alarms"));
  parameter Real fanOffTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check fan off"
    annotation (Dialog(tab="Alarms"));
  parameter Real leaFloTim(
    final unit="s",
    final quantity="Time")=600
    "Threshold time to check damper leaking airflow"
    annotation (Dialog(tab="Alarms"));
  parameter Real valCloTim(
    final unit="s",
    final quantity="Time")=900
    "Threshold time to check valve leaking water flow"
    annotation (Dialog(tab="Alarms"));
  // ---------------- Parameters for time-based suppression ----------------
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (Dialog(tab="Time-based suppresion"));
  parameter Real chaRat=540
    "Gain factor to calculate suppression time based on the change of the setpoint, second per degC"
    annotation (Dialog(tab="Time-based suppresion"));
  parameter Real maxSupTim(
    final unit="s",
    final quantity="Time")=1800 "Maximum suppression time"
    annotation (Dialog(tab="Time-based suppresion"));
  // ---------------- Advanced parameters ----------------
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Near zero temperature difference, below which the difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(
    final unit="1")=0.05
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real floHys(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(
    final unit="1")
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real valPosHys(
    final unit="1")
    "Near zero valve position, below which the valve will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real timChe(
    final unit="s",
    final quantity="Time")=30
    "Threshold time to check the zone temperature status"
    annotation (Dialog(tab="Advanced", group="Control loops"));
  parameter Real conThr(
    final unit="1")=0.1
    "Threshold value to check if the controller output is near zero"
    annotation (Dialog(tab="Advanced", group="Control loops"));
  parameter Real zonDisEff_cool(
    final unit="1")=1.0
    "Zone cooling air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness"));
  parameter Real zonDisEff_heat(
    final unit="1")=0.8
    "Zone heating air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness"));


  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-220,240},{-180,280}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "Occupancy status, true if it is occupied, false if it is not occupied"
    annotation (Placement(transformation(extent={{-220,110},{-180,150}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured supply air temperature after heating coil"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-220,-42},{-180,-2}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint from central air handler"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDam(
    final min=0,
    final max=1,
    final unit="1")
    "Actual damper position"
    annotation (Placement(transformation(extent={{-220,-200},{-180,-160}}),
        iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uVal(
    final min=0,
    final max=1,
    final unit="1")
    "Actual hot water valve position"
    annotation (Placement(transformation(extent={{-220,-230},{-180,-190}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-188},{-100,-148}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotPla
    "Hot water plant status"
    annotation (Placement(transformation(extent={{-220,-290},{-180,-250}}),
        iconTransformation(extent={{-140,-208},{-100,-168}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{200,210},{240,250}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDamSet(
    final min=0,
    final unit="1")
    "Damper position setpoint after considering override"
    annotation (Placement(transformation(extent={{200,170},{240,210}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValSet(
    final min=0,
    final unit="1")
    "Heating valve position setpoint after considering override"
    annotation (Placement(transformation(extent={{200,130},{240,170}}),
        iconTransformation(extent={{100,110},{140,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,90},{240,130}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{200,50},{240,90}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaValResReq if have_hotWatCoi
    "Hot water reset requests"
    annotation (Placement(transformation(extent={{200,10},{240,50}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_hotWatCoi
    "Request to heating hot-water plant"
    annotation (Placement(transformation(extent={{200,-30},{240,10}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{200,-120},{240,-80}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{200,-160},{240,-120}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaValAla
    "Leaking valve alarm"
    annotation (Placement(transformation(extent={{200,-200},{240,-160}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowTemAla
    "Low discharge air temperature alarms"
    annotation (Placement(transformation(extent={{200,-240},{240,-200}}),
        iconTransformation(extent={{100,-200},{140,-160}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.ActiveAirFlow
    actAirSet(final VCooZonMax_flow=VCooZonMax_flow)
    "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.SystemRequests
    sysReq(
    have_hotWatCoi=have_hotWatCoi,
    thrTemDif=thrTemDif,
    twoTemDif=twoTemDif,
    thrTDis_1=thrTDis_1,
    thrTDis_2=thrTDis_2,
    durTimTem=durTimTem,
    durTimFlo=durTimFlo,
    durTimDisAir=durTimDisAir,
    dTHys=dTHys,
    floHys=floHys,
    damPosHys=damPosHys,
    valPosHys=valPosHys)
    "Specify system requests "
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    final kCooCon=kCooCon,
    final TiCooCon=TiCooCon,
    final kHeaCon=kHeaCon,
    final TiHeaCon=TiHeaCon,
    final timChe=timChe,
    final dTHys=dTHys,
    final conThr=conThr)
    "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Alarms
    ala(
    staPreMul=staPreMul,
    hotWatRes=hotWatRes,
    VCooZonMax_flow=VCooZonMax_flow,
    lowFloTim=lowFloTim,
    lowTemTim=lowTemTim,
    comChaTim=comChaTim,
    fanOffTim=fanOffTim,
    leaFloTim=leaFloTim,
    valCloTim=valCloTim,
    floHys=floHys,
    dTHys=dTHys,
    damPosHys=damPosHys,
    valPosHys=valPosHys)
    "Generate alarms"
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Overrides
    setOve(VZonMin_flow=VZonMin_flow, VCooZonMax_flow=VCooZonMax_flow)
    "Override setpoints"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSup(
    samplePeriod=samplePeriod,
    chaRat=chaRat,
    maxTim=maxSupTim,
    dTHys=dTHys)
    "Specify suppresion time due to the setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    have_typTerUniWitCO2=false,
    final have_parFanPowUniWitCO2=true,
    final permit_occStandby=permit_occStandby,
    final AFlo=AFlo,
    final desZonPop=desZonPop,
    final outAirRat_area=outAirRat_area,
    final outAirRat_occupant=outAirRat_occupant,
    final VZonMin_flow=VZonMin_flow,
    final VCooZonMax_flow=VCooZonMax_flow,
    final CO2Set=CO2Set,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys)
    "Minimum outdoor air and minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.DamperValves damVal(
    final dTDisZonSetMax=dTDisZonSetMax,
    final controllerTypeVal=controllerTypeVal,
    final kVal=kVal,
    final TiVal=TiVal,
    final TdVal=TdVal,
    final have_pressureIndependentDamper=have_pressureIndependentDamper,
    final V_flow_nominal=V_flow_nominal,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTHys=dTHys,
    final looHys=looHys,
    final floHys=floHys)
    "Damper and valve control"
    annotation (Placement(transformation(extent={{0,-40},{20,0}})));

equation
  connect(TZon, timSup.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          236},{-142,236}}, color={0,0,127}));
  connect(TZonCooSet, timSup.TSet) annotation (Line(points={{-200,230},{-168,230},
          {-168,244},{-142,244}}, color={0,0,127}));
  connect(TZonCooSet, conLoo.TZonCooSet) annotation (Line(points={{-200,230},{-168,
          230},{-168,206},{-142,206}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          200},{-142,200}}, color={0,0,127}));
  connect(TZonHeaSet, conLoo.TZonHeaSet) annotation (Line(points={{-200,190},{-160,
          190},{-160,194},{-142,194}}, color={0,0,127}));
  connect(uWin, setPoi.uWin) annotation (Line(points={{-200,160},{-120,160},{-120,
          139},{-102,139}}, color={255,0,255}));
  connect(uOcc, setPoi.uOcc) annotation (Line(points={{-200,130},{-132,130},{-132,
          137},{-102,137}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-200,100},{-128,100},
          {-128,134},{-102,134}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-200,70},{-124,70},{-124,
          131},{-102,131}}, color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          123},{-102,123}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-200,40},{-120,40},{-120,
          121},{-102,121}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-200,100},{-128,
          100},{-128,76},{-62,76}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccZonMin_flow) annotation (Line(
        points={{-78,134},{-72,134},{-72,64},{-62,64}}, color={0,0,127}));
  connect(VDis_flow, damVal.VDis_flow) annotation (Line(points={{-200,10},{-40,10},
          {-40,-1},{-2,-1}}, color={0,0,127}));
  connect(conLoo.yCoo, damVal.uCoo) annotation (Line(points={{-118,206},{-14,
          206},{-14,-4},{-2,-4}},
                             color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damVal.VActCooMax_flow) annotation (Line(
        points={{-38,76},{-18,76},{-18,-7},{-2,-7}},   color={0,0,127}));
  connect(TSup, damVal.TSup) annotation (Line(points={{-200,-22},{-48,-22},{-48,
          -10},{-2,-10}}, color={0,0,127}));
  connect(actAirSet.VActMin_flow, damVal.VActMin_flow) annotation (Line(points={{-38,64},
          {-22,64},{-22,-16},{-2,-16}},          color={0,0,127}));
  connect(TDis, damVal.TDis) annotation (Line(points={{-200,40},{-120,40},{-120,
          -31},{-2,-31}}, color={0,0,127}));
  connect(TSupSet, damVal.TSupSet) annotation (Line(points={{-200,-60},{-44,-60},
          {-44,-22},{-2,-22}}, color={0,0,127}));
  connect(TZonHeaSet, damVal.TZonHeaSet) annotation (Line(points={{-200,190},{-160,
          190},{-160,-25},{-2,-25}}, color={0,0,127}));
  connect(conLoo.yHea, damVal.uHea) annotation (Line(points={{-118,194},{-110,194},
          {-110,-28},{-2,-28}}, color={0,0,127}));
  connect(TZon, damVal.TZon) annotation (Line(points={{-200,260},{-164,260},{
          -164,-13},{-2,-13}},
                          color={0,0,127}));
  connect(uOpeMod, damVal.uOpeMod) annotation (Line(points={{-200,100},{-128,
          100},{-128,-34},{-2,-34}},
                                color={255,127,0}));
  connect(oveFloSet, setOve.oveFloSet) annotation (Line(points={{-200,-90},{18,
          -90},{18,-81},{58,-81}},
                              color={255,127,0}));
  connect(damVal.VDisSet_flow, setOve.VActSet_flow) annotation (Line(points={{22,-6},
          {50,-6},{50,-83},{58,-83}},     color={0,0,127}));
  connect(oveDamPos, setOve.oveDamPos) annotation (Line(points={{-200,-120},{22,
          -120},{22,-86},{58,-86}}, color={255,127,0}));
  connect(damVal.yDamSet, setOve.uDamSet) annotation (Line(points={{22,-11},{46,
          -11},{46,-88},{58,-88}}, color={0,0,127}));
  connect(uHeaOff, setOve.uHeaOff) annotation (Line(points={{-200,-150},{26,
          -150},{26,-91.8},{58,-91.8}},
                              color={255,0,255}));
  connect(damVal.yValSet, setOve.uValSet) annotation (Line(points={{22,-34},{42,
          -34},{42,-93.8},{58,-93.8}},
                                   color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-118,240},{-68,
          240},{-68,-121},{118,-121}}, color={255,0,255}));
  connect(TZonCooSet, sysReq.TZonCooSet) annotation (Line(points={{-200,230},{-168,
          230},{-168,-123},{118,-123}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-200,260},{-164,260},{-164,
          -125},{118,-125}}, color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-118,206},{-14,206},
          {-14,-127},{118,-127}}, color={0,0,127}));
  connect(setOve.VSet_flow, sysReq.VSet_flow) annotation (Line(points={{82,-83},
          {90,-83},{90,-129},{118,-129}}, color={0,0,127}));
  connect(VDis_flow, sysReq.VDis_flow) annotation (Line(points={{-200,10},{-40,10},
          {-40,-131},{118,-131}}, color={0,0,127}));
  connect(uDam, sysReq.uDam) annotation (Line(points={{-200,-180},{30,-180},{30,
          -133},{118,-133}}, color={0,0,127}));
  connect(TDis, sysReq.TDis) annotation (Line(points={{-200,40},{-120,40},{-120,
          -137},{118,-137}}, color={0,0,127}));
  connect(uVal, sysReq.uVal) annotation (Line(points={{-200,-210},{34,-210},{34,
          -139},{118,-139}}, color={0,0,127}));
  connect(VDis_flow, ala.VDis_flow) annotation (Line(points={{-200,10},{-40,10},
          {-40,-181},{118,-181}}, color={0,0,127}));
  connect(setOve.VSet_flow, ala.VActSet_flow) annotation (Line(points={{82,-83},
          {90,-83},{90,-183},{118,-183}}, color={0,0,127}));
  connect(uFan, ala.uFan) annotation (Line(points={{-200,-240},{90,-240},{90,
          -185},{118,-185}},
                       color={255,0,255}));
  connect(uDam, ala.uDam) annotation (Line(points={{-200,-180},{30,-180},{30,
          -189},{118,-189}},
                       color={0,0,127}));
  connect(uVal, ala.uVal) annotation (Line(points={{-200,-210},{34,-210},{34,
          -191},{118,-191}},
                       color={0,0,127}));
  connect(TSup, ala.TSup) annotation (Line(points={{-200,-22},{-48,-22},{-48,
          -193},{118,-193}},
                       color={0,0,127}));
  connect(uHotPla, ala.uHotPla) annotation (Line(points={{-200,-270},{94,-270},
          {94,-195},{118,-195}},color={255,0,255}));
  connect(TDis, ala.TDis) annotation (Line(points={{-200,40},{-120,40},{-120,
          -197},{118,-197}},
                       color={0,0,127}));
  connect(setOve.VSet_flow, VSet_flow) annotation (Line(points={{82,-83},{90,
          -83},{90,230},{220,230}},
                               color={0,0,127}));
  connect(setOve.yDamSet, yDamSet) annotation (Line(points={{82,-87},{98,-87},{
          98,190},{220,190}},
                           color={0,0,127}));
  connect(setOve.yValSet, yValSet) annotation (Line(points={{82,-93},{104,-93},
          {104,150},{220,150}},color={0,0,127}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{142,-122},
          {146,-122},{146,110},{220,110}}, color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{142,-127},
          {150,-127},{150,70},{220,70}}, color={255,127,0}));
  connect(sysReq.yHeaValResReq, yHeaValResReq) annotation (Line(points={{142,-133},
          {154,-133},{154,30},{220,30}}, color={255,127,0}));
  connect(sysReq.yHotWatPlaReq, yHotWatPlaReq) annotation (Line(points={{142,-138},
          {158,-138},{158,-10},{220,-10}}, color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{142,-181},{168,
          -181},{168,-60},{220,-60}},
                                color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{142,-184},{172,
          -184},{172,-100},{220,-100}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{142,-192},{176,
          -192},{176,-140},{220,-140}},
                                  color={255,127,0}));
  connect(ala.yLeaValAla, yLeaValAla) annotation (Line(points={{142,-195},{180,
          -195},{180,-180},{220,-180}},
                                  color={255,127,0}));
  connect(ala.yLowTemAla, yLowTemAla) annotation (Line(points={{142,-199},{180,
          -199},{180,-220},{220,-220}},
                                  color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
            {100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,16},{-54,4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,36},{-72,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,66},{-54,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-98,-2},{-72,-14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-98,-24},{-56,-36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSupSet"),
        Text(
          extent={{-98,-114},{-72,-126}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uDam"),
        Text(
          extent={{-98,-134},{-72,-146}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uVal"),
        Text(
          extent={{-98,198},{-72,186}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,178},{-40,164}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{-98,158},{-40,144}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          visible=have_winSen,
          extent={{-98,128},{-72,116}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          visible=have_occSen,
          extent={{-98,108},{-72,96}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-96,-180},{-60,-196}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHotPla"),
        Text(
          extent={{-98,-162},{-72,-174}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uFan"),
        Text(
          extent={{-98,-94},{-62,-110}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHeaOff"),
        Text(
          extent={{-96,88},{-50,72}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-50},{-52,-66}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-70},{-40,-86}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{54,198},{96,186}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{56,168},{98,156}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDamSet"),
        Text(
          extent={{56,138},{98,126}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yValSet"),
        Text(
          extent={{18,92},{96,74}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonTemResReq"),
        Text(
          extent={{18,62},{96,44}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonPreResReq"),
        Text(
          extent={{18,32},{96,14}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHeaValResReq"),
        Text(
          extent={{18,2},{96,-16}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotWatPlaReq"),
        Text(
          extent={{42,-50},{98,-68}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{40,-78},{98,-96}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{40,-108},{98,-126}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          extent={{44,-138},{98,-156}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaValAla"),
        Text(
          extent={{36,-168},{98,-186}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowTemAla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-280},{200,280}})),
  Documentation(info="<html>
<p>
Controller for terminal box of VAV system with reheat according to Section 5.6 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow</code>,
damper position setpoint <code>yDamSet</code>, hot water valve position setpoint
<code>yValSet</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>, hot water reset request <code>yHeaValResReq</code>
and <code>yHotWatPlaReq</code>. It also outputs the alarms about the low airflow
<code>yLowFloAla</code>, low discharge temperature <code>yLowTemAla</code>,
leaking damper <code>yLeaDamAla</code> and valve <code>yLeaValAla</code>, and
airflow sensor calibration alarm <code>yFloSenAla</code>.
</p>
<p>The sequence consists of four subsequences. </p>
<h4>a. Heating and cooling control loop</h4>
<p>
The subsequence is implementd according to Section 5.3.4. The measured zone
temperature <code>TZon</code>, zone setpoints temperatures <code>TZonHeaSet</code> and
<code>TZonCooSet</code> are inputs to the instance of class 
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
zone temperature, the sequence outputs <code>yDamSet</code>, <code>yValSet</code>,
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
end Controller_new;
