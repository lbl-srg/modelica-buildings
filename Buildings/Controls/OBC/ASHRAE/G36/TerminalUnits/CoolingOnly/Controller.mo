within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly;
block Controller "Controller for cooling only VAV box"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard venStd
    "Ventilation standard, ASHRAE 62.1 or Title 24";
  parameter Boolean have_winSen=true
    "True: the zone has window sensor";
  parameter Boolean have_occSen=true
    "True: the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=true
    "True: the zone has CO2 sensor";
  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation (Dialog(enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
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
  // ---------------- Damper control parameters ----------------
  parameter CDL.Types.SimpleController damCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Damper control", group="Controller"));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (Dialog(tab="Damper control", group="Controller"));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (Dialog(tab="Damper control", group="Controller",
      enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(tab="Damper control", group="Controller",
      enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
// ---------------- System request parameters ----------------
  parameter Real thrTemDif(unit="K")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real twoTemDif(unit="K")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (Dialog(tab="System requests"));
  parameter Real durTimTem(unit="s")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimFlo(unit="s")=60
    "Duration time of airflow rate less than setpoint"
    annotation (Dialog(tab="System requests", group="Duration time"));
// ---------------- Parameters for alarms ----------------
  parameter Real staPreMul=1
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (Dialog(tab="Alarms"));
  parameter Real lowFloTim(unit="s")=300
    "Threshold time to check low flow rate"
    annotation (Dialog(tab="Alarms"));
  parameter Real fanOffTim(unit="s")=600
    "Threshold time to check fan off"
    annotation (Dialog(tab="Alarms"));
  parameter Real leaFloTim(unit="s")=600
    "Threshold time to check damper leaking airflow"
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
  parameter Real floHys(unit="m3/s")=0.01*VMin_flow
    "Near zero flow rate, below which the flow rate or difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real looHys(unit="1")=0.01
    "Loop output hysteresis below which the output will be seen as zero"
    annotation (Dialog(tab="Advanced"));
  parameter Real damPosHys(unit="1")=0.005
    "Near zero damper position, below which the damper will be seen as closed"
    annotation (Dialog(tab="Advanced"));
  parameter Real timChe(unit="s")=30
    "Threshold time to check the zone temperature status"
    annotation (Dialog(tab="Advanced", group="Control loops"));
  parameter Real zonDisEff_cool(unit="1")=1.0
    "Zone cooling air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));
  parameter Real zonDisEff_heat(unit="1")=0.8
    "Zone heating air distribution effectiveness"
    annotation (Dialog(tab="Advanced", group="Distribution effectiveness",
                       enable=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-220,230},{-180,270}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-220,200},{-180,240}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-220,160},{-180,200}}),
        iconTransformation(extent={{-140,120},{-100,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-220,70},{-180,110}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-220,10},{-180,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-220,-130},{-180,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Discharge airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final unit="1") "Damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{200,-60},{240,-20}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{200,160},{240,200}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{200,130},{240,170}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,100},{240,140}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,70},{240,110}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{200,40},{240,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{200,10},{240,50}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{200,-100},{240,-60}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{200,-190},{240,-150}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{200,-230},{240,-190}}),
        iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    "Leaking damper alarm"
    annotation (Placement(transformation(extent={{200,-270},{240,-230}}),
        iconTransformation(extent={{100,-180},{140,-140}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow actAirSet(
    final VCooMax_flow=VCooMax_flow) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests sysReq(
    final thrTemDif=thrTemDif,
    final twoTemDif=twoTemDif,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final dTHys=dTHys,
    final floHys=floHys,
    final looHys=looHys,
    final damPosHys=damPosHys,
    final samplePeriod=samplePeriod) "Specify system requests "
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    final kCooCon=kCooCon,
    final TiCooCon=TiCooCon,
    final kHeaCon=kHeaCon,
    final TiHeaCon=TiHeaCon,
    final timChe=timChe,
    final dTHys=dTHys,
    final looHys=looHys) "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms ala(
    final staPreMul=staPreMul,
    final VCooMax_flow=VCooMax_flow,
    final lowFloTim=lowFloTim,
    final fanOffTim=fanOffTim,
    final leaFloTim=leaFloTim,
    final floHys=floHys,
    final damPosHys=damPosHys) "Generate alarms"
    annotation (Placement(transformation(extent={{120,-220},{140,-200}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSup(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints setPoi(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers
    dam(
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final damCon=damCon,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTHys=dTHys) "Damper control"
    annotation (Placement(transformation(extent={{60,-60},{80,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ZoneStates zonSta
    "Check if the zone is in cooling state"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final have_parFanPowUni=false,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(TZon, timSup.TZon) annotation (Line(points={{-200,250},{-144,250},{
          -144,216},{-102,216}}, color={0,0,127}));
  connect(TCooSet, timSup.TSet) annotation (Line(points={{-200,220},{-150,220},
          {-150,224},{-102,224}},color={0,0,127}));
  connect(TCooSet, conLoo.TCooSet) annotation (Line(points={{-200,220},{-150,
          220},{-150,186},{-102,186}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-200,250},{-144,250},{
          -144,180},{-102,180}}, color={0,0,127}));
  connect(THeaSet, conLoo.THeaSet) annotation (Line(points={{-200,180},{-156,
          180},{-156,174},{-102,174}}, color={0,0,127}));
  connect(u1Win, setPoi.u1Win) annotation (Line(points={{-200,150},{-126,150},{
          -126,119},{-102,119}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-200,120},{-132,120},{
          -132,117},{-102,117}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-200,90},{-138,90},
          {-138,115},{-102,115}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-200,30},{-156,30},{
          -156,111},{-102,111}}, color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-200,250},{-144,250},{
          -144,103},{-102,103}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-200,0},{-120,0},{-120,
          101},{-102,101}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-200,90},{-138,90},
          {-138,20},{-22,20}},      color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,114},{-60,114},{-60,14},{-22,14}}, color={0,0,127}));
  connect(VDis_flow, dam.VDis_flow) annotation (Line(points={{-200,-80},{-138,
          -80},{-138,-54},{58,-54}}, color={0,0,127}));
  connect(conLoo.yCoo, dam.uCoo) annotation (Line(points={{-78,186},{-50,186},{
          -50,-31},{58,-31}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, dam.VActCooMax_flow) annotation (Line(
        points={{2,26},{28,26},{28,-34},{58,-34}},     color={0,0,127}));
  connect(TSup, dam.TSup)
    annotation (Line(points={{-200,-40},{22,-40},{22,-25},{58,-25}}, color={0,0,127}));
  connect(actAirSet.VActMin_flow, dam.VActMin_flow) annotation (Line(points={{2,20},{
          34,20},{34,-22},{58,-22}}, color={0,0,127}));
  connect(TZon, dam.TZon) annotation (Line(points={{-200,250},{-144,250},{-144,
          -28},{58,-28}}, color={0,0,127}));
  connect(timSup.yAftSup, sysReq.uAftSup) annotation (Line(points={{-78,220},{
          100,220},{100,-141},{118,-141}}, color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-200,220},{-150,
          220},{-150,-144},{118,-144}}, color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-200,250},{-144,250},{
          -144,-146},{118,-146}}, color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-78,186},{-50,186},
          {-50,-148},{118,-148}}, color={0,0,127}));
  connect(VDis_flow, sysReq.VDis_flow) annotation (Line(points={{-200,-80},{
          -138,-80},{-138,-156},{118,-156}}, color={0,0,127}));
  connect(VDis_flow, ala.VDis_flow) annotation (Line(points={{-200,-80},{-138,
          -80},{-138,-202},{118,-202}}, color={0,0,127}));
  connect(u1Fan, ala.u1Fan) annotation (Line(points={{-200,-240},{100,-240},{100,
          -214},{118,-214}}, color={255,0,255}));
  connect(sysReq.yZonTemResReq, yZonTemResReq) annotation (Line(points={{142,-144},
          {160,-144},{160,-80},{220,-80}}, color={255,127,0}));
  connect(sysReq.yZonPreResReq, yZonPreResReq) annotation (Line(points={{142,-156},
          {170,-156},{170,-120},{220,-120}},  color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{142,-204},{180,-204},
          {180,-170},{220,-170}}, color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{142,-210},{220,-210}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{142,-216},{180,-216},
          {180,-250},{220,-250}}, color={255,127,0}));
  connect(conLoo.yHea, zonSta.uHea) annotation (Line(points={{-78,174},{-40,174},
          {-40,144},{-22,144}}, color={0,0,127}));
  connect(conLoo.yCoo, zonSta.uCoo) annotation (Line(points={{-78,186},{-50,186},
          {-50,136},{-22,136}}, color={0,0,127}));
  connect(zonSta.yZonSta, dam.uZonSta) annotation (Line(points={{2,140},{40,140},
          {40,-40},{58,-40}},  color={255,127,0}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-200,60},{-162,
          60},{-162,113},{-102,113}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-200,150},{-126,150},{
          -126,79},{-102,79}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-200,120},{-132,120},{
          -132,76},{-102,76}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-200,90},{-138,90},
          {-138,73},{-102,73}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set) annotation (Line(points={{-200,60},{-162,
          60},{-162,70},{-102,70}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-200,30},{-156,30},{
          -156,67},{-102,67}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-78,67},{-60,67},{-60,14},{-22,14}}, color={0,0,127}));
  connect(dam.VSet_flow, sysReq.VSet_flow) annotation (Line(points={{82,-31},{
          94,-31},{94,-153},{118,-153}}, color={0,0,127}));
  connect(dam.VSet_flow, ala.VActSet_flow) annotation (Line(points={{82,-31},{
          94,-31},{94,-206},{118,-206}}, color={0,0,127}));
  connect(oveFloSet, dam.oveFloSet) annotation (Line(points={{-200,-110},{-6,
          -110},{-6,-49},{58,-49}}, color={255,127,0}));
  connect(oveDamPos, dam.oveDamPos) annotation (Line(points={{-200,-140},{0,
          -140},{0,-58},{58,-58}}, color={255,127,0}));
  connect(dam.VSet_flow, VSet_flow) annotation (Line(points={{82,-31},{94,-31},{
          94,0},{220,0}},    color={0,0,127}));
  connect(dam.yDam, yDam) annotation (Line(points={{82,-49},{106,-49},{106,-40},
          {220,-40}}, color={0,0,127}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-78,118},{80,118},{80,180},{220,180}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow) annotation (Line(
        points={{-78,110},{86,110},{86,150},{220,150}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-78,106},{92,
          106},{92,120},{220,120}}, color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{-78,
          79},{86,79},{86,90},{220,90}}, color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{-78,
          76},{86,76},{86,60},{220,60}}, color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-78,64},{80,64},{80,30},{
          220,30}}, color={0,0,127}));
  connect(dam.yDam, sysReq.uDam) annotation (Line(points={{82,-49},{106,-49},{
          106,-159},{118,-159}}, color={0,0,127}));
  connect(dam.yDam, ala.uDam) annotation (Line(points={{82,-49},{106,-49},{106,
          -218},{118,-218}}, color={0,0,127}));
annotation (defaultComponentName="cooBoxCon",
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
          extent={{-96,-24},{-54,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-98,16},{-72,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-94,56},{-52,44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{-98,-2},{-72,-14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-100,190},{-72,176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,168},{-50,154}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSet"),
        Text(
          extent={{-98,148},{-52,134}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          visible=have_winSen,
          extent={{-100,120},{-70,106}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-100,100},{-70,86}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-100,-174},{-74,-186}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan"),
        Text(
          extent={{-96,78},{-50,62}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-70},{-52,-86}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-98,-90},{-40,-106}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{54,188},{96,176}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{70,158},{98,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam"),
        Text(
          extent={{18,-28},{96,-46}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonTemResReq"),
        Text(
          extent={{18,-58},{96,-76}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonPreResReq"),
        Text(
          extent={{42,-90},{98,-108}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{40,-118},{98,-136}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla"),
        Text(
          extent={{40,-148},{98,-166}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla"),
        Text(
          visible=have_CO2Sen,
          extent={{-100,40},{-58,28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{12,130},{96,112}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{12,110},{96,92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{36,90},{96,70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{18,70},{96,50}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{18,48},{96,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{66,26},{96,10}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-280},{200,280}})),
  Documentation(info="<html>
<p>
Controller for cooling only terminal box according to Section 5.5 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow</code>,
damper position setpoint <code>yDam</code>, AHU cooling supply temperature
setpoint reset request <code>yZonTemResReq</code>, and static pressure setpoint
reset request <code>yZonPreResReq</code>. It also outputs the alarms about the low airflow
<code>yLowFloAla</code>, leaking damper <code>yLeaDamAla</code>, and
airflow sensor calibration alarm <code>yFloSenAla</code>.
</p>
<p>The sequence consists of six subsequences.</p>
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
Section 5.5.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling supply. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Damper control</h4>
<p>
This sequence sets the damper position setpoints for the terminal unit.
The implementation is according to Section 5.5.5. According to heating and cooling
control loop signal, along with the active maximum and minimum airflow setpoint, measured
zone temperature, the sequence outputs damper position setpoint, and active airflow rate setpoint.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.5.8, this sequence outputs the system reset requests, i.e.
cooling supply air temperature reset requests <code>yZonTemResReq</code>,
static pressure reset requests <code>yZonPreResReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.5.6, this sequence outputs the alarms of low discharge flow,
leaking damper and airflow sensor calibration
alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.5.7, this sequence allows the override the aiflow setpoints,
damper position setpoints.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers</a>.
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
