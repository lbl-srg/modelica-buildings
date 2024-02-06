within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
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
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal
    "Chiller CHW design mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_min
    "Chiller CHW minimum mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="CHW loop and cooling-only chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_nominal
    "HRC CHW design mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChiHea_flow_min
    "HRC CHW minimum mass flow rate (value will be used for each unit)"
    annotation(Dialog(group="HW loop and heat recovery chillers"));

  parameter Real k(min=0)=0.01
    "Gain of controller"
    annotation (Dialog(group="Control parameters"));
  parameter Modelica.Units.SI.Time Ti=60
    "Time constant of integrator block"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_reset=0.5
    "Value to which the controller output is reset if the boolean trigger has a rising edge"
    annotation (Dialog(group="Control parameters"));
  parameter Real y_neutral=0.5
    "Value to which the controller output is reset when the controller is disabled"
    annotation (Dialog(group="Control parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC") "CHW supply temperature setpoint"
    annotation (Placement(transformation(
          extent={{-180,-20},{-140,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaLvg[nChiHea](each final unit="K",
    each  displayUnit="degC") "Evaporator barrel leaving temperature (each HRC)"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1HeaCoo[nChiHea]
    "Direct HR command" annotation (Placement(transformation(extent={{-180,20},{
            -140,60}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nChiHea]
    "On/Off command" annotation (Placement(transformation(extent={{-180,60},{-140,
            100}}), iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEvaChiSet_flow(
    final unit="kg/s") "Chiller evaporator flow setpoint"
    annotation (Placement(transformation(
          extent={{140,60},{180,100}}),   iconTransformation(extent={{100,40},{140,
            80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConEntChiHeaSet(
    final unit="K", displayUnit="degC")
    "HRC condenser entering temperature setpoint" annotation (Placement(
        transformation(extent={{140,-100},{180,-60}}), iconTransformation(
          extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") "Primary HW return temperature" annotation (Placement(
        transformation(extent={{-180,-100},{-140,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And heaCooAndOn[nChiHea]
    "Return true if direct HR AND On" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep(
    final nout=nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  EnergyTransferStations.Combined.Controls.PIDWithEnable ctl[nChiHea](
    each final k=k,
    each final Ti=Ti,
    each final reverseActing=false,
    each final y_reset=y_reset,
    each final y_neutral=y_neutral)
    "CHW supply temperature control"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiFloRes[nChiHea]
    "Chiller evaporator flow reset"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin min(nin=nChiHea)
    "Minimum evaporator flow setpoint"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo[nChiHea,2](
    final k=fill({0,0.33}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFlo[nChiHea,2](
    final k=fill(1.2 .* {mChiWatChi_flow_min,mChiWatChi_flow_nominal}, nChiHea))
    "y-value for flow reset"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiHeaFloRes[nChiHea]
    "HRC evaporator flow reset"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin min1(nin=nChiHea)
    "Minimum evaporator flow setpoint"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo1    [nChiHea, 2](final k=
        fill({0.33,0.67}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFlo1    [nChiHea, 2](final k=
        fill(1.2 .* {mChiWatChiHea_flow_nominal,mChiWatChiHea_flow_min}, nChiHea))
    "y-value for flow reset"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mEvaChiHeaSet_flow(final
      unit="kg/s") "HRC evaporator flow setpoint" annotation (Placement(
        transformation(extent={{140,-20},{180,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Line chiHeaConTemRes[nChiHea]
    "HRC condenser entering temperature reset"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant xFlo2    [nChiHea, 2](final k=
        fill({0.67,1.0}, nChiHea))
    "x-value for flow reset"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff(final p=0.5)
    "Add offset"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff1(final p=-15)
    "Add offset"
    annotation (Placement(transformation(extent={{-90,-130},{-70,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator rep2(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndRea(final nin=nChiHea)
    "Keep reset value from HRC in direct HR with higher index"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Blocks.Sources.IntegerExpression idxHig(final y=max({if heaCooAndOn[
        i].y then i else 1 for i in 1:nChiHea}))
    "Highest index of HRC in direct HR (defaulted to 1 if all false)"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage mea(delta=5*60)
    "Moving average"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
equation
  connect(TChiWatSupSet, rep.u) annotation (Line(points={{-160,0},{-122,0}},
                                 color={0,0,127}));
  connect(y1, heaCooAndOn.u1) annotation (Line(points={{-160,80},{-130,80},{
          -130,60},{-122,60}},
                          color={255,0,255}));
  connect(y1HeaCoo, heaCooAndOn.u2) annotation (Line(points={{-160,40},{-130,40},
          {-130,52},{-122,52}}, color={255,0,255}));
  connect(rep.y, ctl.u_s)
    annotation (Line(points={{-98,0},{-72,0}},     color={0,0,127}));
  connect(TEvaLvg, ctl.u_m) annotation (Line(points={{-160,-40},{-60,-40},{-60,-12}},
        color={0,0,127}));
  connect(heaCooAndOn.y, ctl.uEna) annotation (Line(points={{-98,60},{-80,60},{
          -80,-20},{-64,-20},{-64,-12}},
                                     color={255,0,255}));
  connect(chiFloRes.y, min.u)
    annotation (Line(points={{62,80},{88,80}}, color={0,0,127}));
  connect(yFlo[:, 2].y, chiFloRes.f2) annotation (Line(points={{22,60},{34,60},{
          34,72},{38,72}},
                        color={0,0,127}));
  connect(yFlo[:, 1].y, chiFloRes.f1) annotation (Line(points={{22,60},{34,60},{
          34,84},{38,84}},
                        color={0,0,127}));
  connect(ctl.y, chiFloRes.u) annotation (Line(points={{-48,0},{-20,0},{-20,80},
          {38,80}},     color={0,0,127}));
  connect(xFlo[:, 1].y, chiFloRes.x1) annotation (Line(points={{22,100},{32,100},
          {32,88},{38,88}}, color={0,0,127}));
  connect(xFlo[:, 2].y, chiFloRes.x2) annotation (Line(points={{22,100},{32,100},
          {32,76},{38,76}}, color={0,0,127}));
  connect(min.y, mEvaChiSet_flow) annotation (Line(points={{112,80},{160,80}},
                         color={0,0,127}));
  connect(chiHeaFloRes.y, min1.u)
    annotation (Line(points={{62,0},{88,0}}, color={0,0,127}));
  connect(yFlo1[:, 2].y, chiHeaFloRes.f2) annotation (Line(points={{22,-20},{34,
          -20},{34,-8},{38,-8}},
                            color={0,0,127}));
  connect(yFlo1[:, 1].y, chiHeaFloRes.f1) annotation (Line(points={{22,-20},{34,
          -20},{34,4},{38,4}},
                          color={0,0,127}));
  connect(ctl.y, chiHeaFloRes.u)
    annotation (Line(points={{-48,0},{38,0}}, color={0,0,127}));
  connect(xFlo1[:, 1].y, chiHeaFloRes.x1)
    annotation (Line(points={{22,20},{32,20},{32,8},{38,8}},color={0,0,127}));
  connect(xFlo1[:, 2].y, chiHeaFloRes.x2) annotation (Line(points={{22,20},{32,20},
          {32,-4},{38,-4}}, color={0,0,127}));
  connect(min1.y, mEvaChiHeaSet_flow) annotation (Line(points={{112,0},{160,0}},
                       color={0,0,127}));
  connect(ctl.y, chiHeaConTemRes.u) annotation (Line(points={{-48,0},{-20,0},{-20,
          -80},{38,-80}}, color={0,0,127}));
  connect(xFlo2[:, 1].y, chiHeaConTemRes.x1) annotation (Line(points={{22,-60},{
          32,-60},{32,-72},{38,-72}},
                                   color={0,0,127}));
  connect(xFlo2[:, 2].y, chiHeaConTemRes.x2) annotation (Line(points={{22,-60},{
          32,-60},{32,-84},{38,-84}},
                                   color={0,0,127}));
  connect(addOff.y, rep1.u)
    annotation (Line(points={{-68,-80},{-62,-80}}, color={0,0,127}));
  connect(addOff1.y, rep2.u)
    annotation (Line(points={{-68,-120},{-62,-120}}, color={0,0,127}));
  connect(rep2.y, chiHeaConTemRes.f2) annotation (Line(points={{-38,-120},{0,
          -120},{0,-88},{38,-88}},
                             color={0,0,127}));
  connect(rep1.y, chiHeaConTemRes.f1) annotation (Line(points={{-38,-80},{-30,
          -80},{-30,-76},{38,-76}},
                               color={0,0,127}));
  connect(extIndRea.y, TConEntChiHeaSet)
    annotation (Line(points={{112,-80},{160,-80}}, color={0,0,127}));
  connect(chiHeaConTemRes.y, extIndRea.u)
    annotation (Line(points={{62,-80},{88,-80}}, color={0,0,127}));
  connect(idxHig.y, extIndRea.index) annotation (Line(points={{81,-120},{100,-120},
          {100,-92}}, color={255,127,0}));
  connect(addOff.u, mea.y)
    annotation (Line(points={{-92,-80},{-108,-80}}, color={0,0,127}));
  connect(THeaWatPriRet, mea.u) annotation (Line(points={{-160,-80},{-144,-80},{
          -144,-80},{-132,-80}}, color={0,0,127}));
  connect(mea.y, addOff1.u) annotation (Line(points={{-108,-80},{-100,-80},{
          -100,-120},{-92,-120}},
                             color={0,0,127}));
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
