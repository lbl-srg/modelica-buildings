within IceStorage.BaseClasses;
model OutletTemperatureControl "Storage outlet temperature control"
  parameter Real k=1 "Gain of controller";
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of Integrator block";

  Modelica.Blocks.Interfaces.IntegerInput u "Storage mode"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput yVal1(
    final quantity="1",
    min=0,
    max=1) "Valve1 opening" annotation (Placement(transformation(extent={{100,30},
            {120,50}}), iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Logical.Switch swi "Switch"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isDor "Is dormant"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Modelica.Blocks.Sources.IntegerExpression dorMod(y=Integer(IceStorage.Types.IceThermalStorageMode.Dormant))
    "Dormant mode"
    annotation (Placement(transformation(extent={{-60,14},{-40,34}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Constant uti(k=1) "Utility"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isCha "Is charging"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.IntegerExpression chaMod(y=Integer(IceStorage.Types.IceThermalStorageMode.Charging))
    "Charging mode"
    annotation (Placement(transformation(extent={{-60,-54},{-40,-34}})));
  Modelica.Blocks.Logical.Switch swi1
                                     "Switch"
    annotation (Placement(transformation(extent={{22,-40},{42,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isDis "Is discharging"
    annotation (Placement(transformation(extent={{-20,-86},{0,-66}})));
  Modelica.Blocks.Sources.IntegerExpression disMod(y=Integer(IceStorage.Types.IceThermalStorageMode.Discharging))
    "Discharging mode"
    annotation (Placement(transformation(extent={{-60,-94},{-40,-74}})));
  Modelica.Blocks.Logical.Switch swi2
                                     "Switch"
    annotation (Placement(transformation(extent={{22,-78},{42,-58}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{64,-50},{84,-30}})));
  Buildings.Controls.Continuous.LimPID conPID(k=k, Ti=Ti)
    annotation (Placement(transformation(extent={{-82,-70},{-62,-50}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{18,0},{38,20}})));
  Modelica.Blocks.Interfaces.RealOutput yVal2(
    final quantity="1",
    min=0,
    max=1) "Valve2 opening" annotation (Placement(transformation(extent={{100,-50},
            {120,-30}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TOutSet "Outlet temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TOutMea
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

equation
  connect(dorMod.y,isDor. u2) annotation (Line(points={{-39,24},{-28,24},{-28,
          32},{-22,32}}, color={255,127,0}));
  connect(u,isDor. u1)
    annotation (Line(points={{-120,0},{-32,0},{-32,40},{-22,40}},
                                                color={255,127,0}));
  connect(isDor.y,swi. u2)
    annotation (Line(points={{2,40},{48,40}},
                                            color={255,0,255}));
  connect(swi.y, yVal1)
    annotation (Line(points={{71,40},{110,40}}, color={0,0,127}));
  connect(zer.y,swi. u1)
    annotation (Line(points={{1,70},{14,70},{14,48},{48,48}},color={0,0,127}));
  connect(u,isCha. u1) annotation (Line(points={{-120,0},{-32,0},{-32,-26},{-28,
          -26},{-28,-30},{-22,-30}}, color={255,127,0}));
  connect(chaMod.y,isCha. u2) annotation (Line(points={{-39,-44},{-30,-44},{-30,
          -38},{-22,-38}}, color={255,127,0}));
  connect(isCha.y,swi1. u2)
    annotation (Line(points={{2,-30},{20,-30}}, color={255,0,255}));
  connect(zer.y,swi1. u1) annotation (Line(points={{1,70},{14,70},{14,-22},{20,
          -22}}, color={0,0,127}));
  connect(disMod.y,isDis. u2)
    annotation (Line(points={{-39,-84},{-22,-84}}, color={255,127,0}));
  connect(u,isDis. u1) annotation (Line(points={{-120,0},{-32,0},{-32,-76},{-22,
          -76}}, color={255,127,0}));
  connect(uti.y,swi1. u3) annotation (Line(points={{1,10},{6,10},{6,-38},{20,
          -38}}, color={0,0,127}));
  connect(isDis.y,swi2. u2) annotation (Line(points={{2,-76},{12,-76},{12,-68},
          {20,-68}}, color={255,0,255}));
  connect(swi1.y,pro. u1) annotation (Line(points={{43,-30},{52,-30},{52,-34},{
          62,-34}}, color={0,0,127}));
  connect(uti.y,swi2. u3) annotation (Line(points={{1,10},{6,10},{6,-76},{20,
          -76}}, color={0,0,127}));
  connect(swi2.y,pro. u2) annotation (Line(points={{43,-68},{52,-68},{52,-46},{
          62,-46}}, color={0,0,127}));
  connect(pro.y, yVal2)
    annotation (Line(points={{86,-40},{110,-40}}, color={0,0,127}));
  connect(conPID.y,swi2. u1)
    annotation (Line(points={{-61,-60},{20,-60}}, color={0,0,127}));
  connect(pro.y,feedback. u2) annotation (Line(points={{86,-40},{88,-40},{88,-4},
          {28,-4},{28,2}}, color={0,0,127}));
  connect(uti.y,feedback. u1)
    annotation (Line(points={{1,10},{20,10}}, color={0,0,127}));
  connect(feedback.y,swi. u3) annotation (Line(points={{37,10},{42,10},{42,32},
          {48,32}}, color={0,0,127}));
  connect(TOutSet, conPID.u_s) annotation (Line(points={{-120,-40},{-92,-40},{-92,
          -60},{-84,-60}}, color={0,0,127}));
  connect(TOutMea, conPID.u_m) annotation (Line(points={{-120,-80},{-72,-80},{-72,
          -72}}, color={0,0,127}));
  annotation (defaultComponentName="valOnOff",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end OutletTemperatureControl;
