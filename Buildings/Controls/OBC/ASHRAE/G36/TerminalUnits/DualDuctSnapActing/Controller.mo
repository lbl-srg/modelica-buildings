within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing;
block Controller "Controller for snap-acting controlled dual-duct terminal unit"

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
  parameter Boolean have_duaSen
    "True: the unit has dual inlet flow sensor";
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
  parameter Real VHeaMax_flow(unit="m3/s")
    "Design zone heating maximum airflow rate"
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
  // ---------------- Dampers control parameters ----------------
  parameter CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Dampers"));
  parameter Real kDam=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Dampers"));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Dampers",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Dampers",
      enable=(controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
           or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  // ---------------- System request parameters ----------------
  parameter Real thrTemDif(unit="K")=3
    "Threshold difference between zone temperature and cooling setpoint for generating 3 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests"));
  parameter Real twoTemDif(unit="K")=2
    "Threshold difference between zone temperature and cooling setpoint for generating 2 cooling SAT reset requests"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests"));
  parameter Real durTimTem(unit="s")=120
    "Duration time of zone temperature exceeds setpoint"
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests", group="Duration time"));
  parameter Real durTimFlo(unit="s")=60
    "Duration time of airflow rate less than setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="System requests", group="Duration time"));
  // ---------------- Parameters for alarms ----------------
  parameter Real staPreMul=1
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Alarms"));
  parameter Real lowFloTim(unit="s")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real lowTemTim(unit="s")=600
    "Threshold time to check low discharge temperature"
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
  parameter Real staTim(
    final unit="s",
    final quantity="Time")=1800
    "Delay time after AHU supply fan has been enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniCooDam(unit="1")=0.01
    "Initial cooling damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniHeaDam(unit="1")=0.01
    "Initial heating damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real timChe(unit="s")=30
    "Threshold time to check the zone temperature status"
    annotation (__cdl(ValueInReference=true),
                Dialog(tab="Advanced", group="Control loops"));
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
  parameter Real samplePeriod(unit="s")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Time-based suppresion"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-280,280},{-240,320}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Setpoint temperature for room for cooling"
    annotation (Placement(transformation(extent={{-280,250},{-240,290}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Setpoint temperature for room for heating"
    annotation (Placement(transformation(extent={{-280,220},{-240,260}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-280,170},{-240,210}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-280,150},{-240,190}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-280,90},{-240,130}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,30},{-240,70}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") if have_duaSen
    "Cold duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-280,0},{-240,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if have_duaSen
    "Measured cold-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-30},{-240,10}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooAHU
    "Cooling air handler status"
    annotation (Placement(transformation(extent={{-280,-60},{-240,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") if have_duaSen
    "Hot duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-280,-90},{-240,-50}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if have_duaSen
    "Measured hot-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-120},{-240,-80}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-280,-150},{-240,-110}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") if not have_duaSen
    "Measured discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-280,-210},{-240,-170}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveCooDamPos
    "Index of overriding cooling damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveHeaDamPos
    "Index of overriding heating damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-270},{-240,-230}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{240,290},{280,330}}),
        iconTransformation(extent={{100,180},{140,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{240,260},{280,300}}),
        iconTransformation(extent={{100,160},{140,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1")
    "Heating damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{240,230},{280,270}}),
        iconTransformation(extent={{100,140},{140,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,190},{280,230}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,130},{280,170}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,70},{280,110}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{240,40},{280,80}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonCooTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,0},{280,40}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColDucPreResReq
    "Cold duct pressure reset requests"
    annotation (Placement(transformation(extent={{240,-30},{280,10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonHeaTemResReq
    "Zone heating supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,-60},{280,-20}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotDucPreResReq
    "Hot duct pressure reset requests"
    annotation (Placement(transformation(extent={{240,-90},{280,-50}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaFanReq
    "Heating fan request"
    annotation (Placement(transformation(extent={{240,-120},{280,-80}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,-150},{280,-110}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFloSenAla
    if not have_duaSen
    "Airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-180},{280,-140}}),
        iconTransformation(extent={{100,-120},{140,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLeaDamAla
    if not have_duaSen
    "Leaking dampers alarm, could be heating or cooling damper"
    annotation (Placement(transformation(extent={{240,-210},{280,-170}}),
        iconTransformation(extent={{100,-140},{140,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColFloSenAla if have_duaSen
    "Cold-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-240},{280,-200}}),
        iconTransformation(extent={{100,-160},{140,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColLeaDamAla if have_duaSen
    "Leaking cold-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-270},{280,-230}}),
        iconTransformation(extent={{100,-180},{140,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotFloSenAla if have_duaSen
    "Hot-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-300},{280,-260}}),
        iconTransformation(extent={{100,-200},{140,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotLeaDamAla if have_duaSen
    "Leaking hot-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-330},{280,-290}}),
        iconTransformation(extent={{100,-220},{140,-180}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.ActiveAirFlow
    actAirSet(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests
    sysReq(
    final have_duaSen=have_duaSen,
    final thrTemDif=thrTemDif,
    final twoTemDif=twoTemDif,
    final durTimTem=durTimTem,
    final durTimFlo=durTimFlo,
    final dTHys=dTHys,
    final floHys=floHys,
    final looHys=looHys,
    final damPosHys=damPosHys) "Specify system requests "
    annotation (Placement(transformation(extent={{140,-160},{160,-120}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    final kCooCon=kCooCon,
    final TiCooCon=TiCooCon,
    final kHeaCon=kHeaCon,
    final TiHeaCon=TiHeaCon,
    final timChe=timChe,
    final dTHys=dTHys,
    final looHys=looHys) "Heating and cooling control loop"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms
    ala(
    final have_duaSen=have_duaSen,
    final staPreMul=staPreMul,
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final lowFloTim=lowFloTim,
    final fanOffTim=fanOffTim,
    final leaFloTim=leaFloTim,
    final floHys=floHys,
    final damPosHys=damPosHys,
    final staTim=staTim)       "Generate alarms"
    annotation (Placement(transformation(extent={{140,-240},{160,-200}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Overrides
    setOve(
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow) "Override setpoints"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSupCoo(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the zone cooling setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-200,280},{-180,300}})));
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
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersDualSensors damDuaSen(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final samplePeriod=samplePeriod,
    final dTHys=dTHys,
    final looHys=looHys,
    final iniDam=iniDam) if have_duaSen
    "Dampers control when the unit has single dual airflow sensor"
    annotation (Placement(transformation(extent={{-2,0},{18,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors damSinSen(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final samplePeriod=samplePeriod,
    final looHys=looHys,
    final iniDam=iniDam) if not have_duaSen
    "Dampers control when the unit has single discharge airflow sensor"
    annotation (Placement(transformation(extent={{0,-60},{20,-20}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSupHea(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the zone heating setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-200,240},{-180,260}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Output the minimum outdoor airflow rate setpoint, when using Title 24"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
equation
  connect(TZon, timSupCoo.TZon) annotation (Line(points={{-260,300},{-220,300},{
          -220,286},{-202,286}}, color={0,0,127}));
  connect(TZon, timSupHea.TZon) annotation (Line(points={{-260,300},{-220,300},{
          -220,246},{-202,246}}, color={0,0,127}));
  connect(TCooSet, timSupCoo.TSet) annotation (Line(points={{-260,270},{-226,270},
          {-226,294},{-202,294}}, color={0,0,127}));
  connect(THeaSet, timSupHea.TSet) annotation (Line(points={{-260,240},{-214,240},
          {-214,254},{-202,254}}, color={0,0,127}));
  connect(TCooSet, conLoo.TCooSet) annotation (Line(points={{-260,270},{-226,270},
          {-226,216},{-202,216}}, color={0,0,127}));
  connect(TZon, conLoo.TZon) annotation (Line(points={{-260,300},{-220,300},{-220,
          210},{-202,210}}, color={0,0,127}));
  connect(THeaSet, conLoo.THeaSet) annotation (Line(points={{-260,240},{-214,240},
          {-214,204},{-202,204}}, color={0,0,127}));
  connect(u1Win, setPoi.u1Win) annotation (Line(points={{-260,190},{-180,190},{
          -180,169},{-162,169}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-260,170},{-184,170},{
          -184,167},{-162,167}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-260,140},{-200,140},
          {-200,165},{-162,165}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-260,80},{-192,80},{-192,
          161},{-162,161}},       color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-260,300},{-220,300},{-220,
          153},{-162,153}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-260,50},{-188,50},{-188,
          151},{-162,151}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-260,140},{-200,
          140},{-200,72},{-82,72}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-138,164},{-120,164},{-120,88},{-82,88}}, color={0,0,127}));
  connect(conLoo.yCoo, damDuaSen.uCoo) annotation (Line(points={{-178,216},{-28,
          216},{-28,39},{-4,39}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damDuaSen.VActCooMax_flow) annotation (
      Line(points={{-58,88},{-20,88},{-20,36},{-4,36}}, color={0,0,127}));
  connect(VColDucDis_flow, damDuaSen.VColDucDis_flow) annotation (Line(points={{-260,
          -10},{-60,-10},{-60,30},{-4,30}},    color={0,0,127}));
  connect(u1CooAHU, damDuaSen.u1CooAHU) annotation (Line(points={{-260,-40},{
          -44,-40},{-44,27},{-4,27}},
                             color={255,0,255}));
  connect(actAirSet.VActMin_flow, damDuaSen.VActMin_flow) annotation (Line(
        points={{-58,80},{-24,80},{-24,22},{-4,22}}, color={0,0,127}));
  connect(TZon, damDuaSen.TZon) annotation (Line(points={{-260,300},{-220,300},
          {-220,18},{-4,18}},color={0,0,127}));
  connect(conLoo.yHea, damDuaSen.uHea) annotation (Line(points={{-178,204},{-32,
          204},{-32,10},{-4,10}}, color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damDuaSen.VActHeaMax_flow) annotation (
      Line(points={{-58,72},{-36,72},{-36,7},{-4,7}}, color={0,0,127}));
  connect(VHotDucDis_flow, damDuaSen.VHotDucDis_flow) annotation (Line(points={{-260,
          -100},{-48,-100},{-48,4},{-4,4}},    color={0,0,127}));
  connect(u1HeaAHU, damDuaSen.u1HeaAHU) annotation (Line(points={{-260,-130},{
          -40,-130},{-40,1},{-4,1}},
                                 color={255,0,255}));
  connect(conLoo.yCoo, damSinSen.uCoo) annotation (Line(points={{-178,216},{-28,
          216},{-28,-21},{-2,-21}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damSinSen.VActCooMax_flow) annotation (
      Line(points={{-58,88},{-20,88},{-20,-24},{-2,-24}}, color={0,0,127}));
  connect(actAirSet.VActMin_flow, damSinSen.VActMin_flow) annotation (Line(
        points={{-58,80},{-24,80},{-24,-27},{-2,-27}}, color={0,0,127}));
  connect(conLoo.yHea, damSinSen.uHea) annotation (Line(points={{-178,204},{-32,
          204},{-32,-30},{-2,-30}}, color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damSinSen.VActHeaMax_flow) annotation (
      Line(points={{-58,72},{-36,72},{-36,-33},{-2,-33}}, color={0,0,127}));
  connect(u1CooAHU, damSinSen.u1CooAHU) annotation (Line(points={{-260,-40},{-44,-40},
          {-44,-55},{-2,-55}}, color={255,0,255}));
  connect(u1HeaAHU, damSinSen.u1HeaAHU) annotation (Line(points={{-260,-130},{-40,
          -130},{-40,-58},{-2,-58}}, color={255,0,255}));
  connect(oveFloSet, setOve.oveFloSet) annotation (Line(points={{-260,-190},{0,-190},
          {0,-82},{58,-82}}, color={255,127,0}));
  connect(oveCooDamPos, setOve.oveCooDamPos) annotation (Line(points={{-260,-220},
          {4,-220},{4,-90},{58,-90}}, color={255,127,0}));
  connect(oveHeaDamPos, setOve.oveHeaDamPos) annotation (Line(points={{-260,-250},
          {8,-250},{8,-96},{58,-96}}, color={255,127,0}));
  connect(damDuaSen.yCooDam, setOve.uCooDam) annotation (Line(points={{20,29},{
          44,29},{44,-93},{58,-93}},      color={0,0,127}));
  connect(damDuaSen.yHeaDam, setOve.uHeaDam) annotation (Line(points={{20,6},{
          40,6},{40,-99},{58,-99}},     color={0,0,127}));
  connect(damSinSen.VDis_flow_Set, setOve.VActSet_flow) annotation (Line(points=
         {{22,-26},{36,-26},{36,-85},{58,-85}}, color={0,0,127}));
  connect(damDuaSen.VDis_flow_Set, setOve.VActSet_flow) annotation (Line(points={{20,38},
          {36,38},{36,-85},{58,-85}},         color={0,0,127}));
  connect(timSupCoo.yAftSup, sysReq.uAftSupCoo) annotation (Line(points={{-178,
          290},{-100,290},{-100,-121},{138,-121}},
                                             color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-260,270},{-226,
          270},{-226,-124},{138,-124}},
                                  color={0,0,127}));
  connect(TZon, sysReq.TZon) annotation (Line(points={{-260,300},{-220,300},{
          -220,-127},{138,-127}},
                            color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-178,216},{-28,
          216},{-28,-130},{138,-130}},
                                 color={0,0,127}));
  connect(damDuaSen.VDis_flow_Set, sysReq.VColDuc_flow_Set) annotation (Line(
        points={{20,38},{36,38},{36,-133},{138,-133}},color={0,0,127}));
  connect(timSupHea.yAftSup, sysReq.uAftSupHea) annotation (Line(points={{-178,
          250},{-104,250},{-104,-143},{138,-143}},
                                             color={255,0,255}));
  connect(THeaSet, sysReq.THeaSet) annotation (Line(points={{-260,240},{-214,
          240},{-214,-146},{138,-146}},
                                  color={0,0,127}));
  connect(conLoo.yHea, sysReq.uHea) annotation (Line(points={{-178,204},{-32,
          204},{-32,-149},{138,-149}},
                                 color={0,0,127}));
  connect(damDuaSen.VDis_flow_Set, sysReq.VHotDuc_flow_Set) annotation (Line(
        points={{20,38},{36,38},{36,-152},{138,-152}},color={0,0,127}));
  connect(VColDucDis_flow, sysReq.VColDucDis_flow) annotation (Line(points={{-260,
          -10},{-60,-10},{-60,-135},{138,-135}},color={0,0,127}));
  connect(VHotDucDis_flow, sysReq.VHotDucDis_flow) annotation (Line(points={{-260,
          -100},{-48,-100},{-48,-154},{138,-154}}, color={0,0,127}));
  connect(VDis_flow, damSinSen.VDis_flow) annotation (Line(points={{-260,-160},{
          -56,-160},{-56,-52},{-2,-52}}, color={0,0,127}));
  connect(VDis_flow, sysReq.VColDucDis_flow) annotation (Line(points={{-260,
          -160},{-52,-160},{-52,-135},{138,-135}},
                                           color={0,0,127}));
  connect(VDis_flow, sysReq.VHotDucDis_flow) annotation (Line(points={{-260,
          -160},{-52,-160},{-52,-154},{138,-154}},
                                           color={0,0,127}));
  connect(damSinSen.y1CooDam, sysReq.u1CooDam) annotation (Line(points={{22,-50},
          {32,-50},{32,-140},{138,-140}},color={255,0,255}));
  connect(damSinSen.y1HeaDam, sysReq.u1HeaDam) annotation (Line(points={{22,-56},
          {28,-56},{28,-159},{138,-159}},color={255,0,255}));
  connect(VColDucDis_flow, ala.VColDucDis_flow) annotation (Line(points={{-260,
          -10},{-60,-10},{-60,-212},{138,-212}},
                                          color={0,0,127}));
  connect(u1CooAHU, ala.u1CooFan) annotation (Line(points={{-260,-40},{-44,-40},
          {-44,-215},{138,-215}},
                            color={255,0,255}));
  connect(VHotDucDis_flow, ala.VHotDucDis_flow) annotation (Line(points={{-260,
          -100},{-48,-100},{-48,-231},{138,-231}},
                                           color={0,0,127}));
  connect(u1HeaAHU, ala.u1HeaFan) annotation (Line(points={{-260,-130},{-40,
          -130},{-40,-234},{138,-234}},
                                 color={255,0,255}));
  connect(VDis_flow, ala.VDis_flow) annotation (Line(points={{-260,-160},{-56,
          -160},{-56,-202},{138,-202}},
                                 color={0,0,127}));
  connect(setOve.VSet_flow, VSet_flow) annotation (Line(points={{82,-84},{100,-84},
          {100,310},{260,310}}, color={0,0,127}));
  connect(setOve.yCooDam, yCooDam) annotation (Line(points={{82,-90},{106,-90},{
          106,280},{260,280}},       color={0,0,127}));
  connect(setOve.yHeaDam, yHeaDam) annotation (Line(points={{82,-96},{112,-96},{
          112,250},{260,250}},       color={0,0,127}));
  connect(sysReq.yZonCooTemResReq, yZonCooTemResReq) annotation (Line(points={{162,
          -132},{166,-132},{166,20},{260,20}},   color={255,127,0}));
  connect(sysReq.yColDucPreResReq, yColDucPreResReq) annotation (Line(points={{162,
          -137},{172,-137},{172,-10},{260,-10}}, color={255,127,0}));
  connect(sysReq.yZonHeaTemResReq, yZonHeaTemResReq) annotation (Line(points={{162,
          -143},{178,-143},{178,-40},{260,-40}}, color={255,127,0}));
  connect(sysReq.yHotDucPreResReq, yHotDucPreResReq) annotation (Line(points={{162,
          -148},{184,-148},{184,-70},{260,-70}}, color={255,127,0}));
  connect(sysReq.yHeaFanReq, yHeaFanReq) annotation (Line(points={{162,-158},{
          190,-158},{190,-100},{260,-100}},
                                        color={255,127,0}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{162,-202},{196,
          -202},{196,-130},{260,-130}},
                                  color={255,127,0}));
  connect(ala.yFloSenAla, yFloSenAla) annotation (Line(points={{162,-207},{202,
          -207},{202,-160},{260,-160}},
                                  color={255,127,0}));
  connect(ala.yLeaDamAla, yLeaDamAla) annotation (Line(points={{162,-210},{208,
          -210},{208,-190},{260,-190}},
                                  color={255,127,0}));
  connect(ala.yColFloSenAla, yColFloSenAla) annotation (Line(points={{162,-227},
          {214,-227},{214,-220},{260,-220}}, color={255,127,0}));
  connect(ala.yColLeaDamAla, yColLeaDamAla) annotation (Line(points={{162,-230},
          {212,-230},{212,-250},{260,-250}}, color={255,127,0}));
  connect(ala.yHotFloSenAla, yHotFloSenAla) annotation (Line(points={{162,-234},
          {206,-234},{206,-280},{260,-280}}, color={255,127,0}));
  connect(ala.yHotLeaDamAla, yHotLeaDamAla) annotation (Line(points={{162,-237},
          {200,-237},{200,-310},{260,-310}}, color={255,127,0}));
  connect(damSinSen.VDis_flow_Set, sysReq.VColDuc_flow_Set) annotation (Line(
        points={{22,-26},{36,-26},{36,-133},{138,-133}},color={0,0,127}));
  connect(damSinSen.VDis_flow_Set, sysReq.VHotDuc_flow_Set) annotation (Line(
        points={{22,-26},{36,-26},{36,-152},{138,-152}},color={0,0,127}));
  connect(setOve.VSet_flow, ala.VActSet_flow) annotation (Line(points={{82,-84},
          {90,-84},{90,-205},{138,-205}},color={0,0,127}));
  connect(damDuaSen.TColSup, TColSup) annotation (Line(points={{-4,33},{-40,33},
          {-40,20},{-260,20}}, color={0,0,127}));
  connect(damDuaSen.THotSup, THotSup) annotation (Line(points={{-4,13},{-56,13},
          {-56,-70},{-260,-70}}, color={0,0,127}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-260,110},{-196,
          110},{-196,163},{-162,163}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-138,107},{-120,107},{-120,88},{-82,88}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-260,190},{-180,190},{
          -180,119},{-162,119}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-260,170},{-184,170},{
          -184,116},{-162,116}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-260,140},{-200,140},
          {-200,113},{-162,113}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set)
    annotation (Line(points={{-260,110},{-162,110}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-260,80},{-192,80},{-192,
          107},{-162,107}}, color={0,0,127}));
  connect(damSinSen.yHeaDam, setOve.uHeaDam) annotation (Line(points={{22,-58},{
          40,-58},{40,-99},{58,-99}}, color={0,0,127}));
  connect(damSinSen.yCooDam, setOve.uCooDam) annotation (Line(points={{22,-52},{
          44,-52},{44,-93},{58,-93}}, color={0,0,127}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-138,168},{60,168},{60,210},{260,210}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-138,156},{
          66,156},{66,150},{260,150}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow) annotation (Line(
        points={{-138,160},{66,160},{66,180},{260,180}}, color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{-138,
          119},{66,119},{66,120},{260,120}}, color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{-138,
          116},{66,116},{66,90},{260,90}}, color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-138,104},{60,104},{60,60},
          {260,60}}, color={0,0,127}));
  connect(setOve.yCooDam, sysReq.uCooDam) annotation (Line(points={{82,-90},{
          106,-90},{106,-138},{138,-138}}, color={0,0,127}));
  connect(setOve.yCooDam, ala.uCooDam) annotation (Line(points={{82,-90},{106,
          -90},{106,-218},{138,-218}}, color={0,0,127}));
  connect(setOve.yHeaDam, sysReq.uHeaDam) annotation (Line(points={{82,-96},{
          112,-96},{112,-157},{138,-157}}, color={0,0,127}));
  connect(setOve.yHeaDam, ala.uHeaDam) annotation (Line(points={{82,-96},{112,
          -96},{112,-237},{138,-237}}, color={0,0,127}));
annotation (defaultComponentName="duaDucCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}), graphics={
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
          extent={{-96,-10},{-26,-28}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow",
          visible=have_duaSen),
        Text(
          extent={{-100,28},{-74,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-100,48},{-54,34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-100,198},{-72,184}},
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
          extent={{-98,128},{-72,114}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-98,108},{-72,94}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-96,-32},{-56,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooAHU"),
        Text(
          extent={{-96,88},{-50,72}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-96,-140},{-50,-156}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{54,202},{98,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{52,188},{98,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooDam"),
        Text(
          extent={{4,32},{98,10}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonCooTemResReq"),
        Text(
          extent={{-98,-160},{-20,-178}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveCooDamPos"),
        Text(
          extent={{48,-68},{98,-88}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{46,-90},{98,-106}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yFloSenAla",
          visible=not have_duaSen),
        Text(
          extent={{40,-110},{98,-128}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLeaDamAla",
          visible=not have_duaSen),
        Text(
          extent={{32,-130},{98,-146}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColFloSenAla",
          visible=have_duaSen),
        Text(
          extent={{22,-150},{98,-166}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColLeaDamAla",
          visible=have_duaSen),
        Text(
          extent={{-96,-72},{-26,-90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow",
          visible=have_duaSen),
        Text(
          extent={{-96,-94},{-56,-110}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaAHU"),
        Text(
          extent={{-98,-112},{-56,-126}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow",
          visible=not have_duaSen),
        Text(
          extent={{-98,-180},{-20,-198}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveHeaDamPos"),
        Text(
          extent={{52,168},{98,154}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHeaDam"),
        Text(
          extent={{16,12},{98,-8}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColDucPreResReq"),
        Text(
          extent={{16,-28},{98,-48}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotDucPreResReq"),
        Text(
          extent={{4,-6},{98,-28}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonHeaTemResReq"),
        Text(
          extent={{40,-50},{98,-68}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHeaFanReq"),
        Text(
          extent={{30,-170},{96,-186}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotFloSenAla",
          visible=have_duaSen),
        Text(
          extent={{20,-184},{96,-200}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotLeaDamAla",
          visible=have_duaSen),
        Text(
          visible=have_duaSen,
          extent={{-100,8},{-54,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TColSup"),
        Text(
          visible=have_duaSen,
          extent={{-100,-52},{-54,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THotSup"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,68},{-50,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{12,150},{96,132}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{12,130},{96,112}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{36,110},{96,90}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{18,90},{96,70}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{18,68},{96,50}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{66,46},{96,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-320},{240,320}})),
  Documentation(info="<html>
<p>
Controller for snap-acting controlled dual-duct terminal unit according to Section 5.11 of ASHRAE
Guideline 36, May 2020. It outputs discharge airflow setpoint <code>VSet_flow</code>,
cold and hot duct dampers position setpoint (<code>yCooDam</code>, <code>yHeaDam</code>),
cooling supply temperature setpoint reset request <code>yZonCooTemResReq</code>,
heating supply temperature setpoint reset request <code>yZonHeaTemResReq</code>,
cold-duct static pressure setpoint reset request <code>yColDucPreResReq</code>,
hot-duct static pressure setpoint reset request <code>yHotDucPreResReq</code>,
heating fan request <code>yHeaFanReq</code>.
It also outputs the alarms about the low airflow <code>yLowFloAla</code>,
leaking dampers, and airflow sensor(s) calibration alarm.
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
This sequence sets the active maximum airflow according to
Section 5.11.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Dampers control</h4>
<p>
This sequence sets the dampers position setpoints.
The implementation is according to Section 5.11.5. The sequence outputs 
discharge airflow rate setpoint <code>VSet_flow</code>, cold and hot ducts damper
position setpoints (<code>yCooDam</code>, <code>yHeaDam</code>). It has two
sequences depending on if the unit has the dual inlet flow sensor.
</p>
<ul>
<li>
The unit has dual inlet flow sensor. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersDualSensors\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersDualSensors</a>.
</li>
<li>
The unit has single discharge flow sensor. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors</a>.
</li>
</ul>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.11.8, this sequence outputs the system reset requests, i.e.
cooling and heating supply air temperature reset requests (<code>yZonCooTemResReq</code> and
<code>yZonHeaTemResReq</code>),
cold and hot duct static pressure reset requests (<code>yColDucPreResReq</code> and
<code>yHotDucPreResReq</code>), and the heating fan requests
<code>yHeaFanReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.11.6, this sequence outputs the alarms of low discharge flow,
leaking dampers and airflow sensor calibration alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.11.7, this sequence allows the override the aiflow and dampers position setpoints.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Overrides</a>.
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
