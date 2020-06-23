within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Subsystems;
model Borefield "Auxiliary subsystem with geothermal borefield"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.conDat.mBorFie_flow_nominal);

  replaceable model BoreFieldType = Fluid.Geothermal.Borefields.OneUTube
    constrainedby Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield(
      redeclare final package Medium = Medium,
      final allowFlowReversal=allowFlowReversal,
      final borFieDat=dat,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Wall heat transfer"
    annotation (choicesAllMatching=true);

  parameter Fluid.Geothermal.Borefields.Data.Borefield.Template dat
    "Borefield parameters"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")
    "Pressure losses for the entire borefield (control valve excluded)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Pressure dpValBorFie_nominal=dp_nominal / 2
    "Nominal pressure drop of control valve";

  parameter Modelica.SIunits.Temperature TBorWatEntMax(displayUnit="degC")
    "Maximum value of borefield water entering temperature";
  parameter Real spePumBorMin(final unit="1") = 0.1
    "Borefield pump minimum speed";

  // IO VARIABLES
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIso[2]
    "Isolation valves return position (fractional)" annotation (Placement(
        transformation(extent={{-140,20},{-100,60}}),   iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Control signal from supervisory"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  // COMPONENTS
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false,
    use_inputFilter=false,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValBorFie_nominal,
    final dpFixed_nominal=fill(dp_nominal, 2))
    "Mixing valve controlling entering temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow pum(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpValBorFie_nominal+dp_nominal) "Pump with prescribed mass flow rate"
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
  BoreFieldType borFie
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
  Controls.Borefield con(
    final m_flow_nominal=m_flow_nominal,
    final TBorWatEntMax=TBorWatEntMax,
    final spePumBorMin=spePumBorMin)
    "Controller"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
initial equation
  assert(abs(dat.conDat.dp_nominal) < Modelica.Constants.eps,
    "In " + getInstanceName() +
    ": dp_nominal in the parameter record should be set to zero as the nominal
    pressure drop is lumped in the valve model. Use the exposed parameter
    dp_nominal instead.",
    level = AssertionLevel.warning);
equation
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
  connect(u, con.u) annotation (Line(points={{-120,80},{-80,80},{-80,66},{-62,
          66}},
        color={0,0,127}));
  connect(yValIso, con.yValIso)
    annotation (Line(points={{-120,40},{-80,40},{-80,60},{-62,60}},
                                                  color={0,0,127}));
  connect(con.yPum, pum.m_flow_in) annotation (Line(points={{-38,66},{0,66},{0,20},
          {-40,20},{-40,12}}, color={0,0,127}));
  connect(con.yValMix, val.y) annotation (Line(points={{-38,54},{-20,54},{-20,24},
          {-80,24},{-80,12}}, color={0,0,127}));
  connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-70,0},{-50,0}}, color={0,127,255}));
  connect(senTEnt.T, con.TBorWatEnt) annotation (Line(points={{-10,11},{-10,40},
          {-70,40},{-70,54},{-62,54}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
from_dp is set to false to avoid non convergence issues.
</p>
</html>"));
end Borefield;
