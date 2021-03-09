within Buildings.Templates.AHUs.Fans;
model MultipleVariable
  "Multiple fans (identical) - Variable speed"
  extends Interfaces.Fan(
    final typ=Types.Fan.MultipleVariable);
  extends Data.MultipleVariable
    annotation (IconMap(primitivesVisible=false));

  replaceable Fluid.Movers.SpeedControlled_y fan[nFan](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare each final package Medium = MediumAir,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each final per=per)
    "Fan"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,10},{10,30}})));

  Modelica.Blocks.Routing.RealPassThrough  speSup if braStr=="Supply"
    "Supply fan speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,80})));
  Modelica.Blocks.Routing.RealPassThrough speRet if braStr=="Return"
    "Return fan speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,80})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium = MediumAir,
    final mCon_flow_nominal=fill(m_flow_nominal, nFan),
    final nCon=nFan)
    annotation (Placement(transformation(extent={{-20,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nFan)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,50})));
  Fluid.Sources.MassFlowSource_T floZer(
    redeclare final package Medium = MediumAir,
    final m_flow=0,
    nPorts=1)
    "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-52,-36},{-32,-16}})));
  Fluid.Sources.MassFlowSource_T floZer1(
    redeclare final package Medium = MediumAir,
    final m_flow=0,
    nPorts=1)
    "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{54,-30},{34,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comSup if braStr=="Supply"
    "Supply fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Product conSup1 if
                                                          braStr=="Supply"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal comRet if braStr=="Return"
    "Return fan start/stop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Product conRet1 if
                                                          braStr=="Return"
    "Resulting control signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,50})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nFan) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=
        0.5E-2) if                                               braStr=="Supply"
    "Evaluate fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough staSup if
                                                    braStr=="Supply"
    "Supply fan status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-80})));
  Modelica.Blocks.Routing.BooleanPassThrough staRet if
                                                    braStr=="Return"
    "Return fan status" annotation (Placement(transformation(
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
  connect(comSup.y, conSup1.u2)
    annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
  connect(speSup.y, conSup1.u1) annotation (Line(points={{-20,69},{-20,64},{-34,
          64},{-34,62}}, color={0,0,127}));
  connect(comRet.y, conRet1.u1)
    annotation (Line(points={{46,68},{46,62}}, color={0,0,127}));
  connect(speRet.y, conRet1.u2) annotation (Line(points={{20,69},{20,64},{34,64},
          {34,62}}, color={0,0,127}));
  connect(ahuBus.ahuO.yFanSup, comSup.u) annotation (Line(
      points={{0.1,100.1},{-46,100.1},{-46,92}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.ySpeFanSup, speSup.u) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,92}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.ySpeFanRet, speRet.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,92}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus.ahuO.yFanRet, comRet.u) annotation (Line(
      points={{0.1,100.1},{46,100.1},{46,92}},
      color={255,204,51},
      thickness=0.5));
  connect(conSup1.y, reaRep.u) annotation (Line(points={{-40,38},{-40,30},{-16,
          30},{-16,64},{0,64},{0,62}}, color={0,0,127}));
  connect(conRet1.y, reaRep.u) annotation (Line(points={{40,38},{40,30},{16,30},
          {16,64},{0,64},{0,62}}, color={0,0,127}));
  connect(fan.y_actual, mulMin.u) annotation (Line(points={{11,27},{24,27},{24,
          -36},{0,-36},{0,-38}}, color={0,0,127}));
  connect(evaSta.y, staRet.u) annotation (Line(points={{0,-92},{0,-94},{16,-94},
          {16,-80},{28,-80}}, color={255,0,255}));
  connect(evaSta.y, staSup.u) annotation (Line(points={{0,-92},{0,-94},{-14,-94},
          {-14,-80},{-28,-80}}, color={255,0,255}));
  connect(mulMin.y, evaSta.u)
    annotation (Line(points={{0,-62},{0,-68}}, color={0,0,127}));
  connect(staRet.y, ahuBus.ahuI.staFanRet) annotation (Line(points={{51,-80},{
          60,-80},{60,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
  connect(staSup.y, ahuBus.ahuI.staFanSup) annotation (Line(points={{-51,-80},{
          -60,-80},{-60,96},{0.1,96},{0.1,100.1}}, color={255,0,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-94,-10},{80,-68}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
