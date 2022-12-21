within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block ChillerGroupCommand
  "Block that converts command signals for chiller group"

  parameter Integer nChi(final min=1, start=1)
    "Number of chillers"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1On[nChi]
    "Chiller On/Off signal" annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1On
    "Chiller On/Off signal" annotation (Placement(transformation(extent={{100,-20},
            {140,20}}), iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi]
    "Convert to real"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=nChi) "Total"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Returns true if at least one unit is commanded on"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nChiOnBou
    "Number of chillers that are commanded On, with lower bound of 1"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 "Maximum value"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nChiOn
    "Number of chillers that are commanded On, unbounded" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent
          ={{100,-80},{140,-40}})));
equation
  connect(u1On, booToRea.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={255,0,255}));
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(greThr.y, y1On)
    annotation (Line(points={{42,0},{120,0}}, color={255,0,255}));
  connect(mulSum.y, greThr.u)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(one.y, max1.u1) annotation (Line(points={{-18,80},{0,80},{0,66},{68,
          66}},
        color={0,0,127}));
  connect(mulSum.y, max1.u2)
    annotation (Line(points={{-18,0},{0,0},{0,54},{68,54}}, color={0,0,127}));
  connect(max1.y, nChiOnBou)
    annotation (Line(points={{92,60},{120,60}}, color={0,0,127}));
  connect(mulSum.y, nChiOn) annotation (Line(points={{-18,0},{0,0},{0,-60},{120,
          -60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ChillerGroupCommand;
