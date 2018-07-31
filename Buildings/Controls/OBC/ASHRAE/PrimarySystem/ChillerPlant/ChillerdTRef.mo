within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block ChillerdTRef "Calculate actual partial load ratio and current chiller LIFT"

  parameter Integer cooDegDay65 = 948
    "Cooling degree-days base 18.33 degC (65 degF)"
    annotation(Dialog(group="Design conditions"));
  parameter Integer wetBulCooDegDay55 = 1094
    "Webbulb cooling degree-days base 12.78 degC (55 degF)"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.Temperature TWetBul_nominal
    "Design wetbulb temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.TemperatureDifference APPROACH_nominal
    "Design tower leaving water temperature minus design wetbulb temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Real cooTowEff
    "Tower efficiency per ASHRAE standard 90.1, gpm/hp"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal
    "Design condenser water return temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal
    "Design chilled water supply temperature"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.HeatFlowRate plaCap_nominal(displayUnit = "kW")
    "Total design plant capacity"
    annotation(Dialog(group="Design conditions"));
  parameter Modelica.SIunits.TemperatureDifference dTRefMin
    "Minimum LIFT at minimum load"
    annotation(Dialog(group="Design conditions"));
  parameter Boolean use_simCoe = true
    "Indicate if use simplified coefficients, it recommends to use it";
  parameter Modelica.SIunits.Density rho(displayUnit = "kg/m3") = 1000
    "Density of water";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 4190
    "Specific heat capacity of water";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water return temperature"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VEva_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured chilled water supply flow rate"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yPLR(
    final min=0,
    final max=1,
    final unit = "1")
    "Actual PLR"
    annotation (Placement(transformation(extent={{160,70},{180,90}}),
      iconTransformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dTRef(
    final unit="K",
    final quantity="TemperatureDifference")
    "Chiller LIFT"
    annotation (Placement(transformation(extent={{160,-10},{180,10}}),
      iconTransformation(extent={{100,50},{120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Product chiLoa
    "Actual chiller load"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain PLR(final k=1/plaCap_nominal)
    "Partial load ratio"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeA "Coefficient A"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch coeB "Coefficient B"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain simA(final k=1/0.9)
    "Simplified A cofficient"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Add simB(final k1=-1)
    "Simplified B coefficient"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain masFlo(final k=rho)
    "Convert to mass flow rate"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Limiter lim(
    final uMax=dTRef_nominal,
    final uMin=dTRefMin)
    "LIFT shall be limited by minimum and design LIFT"
    annotation (Placement(transformation(extent={{128,-10},{148,10}})));

protected
  parameter Real a0 = -63;
  parameter Real a1 = 0.0053;
  parameter Real a2 = -0.0087;
  parameter Real a3 = 1.67;
  parameter Real a4 = 0.52;
  parameter Real a5 = -0.029;
  parameter Real b0 = 18;
  parameter Real b1 = -0.0033;
  parameter Real b2 = 0.0053;
  parameter Real b3 = -0.26;
  parameter Real b4 = 0.15;
  parameter Real b5 = -0.014;
  parameter Modelica.SIunits.TemperatureDifference dTRef_nominal=
    TConWatRet_nominal - TChiWatSup_nominal
    "LIFT at design conditions "
    annotation(Dialog(group="Design conditions"));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regA(
    k=a0 + a1*cooDegDay65 + a2*wetBulCooDegDay55 + a3*((TWetBul_nominal-273.15)*9/5+32)
         + a4*APPROACH_nominal*9/5 + a5*cooTowEff)
    "Regressed A coefficient"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant regB(
    k=b0 + b1*cooDegDay65 + b2*wetBulCooDegDay55 + b3*((TWetBul_nominal-273.15)*9/5+32)
         + b4*APPROACH_nominal*9/5 + b5*cooTowEff)
    "Regressed B coefficient"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant simCoe(k=use_simCoe)
    "Simplified cofficients indicator"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minLif(
    final k=dTRefMin*9/5)
    "Minimum LIFT at minimum load"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desLif(
    final k=dTRef_nominal*9/5)
    "LIFT at design conditions"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add difLif(k1=-1)
    "Design and minimum LIFT difference"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gain(k=cp)
    "Gain factor of specific heat capacity"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    annotation (Placement(transformation(extent={{80,34},{100,54}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1)
    "Supply and return chilled water temperature difference"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain dF2dT(final k=5/9)
    "Convert from Farenheit difference to Kelvin difference"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));

equation
  connect(VEva_flow, masFlo.u)
          annotation (Line(points={{-180,20},{-150,20},{-150,40},{-142,40}},
          color={0,0,127}));
  connect(masFlo.y, gain.u)
          annotation (Line(points={{-119,40},{-102,40}}, color={0,0,127}));
  connect(TChiWatSup, add2.u1)
          annotation (Line(points={{-180,100},{-140,100},{-140,96},{-122,96}},
          color={0,0,127}));
  connect(TChiWatRet, add2.u2)
          annotation (Line(points={{-180,60},{-140,60},{-140,84},{-122,84}},
          color={0,0,127}));
  connect(add2.y, chiLoa.u1)
          annotation (Line(points={{-99,90},{-70,90},{-70,86},{-62,86}},
          color={0,0,127}));
  connect(gain.y, chiLoa.u2)
          annotation (Line(points={{-79,40},{-70,40},{-70,74},{-62,74}},
          color={0,0,127}));
  connect(chiLoa.y, PLR.u)
          annotation (Line(points={{-39,80},{-22,80}}, color={0,0,127}));
  connect(difLif.y, simA.u)
          annotation (Line(points={{-79,-10},{-62,-10}}, color={0,0,127}));
  connect(minLif.y, difLif.u1)
          annotation (Line(points={{-119,-10},{-110,-10},{-110,-4},{-102,-4}},
          color={0,0,127}));
  connect(simA.y, simB.u1)
          annotation (Line(points={{-39,-10},{-32,-10},{-32,-34},{-12,-34}},
          color={0,0,127}));
  connect(simA.y, coeA.u1)
          annotation (Line(points={{-39,-10},{-32,-10},{-32,-2},{-12,-2}},
          color={0,0,127}));
  connect(regA.y, coeA.u3)
          annotation (Line(points={{-39,-100},{-20,-100},{-20,-18},{-12,-18}},
          color={0,0,127}));
  connect(simB.y, coeB.u1)
          annotation (Line(points={{11,-40},{20,-40},{20,-32},{38,-32}},
          color={0,0,127}));
  connect(simCoe.y, coeA.u2)
          annotation (Line(points={{-79,-80},{-26,-80},{-26,-10},{-12,-10}},
          color={255,0,255}));
  connect(regB.y, coeB.u3)
          annotation (Line(points={{11,-100},{32,-100},{32,-48},{38,-48}},
          color={0,0,127}));
  connect(simCoe.y, coeB.u2)
          annotation (Line(points={{-79,-80},{26,-80},{26,-40},{38,-40}},
          color={255,0,255}));
  connect(PLR.y, pro.u1)
          annotation (Line(points={{1,80},{20,80},{20,56},{38,56}},
          color={0,0,127}));
  connect(coeA.y, pro.u2)
          annotation (Line(points={{11,-10},{20,-10},{20,44},{38,44}},
          color={0,0,127}));
  connect(coeB.y, add1.u2)
          annotation (Line(points={{61,-40},{70,-40},{70,38},{78,38}},
          color={0,0,127}));
  connect(pro.y, add1.u1)
          annotation (Line(points={{61,50},{78,50}},
          color={0,0,127}));
  connect(PLR.y, yPLR)
          annotation (Line(points={{1,80},{170,80}}, color={0,0,127}));
  connect(desLif.y, difLif.u2)
          annotation (Line(points={{-119,-50},{-108,-50},{-108,-16},{-102,-16}},
          color={0,0,127}));
  connect(lim.y, dTRef)
          annotation (Line(points={{149,0},{170,0}}, color={0,0,127}));
  connect(desLif.y, simB.u2)
          annotation (Line(points={{-119,-50},{-108,-50},{-108,-46},{-12,-46}},
          color={0,0,127}));
  connect(add1.y, dF2dT.u)
          annotation (Line(points={{101,44},{108,44},{108,20},{80,20},{80,0},{92,0}},
          color={0,0,127}));
  connect(dF2dT.y, lim.u)
          annotation (Line(points={{115,0},{126,0}}, color={0,0,127}));

annotation (
  defaultComponentName = "chillerdTRef",
  Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,72},{-42,50}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSup"),
        Text(
          extent={{-96,12},{-42,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatRet"),
        Text(
          extent={{-96,-48},{-42,-70}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VEva_flow"),
        Text(
          extent={{58,68},{100,52}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="dTRef"),
        Text(
          extent={{58,-52},{100,-68}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yPLR"),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-120},{160,120}})),
  Documentation(info="<html>
<p>
Block that output chiller LIFT <code>dTRef</code> and actual partial load ratio 
(<code>yPLR</code>) according to &quot;ASHRAE Fundamentals of Chilled Water 
Plant Design and Control SDL&quot;, Chapter 7, Appendix A, section Condenser 
water temperature control.
</p>
<h4>Actual plant part load ratio <code>yPLR</code></h4>
<p>
<code>yPLR</code> equals to calculated load divided by total chiller design load 
(<code>plaCap_nominal</code>). Following equation is used:
</p>
<pre>
  yPLR = (rho*VEva_flow*cp*(TChiWatRet-TChiWatSup)) / plaCap_nominal
</pre>
<p>
in which, <code>TChiWatSup</code> is measured chilled water supply, 
<code>TChiWatRet</code> is return temperature, <code>VEva_flow</code> is the 
supply flow rate.
</p>
<h4>Chiller dTRef</h4>
<p>
<code>dTRef</code> shall be no smaller than <code>dTRefMin</code> and no larger than 
<code>dTRef_nominal</code>. It can be calculated as:
</p>
<pre>
  dTRef = (A*PLR + B)*5/9
</pre>
<p>
in which, the coefficient A and B can be found out with one of following:
</p>
<ul>
<li>Regressed coefficients (use with care)</li>
</ul>
<pre>
A = -63 + 0.0053*cooDegDay65 - 0.0087*wetBulCooDegDay55 + 1.67*((TWetBul_nominal-273.15)*9/5+32) 
        + 0.52*APPROACH_nominal*9/5 - 0.029*cooTowEff
B = 18 - 0.0033*cooDegDay65 + 0.0053*wetBulCooDegDay55 - 0.26*((TWetBul_nominal-273.15)*9/5+32) 
       + 0.15*APPROACH_nominal*9/5 - 0.014*cooTowEff 
</pre>

<p>
Where <code>cooDegDay65</code> is Cooling degree-days base 65 degF, 
<code>wetBulCooDegDay55</code> is Webbulb cooling degree-days base 55 degF, 
<code>TWetBul_nominal</code> is Design wetbulb temperature,
<code>APPROACH_nominal</code> is Design tower leaving water temperature minus design 
wetbulb temperature, 
<code>cooTowEff</code> is Tower efficiency per ASHRAE standard 90.1
</p>
<ul>
<li>Simplified coefficients (recommended)</li>
</ul>
<pre>
A = (dTRef_nominal - dTRefMin)/0.9
B = dTRef_nominal - A
</pre>

<p>
where <code>dTRef_nominal</code> is dTRef at design conditions 
(<code>TConWatRet_nominal</code> - <code>TChiWatSup_nominal</code>), 
<code>dTRefMin</code> is Minimum dTRef at minimum load.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 05, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerdTRef;
