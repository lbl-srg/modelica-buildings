within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences;
block FailsafeCondition
  "Failsafe condition used in staging up and down"

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature
    for failsafe condition";

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation (Dialog(tab="Advanced"));

  parameter Real delEna(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,30},{-120,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFaiCon
    "Failsafe condition for boiler staging"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Difference between setpoint and measured temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=TDif - TDifHys,
    final uHigh=TDif)
    "Hysteresis deadband to prevent cycling"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=delEna)
    "Time since condition has been met"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Turn on timer when hysteresis turns on and reset it when hysteresis turns
    off or stage change process is completed"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(sub2.u2, TSup)
    annotation (Line(points={{-82,-6},{-90,-6},{-90,0},{-140,0}},
      color={0,0,127}));
  connect(sub2.u1, TSupSet)
    annotation (Line(points={{-82,6},{-90,6},{-90,50},{-140,50}},
      color={0,0,127}));
  connect(sub2.y, hys.u)
    annotation (Line(points={{-58,0},{-42,0}},
      color={0,0,127}));
  connect(not1.u, uStaChaProEnd)
    annotation (Line(points={{-42,-50},{-140,-50}}, color={255,0,255}));
  connect(hys.y, and2.u1)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-18,-50},{-12,-50},{-12,-8},
          {-2,-8}}, color={255,0,255}));
  connect(and2.y, tim.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));

  connect(tim.passed, yFaiCon) annotation (Line(points={{62,-8},{70,-8},{70,0},{
          140,0}}, color={255,0,255}));
annotation (defaultComponentName = "faiSafCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-120,146},{100,108}},
        textColor={0,0,255},
        textString="%name")}),
  Diagram(coordinateSystem(
    preserveAspectRatio=false,
    extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
    <p>
    Failsafe condition used in staging up and down, implemented according to
    the specification provided in section 5.3.3.10, subsections 6.c, 8.c, 10.c
    and 12.c in RP-1711, March 2020 Draft. Timer reset has been implemented
    according to 5.3.3.10.2.
    </p>
    <p align=\"center\">
    <img alt=\"State-machine chart for FailsafeCondition\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/FailsafeCondition_stateMachineChart.png\"/>
    <br/>
    State-machine chart for the sequence defined in RP-1711
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 21, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end FailsafeCondition;
