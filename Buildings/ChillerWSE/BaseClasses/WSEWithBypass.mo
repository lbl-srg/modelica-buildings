within Buildings.ChillerWSE.BaseClasses;
model WSEWithBypass
  "Water side economizer with hotside outlet temperature control"
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
    "Pressure difference of three way valve";
  //---------------------------------------------------------------------------
  //                          Performance Data
  //---------------------------------------------------------------------------
  parameter Real eps "constant effectiveness";

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
   redeclare package Medium1 = MediumCW,
   redeclare package Medium2 = MediumCHW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=dpCHW_nominal,
    eps=eps)
    annotation (Placement(transformation(extent={{4,-12},{36,22}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a_CHW(
  redeclare package Medium = MediumCHW) "inlet port for hotside WSE"
    annotation (Placement(transformation(extent={{130,-110},{150,-90}}),
        iconTransformation(extent={{130,-110},{150,-90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWLeaWSE(redeclare package
      Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialState)       annotation (
      Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=90,
        origin={-84,-64})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CHW(
  redeclare package Medium = MediumCHW) "outlet for hotside WSE"
    annotation (Placement(transformation(extent={{-112,-110},{-92,-90}}),
        iconTransformation(extent={{-112,-110},{-92,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_CW(
  redeclare package Medium = MediumCW)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}}),
        iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_CW(
  redeclare package Medium = MediumCW)
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{130,70},{150,90}}),
        iconTransformation(extent={{130,70},{150,90}})));
  Modelica.Blocks.Interfaces.RealInput bypSig "(0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-128,-50},{-100,-22}}),
        iconTransformation(extent={{-120,-42},{-100,-22}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dp_byp_nominal,
    init=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{28,-62},{8,-42}})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage  valCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    allowFlowReversal=false,
    dpValve_nominal=dpCW_nominal,
    init=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={74,40})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage  valCHW(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=dp_byp_nominal,
    init=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{-11,11},{11,-11}},
        rotation=180,
        origin={-57,-5})));
  Modelica.Blocks.Interfaces.RealInput on
    "Actuator position (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-128,26},{-100,54}}),
        iconTransformation(extent={{-120,14},{-100,34}})));
  Modelica.Blocks.Math.Product pro "Product of no/off signal and bypass signal"
    annotation (Placement(transformation(extent={{-66,-28},{-50,-44}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWLeaHex(redeclare package
      Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature sensor for chilled water leaving the hex, which doesn't mix with bypass water"
    annotation (Placement(transformation(extent={{-6,-16},{-26,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWEntWSE(redeclare package
      Medium = MediumCHW, m_flow_nominal=mCHW_flow_nominal,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Temperature sensor for chilled waterentering WSE"
    annotation (Placement(transformation(extent={{120,-112},{96,-88}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWEntWSE(m_flow_nominal=
        mCW_flow_nominal, redeclare package Medium = MediumCW)
    "Temperature sensor for condense water entering WSE"
    annotation (Placement(transformation(extent={{-76,68},{-52,92}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCWLeaWSE(m_flow_nominal=
        mCW_flow_nominal, redeclare package Medium = MediumCW)
    "Temperature sensor for condense water leaving WSE"
    annotation (Placement(transformation(extent={{96,68},{120,92}})));
equation

  connect(senTCHWLeaWSE.port_b, port_b_CHW) annotation (Line(
      points={{-84,-76},{-84,-76},{-84,-100},{-102,-100}},
      color={0,127,255},
      thickness=1));
  connect(hex.port_b1, valCW.port_a) annotation (Line(
      points={{36,15.2},{74,15.2},{74,30}},
      color={0,127,255},
      thickness=1));
  connect(valCHW.port_b, senTCHWLeaWSE.port_a) annotation (Line(
      points={{-68,-5},{-68,-6},{-84,-6},{-84,-52}},
      color={0,127,255},
      thickness=1));
  connect(valByp.port_b, valCHW.port_a) annotation (Line(
      points={{8,-52},{-38,-52},{-38,-5},{-46,-5}},
      color={0,127,255},
      thickness=1));
  connect(on, pro.u1) annotation (Line(
      points={{-114,40},{-94,40},{-94,-8},{-94,-26},{-94,-40.8},{-67.6,-40.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bypSig, pro.u2) annotation (Line(
      points={{-114,-36},{-94,-36},{-94,-31.2},{-67.6,-31.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pro.y, valByp.y) annotation (Line(
      points={{-49.2,-36},{18,-36},{18,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(hex.port_b2, senTCHWLeaHex.port_a) annotation (Line(
      points={{4,-5.2},{-6,-5.2},{-6,-5}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWLeaHex.port_b, valCHW.port_a) annotation (Line(
      points={{-26,-5},{-26,-5},{-46,-5}},
      color={0,127,255},
      thickness=1));
  connect(port_a_CHW, senTCHWEntWSE.port_a) annotation (Line(
      points={{140,-100},{130,-100},{120,-100}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWEntWSE.port_b, hex.port_a2) annotation (Line(
      points={{96,-100},{74,-100},{74,-5.2},{36,-5.2}},
      color={0,127,255},
      thickness=1));
  connect(senTCHWEntWSE.port_b, valByp.port_a) annotation (Line(
      points={{96,-100},{74,-100},{74,-52},{28,-52}},
      color={0,127,255},
      thickness=1));
  connect(hex.port_a1, senTCWEntWSE.port_b) annotation (Line(
      points={{4,15.2},{-38,15.2},{-38,80},{-52,80}},
      color={0,127,255},
      thickness=1));
  connect(senTCWEntWSE.port_a, port_a_CW) annotation (Line(
      points={{-76,80},{-88,80},{-100,80}},
      color={0,127,255},
      thickness=1));
  connect(valCW.port_b, senTCWLeaWSE.port_a) annotation (Line(
      points={{74,50},{74,80},{96,80}},
      color={0,127,255},
      thickness=1));
  connect(senTCWLeaWSE.port_b, port_b_CW) annotation (Line(
      points={{120,80},{140,80}},
      color={0,127,255},
      thickness=1));
  connect(on, valCHW.y) annotation (Line(
      points={{-114,40},{-86,40},{-57,40},{-57,8.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(on, valCW.y) annotation (Line(
      points={{-114,40},{62,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},
            {140,100}}),                                        graphics={
        Text(
          extent={{-142,-162},{172,-132}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-80,80},{120,76}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,62},{120,58}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,40},{120,36}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,22},{120,18}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,2},{120,-2}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-18},{120,-22}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-38},{120,-42}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-58},{120,-62}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-78},{120,-82}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{140,100}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>This module simulates a heat exchanger with bypass used to modulate water flow rate.</p>
</html>", revisions="<html>
<ul>
<li>
September 08, 2016, by Yangyang Fu:<br>
Delete parameter: nominal flowrate of temperaure sensors. 
</li>
</ul>
<ul>
<li>
July 30, 2016, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end WSEWithBypass;
