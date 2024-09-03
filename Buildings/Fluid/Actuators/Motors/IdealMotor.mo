within Buildings.Fluid.Actuators.Motors;
model IdealMotor "Ideal motor model with hysteresis"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real delta(min=0, max=0.5) = 0.05 "Hysteresis";
  parameter Modelica.Units.SI.Time tOpe(min=0) = 120 "Opening time";
  parameter Modelica.Units.SI.Time tClo(min=0) = tOpe "Closing time";
  parameter Real y_start(min=0, max=1) = 0.5 "Start position";

  Modelica.Blocks.Logical.Hysteresis uppHys(final uLow=0, uHigh=delta,
    final pre_y_start=false)
                       annotation (Placement(transformation(extent={{-60,20},{
            -40,40}})));
  Modelica.Blocks.Logical.Hysteresis lowHys(uLow=-delta, final uHigh=0,
    final pre_y_start=true) "Lower hysteresis"
                                         annotation (Placement(transformation(
          extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Logical.Switch uppSwi annotation (Placement(transformation(
          extent={{0,20},{20,40}})));
  Modelica.Blocks.Continuous.LimIntegrator int(
    final y_start=y_start,
    final k=1,
    outMax=1,
    outMin=0,
    initType=Modelica.Blocks.Types.Init.InitialState,
    limitsAtInit=true,
    y(stateSelect=StateSelect.always)) "Integrator for valve opening position"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

protected
  final Modelica.Blocks.Sources.Constant zer(final k=0) "Zero signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.Constant vOpe(final k=1/tOpe) "Opening speed"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.Constant vClo(final k=-1/tClo) "Closing speed"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Logical.Switch lowSwi annotation (Placement(transformation(
          extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{32,
            -10},{52,10}})));
  Modelica.Blocks.Math.Feedback feeBac "Feedback to compute position error"
                                         annotation (Placement(transformation(
          extent={{-90,-10},{-70,10}})));
equation
  connect(zer.y, uppSwi.u3) annotation (Line(points={{-19,6.10623e-016},{-14,
          6.10623e-016},{-14,22},{-2,22}}, color={0,0,127}));
  connect(uppHys.y, uppSwi.u2)
    annotation (Line(points={{-39,30},{-2,30}}, color={255,0,255}));
  connect(vOpe.y, uppSwi.u1) annotation (Line(points={{-19,70},{-16,70},{-16,38},
          {-2,38}}, color={0,0,127}));
  connect(lowHys.y, lowSwi.u2) annotation (Line(points={{-39,-30},{-2,-30}},
        color={255,0,255}));
  connect(vClo.y, lowSwi.u3) annotation (Line(points={{-19,-70},{-14,-70},{-14,
          -38},{-2,-38}}, color={0,0,127}));
  connect(zer.y, lowSwi.u1) annotation (Line(points={{-19,6.10623e-016},{-14,
          6.10623e-016},{-14,-22},{-2,-22}}, color={0,0,127}));
  connect(add.y, int.u) annotation (Line(points={{53,6.10623e-016},{60,
          6.10623e-016},{60,6.66134e-016},{58,6.66134e-016}}, color={0,0,127}));
  connect(uppSwi.y, add.u1) annotation (Line(points={{21,30},{24,30},{24,6},{30,
          6}}, color={0,0,127}));
  connect(u, feeBac.u1)   annotation (Line(points={{-120,1.11022e-015},{-104,
          1.11022e-015},{-104,6.66134e-016},{-88,6.66134e-016}}, color={0,0,127}));
  connect(feeBac.y, uppHys.u)   annotation (Line(points={{-71,6.10623e-016},{
          -66,6.10623e-016},{-66,30},{-62,30}}, color={0,0,127}));
  connect(feeBac.y, lowHys.u)   annotation (Line(points={{-71,6.10623e-016},{
          -66,6.10623e-016},{-66,-30},{-62,-30}}, color={0,0,127}));
  connect(lowSwi.y, add.u2) annotation (Line(points={{21,-30},{24,-30},{24,-6},
          {30,-6}}, color={0,0,127}));
  connect(int.y, y) annotation (Line(points={{81,6.10623e-016},{93.5,
          6.10623e-016},{93.5,5.55112e-016},{110,5.55112e-016}}, color={0,0,127}));
  connect(int.y, feeBac.u2) annotation (Line(points={{81,6.10623e-016},{94,
          6.10623e-016},{94,-88},{-80,-88},{-80,-8}}, color={0,0,127}));
   annotation (
defaultComponentName="mot",
Documentation(info="<html>
<p>
Ideal actuator motor model with hysteresis and finite actuation speed.
If the current actuator position <code>y</code> is below (or above) the
input signal <code>u</code> by an amount bigger than the hysteresis
<code>delta</code>, then the position <code>y</code> is increased (decreased)
until it reaches <code>u</code>.
The output <code>y</code> is bounded between <code>0</code> and <code>1</code>.
</p>
<p>
<b>Note:</b> This model can introduce state events which increase the computation time.
For a more efficient implementation that approximates a motor, set in
the valve or damper model the parameter <code>use_inputFilter=true</code>
instead of using this motor model.
See also
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
September 8, 2008 by Michael Wetter:<br/>
Added to instance <code>int</code> the attribute
<code>y(stateSelect=StateSelect.always)</code>. Without this attribute,
the model <a href=\"modelica://Buildings.Fluid.Examples.TwoWayValves\">
Buildings.Fluid.Examples.TwoWayValves</a> sets <code>y=3</code>
which is consistent with this model.
</li>
<li>
September 8, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Line(points={{-8,-86},{-8,68}}, color={192,192,192}),
        Polygon(
          points={{-7,85},{-15,63},{1,63},{-7,85}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-18},{82,-18}}, color={192,192,192}),
        Polygon(
          points={{84,-18},{62,-10},{62,-26},{84,-18}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{66,-26},{94,-48}},
          textColor={160,160,164},
          textString="u-y"),
        Text(
          extent={{-3,83},{50,65}},
          textColor={160,160,164},
          textString="v"),
        Line(
          points={{-80,-74},{-8,-74}},
          thickness=0.5),
        Line(
          points={{-8,22},{80,22}},
          thickness=0.5),
        Line(
          points={{-50,-18},{-50,-74}},
          thickness=0.5),
        Line(
          points={{30,22},{30,-18}},
          thickness=0.5),
        Line(
          points={{-32,-69},{-22,-74},{-32,-79}},
          thickness=0.5),
        Line(
          points={{16,27},{6,22},{16,17}},
          thickness=0.5),
        Line(
          points={{-55,-46},{-50,-56},{-44,-46}},
          thickness=0.5),
        Line(
          points={{25,-4},{30,7},{35,-4}},
          thickness=0.5),
        Text(
          extent={{19,-35},{44,-18}},
          textColor={0,0,0},
          textString="+delta"),
        Text(
          extent={{-63,-18},{-40,-2}},
          textColor={0,0,0},
          textString="-delta"),
        Line(
          points={{-8,22},{-8,-74}},
          thickness=0.5),
        Line(
          points={{-50,-18},{30,-18}},
          thickness=0.5),
        Text(
          extent={{-37,12},{-10,32}},
          textColor={0,0,0},
          textString="vOpen"),
        Text(
          extent={{-4,-86},{30,-64}},
          textColor={0,0,0},
          textString="vClose"),
        Line(
          points={{-20,-13},{-30,-18},{-20,-23}},
          thickness=0.5),
        Line(
          points={{6,-13},{16,-18},{6,-23}},
          thickness=0.5)}));
end IdealMotor;
