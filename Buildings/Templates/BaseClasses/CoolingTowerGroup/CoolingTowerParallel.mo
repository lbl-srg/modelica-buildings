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
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val[num](
    redeclare each final package Medium=Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=m_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final use_inputFilter=use_inputFilter,
    each final dpFixed_nominal=dp_nominal)
    "Cooling tower valves"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yVal[num] annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,50})));
  Fluid.Sources.MassFlowSource_T floZer_a(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-60,-66},{-40,-46}})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium = Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, num),
    final nCon=num)
    annotation (Placement(transformation(extent={{-20,-60},{20,-40}})));
  Fluid.Sources.MassFlowSource_T floZer_b(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{60,-40},{40,-60}})));
protected
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TWetBul(final nout=
        num) "Duplicator" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
equation
  for i in 1:num loop
    connect(val[i].port_b,cooTow[i].port_a)
      annotation (Line(points={{-10,0},{8,0}},  color={0,127,255}));
  end for;
  connect(yVal.y, val.y)
    annotation (Line(points={{-50,38},{-50,18},{-20,18},{-20,12}},
                                                 color={0,0,127}));
  connect(busCon.out.yFan[:], cooTow.y) annotation (Line(
      points={{0.1,100.1},{0.1,8},{6,8}},
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
      points={{50,100},{50,80},{70,80},{70,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TWetBul.y, cooTow.TAir) annotation (Line(points={{70,38},{70,32},{-6,
          32},{-6,4},{6,4}},    color={0,0,127}));
  connect(cooTow.PFan, busCon.inp.PFan[:]) annotation (Line(points={{29,8},{50,
          8},{50,60},{0.1,60},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cooTow.TLvg, busCon.inp.TLvg[:]) annotation (Line(points={{29,-6},{50,
          -6},{50,60},{0.1,60},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(floZer_a.ports[1],colDis. port_bDisRet)
    annotation (Line(points={{-40,-56},{-20,-56}}, color={0,127,255}));
  connect(colDis.port_bDisSup,floZer_b. ports[1])
    annotation (Line(points={{20,-50},{40,-50}}, color={0,127,255}));
  connect(port_a, colDis.port_aDisSup) annotation (Line(points={{-100,0},{-80,0},
          {-80,-40},{-26,-40},{-26,-50},{-20,-50}}, color={0,127,255}));
  connect(colDis.ports_bCon, val.port_a) annotation (Line(points={{-12,-40},{
          -12,-20},{-40,-20},{-40,0},{-30,0}}, color={0,127,255}));
  connect(cooTow.port_b, colDis.ports_aCon) annotation (Line(points={{28,0},{40,
          0},{40,-20},{12,-20},{12,-40}}, color={0,127,255}));
  connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-56},{34,
          -56},{34,-40},{80,-40},{80,0},{100,0}}, color={0,127,255}));
  annotation (Diagram(graphics={                               Text(
          extent={{-72,-58},{88,-98}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end CoolingTowerParallel;
