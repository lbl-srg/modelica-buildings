within Buildings.DHC.Plants.Combined.Controls.BaseClasses;
block DirectHeatRecovery
  "Block controlling HRC in direct heat recovery mode"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real mChiWatChi_flow_nominal(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Chiller CHW design mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Real mChiWatChi_flow_min(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Chiller CHW minimum mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Real mChiWatChiHea_flow_nominal(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "HRC CHW design mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Real mChiWatChiHea_flow_min(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "HRC CHW minimum mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Real k(min=0)=0.01
    "Gain of controller"
    annotation (Dialog(group="Control parameters"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_reset=0.5
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_neutral=0.5
    "Value to which the controller output is reset when the controller is disabled"
    annotation (Dialog(group="Control parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,30},{-140,70}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvg[nChiHea](
    each final unit="K",
    each  displayUnit="degC")
    "Evaporator barrel leaving temperature (each HRC)"
    annotation (Placement(transformation(extent={{-180,-10},{-140,30}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1HeaCoo[nChiHea]
    "Direct HR command"
    annotation (Placement(transformation(extent={{-180,70},{-140,110}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nChiHea]
    "On/Off command"
    annotation (Placement(transformation(extent={{-180,110},{-140,150}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEvaChiSet_flow(
    final unit="kg/s") "Chiller evaporator flow setpoint"
    annotation (Placement(transformation(extent={{140,80},{180,120}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConEntChiHeaSet(
    final unit="K", displayUnit="degC")
    "HRC condenser entering temperature setpoint"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(
    final unit="K",
    displayUnit="degC")
    "Primary HW return temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-140,-10}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And heaCooAndOn[nChiHea]
    "Return true if direct HR AND On"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0, origin={-110,110})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable ctl[nChiHea](
    each final k=k,
    each final Ti=Ti,
    each final reverseActing=false,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "CHW supply temperature control"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiFloRes[nChiHea]
    "Chiller evaporator flow reset"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin min(nin=nChiHea)
    "Minimum evaporator flow setpoint"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo[nChiHea,2](
    final k=fill({0,0.33}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFlo[nChiHea,2](
    final k=fill(1.2 .* {mChiWatChi_flow_min,mChiWatChi_flow_nominal}, nChiHea))
    "y-value for flow reset"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiHeaFloRes[nChiHea]
    "HRC evaporator flow reset"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin min1(nin=nChiHea)
    "Minimum evaporator flow setpoint"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo1[nChiHea, 2](
    final k=fill({0.33,0.67}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFlo1[nChiHea, 2](
    final k=fill(1.2 .* {mChiWatChiHea_flow_nominal,mChiWatChiHea_flow_min}, nChiHea))
    "y-value for flow reset"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEvaChiHeaSet_flow(
    final unit="kg/s")
    "HRC evaporator flow setpoint"
    annotation (Placement(transformation(extent={{140,10},{180,50}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiHeaConTemRes[nChiHea]
    "HRC condenser entering temperature reset"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo2[nChiHea, 2](
    final k=fill({0.67,1.0}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff(final p=0.5)
    "Add offset"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff1(final p=-15)
    "Add offset"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{-40,-46},{-20,-26}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(
    final nout=nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea(
    final nin=nChiHea)
    "Keep reset value from HRC in direct HR with higher index"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage mea(delta=5*60)
    "Moving average"
    annotation (Placement(transformation(extent={{-130,-40},{-110,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[nChiHea] "Switch"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChiHea](
    final k=fill(1, nChiHea))
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nChiHea]
    "Convert integer to real"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(nin=nChiHea)
    "Maximum value of a vector input"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxChiHea[nChiHea](
    final k=chiInd)
    "HRC index"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
protected
  parameter Integer chiInd[nChiHea]={i for i in 1:nChiHea}
    "Chiller index";

equation
  connect(TChiWatSupSet, rep.u) annotation (Line(points={{-160,50},{-122,50}},
          color={0,0,127}));
  connect(y1, heaCooAndOn.u1) annotation (Line(points={{-160,130},{-130,130},{-130,
          110},{-122,110}},    color={255,0,255}));
  connect(y1HeaCoo, heaCooAndOn.u2) annotation (Line(points={{-160,90},{-130,90},
          {-130,102},{-122,102}}, color={255,0,255}));
  connect(rep.y, ctl.u_s)
    annotation (Line(points={{-98,50},{-62,50}},   color={0,0,127}));
  connect(TEvaLvg, ctl.u_m) annotation (Line(points={{-160,10},{-50,10},{-50,38}},
        color={0,0,127}));
  connect(heaCooAndOn.y, ctl.uEna) annotation (Line(points={{-98,110},{-90,110},
          {-90,30},{-54,30},{-54,38}},   color={255,0,255}));
  connect(chiFloRes.y, min.u)
    annotation (Line(points={{82,100},{98,100}}, color={0,0,127}));
  connect(yFlo[:, 2].y, chiFloRes.f2) annotation (Line(points={{42,80},{50,80},{
          50,92},{58,92}}, color={0,0,127}));
  connect(yFlo[:, 1].y, chiFloRes.f1) annotation (Line(points={{42,80},{50,80},{
          50,104},{58,104}}, color={0,0,127}));
  connect(ctl.y, chiFloRes.u) annotation (Line(points={{-38,50},{-10,50},{-10,100},
          {58,100}},    color={0,0,127}));
  connect(xFlo[:, 1].y, chiFloRes.x1) annotation (Line(points={{22,120},{40,120},
          {40,108},{58,108}}, color={0,0,127}));
  connect(xFlo[:, 2].y, chiFloRes.x2) annotation (Line(points={{22,120},{40,120},
          {40,96},{58,96}}, color={0,0,127}));
  connect(min.y, mEvaChiSet_flow) annotation (Line(points={{122,100},{160,100}},
                             color={0,0,127}));
  connect(chiHeaFloRes.y, min1.u)
    annotation (Line(points={{82,30},{98,30}}, color={0,0,127}));
  connect(yFlo1[:, 2].y, chiHeaFloRes.f2) annotation (Line(points={{42,10},{50,10},
          {50,22},{58,22}},      color={0,0,127}));
  connect(yFlo1[:, 1].y, chiHeaFloRes.f1) annotation (Line(points={{42,10},{50,10},
          {50,34},{58,34}},    color={0,0,127}));
  connect(ctl.y, chiHeaFloRes.u)
    annotation (Line(points={{-38,50},{-10,50},{-10,30},{58,30}}, color={0,0,127}));
  connect(xFlo1[:, 1].y, chiHeaFloRes.x1)
    annotation (Line(points={{22,50},{40,50},{40,38},{58,38}}, color={0,0,127}));
  connect(xFlo1[:, 2].y, chiHeaFloRes.x2) annotation (Line(points={{22,50},{40,50},
          {40,26},{58,26}}, color={0,0,127}));
  connect(min1.y, mEvaChiHeaSet_flow) annotation (Line(points={{122,30},{160,30}},
                            color={0,0,127}));
  connect(ctl.y, chiHeaConTemRes.u) annotation (Line(points={{-38,50},{-10,50},{
          -10,-40},{58,-40}}, color={0,0,127}));
  connect(xFlo2[:, 1].y, chiHeaConTemRes.x1) annotation (Line(points={{22,-20},{
          40,-20},{40,-32},{58,-32}}, color={0,0,127}));
  connect(xFlo2[:, 2].y, chiHeaConTemRes.x2) annotation (Line(points={{22,-20},{
          40,-20},{40,-44},{58,-44}}, color={0,0,127}));
  connect(addOff.y, rep1.u)
    annotation (Line(points={{-58,-30},{-50,-30},{-50,-36},{-42,-36}}, color={0,0,127}));
  connect(addOff1.y, rep2.u)
    annotation (Line(points={{-58,-60},{-2,-60}},    color={0,0,127}));
  connect(rep2.y, chiHeaConTemRes.f2) annotation (Line(points={{22,-60},{40,-60},
          {40,-48},{58,-48}}, color={0,0,127}));
  connect(rep1.y, chiHeaConTemRes.f1) annotation (Line(points={{-18,-36},{58,
          -36}},               color={0,0,127}));
  connect(extIndRea.y, TConEntChiHeaSet)
    annotation (Line(points={{122,-40},{160,-40}}, color={0,0,127}));
  connect(chiHeaConTemRes.y, extIndRea.u)
    annotation (Line(points={{82,-40},{98,-40}}, color={0,0,127}));
  connect(addOff.u, mea.y)
    annotation (Line(points={{-82,-30},{-108,-30}}, color={0,0,127}));
  connect(THeaWatPriRet, mea.u) annotation (Line(points={{-160,-30},{-132,-30}},
          color={0,0,127}));
  connect(mea.y, addOff1.u) annotation (Line(points={{-108,-30},{-100,-30},{
          -100,-60},{-82,-60}},
                           color={0,0,127}));
  connect(idxChiHea.y, intSwi.u1) annotation (Line(points={{-98,-90},{-60,-90},{
          -60,-92},{-42,-92}}, color={255,127,0}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{-98,-120},{-60,-120},{-60,
          -108},{-42,-108}}, color={255,127,0}));
  connect(heaCooAndOn.y, intSwi.u2) annotation (Line(points={{-98,110},{-90,110},
          {-90,-100},{-42,-100}}, color={255,0,255}));
  connect(intSwi.y, intToRea.u)
    annotation (Line(points={{-18,-100},{-2,-100}}, color={255,127,0}));
  connect(mulMax.y, reaToInt.u)
    annotation (Line(points={{62,-100},{78,-100}}, color={0,0,127}));
  connect(reaToInt.y, extIndRea.index) annotation (Line(points={{102,-100},{110,
          -100},{110,-52}}, color={255,127,0}));
  connect(intToRea.y, mulMax.u)
    annotation (Line(points={{22,-100},{38,-100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
In direct heat recovery mode, the HRC is internally controlled in heating mode
and tracks a HW supply temperature setpoint.
The CHW supply temperature setpoint is maintained by means of supervisory controls
that act on the evaporator flow rate and condenser entering water temperature as
described below.
</p>
<p>
A direct acting control loop runs for each HRC operating in direct heat recovery
mode.
Each loop is enabled with a bias of <i>50&nbsp;%</i> whenever the HRC
is commanded On and in direct heat recovery mode.
The loop is disabled with output set to <i>50&nbsp;%</i> otherwise.
The loop output is mapped as follows.
From <i>0&nbsp;%</i> to <i>33&nbsp;%</i> the evaporator flow setpoint of
cooling-only chillers is reset from <i>1.2</i> times its minimum value
to <i>1.2</i> times its design value.
From <i>33&nbsp;%</i> to <i>67&nbsp;%</i> the evaporator flow setpoint of
the HRC is reset from <i>1.2</i> times its minimum value
to <i>1.2</i> times its design value.
From <i>67&nbsp;%</i> to <i>100&nbsp;%</i> the HRC condenser entering
temperature setpoint is reset from <i>THeaWatRet + 0.5&nbsp;</i>°C
to <i>THeaWatRet - 15&nbsp;</i>°C.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end DirectHeatRecovery;
