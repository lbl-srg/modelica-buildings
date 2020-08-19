<<<<<<< HEAD
within Buildings.Experimental.NatVentControl.Lockouts;
block WetBulbLockout "Locks out natural ventilation based on outdoor air wet bulb temperature"
  parameter Real TWBDiff(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Allowable difference between outdoor air wet bulb temperature and room air temperature setpoint: OA WB +  this difference must be less than room air temperature setpoint";
  Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TStaSetWin
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealInput TWetBul
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=TWBDiffLo,
    uHigh=TWBDiff,
    pre_y_start=true)
    "Tests if room air setpoint minus wet bulb temp is greater than user-specified tolerance (typically 8 F). If so, window can open. If not, window must be closed."
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigWB
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-18},{140,22}})));
  Controls.OBC.CDL.Continuous.ChangeSign           chaSig
    "Negates wet bulb temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
protected
          parameter Real TWBDiffLo(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=TWBDiff*0.99  "Lower hysteresis limit";
equation
  connect(add2.y,hys. u)
    annotation (Line(points={{-18,10},{-2,10}}, color={0,0,127}));
  connect(hys.y,not1. u)
    annotation (Line(points={{22,10},{38,10}},color={255,0,255}));
  connect(not1.y, natVenSigWB)
    annotation (Line(points={{62,10},{120,10}}, color={255,0,255}));
  connect(chaSig.y, add2.u2) annotation (Line(points={{-58,-10},{-50,-10},{-50,4},
          {-42,4}}, color={0,0,127}));
  connect(TStaSetWin, add2.u1) annotation (Line(points={{-120,30},{-82,30},{-82,
          16},{-42,16}}, color={0,0,127}));
  connect(TWetBul, chaSig.u) annotation (Line(points={{-120,-30},{-102,-30},{-102,
          -10},{-82,-10}}, color={0,0,127}));
  annotation (defaultComponentName = "WetBulbLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the wet bulb temperature is too high. 
  The user specifies a tolerance, and the wet bulb temperature must be below the room setpoint minus the tolerance in order for natural ventilation to be permitted. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,40},{-60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,86},{60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,40},{54,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-40,32},{44,-42}},
          lineColor={28,108,200},
          textString="B")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end WetBulbLockout;
=======
within Buildings.Experimental.NatVentControl.Lockouts;
block WetBulbLockout "Locks out natural ventilation based on outdoor air wet bulb temperature"
  parameter Real TWBDiff(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=4.44 "Allowable difference between outdoor air wet bulb temperature and room air temperature setpoint: OA WB +  this difference must be less than room air temperature setpoint";
  Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TStaSetWin
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.RealInput TWetBul
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=TWBDiffLo,
    uHigh=TWBDiff,
    pre_y_start=true)
    "Tests if room air setpoint minus wet bulb temp is greater than user-specified tolerance (typically 8 F). If so, window can open. If not, window must be closed."
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigWB
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-18},{140,22}})));
  Controls.OBC.CDL.Continuous.ChangeSign           chaSig
    "Negates wet bulb temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
protected
          parameter Real TWBDiffLo(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=TWBDiff*0.99  "Lower hysteresis limit";
equation
  connect(add2.y,hys. u)
    annotation (Line(points={{-18,10},{-2,10}}, color={0,0,127}));
  connect(hys.y,not1. u)
    annotation (Line(points={{22,10},{38,10}},color={255,0,255}));
  connect(not1.y, natVenSigWB)
    annotation (Line(points={{62,10},{120,10}}, color={255,0,255}));
  connect(chaSig.y, add2.u2) annotation (Line(points={{-58,-10},{-50,-10},{-50,4},
          {-42,4}}, color={0,0,127}));
  connect(TStaSetWin, add2.u1) annotation (Line(points={{-120,30},{-82,30},{-82,
          16},{-42,16}}, color={0,0,127}));
  connect(TWetBul, chaSig.u) annotation (Line(points={{-120,-30},{-102,-30},{-102,
          -10},{-82,-10}}, color={0,0,127}));
  annotation (defaultComponentName = "WetBulbLockout",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the wet bulb temperature is too high. 
  The user specifies a tolerance, and the wet bulb temperature must be below the room setpoint minus the tolerance in order for natural ventilation to be permitted. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-54,40},{-60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-60,86},{60,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{60,40},{54,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-40,32},{44,-42}},
          lineColor={28,108,200},
          textString="B")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end WetBulbLockout;
>>>>>>> 2008edcd25685faae709310e80edf551fd923411
