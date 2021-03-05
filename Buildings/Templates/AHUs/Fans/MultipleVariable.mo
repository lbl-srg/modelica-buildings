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

  Modelica.Blocks.Routing.RealPassThrough  conSup if braStr=="Supply"
    "Pass through block used to used to connect the right control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,80})));
  Modelica.Blocks.Routing.RealPassThrough conRet if braStr=="Return"
    "Pass through block used to used to connect the right control signal"
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
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Fluid.Sources.MassFlowSource_T floZer1(
    redeclare final package Medium = MediumAir,
    final m_flow=0,
    nPorts=1)
    "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
equation
  connect(ahuBus.ahuO.yFanSup, conSup.u) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(ahuBus.ahuO.yFanRet, conRet.u) annotation (Line(
      points={{0.1,100.1},{20,100.1},{20,92}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, colDis.port_aDisSup) annotation (Line(points={{-100,0},{-30,0},
          {-30,-20},{-20,-20}}, color={0,127,255}));
  connect(fan.port_b, colDis.ports_aCon) annotation (Line(points={{10,20},{20,20},
          {20,0},{12,0},{12,-10}}, color={0,127,255}));
  connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-26},{30,-26},
          {30,0},{100,0}}, color={0,127,255}));
  connect(colDis.ports_bCon, fan.port_a) annotation (Line(points={{-12,-10},{-12,
          0},{-20,0},{-20,20},{-10,20}}, color={0,127,255}));
  connect(reaRep.y, fan.y)
    annotation (Line(points={{0,38},{0,32}}, color={0,0,127}));
  connect(conSup.y, reaRep.u) annotation (Line(points={{-20,69},{-20,66},{0,66},
          {0,62}}, color={0,0,127}));
  connect(conRet.y, reaRep.u)
    annotation (Line(points={{20,69},{20,66},{0,66},{0,62}}, color={0,0,127}));
  connect(floZer.ports[1], colDis.port_bDisRet) annotation (Line(points={{-60,-20},
          {-40,-20},{-40,-26},{-20,-26}}, color={0,127,255}));
  connect(colDis.port_bDisSup, floZer1.ports[1])
    annotation (Line(points={{20,-20},{60,-20}}, color={0,127,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-20,-14},{154,-72}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
