within Buildings.Templates.BaseClasses.CoolingTowerGroup;
model CoolingTowerParallel
  extends Buildings.Templates.Interfaces.CoolingTowerGroup(
    final typ=Buildings.Templates.Types.CoolingTowerGroup.CoolingTowerParallel);

  parameter Integer num(
    final min=1)=2
    "Number of cooling towers";
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve_nominal
   "Nominal pressure difference of the valve";
  parameter Real ratWatAir_nominal(
    final min=0,
    final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Temperature TWatIn_nominal
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Power PFan_nominal
    "Fan power"
    annotation (Dialog(group="Fan"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered opening"));

  replaceable Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow[num](
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final ratWatAir_nominal=ratWatAir_nominal,
    each final TAirInWB_nominal=TAirInWB_nominal,
    each final TWatIn_nominal=TWatIn_nominal,
    each final TWatOut_nominal=TWatIn_nominal-dT_nominal,
    each final PFan_nominal=PFan_nominal,
    each final dp_nominal=0)
    constrainedby
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTowerVariableSpeed(
      redeclare each final package Medium=Medium,
      each final show_T=show_T,
      each final m_flow_nominal=m_flow_nominal,
      each final energyDynamics=energyDynamics)
    "Cooling tower type"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val[num](
    redeclare each final package Medium=Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=m_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final use_inputFilter=use_inputFilter,
    each final dpFixed_nominal=dp_nominal)
    "Cooling tower valves"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yVal[num] annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,50})));
protected
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TWetBul(final nout=
        num) "Duplicator" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,50})));
equation
  for i in 1:num loop
    connect(port_a,val[i].port_a)
      annotation (Line(points={{-100,0},{-60,0}},color={0,127,255}));
    connect(val[i].port_b,cooTow[i].port_a)
      annotation (Line(points={{-40,0},{-10,0}},color={0,127,255}));
    connect(cooTow[i].port_b, port_b)
      annotation (Line(points={{10,0},{100,0}},color={0,127,255}));
  end for;
  connect(yVal.y, val.y)
    annotation (Line(points={{-50,38},{-50,12}}, color={0,0,127}));
  connect(busCon.out.yFan[:], cooTow.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-30,80},{-30,8},{-12,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.out.yVal[:], yVal.u) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-50,80},{-50,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(
      points={{60,100},{60,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TWetBul.y, cooTow.TAir) annotation (Line(points={{60,38},{60,30},{-20,
          30},{-20,4},{-12,4}}, color={0,0,127}));
  connect(cooTow.PFan, busCon.inp.PFan[:]) annotation (Line(points={{11,8},{20,
          8},{20,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cooTow.TLvg, busCon.inp.TLvg[:]) annotation (Line(points={{11,-6},{20,
          -6},{20,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end CoolingTowerParallel;
