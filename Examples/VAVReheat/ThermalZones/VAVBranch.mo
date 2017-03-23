within Buildings.Examples.VAVReheat.ThermalZones;
model VAVBranch "Supply branch of a VAV system"
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  replaceable package MediumW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water" annotation (choicesAllMatching=true);
  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential vav(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    A=0.6,
    use_v_nominal=true,
    dp_nominal(displayUnit="Pa") = 220 + 20) "VAV box for room" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,104})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU terHea(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal*1000*(50 - 17)/4200/10,
    Q_flow_nominal=m_flow_nominal*1006*(50 - 16.7),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=0,
    from_dp2=true,
    dp2_nominal=0,
    T_a1_nominal=289.85,
    T_a2_nominal=355.35) "Heat exchanger of terminal box" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={56,44})));
  Buildings.Fluid.Sources.FixedBoundary sinTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 3E5,
    nPorts=1) "Sink for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={132,24})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumA)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{40,-36},{60,-16}}),
        iconTransformation(extent={{40,-36},{60,-16}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium =
        MediumA)
    "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{40,190},{60,210}}),
        iconTransformation(extent={{40,190},{60,210}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate of this thermal zone";
  parameter Modelica.SIunits.Volume VRoo "Room volume";
  Controls.RoomVAV con "Room temperature controller"
    annotation (Placement(transformation(extent={{0,-6},{20,14}})));
  Controls.ControlBus controlBus annotation (Placement(transformation(extent={{
            -110,-50},{-90,-30}}), iconTransformation(extent={{-110,-38},{-90,-18}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        MediumA) "Sensor for mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,134})));
  Modelica.Blocks.Math.Gain fraMasFlo(k=1/m_flow_nominal)
    "Fraction of mass flow rate, relative to nominal flow"
    annotation (Placement(transformation(extent={{102,134},{122,154}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialState) "Supply air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,74})));
  Modelica.Blocks.Interfaces.RealOutput yDam "Signal for VAV damper"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Modelica.Blocks.Math.Gain ACH(k=1/VRoo/1.2*3600) "Air change per hour"
    annotation (Placement(transformation(extent={{100,94},{120,114}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal*1000*15/4200/10,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    from_dp=true,
    dpFixed_nominal=6000,
    dpValve_nominal=6000) "Valve at reaheat coil"
    annotation (Placement(transformation(extent={{82,34},{102,14}})));
  Buildings.Fluid.Sources.FixedBoundary souTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 3E5 + 12000,
    nPorts=1,
    T=323.15) "Source for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={132,64})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K", displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
equation
  connect(con.controlBus, controlBus) annotation (Line(
      points={{3,11.4},{3,-40},{-100,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(fraMasFlo.u, senMasFlo.m_flow) annotation (Line(
      points={{100,144},{80,144},{80,134},{61,134}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSup.T, con.TSup) annotation (Line(
      points={{39,74},{-20,74},{-20,6.66134e-16},{-2,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(con.yDam, vav.y) annotation (Line(
      points={{21,-1},{32,-1},{32,104},{38,104}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(terHea.port_b1, TSup.port_a) annotation (Line(
      points={{50,54},{50,64}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TSup.port_b, vav.port_a) annotation (Line(
      points={{50,84},{50,94}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(vav.port_b, senMasFlo.port_a) annotation (Line(
      points={{50,114},{50,124}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(con.yDam, yDam) annotation (Line(
      points={{21,-1},{188,-1},{188,5.55112e-16},{210,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(ACH.u, senMasFlo.m_flow) annotation (Line(
      points={{98,104},{80,104},{80,134},{61,134}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(con.yHea, valHea.y) annotation (Line(
      points={{21,8},{92,8},{92,12}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souTer.ports[1], terHea.port_a2) annotation (Line(
      points={{122,64},{62,64},{62,54}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(terHea.port_b2, valHea.port_a) annotation (Line(
      points={{62,34},{62,24},{82,24}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(valHea.port_b, sinTer.ports[1]) annotation (Line(
      points={{102,24},{122,24}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(port_a, terHea.port_a1) annotation (Line(
      points={{50,-26},{50,34}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(senMasFlo.port_b, port_b) annotation (Line(
      points={{50,144},{50,200}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(con.TRoo, TRoo) annotation (Line(
      points={{-2,8},{-60,8},{-60,100},{-120,100}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{200,200}}), graphics={
        Rectangle(
          extent={{-100,200},{200,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160.5,-16.1286},{139.5,-20.1286}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={31.8714,60.5},
          rotation=90),
        Rectangle(
          extent={{36,42},{66,16}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          pattern=LinePattern.None),
        Rectangle(
          extent={{72,-20},{92,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192},
          origin={20,52},
          rotation=90),
        Rectangle(
          extent={{73,-10},{93,-22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={34,51},
          rotation=90),
        Polygon(
          points={{36,128},{64,144},{64,142},{36,126},{36,128}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{36,36},{60,36},{60,34},{36,34},{36,36}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{36,24},{60,24},{60,22},{36,22},{36,24}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{46,30},{60,36},{60,34},{46,28},{46,30}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{46,30},{60,24},{60,22},{46,28},{46,30}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-78,198},{24,156}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{126,24},{194,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="yDam"),
        Text(
          extent={{144,194},{184,168}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="p_rel"),
        Text(
          extent={{144,154},{192,122}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TRooAir")}));
end VAVBranch;
