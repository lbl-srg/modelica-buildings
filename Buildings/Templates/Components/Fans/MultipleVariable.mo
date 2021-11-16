within Buildings.Templates.Components.Fans;
model MultipleVariable
  "Multiple fans (identical) - Variable speed"
  extends Buildings.Templates.Components.Fans.Interfaces.PartialFan(
    final typ=Buildings.Templates.Components.Types.Fan.MultipleVariable);

  parameter Integer nFan = 1
    "Number of fans"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

  Buildings.Fluid.Movers.SpeedControlled_y fan[nFan](
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare each final package Medium=Medium,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final per=per)
    "Fan"
    annotation (
      Placement(transformation(extent={{-10,10},{10,30}})));

  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium=Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, nFan),
    final nCon=nFan)
    annotation (Placement(transformation(extent={{-20,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator repSig(
    final nout=nFan)
    "Replicate signal"
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
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal sigSta
    "Start/stop signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,80})));
  Buildings.Controls.OBC.CDL.Continuous.Product sigCon
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,50})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nFan](
    each t=1E-2,
    each h=0.5E-2)
    "Evaluate fan status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-50})));
  Controls.OBC.CDL.Logical.MultiAnd sigRet(final nin=nFan)
    "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-80})));
equation
  connect(port_a, colDis.port_aDisSup) annotation (Line(points={{-100,0},{-28,0},
          {-28,-20},{-20,-20}}, color={0,127,255}));
  connect(fan.port_b, colDis.ports_aCon) annotation (Line(points={{10,20},{20,20},
          {20,0},{12,0},{12,-10}}, color={0,127,255}));
  connect(colDis.ports_bCon, fan.port_a) annotation (Line(points={{-12,-10},{-12,
          0},{-20,0},{-20,20},{-10,20}}, color={0,127,255}));
  connect(repSig.y, fan.y)
    annotation (Line(points={{0,38},{0,32}}, color={0,0,127}));
  connect(floZer.ports[1], colDis.port_bDisRet) annotation (Line(points={{-32,-26},
          {-20,-26}},                     color={0,127,255}));
  connect(colDis.port_bDisSup, floZer1.ports[1])
    annotation (Line(points={{20,-20},{34,-20}}, color={0,127,255}));
  connect(sigSta.y, sigCon.u2)
    annotation (Line(points={{-46,68},{-46,62}}, color={0,0,127}));
  connect(sigCon.y, repSig.u) annotation (Line(points={{-40,38},{-40,30},{-16,30},
          {-16,64},{0,64},{0,62}}, color={0,0,127}));
  connect(bus.ySpe, sigCon.u1) annotation (Line(
      points={{0,100},{0,68},{-34,68},{-34,62}},
      color={255,204,51},
      thickness=0.5));
  connect(fan.y_actual, evaSta.u) annotation (Line(points={{11,27},{24,27},{24,-36},
          {0,-36},{0,-38}}, color={0,0,127}));
  connect(evaSta.y, sigRet.u) annotation (Line(points={{-2.22045e-15,-62},{2.22045e-15,
          -68}}, color={255,0,255}));
  connect(sigRet.y, bus.y_actual) annotation (Line(points={{0,-92},{0,-96},{60,-96},
          {60,100},{0,100}},               color={255,0,255}));
  connect(bus.y, sigSta.u) annotation (Line(
      points={{0,100},{-46,100},{-46,92}},
      color={255,204,51},
      thickness=0.5));
  connect(colDis.port_aDisRet, V_flow.port_a) annotation (Line(points={{20,-26},
          {30,-26},{30,0},{70,0}}, color={0,127,255}));
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
              Icon(
    graphics={Bitmap(
        extent={{-78,-80},{82,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/MultipleVariable.svg")},
              coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-192,-16},{-18,-74}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
