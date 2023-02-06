within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow;
block SumZone
  "Output the sum, maximum and minimum from the zone level calculation"

  parameter Integer numZon(min=2)
    "Total number of zones that the system serves";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesZonPeaOcc[numZon](
    final min = fill(0, numZon),
    final unit = fill("1", numZon))
    "Design zone peak occupancy"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDesPopBreZon_flow[numZon](
    final min = fill(0, numZon),
    final unit = fill("m3/s", numZon),
    final quantity=fill("VolumeFlowRate", numZon))
    "Population component breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDesAreBreZon_flow[numZon](
    final min = fill(0, numZon),
    final unit = fill("m3/s", numZon),
    final quantity=fill("VolumeFlowRate", numZon))
    "Area component breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput yAveOutAirFraPlu(
    final min = 0,
    final unit = "1")
    "Average system outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesPriOutAirFra[numZon](
    final min = fill(0, numZon),
    final max = fill(1, numZon),
    final unit = fill("1", numZon))
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VUncOutAir_flow[numZon](
    final min = fill(0, numZon),
    final unit = fill("m3/s", numZon),
    final quantity=fill("VolumeFlowRate", numZon))
    "Uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPriOutAirFra[numZon](
    final min = fill(0, numZon),
    final max = fill(1, numZon),
    final unit = fill("1", numZon))
    "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VPriAir_flow[numZon](
    final min = fill(0, numZon),
    final unit = fill("m3/s", numZon),
    final quantity=fill("VolumeFlowRate", numZon))
    "Primary airflow rate"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySumDesZonPop(
    final min = 0,
    final unit = "1")
    "Sum of the design population of the zones in the group"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
        iconTransformation(extent={{100,70},{140,110}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumDesPopBreZon_flow(
    final min = 0,
    final unit = "m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumDesAreBreZon_flow(
    final min = 0,
    final unit = "m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesSysVenEff(
    final min = 0,
    final unit = "1")
    "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumUncOutAir_flow(
    final min = 0,
    final unit = "m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}}),
        iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput uOutAirFra_max(
    final min = 0,
    final max = 1,
    final unit = "1")
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSumSysPriAir_flow(
    final min = 0,
    final unit = "m3/s",
    final quantity="VolumeFlowRate")
    "AHU level primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{100,-140},{140,-100}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysUncOutAir(
    final nin=numZon)
    "Uncorrected outdoor airflow"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysPriAirRate(
    final nin=numZon)
    "System primary airflow rate"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesZonPop(
    final nin=numZon)
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonPop(
    final nin=numZon)
    "Sum of the design breathing zone flow rate for population component"
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonAre(
    final nin=numZon)
    "Sum of the design breathing zone flow rate for area component"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract zonVenEff[numZon]
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin desSysVenEff(
    final nin=numZon)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxPriOutAirFra(
    final nin=numZon)
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=numZon)
    "Replicate Real input signal"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

equation
  connect(zonVenEff.y, desSysVenEff.u)
    annotation (Line(points={{12,0},{18,0}},color={0,0,127}));
  connect(reaRep.y, zonVenEff.u1)
    annotation (Line(points={{-58,20},{-40,20},{-40,6},{-12,6}},
      color={0,0,127}));
  connect(sumDesZonPop.y, ySumDesZonPop)
    annotation (Line(points={{12,120},{120,120}},  color={0,0,127}));
  connect(sumDesBreZonPop.y, VSumDesPopBreZon_flow)
    annotation (Line(points={{12,90},{120,90}},color={0,0,127}));
  connect(sumDesBreZonAre.y, VSumDesAreBreZon_flow)
    annotation (Line(points={{12,60},{120,60}}, color={0,0,127}));
  connect(desSysVenEff.y, yDesSysVenEff)
    annotation (Line(points={{42,0},{120,0}}, color={0,0,127}));
  connect(sysUncOutAir.y, VSumUncOutAir_flow)
    annotation (Line(points={{12,-50},{120,-50}},  color={0,0,127}));
  connect(sysPriAirRate.y, VSumSysPriAir_flow)
    annotation (Line(points={{12,-120},{120,-120}}, color={0,0,127}));
  connect(maxPriOutAirFra.y, uOutAirFra_max)
    annotation (Line(points={{12,-80},{120,-80}},color={0,0,127}));
  connect(yAveOutAirFraPlu, reaRep.u)
    annotation (Line(points={{-120,20},{-82,20}}, color={0,0,127}));
  connect(uDesZonPeaOcc, sumDesZonPop.u)
    annotation (Line(points={{-120,120},{-12,120}}, color={0,0,127}));
  connect(VDesPopBreZon_flow, sumDesBreZonPop.u)
    annotation (Line(points={{-120,90},{-12,90}}, color={0,0,127}));
  connect(VDesAreBreZon_flow, sumDesBreZonAre.u)
    annotation (Line(points={{-120,60},{-12,60}},color={0,0,127}));
  connect(uDesPriOutAirFra, zonVenEff.u2)
    annotation (Line(points={{-120,-20},{-40,-20},{-40,-6},{-12,-6}},
      color={0,0,127}));
  connect(VUncOutAir_flow, sysUncOutAir.u)
    annotation (Line(points={{-120,-50},{-12,-50}}, color={0,0,127}));
  connect(VPriAir_flow, sysPriAirRate.u)
    annotation (Line(points={{-120,-120},{-12,-120}},
                                                    color={0,0,127}));
  connect(uPriOutAirFra, maxPriOutAirFra.u)
    annotation (Line(points={{-120,-80},{-12,-80}}, color={0,0,127}));

annotation (
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
          extent={{-98,88},{-34,74}},
          textColor={0,0,0},
          textString="uDesZonPeaOcc"),
        Text(
          extent={{-98,68},{-22,54}},
          textColor={0,0,0},
          textString="VDesPopBreZon_flow"),
        Text(
          extent={{-98,26},{-30,14}},
          textColor={0,0,0},
          textString="yAveOutAirFraPlu"),
        Text(
          extent={{-98,48},{-24,32}},
          textColor={0,0,0},
          textString="VDesAreBreZon_flow"),
        Text(
          extent={{-98,-52},{-44,-66}},
          textColor={0,0,0},
          textString="uPriOutAirFra"),
        Text(
          extent={{-98,-74},{-50,-86}},
          textColor={0,0,0},
          textString="VPriAir_flow"),
        Text(
          extent={{-98,-32},{-30,-46}},
          textColor={0,0,0},
          textString="VUncOutAir_flow"),
        Text(
          extent={{-98,-12},{-28,-26}},
          textColor={0,0,0},
          textString="uDesPriOutAirFra"),
        Text(
          extent={{42,8},{96,-6}},
          textColor={0,0,0},
          textString="yDesSysVenEff"),
        Text(
          extent={{12,40},{96,24}},
          textColor={0,0,0},
          textString="VSumDesAreBreZon_flow"),
        Text(
          extent={{12,70},{96,54}},
          textColor={0,0,0},
          textString="VSumDesPopBreZon_flow"),
        Text(
          extent={{36,98},{96,82}},
          textColor={0,0,0},
          textString="ySumDesZonPop"),
        Text(
          extent={{36,-50},{96,-66}},
          textColor={0,0,0},
          textString="uOutAirFra_max"),
        Text(
          extent={{26,-20},{96,-36}},
          textColor={0,0,0},
          textString="VSumUncOutAir_flow"),
        Text(
          extent={{24,-80},{96,-96}},
          textColor={0,0,0},
          textString="VSumSysPriAir_flow")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
  defaultComponentName="zonToSys",
  Documentation(info="<html>
<p>
This sequence sums up the zone level minimum outdoor airflow setpoints, finds the
maximum zone outdoor air fraction and the minimum zone ventilation efficiency. It
collects zone level outputs and prepares inputs for specifying AHU level minimum
outdoor air setpoint.
</p>
<p>
It requires following inputs from zone level calculation,
</p>
<ul>
<li>
Design zone peak occupancy, <code>uDesZonPeaOcc</code>,
</li>
<li>
Population component of the breathing zone design outdoor airflow, <code>VDesPopBreZon_flow</code>,
</li>
<li>
Area component of the breathing zone design outdoor airflow, <code>VDesAreBreZon_flow</code>,
</li>
<li>
Design zone primary outdoor air fraction, <code>uDesPriOutAirFra</code>,
</li>
<li>
Uncorrected outdoor airflow rate, <code>VUncOutAir_flow</code>, 
</li>
<li>
Primary outdoor air fraction, <code>uPriOutAirFra</code>,
</li>
<li>
Primary airflow rate, <code>VPriAir_flow</code>,
</li>
</ul>
<p>
and following input from AHU level calculation,
</p>
<ul>
<li>
Average AHU level outdoor air flow fraction plus 1, <code>yAveOutAirFraPlu</code>.
</li>
</ul>
<p>
The sequence gives following outputs for AHU level calculation:
</p>
<ul>
<li>
Sum of the design population of the zones, <code>ySumDesZonPop</code>,
</li>
<li>
Sum of the population component of the design breathing zone flow rate, <code>VSumDesPopBreZon_flow</code>,
</li>
<li>
Sum of the area component of the design breathing zone flow rate, <code>VSumDesAreBreZon_flow</code>,
</li>
<li>
Design system ventilation efficiency, <code>yDesSysVenEff</code>,
<p>
First, compute the zone ventilation efficiency <code>zonVenEff</code>, for design purpose, as
</p>
<pre>
    zonVenEff[i] = yAveOutAirFraPlu - uDesPriOutAirFra[i]
</pre>
<p>
where the <code>uDesPriOutAirFra</code> is the design zone outdoor airflow fraction.
Then the design system ventilation efficiency <code>yDesSysVenEff</code> is
</p>
<pre>
    yDesSysVenEff = min(zonVenEff[i]).
</pre>
</li>
<li>
Sum of the required uncorrected outdoor airflow rate, <code>VSumUncOutAir_flow</code>,
</li>
<li>
Maximum zone outdoor air fraction, <code>uOutAirFra_max</code>,
</li>
<li>
AHU level primary airflow rate, <code>VSumSysPriAir_flow</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Separated from original sequence of finding the system minimum outdoor air setpoint.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
</ul>
</html>"));
end SumZone;
