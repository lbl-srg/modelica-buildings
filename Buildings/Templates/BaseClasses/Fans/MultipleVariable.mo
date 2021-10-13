within Buildings.Templates.BaseClasses.Fans;
model MultipleVariable
  "Multiple fans (identical) - Variable speed"
  extends Buildings.Templates.Interfaces.Fan(
    final typ=Types.Fan.MultipleVariable);

  parameter Integer nFan = 1
    "Number of fans"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

  replaceable Fluid.Movers.SpeedControlled_y fan[nFan](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare each final package Medium=Medium,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each final per=per)
    "Fan"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Routing.RealPassThrough ySpeFanSup
 if loc==Templates.Types.Location.Supply
    "Pass through to connect with specific control signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,80})));
  Modelica.Blocks.Routing.RealPassThrough ySpeFanRet
 if loc==Templates.Types.Location.Return or loc==Templates.Types.Location.Relief
    "Pass through to connect with specific control signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,80})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium=Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, nFan),
    final nCon=nFan)
    annotation (Placement(transformation(extent={{-20,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nFan)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  Fluid.Sources.MassFlowSource_T floZer(
    redeclare final package Medium=Medium,
    final m_flow=0,
    nPorts=1)
    "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-52,-36},{-32,-16}})));
  Fluid.Sources.MassFlowSource_T floZer1(
    redeclare final package Medium=Medium,
    final m_flow=0,
    nPorts=1)
    "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{54,-30},{34,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yFanSup
 if loc==Templates.Types.Location.Supply
    "Supply fan start/stop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Product conSup1
 if loc==Templates.Types.Location.Supply
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yFanRet
 if loc==Templates.Types.Location.Return or loc==Templates.Types.Location.Relief
    "Return fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Product conRet1
 if loc==Templates.Types.Location.Return or loc==Templates.Types.Location.Relief
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,50})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    nin=nFan)
    "Minimum of all return signals"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(
    t=1E-2,
    h=0.5E-2)
    "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanSup_actual
 if loc==Templates.Types.Location.Supply
    "Supply fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough yFanRet_actual
 if loc==Templates.Types.Location.Return or loc==Templates.Types.Location.Relief
    "Return fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-80})));
equation
  connect(port_a, colDis.port_aDisSup) annotation (Line(points={{-100,0},{-28,0},
          {-28,-20},{-20,-20}}, color={0,127,255}));
  connect(fan.port_b, colDis.ports_aCon) annotation (Line(points={{10,20},{20,20},
          {20,0},{12,0},{12,-10}}, color={0,127,255}));
  connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-26},{28,
          -26},{28,0},{100,0}},
                           color={0,127,255}));
  connect(colDis.ports_bCon, fan.port_a) annotation (Line(points={{-12,-10},{-12,
          0},{-20,0},{-20,20},{-10,20}}, color={0,127,255}));
  connect(reaRep.y, fan.y)
    annotation (Line(points={{0,38},{0,32}}, color={0,0,127}));
  connect(floZer.ports[1], colDis.port_bDisRet) annotation (Line(points={{-32,-26},
          {-20,-26}},                     color={0,127,255}));
  connect(colDis.port_bDisSup, floZer1.ports[1])
    annotation (Line(points={{20,-20},{34,-20}}, color={0,127,255}));
  connect(yFanSup.y, conSup1.u2)
    annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
  connect(ySpeFanSup.y, conSup1.u1) annotation (Line(points={{-20,69},{-20,64},
          {-34,64},{-34,62}}, color={0,0,127}));
  connect(yFanRet.y, conRet1.u1)
    annotation (Line(points={{46,68},{46,62}}, color={0,0,127}));
  connect(ySpeFanRet.y, conRet1.u2) annotation (Line(points={{20,69},{20,64},{
          34,64},{34,62}}, color={0,0,127}));
  connect(busCon.out.yFanSup, yFanSup.u) annotation (Line(
      points={{0.1,100.1},{-46,100.1},{-46,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.ySpeFanSup, ySpeFanSup.u) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.ySpeFanRet, ySpeFanRet.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,92}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon.out.yFanRet, yFanRet.u) annotation (Line(
      points={{0.1,100.1},{46,100.1},{46,92}},
      color={255,204,51},
      thickness=0.5));
  connect(conSup1.y, reaRep.u) annotation (Line(points={{-40,38},{-40,30},{-16,
          30},{-16,64},{0,64},{0,62}}, color={0,0,127}));
  connect(conRet1.y, reaRep.u) annotation (Line(points={{40,38},{40,30},{16,30},
          {16,64},{0,64},{0,62}}, color={0,0,127}));
  connect(fan.y_actual, mulMin.u) annotation (Line(points={{11,27},{24,27},{24,
          -36},{0,-36},{0,-38}}, color={0,0,127}));
  connect(evaSta.y, yFanRet_actual.u) annotation (Line(points={{0,-92},{0,-94},
          {16,-94},{16,-80},{28,-80}}, color={255,0,255}));
  connect(evaSta.y, yFanSup_actual.u) annotation (Line(points={{0,-92},{0,-94},
          {-14,-94},{-14,-80},{-28,-80}}, color={255,0,255}));
  connect(mulMin.y, evaSta.u)
    annotation (Line(points={{0,-62},{0,-68}}, color={0,0,127}));
  connect(yFanSup_actual.y, busCon.inp.yFanSup_actual) annotation (Line(points=
          {{-51,-80},{-60,-80},{-60,100.1},{0.1,100.1}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(yFanRet_actual.y, busCon.inp.yFanRet_actual) annotation (Line(points=
          {{51,-80},{80,-80},{80,100.1},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(
    graphics={Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/MultipleVariable.svg")},
              coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-94,-10},{80,-68}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
