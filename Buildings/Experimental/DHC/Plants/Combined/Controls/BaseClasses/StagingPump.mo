within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPump "Pump staging"

  parameter Integer nPum(
    final min=1,
    start=1)
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Integer nChi(
    final min=1,
    start=1)
    "Number of chillers served by the pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Loop design mass flow rate (all pumps)"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean have_switchover=false
    "Set to true in case of switchover valve in series with isolation valve"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final unit="kg/s")
    "Mass flow rate as measured by the loop flow meter" annotation (Placement(
        transformation(extent={{-220,20},{-180,60}}), iconTransformation(extent
          ={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal[nChi](each final unit="1")
    "Chiller isolation valve commanded position"
    annotation (Placement(
        transformation(extent={{-220,-60},{-180,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{180,-20},{220,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratFlo(
    final k=1/m_flow_nominal)
    "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOff(p=0.03)
    "Add offset"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.Ceiling
    numOpe(final yMin=0, final yMax=nPum)
           "Compute number of pumps to be operating"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve(delta=600)
    "Moving average"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nPum)
    "Replicate"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdLag[nPum](
    final t={i for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter sca(
    final k=nPum) "Scale"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Logical.And andLeaEna[nPum]
    "Command On only if lead pump enabled"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep1(final nout=
        nPum) "Replicate"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe[nChi](each t=0.1, each h=
        5E-2)
    "Check if valve open"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr isAnyOpe(nin=nChi)
    "Check if ANY valve open"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe2[nChi](each t=
        0.1, each h=5E-2)
    if have_switchover
    "Check if valve open"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And isoAndSwiOpe[nChi]
    "Check if isolation valve AND switchover valve open"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nChi](each final k=
        true)          if not have_switchover
    "Constant"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValSwi[nChi](each final unit
      ="1")
    if have_switchover
    "Chiller switchover valve commanded position"
    annotation (Placement(
        transformation(extent={{-220,-100},{-180,-60}}),  iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay
                                           delRis(delayTime=60)
    "Delay allowing for valve rise time"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(ratFlo.y, addOff.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={0,0,127}));
  connect(m_flow, movAve.u) annotation (Line(points={{-200,40},{-182,40},{-182,40},
          {-162,40}}, color={0,0,127}));
  connect(movAve.y, ratFlo.u)
    annotation (Line(points={{-138,40},{-122,40}}, color={0,0,127}));
  connect(numOpe.y, rep.u)
    annotation (Line(points={{22,40},{38,40}}, color={255,127,0}));
  connect(rep.y, cmdLag.u)
    annotation (Line(points={{62,40},{78,40}}, color={255,127,0}));
  connect(addOff.y, sca.u)
    annotation (Line(points={{-58,40},{-42,40}}, color={0,0,127}));
  connect(sca.y, numOpe.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={0,0,127}));
  connect(cmdLag.y, andLeaEna.u1)
    annotation (Line(points={{102,40},{118,40}}, color={255,0,255}));
  connect(andLeaEna[2:nPum].y, y1[2:nPum]) annotation (Line(points={{142,40},{
          160,40},{160,0},{200,0}}, color={255,0,255}));
  connect(rep1.y, andLeaEna.u2) annotation (Line(points={{102,0},{110,0},{110,
          32},{118,32}}, color={255,0,255}));
  connect(yVal, isOpe.u)
    annotation (Line(points={{-200,-40},{-162,-40}}, color={0,0,127}));
  connect(yValSwi,isOpe2. u)
    annotation (Line(points={{-200,-80},{-162,-80}},   color={0,0,127}));
  connect(isOpe2.y, isoAndSwiOpe.u2) annotation (Line(points={{-138,-80},{-130,
          -80},{-130,-48},{-82,-48}}, color={255,0,255}));
  connect(tru.y, isoAndSwiOpe.u2) annotation (Line(points={{-98,-80},{-90,-80},
          {-90,-48},{-82,-48}}, color={255,0,255}));
  connect(isOpe.y, isoAndSwiOpe.u1)
    annotation (Line(points={{-138,-40},{-82,-40}}, color={255,0,255}));
  connect(isoAndSwiOpe.y, isAnyOpe.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(isAnyOpe.y, delRis.u)
    annotation (Line(points={{-18,-40},{-2,-40}}, color={255,0,255}));
  connect(delRis.y, rep1.u) annotation (Line(points={{22,-40},{60,-40},{60,0},{
          78,0}}, color={255,0,255}));
  connect(delRis.y, y1[1]) annotation (Line(points={{22,-40},{160,-40},{160,0},
          {200,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="staPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}})));
end StagingPump;
