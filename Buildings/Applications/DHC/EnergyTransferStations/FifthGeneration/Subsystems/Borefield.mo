within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Subsystems;
model Borefield "Auxiliary subsystem with geothermal borefield"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.conDat.mBorFie_flow_nominal);

  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final dp_nominal=dpValBorFie_nominal+dat.conDat.dp_nominal,
    final computeFlowResistance=(dat.conDat.dp_nominal > Modelica.Constants.eps));

  parameter Fluid.Geothermal.Borefields.Data.Borefield.Template dat
    "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  parameter Modelica.SIunits.Pressure dpValBorFie_nominal=dat.conDat.dp_nominal / 4
    "Nominal pressure drop of control valve";

  parameter Modelica.SIunits.Temperature TBorWatEntMax(
    displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Modelica.SIunits.TemperatureDifference dTBorFieSet(min=0)
    "Set-point for temperature difference accross borefield (absolute value)";
  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uColRej
    "Control signal enabling full cold rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaRej
    "Control signal enabling full heat rejection to ambient loop" annotation (
      Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiBor(
    final k=m_flow_nominal)
    "Gain for mass flow rate of borefield"
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValBorFie_nominal,
    final dpFixed_nominal=dp_nominal - dpValBorFie_nominal)
    "Mixing valve controlling entering temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal) "Pump with prescribed mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,0})));
  Fluid.Sensors.TemperatureTwoPort senTEnt(
    final tau=if allowFlowReversal then 1 else 0,
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal)
    "Entering temperature"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,0})));
  Fluid.Geothermal.Borefields.OneUTube borFie(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final borFieDat=borFieDat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Geothermal borefield"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={22,0})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Junction spl(
      redeclare final package Medium = Medium, final m_flow_nominal=
        m_flow_nominal .* {1,-1,-1}) "Flow splitter" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,0})));
  Fluid.Sensors.TemperatureTwoPort senTLvg(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal)
    "Leaving temperature"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  Controls.Borefield con "Controller"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)" annotation (Placement(
        transformation(extent={{-140,-70},{-100,-30}}), iconTransformation(
          extent={{-140,-70},{-100,-30}})));
equation
  connect(port_a, val.port_2)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(val.port_1, pum.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(pum.port_b, senTEnt.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(senTEnt.port_b, borFie.port_a)
    annotation (Line(points={{0,0},{12,0}}, color={0,127,255}));
  connect(port_b, spl.port_2)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  connect(spl.port_1, senTLvg.port_b)
    annotation (Line(points={{70,0},{60,0}}, color={0,127,255}));
  connect(borFie.port_b, senTLvg.port_a)
    annotation (Line(points={{32,0},{40,0}}, color={0,127,255}));
  connect(spl.port_3, val.port_3) annotation (Line(points={{80,-10},{80,-40},{-80,
          -40},{-80,-10}}, color={0,127,255}));
  connect(con.yPumBor, gaiBor.u) annotation (Line(points={{22.1,53.9},{40,53.9},
          {40,60},{48,60}},                 color={0,0,127}));
  connect(con.yMixBor, val.y) annotation (Line(points={{22,66},{40,66},{40,80},{
          -80,80},{-80,12}}, color={0,0,127}));
  connect(gaiBor.y, pum.m_flow_in) annotation (Line(points={{72,60},{80,60},{80,
          20},{-40,20},{-40,12}}, color={0,0,127}));
  connect(senTEnt.T, con.TBorWatEnt)
    annotation (Line(points={{-10,11},{-10,56},{-2,56}}, color={0,0,127}));
  connect(uHeaRej, con.uHeaRej) annotation (Line(points={{-120,80},{-92,80},{
          -92,68},{-2,68}},
                        color={255,0,255}));
  connect(uColRej, con.uColRej) annotation (Line(points={{-120,40},{-92,40},{
          -92,64},{-2,64}},
                        color={255,0,255}));
  connect(senTLvg.T, con.TBorWatLvg) annotation (Line(points={{50,11},{50,40},{
          -4,40},{-4,52},{-2,52}},
                                color={0,0,127}));
  connect(yValIso, con.yValIso) annotation (Line(points={{-120,-50},{-60,-50},{
          -60,60},{-2,60}}, color={0,0,127}));
  annotation (
  defaultComponentName="borFie",
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
