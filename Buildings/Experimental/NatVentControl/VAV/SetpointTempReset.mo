within Buildings.Experimental.NatVentControl.VAV;
block SetpointTempReset  "Resets VAV thermostat if natural ventilation mode is on"
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
    annotation (Placement(transformation(extent={{0,-62},{20,-42}})));
  Controls.OBC.CDL.Interfaces.RealOutput yHtgStpWin
    "Heating setpoint for window while in natural ventilation mode" annotation (
     Placement(transformation(extent={{100,60},{140,100}}), iconTransformation(
          extent={{100,50},{140,90}})));
  Controls.OBC.CDL.Interfaces.RealOutput yClgStpWin
    "Cooling setpoint for window while in natural ventilation mode" annotation (
     Placement(transformation(extent={{100,20},{140,60}}), iconTransformation(
          extent={{100,12},{140,52}})));
  Modelica.Blocks.Sources.Constant htgStpRelAmt(k=HtgStpRel)
    "Amount heating setpoint is relaxed when natural ventilation mode is on"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Constant clgStpRelAmt(k=ClgStpRel)
    "Amount that cooling setpoint is relaxed"
    annotation (Placement(transformation(extent={{-62,-42},{-42,-22}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,-2},{60,18}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(yHtgStpWin, yHtgStpWin)
    annotation (Line(points={{120,80},{120,80}}, color={0,0,127}));
  connect(clgStpRelAmt.y, add1.u1) annotation (Line(points={{-41,-32},{-18,-32},
          {-18,-46},{-2,-46}},
                          color={0,0,127}));
  connect(uNatVen, switch1.u2) annotation (Line(points={{-120,30},{24,30},{24,8},
          {38,8}}, color={255,0,255}));
  connect(THeaSet, yHtgStpWin) annotation (Line(points={{-118,100},{68,100},{68,
          80},{120,80}}, color={0,0,127}));
  connect(THeaSet, add2.u2) annotation (Line(points={{-118,100},{-66,100},{-66,
          48},{12,48},{12,64},{18,64}}, color={0,0,127}));
  connect(add2.y, switch1.u1) annotation (Line(points={{42,70},{50,70},{50,34},
          {30,34},{30,16},{38,16}}, color={0,0,127}));
  connect(THeaSet, switch1.u3) annotation (Line(points={{-118,100},{-66,100},{
          -66,0},{38,0}}, color={0,0,127}));
  connect(switch1.y, yHtgStpVAV) annotation (Line(points={{61,8},{84,8},{84,-30},
          {120,-30}}, color={0,0,127}));
  connect(TCooSet, add1.u2) annotation (Line(points={{-118,72},{-78,72},{-78,
          -58},{-2,-58}}, color={0,0,127}));
  connect(TCooSet, yClgStpWin) annotation (Line(points={{-118,72},{-78,72},{-78,
          40},{120,40}}, color={0,0,127}));
  connect(add1.y, switch2.u1) annotation (Line(points={{22,-52},{30,-52},{30,
          -62},{38,-62}}, color={0,0,127}));
  connect(uNatVen, switch2.u2) annotation (Line(points={{-120,30},{-86,30},{-86,
          -82},{20,-82},{20,-70},{38,-70}}, color={255,0,255}));
  connect(TCooSet, switch2.u3) annotation (Line(points={{-118,72},{-78,72},{-78,
          -76},{38,-76},{38,-78}}, color={0,0,127}));
  connect(switch2.y, yClgStpVAV)
    annotation (Line(points={{61,-70},{120,-70}}, color={0,0,127}));
  connect(htgStpRelAmt.y, add2.u1) annotation (Line(points={{-39,70},{-10,70},{
          -10,76},{18,76}}, color={0,0,127}));
  annotation (defaultComponentName = "setTemRes",Documentation(info="<html>
  This block determines the VAV temperature setpoint while natural ventilation mode is on.
  <p> When natural ventilation mode turns on,
   the block adds a user-specified setpoint relaxation amount (typically 20F, ClgStpRel for cooling and HtgStpRel for heating) to produce relaxed VAV setpoints.
   <p>
  This aims to prevent the VAV from attempting to condition the room while the windows are open. 
<p>
</p>
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
          textString="T")}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-100,-100},{100,140}})));
end SetpointTempReset;
