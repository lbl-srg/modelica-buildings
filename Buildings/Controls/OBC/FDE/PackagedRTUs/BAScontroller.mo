within Buildings.Controls.OBC.FDE.PackagedRTUs;
block BAScontroller
  "Building automation system portion of packaged RTU control"

  parameter Real pBldgSPset(
  final unit="Pa",
  final displayUnit="Pa",
  final quantity="PressureDifference")=15.0
  "Building differential static pressure set point"
  annotation (Dialog(group="System and building parameters"));

  parameter Integer pTotalTU(min=2) = 12 "Total number of terminal units"
  annotation (Dialog(group="System and building parameters"));

  parameter Real minSATset(
  final unit="K",
  final displayUnit="degC",
  final quantity="ThermodynamicTemperature")=14
  "Minimum supply air temperature reset value"
  annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real maxSATset(
  final unit="K",
  final displayUnit="degC",
  final quantity="ThermodynamicTemperature")=19
  "Maximum supply air temperature reset value"
  annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real HeatSet(
  final unit="K",
  final displayUnit="degC",
  final quantity="ThermodynamicTemperature")=35
  "Setback heating supply air temperature set point"
  annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real maxDDSPset(
  final unit="Pa",
  final displayUnit="bar",
  final quantity="PressureDifference")=500
  "Maximum down duct static pressure reset value"
  annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

  parameter Real minDDSPset(
  final unit="Pa",
  final displayUnit="bar",
  final quantity="PressureDifference")=125
  "Minimum down duct static pressure reset value"
  annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

  // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput occReq
    "Terminal unit occupancy requests"
    annotation (Placement(transformation(extent={{-140,34},{-100,74}}),
        iconTransformation(extent={{-140,34},{-100,74}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbcReq
    "Terminal unit setback cooling requests"
    annotation (Placement(transformation(extent={{-140,8},{-100,48}}),
        iconTransformation(extent={{-140,8},{-100,48}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbhReq
    "Terminal unit setback heating requests"
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totCoolReqs
    "Total terminal unit cooling requests"
    annotation (Placement(
        transformation(extent={{-140,-48},{-100,-8}}),
          iconTransformation(extent={{-140,-48},{-100,-8}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT
    "Highest space temperature reported from all terminal units"
    annotation (Placement(transformation(extent={{-140,-74},{-100,-34}}),
        iconTransformation(extent={{-140,-74},{-100,-34}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
    "Most open damper position of all terminal units" annotation (
      Placement(transformation(extent={{-140,-108},{-100,-68}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  // ---outputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{100,32},{140,72}}),
        iconTransformation(extent={{100,32},{140,72}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
    "True when setback cooling mode is active"
    annotation (Placement(transformation(extent={{100,6},{140,46}}),
        iconTransformation(extent={{100,6},{140,46}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
    "True when setback heating mode is active"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOAflowSet
    "Active outside air flow set point sent to factory controller"
    annotation (Placement(transformation(extent={{100,58},{140,98}}),
        iconTransformation(extent={{100,58},{140,98}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBldgSPset
    "Building static pressure set point"
    annotation (Placement(transformation(extent={{100,-72},{140,-32}}),
        iconTransformation(extent={{100,-72},{140,-32}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPset
    "Calculated down duct static pressure set point"
    annotation (Placement(transformation(extent={{100,-104},{140,-64}}),
        iconTransformation(extent={{100,-98},{140,-58}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySATset
    "Calculated supply air temperature set point"
    annotation (Placement(transformation(extent={{100,-46},{140,-6}}),
        iconTransformation(extent={{100,-46},{140,-6}})));

  Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet tSupSet(
    minSATset=287.15,
    maxSATset=292.15,
    HeatSet=308.15,
    TUpcntT=0.15)
    "Calculates supply air temperature set point for packaged 
      RTU factory controller serving terminal units"
    annotation (Placement(transformation(extent={{44,-2},{62,28}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.OperatingMode operatingMode(
    TUpcntM=0.15)
    "Determine occupied or setback operating mode"
    annotation (Placement(transformation(extent={{-14,36},{6,56}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset minOAset
    "Calculates minimum outside air flow set point for packaged RTU controller"
    annotation (Placement(transformation(extent={{40,68},{64,88}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset dDSPset(
    minDDSPset=125,
    maxDDSPset=500)
    "Down duct static pressure set point calculation based on 
      terminal unit damper position"
    annotation (Placement(transformation(extent={{-14,-98},{12,-72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant BldgSPset(
    final k=pBldgSPset)
    "Building static pressure set point"
    annotation (Placement(transformation(extent={{48,-62},{68,-42}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=pTotalTU)
    "Total number of terminal units connected to system."
    annotation (Placement(transformation(extent={{-94,6},{-74,26}})));

equation
  connect(operatingMode.yOcc,minOAset.occ)
    annotation (Line(points={{8,51.4},{30,51.4},{30,78},{37.6,78}},
      color={255,0,255}));
  connect(operatingMode.ySBC,tSupSet.sbc)
    annotation (Line(points={{8,46},{30,46},{30,13.6},{42.2,13.6}},
      color={255,0,255}));
  connect(operatingMode.ySBH,tSupSet.sbh)
    annotation (Line(points={{8,41},{24,41},{24,8.2},{42.2,8.2}},
      color={255,0,255}));
  connect(operatingMode.occ,occ)
    annotation (Line(points={{-16,52},{-22,52},{-22,80},{-120,80}},
      color={255,0,255}));
  connect(tSupSet.highSpaceT, highSpaceT)
    annotation (Line(points={{42.2,2.8},{32,2.8},{32,-54},{-120,-54}},
      color={0,0,127}));
  connect(dDSPset.mostOpenDam, mostOpenDam)
    annotation (Line(points={{-16.6,-87.6},{-66,-87.6},{-66,-88},{-120,-88}},
      color={0,0,127}));
  connect(minOAset.yMinOAflowSet, yMinOAflowSet)
    annotation (Line(points={{66.88,78},{120,78}},
      color={0,0,127}));
  connect(tSupSet.ySATset, ySATset)
    annotation (Line(points={{63.8,13},{71.1,13},{71.1,-26},{120,-26}},
      color={0,0,127}));
  connect(dDSPset.yDDSPset, yDDSPset)
    annotation (Line(points={{14.6,-85},{58,-85},{58,-84},{120,-84}},
      color={0,0,127}));
  connect(BldgSPset.y, yBldgSPset)
    annotation (Line(points={{70,-52},{120,-52}}, color={0,0,127}));
  connect(operatingMode.ySBC, ySBC)
    annotation (Line(points={{8,46},{82,46},{82,26},{120,26}},
      color={255,0,255}));
  connect(operatingMode.ySBH, ySBH)
    annotation (Line(points={{8,41},{10,41},{10,42},{78,42},{78,0},{120,0}},
      color={255,0,255}));
  connect(operatingMode.yOcc, yOcc)
    annotation (Line(points={{8,51.4},{12,51.4},{12,52},{120,52}},
      color={255,0,255}));
  connect(operatingMode.sbcReq,sbcReq)
    annotation (Line(points={{-16,43},{-60,43},{-60,28},{-120,28}},
      color={255,127,0}));
  connect(operatingMode.sbhReq,sbhReq)
    annotation (Line(points={{-16,40},{-50,40},{-50,0},{-120,0}},
      color={255,127,0}));
  connect(operatingMode.TotalTU, conInt.y)
    annotation (Line(points={{-16,46},{-68,46},{-68,16},{-72,16}},
      color={255,127,0}));
  connect(operatingMode.occReq,occReq)
    annotation (Line(points={{-16,49},{-120,49},{-120,54}},
      color={255,127,0},
      smooth=Smooth.Bezier));
  connect(tSupSet.totCoolReqs, totCoolReqs)
    annotation (Line(points={{42.2,19},{-40,19},{-40,-28},{-120,-28}},
      color={255,127,0}));
  connect(tSupSet.TotalTU, conInt.y)
    annotation (Line(points={{42.2,24.4},{-68,24.4},{-68,16},{-72,16}},
      color={255,127,0}));
  annotation (defaultComponentName="conBAS",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={179,151,128},
          radius=10,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-90,184},{90,80}},
          lineColor={28,108,200},
          textStyle={TextStyle.Bold},
          textString="%name"),
        Text(
          extent={{-116,88},{-54,72}},
          lineColor={217,67,180},
          textString="occ"),
        Text(
          extent={{-94,66},{-54,42}},
          lineColor={244,125,35},
          textString="occReq"),
        Text(
          extent={{-96,36},{-52,20}},
          lineColor={244,125,35},
          textString="sbcReq"),
        Text(
          extent={{-96,8},{-52,-8}},
          lineColor={244,125,35},
          textString="sbhReq"),
        Text(
          extent={{-94,-16},{-26,-40}},
          lineColor={244,125,35},
          textString="totCoolReqs"),
        Text(
          extent={{-96,-44},{-34,-64}},
          lineColor={0,0,255},
          textString="highSpaceT"),
        Text(
          extent={{-96,-72},{-52,-88}},
          lineColor={0,0,255},
          textString="sbhReq"),
        Text(
          extent={{20,90},{94,68}},
          lineColor={0,0,255},
          textString="yMinOAflowSet"),
        Text(
          extent={{48,60},{110,44}},
          lineColor={217,67,180},
          textString="yOcc"),
        Text(
          extent={{46,34},{108,18}},
          lineColor={217,67,180},
          textString="ySBC"),
        Text(
          extent={{46,8},{108,-8}},
          lineColor={217,67,180},
          textString="ySBH"),
        Text(
          extent={{44,-16},{98,-32}},
          lineColor={0,0,255},
          textString="ySATset"),
        Text(
          extent={{24,-42},{94,-64}},
          lineColor={0,0,255},
          textString="yBldgSPset"),
        Text(
          extent={{32,-68},{94,-88}},
          lineColor={0,0,255},
          textString="yDDSPset")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {100,100}})),
    Documentation(info="<html>
<p>
Block that is applied for variable volume packaged rooftop air handling units
 operated through a combination of BAS controller and factory controller
 serving terminal air units. It outputs the operating mode (occupied, setback
 heating, or setback cooling), supply air temperature set point,
 down duct static pressure set point, building differential static pressure
 set point, and minimum outside air flow set point.
</p>
<p>
The building differential static pressure set point (<code>yBldgSPset</code>)
 is a fixed value. The remaining outputs are calculated in four subsequences.
</p>
<h4>Operating Mode</h4>
<p>
The operating mode sequence monitors the occupied schedule for the unit (
<code>Occ</code>),setback cooling requests from terminal units 
(<code>SBCreq</code>),and setback heating requests 
(<code>SBHreq</code>) from terminal units.
The operating mode sequence outputs the active occupied mode 
(<code>yOcc</code>),setback cooling mode 
(<code>ySBC</code>), or setback heating mode 
(<code>ySBH</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.OperatingMode\">
Buildings.Controls.OBC.FDE.PackagedRTUs.OperatingMode</a>
for more details.
</p>
<h4>Supply Air Temperature Set Point</h4>
<p>
The supply air temperature sequence monitors terminal unit cooling requests 
(<code>totCoolReqs</code>),setback cooling mode 
(<code>SBC</code>), and setback heating mode 
(<code>SBH</code>). The supply air temperature sequence outputs the active 
supply air temperature set point (<code>ySATset</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet\">
Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet</a>
for more details.
</p>
<h4>Down Duct Static Pressure Set Point</h4>
<p>
The down duct static pressure sequence monitors the most open terminal unit primary air damper position 
(<code>mostOpenDam</code>). The down duct static pressure sequence outputs the active down duct static pressure set point 
(<code>yDDSPset</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset</a>
for more details.
</p>
<h4>Minimum Outside Air Flow</h4>
<p>
The minimum outside air sequence monitors the unit occupied mode 
(<code>Occ</code>).
The minimum outside air sequence outputs the active outside air flow set point 
(<code>yMinOAflowSet</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset</a>
for more details.
</p>
</html>", revisions="<html>
<ul>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>"));
end BAScontroller;
