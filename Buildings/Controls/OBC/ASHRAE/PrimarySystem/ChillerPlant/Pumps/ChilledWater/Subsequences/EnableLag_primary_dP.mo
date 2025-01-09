within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Subsequences;
block EnableLag_primary_dP
  "Sequences for enabling and disabling lag pumps for primary-only plants using differential pressure pump speed control"
  parameter Integer nPum = 2 "Total number of pumps";
  parameter Real timPer(
    final unit="s",
    final quantity="Time")=600
      "Delay time period for enabling and disabling lag pumps";
  parameter Real staCon = -0.03 "Constant used in the staging equation"
    annotation (Dialog(tab="Advanced"));
  parameter Real relFloHys = 0.01
    "Constant value used in hysteresis for checking relative flow rate"
    annotation (Dialog(tab="Advanced"));
  parameter Integer nPum_nominal(
    final max = nPum,
    final min = 1) = nPum
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(group="Nominal conditions"));
  parameter Real VChiWat_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1e-6)=0.5
    "Total plant design chilled water flow rate"
    annotation (Dialog(group="Nominal conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
      iconTransformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yUp
    "Next lag pump status, a rising edge indicates that next lag pump should be enabled"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yDown
    "Last lag pump status, a falling edge indicates that last lag pump should be disabled"
    annotation (Placement(transformation(extent={{220,-180},{260,-140}}),
      iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=timPer)
    "Check if the condition for enabling the pump has been constantly satisfied for enough time"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=timPer)
    "Check if the condition for disabling the pump has been constantly satisfied for enough time"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis enaPum(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if the condition for enabling next lag pump is satisfied"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis disPum(
    final uLow=(-1)*relFloHys,
    final uHigh=relFloHys)
    "Check if the condition for disabling last lag pump is satisfied"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter chiWatFloRat(
    final k=1/VChiWat_flow_nominal) "Chiller water flow ratio"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nPum]
    "Convert boolean input to integer number"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numOpePum(final nin=nPum)
    "Total number of operating pumps"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=-1) "Add real inputs"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Find inputs difference"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch enaNexLag
    "Enabling next lag pump"
    annotation (Placement(transformation(extent={{180,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch shuLasLag
    "Shut off last lag pump"
    annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Logical true"
    annotation (Placement(transformation(extent={{120,150},{140,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Logical false"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomPum(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomPum1(
    final k=1/nPum_nominal)
    "Pump number ratio"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=0.03)
    "Constant"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Input difference"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub3
    "Input difference"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

equation
  connect(VChiWat_flow,chiWatFloRat. u)
    annotation (Line(points={{-240,80},{-202,80}}, color={0,0,127}));
  connect(uChiWatPum,booToInt. u)
    annotation (Line(points={{-240,0},{-202,0}}, color={255,0,255}));
  connect(booToInt.y,numOpePum. u)
    annotation (Line(points={{-178,0},{-142,0}},
      color={255,127,0}));
  connect(numOpePum.y,intToRea. u)
    annotation (Line(points={{-118,0},{-102,0}}, color={255,127,0}));
  connect(sub2.y, enaPum.u)
    annotation (Line(points={{-98,100},{-82,100}}, color={0,0,127}));
  connect(sub1.y, disPum.u)
    annotation (Line(points={{-98,-160},{-82,-160}}, color={0,0,127}));
  connect(intToRea.y, addPar1.u)
    annotation (Line(points={{-78,0},{-60,0},{-60,-40},{-42,-40}},
      color={0,0,127}));
  connect(chiWatFloRat.y, sub2.u1)
    annotation (Line(points={{-178,80},{-160,80},{-160,106},{-122,106}},
      color={0,0,127}));
  connect(chiWatFloRat.y, sub1.u2)
    annotation (Line(points={{-178,80},{-160,80},{-160,-166},{-122,-166}},
      color={0,0,127}));
  connect(con.y, enaNexLag.u1)
    annotation (Line(points={{142,160},{160,160},{160,108},{178,108}},
      color={255,0,255}));
  connect(shuLasLag.y, yDown)
    annotation (Line(points={{202,-160},{240,-160}}, color={255,0,255}));
  connect(enaNexLag.y, yUp)
    annotation (Line(points={{202,100},{240,100}}, color={255,0,255}));
  connect(con1.y, enaNexLag.u3)
    annotation (Line(points={{122,0},{140,0},{140,92},{178,92}},
      color={255,0,255}));
  connect(intToRea.y, nomPum.u)
    annotation (Line(points={{-78,0},{-2,0}}, color={0,0,127}));
  connect(addPar1.y, nomPum1.u)
    annotation (Line(points={{-18,-40},{-2,-40}},  color={0,0,127}));
  connect(enaPum.y, truDel.u)
    annotation (Line(points={{-58,100},{38,100}}, color={255,0,255}));
  connect(truDel.y, enaNexLag.u2)
    annotation (Line(points={{62,100},{178,100}}, color={255,0,255}));
  connect(disPum.y, truDel1.u)
    annotation (Line(points={{-58,-160},{38,-160}}, color={255,0,255}));
  connect(truDel1.y, shuLasLag.u2)
    annotation (Line(points={{62,-160},{178,-160}}, color={255,0,255}));
  connect(nomPum.y, sub3.u1)
    annotation (Line(points={{22,0},{30,0},{30,46},{58,46}}, color={0,0,127}));
  connect(nomPum1.y, sub.u1) annotation (Line(points={{22,-40},{30,-40},{30,-34},
          {58,-34}}, color={0,0,127}));
  connect(con2.y, sub3.u2) annotation (Line(points={{22,-80},{40,-80},{40,34},{58,
          34}}, color={0,0,127}));
  connect(con2.y, sub.u2) annotation (Line(points={{22,-80},{40,-80},{40,-46},{58,
          -46}}, color={0,0,127}));
  connect(sub3.y, sub2.u2) annotation (Line(points={{82,40},{100,40},{100,70},{-140,
          70},{-140,94},{-122,94}}, color={0,0,127}));
  connect(sub.y, sub1.u1) annotation (Line(points={{82,-40},{100,-40},{100,-120},
          {-140,-120},{-140,-154},{-122,-154}}, color={0,0,127}));
  connect(con.y, shuLasLag.u1) annotation (Line(points={{142,160},{160,160},{160,
          -152},{178,-152}}, color={255,0,255}));
  connect(con1.y, shuLasLag.u3) annotation (Line(points={{122,0},{140,0},{140,-168},
          {178,-168}}, color={255,0,255}));
annotation (
  defaultComponentName="enaLagChiPum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,150},{100,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,52},{-38,30}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VChiWat_flow"),
        Text(
          extent={{-98,-24},{-34,-48}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uChiWatPum"),
        Text(
          extent={{64,48},{98,34}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yUp"),
        Text(
          extent={{62,-26},{96,-50}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="yDown")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-200},{220,200}})),
  Documentation(info="<html>
<p>
Block that enable and disable lag primary chilled water pump, for plants
with headered primary chilled water pumps,
according to ASHRAE Guideline36-2021,
section 5.20.6 Primary chilled water pumps, part 5.20.6.6.
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
