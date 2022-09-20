within Buildings.Fluid.Storage.Plant.Controls;
block Interlock
  "Control block that imposes an interlock on two control input signals"
  extends Modelica.Blocks.Icons.Block;

  parameter Real t1=0.01
    "Threshold that the valve is considered closed or the pump is considered off";
  parameter Real t2=0.01
    "Threshold that the valve is considered closed or the pump is considered off";

  Modelica.Blocks.Sources.Constant zero(final k=0) "Constant 0"
    annotation (Placement(transformation(extent={{20,-10},{40,10}},
        rotation=0)));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isOff1(final t=t1)
                       "= true if valve closed or pump off" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "True: let signal pass through; false: outputs zero" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1_in "Control input signal"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput y1(final unit="1")
    "Control output signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1_actual
    "Actuator position" annotation (Placement(transformation(extent={{-140,
            30},{-100,70}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2_in "Control input signal"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold isOff2(final t=t2)
                      "= true if valve closed or pump off" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-70})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "True: let signal pass through; false: outputs zero" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2_actual
    "Actuator position" annotation (Placement(transformation(extent={{-140,
            -90},{-100,-50}}), iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y2(final unit="1")
    "Control output signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-70}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40})));
equation
  connect(zero.y, swi2.u3) annotation (Line(points={{41,0},{50,0},{50,-78},{58,-78}},
        color={0,0,127}));
  connect(zero.y, swi1.u3)
    annotation (Line(points={{41,0},{50,0},{50,42},{58,42}}, color={0,0,127}));
  connect(swi1.y, y1) annotation (Line(points={{82,50},{96,50},{96,50},{120,50}},
        color={0,0,127}));
  connect(u1_actual, isOff1.u)
    annotation (Line(points={{-120,50},{-82,50}}, color={0,0,127}));
  connect(isOff2.u, u2_actual)
    annotation (Line(points={{-82,-70},{-120,-70}}, color={0,0,127}));
  connect(swi1.u1, u1_in) annotation (Line(points={{58,58},{40,58},{40,90},{-120,
          90}}, color={0,0,127}));
  connect(swi2.u1, u2_in) annotation (Line(points={{58,-62},{40,-62},{40,-30},{-120,
          -30}}, color={0,0,127}));
  connect(isOff2.y, swi1.u2) annotation (Line(points={{-58,-70},{-40,-70},{-40,0},
          {0,0},{0,50},{58,50}}, color={255,0,255}));
  connect(isOff1.y, swi2.u2) annotation (Line(points={{-58,50},{-20,50},{-20,
          -70},{58,-70}},
                     color={255,0,255}));
  connect(swi2.y, y2) annotation (Line(points={{82,-70},{94,-70},{94,-70},{120,-70}},
        color={0,0,127}));
  annotation (
  defaultComponentName="conInt",
    Documentation(revisions="<html>
<ul>
<li>
September 20, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>", info="<html>
<p>
This block takes control signals and positions of two actuators.
It imposes an interlock where the control signal of one actuator
is overriden to zero unless the other one's position is below
a threshold.
</p>
</html>"),
    Icon(graphics={
        Polygon(
          points={{-40,0},{40,40},{40,-40},{-40,0}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Interlock;
