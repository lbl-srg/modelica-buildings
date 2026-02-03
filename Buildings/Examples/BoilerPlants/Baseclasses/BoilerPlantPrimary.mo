within Buildings.Examples.BoilerPlants.Baseclasses;
model BoilerPlantPrimary
  "Boiler plant primary loop model for closed loop testing"

  replaceable package MediumW = Buildings.Media.Water
    "Fluid medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=QBoi1_flow_nominal+QBoi2_flow_nominal
    "Total boiler plant heating capacity"
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

  parameter Modelica.Units.SI.HeatFlowRate QBoi1_flow_nominal
    "Boiler-1 heating capacity"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QBoi2_flow_nominal
    "Boiler-2 heating capacity"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal
    "Plant nominal mass flow rate"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi1_flow_nominal=mPla_flow_nominal
    "Boiler-1 nominal mass flow rate"
    annotation(Dialog(group="Boiler parameters"));

  parameter Modelica.Units.SI.MassFlowRate mBoi2_flow_nominal=mPla_flow_nominal
    "Boiler-2 nominal mass flow rate"
    annotation(Dialog(group="Boiler parameters"));

  final constant Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoiOri
    "Original record for boiler performance data is scaled below";

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi1(
    final Q_flow_nominal = QBoi1_flow_nominal,
    final VWat = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal,
    dp_nominal=0)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{260,162},{280,182}})));

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi2(
    final Q_flow_nominal = QBoi2_flow_nominal,
    final VWat = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal,
    dp_nominal=0)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{260,192},{280,212}})));

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal_value(
    final min=dpFixed_nominal_value)
    "Nominal pressure drop of fully open isolation valve"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal_value
    "Pressure drop of boilers, isolation valves, pipes and other resistances that
    are in series in primary loop"
    annotation(Dialog(group="Plant parameters"));

  parameter Modelica.Units.SI.PressureDifference dpPumPri_nominal_value
    "Nominal primary pump pressure head"
    annotation(Dialog(group="Plant parameters"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeBoi1=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller"));

  parameter Real kBoi1(
    final unit="1",
    displayUnit="1",
    final min=0)=0.1
    "Gain of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-1 supply water temperature controller"));

  parameter Real TiBoi1(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=60
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
    final min=0)=0.1
    "Gain of controller"
    annotation(Dialog(tab="PI parameters", group="Boiler-2 supply water temperature controller"));

  parameter Real TiBoi2(
    final unit="s",
    displayUnit="s",
    final quantity="time",
    final min=0)=60
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
      iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{-360,-20},{-320,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotIsoVal[2]
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,20},{-320,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-60},{-320,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{-360,60},{-320,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-360,-180},{-320,-140}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{320,-40},{360,0}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,60},{360,100}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,20},{360,60}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,-10},{360,30}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[2]
    "Measured boiler hot water isolation valve position"
    annotation (Placement(transformation(extent={{320,-120},{360,-80}}),
      iconTransformation(extent={{100,-160},{140,-120}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW)
    "HW return port"
    annotation (Placement(transformation(extent={{30,230},{50,250}}),
      iconTransformation(extent={{60,110},{80,130}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW)
    "HW supply port"
    annotation (Placement(transformation(extent={{-50,230},{-30,250}}),
      iconTransformation(extent={{-76,110},{-56,130}})));

  Buildings.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    final p=100000,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));

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
    m_flow_nominal=mPla_flow_nominal,
    dp_nominal(displayUnit="Pa") = dpPumPri_nominal_value)
    "Hot water primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-50})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-150})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mPla_flow_nominal,-mPla_flow_nominal,-
        mPla_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,100})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mPla_flow_nominal,mPla_flow_nominal,-
        mPla_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,100})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi2_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{40,-220},{20,-200}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi1_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{40,-160},{20,-140}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,30})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,60})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys2[2](
    final uLow=fill(0.05, 2),
    final uHigh=fill(0.09, 2))
    "Check if pumps are on"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timPumSta[2](final t=fill(10, 2))
    "Output pump proven on signal when pump status is enabled for two minutes"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));

  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conPIDBoi[2](
    final controllerType={controllerTypeBoi1,controllerTypeBoi2},
    final k={kBoi1,kBoi2},
    final Ti={TiBoi1,TiBoi2},
    final Td={TdBoi1,TdBoi2},
    r={10,10},
    final yMax=fill(1, 2),
    final yMin=fill(0, 2),
    final xi_start=fill(0.2, 2))
    "PI controller for operating boilers to regulating hot water supply temperature"
    annotation (Placement(transformation(extent={{-138,150},{-118,170}})));

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi1_flow_nominal,mPla_flow_nominal,-
        mBoi2_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={150,-150})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRoo
    "Room temperature of boiler room"
    annotation (Placement(transformation(extent={{-260,-180},{-240,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Detect changes to boiler status setpoints"
    annotation (Placement(transformation(extent={{-240,110},{-220,130}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor in primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={210,40})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "Volume flow-rate through minimum flow bypass branch"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem4(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor after water exits return plumbing"
    annotation (Placement(transformation(extent={{180,150},{200,170}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipe1(
    redeclare package Medium = MediumW,
    final allowFlowReversal=false,
    final m_flow_nominal=mPla_flow_nominal,
    dp_nominal=500)
    "Pipe element for decoupler leg"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul[2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pum2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final allowFlowReversal=true,
    final addPowerToMedium=false,
    final riseTime=60,
    m_flow_nominal=mPla_flow_nominal,
    dp_nominal(displayUnit="Pa") = dpPumPri_nominal_value)
    "Hot water primary pump-2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-50})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=2)
    "Replicate pump speed signal into vector"
    annotation (Placement(transformation(extent={{-300,-50},{-280,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe[2](
    final unit=fill("1",2),
    displayUnit=fill("1",2))
    "Measured primary pump speed"
    annotation (Placement(transformation(extent={{320,-80},{360,-40}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDec_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured decoupler flowrate"
    annotation (Placement(transformation(extent={{320,90},{360,130}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TRetSec(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit = "degC",
    min = 0) "Measured secondary loop return temperature"
    annotation (Placement(transformation(extent={{320,120},{360,160}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal,
    final dpValve_nominal=500,
    final l=1e-7)
    "Check valve for primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-80})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal,
    final dpValve_nominal=500,
    final l=1e-7)
    "Check valve for primary pump-2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-80})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,30},{-280,50}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](
    final t=fill(0.95,2),
    final h=fill(0.05, 2))
    "Check if isolation valve is opened"
    annotation (Placement(transformation(extent={{280,-110},{300,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,-10},{-280,10}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul1[2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,
        mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-110})));

  Buildings.Fluid.FixedResistances.Junction spl3(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,
        mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-30,-10})));

equation

  connect(senVolFlo.V_flow, VHotWatPri_flow) annotation (Line(points={{-41,30},{
          -50,30},{-50,10},{340,10}},             color={0,0,127}));

  connect(senTem.T, ySupTem) annotation (Line(points={{-41,60},{-48,60},{-48,80},
          {340,80}},                                color={0,0,127}));

  connect(hys2.y, timPumSta.u)
    annotation (Line(points={{122,-30},{128,-30},{128,-20},{138,-20}},
                                                   color={255,0,255}));
  connect(boi1.port_a, spl6.port_1)
    annotation (Line(points={{110,-150},{140,-150}}, color={0,127,255}));
  connect(boi2.port_a, spl6.port_3) annotation (Line(points={{110,-210},{150,-210},
          {150,-160}}, color={0,127,255}));
  connect(TZon, TRoo.T)
    annotation (Line(points={{-340,-160},{-272,-160},{-272,-170},{-262,-170}},
                                                     color={0,0,127}));
  connect(boi1.heatPort, TRoo.port) annotation (Line(points={{100,-142.8},{100,-124},
          {70,-124},{70,-170},{-240,-170}},       color={191,0,0}));
  connect(boi2.heatPort, TRoo.port) annotation (Line(points={{100,-202.8},{100,-170},
          {-240,-170}},                                         color={191,0,0}));
  connect(boi1.T, conPIDBoi[1].u_m)
    annotation (Line(points={{89,-142},{80,-142},{80,-122},{-128,-122},{-128,148}},
                                                             color={0,0,127}));
  connect(boi2.T, conPIDBoi[2].u_m)
    annotation (Line(points={{89,-202},{80,-202},{80,-122},{-128,-122},{-128,148}},
                                                             color={0,0,127}));
  connect(uBoiSta, edg.u) annotation (Line(points={{-340,160},{-252,160},{-252,120},
          {-242,120}},                       color={255,0,255}));
  connect(conPIDBoi[1].y, boi1.y) annotation (Line(points={{-116,160},{-110,160},
          {-110,-182},{120,-182},{120,-142},{112,-142}},
                                  color={0,0,127}));
  connect(conPIDBoi[2].y, boi2.y) annotation (Line(points={{-116,160},{-110,160},
          {-110,-182},{120,-182},{120,-202},{112,-202}},
                                  color={0,0,127}));
  connect(edg.y, conPIDBoi.trigger) annotation (Line(points={{-218,120},{-134,120},
          {-134,148}},                     color={255,0,255}));
  connect(senTem2.port_b, spl6.port_2) annotation (Line(points={{210,30},{210,-150},
          {160,-150}}, color={0,127,255}));
  connect(spl4.port_3, senVolFlo1.port_a)
    annotation (Line(points={{-20,100},{20,100}},
                                                color={0,127,255}));
  connect(senTem3.port_b, spl5.port_3)
    annotation (Line(points={{140,100},{200,100}},
                                                 color={0,127,255}));

  connect(spl5.port_2, senTem2.port_a)
    annotation (Line(points={{210,90},{210,50}},color={0,127,255}));
  connect(senTem4.port_b, spl5.port_1) annotation (Line(points={{200,160},{210,160},
          {210,110}},     color={0,127,255}));
  connect(senTem2.T, yRetTem) annotation (Line(points={{221,40},{340,40}},
                         color={0,0,127}));
  connect(pipe1.port_a, senVolFlo1.port_b) annotation (Line(points={{80,100},{40,
          100}},            color={0,127,255}));
  connect(pipe1.port_b, senTem3.port_a) annotation (Line(points={{100,100},{120,
          100}},              color={0,127,255}));
  connect(TBoiHotWatSupSet, mul.u2) annotation (Line(points={{-340,80},{-200,80},
          {-200,154},{-182,154}},             color={0,0,127}));
  connect(booToRea1.y, mul.u1) annotation (Line(points={{-218,160},{-192,160},{-192,
          166},{-182,166}}, color={0,0,127}));
  connect(mul.y, conPIDBoi.u_s) annotation (Line(points={{-158,160},{-140,160}},
                            color={0,0,127}));
  connect(pum1.y_actual, hys2[1].u)
    annotation (Line(points={{-37,-39},{-37,-30},{98,-30}}, color={0,0,127}));
  connect(pum2.y_actual, hys2[2].u)
    annotation (Line(points={{-7,-39},{-7,-30},{98,-30}}, color={0,0,127}));
  connect(timPumSta.passed, yPumSta) annotation (Line(points={{162,-28},{308,-28},
          {308,-20},{340,-20}},   color={255,0,255}));
  connect(uPumSpe, reaScaRep.u)
    annotation (Line(points={{-340,-40},{-302,-40}},
                                                 color={0,0,127}));
  connect(pum1.y_actual, yPriPumSpe[1]) annotation (Line(points={{-37,-39},{-37,
          -30},{92,-30},{92,-48},{308,-48},{308,-65},{340,-65}},       color={0,
          0,127}));
  connect(pum2.y_actual, yPriPumSpe[2]) annotation (Line(points={{-7,-39},{-7,-30},
          {92,-30},{92,-48},{308,-48},{308,-55},{340,-55}},     color={0,0,127}));
  connect(senVolFlo1.V_flow, VDec_flow) annotation (Line(points={{30,111},{30,120},
          {300,120},{300,110},{340,110}},
        color={0,0,127}));
  connect(senTem4.T, TRetSec) annotation (Line(points={{190,171},{190,180},{248,
          180},{248,140},{340,140}},
                           color={0,0,127}));
  connect(preSou.ports[1], spl1.port_2) annotation (Line(points={{-60,-150},{-60,
          -152},{-48,-152},{-48,-132},{-30,-132},{-30,-140}},      color={0,127,
          255}));
  connect(cheVal1.port_b, pum1.port_a)
    annotation (Line(points={{-30,-70},{-30,-60}}, color={0,127,255}));
  connect(cheVal2.port_b,pum2. port_a)
    annotation (Line(points={{0,-70},{0,-60}}, color={0,127,255}));
  connect(uHotIsoVal, booToRea2.u)
    annotation (Line(points={{-340,40},{-302,40}}, color={255,0,255}));
  connect(booToRea2[1].y, val1.y) annotation (Line(points={{-278,40},{-140,40},{
          -140,-128},{30,-128},{30,-138}}, color={0,0,127}));
  connect(booToRea2[2].y, val2.y) annotation (Line(points={{-278,40},{-140,40},{
          -140,-128},{48,-128},{48,-192},{30,-192},{30,-198}},
                                           color={0,0,127}));
  connect(yHotWatIsoVal, greThr1.y)
    annotation (Line(points={{340,-100},{302,-100}}, color={255,0,255}));
  connect(val1.y_actual, greThr1[1].u) annotation (Line(points={{25,-143},{10,-143},
          {10,-100},{278,-100}},                       color={0,0,127}));
  connect(val2.y_actual, greThr1[2].u) annotation (Line(points={{25,-203},{10,-203},
          {10,-100},{278,-100}},             color={0,0,127}));
  connect(uBoiSta, booToRea1.u)
    annotation (Line(points={{-340,160},{-242,160}}, color={255,0,255}));
  connect(uPumSta, booToRea3.u)
    annotation (Line(points={{-340,0},{-302,0}},   color={255,0,255}));
  connect(booToRea3.y, mul1.u1) annotation (Line(points={{-278,0},{-272,0},{-272,
          -14},{-262,-14}},
                          color={0,0,127}));
  connect(reaScaRep.y, mul1.u2) annotation (Line(points={{-278,-40},{-272,-40},{
          -272,-26},{-262,-26}},
                          color={0,0,127}));
  connect(mul1[1].y, pum1.y) annotation (Line(points={{-238,-20},{-56,-20},{-56,
          -50},{-42,-50}}, color={0,0,127}));
  connect(mul1[2].y, pum2.y) annotation (Line(points={{-238,-20},{-56,-20},{-56,
          -28},{-12,-28},{-12,-50}}, color={0,0,127}));
  connect(spl1.port_2, spl2.port_1)
    annotation (Line(points={{-30,-140},{-30,-120}}, color={0,127,255}));
  connect(spl2.port_2, cheVal1.port_a)
    annotation (Line(points={{-30,-100},{-30,-90}}, color={0,127,255}));
  connect(spl2.port_3, cheVal2.port_a)
    annotation (Line(points={{-20,-110},{0,-110},{0,-90}}, color={0,127,255}));
  connect(spl3.port_1, pum1.port_b)
    annotation (Line(points={{-30,-20},{-30,-40}}, color={0,127,255}));
  connect(spl3.port_3, pum2.port_b)
    annotation (Line(points={{-20,-10},{0,-10},{0,-40}},   color={0,127,255}));
  connect(spl3.port_2, senVolFlo.port_a)
    annotation (Line(points={{-30,0},{-30,20}},    color={0,127,255}));
  connect(val2.port_b, spl1.port_1) annotation (Line(points={{20,-210},{-30,-210},
          {-30,-160}},            color={0,127,255}));
  connect(val1.port_b, spl1.port_3)
    annotation (Line(points={{20,-150},{-20,-150}},color={0,127,255}));
  connect(boi1.port_b, val1.port_a) annotation (Line(points={{90,-150},{40,-150}},
                                                    color={0,127,255}));
  connect(boi2.port_b, val2.port_a)
    annotation (Line(points={{90,-210},{40,-210}}, color={0,127,255}));
  connect(port_a, senTem4.port_a)
    annotation (Line(points={{40,240},{40,160},{180,160}}, color={0,127,255}));
  connect(senVolFlo.port_b, senTem.port_a)
    annotation (Line(points={{-30,40},{-30,50}}, color={0,127,255}));
  connect(senTem.port_b, spl4.port_1)
    annotation (Line(points={{-30,70},{-30,90}}, color={0,127,255}));
  connect(spl4.port_2, port_b) annotation (Line(points={{-30,110},{-32,110},{-32,
          126},{-40,126},{-40,240}},
                           color={0,127,255}));
  annotation (defaultComponentName="boiPlaPri",
    Documentation(info="<html>
      <p>
      This class implements a boiler plant primary loop with 2 condensing boilers,
      2 variable-speed primary pumps, and a common decoupler leg.
      Additionally, it includes PID loops to operate the boilers at the required
      supply temperature setpoint signal.
    </p>

    <p>
      The intended use-case for this class is to combine it with single or multiple
      instances of the secondary loop class
      <a href=\"modelica://Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad\">
        Buildings.Examples.BoilerPlants.Baseclasses.SimplifiedSecondaryLoad
      </a>
      to create a primary-secondary boiler plant with variable-primary and variable-secondary
      pumps.
    </p>

    <p>A few key points when using this class are as follows:</p>
    <ul>
      <li>
        The parameter <code>dpFixed_nominal_value</code> must be provided an appropriate
        value to represent the cumulative pressure drop in the primary loop.
        The parameter <code>dpValve_nominal_value</code> must be provided a value
        that is at minimum equal to <code>dpFixed_nominal_value</code>, to ensure
        valve authority <code>&ge;50%</code>.
      </li>
      <li>
        The parameter <code>dpPumPri_nominal_value</code> must be tuned to provide
        positive flow in the decoupler leg measured by signal <code>VDec_flow</code>
        when the secondary loops are drawing maximum hot-water.
      </li>
    </ul>
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
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,-160},{100,-200}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-40,-38},{40,-118}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-74},{60,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-80},{60,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-100},{-12,-118},{14,-118},{0,-100}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(extent={{-80,38},{-50,6}},  lineColor={28,108,200}),
        Polygon(
          points={{-80,20},{-50,20},{-66,38},{-80,20}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,-60},{-66,-32}}, color={28,108,200}),
        Line(points={{-66,38},{-66,114}},color={28,108,200}),
        Line(points={{70,112},{70,-64},{70,-70}},color={28,108,200}),
        Polygon(points={{-80,6},{-80,6}},   lineColor={28,108,200}),
        Polygon(
          points={{-76,-32},{-54,-32},{-66,-20},{-76,-32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,-8},{-54,-8},{-66,-20},{-76,-8}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-66,-8},{-66,6}},  color={28,108,200}),
        Ellipse(
          extent={{-82,-60},{-52,-92}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Ellipse(
          extent={{56,-58},{86,-90}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}));
end BoilerPlantPrimary;
