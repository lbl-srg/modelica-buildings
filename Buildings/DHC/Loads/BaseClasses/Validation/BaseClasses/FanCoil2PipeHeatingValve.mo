within Buildings.DHC.Loads.BaseClasses.Validation.BaseClasses;
model FanCoil2PipeHeatingValve
  "Model of a two-pipe fan coil unit for heating, with a two-way control valve"
  extends Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1=Buildings.Media.Water,
    redeclare package Medium2=Buildings.Media.Air,
    final have_heaPor=false,
    final have_fluPor=false,
    final have_fan=true,
    final have_heaWat=true,
    final have_chiWat=false,
    final have_QReq_flow=true,
    final allowFlowReversal=false,
    final allowFlowReversalLoa=false,
    final have_chaOve=false,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_TSen=false,
    final have_weaBus=false,
    final have_pum=false,
    final mHeaWat_flow_nominal=abs(
      QHea_flow_nominal/cpHeaWat_nominal/(T_aHeaWat_nominal-T_bHeaWat_nominal)));
  import hexConfiguration=Buildings.Fluid.Types.HeatExchangerConfiguration;
  final parameter hexConfiguration hexConHea=hexConfiguration.CounterFlow
    "Heating heat exchanger configuration";
  parameter Boolean have_speVar=true
    "Set to true for a variable speed fan (otherwise fan is always on)";
  parameter Modelica.Units.SI.PressureDifference dpLoa_nominal(displayUnit="Pa")=
       250 "Load side pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpSou_nominal=30000
    "Nominal pressure drop on source side";
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversalLoa,
    final m_flow_nominal=mLoaHea_flow_nominal,
    redeclare final Fluid.Movers.Data.Generic per,
    addPowerToMedium=true,
    nominalValuesDefineDefaultPressureCurve=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_riseTime=false,
    final dp_nominal=dpLoa_nominal) "Fan"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.PID con(
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=true,
    yMin=0)
    "PI controller"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mLoaHea_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_aHeaWat_nominal,
    final T_a2_nominal=T_aLoaHea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversalLoa)
    "Heating coil"
    annotation (Placement(transformation(extent={{-80,4},{-60,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(
    y=hex.Q2_flow)
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiFloNom2(k=
        mLoaHea_flow_nominal)
    annotation (Placement(transformation(extent={{56,170},{76,190}})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium=Medium2,
    use_T_in=false,
    nPorts=1)
    "Sink for supply air"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,0})));
  Fluid.Sources.Boundary_pT retAir(
    redeclare package Medium=Medium2,
    use_T_in=true,
    nPorts=1)
    "Source for return air"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,0})));
  Buildings.DHC.Loads.BaseClasses.SimpleRoomODE TLoaODE(
    dTEnv_nominal=25,
    TAir_start=293.15,
    QEnv_flow_nominal=QHea_flow_nominal) "Predicted room air temperature"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=10000,
    use_inputFilter=false,
    final allowFlowReversal=allowFlowReversal,
    dpFixed_nominal=dpSou_nominal-10000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={-40,-80})));
  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiHeaFlo(k=1/
        QHea_flow_nominal)
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiHeaFlo1(k=1/
        QHea_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,190})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    k=1)
    "One constant"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    k=have_speVar)
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{30,170},{50,190}})));
  Fluid.FixedResistances.PressureDrop resLoa(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversalLoa,
    final m_flow_nominal=mLoaHea_flow_nominal,
    final dp_nominal=dpLoa_nominal)
    "Load side pressure drop"
    annotation (Placement(transformation(extent={{94,-10},{74,10}})));
equation
  connect(gaiFloNom2.y,fan.m_flow_in)
    annotation (Line(points={{78,180},{60,180},{60,12}},color={0,0,127}));
  connect(fan.P,mulPFan.u)
    annotation (Line(points={{49,9},{40,9},{40,140},{158,140}},color={0,0,127}));
  connect(Q_flowHea.y,mulQActHea_flow.u)
    annotation (Line(points={{141,220},{150,220},{150,220},{158,220}},color={0,0,127}));
  connect(fan.port_b,hex.port_a2)
    annotation (Line(points={{50,0},{-60,0}},color={0,127,255}));
  connect(hex.port_b2,sinAir.ports[1])
    annotation (Line(points={{-80,0},{-100,0}},color={0,127,255}));
  connect(TSetHea,TLoaODE.TSet)
    annotation (Line(points={{-220,220},{-120,220},{-120,48},{-12,48}},color={0,0,127}));
  connect(mulQReqHea_flow.y,TLoaODE.QReq_flow)
    annotation (Line(points={{-158,100},{-100,100},{-100,40},{-12,40}},color={0,0,127}));
  connect(Q_flowHea.y,TLoaODE.QAct_flow)
    annotation (Line(points={{141,220},{150,220},{150,160},{-20,160},{-20,32},{-12,32}},color={0,0,127}));
  connect(TLoaODE.TAir,retAir.T_in)
    annotation (Line(points={{12,40},{130,40},{130,4},{122,4}},color={0,0,127}));
  connect(hex.port_b1,val.port_a)
    annotation (Line(points={{-60,-12},{-40,-12},{-40,-70}},color={0,127,255}));
  connect(val.port_b,senMasFlo.port_a)
    annotation (Line(points={{-40,-90},{-40,-110}},color={0,127,255}));
  connect(con.y,val.y)
    annotation (Line(points={{12,220},{20,220},{20,-80},{-28,-80}},color={0,0,127}));
  connect(senMasFlo.m_flow,mulMasFloReqHeaWat.u)
    annotation (Line(points={{-29,-120},{140,-120},{140,100},{158,100}},color={0,0,127}));
  connect(mulQReqHea_flow.y,gaiHeaFlo.u)
    annotation (Line(points={{-158,100},{-100,100},{-100,220},{-42,220}},color={0,0,127}));
  connect(gaiHeaFlo.y,con.u_s)
    annotation (Line(points={{-18,220},{-12,220}},color={0,0,127}));
  connect(Q_flowHea.y,gaiHeaFlo1.u)
    annotation (Line(points={{141,220},{150,220},{150,160},{0,160},{0,178},{-8.88178e-16,178}},color={0,0,127}));
  connect(con.u_m,gaiHeaFlo1.y)
    annotation (Line(points={{0,208},{0,207},{6.66134e-16,207},{6.66134e-16,202}},color={0,0,127}));
  connect(gaiFloNom2.u,swi.y)
    annotation (Line(points={{54,180},{52,180}},color={0,0,127}));
  connect(con.y,swi.u1)
    annotation (Line(points={{12,220},{20,220},{20,188},{28,188}},color={0,0,127}));
  connect(con1.y,swi.u2)
    annotation (Line(points={{-38,170},{24,170},{24,180},{28,180}},color={255,0,255}));
  connect(one.y,swi.u3)
    annotation (Line(points={{12,140},{26,140},{26,172},{28,172}},color={0,0,127}));
  connect(senMasFlo.port_b,mulHeaWatFloOut.port_a)
    annotation (Line(points={{-40,-130},{-40,-220},{160,-220}},color={0,127,255}));
  connect(mulHeaWatFloInl.port_b,hex.port_a1)
    annotation (Line(points={{-160,-220},{-100,-220},{-100,-12},{-80,-12}},color={0,127,255}));
  connect(retAir.ports[1], resLoa.port_a)
    annotation (Line(points={{100,0},{94,0}}, color={0,127,255}));
  connect(resLoa.port_b, fan.port_a)
    annotation (Line(points={{74,0},{70,0}}, color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a simplified model of a two-pipe fan coil unit for heating. It is
intended to be used in a case where the room thermal loads are provided
as time series, and hence it takes the load as an input.
</p>
<p>
A PI controller tracks the load.
The controller output signal is mapped linearly to both,
</p>
<ul>
<li>
the opening of a two-way control valve, and
</li>
<li>
the air mass flow rate, from zero to its nominal value.
</li>
</ul>
<p>
The impact of an unmet load on the room air temperature is assessed with
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.SimpleRoomODE\">
Buildings.DHC.Loads.BaseClasses.SimpleRoomODE</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-120,-1.46958e-14},{-80,-9.79717e-15},{-40,60},{40,-60},{80,9.79717e-15},{120,1.46958e-14}},
          color={255,255,255},
          thickness=1,
          rotation=180),
        Polygon(
          points={{46,62},{70,70},{62,46},{46,62}},
          lineColor={255,255,255},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-118,-118},{120,120}},
          color={255,255,255},
          thickness=1),
    Polygon(
      points={{-72,-100},{-86,-90},{-86,-112},{-72,-100}},
      lineColor={0,0,0},
      fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{-72,-100},{-60,-90},{-60,-112},{-72,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid)}));
end FanCoil2PipeHeatingValve;
