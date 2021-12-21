within Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup;
model CoolingTowerParallel
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CoolingTowerGroup.Interfaces.PartialCoolingTowerGroup(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.CoolingTowerGroup.CoolingTowerParallel);

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));

  final parameter Modelica.Units.SI.MassFlowRate mTow_flow_nominal=
    m_flow_nominal/nCooTow "Single tower nominal mass flow rate";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    dat.getReal(varName=id + ".CoolingTower.dp_nominal.value")
    "Nominal pressure difference of the tower"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    dat.getReal(varName=id + ".CoolingTower.dpValve_nominal.value")
    "Nominal pressure difference of the valve";
  parameter Real ratWatAir_nominal(
    final min=0,
    final unit="1")=0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=
    dat.getReal(varName=id + ".CoolingTower.TAirInWB_nominal.value")
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Temperature TWatIn_nominal=
    dat.getReal(varName=id + ".CoolingTower.TCW_nominal.value")
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal=
    dat.getReal(varName=id + ".CoolingTower.dT_nominal.value")
    "Temperature difference between inlet and outlet of the tower"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.Units.SI.Power PFan_nominal=
    dat.getReal(varName=id + ".CoolingTower.PFan_nominal.value")
    "Fan power"
    annotation (Dialog(group="Fan"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation (Dialog(tab="Dynamics",group="Filtered opening"));

  replaceable Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel cooTow[nCooTow](
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
      each final m_flow_nominal=mTow_flow_nominal,
      each final energyDynamics=energyDynamics)
    "Cooling tower type"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val[nCooTow](
    redeclare each final package Medium=Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_nominal=mTow_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final use_inputFilter=use_inputFilter,
    each final dpFixed_nominal=dp_nominal)
    "Cooling tower valves"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yVal[nCooTow] annotation (
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
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=fill(mTow_flow_nominal, nCooTow),
    final nCon=nCooTow)
    annotation (Placement(transformation(extent={{-20,-60},{20,-40}})));
  Fluid.Sources.MassFlowSource_T floZer_b(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{60,-40},{40,-60}})));
protected
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TWetBul(final nout=
        nCooTow) "Duplicator" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,50})));
equation
  for i in 1:nCooTow loop
    connect(val[i].port_b,cooTow[i].port_a)
      annotation (Line(points={{-10,0},{8,0}},  color={0,127,255}));
  end for;
  connect(yVal.y, val.y)
    annotation (Line(points={{-50,38},{-50,18},{-20,18},{-20,12}},
                                                 color={0,0,127}));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(
      points={{50,100},{50,80},{70,80},{70,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TWetBul.y, cooTow.TAir) annotation (Line(points={{70,38},{70,32},{-6,32},
          {-6,4},{6,4}},        color={0,0,127}));
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
  connect(busCon.yFan, cooTow.y) annotation (Line(
      points={{0,100},{0,8},{6,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.yVal, yVal.u) annotation (Line(
      points={{0,100},{0,68},{-50,68},{-50,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(cooTow.PFan, busCon.PFan) annotation (Line(points={{29,8},{50,8},{50,68},
          {0,68},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(cooTow.TLvg, busCon.TLvg) annotation (Line(points={{29,-6},{50,-6},{50,
          68},{0,68},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(graphics={                               Text(
          extent={{-72,-58},{88,-98}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end CoolingTowerParallel;
