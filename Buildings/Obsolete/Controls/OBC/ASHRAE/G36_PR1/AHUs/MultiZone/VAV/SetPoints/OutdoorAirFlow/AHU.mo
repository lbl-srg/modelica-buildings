within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow;
block AHU "Output outdoor airflow related calculations at the AHU level"

  parameter Real VPriSysMax_flow(unit="m3/s")
    "Maximum expected system primary airflow at design stage"
    annotation(Dialog(group="Nominal condition"));

  parameter Real peaSysPop(final unit="1")
    "Peak system population"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput sumDesZonPop(
    final min=0,
    final unit="1")
    "Sum of the design population of the zones in the group"
    annotation (Placement(transformation(extent={{-260,180},{-220,220}}),
        iconTransformation(extent={{-140,70},{-100,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-140,50},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesSysVenEff(
    final min=0,
    final unit="1")
    "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-260,-44},{-220,-4}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumSysPriAir_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
    final min=0,
    final unit="1")
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status, true if on, false if off"
    annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-260,-200},{-220,-160}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
        iconTransformation(extent={{100,60},{140,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAveOutAirFraPlu(
    final min=0,
    final unit="1")
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{240,110},{280,150}}),
        iconTransformation(extent={{100,30},{140,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,10},{280,50}}),
        iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput effOutAir_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by VDesOutMin_flow_nominal"
    annotation (Placement(transformation(extent={{240,-70},{280,-30}}),
        iconTransformation(extent={{100,-70},{140,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReqOutAir
    "True if the AHU supply fan is on and the zone is in occupied mode"
    annotation (Placement(transformation(extent={{240,-160},{280,-120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Divide outAirFra
    "System outdoor air fraction"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=1)
    "System outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Reals.Subtract sysVenEff
    "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Reals.Divide effMinOutAirInt
    "Effective minimum outdoor air setpoint"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Reals.Divide occDivFra
    "Occupant diversity fraction"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

  Buildings.Controls.OBC.CDL.Reals.Add unCorOutAirInk
    "Uncorrected outdoor air intake"
    annotation (Placement(transformation(extent={{0,140},{20,160}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply pro "Product of inputs"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter aveOutAirFra(
    final k=1/VPriSysMax_flow) "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(
    final p=1)
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.CDL.Reals.Divide desOutAirInt
    "Design system outdoor air intake"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Reals.Min min
    "Minimum outdoor airflow rate should not be more than designed outdoor airflow rate"
    annotation (Placement(transformation(extent={{180,20},{200,40}})));

  Buildings.Controls.OBC.CDL.Reals.Min sysUncOutAir
    "Uncorrected outdoor air rate should not be higher than its design value"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-180,-230},{-160,-210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant peaSysPopulation(
    final k=peaSysPop)
    "Peak system population"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant smaSysEff(
    final k=1E-4)
    "Set system ventilation efficiency to small value to avoid division by zero"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Divide norVOutMin
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Max sysVenEffNonZero
    "Current system ventilation efficiency, bounded away from zero"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

equation
  connect(peaSysPopulation.y, occDivFra.u1)
    annotation (Line(points={{-158,220},{-140,220},{-140,196},{-122,196}},
      color={0,0,127}));
  connect(pro.y, unCorOutAirInk.u1)
    annotation (Line(points={{-38,170},{-20,170},{-20,156},{-2,156}},
      color={0,0,127}));
  connect(aveOutAirFra.y, addPar1.u)
    annotation (Line(points={{82,130},{118,130}},color={0,0,127}));
  connect(unCorOutAirInk.y, desOutAirInt.u1)
    annotation (Line(points={{22,150},{40,150},{40,86},{58,86}},    color={0,0,127}));
  connect(sysUncOutAir.y, effMinOutAirInt.u1) annotation (Line(points={{-158,10},
          {-140,10},{-140,26},{98,26}}, color={0,0,127}));
  connect(sysUncOutAir.y, outAirFra.u1) annotation (Line(points={{-158,10},{-140,
          10},{-140,-4},{-122,-4}}, color={0,0,127}));
  connect(unCorOutAirInk.y, sysUncOutAir.u1) annotation (Line(points={{22,150},{
          40,150},{40,50},{-200,50},{-200,16},{-182,16}}, color={0,0,127}));
  connect(desOutAirInt.y, min.u1)
    annotation (Line(points={{82,80},{140,80},{140,36},{178,36}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, VDesUncOutAir_flow)
    annotation (Line(points={{22,150},{40,150},{40,180},{260,180}},
      color={0,0,127}));
  connect(desOutAirInt.y, VDesOutAir_flow)
    annotation (Line(points={{82,80},{260,80}}, color={0,0,127}));
  connect(occDivFra.y, pro.u1)
    annotation (Line(points={{-98,190},{-80,190},{-80,176},{-62,176}},
      color={0,0,127}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-240,-180},{-102,-180}},color={255,127,0}));
  connect(occMod.y, intEqu1.u2)
    annotation (Line(points={{-158,-220},{-140,-220},{-140,-188},{-102,-188}},
      color={255,127,0}));
  connect(intEqu1.y, and1.u2)
    annotation (Line(points={{-78,-180},{20,-180},{20,-148},{118,-148}},
      color={255,0,255}));
  connect(outAirFra.y, addPar.u)
    annotation (Line(points={{-98,-10},{-82,-10}}, color={0,0,127}));
  connect(addPar.y, sysVenEff.u1)
    annotation (Line(points={{-58,-10},{-50,-10},{-50,-4},{-42,-4}},
      color={0,0,127}));
  connect(VEffOutAir_flow, min.y)
    annotation (Line(points={{260,30},{202,30}}, color={0,0,127}));
  connect(effMinOutAirInt.y, min.u2)
    annotation (Line(points={{122,20},{160,20},{160,24},{178,24}},
      color={0,0,127}));
  connect(norVOutMin.u1, min.y)
    annotation (Line(points={{178,-44},{160,-44},{160,-10},{220,-10},
      {220,30},{202,30}}, color={0,0,127}));
  connect(desOutAirInt.y, norVOutMin.u2)
    annotation (Line(points={{82,80},{140,80},{140,-56},{178,-56}},
      color={0,0,127}));
  connect(norVOutMin.y, effOutAir_normalized)
    annotation (Line(points={{202,-50},{260,-50}}, color={0,0,127}));
  connect(uSupFan, and1.u1)
    annotation (Line(points={{-240,-140},{118,-140}},
      color={255,0,255}));
  connect(addPar1.y, yAveOutAirFraPlu)
    annotation (Line(points={{142,130},{260,130}},color={0,0,127}));
  connect(occDivFra.u2, sumDesZonPop)
    annotation (Line(points={{-122,184},{-200,184},{-200,200},{-240,200}},
      color={0,0,127}));
  connect(pro.u2, VSumDesPopBreZon_flow) annotation (Line(points={{-62,164},{-200,
          164},{-200,160},{-240,160}}, color={0,0,127}));
  connect(unCorOutAirInk.u2, VSumDesAreBreZon_flow) annotation (Line(points={{-2,144},
          {-200,144},{-200,120},{-240,120}},      color={0,0,127}));
  connect(desOutAirInt.u2, uDesSysVenEff) annotation (Line(points={{58,74},{-80,
          74},{-80,80},{-240,80}}, color={0,0,127}));
  connect(sysUncOutAir.u2, VSumUncOutAir_flow) annotation (Line(points={{-182,4},
          {-200,4},{-200,-24},{-240,-24}}, color={0,0,127}));
  connect(outAirFra.u2, VSumSysPriAir_flow) annotation (Line(points={{-122,-16},
          {-140,-16},{-140,-60},{-240,-60}}, color={0,0,127}));
  connect(sysVenEff.u2, uOutAirFra_max)
    annotation (Line(points={{-42,-16},{-50,-16},{-50,-100},{-240,-100}},
      color={0,0,127}));
  connect(and1.y, yReqOutAir)
    annotation (Line(points={{142,-140},{260,-140}}, color={255,0,255}));
  connect(aveOutAirFra.u, unCorOutAirInk.y) annotation (Line(points={{58,130},{40,
          130},{40,150},{22,150}}, color={0,0,127}));
  connect(sysVenEff.y, sysVenEffNonZero.u1) annotation (Line(points={{-18,-10},{
          -10,-10},{-10,-4},{-2,-4}}, color={0,0,127}));
  connect(smaSysEff.y, sysVenEffNonZero.u2) annotation (Line(points={{-18,-50},
          {-8,-50},{-8,-16},{-2,-16}}, color={0,0,127}));
  connect(sysVenEffNonZero.y, effMinOutAirInt.u2) annotation (Line(points={{22,-10},
          {92,-10},{92,14},{98,14}}, color={0,0,127}));
annotation (
  defaultComponentName="ahuOutAirSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,158},{100,118}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,98},{-34,86}},
          textColor={0,0,0},
          textString="sumDesZonPop"),
        Text(
          extent={{-96,-62},{-52,-76}},
          textColor={255,0,255},
          textString="uSupFan"),
        Text(
          extent={{-96,-82},{-50,-96}},
          textColor={255,127,0},
          textString="uOpeMod"),
        Text(
          extent={{-98,78},{-12,62}},
          textColor={0,0,0},
          textString="VDesPopBreZon_flow"),
        Text(
          extent={{-98,58},{-12,42}},
          textColor={0,0,0},
          textString="VDesAreBreZon_flow"),
        Text(
          extent={{-98,38},{-34,26}},
          textColor={0,0,0},
          textString="desSysVenEff"),
        Text(
          extent={{-98,18},{-30,4}},
          textColor={0,0,0},
          textString="VUncOutAir_flow"),
        Text(
          extent={{-98,-2},{-34,-18}},
          textColor={0,0,0},
          textString="VSysPriAir_flow"),
        Text(
          extent={{-98,-22},{-28,-38}},
          textColor={0,0,0},
          textString="uOutAirFra_max"),
        Text(
          extent={{42,-74},{102,-86}},
          textColor={255,0,255},
          textString="yReqOutAir"),
        Text(
          extent={{20,88},{96,72}},
          textColor={0,0,0},
          textString="VDesUncOutAir_flow"),
        Text(
          extent={{30,60},{98,44}},
          textColor={0,0,0},
          textString="yAveOutAirFraPlu"),
        Text(
          extent={{34,30},{98,12}},
          textColor={0,0,0},
          textString="VDesOutAir_flow"),
        Text(
          extent={{38,-10},{98,-26}},
          textColor={0,0,0},
          textString="VEffOutAir_flow"),
        Text(
          extent={{18,-40},{98,-56}},
          textColor={0,0,0},
          textString="effOutAir_normalized")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-240},{240,240}})),
Documentation(info="<html>
<p>
This sequence outputs AHU level design minimum outdoor airflow rate
<code>VDesOutAir_flow</code> and effective minimum outdoor airflow rate
<code>VEffOutAir_flow</code>.
</p>
<p>
It requires following inputs which are sum, maximum or minimum of the outputs from
the zone level calculation:
</p>
<ol>
<li>
Sum of the design population of the zones in the group, <code>sumDesZonPop</code>.
</li>
<li>
Sum of the population component design breathing zone flow rate,
<code>VSumDesPopBreZon_flow</code>.
</li>
<li>
Sum of the area component design breathing zone flow rate,
<code>VSumDesAreBreZon_flow</code>.
</li>
<li>
Minimum of all zones ventilation efficiency, <code>uDesSysVenEff</code>.
</li>
<li>
Sum of all zones required uncorrected outdoor airflow rate, <code>VSumUncOutAir_flow</code>.
</li>
<li>
Sum of the measured discharged flow rate of all terminal units,
<code>VSumSysPriAir_flow</code>.
</li>
<li>
Maximum of primary outdoor air fraction of all zones, <code>uOutAirFra_max</code>.
</li>
</ol>
<p>
The calculation is done using the steps below.
</p>
<ol>
<li>
<p>
Compute the occupancy diversity fraction <code>occDivFra</code>.
During system operation, the system population equals the sum of the zone population,
so <code>occDivFra=1</code>. It has no impact on the calculation of the uncorrected
outdoor airflow <code>sysUncOutAir</code>.
For design purpose, compute for all zones
</p>
<pre>
    occDivFra = peaSysPop/sumDesZonPop
</pre>
<p>
where <code>peaSysPop</code> is the peak system population and
<code>sumDesZonPop</code> is the sum of the design population.
</p>
</li>
<li>
<p>
Compute the design uncorrected outdoor airflow rate <code>VDesUncOutAir_flow</code> as
</p>
<pre>
    VDesUncOutAir_flow = occDivFra*VSumDesPopBreZon_flow+VSumDesAreBreZon_flow.
</pre>
</li>
<li>
<p>
Compute the uncorrected outdoor airflow rate <code>sysUncOutAir</code> as
</p>
<pre>
    sysUncOutAir = min(VDesUncOutAir_flow, VSumUncOutAir_flow)
</pre>
<p>
where <code>VSumUncOutAir_flow</code> is sum of all zones required uncorrected
outdoor airflow rate
</p>
</li>
<li>
<p>
Compute the outdoor air fraction as
</p>
<pre>
    outAirFra = sysUncOutAir/VSumSysPriAir_flow.
</pre>
<p>
For design purpose, use
</p>
<pre>
    aveOutAirFra = sysUncOutAir/VPriSysMax_flow.
</pre>
<p>
where <code>VPriSysMax_flow</code> is the maximum expected system primary airflow
at design stage.
</p>
</li>
<li>
<p>
Compute the system ventilation efficiency <code>sysVenEff</code>. During system
operation, the efficiency is
</p>
<pre>
    sysVenEff = 1 + outAirFra - uOutAirFra_max
</pre> 
</li>
<li>
<p>
Compute the minimum required AHU outdoor air intake flow rate.
The minimum required system outdoor air intake flow should be the uncorrected
outdoor air intake <code>sysUncOutAir</code> divided by the system ventilation
efficiency <code>sysVenEff</code>, but it should not be larger than the design
outdoor air rate <code>desOutAirInt</code>. Hence,
</p>
<pre>
    effMinOutAirInt = min(sysUncOutAir/sysVenEff, desOutAirInt),
</pre>
<p>
where the design outdoor air rate <code>desOutAirInt</code> is
</p>
<pre>
    desOutAirInt = VDesUncOutAir_flow/uDesSysVenEff.
</pre>
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
September 9, 2022, by Michael Wetter:<br/>
Replaced hysteresis with <code>max</code> function to avoid chattering when the fan switches on.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3106\">#3106</a>.
</li>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Separated from original sequence of finding the system minimum outdoor air setpoint.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
February 27, 2020, by Jianjun Hu:<br/>
Applied hysteresis for checking ventilation efficiency.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1787\">#1787</a>.
</li>
<li>
January 30, 2020, by Michael Wetter:<br/>
Removed the use of <code>fill</code> when assigning the <code>unit</code> attribute.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1728\">#1728</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AHU;
