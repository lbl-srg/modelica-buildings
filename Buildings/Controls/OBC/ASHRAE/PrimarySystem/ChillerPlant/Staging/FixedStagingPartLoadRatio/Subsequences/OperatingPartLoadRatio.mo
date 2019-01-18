within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.FixedStagingPartLoadRatio.Subsequences;
block OperatingPartLoadRatio
  "Stage operating part load ratio (current, up, down and minimum)"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real staUpMult1 = 0.8
  "Multiplies operating part load ratio to get the stage up part load ratio";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCapNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUpCapMin(
    final unit="W",
    final quantity="Power") "Minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDowCapNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next lower stage"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final unit="1", min = 0)
    "Operating part load ratio"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
                            iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaDow(
    final unit="1", min = 0)
    "Stage down part load ratio"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUp(
    final unit="1", min = 0)
    "Stage up part load ratio"
    annotation (Placement(transformation(extent={{180,50},{200,70}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaUpMin(
    final unit="1", min = 0)
    "Stage up minimal part load ratio"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}}),
                    iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Division opePlrSta
    "Calculates operating part load ratio at the current stage"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));


  CDL.Continuous.Division staDowPlr "Calculates stage down part load ratio"
    annotation (Placement(transformation(extent={{-38,-192},{-18,-172}})));
  CDL.Continuous.Product staUpPlr "Calculates stage up part load ratio"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Continuous.Sources.Constant staUpMult(k=staUpMult1)
    "Stage up multiplier for the operating part load ratio"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-200,0},{-160,0},{-160,
          36},{-42,36}},       color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-200,60},{-80,60},
          {-80,24},{-42,24}}, color={0,0,127}));
  connect(opePlrSta.y, y) annotation (Line(points={{-19,30},{120,30},{120,0},{190,
          0}}, color={0,0,127}));
  connect(opePlrSta.y, staUpPlr.u1) annotation (Line(points={{-19,30},{0,30},{0,
          -4},{18,-4}}, color={0,0,127}));
  connect(staUpMult.y, staUpPlr.u2) annotation (Line(points={{-19,-30},{0,-30},{
          0,-16},{18,-16}}, color={0,0,127}));
  connect(staUpPlr.y, yStaUp) annotation (Line(points={{41,-10},{80,-10},{80,60},
          {190,60}}, color={0,0,127}));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-200},{180,200}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperatingPartLoadRatio;
