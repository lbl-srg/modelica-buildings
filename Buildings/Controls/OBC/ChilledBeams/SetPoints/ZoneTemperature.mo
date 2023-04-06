within Buildings.Controls.OBC.ChilledBeams.SetPoints;
block ZoneTemperature
  "Sequence to generate zone heating and cooling setpoint temperatures"

  parameter Real zonOccHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 293.15
    "Zone heating setpoint when it is occupied";

  parameter Real zonUnoccHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 290.15
    "Zone heating setpoint when it is unoccupied";

  parameter Real zonOccCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 296.15
    "Zone cooling setpoint when it is occupied";

  parameter Real zonUnoccCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") = 299.15
    "Zone cooling setpoint when it is unoccupied";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Operating mode signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Zone cooling setpoint temperature"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=zonOccHeaSet)
    "Zone occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=zonUnoccHeaSet)
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=zonOccCooSet)
    "Zone occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=zonUnoccCooSet)
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Generate True signal for occupied mode and False otherwise"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ChilledBeams.Types.OperationModes.occupied)
    "Occupied mode signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Switch for occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Switch for occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));

equation
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-18,-20},{-10,-20},{-10,
          -8},{-2,-8}}, color={255,127,0}));

  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-120,0},{-2,0}}, color={255,127,0}));

  connect(con.y, swi.u1) annotation (Line(points={{-58,80},{30,80},{30,68},{38,68}},
        color={0,0,127}));

  connect(con1.y, swi.u3) annotation (Line(points={{-58,40},{30,40},{30,52},{38,
          52}}, color={0,0,127}));

  connect(intEqu.y, swi.u2) annotation (Line(points={{22,0},{32,0},{32,60},{38,60}},
        color={255,0,255}));

  connect(con2.y, swi1.u1) annotation (Line(points={{-58,-40},{30,-40},{30,-52},
          {38,-52}}, color={0,0,127}));

  connect(con3.y, swi1.u3) annotation (Line(points={{-58,-80},{30,-80},{30,-68},
          {38,-68}}, color={0,0,127}));

  connect(intEqu.y, swi1.u2) annotation (Line(points={{22,0},{32,0},{32,-60},{38,
          -60}}, color={255,0,255}));

  connect(swi.y, TZonHeaSet)
    annotation (Line(points={{62,60},{120,60}}, color={0,0,127}));

  connect(swi1.y, TZonCooSet)
    annotation (Line(points={{62,-60},{120,-60}}, color={0,0,127}));

annotation(defaultComponentName="TZonSet",
  Icon(coordinateSystem(preserveAspectRatio=false),
          graphics={
            Text(
              extent={{-100,150},{100,110}},
              lineColor={0,0,255},
              textString="%name"),
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
Sequences for calculating zone heating and cooling setpoint temperatures. The 
setpoints are calculated as follows.
<ul>
<li>
When the operating mode is <code>occupied</code>, the zone heating and cooling 
setpoints are set as per the occupied values <code>zonOccHeaSet</code> and 
<code>zonOccCooSet</code>.
</li>
<li>
When the operating mode is either <code>unoccupiedScheduled</code> or 
<code>unoccupiedUnscheduled</code>, the zone heating and cooling setpoints are 
set as per the unoccupied values <code>zonUnoccHeaSet</code> and 
<code>zonUnoccHeaSet</code>.
</li>
</ul>
</p>
</html>",
revisions="<html>
<ul>
<li>
September 6, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneTemperature;
