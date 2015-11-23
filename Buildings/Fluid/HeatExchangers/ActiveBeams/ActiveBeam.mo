within Buildings.Fluid.HeatExchangers.ActiveBeams;
model ActiveBeam

  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  parameter Real m_airflow_nominal=0.03 "Nominal air mass flow rate"
  annotation (Dialog(group="Nominal condition Cooling"));
  parameter Real m_waterflow_nominal=0.038 "Nominal water mass flow rate"
  annotation (Dialog(group="Nominal condition Cooling"));
  parameter Real temp_diff_nominal=9
    "Nominal temperature difference room-water"
  annotation (Dialog(group="Nominal condition Cooling"));
  parameter Real P_flow_nominal=1000 "Nominal capacity"
  annotation (Dialog(group="Nominal condition Cooling"));

   replaceable parameter
    Buildings.Fluid.HeatExchangers.ActiveBeams.Data.CapacityActiveBeam per
    "Record with performance data" annotation (
    Dialog(group="Nominal condition Cooling"),
    choicesAllMatching=true,
    Placement(transformation(extent={{72,-92},{92,-72}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b3
    annotation (Placement(transformation(extent={{-18,-108},{2,-88}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow HeatToRoom annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-40})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo_air(redeclare final package
      Medium = Medium2) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={62,-60})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo_water(redeclare final package
      Medium = Medium1) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-62,60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem_WaterIn(redeclare final
      package Medium = Medium1, m_flow_nominal=0.038) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-16,60})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{30,-30},{42,-18}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{22,84},{14,92}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{8,84},{0,92}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = Medium1,
    Q_flow_nominal=P_flow_nominal,
    m_flow_nominal=0.1,
    dp_nominal=10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,60})));
  BaseClasses.ModificationFactor          modificationFactorWaterFlow( xd=per.water.variable, yd=per.water.f)
    annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=-90,
        origin={-68,33})));
  BaseClasses.ModificationFactor         modificationFactorTempDiff( xd=per.temp_diff.variable, yd=per.temp_diff.f) annotation (
     Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=-90,
        origin={-24,33})));
  Modelica.Blocks.Math.MultiProduct multiProduct(nu=3) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-10,-4})));
  BaseClasses.ModificationFactor modificationFactorAirFlow(xd=per.primaryair.variable,
      yd=per.primaryair.f) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={94,-26})));
  Modelica.Blocks.Sources.Constant rated_airflow( k=m_airflow_nominal)
    annotation (Placement(transformation(extent={{40,-50},{48,-42}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{74,-48},{82,-40}})));
  Modelica.Blocks.Sources.Constant rated_waterflow( k=m_waterflow_nominal)
    annotation (Placement(transformation(extent={{-48,76},{-54,82}})));
  Modelica.Blocks.Math.Division division1
    annotation (Placement(transformation(extent={{-22,88},{-30,96}})));
  Modelica.Blocks.Sources.Constant rated_tempdiff( k=temp_diff_nominal)
    annotation (Placement(transformation(extent={{-6,80},{-12,86}})));
  Modelica.Blocks.Math.Division division2
    annotation (Placement(transformation(extent={{-70,78},{-78,86}})));
equation
  connect(port_a2, senMasFlo_air.port_a) annotation (Line(points={{100,-60},{
          84,-60},{68,-60}}, color={0,127,255}));
  connect(senMasFlo_air.port_b, port_b2) annotation (Line(points={{56,-60},{
          -22,-60},{-100,-60}}, color={0,127,255}));
  connect(port_a1, senMasFlo_water.port_a)
    annotation (Line(points={{-100,60},{-68,60}}, color={0,127,255}));
  connect(senMasFlo_water.port_b, senTem_WaterIn.port_a)
    annotation (Line(points={{-56,60},{-22,60}}, color={0,127,255}));
  connect(senTem_WaterIn.port_b, hea.port_a)
    annotation (Line(points={{-10,60},{-10,60},{36,60}}, color={0,127,255}));
  connect(hea.port_b, port_b1)
    annotation (Line(points={{56,60},{100,60}}, color={0,127,255}));
  connect(senMasFlo_air.m_flow, division.u1) annotation (Line(points={{62,
          -53.4},{62,-41.6},{73.2,-41.6}}, color={0,0,127}));
  connect(rated_airflow.y, division.u2) annotation (Line(points={{48.4,-46},{
          48,-46},{48,-46.4},{73.2,-46.4}}, color={0,0,127}));
  connect(division.y, modificationFactorAirFlow.u) annotation (Line(points={{
          82.4,-44},{93.88,-44},{93.88,-32.36}}, color={0,0,127}));
  connect(rated_waterflow.y, division2.u2) annotation (Line(points={{-54.3,79},
          {-66,79},{-66,79.6},{-69.2,79.6}}, color={0,0,127}));
  connect(senMasFlo_water.m_flow, division2.u1) annotation (Line(points={{-62,
          66.6},{-62,84.4},{-69.2,84.4}}, color={0,0,127}));
  connect(division2.y, modificationFactorWaterFlow.u) annotation (Line(points=
         {{-78.4,82},{-82,82},{-82,44},{-68.12,44},{-68.12,38.3}}, color={0,0,
          127}));
  connect(port_b3, temperatureSensor.port) annotation (Line(points={{-8,-98},{4,
          -98},{30,-98},{30,-24}},    color={191,0,0}));
  connect(temperatureSensor.T, add.u2) annotation (Line(points={{42,-24},{72,-24},
          {72,85.6},{22.8,85.6}},      color={0,0,127}));
  connect(senTem_WaterIn.T, add.u1) annotation (Line(points={{-16,66.6},{-16,76},
          {28,76},{28,90.4},{22.8,90.4}},     color={0,0,127}));
  connect(add.y, abs1.u)
    annotation (Line(points={{13.6,88},{8.8,88},{8.8,88}}, color={0,0,127}));
  connect(abs1.y, division1.u1) annotation (Line(points={{-0.4,88},{-2,88},{
          -2,94.4},{-21.2,94.4}}, color={0,0,127}));
  connect(rated_tempdiff.y, division1.u2) annotation (Line(points={{-12.3,83},
          {-18,83},{-18,89.6},{-21.2,89.6}}, color={0,0,127}));
  connect(division1.y, modificationFactorTempDiff.u) annotation (Line(points={{-30.4,
          92},{-34,92},{-34,44},{-24.12,44},{-24.12,38.3}},         color={0,
          0,127}));
  connect(multiProduct.y, hea.u) annotation (Line(points={{-10,-11.02},{-10,-11.02},
          {-10,-16},{10,-16},{10,66},{34,66}},        color={0,0,127}));
  connect(hea.Q_flow, HeatToRoom.Q_flow) annotation (Line(points={{57,66},{62,66},
          {62,-8},{18,-8},{18,-30},{-10,-30}},     color={0,0,127}));
  connect(HeatToRoom.port, port_b3) annotation (Line(points={{-10,-50},{-10,-50},
          {-10,-98},{-8,-98}},      color={191,0,0}));
  connect(modificationFactorWaterFlow.y, multiProduct.u[1]) annotation (Line(
        points={{-68,27.7},{-68,6},{-7.2,6},{-7.2,2}}, color={0,0,127}));
  connect(modificationFactorTempDiff.y, multiProduct.u[2]) annotation (Line(
        points={{-24,27.7},{-24,16},{-10,16},{-10,2}}, color={0,0,127}));
  connect(modificationFactorAirFlow.y, multiProduct.u[3]) annotation (Line(
        points={{94,-19.64},{94,-19.64},{94,22},{-8,22},{-8,2},{-12.8,2}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{120,100}}), graphics={Rectangle(
          extent={{-94,72},{90,-62}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}), Ellipse(
          extent={{40,32},{-36,-28}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-100},{120,100}})));
end ActiveBeam;
