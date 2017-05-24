within Buildings.ChillerWSE.BaseClasses;
model WSEWithTControl
  "Water side economizer with outlet water temperature control via bypass valve"
  //---------------------------------------------------------------------------
  //                          Declare Medium
  //---------------------------------------------------------------------------
  replaceable package MediumCHW =
      Buildings.Media.Water
    "Medium in the chilled water side";
  replaceable package MediumCW =
      Buildings.Media.Water
    "Medium in the condenser water side";
  //---------------------------------------------------------------------------
  //                         Nominal Information
  //---------------------------------------------------------------------------
  parameter Modelica.SIunits.Pressure dpCHW_nominal
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dpCW_nominal
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal
    "Nominal mass flow rate at the chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal mass flow rate at the condenser water wide";
  parameter Modelica.SIunits.Pressure dp_byp_nominal
    "Pressure difference OF three way valve";

  //---------------------------------------------------------------------------
  //                          Performance Data
  //---------------------------------------------------------------------------
  parameter Real eps "constant effectiveness";
  //---------------------------------------------------------------------------
  //                          Controller Settings
  //---------------------------------------------------------------------------
  parameter Real GaiPi "Gain of the PID controller,and negative for WSE temperature control";
  parameter Real tIntPi "Integration time of the PID controller";

  WSEWithBypass WSE(
  redeclare package MediumCHW = MediumCHW,
  redeclare package MediumCW = MediumCW,
  dpCHW_nominal=dpCHW_nominal,
  dpCW_nominal=dpCW_nominal,
  mCHW_flow_nominal=mCHW_flow_nominal,
  mCW_flow_nominal=mCW_flow_nominal,
  eps=eps,
  dp_byp_nominal=dp_byp_nominal) "water side economizer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={4,6})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CW(redeclare package Medium =
        MediumCW)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CW(redeclare package Medium =
        MediumCW)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CHW(redeclare package Medium =
        MediumCHW) "inlet port for hotside WSE"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CHW(redeclare package Medium =
        MediumCHW) "outlet for hotside WSE"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWLeaWSE(
  redeclare package Medium = MediumCHW,
  m_flow_nominal=mCHW_flow_nominal)
    "Temperature sensor for WSE leaving chilled water"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWEntWSE(
  redeclare package Medium = MediumCHW,
  m_flow_nominal=
        mCHW_flow_nominal) "Temperature sensor for WSE entering chilled water "
    annotation (Placement(transformation(extent={{80,70},{60,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLeaWSE(
  redeclare package Medium = MediumCW,
  m_flow_nominal=
        mCW_flow_nominal)       "temperaure sensor for WSE entering condense water"
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntWSE(
  redeclare package Medium = MediumCW,
  m_flow_nominal=
        mCW_flow_nominal)
    "temperature sensor for WSE  entering condense water"
    annotation (Placement(transformation(extent={{-82,-90},{-62,-70}})));
  BypassControlForWSE                     temCon(GaiPi=GaiPi, tIntPi=tIntPi)
    "Temperature controller "
    annotation (Placement(transformation(extent={{-76,-28},{-60,-12}})));
  Modelica.Blocks.Interfaces.RealInput TSet "temperature set point"
    annotation (Placement(transformation(extent={{-128,-34},{-100,-6}}),
        iconTransformation(extent={{-120,-26},{-100,-6}})));
  Modelica.Blocks.Interfaces.RealInput on
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-128,6},{-100,34}}),
        iconTransformation(extent={{-120,14},{-100,34}})));
  TimerSISO                     tim
    annotation (Placement(transformation(extent={{-76,12},{-60,28}})));
  Modelica.Blocks.Interfaces.RealOutput runTim "running time"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{100,14},{112,26}})));
  Modelica.Blocks.Sources.RealExpression exp(y=if on > 0 then senTCHWLeaWSE.T
         else TSet)
    annotation (Placement(transformation(extent={{-96,-62},{-76,-42}})));
  Modelica.Blocks.Interfaces.RealOutput opeSta "Operation status(1:on, 0: 0ff)"
    annotation (Placement(transformation(extent={{100,-18},{120,2}}),
        iconTransformation(extent={{100,-26},{112,-14}})));
equation

  connect(senTCHWLeaWSE.port_b, port_b_CHW) annotation (Line(
      points={{80,-80},{100,-80}},
      color={0,127,255},
      thickness=1));
  connect(port_a_CHW, senTCHWEntWSE.port_a) annotation (Line(
      points={{100,80},{80,80}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWEntWSE.port_b,WSE. port_a_CHW) annotation (Line(points={{60,80},
          {40,80},{40,16},{12.1818,16}}, color={0,127,255},
      thickness=1));
  connect(senTCWLeaWSE.port_b, port_b_CW) annotation (Line(
      points={{-80,80},{-80,80},{-86,80},{-100,80}},
      color={0,127,255},
      thickness=1));
  connect(port_a_CW, senTCWEntWSE.port_a) annotation (Line(
      points={{-100,-80},{-100,-80},{-82,-80}},
      color={0,127,255},
      thickness=1));
  connect(senTCWEntWSE.port_b,WSE. port_a_CW) annotation (Line(points={{-62,-80},
          {-30,-80},{-30,-4},{-4.18182,-4}},
                                        color={0,127,255},
      thickness=1));
  connect(TSet, temCon.TSet) annotation (Line(
      points={{-114,-20},{-76.8,-20},{-76.8,-19.84}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(on, tim.on) annotation (Line(
      points={{-114,20},{-76.8,20},{-76.8,20.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(tim.y, runTim) annotation (Line(
      points={{-59.2,20},{-59.2,20},{110,20}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(WSE.port_b_CW, senTCWLeaWSE.port_a) annotation (Line(
      points={{-4.18182,16},{-4.18182,16},{-30,16},{-30,80},{-60,80}},
      color={0,127,255},
      thickness=1));
  connect(WSE.port_b_CHW, senTCHWLeaWSE.port_a) annotation (Line(
      points={{12.1818,-4.16667},{12.1818,-4.16667},{40,-4.16667},{40,-80},{60,
          -80}},
      color={0,127,255},
      thickness=1));
  connect(on, WSE.on) annotation (Line(
      points={{-114,20},{-102,20},{-92,20},{-92,42},{-10,42},{-10,-20},{
          0.909091,-20},{0.909091,-4.83333}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(temCon.y, WSE.bypSig) annotation (Line(
      points={{-59.2,-20},{-24,-20},{6,-20},{6,-4.83333}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(exp.y, temCon.T) annotation (Line(
      points={{-75,-52},{-68,-52},{-68,-28.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(on, opeSta) annotation (Line(
      points={{-114,20},{-92,20},{-92,42},{80,42},{80,-8},{110,-8}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-78,82},{78,76}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,62},{78,56}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,42},{78,36}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,22},{78,16}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,2},{78,-4}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,-18},{78,-24}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,-38},{78,-44}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-78,-56},{78,-62}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,-78},{-66,-94}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,-94},{-50,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-58,-78},{-58,-56}},
          color={255,0,0},
          pattern=LinePattern.Dash,
          thickness=1),
        Text(
          extent={{-114,-148},{108,-108}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This modulate contains two sub-models: heat exchanger with bypass, and a built-in PI controller to transmit signal to bypass. </p>
<h4>Thermal performance</h4>
<p>Heat and mass transfer is modeled in <a href=\"ChillerPlantSystem.BaseClasses.Components.WSEWithBypass\">ChillerPlantSystem.BaseClasses.Components.WSEWithBypass.</a></p>
<h4>Controller</h4>
<p>A PI controller is used to modulate the bypass signal to control the outlet water temperature. Details can be found in <A href=\"ChillerPlantSystem.BaseClasses.Control.BypassControlForWSE\">ChillerPlantSystem.BaseClasses.Control.BypassControlForWSE.</a></p>
</html>", revisions="<html>
<ul>
<li>Jul 30, 2016, by Yangyang Fu:<br/>
First Implementation.
</li>
</ul>
</html>"));
end WSEWithTControl;
