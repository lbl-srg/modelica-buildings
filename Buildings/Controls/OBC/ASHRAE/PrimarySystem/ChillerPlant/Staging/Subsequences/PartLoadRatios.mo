within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block PartLoadRatios
  "Stage operating part load ratios (current, up, down and minimum) with reset based on stage chiller type"

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real chiStaTyp[numSta] = {1,1}
  "Integer stage chiller type: 1=any constant speed centrifugal, 2=all positive displacement, 3=any variable speed centrifugal";

  parameter Real posDisMult(unit = "1", min = 0, max = 1)=0.8
  "Positive displacement chiller type staging multiplier";

  parameter Real conSpeCenMult(unit = "1", min = 0, max = 1)=0.9
  "Constant speed centrifugal chiller type staging multiplier";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCapReq(
    final unit="W",
    final quantity="Power")
    "Chilled water cooling capacity requirement"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaCapNom(
    final unit="W",
    final quantity="Power")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaUpCapMin(
    final unit="W",
    final quantity="Power") "Minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{-220,-100},{-180,-60}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uStaDowCapNom(
    final unit="W",
    final quantity="Power") "Nominal capacity of the next lower stage"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMin(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLifMax(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uLif(
    final unit="K",
    final quantity="ThermodynamicTemperature") if max(chiStaTyp) > 2.5
    "Chiller lift"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
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
  CDL.Continuous.Sources.Constant chiStaType[numSta](k=chiStaTyp)
    "Chiller stage type"
    annotation (Placement(transformation(extent={{-140,280},{-120,300}})));

  CDL.Interfaces.IntegerInput                        uSta "Chiller stage"
    annotation (Placement(transformation(extent={{-220,220},{-180,260}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Routing.RealExtractor extStaTyp "Extract stage type"
    annotation (Placement(transformation(extent={{-100,280},{-80,300}})));
  CDL.Integers.Add oneUp "Adds one"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  CDL.Integers.Sources.Constant                        one(final k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
  CDL.Integers.Add oneDown(k2=-1) "Subtracts one"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Conversions.RealToInteger curStaTyp "Current stage chiller type"
    annotation (Placement(transformation(extent={{-20,280},{0,300}})));
  CDL.Conversions.RealToInteger staUpTyp "Stage up chiller type"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  CDL.Routing.RealExtractor extStaTyp1 "Extract stage type"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  CDL.Routing.RealExtractor extStaTyp2 "Extract stage type"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  CDL.Conversions.RealToInteger staDowTyp1 "Stage down chiller type"
    annotation (Placement(transformation(extent={{-20,140},{0,160}})));
equation
  connect(uCapReq, opePlrSta.u1) annotation (Line(points={{-200,0},{-158,0},{-158,
          36},{-42,36}},       color={0,0,127}));
  connect(uStaCapNom, opePlrSta.u2) annotation (Line(points={{-200,40},{-78,40},
          {-78,24},{-42,24}}, color={0,0,127}));
  connect(opePlrSta.y, y) annotation (Line(points={{-19,30},{120,30},{120,0},{190,
          0}}, color={0,0,127}));
  connect(opePlrSta.y, staUpPlr.u1) annotation (Line(points={{-19,30},{0,30},{0,
          -4},{18,-4}}, color={0,0,127}));
  connect(staUpPlr.y, yStaUp) annotation (Line(points={{41,-10},{80,-10},{80,60},
          {190,60}}, color={0,0,127}));
  connect(chiStaType.y,extStaTyp. u)
    annotation (Line(points={{-119,290},{-102,290}},color={0,0,127}));
  connect(uSta,extStaTyp. index) annotation (Line(points={{-200,240},{-90,240},
          {-90,278}},color={255,127,0}));
  connect(one.y, oneDown.u2) annotation (Line(points={{-139,190},{-120,190},{
          -120,104},{-102,104}}, color={255,127,0}));
  connect(extStaTyp.y, curStaTyp.u)
    annotation (Line(points={{-79,290},{-22,290}}, color={0,0,127}));
  connect(one.y, oneUp.u2) annotation (Line(points={{-139,190},{-120,190},{-120,
          184},{-102,184}}, color={255,127,0}));
  connect(uSta, oneDown.u1) annotation (Line(points={{-200,240},{-112,240},{
          -112,116},{-102,116}}, color={255,127,0}));
  connect(uSta, oneUp.u1) annotation (Line(points={{-200,240},{-112,240},{-112,
          196},{-102,196}}, color={255,127,0}));
  connect(oneUp.y, extStaTyp1.index) annotation (Line(points={{-79,190},{-50,
          190},{-50,218}}, color={255,127,0}));
  connect(extStaTyp1.y, staUpTyp.u)
    annotation (Line(points={{-39,230},{-22,230}}, color={0,0,127}));
  connect(chiStaType.y, extStaTyp1.u) annotation (Line(points={{-119,290},{-110,
          290},{-110,250},{-70,250},{-70,230},{-62,230}}, color={0,0,127}));
  connect(chiStaType.y, extStaTyp2.u) annotation (Line(points={{-119,290},{-114,
          290},{-114,288},{-110,288},{-110,250},{-70,250},{-70,150},{-62,150}},
        color={0,0,127}));
  connect(oneDown.y, extStaTyp2.index) annotation (Line(points={{-79,110},{-50,
          110},{-50,138}}, color={255,127,0}));
  connect(extStaTyp2.y, staDowTyp1.u)
    annotation (Line(points={{-39,150},{-22,150}}, color={0,0,127}));
  annotation (defaultComponentName = "staChaPosDis",
        Icon(coordinateSystem(extent={{-180,-200},{180,320}}),
             graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-180,-200},{180,320}})),
Documentation(info="<html>
<p>
Fixme: This is a development version of the staging part load ratio 
calculation with chiller type reset.

Set stage chiller type to:

1 if the stage contains any constant speed centrifugal chillers
2 if the stage contains any positive displacement chillers
3 if the stage contains more than 1 variable speed centrifugal chiller

If more than one condition applies for a single stage, use the determination with the highest integer.

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
end PartLoadRatios;
