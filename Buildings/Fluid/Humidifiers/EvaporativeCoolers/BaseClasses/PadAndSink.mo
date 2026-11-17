within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses;
block PadAndSink "Rigid media pad and sink for blowdown"
  extends Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.RigidMediaPad;
  parameter Modelica.Units.SI.Height height=0.5 "Height of the tank";
  parameter Modelica.Units.SI.Area crossArea=2 "Cross-sectional area of the tank";
  parameter Modelica.Units.SI.Height level_target=0.15 "Target water level in the tank";
  parameter Modelica.Units.SI.MassFlowRate mMakUp_flow_nominal=0.5
    "Make up water mass flow nominal";
  parameter Real cycCon=4
    "Cycle of concentration for blowdown";

  Modelica.Fluid.Vessels.OpenTank              tank(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    height=height,
    crossArea=crossArea,
    level_start=level_target,
    use_portsData=false,
    nPorts=3) "Open tank"
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  inner Modelica.Fluid.System system(p_ambient=101325, T_ambient=293.15)
    "System-wide properties"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Movers.SpeedControlled_y                 mov(
    redeclare package Medium = Medium,
    per=per,
    addPowerToMedium=true)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-220})));
  parameter Movers.Data.Pumps.Wilo.Stratos30slash1to8                 per1
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  FixedResistances.PressureDrop                 preDro1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=20000)         "Pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,-230})));
  FixedResistances.Junction                 junBloDow(
    redeclare package Medium = Medium,
    m_flow_nominal={m_flow_nominal,-m_flow_nominal,-m_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,-130})));
  Sources.MassFlowSource_T                 MakUpWat(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=288.15,
    nPorts=1) "Make up water"
    annotation (Placement(transformation(extent={{-40,-300},{-20,-280}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=tank.level)
    annotation (Placement(transformation(extent={{-220,-320},{-200,-300}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai(k=
        mMakUp_flow_nominal)
    annotation (Placement(transformation(extent={{-70,-320},{-50,-300}})));
  Controls.OBC.CDL.Reals.Sources.Constant           con1(k=1)
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));
  FixedResistances.Junction                 junEva(
    redeclare package Medium = Medium,
    m_flow_nominal={m_flow_nominal,-m_flow_nominal,-m_flow_nominal},
    dp_nominal={25,-25,-25}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,-170})));
  Modelica.Fluid.Sources.MassFlowSource_T sinEva(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for evaporative water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-170})));
  Modelica.Fluid.Sources.MassFlowSource_T sinBloDow(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=293.15,
    nPorts=1) "Mass flow sink for blowdown water" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-130})));
  Controls.OBC.CDL.Reals.MultiplyByParameter           gai1(k=1/(cycCon - 1))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-130})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToRea
    annotation (Placement(transformation(extent={{-102,-320},{-82,-300}})));
  Controls.OBC.CDL.Reals.Hysteresis           hys(
    uLow=level_target - 0.05,
    uHigh=level_target + 0.05,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
  Controls.OBC.CDL.Logical.Not           not1
    annotation (Placement(transformation(extent={{-140,-320},{-120,-300}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=-1)
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation
  connect(tank.ports[1],mov. port_a) annotation (Line(points={{-1.33333,-250},{-1.33333,
          -260},{-50,-260},{-50,-230}},
                          color={0,127,255}));
  connect(preDro1.port_b, tank.ports[2]) annotation (Line(points={{30,-240},{30,
          -252},{0,-252},{0,-250}}, color={0,127,255}));
  connect(MakUpWat.ports[1],tank. ports[3]) annotation (Line(points={{-20,-290},
          {1.33333,-290},{1.33333,-250}},
                                        color={0,127,255}));
  connect(gai.y,MakUpWat. m_flow_in)
    annotation (Line(points={{-48,-310},{-42,-310},{-42,-282}},
                                                             color={0,0,127}));
  connect(con1.y,mov. y)
    annotation (Line(points={{-98,-220},{-62,-220}},
                                                 color={0,0,127}));
  connect(junEva.port_3,sinEva. ports[1])
    annotation (Line(points={{40,-170},{60,-170}},
                                                 color={0,127,255}));
  connect(junBloDow.port_3,sinBloDow. ports[1])
    annotation (Line(points={{40,-130},{60,-130}},
                                               color={0,127,255}));
  connect(gai1.y,sinBloDow. m_flow_in) annotation (Line(points={{98,-130},{90,-130},
          {90,-138},{80,-138}},
                            color={0,0,127}));
  connect(booToRea.y,gai. u)
    annotation (Line(points={{-80,-310},{-72,-310}},
                                                   color={0,0,127}));
  connect(realExpression.y,hys. u) annotation (Line(points={{-199,-310},{-182,-310}},
                       color={0,0,127}));
  connect(hys.y,not1. u) annotation (Line(points={{-158,-310},{-142,-310}},
                       color={255,0,255}));
  connect(not1.y,booToRea. u) annotation (Line(points={{-118,-310},{-104,-310}},
                 color={255,0,255}));
  connect(swiEvaCoo.y, gai2.u) annotation (Line(points={{82,-30},{90,-30},{90,-50},
          {98,-50}}, color={0,0,127}));
  connect(gai2.y, sinEva.m_flow_in) annotation (Line(points={{122,-50},{140,-50},
          {140,-178},{80,-178}}, color={0,0,127}));
  connect(gai2.y, gai1.u) annotation (Line(points={{122,-50},{140,-50},{140,-130},
          {122,-130}}, color={0,0,127}));
  connect(mov.port_b, junBloDow.port_1) annotation (Line(points={{-50,-210},{-48,
          -210},{-48,-100},{30,-100},{30,-120}}, color={0,127,255}));
  connect(junBloDow.port_2, junEva.port_1)
    annotation (Line(points={{30,-140},{30,-160}}, color={0,127,255}));
  connect(junEva.port_2, preDro1.port_a)
    annotation (Line(points={{30,-180},{30,-220}}, color={0,127,255}));
  annotation (defaultComponentName="selLarVal",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-220},{100,100}})),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> largest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
Boolean vector <code>y</code>, where <code>true</code> means that the value at the
corresponding index is one of the largest values, and <code>false</code> means
that it is not.
</p>
<p>
If the input vector <code>u</code> contains equal values, this block will
prioritize values that appear first in <code>u</code> when
selecting the <code>nSel</code> largest values.
</p>
<p>
Setting the disabled flag vector <code>disFla = true</code> serves to exclude certain
values in the input vector from the ranking of the largest values. These values will
have the Boolean output <code>y = false</code>. If the total number of values after
excluding is less than <code>nSel</code>, all non-excluded values will have the
Boolean output <code>y = true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PadAndSink;
