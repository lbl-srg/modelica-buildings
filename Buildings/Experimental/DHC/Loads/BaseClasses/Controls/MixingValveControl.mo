within Buildings.Experimental.DHC.Loads.BaseClasses.Controls;
block MixingValveControl
  "Mixing valve controller"
  extends Modelica.Blocks.Icons.Block;
  import Type_dis=Buildings.Experimental.DHC.Loads.BaseClasses.Types.DistributionType
    "Types of distribution system";
  parameter Type_dis typDis=Type_dis.HeatingWater
    "Type of distribution system"
    annotation (Evaluate=true);
  parameter Real k(
    final min=0,
    final unit="1")=0.1
    "Gain of controller";
  parameter Modelica.Units.SI.Time Ti(final min=Modelica.Constants.small) = 10
    "Time constant of integrator block";
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-120,-40}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,40})));
  Modelica.Blocks.Interfaces.IntegerInput modChaOve if typDis == Type_dis.ChangeOver
    "Operating mode in change-over (1 for heating, 2 for cooling)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-120,80}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,80})));
  Modelica.Blocks.Interfaces.RealInput TSupMes(
    final unit="K",
    displayUnit="degC")
    "Supply temperature (measured)"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-120,-80}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,-40})));
  Modelica.Blocks.Interfaces.RealOutput yVal(
    final unit="1")
    "Valve control signal"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={120,0}),iconTransformation(extent={{-10,-10},{10,10}},rotation=0,origin={110,0})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Blocks.Math.IntegerToBoolean toBoo(
    threshold=2) if typDis == Type_dis.ChangeOver
    "Conversion to boolean (true if cooling mode)"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset resConTSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=-1,
    final reverseActing=true,
    final y_reset=0) if typDis == Type_dis.ChangeOver
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conTSup(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=-1,
    final reverseActing=true) if typDis <> Type_dis.ChangeOver
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min negPar
    "Negative part of control signal"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Max posPar
    "Positive part of control signal"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter opp(k=-1)
    "Opposite value"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.BooleanExpression fixMod(
    final y=typDis == Type_dis.ChilledWater) if typDis <> Type_dis.ChangeOver
    "Fixed operating mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha if typDis == Type_dis.ChangeOver
    "Evaluate the integer input u to check if its value changes"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
equation
  connect(modChaOve,toBoo.u)
    annotation (Line(points={{-120,80},{-90,80},{-90,40},{-12,40}},color={255,127,0}));
  connect(toBoo.y,swi.u2)
    annotation (Line(points={{11,40},{30,40},{30,0},{68,0}},color={255,0,255}));
  connect(fixMod.y,swi.u2)
    annotation (Line(points={{11,0},{68,0}},color={255,0,255}));
  connect(resConTSup.y,posPar.u2)
    annotation (Line(points={{-48,-60},{-20,-60},{-20,-86},{-12,-86}},color={0,0,127}));
  connect(zer.y,posPar.u1)
    annotation (Line(points={{-48,20},{-40,20},{-40,-74},{-12,-74}},color={0,0,127}));
  connect(zer.y,negPar.u1)
    annotation (Line(points={{-48,20},{-40,20},{-40,-34},{-12,-34}},color={0,0,127}));
  connect(resConTSup.y,negPar.u2)
    annotation (Line(points={{-48,-60},{-20,-60},{-20,-46},{-12,-46}},color={0,0,127}));
  connect(negPar.y,opp.u)
    annotation (Line(points={{12,-40},{18,-40}},color={0,0,127}));
  connect(resConTSup.u_s,TSupSet)
    annotation (Line(points={{-72,-60},{-90,-60},{-90,-40},{-120,-40}},color={0,0,127}));
  connect(TSupMes,resConTSup.u_m)
    annotation (Line(points={{-120,-80},{-60,-80},{-60,-72}},color={0,0,127}));
  connect(swi.y,yVal)
    annotation (Line(points={{92,0},{120,0}},color={0,0,127}));
  connect(modChaOve,cha.u)
    annotation (Line(points={{-120,80},{-82,80}},color={255,127,0}));
  connect(cha.y,resConTSup.trigger)
    annotation (Line(points={{-58,80},{-40,80},{-40,60},{-80,60},{-80,-76},{-66,-76},{-66,-72}},color={255,0,255}));
  connect(opp.y,swi.u1)
    annotation (Line(points={{42,-40},{50,-40},{50,8},{68,8}},color={0,0,127}));
  connect(posPar.y,swi.u3)
    annotation (Line(points={{12,-80},{60,-80},{60,-8},{68,-8}},color={0,0,127}));
  connect(TSupSet,conTSup.u_s)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-20},{-72,-20}},color={0,0,127}));
  connect(TSupMes,conTSup.u_m)
    annotation (Line(points={{-120,-80},{-84,-80},{-84,-40},{-60,-40},{-60,-32}},color={0,0,127}));
  connect(conTSup.y,negPar.u2)
    annotation (Line(points={{-48,-20},{-20,-20},{-20,-46},{-12,-46}},color={0,0,127}));
  connect(conTSup.y,posPar.u2)
    annotation (Line(points={{-48,-20},{-20,-20},{-20,-86},{-12,-86}},color={0,0,127}));
  annotation (
    defaultComponentName="conVal",
    Documentation(
      info="
<html>
<p>
This model implements a generic controller for a three-way mixing valve.
Three operating modes are supported:
</p>
<ul>
<li>
Heating: the controller tracks a minimum supply temperature.
</li>
<li>
Cooling: the controller tracks a maximum supply temperature.
</li>
<li>
Change-over: the controller tracks either a minimum or a maximum
supplied temperature depending on the actual value of the integer input
<code>modChaOve</code> (1 for heating, 2 for cooling).
The model instantiates only one PI block to limit the number of state
variables in large models. Therefore the PI gain
is independent from the change-over mode: the reverse action is modeled
by taking the opposite value of the PI block output. Eventually the
integral part is reset whenever the change-over mode is switched.
</li>
</ul>
<p>
See
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Controls.Validation.MixingValveControl\">
Buildings.Experimental.DHC.Loads.BaseClasses.Controls.Validation.MixingValveControl</a>
for a simulation with change-over.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Text(
          extent={{-90,96},{-10,66}},
          textColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          visible=typDis == Type_dis.ChangeOver,
          textString="modChaOve"),
        Text(
          extent={{-90,54},{-22,26}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TSupSet"),
        Text(
          extent={{-90,-26},{-16,-52}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TSupMes"),
        Text(
          extent={{50,12},{88,-14}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="yVal")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end MixingValveControl;
