within Buildings.Applications.DHC.CentralPlants.Subsystems;
model MultiChillerSystem
  "The chiller system with three chillers and associated local controllers"
  replaceable package MediumCHW =
      Buildings.Media.Water
    "Medium in the chilled water side";
  replaceable package MediumCW =
      Buildings.Media.Water
    "Medium in the condenser water side";
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{-10,70},{10,90}})));
  parameter Modelica.SIunits.Pressure dPCHW_nominal
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal mass flow rate at the chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal mass flow rate at the condenser water wide";
  parameter Modelica.SIunits.Temperature TCW_start
    "The start temperature of condenser water side";
  parameter Modelica.SIunits.Temperature TCHW_start
    "The start temperature of chilled water side";
  Modelica.Blocks.Interfaces.RealInput On[3](min=0,max=1) "On signal"    annotation (Placement(transformation(extent={{-118,
            -31},{-100,-49}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CW(redeclare package Medium = MediumCW)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CW(redeclare package Medium = MediumCW)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CHW(redeclare package Medium = MediumCHW)
    "Fluid connector b2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}}),
        iconTransformation(extent={{90,-90},{110,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CHW(redeclare package Medium = MediumCHW)
    "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Interfaces.RealOutput P[3]
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWEntChi(
    redeclare package Medium = MediumCHW,
    allowFlowReversal=true,
    m_flow_nominal=3*mCHW_flow_nominal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLeaChi(
    allowFlowReversal=true,
    redeclare package Medium = MediumCW,
    m_flow_nominal=3*mCW_flow_nominal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-80,80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWLeaChi(
    allowFlowReversal=true,
    redeclare package Medium = MediumCHW,
    m_flow_nominal=3*mCHW_flow_nominal,
    T_start=TCHW_start)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={52,-80})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntChi(
    allowFlowReversal=true,
    redeclare package Medium = MediumCW,
    m_flow_nominal=3*mCW_flow_nominal,
    T_start=TCW_start)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-80})));
  WaterSide.BaseClasses.Components.Compressor ch1(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=TCW_start,
    TCHW_start=TCHW_start,
    per=per) annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  WaterSide.BaseClasses.Components.Compressor ch2(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=TCW_start,
    TCHW_start=TCHW_start,
    per=per) annotation (Placement(transformation(extent={{-20,-18},{0,2}})));
  WaterSide.BaseClasses.Components.Compressor ch3(
    redeclare package MediumCHW = MediumCHW,
    redeclare package MediumCW = MediumCW,
    dPCHW_nominal=dPCHW_nominal,
    dPCW_nominal=dPCW_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    TCW_start=TCW_start,
    TCHW_start=TCHW_start,
    per=per)
    annotation (Placement(transformation(extent={{-20,-58},{0,-38}})));
  Modelica.Blocks.Interfaces.RealOutput Rat[3] "compressor speed ratio"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCHW(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{70,-90},{88,-70}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCW(redeclare package Medium =
        MediumCHW)
    annotation (Placement(transformation(extent={{-46,70},{-64,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetCHW
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
equation
  connect(port_b_CW, port_b_CW) annotation (Line(
      points={{-100,80},{-100,80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(port_a_CW, port_a_CW) annotation (Line(
      points={{-100,-80},{-100,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCHWEntChi.port_a, port_a_CHW) annotation (Line(
      points={{60,80},{100,80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(port_b_CW, senTCWLeaChi.port_b) annotation (Line(
      points={{-100,80},{-90,80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTCWEntChi.port_a, port_a_CW) annotation (Line(
      points={{-80,-80},{-100,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(port_b_CHW, port_b_CHW) annotation (Line(
      points={{100,-80},{98,-80},{98,-80},{100,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(ch2.port_b_CW, ch1.port_b_CW) annotation (Line(points={{-20,0},{-40,0},
          {-40,80},{-20,80},{-20,36}}, color={0,127,255}));
  connect(ch3.port_b_CW, ch1.port_b_CW) annotation (Line(
      points={{-20,-40},{-40,-40},{-40,80},{-20,80},{-20,36}},
      color={0,127,255},
      thickness=1));
  connect(senTCWEntChi.port_b, ch3.port_a_CW) annotation (Line(
      points={{-60,-80},{-50,-80},{-50,-56},{-20,-56}},
      color={0,127,255},
      thickness=1));
  connect(ch2.port_a_CW, ch3.port_a_CW) annotation (Line(
      points={{-20,-16},{-50,-16},{-50,-56},{-20,-56}},
      color={0,127,255},
      thickness=1));
  connect(ch1.port_a_CW, ch3.port_a_CW) annotation (Line(
      points={{-20,20},{-50,20},{-50,-56},{-20,-56}},
      color={0,127,255},
      thickness=1));
  connect(ch1.port_a_CHW, senTCHWEntChi.port_b) annotation (Line(
      points={{0,36},{20,36},{20,80},{40,80}},
      color={0,127,255},
      thickness=1));
  connect(ch2.port_a_CHW, senTCHWEntChi.port_b) annotation (Line(
      points={{0,0},{20,0},{20,80},{40,80}},
      color={0,127,255},
      thickness=1));
  connect(ch3.port_a_CHW, senTCHWEntChi.port_b) annotation (Line(
      points={{0,-40},{20,-40},{20,80},{40,80}},
      color={0,127,255},
      thickness=1));
  connect(ch1.port_b_CHW, senTCHWLeaChi.port_a) annotation (Line(
      points={{0,20},{20,20},{42,20},{42,-80}},
      color={0,127,255},
      thickness=1));
  connect(ch2.port_b_CHW, senTCHWLeaChi.port_a) annotation (Line(
      points={{0,-16},{42,-16},{42,-80}},
      color={0,127,255},
      thickness=1));
  connect(ch3.port_b_CHW, senTCHWLeaChi.port_a) annotation (Line(
      points={{0,-56},{42,-56},{42,-80}},
      color={0,127,255},
      thickness=1));
  connect(ch1.On, On[1]) annotation (Line(
      points={{-22,23},{-88,23},{-88,-34},{-109,-34}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ch2.On, On[2]) annotation (Line(
      points={{-22,-13},{-70,-13},{-70,-40},{-109,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ch3.On, On[3]) annotation (Line(
      points={{-22,-53},{-88,-53},{-88,-46},{-109,-46}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ch1.P, P[1]) annotation (Line(
      points={{1,32},{30,32},{60,32},{60,33.3333},{110,33.3333}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ch2.P, P[2]) annotation (Line(
      points={{1,-4},{28,-4},{54,-4},{54,40},{110,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ch3.P, P[3]) annotation (Line(
      points={{1,-44},{26,-44},{46,-44},{46,46.6667},{110,46.6667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senTCWLeaChi.port_a, senMasFloCW.port_b) annotation (Line(
      points={{-70,80},{-64,80}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCW.port_a, ch1.port_b_CW) annotation (Line(
      points={{-46,80},{-20,80},{-20,36}},
      color={0,127,255},
      thickness=1));
  connect(senMasFloCHW.port_b, port_b_CHW) annotation (Line(
      points={{88,-80},{94,-80},{100,-80}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWLeaChi.port_b, senMasFloCHW.port_a) annotation (Line(
      points={{62,-80},{66,-80},{70,-80}},
      color={0,127,255},
      thickness=1));
  connect(Rat, On) annotation (Line(
      points={{110,-40},{-109,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetCHW.y, ch1.TCHWSet) annotation (Line(
      points={{-78,40},{-74,40},{-74,31},{-22,31}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetCHW.y, ch2.TCHWSet) annotation (Line(
      points={{-78,40},{-70,40},{-70,-5},{-22,-5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSetCHW.y, ch3.TCHWSet) annotation (Line(
      points={{-78,40},{-66,40},{-66,-45},{-22,-45}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Documentation(info="<html>
<p>This model is to simulate the chiller system which consists of three chillers and associated local controllers.</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                   graphics={
        Text(
          extent={{-44,-142},{50,-110}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-28,80},{26,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,20},{26,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,-40},{26,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,12},{-28,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,-50},{-60,-50},{-60,80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-90,-80},{-40,-80},{-40,50},{-34,50},{-28,50}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,-10},{-40,-10}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,-70},{-40,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-80},{102,-80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{40,-80},{40,50},{26,50}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,-12},{40,-12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,-70},{40,-70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,12},{60,12}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,-48},{60,-48},{60,80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-100,80},{-60,80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-28,70},{-60,70}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,80},{60,80}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{26,72},{60,72}},
          color={0,0,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-32,76},{-22,64}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,74},{-24,66}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,18},{-22,6}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,16},{-24,8}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,-44},{-22,-56}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,-46},{-24,-54}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,56},{30,44}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,54},{28,46}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-6},{30,-18}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,-8},{28,-16}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-64},{30,-76}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,-66},{28,-74}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,78},{30,66}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,18},{30,6}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,-44},{30,-56}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,56},{-22,44}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,-4},{-22,-16}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,-64},{-22,-76}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}));
end MultiChillerSystem;
