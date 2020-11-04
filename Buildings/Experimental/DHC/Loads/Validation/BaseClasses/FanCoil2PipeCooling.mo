within Buildings.Experimental.DHC.Loads.Validation.BaseClasses;
model FanCoil2PipeCooling
  "Model of a sensible only two-pipe fan coil unit for cooling,
  computing a required chilled water mass flow rate"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1=Buildings.Media.Water,
    redeclare package Medium2=Buildings.Media.Air,
    final have_heaPor=false,
    final have_fluPor=false,
    final have_fan=true,
    final have_watHea=false,
    final have_watCoo=true,
    final have_QReq_flow=true,
    final allowFlowReversal=false,
    final allowFlowReversalLoa=true,
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
  parameter Modelica.SIunits.Time Ti(
    min=Modelica.Constants.small)=10
    "Time constant of integrator block";
  parameter Boolean use_inputFilter=true
    "= true, if fan speed is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (Dialog(tab="Dynamics",group="Filtered speed",enable=use_inputFilter));
  final parameter hexConfiguration hexConCoo=hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
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
    m_flow_nominal=mLoaCoo_flow_nominal,
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    dp_nominal=200)
    "Fan"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mLoaCoo_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_aChiWat_nominal,
    final T_a2_nominal=T_aLoaCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversalLoa)
    "Cooling coil"
    annotation (Placement(transformation(extent={{-80,4},{-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMasFlo(
    k=mChiWat_flow_nominal)
    "Scale water flow rate"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(
    y=hex.Q2_flow)
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(
    k=mLoaCoo_flow_nominal)
    "Scale air flow rate"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
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
  Buildings.Experimental.DHC.Loads.SimpleRoomODE TLoaODE(
    TOutHea_nominal=273.15-5,
    TIndHea_nominal=T_aLoaHea_nominal,
    QHea_flow_nominal=QHea_flow_nominal)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFlo(
    k=1/QCoo_flow_nominal)
    annotation (Placement(transformation(extent={{-88,210},{-68,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFlo1(
    k=1/QCoo_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={0,190})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Reset when demand rises from zero"
    annotation (Placement(transformation(extent={{-50,190},{-30,210}})));
equation
  connect(gaiFloNom2.y,fan.m_flow_in)
    annotation (Line(points={{62,180},{80,180},{80,12}},color={0,0,127}));
  connect(con.y,gaiMasFlo.u)
    annotation (Line(points={{12,220},{38,220}},color={0,0,127}));
  connect(fan.P,scaPFan.u)
    annotation (Line(points={{69,9},{60,9},{60,140},{158,140}},color={0,0,127}));
  connect(fan.port_b,hex.port_a2)
    annotation (Line(points={{70,0},{-60,0}},color={0,127,255}));
  connect(hex.port_b2,sinAir.ports[1])
    annotation (Line(points={{-80,0},{-100,0}},color={0,127,255}));
  connect(Q_flowCoo.y,TLoaODE.QAct_flow)
    annotation (Line(points={{141,200},{150,200},{150,160},{-20,160},{-20,32},{-12,32}},color={0,0,127}));
  connect(TLoaODE.TAir,retAir.T_in)
    annotation (Line(points={{12,40},{140,40},{140,4},{124,4}},color={0,0,127}));
  connect(gaiMasFlo.y,scaMasFloReqChiWat.u)
    annotation (Line(points={{62,220},{100,220},{100,80},{158,80}},color={0,0,127}));
  connect(scaQReqCoo_flow.y,TLoaODE.QReq_flow)
    annotation (Line(points={{-158,60},{-100,60},{-100,40},{-12,40}},color={0,0,127}));
  connect(Q_flowCoo.y,scaQActCoo_flow.u)
    annotation (Line(points={{141,200},{158,200}},color={0,0,127}));
  connect(TSetCoo,TLoaODE.TSet)
    annotation (Line(points={{-220,180},{-120,180},{-120,48},{-12,48}},color={0,0,127}));
  connect(scaQReqCoo_flow.y,gaiHeaFlo.u)
    annotation (Line(points={{-158,60},{-100,60},{-100,220},{-90,220}},color={0,0,127}));
  connect(gaiHeaFlo.y,con.u_s)
    annotation (Line(points={{-66,220},{-12,220}},color={0,0,127}));
  connect(con.u_m,gaiHeaFlo1.y)
    annotation (Line(points={{0,208},{0,202},{6.66134e-16,202}},color={0,0,127}));
  connect(Q_flowCoo.y,gaiHeaFlo1.u)
    annotation (Line(points={{141,200},{150,200},{150,160},{0,160},{0,178},{-8.88178e-16,178}},color={0,0,127}));
  connect(con.y,gaiFloNom2.u)
    annotation (Line(points={{12,220},{20,220},{20,180},{38,180}},color={0,0,127}));
  connect(retAir.ports[1],fan.port_a)
    annotation (Line(points={{102,0},{90,0}},color={0,127,255}));
  connect(greThr.y,con.trigger)
    annotation (Line(points={{-28,200},{-6,200},{-6,208}},color={255,0,255}));
  connect(gaiHeaFlo.y,greThr.u)
    annotation (Line(points={{-66,220},{-60,220},{-60,200},{-52,200}},color={0,0,127}));
  connect(scaChiWatFloInl.port_b,hex.port_a1)
    annotation (Line(points={{-160,-180},{-100,-180},{-100,-12},{-80,-12}},color={0,127,255}));
  connect(hex.port_b1,scaChiWatFloOut.port_a)
    annotation (Line(points={{-60,-12},{-40,-12},{-40,-180},{160,-180}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a sensible only simplified model of a two-pipe fan coil unit for cooling.
It is intended to be used
</p>
<ul>
<li>
in a case where the room thermal loads are provided as time series: it therefore
takes the load as an input, and
</li>
<li>
in conjunction with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>:
it therefore computes the water mass flow rate required to meet the load.
</li>
</ul>
<p>
For the sake of simplicity, a sensible only heat exchanger model is considered.
</p>
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
<a href=\"modelica://Buildings.Experimental.DHC.Loads.SimpleRoomODE\">
Buildings.Experimental.DHC.Loads.SimpleRoomODE</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end FanCoil2PipeCooling;
