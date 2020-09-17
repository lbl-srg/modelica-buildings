within Buildings.Experimental;
package Lighting "\"Lighting control package\""
  block DaylightControlContinuous "Controls light fixture continually to a foot-candle setpoint"
   parameter Real maxFC( min=0)= 50 "Maximum foot-cancdle output for light fixture";
    Controls.OBC.CDL.Interfaces.RealInput uLigSet
      "Room light setpoint in foot candles"
                                          annotation (Placement(transformation(
            extent={{-138,-90},{-98,-50}}), iconTransformation(extent={{-142,
              -30},{-102,10}})));
    Controls.OBC.CDL.Interfaces.BooleanInput uFixAva
      "Lighting fixture availability schedule: true if fixture is allowed to be on, false if not"
      annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
          iconTransformation(extent={{-140,50},{-100,90}})));
    Controls.OBC.CDL.Interfaces.RealOutput yLigSig
      "Lighting signal: percent of maximum output" annotation (Placement(
          transformation(extent={{180,-10},{220,30}}), iconTransformation(extent={{104,-12},
              {144,28}})));
    Controls.OBC.CDL.Logical.Switch swi
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Controls.OBC.CDL.Continuous.Sources.Constant conZero(k=0)
      "Constant zero if light is scheduled to be off"
      annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
    Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=0.01, uHigh=0.02)
      annotation (Placement(transformation(extent={{140,40},{160,60}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yLigSta
      "Lighting fixture status: true if fixture is on, false if not" annotation (
        Placement(transformation(extent={{180,32},{220,72}}), iconTransformation(
            extent={{104,30},{144,70}})));
    Controls.OBC.CDL.Continuous.Product pro
      annotation (Placement(transformation(extent={{140,-60},{160,-40}})));
    Controls.OBC.CDL.Continuous.Sources.Constant conMaxFC(k=MaxFC)
      "Maximum foot candle level from light"
      annotation (Placement(transformation(extent={{80,-82},{100,-62}})));
    Controls.OBC.CDL.Interfaces.RealOutput yLigLev
      "Lighting level in foot candles" annotation (Placement(transformation(
            extent={{180,-70},{220,-30}}), iconTransformation(extent={{104,-52},
              {144,-12}})));
    Controls.OBC.CDL.Interfaces.RealInput uDayLev
      "Daylight level in foot candles" annotation (Placement(transformation(
            extent={{-140,-30},{-100,10}}), iconTransformation(extent={{-142,10},
              {-102,50}})));
    Controls.OBC.CDL.Continuous.Add add2(k1=-1)
      annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
    Controls.OBC.CDL.Continuous.Division div
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Controls.OBC.CDL.Continuous.Sources.Constant conMaxFC1(k=MaxFC)
      "Maximum foot candle level from light"
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    Controls.OBC.CDL.Continuous.Hysteresis hys1(uLow=0.01, uHigh=0.02)
      annotation (Placement(transformation(extent={{22,60},{42,80}})));
    Controls.OBC.CDL.Logical.Switch swi1
      annotation (Placement(transformation(extent={{62,60},{82,80}})));
  equation
    connect(uFixAva, swi.u2) annotation (Line(points={{-120,70},{-80,70},{-80,10},
            {98,10}}, color={255,0,255}));
    connect(conZero.y, swi.u3) annotation (Line(points={{82,-30},{88,-30},{88,2},{
            98,2}}, color={0,0,127}));
    connect(yLigSig, yLigSig)
      annotation (Line(points={{200,10},{200,10}}, color={0,0,127}));
    connect(hys.y, yLigSta) annotation (Line(points={{162,50},{176,50},{176,52},{200,
            52}}, color={255,0,255}));
    connect(swi.y, hys.u) annotation (Line(points={{122,10},{130,10},{130,50},{138,
            50}}, color={0,0,127}));
    connect(swi.y, yLigSig)
      annotation (Line(points={{122,10},{200,10}}, color={0,0,127}));
    connect(conMaxFC.y, pro.u2) annotation (Line(points={{102,-72},{122,-72},{122,
            -56},{138,-56}}, color={0,0,127}));
    connect(swi.y, pro.u1) annotation (Line(points={{122,10},{130,10},{130,-44},{138,
            -44}}, color={0,0,127}));
    connect(pro.y, yLigLev)
      annotation (Line(points={{162,-50},{200,-50}}, color={0,0,127}));
    connect(uDayLev, add2.u1) annotation (Line(points={{-120,-10},{-82,-10},{
            -82,-2},{-62,-2}}, color={0,0,127}));
    connect(uLigSet, add2.u2) annotation (Line(points={{-118,-70},{-80,-70},{
            -80,-14},{-62,-14}}, color={0,0,127}));
    connect(add2.y, div.u1) annotation (Line(points={{-38,-8},{-36,-8},{-36,76},
            {-22,76}}, color={0,0,127}));
    connect(conMaxFC1.y, div.u2) annotation (Line(points={{-38,-50},{-30,-50},{
            -30,64},{-22,64}}, color={0,0,127}));
    connect(div.y, hys1.u)
      annotation (Line(points={{2,70},{20,70}}, color={0,0,127}));
    connect(hys1.y, swi1.u2)
      annotation (Line(points={{44,70},{60,70}}, color={255,0,255}));
    connect(div.y, swi1.u1) annotation (Line(points={{2,70},{10,70},{10,94},{52,
            94},{52,78},{60,78}}, color={0,0,127}));
    connect(conZero.y, swi1.u3) annotation (Line(points={{82,-30},{88,-30},{88,
            46},{46,46},{46,62},{60,62}}, color={0,0,127}));
    connect(div.y, swi.u1) annotation (Line(points={{2,70},{10,70},{10,20},{98,
            20},{98,18}}, color={0,0,127}));
    annotation (defaultComponentName = "dayConCon", Documentation(info="<html>
  <p>
  This block determines the percent of a light fixture's maximum output that is required,
  given a daylight level, a foot-candle setpoint, and the fixture's maximum foot-candle output (maxFC). 
  <p>
  If daylight is sufficient to meet the foot-candle setpoint, the fixture is allowed to turn off. 
  Otherwise, the fixture modulates to meet the foot-candle setpoint. 
  
<p>
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,98},{102,-102}},
            lineColor={244,125,35},
            lineThickness=1),
          Ellipse(
            extent={{-34,32},{32,-34}},
            lineColor={244,125,35},
            lineThickness=1,
            fillColor={217,67,180},
            fillPattern=FillPattern.None,
            startAngle=0,
            endAngle=360),
          Polygon(
            points={{-10,42},{0,58},{10,42},{-10,42}},
            lineColor={244,125,35},
            lineThickness=1,
            fillColor={217,67,180},
            fillPattern=FillPattern.None),
          Polygon(
            points={{-10,-8},{0,8},{10,-8},{-10,-8}},
            lineColor={244,125,35},
            lineThickness=1,
            fillColor={217,67,180},
            fillPattern=FillPattern.None,
            origin={0,-50},
            rotation=180),
          Polygon(
            points={{-10,-8},{0,8},{10,-8},{-10,-8}},
            lineColor={244,125,35},
            lineThickness=1,
            fillColor={217,67,180},
            fillPattern=FillPattern.None,
            origin={48,2},
            rotation=270),
          Polygon(
            points={{-10,-8},{0,8},{10,-8},{-10,-8}},
            lineColor={244,125,35},
            lineThickness=1,
            fillColor={217,67,180},
            fillPattern=FillPattern.None,
            origin={-50,0},
            rotation=90)}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{180,100}})));
  end DaylightControlContinuous;

  package Validation "Validation package for lighting model"
    model DayConCon "Validation model for daylighting control"
      DaylightControlContinuous daylightControlContinuous(MaxFC=100)
        annotation (Placement(transformation(extent={{-18,-2},{40,60}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Modelica.Blocks.Sources.Constant const(k=100)
        annotation (Placement(transformation(extent={{-82,22},{-62,42}})));
      Modelica.Blocks.Sources.Ramp ramp(height=50, duration=7200)
        annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
    equation
      connect(booleanConstant.y, daylightControlContinuous.uFixAva) annotation (
          Line(points={{-59,70},{-32,70},{-32,50.7},{-23.8,50.7}}, color={255,0,255}));
      connect(ramp.y, daylightControlContinuous.uDayLev) annotation (Line(points={{-59,
              -12},{-48,-12},{-48,38.3},{-24.38,38.3}}, color={0,0,127}));
      connect(const.y,daylightControlContinuous.uLigSet)  annotation (Line(points={{
              -61,32},{-42,32},{-42,25.9},{-24.38,25.9}}, color={0,0,127}));
      annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=14400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/Lighting/Validation/DayConCon.mos"
            "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-94},{100,106}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,64},{64,4},{-36,-56},{-36,64}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DayConCon;
  end Validation;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-98,100},{102,-100}},
          lineColor={217,67,180},
          lineThickness=1),
        Rectangle(
          extent={{-20,-20},{22,-80}},
          lineColor={217,67,180},
          lineThickness=1),
        Polygon(
          points={{-40,0},{-20,-18},{22,-18},{40,0},{-38,0},{-40,0}},
          lineColor={217,67,180},
          lineThickness=1),
        Ellipse(
          extent={{-54,82},{54,-16}},
          lineColor={217,67,180},
          lineThickness=1,
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid)}));
end Lighting;
