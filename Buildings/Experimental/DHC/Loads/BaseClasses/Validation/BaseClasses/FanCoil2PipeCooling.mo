within Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses;
model FanCoil2PipeCooling
  "Model of a sensible only two-pipe fan coil unit for cooling,
  computing a required chilled water mass flow rate"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1=Buildings.Media.Water,
    redeclare package Medium2=Buildings.Media.Air,
    final have_heaPor=false,
    final have_fluPor=false,
    final have_fan=true,
    final have_heaWat=false,
    final have_chiWat=true,
    final have_QReq_flow=true,
    allowFlowReversal=false,
    final allowFlowReversalLoa=false,
    final have_chaOve=false,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_TSen=false,
    final have_weaBus=false,
    final have_pum=false,
    mChiWat_flow_nominal=abs(
      QCoo_flow_nominal/cpChiWat_nominal/(T_aChiWat_nominal-T_bChiWat_nominal)));
  import hexConfiguration=Buildings.Fluid.Types.HeatExchangerConfiguration;
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 10
    "Time constant of integrator block";
  parameter Modelica.Units.SI.PressureDifference dpLoa_nominal(displayUnit="Pa")=
       250 "Load side pressure drop"
    annotation (Dialog(group="Nominal condition"));
  final parameter hexConfiguration hexConCoo=hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
  parameter Boolean have_speVar=true
    "Set to true for a variable speed fan (otherwise fan is always on)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Modelica.Units.SI.HeatFlowRate QEnv_flow_nominal(min=0)
    "Nominal envelope heat loss (for room air temperature prediction)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTEnv_nominal = 15
    "Design temperature difference at which envelope heat loss is QEnv_flow_nominal"
    annotation (Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset con(
    final k=k,
    final Ti=Ti,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final reverseActing=true)
    "PI controller"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium=Medium2,
    final allowFlowReversal=allowFlowReversalLoa,
    final m_flow_nominal=mLoaCoo_flow_nominal,
    redeclare final Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    final dp_nominal=dpLoa_nominal)
    "Fan"
    annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNtu(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mLoaCoo_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_aChiWat_nominal,
    final T_a2_nominal=T_aLoaCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversalLoa,
    final w_a2_nominal=w_aLoaCoo_nominal)
    "Cooling coil"
    annotation (Placement(transformation(extent={{-80,4},{-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiMasFlo(k=
        mChiWat_flow_nominal) "Scale water flow rate"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(
    final y=hexWetNtu.Q2_flow)
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiFloNom2(k=
        mLoaCoo_flow_nominal) "Scale air flow rate"
    annotation (Placement(transformation(extent={{52,170},{72,190}})));
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
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={112,0})));
  Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE TLoaODE(
    final dTEnv_nominal=dTEnv_nominal,
    TAir_start=297.15,
    final QEnv_flow_nominal=QEnv_flow_nominal) "Predicted room air temperature"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiHeaFlo(k=1/
        QCoo_flow_nominal)
    annotation (Placement(transformation(extent={{-88,210},{-68,230}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiHeaFlo1(k=1/
        QCoo_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,190})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    t=1E-4,
    h=0.5E-4)
    "Reset when demand rises from zero"
    annotation (Placement(transformation(extent={{-50,190},{-30,210}})));
  Fluid.FixedResistances.PressureDrop resLoa(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversalLoa,
    final m_flow_nominal=mLoaCoo_flow_nominal,
    final dp_nominal=dpLoa_nominal)
    "Load side pressure drop"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    "One constant"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=have_speVar)
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{26,170},{46,190}})));
equation
  connect(gaiFloNom2.y,fan.m_flow_in)
    annotation (Line(points={{74,180},{80,180},{80,20},{40,20},{40,12}},
                                                        color={0,0,127}));
  connect(con.y,gaiMasFlo.u)
    annotation (Line(points={{12,220},{38,220}},color={0,0,127}));
  connect(fan.P,mulPFan.u)
    annotation (Line(points={{29,9},{20,9},{20,140},{158,140}},color={0,0,127}));
  connect(fan.port_b, hexWetNtu.port_a2)
    annotation (Line(points={{30,0},{-60,0}}, color={0,127,255}));
  connect(hexWetNtu.port_b2, sinAir.ports[1])
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(Q_flowCoo.y,TLoaODE.QAct_flow)
    annotation (Line(points={{141,200},{150,200},{150,160},{-20,160},{-20,32},{-12,32}},color={0,0,127}));
  connect(TLoaODE.TAir,retAir.T_in)
    annotation (Line(points={{12,40},{140,40},{140,4},{124,4}},color={0,0,127}));
  connect(gaiMasFlo.y,mulMasFloReqChiWat.u)
    annotation (Line(points={{62,220},{100,220},{100,80},{158,80}},color={0,0,127}));
  connect(mulQReqCoo_flow.y,TLoaODE.QReq_flow)
    annotation (Line(points={{-158,60},{-100,60},{-100,40},{-12,40}},color={0,0,127}));
  connect(Q_flowCoo.y,mulQActCoo_flow.u)
    annotation (Line(points={{141,200},{158,200}},color={0,0,127}));
  connect(TSetCoo,TLoaODE.TSet)
    annotation (Line(points={{-220,180},{-120,180},{-120,48},{-12,48}},color={0,0,127}));
  connect(mulQReqCoo_flow.y,gaiHeaFlo.u)
    annotation (Line(points={{-158,60},{-100,60},{-100,220},{-90,220}},color={0,0,127}));
  connect(gaiHeaFlo.y,con.u_s)
    annotation (Line(points={{-66,220},{-12,220}},color={0,0,127}));
  connect(con.u_m,gaiHeaFlo1.y)
    annotation (Line(points={{0,208},{0,202},{6.66134e-16,202}},color={0,0,127}));
  connect(Q_flowCoo.y,gaiHeaFlo1.u)
    annotation (Line(points={{141,200},{150,200},{150,160},{0,160},{0,178},{-8.88178e-16,178}},color={0,0,127}));
  connect(greThr.y,con.trigger)
    annotation (Line(points={{-28,200},{-6,200},{-6,208}},color={255,0,255}));
  connect(gaiHeaFlo.y,greThr.u)
    annotation (Line(points={{-66,220},{-60,220},{-60,200},{-52,200}},color={0,0,127}));
  connect(mulChiWatFloInl.port_b, hexWetNtu.port_a1) annotation (Line(points={{
          -160,-180},{-100,-180},{-100,-12},{-80,-12}}, color={0,127,255}));
  connect(hexWetNtu.port_b1, mulChiWatFloOut.port_a) annotation (Line(points={{
          -60,-12},{-40,-12},{-40,-180},{160,-180}}, color={0,127,255}));
  connect(retAir.ports[1], resLoa.port_a)
    annotation (Line(points={{102,0},{80,0}}, color={0,127,255}));
  connect(resLoa.port_b, fan.port_a)
    annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
  connect(gaiFloNom2.u, swi.y)
    annotation (Line(points={{50,180},{48,180}}, color={0,0,127}));
  connect(con.y, swi.u1) annotation (Line(points={{12,220},{20,220},{20,188},{24,
          188}}, color={0,0,127}));
  connect(con1.y, swi.u2) annotation (Line(points={{-28,160},{-24,160},{-24,168},
          {16,168},{16,180},{24,180}}, color={255,0,255}));
  connect(one.y, swi.u3) annotation (Line(points={{12,140},{18,140},{18,172},{24,
          172}}, color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a simplified model of a two-pipe fan coil unit for cooling.
It is intended to be used
</p>
<ul>
<li>
in a case where the room thermal loads are provided as time series: it therefore
takes the load as an input, and
</li>
<li>
in conjunction with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution</a>:
it therefore computes the water mass flow rate required to meet the load.
</li>
</ul>
<p>
For the sake of computational performance, a PI controller is used instead of an inverse
model of the heat exchanger to assess the required water mass flow rate.
The controller output signal is mapped linearly to both,
</p>
<ul>
<li>
the water mass flow rate, from zero to its nominal value, and
</li>
<li>
the air mass flow rate, from zero to its nominal value.
</li>
</ul>
<p>
The controller tracks the load while the impact of an unmet load on the room
air temperature is assessed with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE\">
Buildings.Experimental.DHC.Loads.BaseClasses.SimpleRoomODE</a>.
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
          fillColor={0,0,255},
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
          thickness=1)}));
end FanCoil2PipeCooling;
