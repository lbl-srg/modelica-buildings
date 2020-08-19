within Buildings.Experimental.NatVentControl.Lockouts;
block DryBulbLockout
  "Locks out natural ventilation if outdoor air dry bulb temperature is below a user-specified threshhold"
  parameter Real TOADB(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=288.7 "Outdoor air temperature below which nat vent is not allowed";

  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=0,
    uHigh=0.1,
    pre_y_start=true)
    "Tests if VAV setpoint minus wet bulb temp is greater than user-specified tolerance (typically 8 F). If so, window can open. If not, window must be closed."
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Controls.OBC.CDL.Continuous.ChangeSign           chaSig
    "Negates room temperature setpoint"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Controls.OBC.CDL.Logical.And and2
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(
    uLow=TOADBLo,
    uHigh=TOADB,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Controls.OBC.CDL.Interfaces.RealInput TDryBul
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput natVenSigOAT
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TStaSetWin
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
protected
    parameter Real TOADBLo(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=TOADB*0.99  "Lower hysteresis limit";
equation
  connect(add2.y,hys. u)
    annotation (Line(points={{-38,30},{-22,30}},color={0,0,127}));
  connect(TStaSetWin, chaSig.u) annotation (Line(points={{-120,50},{-94,50},{-94,
          70},{-92,70}}, color={0,0,127}));
  connect(TDryBul,add2. u2) annotation (Line(points={{-120,-10},{-82,-10},{-82,24},
          {-62,24}},color={0,0,127}));
  connect(chaSig.y,add2. u1) annotation (Line(points={{-68,70},{-66,70},{-66,36},
          {-62,36}}, color={0,0,127}));
  connect(TDryBul,hys1. u) annotation (Line(points={{-120,-10},{-82,-10},{-82,-50},
          {-2,-50}}, color={0,0,127}));
  connect(hys1.y,and2. u2) annotation (Line(points={{22,-50},{48,-50},{48,22},{58,
          22}}, color={255,0,255}));
  connect(hys.y,not1. u)
    annotation (Line(points={{2,30},{18,30}}, color={255,0,255}));
  connect(not1.y,and2. u1)
    annotation (Line(points={{42,30},{58,30}}, color={255,0,255}));
  connect(and2.y,natVenSigOAT)  annotation (Line(points={{82,30},{90,30},{90,10},
          {120,10}}, color={255,0,255}));

  annotation (defaultComponentName = "DryBulbLockout", Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the dry bulb temperature is below a user-specified threshhold or above the air temperature setpoint for the room.
</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{-76,40},{-76,-82},{84,-82},{84,40},{-76,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-50,40},{-56,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-56,86},{64,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{64,40},{58,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-18,42},{32,-54}},
          lineColor={28,108,200},
          textString="W")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end DryBulbLockout;
