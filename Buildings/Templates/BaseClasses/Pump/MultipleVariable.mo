within Buildings.Templates.BaseClasses.Pump;
model MultipleVariable
  extends Buildings.Templates.Interfaces.Pump(
    final typ=Types.Pump.MultipleVariable);

  parameter Integer nPum = 1
    "Number of pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

  replaceable Fluid.Movers.SpeedControlled_y pum[nPum](each energyDynamics=
        Modelica.Fluid.Types.Dynamics.FixedInitial)
    constrainedby Fluid.Movers.SpeedControlled_y(
      redeclare each final package Medium=Medium,
      each final inputType=Buildings.Fluid.Types.InputType.Continuous,
      each final per=per) "Pumps"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium = Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, nPum),
    final nCon=nPum)
    annotation (Placement(transformation(extent={{-20,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(final nout=nPum)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  Fluid.Sources.MassFlowSource_T floZer_a(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));
  Fluid.Sources.MassFlowSource_T floZer_b(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{54,-64},{34,-44}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yPum "Pump start/stop"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,30})));
  Buildings.Controls.OBC.CDL.Continuous.Product con "Resulting control signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,50})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(nin=nPum)
    "Minimum of all return signals"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta(t=1E-2, h=0.5E-2)
    "Evaluate pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,70})));
equation
  connect(port_a,colDis. port_aDisSup) annotation (Line(points={{-100,0},{-80,0},
          {-80,-40},{-30,-40},{-30,-50},{-20,-50}},
                                color={0,127,255}));
  connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-56},{28,
          -56},{28,-40},{80,-40},{80,0},{100,0}},
                           color={0,127,255}));
  connect(colDis.ports_bCon,pum. port_a) annotation (Line(points={{-12,-40},{
          -12,-20},{-40,-20},{-40,0},{-10,0}},
                                         color={0,127,255}));
  connect(reaRep.y,pum. y)
    annotation (Line(points={{-2.22045e-15,38},{0,12}},
                                             color={0,0,127}));
  connect(floZer_a.ports[1], colDis.port_bDisRet)
    annotation (Line(points={{-32,-60},{-26,-60},{-26,-56},{-20,-56}},
                                                   color={0,127,255}));
  connect(colDis.port_bDisSup, floZer_b.ports[1])
    annotation (Line(points={{20,-50},{28,-50},{28,-54},{34,-54}},
                                                 color={0,127,255}));
  connect(yPum.y, con.u2) annotation (Line(points={{-58,30},{-48,30},{-48,44},{-42,
          44}}, color={0,0,127}));
  connect(busCon.out.yPum, yPum.u) annotation (Line(
      points={{0.1,100.1},{0.1,90},{-88,90},{-88,30},{-82,30}},
      color={255,204,51},
      thickness=0.5));
  connect(con.y, reaRep.u) annotation (Line(points={{-18,50},{-14,50},{-14,62},{
          2.22045e-15,62}}, color={0,0,127}));
  connect(pum.y_actual,mulMin. u) annotation (Line(points={{11,7},{32,7},{32,30},
          {38,30}},              color={0,0,127}));
  connect(mulMin.y,evaSta. u)
    annotation (Line(points={{62,30},{70,30},{70,58}},
                                               color={0,0,127}));
  connect(busCon.out.ySpePum, con.u1) annotation (Line(
      points={{0.1,100.1},{0.1,90},{-50,90},{-50,56},{-42,56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(evaSta.y, busCon.inp.yPum_actual) annotation (Line(points={{70,82},{70,
          90},{0.1,90},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b, colDis.ports_aCon) annotation (Line(points={{10,0},{40,0},
          {40,-20},{12,-20},{12,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-60,-60},{100,-100}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
