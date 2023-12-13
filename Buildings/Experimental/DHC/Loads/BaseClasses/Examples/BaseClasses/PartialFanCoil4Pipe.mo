within Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses;
partial model PartialFanCoil4Pipe
  "Partial model of a sensible only four-pipe fan coil unit computing a required water mass flow rate"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1=Buildings.Media.Water,
    redeclare package Medium2=Buildings.Media.Air,
    final have_heaWat=true,
    final have_chiWat=true,
    final have_fan=true,
    final allowFlowReversal=false,
    final allowFlowReversalLoa=true,
    final have_chaOve=false,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_QReq_flow=false,
    final have_weaBus=false,
    final have_pum=false,
    final mHeaWat_flow_nominal=abs(
      QHea_flow_nominal/cpHeaWat_nominal/(T_aHeaWat_nominal-T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(
      QCoo_flow_nominal/cpChiWat_nominal/(T_aChiWat_nominal-T_bChiWat_nominal)));
  import hexConfiguration=Buildings.Fluid.Types.HeatExchangerConfiguration;
  final parameter hexConfiguration hexConHea=hexConfiguration.CounterFlow
    "Heating heat exchanger configuration";
  final parameter hexConfiguration hexConCoo=hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
  Buildings.Controls.OBC.CDL.Reals.PID conHea(
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=true,
    yMin=0)
    "PI controller for heating"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=max(
      {mLoaHea_flow_nominal,mLoaCoo_flow_nominal}),
    redeclare final Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    dp_nominal=400,
    final allowFlowReversal=allowFlowReversalLoa)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mLoaHea_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_aHeaWat_nominal,
    final T_a2_nominal=T_aLoaHea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversalLoa)
    annotation (Placement(transformation(extent={{-80,4},{-60,-16}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiHeaFloNom(k=
        mHeaWat_flow_nominal)
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(
    y=hexHea.Q2_flow)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNtu(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mLoaCoo_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_aChiWat_nominal,
    final T_a2_nominal=T_aLoaCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversalLoa,
    final w_a2_nominal=w_aLoaCoo_nominal)
    annotation (Placement(transformation(extent={{0,4},{20,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexWetNtu.Q2_flow)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiFloNom2(k=max({
        mLoaHea_flow_nominal,mLoaCoo_flow_nominal}))
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Reals.PID conCoo(
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=false,
    yMin=0)
    "PI controller for cooling"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gaiCooFloNom(k=
        mChiWat_flow_nominal) "Scaling"
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Utilities.Math.SmoothMax smoothMax(
    deltaX=1E-2)
    "C1 maximum"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
equation
  connect(hexWetNtu.port_b2, hexHea.port_a2)
    annotation (Line(points={{0,0},{-60,0}}, color={0,127,255}));
  connect(fan.port_b, hexWetNtu.port_a2)
    annotation (Line(points={{70,0},{20,0}}, color={0,127,255}));
  connect(gaiFloNom2.y,fan.m_flow_in)
    annotation (Line(points={{62,140},{80,140},{80,12}},color={0,0,127}));
  connect(conHea.y,gaiHeaFloNom.u)
    annotation (Line(points={{12,220},{38,220}},color={0,0,127}));
  connect(conCoo.y,gaiCooFloNom.u)
    annotation (Line(points={{12,180},{38,180}},color={0,0,127}));
  connect(gaiHeaFloNom.y,mulMasFloReqHeaWat.u)
    annotation (Line(points={{62,220},{134,220},{134,100},{158,100}},color={0,0,127}));
  connect(gaiCooFloNom.y,mulMasFloReqChiWat.u)
    annotation (Line(points={{62,180},{128,180},{128,80},{158,80}},color={0,0,127}));
  connect(fan.P,mulPFan.u)
    annotation (Line(points={{69,9},{60,9},{60,16},{152,16},{152,140},{158,140}},color={0,0,127}));
  connect(Q_flowHea.y,mulQActHea_flow.u)
    annotation (Line(points={{-59,60},{140,60},{140,220},{158,220}},color={0,0,127}));
  connect(Q_flowCoo.y,mulQActCoo_flow.u)
    annotation (Line(points={{-59,40},{146,40},{146,200},{158,200}},color={0,0,127}));
  connect(TSetCoo,conCoo.u_s)
    annotation (Line(points={{-220,180},{-20,180},{-20,180},{-12,180}},color={0,0,127}));
  connect(TSetHea,conHea.u_s)
    annotation (Line(points={{-220,220},{-60,220},{-60,220},{-12,220}},color={0,0,127}));
  connect(smoothMax.y,gaiFloNom2.u)
    annotation (Line(points={{11,140},{38,140}},color={0,0,127}));
  connect(conHea.y,smoothMax.u1)
    annotation (Line(points={{12,220},{20,220},{20,200},{-20,200},{-20,146},{-12,146}},color={0,0,127}));
  connect(conCoo.y,smoothMax.u2)
    annotation (Line(points={{12,180},{20,180},{20,120},{-20,120},{-20,134},{-12,134}},color={0,0,127}));
  connect(mulChiWatFloInl.port_b, hexWetNtu.port_a1) annotation (Line(points={{-160,
          -180},{-20,-180},{-20,-12},{0,-12}}, color={0,127,255}));
  connect(hexWetNtu.port_b1, mulChiWatFloOut.port_a) annotation (Line(points={{20,
          -12},{40,-12},{40,-180},{160,-180}}, color={0,127,255}));
  connect(hexHea.port_b1,mulHeaWatFloOut.port_a)
    annotation (Line(points={{-60,-12},{-40,-12},{-40,-220},{160,-220}},color={0,127,255}));
  connect(mulHeaWatFloInl.port_b,hexHea.port_a1)
    annotation (Line(points={{-160,-220},{-100,-220},{-100,-12},{-80,-12}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a simplified partial model of a sensible only four-pipe fan coil unit
for heating and cooling.
It is intended to be used in conjunction with
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution</a>,
and hence it computes the water mass flow rate required to meet the temperature
set point.
</p>
<p>
For the sake of simplicity, a sensible only heat exchanger model is considered.
</p>
<p>
For the sake of computational performance, a PI controller is used instead of an inverse
model of the heat exchanger to assess the required water mass flow rate.
Each controller output signal is mapped linearly to the water mass flow rate,
from zero to its nominal value.
The maximum of the two output signals is mapped linearly to the air mass
flow rate, from zero to its nominal value.
</p>
<p>
The model takes the measured room air temperature as an input (as opposed to
the fan inlet temperature) to maintain a valid control loop output in case
of zero air flow rate.
</p>
<p>
The model is partial to allow various connectivity options on the load side:
either with fluid ports or with heat ports.
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
end PartialFanCoil4Pipe;
