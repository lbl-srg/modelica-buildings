within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPIDSequence "PID controllers with hysteresis in sequence"
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_enaSig = false
    "Set to true for conditionnally enabled controller"
    annotation(Evaluate=true);
  parameter Integer nCon = 1
    "Number of controllers in sequence"
    annotation(Evaluate=true);
  parameter Real yThr = yMin
    "Threshold value of controller (i) output for enabling (i+1)";
  parameter Real hys
    "Hysteresis of each controller (full width, absolute value)";
  parameter Real dea
    "Dead band between each controller (absolute value)";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller (P or PI)"
    annotation(choices(
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real yMax = 1
    "Upper limit of output";
  parameter Real yMin = 0
    "Lower limit of output";
  parameter Real k[nCon](each min=0) = fill(1, nCon)
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti[nCon](
    each min=Buildings.Controls.OBC.CDL.Constants.small) = fill(0.5, nCon)
    "Time constant of integrator block"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Boolean reverseActing = false
    "Set to true for control output increasing with decreasing measurement value";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna if have_enaSig
    "Enable signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-160}),  iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-160}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(extent={{20,-20},{-20,20}},
        rotation=270, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nCon]
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nCon)
    "Replicate measurement signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Sources.RealExpression setOff[nCon](
    final y=uSet)
    "Set-point with offset"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nCon-1) if have_enaSig and nCon > 1 "Replicate enable signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,-100})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig(
    final nin=nCon,
    final nout=nCon - 1,
    final extract=1:nCon - 1) if   have_enaSig and nCon > 1
    "Extract outputs from the first (nCon - 1) controller"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[nCon - 1](
    each final threshold=yThr) if have_enaSig and nCon > 1
    "Compare (i-1) controller output with threshold"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nCon - 1] if have_enaSig and nCon > 1
    "True if enable signal is true and (i-1) controller output >= yThr"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-120,-60})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID[nCon](
    final k=k,
    final Ti=Ti,
    each final Td=0.1,
    each final controllerType=controllerType,
    each final reverseActing=reverseActing,
    each final yMin=yMin,
    each final yMax=yMax)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nCon]
    "Switch to measurement instead of set point if disabled" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,0})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nCon]
    "Switch to off if disabled"
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));
  HeatTransfer.Radiosity.Constant zer[nCon](
    each final k=0)
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nCon](
    each final k=true) if not have_enaSig
    "Always true (for the case where no enable signal is used)"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-92,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback feedback[nCon]
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nCon](
    each final uLow=-hys/2,
    each final uHigh=hys)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant revAct(
    final k=reverseActing)
    "Output true in case of reverse acting"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=1,
    final realFalse=-1) "Output 1 if reverse acting, else -1"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(
    final nout=nCon)
    "Replicate measurement signal"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,90})));
  Buildings.Controls.OBC.CDL.Continuous.Product proRev[nCon]
    "Opposite if reverse acting"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Routing.BooleanPassThrough pasThr[nCon] if have_enaSig
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-40})));
  Buildings.Controls.OBC.CDL.Logical.And andHys[nCon]
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
protected
  final parameter Real sig = if reverseActing then -1 else 1
    "Sign of set-point offset";
  Real uSet[nCon] =  u_s .+ sig * dea .* {i for i in 1:nCon}
    "Set-point values";
equation
  connect(u_m, reaRep.u)
    annotation (Line(points={{0,-160},{0,-132},{-8.88178e-16,-132}},
                                                color={0,0,127}));
  connect(uEna, booRep.u) annotation (Line(points={{-40,-160},{-40,-120},{-120,-120},
          {-120,-112}},
                      color={255,0,255}));
  connect(extSig.y, greEquThr.u)
    annotation (Line(points={{82,40},{88,40}}, color={0,0,127}));
  connect(booRep.y, and2.u1)
    annotation (Line(points={{-120,-88},{-120,-72}},
                                                   color={255,0,255}));
  connect(greEquThr.y, and2.u2) annotation (Line(points={{112,40},{120,40},{120,
          -80},{-112,-80},{-112,-72}},
                                color={255,0,255}));
  connect(conPID.y, extSig.u)
    annotation (Line(points={{32,0},{40,0},{40,40},{58,40}}, color={0,0,127}));
  connect(conPID.y, swi2.u1)
    annotation (Line(points={{32,0},{40,0},{40,8},{90,8}}, color={0,0,127}));
  connect(swi2.y, y)
    annotation (Line(points={{114,0},{138,0},{138,0},{160,0}},
                                              color={0,0,127}));
  connect(swi1.y, conPID.u_s)
    annotation (Line(points={{2,0},{8,0}},     color={0,0,127}));
  connect(reaRep.y, conPID.u_m)
    annotation (Line(points={{6.66134e-16,-108},{6.66134e-16,-20},{20,-20},{20,
          -12}},                               color={0,0,127}));
  connect(reaRep.y, swi1.u3) annotation (Line(points={{6.66134e-16,-108},{
          6.66134e-16,-20},{-40,-20},{-40,-8},{-22,-8}},
                              color={0,0,127}));
  connect(setOff.y, swi1.u1) annotation (Line(points={{-109,0},{-40,0},{-40,8},
          {-22,8}}, color={0,0,127}));
  connect(zer.JOut, swi2.u3) annotation (Line(points={{51,-60},{60,-60},{60,-8},
          {90,-8}}, color={0,127,0}));
  connect(reaRep.y, feedback.u2) annotation (Line(points={{0,-108},{0,-20},{-80,
          -20},{-80,48}},  color={0,0,127}));
  connect(setOff.y, feedback.u1) annotation (Line(points={{-109,0},{-100,0},{
          -100,60},{-92,60}},
                         color={0,0,127}));
  connect(revAct.y, booToRea1.u)
    annotation (Line(points={{-108,120},{-102,120}}, color={255,0,255}));
  connect(booToRea1.y, reaRep1.u)
    annotation (Line(points={{-78,120},{-60,120},{-60,102}}, color={0,0,127}));
  connect(reaRep1.y,proRev. u1)
    annotation (Line(points={{-60,78},{-60,66},{-42,66}}, color={0,0,127}));
  connect(feedback.y,proRev. u2) annotation (Line(points={{-68,60},{-50,60},{
          -50,54},{-42,54}},
                         color={0,0,127}));
  connect(proRev.y, hys1.u)
    annotation (Line(points={{-18,60},{-12,60}},color={0,0,127}));
  connect(uEna, pasThr[1].u) annotation (Line(points={{-40,-160},{-40,-60},{
          -106,-60},{-106,-40},{-102,-40}},
                                       color={255,0,255}));
  connect(and2[1:nCon-1].y, pasThr[2:nCon].u) annotation (Line(points={{-120,-48},
          {-120,-40},{-102,-40}},
                 color={255,0,255}));
  connect(hys1.y, andHys.u2) annotation (Line(points={{12,60},{20,60},{20,40},{
          -60,40},{-60,-48},{-54,-48}},  color={255,0,255}));
  connect(pasThr.y, andHys.u1)
    annotation (Line(points={{-79,-40},{-54,-40}}, color={255,0,255}));
  connect(tru.y, andHys.u1) annotation (Line(points={{-80,-100},{-68,-100},{-68,
          -40},{-54,-40}},     color={255,0,255}));
  connect(andHys.y, swi1.u2) annotation (Line(points={{-30,-40},{-28,-40},{-28,
          0},{-22,0}},
                    color={255,0,255}));
  connect(andHys.y, swi2.u2) annotation (Line(points={{-30,-40},{80,-40},{80,0},
          {90,0}}, color={255,0,255}));
  annotation (defaultComponentName="conPlaSeq",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This controller is composed of a set of instances of 
<a href=\\\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay\\\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay</a>
connected in sequence and separated with a dead band.
More precisely, the set point input signal of each controller is given by
</p>
<ul>
<li>
<code>u_s[1] = u_s + dea + hys / 2</code> 
</li>
<li>
For <code>i > 1</code>, <code>u_s[i] = u_s[i-1] + dea + hys</code>
</li>
</ul>
<p>
Optionally, a boolean input signal can be used as an enable signal.
</p>
<ul>
<li>
When the enable signal is false, each controller output is zero. 
</li>
<li>
When the enable signal is true, the first controller is enabled.
The controller <code>i</code> (with <code>i > 1</code>) is enabled if 
the output of the controller <code>i-1</code> exceeds 
the threshold value <code>yThr</code>.
This allows enforcing a control in sequence of several systems,
independently from the other control parameters (such as the dead band, 
the gain or the integral time constant).
To disable this feature, simply set <code>yThr</code> equal to 
<code>yMin</code> (the default).
</li>
</ul>
<p>
<img alt=\"Sequence chart\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/Combined/Generation5/Controls/LimPlaySequence.png\"/>
</p>
<p>
See
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlaySequence\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlaySequence</a>
for an illustration of the control response.
</p>
</html>"));
end LimPIDSequence;
