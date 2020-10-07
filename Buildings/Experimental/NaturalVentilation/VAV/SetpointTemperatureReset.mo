within Buildings.Experimental.NaturalVentilation.VAV;
block SetpointTemperatureReset
  "Resets VAV thermostat if natural ventilation mode is on"
  parameter Real ClgStpRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Amount by which VAV cooling setpoint relaxes when natural ventilation mode is on";
  parameter Real HtgStpRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Amount by which VAV heating setpoint relaxes when natural ventilation mode is on";
  Controls.OBC.CDL.Interfaces.BooleanInput uNatVen
    "True if natural ventilation is active; false if not" annotation (Placement(
        transformation(extent={{-140,10},{-100,50}}), iconTransformation(extent=
           {{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput yHtgStpVAV
    "VAV heating setpoint while in natural ventilation mode" annotation (
      Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Controls.OBC.CDL.Interfaces.RealOutput yClgStpVAV
    "VAV cooling setpoint while in natural ventilation mode" annotation (
      Placement(transformation(extent={{100,-90},{140,-50}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Controls.OBC.CDL.Interfaces.RealInput THeaSet
    "Heating air temperature setpoint for mechanical heating"
    annotation (Placement(transformation(extent={{-138,80},{-98,120}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.RealInput TCooSet
    "Cooling air temperature setpoint for mechanical cooling"
    annotation (Placement(transformation(extent={{-138,52},{-98,92}}),
        iconTransformation(extent={{-142,-60},{-102,-20}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Controls.OBC.CDL.Interfaces.RealOutput yHtgStpWin
    "Heating setpoint for window while in natural ventilation mode" annotation (
     Placement(transformation(extent={{100,60},{140,100}}), iconTransformation(
          extent={{100,50},{140,90}})));
  Controls.OBC.CDL.Interfaces.RealOutput yClgStpWin
    "Cooling setpoint for window while in natural ventilation mode" annotation (
     Placement(transformation(extent={{100,20},{140,60}}), iconTransformation(
          extent={{100,12},{140,52}})));
  Controls.OBC.CDL.Continuous.Sources.Constant htgStpRelAmt(k=HtgStpRel)
    "Amount heating setpoint is relaxed when natural ventilation mode is on"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant clgStpRelAmt(k=ClgStpRel)
    "Amount cooling setpoint is relaxed when natural ventilation mode is on"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(yHtgStpWin, yHtgStpWin)
    annotation (Line(points={{120,80},{120,80}}, color={0,0,127}));
  connect(THeaSet, yHtgStpWin) annotation (Line(points={{-118,100},{68,100},{68,
          80},{120,80}}, color={0,0,127}));
  connect(THeaSet, add2.u2) annotation (Line(points={{-118,100},{-72,100},{-72,
          48},{12,48},{12,64},{18,64}}, color={0,0,127}));
  connect(TCooSet, add1.u2) annotation (Line(points={{-118,72},{-78,72},{-78,
          -56},{18,-56}}, color={0,0,127}));
  connect(TCooSet, yClgStpWin) annotation (Line(points={{-118,72},{-78,72},{-78,
          40},{120,40}}, color={0,0,127}));
  connect(htgStpRelAmt.y, add2.u1) annotation (Line(points={{-38,70},{0,70},{0,
          76},{18,76}}, color={0,0,127}));
  connect(clgStpRelAmt.y, add1.u1) annotation (Line(points={{-38,-30},{0,-30},{
          0,-44},{18,-44}}, color={0,0,127}));
  connect(add1.y, swi1.u1) annotation (Line(points={{42,-50},{48,-50},{48,-62},
          {58,-62}}, color={0,0,127}));
  connect(uNatVen, swi1.u2) annotation (Line(points={{-120,30},{-86,30},{-86,
          -70},{58,-70}}, color={255,0,255}));
  connect(TCooSet, swi1.u3) annotation (Line(points={{-118,72},{-94,72},{-94,
          -78},{58,-78}}, color={0,0,127}));
  connect(swi1.y, yClgStpVAV)
    annotation (Line(points={{82,-70},{120,-70}}, color={0,0,127}));
  connect(add2.y, swi.u1) annotation (Line(points={{42,70},{52,70},{52,18},{58,
          18}}, color={0,0,127}));
  connect(uNatVen, swi.u2) annotation (Line(points={{-120,30},{40,30},{40,10},{
          58,10}}, color={255,0,255}));
  connect(THeaSet, swi.u3) annotation (Line(points={{-118,100},{-72,100},{-72,0},
          {32,0},{32,2},{58,2}}, color={0,0,127}));
  connect(swi.y, yHtgStpVAV) annotation (Line(points={{82,10},{90,10},{90,-30},
          {120,-30}}, color={0,0,127}));
  annotation (defaultComponentName = "setTemRes",Documentation(info="<html>
  This block determines the VAV temperature setpoint while natural ventilation mode is on.
  <p> When natural ventilation mode turns on,
   the block adds a user-specified setpoint relaxation amount (typically 20F, ClgStpRel for cooling and HtgStpRel for heating) to produce relaxed VAV setpoints.
   <p>
   This aims to prevent the VAV from attempting to condition the room while the windows are open. 
<p>
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-80,60},{-80,-60},{34,-60},{94,60},{-52,60},{-80,60}},
          lineColor={0,140,72},
          lineThickness=1), Text(
          extent={{20,-52},{-36,58}},
          lineColor={0,140,72},
          lineThickness=1,
          textString="T"),
        Text(
          lineColor={0,0,255},
          extent={{-146,98},{154,138}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-100},{100,140}}), graphics={Text(
          extent={{-96,140},{304,108}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="VAV Setpoint Temperature Reset:
Selects VAV temperature setpoint
based on natural ventilation status
"), Text( extent={{-70,18},{-24,12}},
          lineColor={28,108,200},
          lineThickness=1,
          fontSize=8,
          horizontalAlignment=TextAlignment.Left,
          textString="Relax setpoints by a user-specified amount
if natural ventilation is active
Otherwise,
pass setpoints to VAV unchanged. ")}));
end SetpointTemperatureReset;
