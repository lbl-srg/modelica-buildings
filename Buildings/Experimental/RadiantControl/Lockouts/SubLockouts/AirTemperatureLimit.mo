within Buildings.Experimental.RadiantControl.Lockouts.SubLockouts;
block AirTemperatureLimit "Locks out heating if room air is hotter than user-specified threshold; locks out cooling if room air is colder than user-specified threshold"
   parameter Real TAirHiSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
    parameter Real TAirLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
  Buildings.Controls.OBC.CDL.Continuous.Greater           gre1
    "If room air temp is above high threshold, lock out heating"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Logical.Not           not2
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Less           les1
    "If room air temp is below low threshold, lock out cooling"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not           not3
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput htgSigAirTem
    "True if heating is allowed, false if heating is locked out because room air is too hot"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput clgSigAirTem
    "True if cooling allowed, false if cooling locked out because room air is too cold"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRoo(unit="K", displayUnit="K")
    "Room air temperature"
    annotation (Placement(transformation(extent={{-140,52},{-100,92}})));
  Modelica.Blocks.Sources.Constant TAirHi(k=TAirHiSet)
    "Air temperature high limit above which heating is locked out"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Constant TAirLo(k=TAirLoSet)
    "Air temperature low limit below which cooling is locked out"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(gre1.y, not2.u)
    annotation (Line(points={{22,30},{38,30}}, color={255,0,255}));
  connect(les1.y, not3.u)
    annotation (Line(points={{22,-50},{38,-50}}, color={255,0,255}));
  connect(TRoo, gre1.u1) annotation (Line(points={{-120,72},{-52,72},{-52,30},{-2,
          30}}, color={0,0,127}));
  connect(les1.u1, TRoo) annotation (Line(points={{-2,-50},{-52,-50},{-52,72},{-120,
          72}}, color={0,0,127}));
  connect(not2.y, htgSigAirTem)
    annotation (Line(points={{62,30},{120,30}}, color={255,0,255}));
  connect(not3.y, clgSigAirTem) annotation (Line(points={{62,-50},{82,-50},{82,
          -50},{120,-50}}, color={255,0,255}));
  connect(TAirHi.y, gre1.u2) annotation (Line(points={{-19,10},{-12,10},{-12,22},
          {-2,22}}, color={0,0,127}));
  connect(TAirLo.y, les1.u2) annotation (Line(points={{-19,-70},{-10,-70},{-10,-58},
          {-2,-58}}, color={0,0,127}));
  annotation (defaultComponentName = "AirTemperatureLimit",Documentation(info="<html>
<p>
If room air temperature is above a specified temperature threshold, heating is looked out. If room air temperature is below a specified temperature threshold, cooling is locked out.
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),graphics={
        Text(
          lineColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Rectangle(extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(points={{90,0},{68,8}, {68,-8},{90,0}},
          lineColor={192,192,192}, fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{80,0}}),
        Text(
        extent={{-56,90},{48,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="A"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirTemperatureLimit;
