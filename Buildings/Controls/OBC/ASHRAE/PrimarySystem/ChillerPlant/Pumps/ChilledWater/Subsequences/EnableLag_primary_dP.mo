within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLag_primary_dP
  "Sequences for enabling lag pump for primary-only plants using differential pressure pump speed control"
  parameter Integer nPum = 2 "Total number of pumps";
  parameter Integer nPum_nominal(final max = nPum, final min = 0) = 1
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.VolumeFlowRate VChiWat_flow_nominal(final min=1e-6)
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Chilled water flow"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-180,-40},{-140,0}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yNexLagPum
    "Next lag pump status"
    annotation (Placement(transformation(extent={{140,10},{160,30}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLasLagPum
    "Last lag pump status"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Gain chiWatFloRat(
    final k=1/VChiWat_flow_nominal)
    "Chiller water flow ratio"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer number"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(final nin=nPum)
    "Total number of operating pumps"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-0.03,
    final k=1/nPum_nominal)
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1,
    final k=1)
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=-0.03,
    final k=1/nPum_nominal)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=-0.01,
    final uHigh=0.01)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.01,
    final uHigh=0.01)
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=10*60)
    "Check if the time is greater than 10 minutes"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    final threshold=10*60)
    "Check if the time is greater than 10 minutes"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch enaNexLag
    "Enabling next lag pump"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch shuLasLag
    "Shut off last lag pump"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

equation
  connect(VChiWat_flow,chiWatFloRat. u)
    annotation (Line(points={{-160,60},{-122,60}}, color={0,0,127}));
  connect(uChiWatPum,booToInt. u)
    annotation (Line(points={{-160,-20},{-82,-20}},  color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-59,-20},{-50,-20},{-50,-20},{-42,-20}},
      color={255,127,0}));
  connect(mulSumInt.y,intToRea. u)
    annotation (Line(points={{-18.3,-20},{-2,-20}}, color={255,127,0}));
  connect(intToRea.y,addPar. u)
    annotation (Line(points={{21,-20},{38,-20}}, color={0,0,127}));
  connect(add2.y,hys. u)
    annotation (Line(points={{-59,20},{-42,20}}, color={0,0,127}));
  connect(add1.y,hys1. u)
    annotation (Line(points={{-59,-100},{-42,-100}}, color={0,0,127}));
  connect(hys.y,tim. u)
    annotation (Line(points={{-19,20},{-2,20}},  color={255,0,255}));
  connect(hys1.y,tim1. u)
    annotation (Line(points={{-19,-100},{-2,-100}},color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{21,20},{38,20}}, color={0,0,127}));
  connect(tim1.y, greEquThr1.u)
    annotation (Line(points={{21,-100},{38,-100}}, color={0,0,127}));
  connect(addPar1.y, addPar2.u)
    annotation (Line(points={{-59,-60},{-42,-60}}, color={0,0,127}));
  connect(addPar.y, add2.u2)
    annotation (Line(points={{61,-20},{70,-20},{70,0},{-90,0},{-90,14},{-82,14}},
      color={0,0,127}));
  connect(intToRea.y, addPar1.u)
    annotation (Line(points={{21,-20},{30,-20},{30,-40},{-90,-40},
      {-90,-60},{-82,-60}}, color={0,0,127}));
  connect(addPar2.y, add1.u1)
    annotation (Line(points={{-19,-60},{-10,-60},{-10,-80},{-90,-80},
      {-90,-94},{-82,-94}}, color={0,0,127}));
  connect(chiWatFloRat.y, add2.u1)
    annotation (Line(points={{-99,60},{-90,60},{-90,26},{-82,26}}, color={0,0,127}));
  connect(chiWatFloRat.y, add1.u2)
    annotation (Line(points={{-99,60},{-90,60},{-90,36},{-100,36},
      {-100,-106},{-82,-106}}, color={0,0,127}));
  connect(greEquThr.y, enaNexLag.u2)
    annotation (Line(points={{61,20},{98,20}}, color={255,0,255}));
  connect(con1.y, enaNexLag.u3)
    annotation (Line(points={{21,60},{80,60},{80,12},{98,12}}, color={255,0,255}));
  connect(con.y, enaNexLag.u1)
    annotation (Line(points={{21,100},{90,100},{90,28},{98,28}}, color={255,0,255}));
  connect(greEquThr1.y, shuLasLag.u2)
    annotation (Line(points={{61,-100},{98,-100}}, color={255,0,255}));
  connect(con1.y, shuLasLag.u1)
    annotation (Line(points={{21,60},{80,60},{80,-92},{98,-92}}, color={255,0,255}));
  connect(con.y, shuLasLag.u3)
    annotation (Line(points={{21,100},{90,100},{90,-108},{98,-108}}, color={255,0,255}));
  connect(shuLasLag.y, yLasLagPum)
    annotation (Line(points={{121,-100},{150,-100}}, color={255,0,255}));
  connect(enaNexLag.y, yNexLagPum)
    annotation (Line(points={{121,20},{150,20}}, color={255,0,255}));

annotation (
  defaultComponentName="enaLagChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,52},{-38,30}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-24},{-34,-48}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{34,54},{98,30}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yNexLagPum"),
        Text(
          extent={{32,-26},{96,-50}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yLasLagPum")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,120}})),
  Documentation(info="<html>
<p>
Block that enable and disable leading primary chilled water pump, for plants
with headered primary chilled water pumps, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.6 Primary chilled water pumps, part 5.2.6.4.
</p>
<p>
Chilled water pump shall be staged as a function of chilled water flow ratio (CHWFR), 
i.e. the ratio of current chilled water flow <code>VChiWat_flow</code> to design
flow <code>VChiWat_flow_nominal</code>, and the number of pumps <code>num_nominal</code>
that operate at design conditions. Pumps are assumed to be equally sized.
</p>
<pre>
                  VChiWat_flow
     CHWFR = ---------------------- 
              VChiWat_flow_nominal
</pre>
<p>
1. Start the next lag pump <code>yNexLagPum</code> whenever the following is 
true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps
     CHWFR &gt; ---------------------------  - 0.03 
                       num_nominal
</pre>
<p>
2. Shut off the last lag pump whenever the following is true for 10 minutes:
</p>
<pre>
              Number_of_operating_pumps - 1
     CHWFR &le; -------------------------------  - 0.03 
                       num_nominal
</pre>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableLag_primary_dP;
