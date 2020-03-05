within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model SubsystemBorefield "Auxiliary subsystem with geothermal borefield"
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
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
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
        origin={20,0})));
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
equation
  connect(port_a, valBor.port_2)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(valBor.port_1, pumBor.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(gaiBor.y, pumBor.m_flow_in)
    annotation (Line(points={{-58,60},{-40,60},{-40,12}}, color={0,0,127}));
  connect(pumBor.port_b, TBorEnt.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(TBorEnt.port_b, borFie.port_a)
    annotation (Line(points={{0,0},{10,0}}, color={0,127,255}));
  connect(port_b, splBor.port_2)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  connect(splBor.port_1, TBorLvg.port_b)
    annotation (Line(points={{70,0},{60,0}}, color={0,127,255}));
  connect(borFie.port_b, TBorLvg.port_a)
    annotation (Line(points={{30,0},{40,0}}, color={0,127,255}));
  connect(splBor.port_3, valBor.port_3) annotation (Line(points={{80,-10},{80,
          -40},{-80,-40},{-80,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SubsystemBorefield;
