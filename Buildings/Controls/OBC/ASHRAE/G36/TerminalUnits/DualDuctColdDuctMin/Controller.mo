within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin;
block Controller "Controller for dual-duct terminal unit with cold-duct minimum control"

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
    annotation (__cdl(ValueInReference=false), Dialog(tab="Control loops", group="Cooling"));
  parameter Real TiCooCon(unit="s")=900
    "Time constant of integrator block for cooling control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Control loops", group="Cooling"));
  parameter Real kHeaCon=0.1
    "Gain of controller for heating control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Control loops", group="Heating"));
  parameter Real TiHeaCon(unit="s")=900
    "Time constant of integrator block for heating control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Control loops", group="Heating"));
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
    annotation (__cdl(ValueInReference=true), Dialog(tab="System requests", group="Duration time"));
  // ---------------- Parameters for alarms ----------------
  parameter Real staPreMul=1
    "Importance multiplier for the zone static pressure reset control loop"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Alarms"));
  parameter Real lowFloTim(unit="s")=300
    "Threshold time to check low flow rate"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real fanOffTim(unit="s")=600
    "Threshold time to check fan off"
    annotation (__cdl(ValueInReference=true), Dialog(tab="Alarms"));
  parameter Real leaFloTim(unit="s")=600
    "Threshold time to check damper leaking airflow"
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
  parameter Real samplePeriod(unit="s")=120
    "Sample period of component, set to the same value as the trim and respond that process static pressure reset"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced", group="Time-based suppresion"));

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
        iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-280,110},{-240,150}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-280,50},{-240,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Cold duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-280,-10},{-240,30}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VColDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured cold-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-40},{-240,0}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooAHU
    "Cooling air handler status"
    annotation (Placement(transformation(extent={{-280,-70},{-240,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Hot duct supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-280,-100},{-240,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotDucDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured hot-duct discharge airflow rate airflow rate"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaAHU
    "Heating air handler status"
    annotation (Placement(transformation(extent={{-280,-160},{-240,-120}}),
        iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow; 4: set to heating maximum"
    annotation (Placement(transformation(extent={{-280,-200},{-240,-160}}),
        iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveCooDamPos
    "Index of overriding cooling damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-230},{-240,-190}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveHeaDamPos
    "Index of overriding heating damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-280,-260},{-240,-220}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{240,240},{280,280}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooDam(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{240,210},{280,250}}),
        iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaDam(
    final min=0,
    final max=1,
    final unit="1")
    "Heating damper commanded position, or commanded flow rate ratio"
    annotation (Placement(transformation(extent={{240,180},{280,220}}),
        iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,150},{280,190}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{240,120},{280,160}}),
        iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,30},{280,70}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
    final unit="1") if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{240,0},{280,40}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonCooTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,-40},{280,0}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColDucPreResReq
    "Cold duct pressure reset requests"
    annotation (Placement(transformation(extent={{240,-70},{280,-30}}),
        iconTransformation(extent={{100,-40},{140,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yZonHeaTemResReq
    "Zone heating supply air temperature reset request"
    annotation (Placement(transformation(extent={{240,-100},{280,-60}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotDucPreResReq
    "Hot duct pressure reset requests"
    annotation (Placement(transformation(extent={{240,-130},{280,-90}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHeaFanReq
    "Heating fan request"
    annotation (Placement(transformation(extent={{240,-160},{280,-120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yLowFloAla
    "Low airflow alarms"
    annotation (Placement(transformation(extent={{240,-200},{280,-160}}),
        iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColFloSenAla
    "Cold-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-230},{280,-190}}),
        iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yColLeaDamAla
    "Leaking cold-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
        iconTransformation(extent={{100,-170},{140,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotFloSenAla
    "Hot-duct airflow sensor calibration alarm"
    annotation (Placement(transformation(extent={{240,-290},{280,-250}}),
        iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotLeaDamAla
    "Leaking hot-duct damper alarm"
    annotation (Placement(transformation(extent={{240,-320},{280,-280}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.ActiveAirFlow
    actAirSet(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final floHys=floHys) "Active airflow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests
    sysReq(
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
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms
    ala(
    final staPreMul=staPreMul,
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final lowFloTim=lowFloTim,
    final fanOffTim=fanOffTim,
    final leaFloTim=leaFloTim,
    final floHys=floHys,
    final damPosHys=damPosHys,
    final staTim=staTim)       "Generate alarms"
    annotation (Placement(transformation(extent={{140,-240},{160,-220}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Overrides
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
    final permit_occStandby=permit_occStandby,
    final VAreBreZon_flow=VAreBreZon_flow,
    final VPopBreZon_flow=VPopBreZon_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow,
    final zonDisEff_cool=zonDisEff_cool,
    final zonDisEff_heat=zonDisEff_heat,
    final dTHys=dTHys) if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1
    "Output the minimum outdoor airflow rate setpoint, when using ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Dampers
    damDuaSen(
    final VCooMax_flow=VCooMax_flow,
    final VHeaMax_flow=VHeaMax_flow,
    final controllerTypeDam=controllerTypeDam,
    final kDam=kDam,
    final TiDam=TiDam,
    final TdDam=TdDam,
    final dTHys=dTHys,
    final looHys=looHys,
    final iniDam=iniDam)
    "Dampers control when the unit has single dual airflow sensor"
    annotation (Placement(transformation(extent={{0,0},{20,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.Generic.TimeSuppression timSupHea(
    final samplePeriod=samplePeriod,
    final chaRat=chaRat,
    final maxTim=maxSupTim,
    final dTHys=dTHys)
    "Specify suppresion time due to the zone heating setpoint change and check if it has passed the suppresion period"
    annotation (Placement(transformation(extent={{-200,240},{-180,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooMax(
    final k=VCooMax_flow)
    "Cooling maximum flow"
    annotation (Placement(transformation(extent={{-40,280},{-20,300}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaMax(
    final k=VHeaMax_flow)
    "Heating maximum flow"
    annotation (Placement(transformation(extent={{-80,250},{-60,270}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Sum of minimum flow and cooling maximum flow"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(
    final h=floHys)
    "Check if cooling maximum is greater than the sum of minimum and heating maximum flow"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(
    final message="Warning: the sum of minimum flow and heating maximum flow is greater than the cooling maximum flow.")
    "Generate warning when the cooling maximum is less than the sum of heating maximum and the minimum flow"
    annotation (Placement(transformation(extent={{60,280},{80,300}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Setpoints minFlo(
    final have_winSen=have_winSen,
    final have_occSen=have_occSen,
    final have_CO2Sen=have_CO2Sen,
    final have_typTerUni=true,
    final VOccMin_flow=VOccMin_flow,
    final VAreMin_flow=VAreMin_flow,
    final VMin_flow=VMin_flow,
    final VCooMax_flow=VCooMax_flow)
    if venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24
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
          -180,159},{-162,159}}, color={255,0,255}));
  connect(u1Occ, setPoi.u1Occ) annotation (Line(points={{-260,160},{-184,160},{
          -184,157},{-162,157}}, color={255,0,255}));
  connect(uOpeMod, setPoi.uOpeMod) annotation (Line(points={{-260,130},{-200,
          130},{-200,155},{-162,155}}, color={255,127,0}));
  connect(ppmCO2, setPoi.ppmCO2) annotation (Line(points={{-260,70},{-192,70},{
          -192,151},{-162,151}},  color={0,0,127}));
  connect(TZon, setPoi.TZon) annotation (Line(points={{-260,300},{-220,300},{-220,
          143},{-162,143}}, color={0,0,127}));
  connect(TDis, setPoi.TDis) annotation (Line(points={{-260,40},{-188,40},{-188,
          141},{-162,141}}, color={0,0,127}));
  connect(uOpeMod, actAirSet.uOpeMod) annotation (Line(points={{-260,130},{-200,
          130},{-200,72},{-82,72}}, color={255,127,0}));
  connect(setPoi.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-138,154},{-120,154},{-120,88},{-82,88}}, color={0,0,127}));
  connect(conLoo.yCoo, damDuaSen.uCoo) annotation (Line(points={{-178,216},{-28,
          216},{-28,39},{-2,39}}, color={0,0,127}));
  connect(actAirSet.VActCooMax_flow, damDuaSen.VActCooMax_flow) annotation (
      Line(points={{-58,88},{-20,88},{-20,36},{-2,36}}, color={0,0,127}));
  connect(VColDucDis_flow, damDuaSen.VColDucDis_flow) annotation (Line(points={{-260,
          -20},{-52,-20},{-52,30},{-2,30}},    color={0,0,127}));
  connect(u1CooAHU, damDuaSen.u1CooAHU) annotation (Line(points={{-260,-50},{-44,
          -50},{-44,27},{-2,27}}, color={255,0,255}));
  connect(actAirSet.VActMin_flow, damDuaSen.VActMin_flow) annotation (Line(
        points={{-58,80},{-24,80},{-24,22},{-2,22}}, color={0,0,127}));
  connect(TZon, damDuaSen.TZon) annotation (Line(points={{-260,300},{-220,300},{
          -220,18},{-2,18}}, color={0,0,127}));
  connect(conLoo.yHea, damDuaSen.uHea) annotation (Line(points={{-178,204},{-32,
          204},{-32,10},{-2,10}}, color={0,0,127}));
  connect(actAirSet.VActHeaMax_flow, damDuaSen.VActHeaMax_flow) annotation (
      Line(points={{-58,72},{-36,72},{-36,7},{-2,7}}, color={0,0,127}));
  connect(VHotDucDis_flow, damDuaSen.VHotDucDis_flow) annotation (Line(points={{-260,
          -110},{-48,-110},{-48,4},{-2,4}},    color={0,0,127}));
  connect(u1HeaAHU, damDuaSen.u1HeaAHU) annotation (Line(points={{-260,-140},{-40,
          -140},{-40,1},{-2,1}}, color={255,0,255}));
  connect(oveFloSet, setOve.oveFloSet) annotation (Line(points={{-260,-180},{0,-180},
          {0,-82},{58,-82}}, color={255,127,0}));
  connect(oveCooDamPos, setOve.oveCooDamPos) annotation (Line(points={{-260,-210},
          {4,-210},{4,-90},{58,-90}}, color={255,127,0}));
  connect(oveHeaDamPos, setOve.oveHeaDamPos) annotation (Line(points={{-260,-240},
          {8,-240},{8,-96},{58,-96}}, color={255,127,0}));
  connect(damDuaSen.yCooDam, setOve.uCooDam) annotation (Line(points={{22,29},{44,
          29},{44,-93},{58,-93}}, color={0,0,127}));
  connect(damDuaSen.yHeaDam, setOve.uHeaDam) annotation (Line(points={{22,6},
          {40,6},{40,-99},{58,-99}}, color={0,0,127}));
  connect(damDuaSen.VDis_flow_Set, setOve.VActSet_flow) annotation (Line(points=
         {{22,38},{36,38},{36,-85},{58,-85}}, color={0,0,127}));
  connect(setOve.VSet_flow, VSet_flow) annotation (Line(points={{82,-84},{100,-84},
          {100,260},{260,260}}, color={0,0,127}));
  connect(setOve.yCooDam, yCooDam) annotation (Line(points={{82,-90},{106,-90},{
          106,230},{260,230}}, color={0,0,127}));
  connect(setOve.yHeaDam, yHeaDam) annotation (Line(points={{82,-96},{112,-96},{
          112,200},{260,200}}, color={0,0,127}));
  connect(sysReq.yZonCooTemResReq, yZonCooTemResReq) annotation (Line(points={{162,
          -132},{176,-132},{176,-20},{260,-20}}, color={255,127,0}));
  connect(sysReq.yColDucPreResReq, yColDucPreResReq) annotation (Line(points={{162,
          -137},{182,-137},{182,-50},{260,-50}}, color={255,127,0}));
  connect(sysReq.yZonHeaTemResReq, yZonHeaTemResReq) annotation (Line(points={{162,
          -143},{188,-143},{188,-80},{260,-80}}, color={255,127,0}));
  connect(sysReq.yHotDucPreResReq, yHotDucPreResReq) annotation (Line(points={{162,
          -148},{194,-148},{194,-110},{260,-110}}, color={255,127,0}));
  connect(sysReq.yHeaFanReq, yHeaFanReq) annotation (Line(points={{162,-158},{
          200,-158},{200,-140},{260,-140}},
                                        color={255,127,0}));
  connect(ala.yColFloSenAla, yColFloSenAla) annotation (Line(points={{162,-227},
          {206,-227},{206,-210},{260,-210}}, color={255,127,0}));
  connect(ala.yColLeaDamAla, yColLeaDamAla) annotation (Line(points={{162,-230},
          {212,-230},{212,-240},{260,-240}}, color={255,127,0}));
  connect(ala.yHotFloSenAla, yHotFloSenAla) annotation (Line(points={{162,-234},
          {206,-234},{206,-270},{260,-270}}, color={255,127,0}));
  connect(timSupCoo.yAftSup, sysReq.uAftSupCoo) annotation (Line(points={{-178,
          290},{-100,290},{-100,-121},{138,-121}},
                                             color={255,0,255}));
  connect(TCooSet, sysReq.TCooSet) annotation (Line(points={{-260,270},{-226,
          270},{-226,-124},{138,-124}},
                                  color={0,0,127}));
  connect(TDis, sysReq.TZon) annotation (Line(points={{-260,40},{-188,40},{-188,
          -127},{138,-127}},color={0,0,127}));
  connect(conLoo.yCoo, sysReq.uCoo) annotation (Line(points={{-178,216},{-28,
          216},{-28,-130},{138,-130}},
                                 color={0,0,127}));
  connect(damDuaSen.VColDucDis_flow_Set, sysReq.VColDuc_flow_Set) annotation (
      Line(points={{22,34},{48,34},{48,-133},{138,-133}},color={0,0,127}));
  connect(VColDucDis_flow, sysReq.VColDucDis_flow) annotation (Line(points={{-260,
          -20},{-52,-20},{-52,-135},{138,-135}},color={0,0,127}));
  connect(timSupHea.yAftSup, sysReq.uAftSupHea) annotation (Line(points={{-178,
          250},{-104,250},{-104,-143},{138,-143}},
                                             color={255,0,255}));
  connect(THeaSet, sysReq.THeaSet) annotation (Line(points={{-260,240},{-214,
          240},{-214,-146},{138,-146}},
                                  color={0,0,127}));
  connect(conLoo.yHea, sysReq.uHea) annotation (Line(points={{-178,204},{-32,
          204},{-32,-149},{138,-149}},
                                 color={0,0,127}));
  connect(damDuaSen.VHotDucDis_flow_Set, sysReq.VHotDuc_flow_Set) annotation (
      Line(points={{22,11},{32,11},{32,-152},{138,-152}},color={0,0,127}));
  connect(VHotDucDis_flow, sysReq.VHotDucDis_flow) annotation (Line(points={{-260,
          -110},{-48,-110},{-48,-154},{138,-154}},color={0,0,127}));
  connect(setOve.VSet_flow, ala.VActSet_flow) annotation (Line(points={{82,-84},
          {90,-84},{90,-221},{138,-221}},color={0,0,127}));
  connect(VColDucDis_flow, ala.VColDucDis_flow) annotation (Line(points={{-260,
          -20},{-52,-20},{-52,-224},{138,-224}},
                                          color={0,0,127}));
  connect(u1CooAHU, ala.u1CooFan) annotation (Line(points={{-260,-50},{-44,-50},
          {-44,-226},{138,-226}},color={255,0,255}));
  connect(VHotDucDis_flow, ala.VHotDucDis_flow) annotation (Line(points={{-260,
          -110},{-48,-110},{-48,-234},{138,-234}},
                                           color={0,0,127}));
  connect(u1HeaAHU, ala.u1HeaFan) annotation (Line(points={{-260,-140},{-40,
          -140},{-40,-236},{138,-236}},
                                 color={255,0,255}));
  connect(ala.yLowFloAla, yLowFloAla) annotation (Line(points={{162,-222},{200,
          -222},{200,-180},{260,-180}},
                                  color={255,127,0}));
  connect(ala.yHotLeaDamAla, yHotLeaDamAla) annotation (Line(points={{162,-237},
          {200,-237},{200,-300},{260,-300}}, color={255,127,0}));
  connect(TColSup, damDuaSen.TColSup) annotation (Line(points={{-260,10},{-40,10},
          {-40,33},{-2,33}}, color={0,0,127}));
  connect(THotSup, damDuaSen.THotSup) annotation (Line(points={{-260,-80},{-56,-80},
          {-56,13},{-2,13}}, color={0,0,127}));
  connect(heaMax.y, add2.u1) annotation (Line(points={{-58,260},{-50,260},{-50,246},
          {-42,246}}, color={0,0,127}));
  connect(setPoi.VOccZonMin_flow, add2.u2) annotation (Line(points={{-138,154},{
          -120,154},{-120,234},{-42,234}}, color={0,0,127}));
  connect(cooMax.y, gre.u1)
    annotation (Line(points={{-18,290},{18,290}}, color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{-18,240},{0,240},{0,282},{18,
          282}}, color={0,0,127}));
  connect(gre.y, assMes.u)
    annotation (Line(points={{42,290},{58,290}}, color={255,0,255}));
  connect(ppmCO2Set, setPoi.ppmCO2Set) annotation (Line(points={{-260,100},{
          -196,100},{-196,153},{-162,153}}, color={0,0,127}));
  connect(u1Win, minFlo.u1Win) annotation (Line(points={{-260,190},{-180,190},{
          -180,119},{-162,119}}, color={255,0,255}));
  connect(u1Occ, minFlo.u1Occ) annotation (Line(points={{-260,160},{-184,160},{
          -184,116},{-162,116}}, color={255,0,255}));
  connect(uOpeMod, minFlo.uOpeMod) annotation (Line(points={{-260,130},{-200,
          130},{-200,113},{-162,113}}, color={255,127,0}));
  connect(ppmCO2Set, minFlo.ppmCO2Set) annotation (Line(points={{-260,100},{
          -196,100},{-196,110},{-162,110}}, color={0,0,127}));
  connect(ppmCO2, minFlo.ppmCO2) annotation (Line(points={{-260,70},{-192,70},{
          -192,107},{-162,107}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, actAirSet.VOccMin_flow) annotation (Line(
        points={{-138,107},{-120,107},{-120,88},{-82,88}}, color={0,0,127}));
  connect(minFlo.VOccZonMin_flow, add2.u2) annotation (Line(points={{-138,107},{
          -120,107},{-120,234},{-42,234}},  color={0,0,127}));
  connect(setPoi.VAdjPopBreZon_flow, VAdjPopBreZon_flow) annotation (Line(
        points={{-138,158},{80,158},{80,170},{260,170}}, color={0,0,127}));
  connect(setPoi.VAdjAreBreZon_flow, VAdjAreBreZon_flow)
    annotation (Line(points={{-138,150},{86,150},{86,140},{260,140}}, color={0,0,127}));
  connect(setPoi.VMinOA_flow, VMinOA_flow) annotation (Line(points={{-138,146},{
          80,146},{80,110},{260,110}},  color={0,0,127}));
  connect(minFlo.VZonAbsMin_flow, VZonAbsMin_flow) annotation (Line(points={{-138,
          119},{74,119},{74,80},{260,80}},      color={0,0,127}));
  connect(minFlo.VZonDesMin_flow, VZonDesMin_flow) annotation (Line(points={{-138,
          116},{68,116},{68,50},{260,50}},      color={0,0,127}));
  connect(minFlo.yCO2, yCO2) annotation (Line(points={{-138,104},{62,104},{62,20},
          {260,20}},     color={0,0,127}));
  connect(setOve.yCooDam, sysReq.uCooDam) annotation (Line(points={{82,-90},{
          106,-90},{106,-138},{138,-138}}, color={0,0,127}));
  connect(setOve.yCooDam, ala.uCooDam) annotation (Line(points={{82,-90},{106,
          -90},{106,-232},{138,-232}}, color={0,0,127}));
  connect(setOve.yHeaDam, sysReq.uHeaDam) annotation (Line(points={{82,-96},{
          112,-96},{112,-157},{138,-157}}, color={0,0,127}));
  connect(setOve.yHeaDam, ala.uHeaDam) annotation (Line(points={{82,-96},{112,
          -96},{112,-238},{138,-238}}, color={0,0,127}));
  connect(uOpeMod, ala.uOpeMod) annotation (Line(points={{-260,130},{-200,130},
          {-200,-229},{138,-229}}, color={255,127,0}));
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
          extent={{-96,-20},{-26,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VColDucDis_flow"),
        Text(
          extent={{-100,18},{-74,4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=have_CO2Sen,
          extent={{-100,40},{-54,26}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          extent={{-100,200},{-72,186}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-98,178},{-54,162}},
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
          extent={{-98,118},{-72,104}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          visible=have_occSen,
          extent={{-98,98},{-72,84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-96,-42},{-52,-58}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1CooAHU"),
        Text(
          extent={{-96,78},{-50,62}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-96,-140},{-50,-156}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{54,198},{98,182}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VSet_flow"),
        Text(
          extent={{42,178},{98,164}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooDam"),
        Text(
          extent={{4,12},{98,-10}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonCooTemResReq"),
        Text(
          extent={{-98,-160},{-20,-178}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveCooDamPos"),
        Text(
          extent={{48,-98},{98,-118}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yLowFloAla"),
        Text(
          extent={{32,-120},{98,-136}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColFloSenAla"),
        Text(
          extent={{22,-140},{98,-156}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColLeaDamAla"),
        Text(
          extent={{-96,-82},{-26,-100}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VHotDucDis_flow"),
        Text(
          extent={{-96,-104},{-52,-120}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HeaAHU"),
        Text(
          extent={{-98,-180},{-20,-198}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveHeaDamPos"),
        Text(
          extent={{42,158},{98,144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yHeaDam"),
        Text(
          extent={{16,-8},{98,-28}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yColDucPreResReq"),
        Text(
          extent={{16,-48},{98,-68}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotDucPreResReq"),
        Text(
          extent={{4,-26},{98,-48}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yZonHeaTemResReq"),
        Text(
          extent={{40,-70},{98,-88}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHeaFanReq"),
        Text(
          extent={{30,-160},{96,-176}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotFloSenAla"),
        Text(
          extent={{20,-180},{96,-196}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yHotLeaDamAla"),
        Text(
          extent={{-98,-2},{-56,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TColSup"),
        Text(
          extent={{-100,-62},{-58,-76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THotSup"),
        Text(
          visible=have_CO2Sen,
          extent={{-96,58},{-50,44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set"),
        Text(
          extent={{12,132},{96,114}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{12,112},{96,94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{36,92},{96,72}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1),
        Text(
          extent={{18,72},{96,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{18,50},{96,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24),
        Text(
          extent={{66,28},{96,12}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2",
          visible=venStd == Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-320},{240,320}})),
  Documentation(info="<html>
<p>
Controller for dual-duct terminal unit with cold-duct minimum control
according to Section 5.14 of ASHRAE
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
Section 5.14.4. Depending on operation modes <code>uOpeMod</code>, it sets the
airflow rate limits for cooling and heating supply. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.ActiveAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.ActiveAirFlow</a>.
</p>
<h4>c. Dampers control</h4>
<p>
This sequence sets the dampers position setpoints.
The implementation is according to Section 5.14.5. The sequence outputs 
discharge airflow rate setpoint <code>VSet_flow</code>, cold and hot ducts damper
position setpoints (<code>yCooDam</code>, <code>yHeaDam</code>). See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Dampers\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Dampers</a>.
</p>
<h4>d. System reset requests generation</h4>
<p>
According to Section 5.14.8, this sequence outputs the system reset requests, i.e.
cooling and heating supply air temperature reset requests (<code>yZonCooTemResReq</code> and
<code>yZonHeaTemResReq</code>),
cold and hot duct static pressure reset requests (<code>yColDucPreResReq</code> and
<code>yHotDucPreResReq</code>), and the heating fan requests
<code>yHeaFanReq</code>. 
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests</a>.
</p>
<h4>e. Alarms</h4>
<p>
According to Section 5.14.6, this sequence outputs the alarms of low discharge flow,
leaking dampers and airflow sensor calibration alarm.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms</a>.
</p>
<h4>f. Testing and commissioning overrides</h4>
<p>
According to Section 5.14.7, this sequence allows the override the aiflow and dampers position setpoints.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Overrides\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Overrides</a>.
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
