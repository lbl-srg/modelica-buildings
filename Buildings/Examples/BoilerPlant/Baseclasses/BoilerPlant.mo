within Buildings.Examples.BoilerPlant.Baseclasses;
model BoilerPlant "Boiler plant model for closed loop testing"
  replaceable package MediumA =
      Buildings.Media.Air;

  replaceable package MediumW =
      Buildings.Media.Water
    "Medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = boiEff1[1]*boiCap1 + boiEff2[1]*boiCap2
    "Nominal heat flow rate of radiator"
    annotation(dialog(group="Plant parameters"));

  parameter Real TPlaHotWatSetMax(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 353.15
    "The maximum allowed hot-water setpoint temperature for the plant"
    annotation(Dialog(group="Boiler parameters"));

  parameter Real THotWatSetMinConBoi(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 305.37
    "The minimum allowed hot-water setpoint temperature for condensing boilers"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap1= 2200000
    "Boiler capacity for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap2= 2200000
    "Boiler capacity for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff1[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-1"
    annotation(dialog(group="Boiler parameters"));

  parameter Real boiEff2[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-2"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal=0.113*1000
    "Secondary load nominal mass flow rate"
    annotation(dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal1=mSec_flow_nominal
    "Boiler-1 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal2=mSec_flow_nominal
    "Boiler-2 nominal mass flow rate"
    annotation(dialog(group="Boiler parameters"));

  constant Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoiOri
    "Original record for boiler performance data is scaled below";

  parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi1(
    final Q_flow_nominal = boiCap1,
    final VWat = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{260,162},{280,182}})));

  parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi2(
    final Q_flow_nominal = boiCap2,
    final VWat = boiCap2/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = boiCap2/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = boiCap2/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{260,192},{280,212}})));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal_value=6000
    "Nominal pressure drop of fully open valve, used if CvData=Buildings.Fluid.Types.CvTypes.OpPoint";

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal_value=1000
    "Pressure drop of pipe and other resistances that are in series";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypePla=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PI parameters", group="Plant supply water temperature controller"));

  parameter Real kPla(
    final unit="1",
    displayUnit="1",
    final min=0)=10e-3
    "Gain of controller"
    annotation(Dialog(tab="PI parameters", group="Plant supply water temperature controller"));

  parameter Real TiPla(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=90
    "Time constant of integrator block"
    annotation(Dialog(tab="PI parameters", group="Plant supply water temperature controller",
      enable = (controllerTypePla == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypePla == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdPla(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=0.1
    "Time constant of derivative block"
    annotation(Dialog(tab="PI parameters", group="Plant supply water temperature controller",
      enable = (controllerTypePla == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypePla == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeBoi1=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller"));

  parameter Real kBoi1(
    final unit="1",
    displayUnit="1",
    final min=0)=10e-3
    "Gain of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller"));

  parameter Real TiBoi1(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=90
    "Time constant of integrator block"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller",
      enable = (controllerTypeBoi1 == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeBoi1 == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdBoi1(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=0.1
    "Time constant of derivative block"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller",
      enable = (controllerTypeBoi1 == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypeBoi1 == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeBoi2=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-2 supply water temperature controller"));

  parameter Real kBoi2(
    final unit="1",
    displayUnit="1",
    final min=0)=10e-3
    "Gain of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-2 supply water temperature controller"));

  parameter Real TiBoi2(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=90
    "Time constant of integrator block"
    annotation(Dialog(tab="PI parameters", group="Boiler-2 supply water temperature controller",
      enable = (controllerTypeBoi2 == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeBoi2 == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  parameter Real TdBoi2(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=0.1
    "Time constant of derivative block"
    annotation(Dialog(tab="PI parameters", group="Boiler-2 supply water temperature controller",
      enable = (controllerTypeBoi2 == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerTypeBoi2 == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{-360,140},{-320,180}}),
      iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[1]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-360,180},{-320,220}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHotIsoVal[2](
    final unit="1",
    displayUnit="1")
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValSig(
    final unit="1",
    displayUnit="1")
    "Bypass valve signal"
    annotation (Placement(transformation(extent={{-360,-60},{-320,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{-360,-130},{-320,-90}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-360,-90},{-320,-50}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPlaHotWatSupSet(
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Plant hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-360,-180},{-320,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoiSta[2]
    "Boiler status signal"
    annotation (Placement(transformation(extent={{320,-90},{360,-50}}),
      iconTransformation(extent={{100,-70},{140,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[1]
    "Pump status signal"
    annotation (Placement(transformation(extent={{320,-130},{360,-90}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,80},{360,120}}),
      iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,40},{360,80}}),
      iconTransformation(extent={{100,30},{140,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatDp[1](
    final unit="Pa",
    displayUnit="Pa")
    "Hot water differential pressure between supply and return"
    annotation (Placement(transformation(extent={{320,-10},{360,30}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWat_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatIsoVal[2](
    final unit="1",
    displayUnit="1")
    "Measured boiler hot water isolation valve position"
    annotation (Placement(transformation(extent={{320,-170},{360,-130}}),
      iconTransformation(extent={{100,-130},{140,-90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBypValPos(
    final unit="1",
    displayUnit="1")
    "Measured bypass valve position"
    annotation (Placement(transformation(extent={{320,130},{360,170}}),
      iconTransformation(extent={{100,90},{140,130}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW)
    "HW inlet port"
    annotation (Placement(transformation(extent={{30,230},{50,250}}),
      iconTransformation(extent={{60,130},{80,150}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW)
    "HW outlet port"
    annotation (Placement(transformation(extent={{-50,230},{-30,250}}),
      iconTransformation(extent={{-80,130},{-60,150}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    p=100000,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{18,-78},{-2,-58}})));

  Buildings.Fluid.Boilers.BoilerTable boi2(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=perBoi2) "Boiler-2"
    annotation (Placement(transformation(extent={{110,-220},{90,-200}})));

  Buildings.Fluid.Boilers.BoilerTable boi1(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final per=perBoi1) "Boiler-1"
    annotation (Placement(transformation(extent={{110,-160},{90,-140}})));

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=false,
    redeclare Buildings.Fluid.Movers.Data.Generic per(
      final pressure(V_flow={0,2*mSec_flow_nominal/1000},
      final dp={2*75000,0})),
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final addPowerToMedium=false,
    final riseTime=60)
    "Hot water primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-50})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mSec_flow_nominal,mBoi_flow_nominal1},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-150})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mSec_flow_nominal,-mSec_flow_nominal,-mSec_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Minimum flow bypass valve"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mSec_flow_nominal,mSec_flow_nominal,-mSec_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,40})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi_flow_nominal2,
    final dpValve_nominal=dpValve_nominal_value,
    final use_inputFilter=true,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final y_start=0,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dpValve_nominal=dpValve_nominal_value,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final y_start=0,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = MediumW)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal/1000)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-10})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW supply temperature sensor"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW return temperature sensor before water enters return plumbing"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=1)
    "Real replicator"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2(
    final uLow=0.05,
    final uHigh=0.09)
    "Check if pumps are on"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timPumSta(final t=120)
    "Output pump proven on signal when pump status is enabled for two minutes"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Hold pump enable status until change process is completed"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[2]
    "Switch to signal from controller once enabling process has been completed"
    annotation (Placement(transformation(extent={{-210,150},{-190,170}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1[2]
    "Hold boiler enable status until boiler is proven on"
    annotation (Placement(transformation(extent={{-260,150},{-240,170}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPIDBoi[2](
    final controllerType={controllerTypeBoi1,controllerTypeBoi2},
    final k={kBoi1,kBoi2},
    final Ti={TiBoi1,TiBoi2},
    final Td={TdBoi1,TdBoi2},
    final yMax=fill(1, 2),
    final yMin=fill(0, 2),
    final xi_start=fill(0.2, 2))
    "PI controller for operating boilers to regulating hot water supply temperature"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro1[2]
    "Product of boiler power and current status"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi_flow_nominal1,mSec_flow_nominal,-mBoi_flow_nominal2},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={150,-150})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre1(
    redeclare package Medium = MediumW)
    "Differential pressure sensor between hot water supply and return"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-70,-10})));

  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr[2](
    final t=fill(0.02, 2),
    final h=fill(0.02/10, 2))
    "Determine if boilers are disabled"
    annotation (Placement(transformation(extent={{180,-130},{200,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,-86},{260,-66}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat2[2]
    "Determine boiler enable status based on PLR and hold it till the boiler disable limit is passed"
    annotation (Placement(transformation(extent={{280,-80},{300,-60}})));

  Buildings.Fluid.FixedResistances.PlugFlowPipe pipe(
    redeclare package Medium = MediumW,
    final allowFlowReversal=false,
    final m_flow_nominal=mSec_flow_nominal,
    final have_pipCap=false,
    final length=2000,
    final dIns=0.0508,
    final kIns=0.0389)
    "Dynamic pipe element to represent duct loss"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRoo
    "Room temperature of boiler room"
    annotation (Placement(transformation(extent={{-280,-80},{-260,-60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(
    final nout=1)
    "Boolean replicator"
    annotation (Placement(transformation(extent={{280,-120},{300,-100}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr3[2](
    final t=fill(0.02,2),
    final h=fill(0.02/10, 2))
    "Check if boiler is enabled"
    annotation (Placement(transformation(extent={{180,-210},{200,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2]
    "Logical pre block"
    annotation (Placement(transformation(extent={{240,-210},{260,-190}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiPum
    "Switch for pump"
    annotation (Placement(transformation(extent={{-220,-20},{-200,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    "Zero output signal"
    annotation (Placement(transformation(extent={{-300,-30},{-280,-10}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPIDPla(
    final controllerType=controllerTypePla,
    final k=kPla,
    final Ti=TiPla,
    final Td=TdPla,
    final yMax=1,
    final yMin=0)
    "PI controller for setting boiler supply temperature setpoint"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Detect changes to boiler status setpoints"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));

  Buildings.Controls.OBC.CDL.Reals.Line lin[2]
    "Intrapolate plant supply temperature PI signal to boiler supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-190},{-160,-170}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=2)
    "Replicate plant PI signal to each boiler PI controller"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[2](
    final k=fill(0, 2))
    "Support point for boiler setpoint"
    annotation (Placement(transformation(extent={{-240,-150},{-220,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[2](
    final k=fill(1, 2))
    "Support point for boiler setpoint"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[2](
    final k=fill(TPlaHotWatSetMax, 2))
    "Max boiler plant supply temperature"
    annotation (Placement(transformation(extent={{-280,-190},{-260,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Detect plant enable signal becoming true"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Send zero signal when the plant is disabled"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert plant enable Boolean signal to Real signal"
    annotation (Placement(transformation(extent={{60,190},{80,210}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW return temperature sensor in primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={210,-10})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "Volume flow-rate through minimum flow bypass branch"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW return temperature sensor"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "Volume flow-rate through secondary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,104})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem4(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW return temperature sensor after water exits return plumbing"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

equation
  connect(val1.port_a, spl1.port_3)
    annotation (Line(points={{0,-150},{-20,-150}},    color={0,127,255}));
  connect(val2.port_a, spl1.port_1) annotation (Line(points={{0,-210},{-30,-210},
          {-30,-160}}, color={0,127,255}));

  connect(spl4.port_2, senRelPre.port_a) annotation (Line(points={{-30,50},{-30,
          80},{80,80}},    color={0,127,255}));

  connect(senRelPre.port_b, spl5.port_1) annotation (Line(points={{100,80},{210,
          80},{210,50}},   color={0,127,255}));

  connect(senVolFlo.port_b, spl4.port_1) annotation (Line(points={{-30,0},{-30,30}},
                                                     color={0,127,255}));

  connect(senVolFlo.V_flow, VHotWat_flow) annotation (Line(points={{-41,-10},{
          -41,16},{180,16},{180,-30},{340,-30}},   color={0,0,127}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-10,131},{-10,140},{270,
          140},{270,100},{340,100}},                color={0,0,127}));

  connect(reaRep.y, yHotWatDp)
    annotation (Line(points={{302,10},{340,10}},     color={0,0,127}));

  connect(senRelPre.p_rel, reaRep.u) annotation (Line(points={{90,71},{90,66},{240,
          66},{240,10},{278,10}},           color={0,0,127}));

  connect(hys2.y, timPumSta.u)
    annotation (Line(points={{122,-30},{138,-30}}, color={255,0,255}));
  connect(lat.y, logSwi.u2)
    annotation (Line(points={{-278,40},{-262,40}}, color={255,0,255}));
  connect(lat.y, logSwi.u1) annotation (Line(points={{-278,40},{-270,40},{-270,
          48},{-262,48}}, color={255,0,255}));
  connect(uBoiSta, lat1.u)
    annotation (Line(points={{-340,160},{-262,160}}, color={255,0,255}));
  connect(lat1.y, logSwi1.u2)
    annotation (Line(points={{-238,160},{-212,160}}, color={255,0,255}));
  connect(logSwi1.y, booToRea1.u)
    annotation (Line(points={{-188,160},{-162,160}}, color={255,0,255}));
  connect(uBoiSta, logSwi1.u3) annotation (Line(points={{-340,160},{-310,160},{
          -310,140},{-220,140},{-220,152},{-212,152}}, color={255,0,255}));
  connect(lat1.y, logSwi1.u1) annotation (Line(points={{-238,160},{-220,160},{
          -220,168},{-212,168}}, color={255,0,255}));
  connect(booToRea1.y, pro1.u1) annotation (Line(points={{-138,160},{-130,160},{
          -130,-114},{-122,-114}}, color={0,0,127}));
  connect(boi1.port_a, spl6.port_1)
    annotation (Line(points={{110,-150},{140,-150}}, color={0,127,255}));
  connect(boi2.port_a, spl6.port_3) annotation (Line(points={{110,-210},{150,-210},
          {150,-160}}, color={0,127,255}));
  connect(senTem1.port_a, port_a)
    annotation (Line(points={{60,120},{40,120},{40,240}},  color={0,127,255}));
  connect(val.y_actual, yBypValPos) annotation (Line(points={{95,47},{120,47},{120,
          150},{340,150}}, color={0,0,127}));
  connect(pre2.y, lat2.clr) annotation (Line(points={{262,-76},{278,-76}},
                           color={255,0,255}));
  connect(lat2.y, yBoiSta)
    annotation (Line(points={{302,-70},{340,-70}}, color={255,0,255}));
  connect(lesThr.y, pre2.u) annotation (Line(points={{202,-120},{220,-120},{220,
          -76},{238,-76}}, color={255,0,255}));
  connect(TZon, TRoo.T)
    annotation (Line(points={{-340,-70},{-282,-70}}, color={0,0,127}));
  connect(pum.port_b, senVolFlo.port_a)
    annotation (Line(points={{-30,-40},{-30,-20}}, color={0,127,255}));
  connect(senRelPre1.port_a, spl1.port_2) annotation (Line(points={{-70,-20},{-70,
          -140},{-30,-140}}, color={0,127,255}));
  connect(senRelPre1.port_b, spl4.port_1)
    annotation (Line(points={{-70,0},{-70,30},{-30,30}}, color={0,127,255}));
  connect(booRep1.y, yPumSta)
    annotation (Line(points={{302,-110},{340,-110}}, color={255,0,255}));
  connect(timPumSta.passed, booRep1.u) annotation (Line(points={{162,-38},{230,-38},
          {230,-110},{278,-110}}, color={255,0,255}));
  connect(uPumSta[1], logSwi.u3) annotation (Line(points={{-340,40},{-308,40},{-308,
          20},{-270,20},{-270,32},{-262,32}}, color={255,0,255}));
  connect(uPumSta[1], lat.u)
    annotation (Line(points={{-340,40},{-302,40}}, color={255,0,255}));
  connect(uBypValSig, val.y) annotation (Line(points={{-340,-40},{-120,-40},{-120,
          60},{90,60},{90,52}}, color={0,0,127}));
  connect(spl1.port_2, pum.port_a)
    annotation (Line(points={{-30,-140},{-30,-60}}, color={0,127,255}));
  connect(senTem.port_b, port_b) annotation (Line(points={{0,120},{10,120},{10,
          160},{-40,160},{-40,240}}, color={0,127,255}));
  connect(preSou.ports[1], pum.port_a) annotation (Line(points={{-2,-68},{-30,-68},
          {-30,-60}},           color={0,127,255}));
  connect(greThr3.y, pre3.u)
    annotation (Line(points={{202,-200},{238,-200}}, color={255,0,255}));
  connect(pre3.y, lat2.u) annotation (Line(points={{262,-200},{266,-200},{266,-70},
          {278,-70}},      color={255,0,255}));
  connect(TRoo.port, pipe.heatPort) annotation (Line(points={{-260,-70},{-140,
          -70},{-140,100},{100,100},{100,130},{140,130}},
                                                   color={191,0,0}));
  connect(boi1.heatPort, TRoo.port) annotation (Line(points={{100,-142.8},{100,
          -86},{-120,-86},{-120,-70},{-260,-70}}, color={191,0,0}));
  connect(boi2.heatPort, TRoo.port) annotation (Line(points={{100,-202.8},{100,-180},
          {84,-180},{84,-86},{-120,-86},{-120,-70},{-260,-70}}, color={191,0,0}));
  connect(timPumSta.passed, lat.clr) annotation (Line(points={{162,-38},{230,-38},
          {230,-232},{-314,-232},{-314,34},{-302,34}}, color={255,0,255}));
  connect(lat2.y, lat1.clr) annotation (Line(points={{302,-70},{306,-70},{306,
          220},{-300,220},{-300,154},{-262,154}}, color={255,0,255}));
  connect(val1.port_b,boi1. port_b)
    annotation (Line(points={{20,-150},{90,-150}}, color={0,127,255}));
  connect(val2.port_b, boi2.port_b)
    annotation (Line(points={{20,-210},{90,-210}}, color={0,127,255}));
  connect(boi1.T, conPIDBoi[1].u_m)
    annotation (Line(points={{89,-142},{50,-142},{50,-132}}, color={0,0,127}));
  connect(boi2.T, conPIDBoi[2].u_m)
    annotation (Line(points={{89,-202},{50,-202},{50,-132}}, color={0,0,127}));
  connect(hys2.u, pum.y_actual)
    annotation (Line(points={{98,-30},{-37,-30},{-37,-39}}, color={0,0,127}));
  connect(uPumSpe, swiPum.u1) annotation (Line(points={{-340,0},{-300,0},{-300,-2},
          {-222,-2}}, color={0,0,127}));
  connect(zer.y, swiPum.u3) annotation (Line(points={{-278,-20},{-270,-20},{-270,
          -18},{-222,-18}}, color={0,0,127}));
  connect(logSwi.y, swiPum.u2) annotation (Line(points={{-238,40},{-228,40},{-228,
          -10},{-222,-10}}, color={255,0,255}));
  connect(swiPum.y, pum.y) annotation (Line(points={{-198,-10},{-100,-10},{-100,
          -50},{-42,-50}}, color={0,0,127}));
  connect(senTem.T, conPIDPla.u_m) annotation (Line(points={{-10,131},{-10,140},
          {0,140},{0,168}}, color={0,0,127}));
  connect(TPlaHotWatSupSet, conPIDPla.u_s) annotation (Line(points={{-340,-160},
          {-90,-160},{-90,180},{-12,180}}, color={0,0,127}));
  connect(uBoiSta, edg.u) annotation (Line(points={{-340,160},{-310,160},{-310,120},
          {-172,120}},                       color={255,0,255}));
  connect(reaScaRep.y, lin.u) annotation (Line(points={{162,180},{172,180},{172,
          20},{-190,20},{-190,-180},{-182,-180}}, color={0,0,127}));
  connect(con.y, lin.x1) annotation (Line(points={{-218,-140},{-186,-140},{-186,
          -172},{-182,-172}}, color={0,0,127}));
  connect(con1.y, lin.x2) annotation (Line(points={{-218,-200},{-186,-200},{-186,
          -184},{-182,-184}}, color={0,0,127}));
  connect(con2.y, lin.f2) annotation (Line(points={{-258,-180},{-200,-180},{-200,
          -188},{-182,-188}}, color={0,0,127}));
  connect(pro1.y, conPIDBoi.u_s)
    annotation (Line(points={{-98,-120},{38,-120}}, color={0,0,127}));
  connect(TBoiHotWatSupSet, lin.f1) annotation (Line(points={{-340,-110},{-200,-110},
          {-200,-176},{-182,-176}}, color={0,0,127}));
  connect(lin.y, pro1.u2) annotation (Line(points={{-158,-180},{-130,-180},{-130,
          -126},{-122,-126}}, color={0,0,127}));
  connect(conPIDBoi[1].y, boi1.y) annotation (Line(points={{62,-120},{128,-120},
          {128,-142},{112,-142}}, color={0,0,127}));
  connect(conPIDBoi[2].y, boi2.y) annotation (Line(points={{62,-120},{128,-120},
          {128,-202},{112,-202}}, color={0,0,127}));
  connect(conPIDBoi.y, lesThr.u)
    annotation (Line(points={{62,-120},{178,-120}}, color={0,0,127}));
  connect(conPIDBoi.y, greThr3.u) annotation (Line(points={{62,-120},{128,-120},
          {128,-200},{178,-200}}, color={0,0,127}));
  connect(edg.y, conPIDBoi.trigger) annotation (Line(points={{-148,120},{-80,120},
          {-80,-190},{44,-190},{44,-132}}, color={255,0,255}));
  connect(uPla, edg1.u) annotation (Line(points={{-340,200},{-140,200},{-140,180},
          {-132,180}}, color={255,0,255}));
  connect(edg1.y, conPIDPla.trigger) annotation (Line(points={{-108,180},{-100,
          180},{-100,150},{-6,150},{-6,168}}, color={255,0,255}));
  connect(mul.y, reaScaRep.u)
    annotation (Line(points={{122,180},{138,180}}, color={0,0,127}));
  connect(conPIDPla.y, mul.u2) annotation (Line(points={{12,180},{20,180},{20,
          174},{98,174}}, color={0,0,127}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{82,200},{90,200},{90,186},
          {98,186}}, color={0,0,127}));
  connect(uPla, booToRea.u)
    annotation (Line(points={{-340,200},{58,200}}, color={255,0,255}));
  connect(uHotIsoVal[1], val1.y) annotation (Line(points={{-340,70},{-50,70},{-50,
          -100},{10,-100},{10,-138}}, color={0,0,127}));
  connect(uHotIsoVal[2], val2.y) annotation (Line(points={{-340,90},{-50,90},{-50,
          -180},{10,-180},{10,-198}}, color={0,0,127}));
  connect(val1.y_actual, yHotWatIsoVal[1]) annotation (Line(points={{15,-143},{32,
          -143},{32,-170},{290,-170},{290,-160},{340,-160}}, color={0,0,127}));
  connect(val2.y_actual, yHotWatIsoVal[2]) annotation (Line(points={{15,-203},{32,
          -203},{32,-170},{290,-170},{290,-140},{340,-140}}, color={0,0,127}));
  connect(senTem2.port_b, spl6.port_2) annotation (Line(points={{210,-20},{210,
          -150},{160,-150}},
                       color={0,127,255}));
  connect(spl4.port_3, senVolFlo1.port_a)
    annotation (Line(points={{-20,40},{20,40}}, color={0,127,255}));
  connect(senVolFlo1.port_b, val.port_a)
    annotation (Line(points={{40,40},{80,40}}, color={0,127,255}));
  connect(val.port_b, senTem3.port_a)
    annotation (Line(points={{100,40},{120,40}}, color={0,127,255}));
  connect(senTem3.port_b, spl5.port_3)
    annotation (Line(points={{140,40},{200,40}}, color={0,127,255}));
  connect(spl4.port_2, senVolFlo2.port_a)
    annotation (Line(points={{-30,50},{-30,94}}, color={0,127,255}));
  connect(senVolFlo2.port_b, senTem.port_a) annotation (Line(points={{-30,114},
          {-30,120},{-20,120}}, color={0,127,255}));
  connect(senTem1.port_b, pipe.port_a)
    annotation (Line(points={{80,120},{130,120}}, color={0,127,255}));
  connect(spl5.port_2, senTem2.port_a)
    annotation (Line(points={{210,30},{210,0}}, color={0,127,255}));
  connect(pipe.port_b, senTem4.port_a)
    annotation (Line(points={{150,120},{180,120}}, color={0,127,255}));
  connect(senTem4.port_b, spl5.port_1) annotation (Line(points={{200,120},{210,
          120},{210,50}}, color={0,127,255}));
  connect(senTem2.T, yRetTem) annotation (Line(points={{221,-10},{250,-10},{250,
          60},{340,60}}, color={0,0,127}));
  annotation (defaultComponentName="boiPla",
    Documentation(info="<html>
      <p>
      This model implements a primary-only, condensing boiler plant with a headered, 
      variable-speed primary pump, as defined in ASHRAE RP-1711, March 2020 draft.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      October 28, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-320,-240},{320,240}})),
    Icon(coordinateSystem(extent={{-100,-140},{100,140}}),
      graphics={
        Rectangle(
          extent={{-100,140},{100,-140}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-140},{100,-180}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,-18},{40,-98}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-54},{60,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-60},{60,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-80},{-12,-98},{14,-98},{0,-80}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(extent={{-80,58},{-50,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-80,40},{-50,40},{-66,58},{-80,40}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,-40},{-66,-12}}, color={28,108,200}),
        Line(points={{-66,58},{-66,134}},color={28,108,200}),
        Line(points={{70,132},{70,-44},{70,-50}},color={28,108,200}),
        Polygon(points={{-80,26},{-80,26}}, lineColor={28,108,200}),
        Polygon(
          points={{-76,-12},{-54,-12},{-66,0},{-76,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,12},{-54,12},{-66,0},{-76,12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,12},{-66,26}}, color={28,108,200}),
        Ellipse(
          extent={{-82,-40},{-52,-72}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Ellipse(
          extent={{56,-38},{86,-70}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end BoilerPlant;
