within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses;
block WaterBasin "Water basin"

  parameter Modelica.Units.SI.Height height=0.5 "Height of the tank";
  parameter Modelica.Units.SI.Area crossArea=2 "Cross-sectional area of the tank";
  parameter Modelica.Units.SI.Height level_target(min=0, max=height)=0.15 "Target water level in the tank";
  parameter Modelica.Units.SI.MassFlowRate mMakUp_flow_nominal=0.5
    "Make up water mass flow nominal";
  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=2
    "Recirculation water mass flow nominal";
  parameter Real cycCon=4
    "Cycle of concentration for blowdown";
  replaceable package Medium =
    Buildings.Media.Water "Medium in the component";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEva_flow
    "Flow of evaporated water leaving the recirculation loop" annotation (
      Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mRecPum_flow
    "Mass flow setpoint of the recirculation pump" annotation (Placement(
        transformation(extent={{-160,-80},{-120,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  Modelica.Fluid.Vessels.OpenTank              tank(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    height=height,
    crossArea=crossArea,
    level_start=level_target,
    use_portsData=false,
    nPorts=3) "Open tank"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15)
    "System-wide properties"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Movers.FlowControlled_m_flow             mov(
    redeclare package Medium = Medium,
    per=per,
    addPowerToMedium=true)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-20})));
  parameter Movers.Data.Generic per
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  FixedResistances.PressureDrop                 preDro1(
    redeclare package Medium = Medium,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=20000)         "Pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-30})));
  FixedResistances.Junction                 junBloDow(
    redeclare package Medium = Medium,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,70})));
  Sources.MassFlowSource_T                 MakUpWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=288.15,
    nPorts=1) "Make up water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-70})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=tank.level)
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai(k=
        mMakUp_flow_nominal)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  FixedResistances.Junction                 junEva(
    redeclare package Medium = Medium,
    m_flow_nominal={mRec_flow_nominal,-mRec_flow_nominal,-mRec_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,30})));
  Modelica.Fluid.Sources.MassFlowSource_T sinEva(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for evaporative water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,30})));
  Modelica.Fluid.Sources.MassFlowSource_T sinBloDow(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for blowdown water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,70})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai1(k=1/(cycCon - 1))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,70})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToRea
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Controls.OBC.CDL.Reals.Hysteresis           hys(
    uLow=level_target - 0.05,
    uHigh=level_target + 0.05,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Controls.OBC.CDL.Logical.Not           not1
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=-1)
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Controls.OBC.CDL.Interfaces.RealOutput mMakUp_flow "Makeup water flow"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(tank.ports[1],mov. port_a) annotation (Line(points={{-21.3333,-50},{
          -21.3333,-60},{-70,-60},{-70,-30}},
                          color={0,127,255}));
  connect(preDro1.port_b,tank. ports[2]) annotation (Line(points={{10,-40},{10,-52},
          {-20,-52},{-20,-50}},     color={0,127,255}));
  connect(MakUpWat.ports[1],tank. ports[3]) annotation (Line(points={{80,-70},{
          -18.6667,-70},{-18.6667,-50}},color={0,127,255}));
  connect(gai.y,MakUpWat. m_flow_in)
    annotation (Line(points={{62,-90},{110,-90},{110,-78},{102,-78}},
                                                             color={0,0,127}));
  connect(junEva.port_3,sinEva. ports[1])
    annotation (Line(points={{20,30},{40,30}},   color={0,127,255}));
  connect(junBloDow.port_3,sinBloDow. ports[1])
    annotation (Line(points={{20,70},{40,70}}, color={0,127,255}));
  connect(gai1.y,sinBloDow. m_flow_in) annotation (Line(points={{78,70},{70,70},
          {70,62},{60,62}}, color={0,0,127}));
  connect(booToRea.y,gai. u)
    annotation (Line(points={{22,-90},{38,-90}},   color={0,0,127}));
  connect(realExpression.y,hys. u) annotation (Line(points={{-99,-90},{-82,-90}},
                       color={0,0,127}));
  connect(hys.y,not1. u) annotation (Line(points={{-58,-90},{-42,-90}},
                       color={255,0,255}));
  connect(not1.y,booToRea. u) annotation (Line(points={{-18,-90},{-2,-90}},
                 color={255,0,255}));
  connect(gai2.y,sinEva. m_flow_in) annotation (Line(points={{102,110},{120,110},
          {120,22},{60,22}},     color={0,0,127}));
  connect(gai2.y,gai1. u) annotation (Line(points={{102,110},{120,110},{120,70},
          {102,70}},   color={0,0,127}));
  connect(mov.port_b,junBloDow. port_1) annotation (Line(points={{-70,-10},{-68,
          -10},{-68,100},{10,100},{10,80}},      color={0,127,255}));
  connect(junBloDow.port_2,junEva. port_1)
    annotation (Line(points={{10,60},{10,40}},     color={0,127,255}));
  connect(junEva.port_2,preDro1. port_a)
    annotation (Line(points={{10,20},{10,-20}},    color={0,127,255}));
  connect(mEva_flow, gai2.u) annotation (Line(points={{-140,60},{-100,60},{-100,
          110},{78,110}}, color={0,0,127}));
  connect(mRecPum_flow, mov.m_flow_in) annotation (Line(points={{-140,-60},{-90,
          -60},{-90,-20},{-82,-20}}, color={0,0,127}));
  connect(gai.y, mMakUp_flow) annotation (Line(points={{62,-90},{110,-90},{110,0},
          {140,0}}, color={0,0,127}));
  annotation (defaultComponentName="watBas",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block routes the two Real inputs <code>u1</code> and <code>u3</code> to the two
Real outputs <code>y1</code> and <code>y2</code> based on the Boolean input
<code>u2</code>.
</p>
<p>
If <code>u2</code> is <code>true</code>, <code>y1 = u1</code> and
<code>y2 = u3</code>. If <code>u2</code> is <code>false</code>, <code>y1 = u3</code>
and <code>y2 = u1</code>.
</p>
</html>"));
end WaterBasin;
