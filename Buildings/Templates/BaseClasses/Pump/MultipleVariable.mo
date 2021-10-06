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
      Placement(transformation(extent={{-30,-10},{-10,10}})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium = Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, nPum),
    final nCon=nPum)
    annotation (Placement(transformation(extent={{-20,-60},{20,-40}})));
  Fluid.Sources.MassFlowSource_T floZer_a(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-60,-66},{-40,-46}})));
  Fluid.Sources.MassFlowSource_T floZer_b(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{60,-40},{40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaSta[nPum](t=1E-2, h=
       0.5E-2) "Evaluate pump status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,70})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nPum](each final uLow=
        threshold, each final uHigh=2*threshold)
    "Hysteresis for isolation valves"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nPum]
    "Boolean to real conversion for isolation valves"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Fluid.Actuators.Valves.TwoWayLinear val[nPum](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final l=l,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final allowFlowReversal=allowFlowReversal,
    each final show_T=show_T,
    each final rhoStd=rhoStd,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=init,
    final y_start=yValve_start,
    each final dpValve_nominal=dpValve_nominal,
    each final m_flow_nominal=m_flow_nominal,
    each final deltaM=deltaM,
    each final from_dp=from_dp,
    each final linearized=linearizeFlowResistance,
    each final homotopyInitialization=homotopyInitialization)
    "Isolation valves"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(port_a,colDis. port_aDisSup) annotation (Line(points={{-100,0},{-80,0},
          {-80,-40},{-30,-40},{-30,-50},{-20,-50}},
                                color={0,127,255}));
  connect(colDis.port_aDisRet, port_b) annotation (Line(points={{20,-56},{30,
          -56},{30,-40},{80,-40},{80,0},{100,0}},
                           color={0,127,255}));
  connect(colDis.ports_bCon,pum. port_a) annotation (Line(points={{-12,-40},{
          -12,-20},{-40,-20},{-40,0},{-30,0}},
                                         color={0,127,255}));
  connect(floZer_a.ports[1], colDis.port_bDisRet)
    annotation (Line(points={{-40,-56},{-20,-56}}, color={0,127,255}));
  connect(colDis.port_bDisSup, floZer_b.ports[1])
    annotation (Line(points={{20,-50},{40,-50}}, color={0,127,255}));
  connect(evaSta.y, busCon.inp.yPum_actual) annotation (Line(points={{70,82},{70,
          90},{0.1,90},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b, val.port_a)
    annotation (Line(points={{-10,0},{10,0}}, color={0,127,255}));
  connect(val.port_b, colDis.ports_aCon) annotation (Line(points={{30,0},{40,0},
          {40,-20},{12,-20},{12,-40}}, color={0,127,255}));
  connect(hys.y, booToRea.u)
    annotation (Line(points={{-38,50},{-22,50}}, color={255,0,255}));
  connect(booToRea.y, val.y)
    annotation (Line(points={{2,50},{20,50},{20,12}}, color={0,0,127}));
  connect(busCon.out.ySpePum, pum[1].y) annotation (Line(
      points={{0.1,100.1},{0.1,96},{0,96},{0,90},{-80,90},{-80,20},{-20,20},{
          -20,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pum.y_actual, evaSta.u) annotation (Line(points={{-9,7},{6,7},{6,30},
          {70,30},{70,58}}, color={0,0,127}));
  connect(busCon.out.ySpePum, hys[1].u) annotation (Line(
      points={{0.1,100.1},{0.1,90},{-80,90},{-80,50},{-62,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-60,-60},{100,-100}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="Boundary conditions are only needed for OCT
that fails to translate when CollectorDistributor ports are left unconnected.")}));
end MultipleVariable;
