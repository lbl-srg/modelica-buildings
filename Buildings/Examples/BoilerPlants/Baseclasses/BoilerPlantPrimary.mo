within Buildings.Examples.BoilerPlants.Baseclasses;
model BoilerPlantPrimary
  "Boiler plant primary loop model for closed loop testing"

  replaceable package MediumW = Buildings.Media.Water
    "Fluid medium model";

  parameter Integer nSec(min=0) = 2
    "Number of secondary loops connected to the primary loop"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = boiEff1[1]*boiCap1 + boiEff2[1]*boiCap2
    "Nominal heat flow rate of radiator"
    annotation(Dialog(group="Plant parameters"));

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
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate boiCap2= 2200000
    "Boiler capacity for boiler-2"
    annotation(Dialog(group="Boiler parameters"));

  parameter Real boiEff1[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-1"
    annotation(Dialog(group="Boiler parameters"));

  parameter Real boiEff2[6](
    final unit="1",
    displayUnit="1") = {0.6246, 0.7711, -1.2077*10e-15, 0.008576, -0.005933, 0.003156}
    "Efficiency for boiler-2"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mSec_flow_nominal=0.113*1000
    "Secondary load nominal mass flow rate"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal1=mSec_flow_nominal
    "Boiler-1 nominal mass flow rate"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi_flow_nominal2=mSec_flow_nominal
    "Boiler-2 nominal mass flow rate"
    annotation(Dialog(group="Boiler parameters"));

  final constant Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoiOri
    "Original record for boiler performance data is scaled below";

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi1(
    final Q_flow_nominal = boiCap1,
    final VWat = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = boiCap1/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{260,162},{280,182}})));

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi2(
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
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotIsoVal[2]
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{-360,-130},{-320,-90}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-360,-90},{-320,-50}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{320,-130},{360,-90}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,80},{360,120}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,40},{360,80}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatDp[1](
    final unit="Pa",
    displayUnit="Pa")
    "Hot water differential pressure between supply and return"
    annotation (Placement(transformation(extent={{320,-10},{360,30}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-50},{360,-10}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[2]
    "Measured boiler hot water isolation valve position"
    annotation (Placement(transformation(extent={{320,-170},{360,-130}}),
      iconTransformation(extent={{100,-200},{140,-160}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumW) "HW return port" annotation (Placement(transformation(extent={{
            30,230},{50,250}}), iconTransformation(extent={{60,130},{80,150}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumW) "HW supply port" annotation (Placement(transformation(extent={{
            -50,230},{-30,250}}), iconTransformation(extent={{-80,130},{-60,150}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    final p=100000,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Fluid.Boilers.BoilerTable boi2(
    redeclare package Medium = MediumW,
    allowFlowReversal=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=perBoi2)
    "Boiler-2"
    annotation (Placement(transformation(extent={{110,-220},{90,-200}})));

  Buildings.Fluid.Boilers.BoilerTable boi1(
    redeclare package Medium = MediumW,
    allowFlowReversal=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final per=perBoi1) "Boiler-1"
    annotation (Placement(transformation(extent={{110,-160},{90,-140}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=true,
    final addPowerToMedium=false,
    final riseTime=60,
    final m_flow_nominal=mSec_flow_nominal/2,
    dp_nominal(displayUnit="Pa") = 50000)
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
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{0,-220},{20,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi_flow_nominal1,
    final dpValve_nominal=dpValve_nominal_value,
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
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
    final m_flow_nominal=mSec_flow_nominal)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-10})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,14})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=1)
    "Real replicator"
    annotation (Placement(transformation(extent={{280,0},{300,20}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2[2](
    final uLow=fill(0.05, 2),
    final uHigh=fill(0.09, 2))
    "Check if pumps are on"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timPumSta[2](final t=fill(10, 2))
    "Output pump proven on signal when pump status is enabled for two minutes"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));

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

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi_flow_nominal1,mSec_flow_nominal,-mBoi_flow_nominal2},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={150,-150})));

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

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Detect changes to boiler status setpoints"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));

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

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem4(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal)
    "HW return temperature sensor after water exits return plumbing"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipe1(
    redeclare package Medium = MediumW,
    final allowFlowReversal=false,
    final m_flow_nominal=mSec_flow_nominal,
    dp_nominal=500)
    "Pipe element for decoupler leg"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul[2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=true,
    final addPowerToMedium=false,
    final riseTime=60,
    m_flow_nominal=mSec_flow_nominal/2,
    dp_nominal(displayUnit="Pa") = 50000)
    "Hot water primary pump-2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-50})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=2)
    "Replicate pump speed signal into vector"
    annotation (Placement(transformation(extent={{-300,-10},{-280,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe[2](
    final unit="1",
    displayUnit="1")
    "Measured primary pump speed"
    annotation (Placement(transformation(extent={{320,-220},{360,-180}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDec_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured decoupler flowrate"
    annotation (Placement(transformation(extent={{320,180},{360,220}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TRetSec(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit = "degC",
    min = 0)
    "Measured decoupler flowrate"
    annotation (Placement(transformation(extent={{320,220},{360,260}}),
      iconTransformation(extent={{100,160},{140,200}})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal/2,
    final dpValve_nominal=1e-6,
    final l=1e-7)
    "Check valve for primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-80})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mSec_flow_nominal/2,
    final dpValve_nominal=1e-6,
    final l=1e-7)
    "Check valve for primary pump-2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-80})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,70},{-280,90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](
    final t=fill(0.95,2),
    final h=fill(0.05, 2))
    "Check if isolation valve is opened"
    annotation (Placement(transformation(extent={{280,-160},{300,-140}})));

  Controls.OBC.CDL.Conversions.BooleanToReal           booToRea3[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));
  Controls.OBC.CDL.Reals.Multiply           mul1
                                               [2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-260,10},{-240,30}})));
  Fluid.FixedResistances.Junction           spl2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mSec_flow_nominal,
        mBoi_flow_nominal1},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-110})));
  Fluid.FixedResistances.Junction           spl3(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi_flow_nominal2,-mSec_flow_nominal,
        mBoi_flow_nominal1},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-66,-30})));
equation
  connect(val1.port_a, spl1.port_3)
    annotation (Line(points={{0,-150},{-20,-150}},    color={0,127,255}));
  connect(val2.port_a, spl1.port_1) annotation (Line(points={{0,-210},{-30,-210},
          {-30,-160}}, color={0,127,255}));

  connect(spl4.port_2, senRelPre.port_a) annotation (Line(points={{-30,50},{-30,
          80},{80,80}},    color={0,127,255}));

  connect(senRelPre.port_b, spl5.port_1) annotation (Line(points={{100,80},{210,
          80},{210,50}},   color={0,127,255}));

  connect(senVolFlo.V_flow, VHotWatPri_flow) annotation (Line(points={{-41,-10},
          {-50,-10},{-50,8},{180,8},{180,-30},{340,-30}},
                                                  color={0,0,127}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-41,14},{-48,14},{-48,64},
          {300,64},{300,100},{340,100}},            color={0,0,127}));

  connect(reaRep.y, yHotWatDp)
    annotation (Line(points={{302,10},{340,10}},     color={0,0,127}));

  connect(senRelPre.p_rel, reaRep.u) annotation (Line(points={{90,71},{90,66},{240,
          66},{240,10},{278,10}},           color={0,0,127}));

  connect(hys2.y, timPumSta.u)
    annotation (Line(points={{122,-30},{138,-30}}, color={255,0,255}));
  connect(boi1.port_a, spl6.port_1)
    annotation (Line(points={{110,-150},{140,-150}}, color={0,127,255}));
  connect(boi2.port_a, spl6.port_3) annotation (Line(points={{110,-210},{150,-210},
          {150,-160}}, color={0,127,255}));
  connect(TZon, TRoo.T)
    annotation (Line(points={{-340,-70},{-282,-70}}, color={0,0,127}));
  connect(TRoo.port, pipe.heatPort) annotation (Line(points={{-260,-70},{-140,
          -70},{-140,100},{100,100},{100,130},{140,130}},
                                                   color={191,0,0}));
  connect(boi1.heatPort, TRoo.port) annotation (Line(points={{100,-142.8},{100,
          -86},{-120,-86},{-120,-70},{-260,-70}}, color={191,0,0}));
  connect(boi2.heatPort, TRoo.port) annotation (Line(points={{100,-202.8},{100,-180},
          {84,-180},{84,-86},{-120,-86},{-120,-70},{-260,-70}}, color={191,0,0}));
  connect(val1.port_b,boi1. port_b)
    annotation (Line(points={{20,-150},{90,-150}}, color={0,127,255}));
  connect(val2.port_b, boi2.port_b)
    annotation (Line(points={{20,-210},{90,-210}}, color={0,127,255}));
  connect(boi1.T, conPIDBoi[1].u_m)
    annotation (Line(points={{89,-142},{50,-142},{50,-132}}, color={0,0,127}));
  connect(boi2.T, conPIDBoi[2].u_m)
    annotation (Line(points={{89,-202},{50,-202},{50,-132}}, color={0,0,127}));
  connect(uBoiSta, edg.u) annotation (Line(points={{-340,160},{-310,160},{-310,120},
          {-172,120}},                       color={255,0,255}));
  connect(conPIDBoi[1].y, boi1.y) annotation (Line(points={{62,-120},{128,-120},
          {128,-142},{112,-142}}, color={0,0,127}));
  connect(conPIDBoi[2].y, boi2.y) annotation (Line(points={{62,-120},{128,-120},
          {128,-202},{112,-202}}, color={0,0,127}));
  connect(edg.y, conPIDBoi.trigger) annotation (Line(points={{-148,120},{-80,120},
          {-80,-190},{44,-190},{44,-132}}, color={255,0,255}));
  connect(senTem2.port_b, spl6.port_2) annotation (Line(points={{210,-20},{210,
          -150},{160,-150}},
                       color={0,127,255}));
  connect(spl4.port_3, senVolFlo1.port_a)
    annotation (Line(points={{-20,40},{20,40}}, color={0,127,255}));
  connect(senTem3.port_b, spl5.port_3)
    annotation (Line(points={{140,40},{200,40}}, color={0,127,255}));

  connect(spl5.port_2, senTem2.port_a)
    annotation (Line(points={{210,30},{210,0}}, color={0,127,255}));
  connect(pipe.port_b, senTem4.port_a)
    annotation (Line(points={{150,120},{180,120}}, color={0,127,255}));
  connect(senTem4.port_b, spl5.port_1) annotation (Line(points={{200,120},{210,
          120},{210,50}}, color={0,127,255}));
  connect(senTem2.T, yRetTem) annotation (Line(points={{221,-10},{250,-10},{250,
          60},{340,60}}, color={0,0,127}));
  connect(pipe1.port_a, senVolFlo1.port_b) annotation (Line(points={{80,40},{40,
          40}},             color={0,127,255}));
  connect(pipe1.port_b, senTem3.port_a) annotation (Line(points={{100,40},{120,40}},
                              color={0,127,255}));
  connect(TBoiHotWatSupSet, mul.u2) annotation (Line(points={{-340,-110},{-340,-112},
          {-132,-112},{-132,154},{-122,154}}, color={0,0,127}));
  connect(booToRea1.y, mul.u1) annotation (Line(points={{-138,160},{-128,160},{-128,
          166},{-122,166}}, color={0,0,127}));
  connect(mul.y, conPIDBoi.u_s) annotation (Line(points={{-98,160},{-88,160},{-88,
          -120},{38,-120}}, color={0,0,127}));
  connect(senVolFlo.port_b, senTem.port_a)
    annotation (Line(points={{-30,0},{-30,4}}, color={0,127,255}));
  connect(senTem.port_b, spl4.port_1) annotation (Line(points={{-30,24},{-28,24},
          {-28,30},{-30,30}}, color={0,127,255}));
  connect(pum1.y_actual, hys2[1].u)
    annotation (Line(points={{-37,-39},{-37,-30},{98,-30}}, color={0,0,127}));
  connect(pum2.y_actual, hys2[2].u)
    annotation (Line(points={{-7,-39},{-7,-30},{98,-30}}, color={0,0,127}));
  connect(timPumSta.passed, yPumSta) annotation (Line(points={{162,-38},{230,-38},
          {230,-110},{340,-110}}, color={255,0,255}));
  connect(uPumSpe, reaScaRep.u)
    annotation (Line(points={{-340,0},{-302,0}}, color={0,0,127}));
  connect(pum1.y_actual, yPriPumSpe[1]) annotation (Line(points={{-37,-39},{-37,
          -32},{-56,-32},{-56,-236},{308,-236},{308,-205},{340,-205}}, color={0,
          0,127}));
  connect(pum2.y_actual, yPriPumSpe[2]) annotation (Line(points={{-7,-39},{-7,
          -32},{76,-32},{76,-176},{308,-176},{308,-195},{340,-195}},
                                                                color={0,0,127}));
  connect(senVolFlo1.V_flow, VDec_flow) annotation (Line(points={{30,51},{30,216},
          {300,216},{300,200},{340,200}},
        color={0,0,127}));
  connect(senTem4.T, TRetSec) annotation (Line(points={{190,131},{256,131},{256,
          240},{340,240}}, color={0,0,127}));
  connect(preSou.ports[1], spl1.port_2) annotation (Line(points={{-100,-130},{
          -100,-132},{-60,-132},{-60,-128},{-30,-128},{-30,-140}}, color={0,127,
          255}));
  connect(cheVal1.port_b, pum1.port_a)
    annotation (Line(points={{-30,-70},{-30,-60}}, color={0,127,255}));
  connect(cheVal2.port_b,pum2. port_a)
    annotation (Line(points={{0,-70},{0,-60}}, color={0,127,255}));
  connect(uHotIsoVal, booToRea2.u)
    annotation (Line(points={{-340,80},{-302,80}}, color={255,0,255}));
  connect(booToRea2[1].y, val1.y) annotation (Line(points={{-278,80},{-160,80},{
          -160,-106},{10,-106},{10,-138}}, color={0,0,127}));
  connect(booToRea2[2].y, val2.y) annotation (Line(points={{-278,80},{-160,80},{
          -160,-186},{10,-186},{10,-198}}, color={0,0,127}));
  connect(yHotWatIsoVal, greThr1.y)
    annotation (Line(points={{340,-150},{302,-150}}, color={255,0,255}));
  connect(val1.y_actual, greThr1[1].u) annotation (Line(points={{15,-143},{16,-143},
          {16,-100},{272,-100},{272,-150},{278,-150}}, color={0,0,127}));
  connect(val2.y_actual, greThr1[2].u) annotation (Line(points={{15,-203},{16,-203},
          {16,-168},{40,-168},{40,-140},{28,-140},{28,-132},{16,-132},{16,-100},
          {272,-100},{272,-150},{278,-150}}, color={0,0,127}));
  connect(uBoiSta, booToRea1.u)
    annotation (Line(points={{-340,160},{-162,160}}, color={255,0,255}));
  connect(uPumSta, booToRea3.u)
    annotation (Line(points={{-340,40},{-302,40}}, color={255,0,255}));
  connect(booToRea3.y, mul1.u1) annotation (Line(points={{-278,40},{-272,40},{-272,
          26},{-262,26}}, color={0,0,127}));
  connect(reaScaRep.y, mul1.u2) annotation (Line(points={{-278,0},{-272,0},{-272,
          14},{-262,14}}, color={0,0,127}));
  connect(mul1[1].y, pum1.y) annotation (Line(points={{-238,20},{-100,20},{-100,
          -50},{-42,-50}}, color={0,0,127}));
  connect(mul1[2].y, pum2.y) annotation (Line(points={{-238,20},{-100,20},{-100,
          -64},{-12,-64},{-12,-50}}, color={0,0,127}));
  connect(spl1.port_2, spl2.port_1)
    annotation (Line(points={{-30,-140},{-30,-120}}, color={0,127,255}));
  connect(spl2.port_2, cheVal1.port_a)
    annotation (Line(points={{-30,-100},{-30,-90}}, color={0,127,255}));
  connect(spl2.port_3, cheVal2.port_a)
    annotation (Line(points={{-20,-110},{0,-110},{0,-90}}, color={0,127,255}));
  connect(spl3.port_1, pum1.port_b)
    annotation (Line(points={{-66,-40},{-68,-40},{-68,-48},{-48,-48},{-48,-28},
          {-30,-28},{-30,-40}},                    color={0,127,255}));
  connect(spl3.port_3, pum2.port_b)
    annotation (Line(points={{-56,-30},{-56,-24},{-12,-24},{-12,-28},{0,-28},{0,
          -40}},                                           color={0,127,255}));
  connect(spl3.port_2, senVolFlo.port_a)
    annotation (Line(points={{-66,-20},{-66,-8},{-52,-8},{-52,-22},{-30,-22},{
          -30,-20}},                               color={0,127,255}));
  connect(port_a, pipe.port_a)
    annotation (Line(points={{40,240},{40,120},{130,120}}, color={0,127,255}));
  connect(spl4.port_2, port_b) annotation (Line(points={{-30,50},{-32,50},{-32,
          224},{-40,224},{-40,240}}, color={0,127,255}));
  annotation (defaultComponentName="boiPlaPri",
    Documentation(info="<html>
      <p>
      This model implements a boiler plant primary loop with 2 condensing boilers,
      2 variable-speed primary pumps, and a common decoupler leg. Additionally,
      it includes controls to enable the boilers and pumps and hold their enable
      status until they are proven on. It also includes PID loops to operate the
      boilers at the required supply temperature setpoint signal.
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
    Icon(coordinateSystem(extent={{-100,-160},{100,160}}),
      graphics={
        Rectangle(
          extent={{-100,160},{100,-160}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-160},{100,-200}},
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
end BoilerPlantPrimary;
