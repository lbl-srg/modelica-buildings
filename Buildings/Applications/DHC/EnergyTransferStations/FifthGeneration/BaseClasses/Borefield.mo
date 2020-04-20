within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model Borefield "Auxiliary subsystem with geothermal borefield"
  extends Fluid.Interfaces.PartialTwoPort(
    allowFlowReversal=false);
  parameter Modelica.SIunits.TemperatureDifference dTGeo
    "Temperature difference between entering and leaving water of the borefield";
  parameter Modelica.SIunits.Length xBorFie
    "Borefield length";
  parameter Modelica.SIunits.Length yBorFie
    "Borefield width";
  parameter Modelica.SIunits.Pressure dpBorFie_nominal
    "Pressure losses for the entire borefield";
  parameter Modelica.SIunits.Radius rTub =  0.05
   "Outer radius of the tubes";
  final parameter Modelica.SIunits.MassFlowRate mBor_flow_nominal=
    m_flow_nominal / nBorHol
    "Borehole nominal mass flow rate";
  final parameter Modelica.SIunits.Length dBorHol = 5
    "Distance between two boreholes";
  final parameter Integer nXBorHol = integer((xBorFie+dBorHol)/dBorHol)
    "Number of boreholes in x-direction";
  final parameter Integer nYBorHol = integer((yBorFie+dBorHol)/dBorHol)
    "Number of boreholes in y-direction";
  final parameter Integer nBorHol = nXBorHol*nYBorHol
   "Number of boreholes";
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiBor(
    final k=m_flow_nominal)
    "Gain for mass flow rate of borefield"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBor(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true,
    m_flow_nominal=mGeo_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000,
    homotopyInitialization=true)
    "Three-way mixing valve controlling borefield water entering temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,  origin={-80,0})));
  Fluid.Movers.FlowControlled_m_flow pumBor(
    redeclare final package Medium = Medium,
    m_flow_nominal=mGeo_flow_nominal,
    addPowerToMedium=false,
    show_T=show_T,
    per(pressure(dp={dpBorFie_nominal,0}, V_flow={0,mGeo_flow_nominal/1000})),
    use_inputFilter=true,
    riseTime=10)
    "Pump that forces the flow rate to be set to the control signal"
     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,   origin={-40,0})));
  Fluid.Sensors.TemperatureTwoPort TBorEnt(
    final tau=if allowFlowReversal then 1 else 0,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mGeo_flow_nominal)
    "Entering water temperature to the borefield system"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-10,0})));
  Fluid.Geothermal.Borefields.OneUTube borFie(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    borFieDat=borFieDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=show_T,
    dT_dz=0,
    TExt0_start=285.95)
    "Geothermal borefield"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={22,0})));
  Junction splBor(
    m_flow_nominal=mGeo_flow_nominal.*{1,-1,-1},
    redeclare final package Medium = Medium)
    "Flow splitter"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={80,0})));
  Fluid.Sensors.TemperatureTwoPort TBorLvg(
    final tau=if allowFlowReversal then 1 else 0,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal)
    "Borefield system leaving water temperature"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={50,0})));
  Controls.Borefield ambCirCon
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoCon
    "Condenser to ambient loop isolation valve control signal" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoEva
    "Evaporator to ambient loop isolation valve control signal" annotation (
      Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
equation
  connect(port_a, valBor.port_2)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(valBor.port_1, pumBor.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(pumBor.port_b, TBorEnt.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(TBorEnt.port_b, borFie.port_a)
    annotation (Line(points={{0,0},{12,0}}, color={0,127,255}));
  connect(port_b, splBor.port_2)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  connect(splBor.port_1, TBorLvg.port_b)
    annotation (Line(points={{70,0},{60,0}}, color={0,127,255}));
  connect(borFie.port_b, TBorLvg.port_a)
    annotation (Line(points={{32,0},{40,0}}, color={0,127,255}));
  connect(splBor.port_3, valBor.port_3) annotation (Line(points={{80,-10},{80,
          -40},{-80,-40},{-80,-10}}, color={0,127,255}));
  connect(ambCirCon.yPumBor, gaiBor.u) annotation (Line(points={{22.1,53.9},{32,
          53.9},{32,54},{40,54},{40,60},{48,60}}, color={0,0,127}));
  connect(ambCirCon.yMixBor, valBor.y) annotation (Line(points={{22,66},{40,66},
          {40,80},{-80,80},{-80,12}}, color={0,0,127}));
  connect(gaiBor.y, pumBor.m_flow_in) annotation (Line(points={{72,60},{80,60},{
          80,20},{-40,20},{-40,12}}, color={0,0,127}));
  connect(TBorEnt.T, ambCirCon.TBorWatEnt)
    annotation (Line(points={{-10,11},{-10,56},{-2,56}}, color={0,0,127}));
  connect(uHeaRej, ambCirCon.uHeaRej) annotation (Line(points={{-120,80},{-92,
          80},{-92,68},{-2,68}},
                             color={255,0,255}));
  connect(uColRej, ambCirCon.uColRej) annotation (Line(points={{-120,60},{-92,
          60},{-92,65},{-2,65}},
                             color={255,0,255}));
  connect(TBorLvg.T, ambCirCon.TBorWatLvg) annotation (Line(points={{50,11},{50,
          40},{-4,40},{-4,53},{-2,53}}, color={0,0,127}));
  connect(uIsoCon, ambCirCon.uIsoCon) annotation (Line(points={{-120,40},{-88,
          40},{-88,62},{-2,62}}, color={0,0,127}));
  connect(uIsoEva, ambCirCon.uIsoEva) annotation (Line(points={{-120,20},{-84,
          20},{-84,59},{-2,59}}, color={0,0,127}));
  annotation (
  defaultComponentName="bor",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Borefield;
