within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block SupplySignals
  "Multizone VAV AHU supply air temperature control loop and coil valves position"

  parameter Boolean have_heaCoi=true
    "True: the AHU has heating coil. It could be the hot water coil, or the electric heating coil";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for supply air temperature signal";
  parameter Real kTSup(final unit="1/K")=0.05
    "Gain of controller for supply air temperature signal";
  parameter Real TiTSup(
    final unit="s",
    final quantity="Time")=600
    "Time constant of integrator block for supply temperature control signal"
    annotation(Dialog(
      enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdTSup(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for supply temperature control signal"
    annotation(Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                          or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uHea_max(
    final min=-0.9,
    final unit="1")=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHea_max < uCoo_min < 1.";
  parameter Real uCoo_min(
    final max=0.9,
    final unit="1")=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHea_max < uCoo_min < 1.";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature" annotation (Placement(transformation(
          extent={{-140,-40},{-100,0}}), iconTransformation(extent={{-140,-80},{
            -100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSupSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint" annotation (Placement(transformation(
          extent={{-140,10},{-100,50}}), iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan status"           annotation (Placement(transformation(extent={{
            -140,60},{-100,100}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heaCoi "Heating coil commanded position"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1") "Cooling coil commanded position" annotation (Placement(
        transformation(extent={{100,-40},{140,0}}), iconTransformation(extent={{
            100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uTSup(
    final max=1,
    final unit="1",
    final min=-1)
    "Supply temperature control signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conTSup(
    final controllerType=controllerType,
    final k=kTSup,
    final Ti=TiTSup,
    final Td=TdTSup,
    final yMax=1,
    final yMin=-1,
    final reverseActing=false,
    final y_reset=0)
    "Controller for supply air temperature control signal (to be used by heating coil, cooling coil and economizer)"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch to select supply temperature control signal based on status of supply fan"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uHeaMaxCon(
    final k=uHea_max) if have_heaCoi
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant negOne(final k=-1)
    if have_heaCoi
    "Negative unity signal"
    annotation (Placement(transformation(extent={{0,18},{20,38}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCooMinCon(
    final k=uCoo_min)
    "Constant signal to map control action"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Zero control signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Unity signal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigCoo(
    final limitBelow=true,
    final limitAbove=false)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Line conSigHea(
    final limitBelow=false,
    final limitAbove=true) if have_heaCoi
    "Heating control signal"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

equation
  connect(zer.y,swi. u3)
    annotation (Line(points={{-38,-40},{-20,-40},{-20,52},{-2,52}},
      color={0,0,127}));
  connect(TAirSup, conTSup.u_m)
    annotation (Line(points={{-120,-20},{-50,-20},{-50,18}}, color={0,0,127}));
  connect(negOne.y,conSigHea. x1)
    annotation (Line(points={{22,28},{58,28}},
      color={0,0,127}));
  connect(one.y,conSigHea. f1)
    annotation (Line(points={{22,-80},{50,-80},{50,24},{58,24}},
      color={0,0,127}));
  connect(swi.y,conSigHea. u)
    annotation (Line(points={{22,60},{46,60},{46,20},{58,20}},
      color={0,0,127}));
  connect(swi.y,conSigCoo. u)
    annotation (Line(points={{22,60},{46,60},{46,-20},{58,-20}},
      color={0,0,127}));
  connect(uHeaMaxCon.y,conSigHea. x2)
    annotation (Line(points={{22,-10},{30,-10},{30,16},{58,16}},
      color={0,0,127}));
  connect(zer.y,conSigHea. f2)
    annotation (Line(points={{-38,-40},{-20,-40},{-20,-30},{36,-30},{36,12},
      {58,12}}, color={0,0,127}));
  connect(uCooMinCon.y,conSigCoo. x1)
    annotation (Line(points={{22,-50},{40,-50},{40,-12},{58,-12}},
      color={0,0,127}));
  connect(zer.y,conSigCoo. f1)
    annotation (Line(points={{-38,-40},{-20,-40},{-20,-30},{36,-30},{36,-16},
      {58,-16}}, color={0,0,127}));
  connect(one.y,conSigCoo. x2)
    annotation (Line(points={{22,-80},{50,-80},{50,-24},{58,-24}},
      color={0,0,127}));
  connect(one.y,conSigCoo. f2)
    annotation (Line(points={{22,-80},{50,-80},{50,-28},{58,-28}},
      color={0,0,127}));
  connect(conSigHea.y, yHeaCoi)
    annotation (Line(points={{82,20},{120,20}}, color={0,0,127}));
  connect(conSigCoo.y, yCooCoi)
    annotation (Line(points={{82,-20},{120,-20}}, color={0,0,127}));
  connect(swi.y,uTSup)
    annotation (Line(points={{22,60},{120,60}},  color={0,0,127}));
  connect(TAirSupSet, conTSup.u_s)
    annotation (Line(points={{-120,30},{-62,30}}, color={0,0,127}));
  connect(u1SupFan, swi.u2) annotation (Line(points={{-120,80},{-80,80},{-80,60},
          {-2,60}}, color={255,0,255}));
  connect(conTSup.y, swi.u1)
    annotation (Line(points={{-38,30},{-28,30},{-28,68},{-2,68}},
      color={0,0,127}));
  connect(u1SupFan, conTSup.trigger) annotation (Line(points={{-120,80},{-80,80},
          {-80,0},{-56,0},{-56,18}}, color={255,0,255}));

annotation (
  defaultComponentName = "supSig",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,8},{-50,-8}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSupSet"),
        Text(
          extent={{-98,-52},{-62,-68}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TAirSup"),
        Text(
          extent={{62,8},{100,-4}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          visible=have_heaCoi,
          textString="yHeaCoi"),
        Text(
          extent={{74,66},{96,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uTSup"),
        Text(
          extent={{62,-50},{96,-64}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCooCoi"),
        Text(
          extent={{-96,66},{-56,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="u1SupFan"),
        Text(
          extent={{-124,146},{96,108}},
          textColor={0,0,255},
          textString="%name")}),Documentation(info="<html>
<p>
Block that outputs the supply temperature control loop signal,
and the coil valve postions for VAV system with multiple zones,
implemented according to Section 5.16.2.3 of the ASHRAE Guideline G36, May 2020.
</p>
<p>
The supply air temperature control loop signal <code>uTSup</code>
is computed using a PI controller that tracks the supply air temperature
setpoint <code>TSupSet</code>.
If the fan is off, then <code>uTSup = 0</code>.
</p>
<p>
Heating valve control signal (or modulating electric heating
coil if applicable) <code>yHeaCoi</code> and cooling valve control signal <code>yCooCoi</code>
are sequenced based on the supply air temperature control loop signal <code>uTSup</code>.
From <code>uTSup = uHea_max</code> to <code>uTSup = -1</code>,
<code>yHeaCoi</code> increases linearly from <i>0</i> to <i>1</i>.
Similarly, <code>uTSup = uCoo_min</code> to <code>uTSup = +1</code>,
<code>yCooCoi</code> increases linearly from <i>0</i> to <i>1</i>.
</p>

<p align=\"center\">
<img alt=\"Image of supply temperature loop\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/SupTemLoop.png\"/>
</p>

<p>
The output <code>uTSup</code> can be used in a controller for the economizer.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
Updated according to ASHRAE G36 official release.
</li>
<li>
November 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplySignals;
