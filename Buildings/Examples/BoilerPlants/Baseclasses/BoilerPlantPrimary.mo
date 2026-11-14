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

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoiOri
    "Original record for boiler performance data is scaled below";

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi1(
    final Q_flow_nominal = QBoi1_flow_nominal,
    final VWat = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = QBoi1_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal,
    dp_nominal=0)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));

  final parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 perBoi2(
    final Q_flow_nominal = QBoi2_flow_nominal,
    final VWat = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.VWat,
    final mDry = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.mDry,
    final m_flow_nominal = QBoi2_flow_nominal/perBoiOri.Q_flow_nominal*perBoiOri.m_flow_nominal,
    dp_nominal=0)
    "Boiler performance data, scaled to while keeping dp_nominal constant"
    annotation (Placement(transformation(extent={{-280,200},{-260,220}})));

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
    annotation (Placement(transformation(extent={{-360,-10},{-320,30}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotIsoVal[2]
    "Hot water isolation valve signal"
    annotation (Placement(transformation(extent={{-360,40},{-320,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1")
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-360,-68},{-320,-28}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TBoiHotWatSupSet[2](
    final unit=fill("K", 2),
    displayUnit=fill("degC", 2),
    final quantity=fill("ThermodynamicTemperature", 2))
    "Boiler hot water supply temperature setpoint vector"
    annotation (Placement(transformation(extent={{-360,100},{-320,140}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-360,-200},{-320,-160}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSta[2]
    "Pump status signal"
    annotation (Placement(transformation(extent={{320,-58},{360,-18}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply temperature"
    annotation (Placement(transformation(extent={{320,90},{360,130}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetTem(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured return temperature"
    annotation (Placement(transformation(extent={{320,50},{360,90}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VHotWatPri_flow(
    final unit="m3/s",
    displayUnit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured flowrate in primary circuit"
    annotation (Placement(transformation(extent={{320,10},{360,50}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHotWatIsoVal[2]
    "Measured boiler hot water isolation valve position"
    annotation (Placement(transformation(extent={{320,-140},{360,-100}}),
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
    annotation (Placement(transformation(extent={{260,-170},{240,-150}})));

  Buildings.Fluid.Boilers.BoilerTable boi2(
    redeclare package Medium = MediumW,
    allowFlowReversal=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per=perBoi2)
    "Boiler-2"
    annotation (Placement(transformation(extent={{110,-230},{90,-210}})));

  Buildings.Fluid.Boilers.BoilerTable boi1(
    redeclare package Medium = MediumW,
    allowFlowReversal=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final per=perBoi1) "Boiler-1"
    annotation (Placement(transformation(extent={{110,-170},{90,-150}})));

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
      origin={-40,-50})));

  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,-160})));

  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mPla_flow_nominal,-mPla_flow_nominal,-
        mPla_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,140})));

  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mPla_flow_nominal,mPla_flow_nominal,-
        mPla_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=270,
      origin={210,140})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi2_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-2"
    annotation (Placement(transformation(extent={{58,-230},{38,-210}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mBoi1_flow_nominal,
    final dpValve_nominal=dpValve_nominal_value,
    strokeTime=60,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dpFixed_nominal_value)
    "Isolation valve for boiler-1"
    annotation (Placement(transformation(extent={{40,-170},{20,-150}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "Volume flow-rate through primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,50})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,90})));

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
    r={10,10},
    final yMax=fill(1, 2),
    final yMin=fill(0, 2),
    final xi_start=fill(0.2, 2))
    "PI controller for operating boilers to regulating hot water supply temperature"
    annotation (Placement(transformation(extent={{-138,130},{-118,150}})));

  Buildings.Fluid.FixedResistances.Junction spl6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={-mBoi1_flow_nominal,mPla_flow_nominal,-
        mBoi2_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={150,-160})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRoo
    "Room temperature of boiler room"
    annotation (Placement(transformation(extent={{-260,-190},{-240,-170}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg[2]
    "Detect changes to boiler status setpoints"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor in primary circuit"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={210,70})));

  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "Volume flow-rate through minimum flow bypass branch"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem4(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal)
    "HW return temperature sensor after water exits return plumbing"
    annotation (Placement(transformation(extent={{180,190},{200,210}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipe1(
    redeclare package Medium = MediumW,
    final allowFlowReversal=false,
    final m_flow_nominal=mPla_flow_nominal,
    dp_nominal=500)
    "Pipe element for decoupler leg"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul[2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-180,130},{-160,150}})));

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
    annotation (Placement(transformation(extent={{-300,-58},{-280,-38}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPriPumSpe[2](
    final unit=fill("1",2),
    displayUnit=fill("1",2))
    "Measured primary pump speed"
    annotation (Placement(transformation(extent={{320,-102},{360,-62}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDec_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured decoupler flowrate"
    annotation (Placement(transformation(extent={{320,150},{360,190}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TRetSec(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit = "degC",
    min = 0) "Measured secondary loop return temperature"
    annotation (Placement(transformation(extent={{320,200},{360,240}}),
      iconTransformation(extent={{100,120},{140,160}})));

  Buildings.Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mPla_flow_nominal,
    final dpValve_nominal=500,
    final l=1e-7)
    "Check valve for primary pump-1"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,-80})));

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
    annotation (Placement(transformation(extent={{-300,50},{-280,70}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1[2](
    final t=fill(0.95,2),
    final h=fill(0.05, 2))
    "Check if isolation valve is opened"
    annotation (Placement(transformation(extent={{280,-130},{300,-110}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3[2]
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{-300,0},{-280,20}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul1[2]
    "Supply non-zero setpoint only when boiler is enabled"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,
        mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,-110})));

  Buildings.Fluid.FixedResistances.Junction spl3(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mBoi2_flow_nominal,-mPla_flow_nominal,
        mBoi1_flow_nominal},
    final dp_nominal={0,0,0})
    "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-40,0})));

equation

  connect(senVolFlo.V_flow, VHotWatPri_flow) annotation (Line(points={{-51,50},{
          -60,50},{-60,30},{340,30}}, color={0,0,127}));
  connect(senTem.T, ySupTem) annotation (Line(points={{-51,90},{-60,90},{-60,110},
          {340,110}}, color={0,0,127}));
  connect(hys2.y, timPumSta.u)
    annotation (Line(points={{122,-30},{138,-30}}, color={255,0,255}));
  connect(boi1.port_a, spl6.port_1)
    annotation (Line(points={{110,-160},{140,-160}}, color={0,127,255}));
  connect(boi2.port_a, spl6.port_3) annotation (Line(points={{110,-220},{150,-220},
          {150,-170}}, color={0,127,255}));
  connect(TZon, TRoo.T)
    annotation (Line(points={{-340,-180},{-262,-180}}, color={0,0,127}));
  connect(boi1.heatPort, TRoo.port) annotation (Line(points={{100,-152.8},{100,-140},
          {70,-140},{70,-180},{-240,-180}}, color={191,0,0}));
  connect(boi2.heatPort, TRoo.port) annotation (Line(points={{100,-212.8},{100,-180},
          {-240,-180}}, color={191,0,0}));
  connect(boi1.T, conPIDBoi[1].u_m)
    annotation (Line(points={{89,-152},{80,-152},{80,-200},{-128,-200},{-128,128}},
          color={0,0,127}));
  connect(boi2.T, conPIDBoi[2].u_m)
    annotation (Line(points={{89,-212},{80,-212},{80,-200},{-128,-200},{-128,128}},
          color={0,0,127}));
  connect(uBoiSta, edg.u) annotation (Line(points={{-340,160},{-280,160},{-280,100},
          {-242,100}}, color={255,0,255}));
  connect(conPIDBoi[1].y, boi1.y) annotation (Line(points={{-116,140},{-100,140},
    {-100,-190},{120,-190},{120,-152},{112,-152}}, color={0,0,127}));
  connect(conPIDBoi[2].y, boi2.y) annotation (Line(points={{-116,140},{-100,140},
    {-100,-190},{120,-190},{120,-212},{112,-212}}, color={0,0,127}));
  connect(edg.y, conPIDBoi.trigger) annotation (Line(points={{-218,100},{-134,100},
          {-134,128}}, color={255,0,255}));
  connect(senTem2.port_b, spl6.port_2) annotation (Line(points={{210,60},{210,-160},
          {160,-160}}, color={0,127,255}));
  connect(spl4.port_3, senVolFlo1.port_a)
    annotation (Line(points={{-30,140},{20,140}}, color={0,127,255}));
  connect(senTem3.port_b, spl5.port_3)
    annotation (Line(points={{140,140},{200,140}}, color={0,127,255}));
  connect(spl5.port_2, senTem2.port_a)
    annotation (Line(points={{210,130},{210,80}}, color={0,127,255}));
  connect(senTem4.port_b, spl5.port_1) annotation (Line(points={{200,200},{210,200},
          {210,150}}, color={0,127,255}));
  connect(senTem2.T, yRetTem) annotation (Line(points={{221,70},{340,70}},
          color={0,0,127}));
  connect(pipe1.port_a, senVolFlo1.port_b) annotation (Line(points={{80,140},{40,
          140}}, color={0,127,255}));
  connect(pipe1.port_b, senTem3.port_a) annotation (Line(points={{100,140},{120,
          140}}, color={0,127,255}));
  connect(TBoiHotWatSupSet, mul.u2) annotation (Line(points={{-340,120},{-200,120},
          {-200,134},{-182,134}}, color={0,0,127}));
  connect(booToRea1.y, mul.u1) annotation (Line(points={{-218,160},{-200,160},{-200,
          146},{-182,146}}, color={0,0,127}));
  connect(mul.y, conPIDBoi.u_s) annotation (Line(points={{-158,140},{-140,140}},
          color={0,0,127}));
  connect(pum1.y_actual, hys2[1].u)
    annotation (Line(points={{-47,-39},{-47,-30},{98,-30}}, color={0,0,127}));
  connect(pum2.y_actual, hys2[2].u)
    annotation (Line(points={{-7,-39},{-7,-30},{98,-30}}, color={0,0,127}));
  connect(timPumSta.passed, yPumSta) annotation (Line(points={{162,-38},{340,-38}},
          color={255,0,255}));
  connect(uPumSpe, reaScaRep.u)
    annotation (Line(points={{-340,-48},{-302,-48}}, color={0,0,127}));
  connect(pum1.y_actual, yPriPumSpe[1]) annotation (Line(points={{-47,-39},{-47,
          -30},{60,-30},{60,-87},{340,-87}}, color={0,0,127}));
  connect(pum2.y_actual, yPriPumSpe[2]) annotation (Line(points={{-7,-39},{-7,-30},
          {60,-30},{60,-77},{340,-77}}, color={0,0,127}));
  connect(senVolFlo1.V_flow, VDec_flow) annotation (Line(points={{30,151},{30,170},
          {340,170}}, color={0,0,127}));
  connect(senTem4.T, TRetSec) annotation (Line(points={{190,211},{190,220},{340,
          220}}, color={0,0,127}));
  connect(preSou.ports[1], spl6.port_2) annotation (Line(points={{240,-160},{160,
          -160}}, color={0,127,255}));
  connect(cheVal1.port_b, pum1.port_a)
    annotation (Line(points={{-40,-70},{-40,-60}}, color={0,127,255}));
  connect(cheVal2.port_b,pum2. port_a)
    annotation (Line(points={{0,-70},{0,-60}}, color={0,127,255}));
  connect(uHotIsoVal, booToRea2.u)
    annotation (Line(points={{-340,60},{-302,60}}, color={255,0,255}));
  connect(booToRea2[1].y, val1.y) annotation (Line(points={{-278,60},{-160,60},{
          -160,-140},{30,-140},{30,-148}}, color={0,0,127}));
  connect(booToRea2[2].y, val2.y) annotation (Line(points={{-278,60},{-160,60},{
          -160,-140},{48,-140},{48,-208}}, color={0,0,127}));
  connect(yHotWatIsoVal, greThr1.y)
    annotation (Line(points={{340,-120},{302,-120}}, color={255,0,255}));
  connect(val1.y_actual, greThr1[1].u) annotation (Line(points={{25,-153},{10,-153},
          {10,-120},{278,-120}}, color={0,0,127}));
  connect(val2.y_actual, greThr1[2].u) annotation (Line(points={{43,-213},{10,-213},
          {10,-120},{278,-120}}, color={0,0,127}));
  connect(uBoiSta, booToRea1.u)
    annotation (Line(points={{-340,160},{-242,160}}, color={255,0,255}));
  connect(uPumSta, booToRea3.u)
    annotation (Line(points={{-340,10},{-302,10}}, color={255,0,255}));
  connect(booToRea3.y, mul1.u1) annotation (Line(points={{-278,10},{-260,10},{-260,
          -14},{-242,-14}}, color={0,0,127}));
  connect(reaScaRep.y, mul1.u2) annotation (Line(points={{-278,-48},{-260,-48},{
          -260,-26},{-242,-26}}, color={0,0,127}));
  connect(mul1[1].y, pum1.y) annotation (Line(points={{-218,-20},{-80,-20},{-80,
          -50},{-52,-50}}, color={0,0,127}));
  connect(mul1[2].y, pum2.y) annotation (Line(points={{-218,-20},{-20,-20},{-20,
          -50},{-12,-50}}, color={0,0,127}));
  connect(spl1.port_2, spl2.port_1)
    annotation (Line(points={{-40,-150},{-40,-120}}, color={0,127,255}));
  connect(spl2.port_2, cheVal1.port_a)
    annotation (Line(points={{-40,-100},{-40,-90}}, color={0,127,255}));
  connect(spl2.port_3, cheVal2.port_a)
    annotation (Line(points={{-30,-110},{0,-110},{0,-90}}, color={0,127,255}));
  connect(spl3.port_1, pum1.port_b)
    annotation (Line(points={{-40,-10},{-40,-40}}, color={0,127,255}));
  connect(spl3.port_3, pum2.port_b)
    annotation (Line(points={{-30,0},{0,0},{0,-40}}, color={0,127,255}));
  connect(spl3.port_2, senVolFlo.port_a)
    annotation (Line(points={{-40,10},{-40,40}},   color={0,127,255}));
  connect(val2.port_b, spl1.port_1) annotation (Line(points={{38,-220},{-40,-220},
          {-40,-170}}, color={0,127,255}));
  connect(val1.port_b, spl1.port_3)
    annotation (Line(points={{20,-160},{-30,-160}},color={0,127,255}));
  connect(boi1.port_b, val1.port_a) annotation (Line(points={{90,-160},{40,-160}},
         color={0,127,255}));
  connect(boi2.port_b, val2.port_a)
    annotation (Line(points={{90,-220},{58,-220}}, color={0,127,255}));
  connect(port_a, senTem4.port_a)
    annotation (Line(points={{40,240},{40,200},{180,200}}, color={0,127,255}));
  connect(senVolFlo.port_b, senTem.port_a)
    annotation (Line(points={{-40,60},{-40,80}}, color={0,127,255}));
  connect(senTem.port_b, spl4.port_1)
    annotation (Line(points={{-40,100},{-40,130}}, color={0,127,255}));
  connect(spl4.port_2, port_b) annotation (Line(points={{-40,150},{-40,240}},
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
<p>
A few key points when using this class are as follows:
</p>
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
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-240},{320,240}})),
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
