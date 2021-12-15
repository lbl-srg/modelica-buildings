within Buildings.Examples.DualFanDualDuct.ThermalZones;
model SupplyBranch "Supply branch of a dual duct system"
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  Modelica.Fluid.Interfaces.FluidPort_a port_aHot(redeclare package Medium =
        MediumA) "Connector for hot deck"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-12,-110},{8,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aCol(redeclare package Medium =
        MediumA) "Connector for cold deck"
    annotation (Placement(transformation(extent={{90,-110},{110,-90}}),
        iconTransformation(extent={{92,-110},{112,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium =
        MediumA)
    "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{40,190},{60,210}}),
        iconTransformation(extent={{40,190},{60,210}})));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)";
  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Mass flow rate cold air deck";
  parameter Modelica.Units.SI.MassFlowRate mAirHot_flow_nominal=0.3*
      m_flow_nominal "Mass flow rate hot air deck";
  parameter Modelica.Units.SI.MassFlowRate mAirCol_flow_nominal=m_flow_nominal
    "Mass flow rate cold air deck";

  parameter Modelica.Units.SI.Volume VRoo "Room volume";
  Controls.RoomMixingBox con(m_flow_min=VRoo*3*1.2/3600)
    "Room temperature controller"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  VAVReheat.BaseClasses.Controls.ControlBus controlBus
                                 annotation (Placement(transformation(extent={{
            -110,-50},{-90,-30}}), iconTransformation(extent={{-110,-38},{-90,-18}})));
  Buildings.Fluid.Actuators.Dampers.Exponential vavHot(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAirHot_flow_nominal,
    from_dp=from_dp,
    linearized=linearizeFlowResistance,
    y_start=0,
    dpDamper_nominal=0.27,
    dpFixed_nominal=40 - 0.27) "VAV damper for hot deck" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Buildings.Fluid.Actuators.Dampers.Exponential vavCol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mAirCol_flow_nominal,
    from_dp=from_dp,
    linearized=linearizeFlowResistance,
    y_start=0,
    dpDamper_nominal=0.27,
    dpFixed_nominal=40 - 0.27) "VAV damper for cold deck" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,-30})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        MediumA) "Sensor for mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,134})));
  Modelica.Blocks.Math.Gain fraMasFlo(k=1/m_flow_nominal)
    "Fraction of mass flow rate, relative to nominal flow"
    annotation (Placement(transformation(extent={{102,134},{122,154}})));
  Modelica.Blocks.Math.Gain ACH(k=1/VRoo/1.2*3600) "Air change per hour"
    annotation (Placement(transformation(extent={{100,94},{120,114}})));
  Modelica.Blocks.Interfaces.RealInput TRoo "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = MediumA,
    m_flow_nominal={mAirCol_flow_nominal,mAirHot_flow_nominal,
        mAirCol_flow_nominal + mAirHot_flow_nominal},
    from_dp=from_dp,
    linearized=linearizeFlowResistance,
    dp_nominal=20*{0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixer for hot and cold air deck" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,40})));

  Buildings.Fluid.Sensors.RelativePressure senRelPreHot(redeclare package Medium =
        MediumA) "Relative pressure hot deck (compared to room pressure)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={150,0})));
  Buildings.Fluid.Sensors.RelativePressure senRelPreCol(redeclare package Medium =
        MediumA) "Relative pressure cold deck (compared to room pressure)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={170,-60})));
  Modelica.Blocks.Interfaces.RealOutput p_relCol "Pressure signal of cold deck"
    annotation (Placement(transformation(extent={{200,-70},{220,-50}})));
  Modelica.Blocks.Interfaces.RealOutput p_relHot "Pressure signal of hot deck"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium = MediumA,
      m_flow_nominal=m_flow_nominal) "Supply air temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,168})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput yFan
    "Fan operation, true if fan is running" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-140,0},{-100,40}})));
equation
  connect(fraMasFlo.u, senMasFlo.m_flow) annotation (Line(
      points={{100,144},{80,144},{80,134},{61,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ACH.u, senMasFlo.m_flow) annotation (Line(
      points={{98,104},{80,104},{80,134},{61,134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.TRoo, TRoo) annotation (Line(
      points={{-42,18},{-60,18},{-60,100},{-120,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vavHot.port_a, port_aHot) annotation (Line(
      points={{-1.12703e-16,-40},{-1.12703e-16,-56.5},{4.42409e-16,-56.5},{
          4.42409e-16,-73},{5.55112e-16,-73},{5.55112e-16,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vavHot.port_b, mix.port_2) annotation (Line(
      points={{1.1119e-15,-20},{1.1119e-15,40},{40,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_1, vavCol.port_b) annotation (Line(
      points={{60,40},{100,40},{100,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_3, senMasFlo.port_a) annotation (Line(
      points={{50,50},{50,124}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, con.mAir_flow) annotation (Line(
      points={{61,134},{66,134},{66,70},{-52,70},{-52,6},{-42,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.yHot, vavHot.y) annotation (Line(
      points={{-19,14},{-16,14},{-16,-30},{-12,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.yCol, vavCol.y) annotation (Line(
      points={{-19,5},{80,5},{80,-30},{88,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senRelPreHot.port_a, port_aHot) annotation (Line(
      points={{150,-10},{150,-60},{5.55112e-16,-60},{5.55112e-16,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPreCol.port_a, port_aCol) annotation (Line(
      points={{170,-70},{170,-76},{100,-76},{100,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vavCol.port_a, port_aCol) annotation (Line(
      points={{100,-40},{100,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPreHot.port_b, mix.port_3) annotation (Line(
      points={{150,10},{150,60},{50,60},{50,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPreCol.port_b, mix.port_3) annotation (Line(
      points={{170,-50},{170,60},{50,60},{50,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelPreCol.p_rel, p_relCol) annotation (Line(
      points={{179,-60},{210,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senRelPreHot.p_rel, p_relHot) annotation (Line(
      points={{159,-5.14725e-17},{198,0},{210,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.TRooSetHea, controlBus.TRooSetHea) annotation (Line(
      points={{-42,14},{-80,14},{-80,-40},{-100,-40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(con.TRooSetCoo, controlBus.TRooSetCoo) annotation (Line(
      points={{-42,10},{-80,10},{-80,-40},{-100,-40}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(senMasFlo.port_b, TSup.port_a) annotation (Line(
      points={{50,144},{50,158}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSup.port_b, port_b) annotation (Line(
      points={{50,178},{50,200}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(con.yFan, yFan) annotation (Line(points={{-42,2},{-82,2},{-82,0},{
          -120,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{200,200}}), graphics={
        Rectangle(
          extent={{-100,200},{200,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-73.83,-32.508},{64.17,-40.508}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={13.492,135.83},
          rotation=90),
        Text(
          extent={{-78,198},{24,156}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-85.6,-32.2572},{74.4,-40.2572}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          origin={-38.2572,-14.4},
          rotation=90),
        Rectangle(
          extent={{-86.67,-32.2436},{75.33,-40.2436}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={65.7564,-15.33},
          rotation=90),
        Rectangle(
          extent={{72,-20},{92,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192},
          origin={72,-92},
          rotation=90),
        Rectangle(
          extent={{73,-10},{93,-22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={86,-93},
          rotation=90),
        Polygon(
          points={{88,-16},{116,0},{116,-2},{88,-18},{88,-16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{72,-20},{92,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192},
          origin={-32,-92},
          rotation=90),
        Rectangle(
          extent={{73,-10},{93,-22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={-18,-93},
          rotation=90),
        Polygon(
          points={{-16,-16},{12,0},{12,-2},{-16,-18},{-16,-16}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-29.2527,-25.7545},{25.4253,-32.0925}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          origin={20.7473,32.2455},
          rotation=180),
        Rectangle(
          extent={{-30.3227,-25.7545},{26.3553,-32.0925}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={75.6773,32.2455},
          rotation=180),
        Line(
          points={{206,0},{146,0},{146,-36},{2,-36}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{200,-60},{104,-60}},
          color={0,0,255},
          smooth=Smooth.None)}));
end SupplyBranch;
