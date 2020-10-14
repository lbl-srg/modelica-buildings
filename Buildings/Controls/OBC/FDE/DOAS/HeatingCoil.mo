within Buildings.Controls.OBC.FDE.DOAS;
block HeatingCoil
  "This block commands the heating coil."

  parameter Real SArhcPIk = 0.0000001
  "Heating coil SAT PI gain value k.";

  parameter Real SArhcPITi = 0.000025
  "Heating coil SAT PI time constant value Ti.";

    // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput supFanProof
    "True when supply fan is proven on."
    annotation (Placement(transformation(extent={{-142,-20},{-102,20}}),
        iconTransformation(extent={{-142,-20},{-102,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput saT
    "Supply air temperature sensor value."
    annotation (Placement(transformation(extent={{-142,-60},{-102,-20}}),
        iconTransformation(extent={{-142,-70},{-102,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput supHeaSP
    "Supply air temperature heating set point."
    annotation (Placement(transformation(extent={{-142,16},{-102,56}}),
        iconTransformation(extent={{-142,28},{-102,68}})));

    // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRHC
    "Reheat coil valve command."
    annotation (Placement(transformation(extent={{102,-20},{142,20}}),
      iconTransformation(extent={{102,-20},{142,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final k=SArhcPIk,
    final Ti=SArhcPITi)
    "PI calculation of supply air temperature and supply air heating set point"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Logical switch passes supply air heating set point when supply fan 
      is proven otherwise sends 0 set point."
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con0(
    final k=0)
    "Real constant 0"
    annotation (Placement(transformation(extent={{-52,-28},{-32,-8}})));

equation
  connect(conPID.u_s, swi.y)
    annotation (Line(points={{18,0},{2,0}}, color={0,0,127}));
  connect(swi.u2, supFanProof)
    annotation (Line(points={{-22,0},{-122,0}}, color={255,0,255}));
  connect(con0.y, swi.u3)
    annotation (Line(points={{-30,-18},{-26,-18},{-26,-8},{-22,-8}},
      color={0,0,127}));
  connect(conPID.u_m, saT)
    annotation (Line(points={{30,-12},{30,-40},{-122,-40}}, color={0,0,127}));
  connect(swi.u1, supHeaSP) annotation (Line(points={{-22,8},{-32,8},{-32,36},{-122,
          36}}, color={0,0,127}));
  connect(conPID.y, yRHC)
    annotation (Line(points={{42,0},{122,0}}, color={0,0,127}));
  annotation (defaultComponentName="Heating",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
            radius=10,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,68},{6,-66}},
          lineColor={238,46,47},
          fillColor={254,56,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,58},{68,56}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,60},{-10,54}},
          lineColor={28,108,200},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-56},{80,-58}},
          lineColor={0,0,0},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,-54},{2,-60}},
          lineColor={28,108,200},
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,-58},{30,-66},{30,-50},{42,-58}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,-58},{54,-66},{54,-50},{42,-58}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,-54},{46,-62}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{42,-48},{42,-54}}, color={127,0,0}),
        Ellipse(
          extent={{36,-32},{48,-46}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,-38},{48,-48}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
           Text(
            extent={{-90,180},{90,76}},
            lineColor={28,108,200},
            textStyle={TextStyle.Bold},
            textString="%name"),
        Text(
          extent={{-98,8},{-54,-6}},
          lineColor={28,108,200},
          textString="supFanProof"),
        Text(
          extent={{58,8},{102,-6}},
          lineColor={28,108,200},
          textString="yRHC"),
        Text(
          extent={{-98,54},{-58,44}},
          lineColor={28,108,200},
          textString="supHeaSP"),
        Text(
          extent={{-108,-42},{-68,-54}},
          lineColor={28,108,200},
          textString="saT")}),     Diagram(coordinateSystem(preserveAspectRatio=
           false)),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"));
end HeatingCoil;
