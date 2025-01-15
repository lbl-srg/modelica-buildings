within Buildings.Examples.Tutorial.CDL;
model System1 "Open loop model"
  extends Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop;

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y1(k=mRad_flow_nominal)
    "Control signal of 1"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y2(k=1)
    "Control signal of 1"
    annotation (Placement(transformation(extent={{100,-210},{120,-190}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y3(k=1)
    "Constant control signal of 1"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y4(k=1)
    "Control signal of 1"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant y5(k=mBoi_flow_nominal)
    "Control signal of 1"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
equation
  connect(y1.y, pumRad.m_flow_in)
    annotation (Line(points={{-98,-70},{-62,-70}}, color={0,0,127}));
  connect(y3.y, boi.y) annotation (Line(points={{-98,-250},{32,-250},{32,-302},{
          22,-302}}, color={0,0,127}));
  connect(y2.y, valBoi.y) annotation (Line(points={{122,-200},{130,-200},{130,-230},
          {72,-230}}, color={0,0,127}));
  connect(y4.y, valRad.y)
    annotation (Line(points={{-98,-150},{-62,-150}}, color={0,0,127}));
  connect(y5.y, pumBoi.m_flow_in) annotation (Line(points={{-98,-280},{-80,-280},
          {-80,-280},{-62,-280}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model extends from the open loop partial model
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop\">
Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop</a>,
which implements the HVAC system model and a simple room.
In this partial model, the room is modeled
as a first order response.
</p>
<h4>Implementation</h4>
<p>
To set control inputs, we instantiated
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sources.Constant\">
Buildings.Controls.OBC.CDL.Reals.Sources.Constant</a>
and connected them to the pumps, the boiler and the valves.
</p>
<h4>Exercise</h4>
<p>
Create a model, such as this model, that extends from
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop\">
Buildings.Examples.Tutorial.CDL.BaseClasses.PartialOpenLoop</a>
and adds constant input signals for the valves, pumps and the boiler.
Valves should be fully open (<i>y=1</i>), the boiler should be operating (<i>y=1</i>)
and the mass flow rates of the pumps should be set to the parameter value of
<code>mRad_flow_nominal</code> and <code>mBoi_flow_nominal</code>.
</p>
<p>
Simulate the model for January 15 to 16 and plot the open loop temperatures
as shown below, which corresponds to a start time of <i>15*24*3600=1296000</i> seconds and a
stop time of <i>1382400</i> seconds.
</p>
<p align=\"center\">
<img alt=\"Open loop temperatures.\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/CDL/System1/OpenLoopTemperatures.png\" border=\"1\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/CDL/System1.mos"
        "Simulate and plot"),
    experiment(
      StartTime=1296000,
      StopTime=1382400,
      Tolerance=1e-06));
end System1;
