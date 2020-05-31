within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences;
block FailsafeCondition
  "Failsafe condition used in staging up and down"

  parameter Real delayEna(
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 900
    "Enable delay";

  parameter Real TDif(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature
    for failsafe condition";

  parameter Real TDifHys(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Failsafe condition for chiller staging"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1,
    y(
    final unit="K",
    final displayUnit="K"))
    "Difference between setpoint and measured temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=TDif - TDifHys,
    final uHigh=TDif)
    "Hysteresis deadband to prevent cycling"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(final delayTime=delayEna,
    final delayOnInit=true)
    "Enable delay"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation
  connect(add2.u2, TSup)
    annotation (Line(points={{-82,-6},{-90,-6},{-90,-50},{-120,-50}},
      color={0,0,127}));
  connect(add2.u1, TSupSet)
    annotation (Line(points={{-82,6},{-90,6},{-90,50},{-120,50}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-58,0},{-42,0}},
      color={0,0,127}));
  connect(hys.y, truDel.u)
    annotation (Line(points={{-18,0},{-2,0}},
      color={255,0,255}));
  connect(truDel.y, y)
    annotation (Line(points={{22,0},{120,0}},
      color={255,0,255}));

annotation (defaultComponentName = "faiSafCon",
  Icon(coordinateSystem(extent={{-100,-80},{100,100}}),
    graphics={
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-120,146},{100,108}},
        lineColor={0,0,255},
        textString="%name")}),
  Diagram(coordinateSystem(
    preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
    <p>Failsafe condition used in staging up and down, implemented according to
    the specification provided in section 5.3.3.10 1711 March 2020 Draft.
    </p>
    <p align=\"center\">
    <img alt=\"Validation plot for FailsafeCondition\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Subsequences/FailsafeCondition.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Validation.FailsafeCondition\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences.Validation.FailsafeCondition</a>.
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
