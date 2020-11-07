within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPlaySequence "Play hysteresis controllers in sequence"
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
  parameter Real k(min=0) = 1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small) = 0.5
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
        origin={-40,-120}),  iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20}, {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-120}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(extent={{20,-20},{-20,20}},
        rotation=270, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y[nCon]
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140, 20}})));

  LimPlay conPla[nCon](
    each final controllerType=controllerType,
    each final yMax=yMax,
    each final yMin=yMin,
    each final have_enaSig=have_enaSig,
    each final k=k,
    each final Ti=Ti,
    each final hys=hys,
    each final reverseActing=reverseActing)
    "Play hysteresis controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nCon)
    "Replicate measurement signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-70})));
  Modelica.Blocks.Sources.RealExpression setOff[nCon](
    final y=uSet)
    "Set point with offset"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=nCon-1) if have_enaSig and nCon > 1 "Replicate enable signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-70})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractSignal extSig(
    final nin=nCon,
    final nout=nCon - 1,
    final extract=1:nCon - 1) if   have_enaSig and nCon > 1
    "Extract outputs from the first (nCon - 1) controller"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr[nCon - 1](
    each final t=yThr,
    each final h=yThr*0.1) if have_enaSig and nCon > 1
    "Compare (i-1) controller output with threshold"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nCon - 1] if have_enaSig and nCon > 1
    "True if enable signal is true and (i-1) controller output >= yThr"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-80,-40})));
protected
  final parameter Real sig = if reverseActing then -1 else 1
    "Sign of set point offset";
  Real uSet[nCon] =  cat(1,
    {u_s + sig * (dea + hys/2)},
    {u_s + sig * i * (dea + hys) - sig * hys/2 for i in 2:nCon})
    "Set point values";
equation
  connect(reaRep.y, conPla.u_m)
    annotation (Line(points={{8.88178e-16,-58},{8.88178e-16,-34},{0,-34},{0,-12}},
                                               color={0,0,127}));
  connect(setOff.y, conPla.u_s)
    annotation (Line(points={{-69,0},{-12,0}}, color={0,0,127}));
  connect(u_m, reaRep.u)
    annotation (Line(points={{0,-120},{0,-82},{-6.66134e-16,-82}},
                                                color={0,0,127}));
  connect(conPla.y, y)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(uEna, booRep.u) annotation (Line(points={{-40,-120},{-40,-90},{-80,-90},
          {-80,-82}}, color={255,0,255}));
  connect(uEna, conPla[1].uEna) annotation (Line(points={{-40,-120},{-40,-20},{-6,
          -20},{-6,-12}}, color={255,0,255}));
  connect(extSig.y, greEquThr.u)
    annotation (Line(points={{52,40},{58,40}}, color={0,0,127}));
  connect(conPla.y, extSig.u)
    annotation (Line(points={{12,0},{20,0},{20,40},{28,40}}, color={0,0,127}));
  connect(booRep.y, and2.u1)
    annotation (Line(points={{-80,-58},{-80,-52}}, color={255,0,255}));
  connect(greEquThr.y, and2.u2) annotation (Line(points={{82,40},{90,40},{90,60},
          {-60,60},{-60,-54},{-72,-54},{-72,-52}},
                                color={255,0,255}));
  connect(and2[1:nCon-1].y, conPla[2:nCon].uEna)
    annotation (Line(points={{-80,-28},{-80,-20},{-6,-20},{-6,-12}},
                              color={255,0,255}));
  annotation (defaultComponentName="conPlaSeq",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)),
Documentation(
revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This controller is composed of a set of instances of
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.LimPlay</a>
connected in sequence and separated with a dead band.
More precisely, the set point input signal of each controller is given by
</p>
<ul>
<li>
<code>u_s[1] = u_s+dea+hys/2</code>
</li>
<li>
For <code>i>1</code>, <code>u_s[i] = u_s[i-1]+dea+hys</code>
</li>
</ul>
<p>
Optionally, a Boolean input signal can be used as an enable signal.
</p>
<ul>
<li>
When the enable signal is <code>false</code>, each controller output is zero.
</li>
<li>
When the enable signal is <code>true</code>, the first controller is enabled.
The controller <code>i</code> (with <code>i>1</code>) is enabled if
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
end LimPlaySequence;
