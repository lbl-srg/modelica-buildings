within Buildings.Controls.OBC.FDE.PackagedRTUs;
block BAScontroller
  "building automation system portion of packaged RTU control"

  parameter Real pBldgSPset(
  final unit="Pa",
  final displayUnit="Pa",
  final quantity="PressureDifference")=0.005
  "Building differential static pressure set point"
  annotation (Dialog(group="System and building parameters"));

  parameter Integer pTotalTU(min=2)=25
  "Total number of terminal units"
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
  final displayUnit="Pa",
  final quantity="PressureDifference")=5e-3
  "Maximum down duct static pressure reset value"
  annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

  parameter Real minDDSPset(
  final unit="Pa",
  final displayUnit="Pa",
  final quantity="PressureDifference")=1.25e-3
  "Minimum down duct static pressure reset value"
  annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

  // ---inputs---
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occ
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput occReq
    "Terminal unit occupancy requests"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbcReq
    "Terminal unit setback cooling requests"
    annotation (Placement(transformation(extent={{-140,-28},{-100,12}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput sbhReq
    "Terminal unit setback heating requests"
    annotation (Placement(
        transformation(extent={{-140,-58},{-100,-18}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totCoolReqs
    "Total terminal unit cooling requests"
    annotation (Placement(
        transformation(extent={{-140,-88},{-100,-48}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT
    "Highest space temperature reported from all terminal units"
    annotation (Placement(transformation(extent={{-140,-124},{-100,-84}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
    "Most open damper position of all terminal units" annotation (
      Placement(transformation(extent={{-140,-156},{-100,-116}})));

  // ---outputs---
  output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
    "True when occupied mode is active"
    annotation (Placement(transformation(extent={{104,28},{144,68}})));
  output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
    "True when setback cooling mode is active"
    annotation (Placement(transformation(extent={{104,-2},{144,38}})));
  output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
    "True when setback heating mode is active"
    annotation (Placement(transformation(extent={{104,-36},{144,4}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOAflowSet
    "active outside air flow set point sent to factory controller"
    annotation (Placement(transformation(extent={{104,56},{144,96}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBldgSPset
    "Building static pressure set point"
    annotation (Placement(transformation(extent={{104,-112},{144,-72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPset
    "Calculated down duct static pressure set point"
    annotation (
      Placement(transformation(extent={{104,-154},{144,-114}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySATset
    "Calculated supply air temperature set point"
    annotation (Placement(transformation(extent={{104,-74},{144,-34}})));

  TSupSet tSupSet
    annotation (Placement(transformation(extent={{28,-2},{46,28}})));
  OperatingMode operatingMode
    annotation (Placement(transformation(extent={{-26,36},{-6,56}})));
  MinOAset minOAset
    annotation (Placement(transformation(extent={{28,82},{40,92}})));
  DDSPset dDSPset
    annotation (Placement(transformation(extent={{-8,-142},{6,-126}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant BldgSPset(k=
        pBldgSPset) "Building static pressure set point"
    annotation (Placement(transformation(extent={{30,-102},{50,-82}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=pTotalTU)
    annotation (Placement(transformation(extent={{-96,12},{-76,32}})));

equation
  connect(operatingMode.yOcc,minOAset.occ)  annotation (Line(points={{-4.15385,
          52.8},{14,52.8},{14,87.6},{26,87.6}},
                                            color={255,0,255}));
  connect(operatingMode.ySBC,tSupSet.sbc)  annotation (Line(points={{-4.15385,
          43.2},{12,43.2},{12,11.6},{26.2,11.6}}, color={255,0,255}));
  connect(operatingMode.ySBH,tSupSet.sbh)  annotation (Line(points={{-4.15385,
          39},{8,39},{8,1.8},{26.2,1.8}},     color={255,0,255}));
  connect(operatingMode.occ,occ)  annotation (Line(points={{-27.5385,54.2},{-64,
          54.2},{-64,80},{-120,80}}, color={255,0,255}));
  connect(tSupSet.highSpaceT, highSpaceT) annotation (Line(points={{26.2,
          6.6},{-20,6.6},{-20,-104},{-120,-104}}, color={0,0,127}));
  connect(dDSPset.mostOpenDam, mostOpenDam) annotation (Line(points={{-9.8,
          -135.6},{-54.9,-135.6},{-54.9,-136},{-120,-136}}, color={0,0,127}));
  connect(minOAset.yMinOAflowSet, yMinOAflowSet) annotation (Line(points={{42,
          87.6},{82,87.6},{82,76},{124,76}}, color={0,0,127}));
  connect(tSupSet.ySATset, ySATset) annotation (Line(points={{47.9636,1.8},{
          55.1,1.8},{55.1,-54},{124,-54}}, color={0,0,127}));
  connect(dDSPset.yDDSPset, yDDSPset) annotation (Line(points={{8,-133.6},{58,-133.6},
          {58,-134},{124,-134}}, color={0,0,127}));
  connect(BldgSPset.y, yBldgSPset)
    annotation (Line(points={{52,-92},{124,-92}}, color={0,0,127}));
  connect(operatingMode.ySBC, ySBC) annotation (Line(points={{-4.15385,43.2},{
          82,43.2},{82,18},{124,18}},
                             color={255,0,255}));
  connect(operatingMode.ySBH, ySBH) annotation (Line(points={{-4.15385,39},{8,
          39},{8,36},{76,36},{76,-16},{124,-16}},
                                              color={255,0,255}));
  connect(operatingMode.yOcc, yOcc) annotation (Line(points={{-4.15385,52.8},
          {12,52.8},{12,52},{92,52},{92,48},{124,48}},
                                             color={255,0,255}));
  connect(operatingMode.sbcReq,sbcReq)  annotation (Line(points={{-27.5385,42.4},
          {-60,42.4},{-60,-8},{-120,-8}},       color={255,127,0}));
  connect(operatingMode.sbhReq,sbhReq)  annotation (Line(points={{-27.5385,38.2},
          {-50,38.2},{-50,-38},{-120,-38}},       color={255,127,0}));
  connect(operatingMode.TotalTU, conInt.y) annotation (Line(points={{-27.5385,
          48.2},{-68,48.2},{-68,22},{-74,22}},          color={255,127,0}));
  connect(operatingMode.occReq,occReq)  annotation (Line(
      points={{-27.5385,51.2},{-120,51.2},{-120,50}},
      color={255,127,0},
      smooth=Smooth.Bezier));
  connect(tSupSet.totCoolReqs, totCoolReqs) annotation (Line(points={{26.2,
          17.6},{-40,17.6},{-40,-68},{-120,-68}}, color={255,127,0}));
  connect(tSupSet.TotalTU, conInt.y) annotation (Line(points={{26.2,21.2},{
          -68,21.2},{-68,22},{-74,22}}, color={255,127,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{
            100,100}}), graphics={Rectangle(extent={{-98,100},{98,-160}},
            lineColor={179,151,128},
          radius=10),                Text(
          extent={{-90,40},{90,-64}},
          lineColor={179,151,128},
          textString="BAS",
          textStyle={TextStyle.Bold})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {100,100}})),
    Documentation(info="<html>
<p>
Block that is applied for variable volume packaged rooftop air handling units operated through a combination of BAS controller and factory controller
 serving terminal air units. It outputs the operating mode (occupied, setback heating, or setback cooling), supply air temperature set point,
 down duct static pressure set point, building differential static pressure set point, and minimum outside air flow set point.
</p>
<p>
The building differential static pressure set point (<code>yBldgSPset</code>) is a fixed value. The remaining outputs are calculated in four subsequences.
</p>
<h4>Operating Mode</h4>
<p>
The operating mode sequence monitors the occupied schedule for the unit (<code>Occ</code>), setback cooling requests from terminal units (<code>SBCreq</code>), and setback heating requests (<code>SBHreq</code>) from terminal units.
The operating mode sequence outputs the active occupied mode (<code>yOcc</code>), setback cooling mode (<code>ySBC</code>), or setback heating mode (<code>ySBH</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.OperatingMode\">
Buildings.Controls.OBC.FDE.PackagedRTUs.OperatingMode</a>
for more details.
</p>
<h4>Supply Air Temperature Set Point</h4>
<p>
The supply air temperature sequence monitors terminal unit cooling requests (<code>totCoolReqs</code>), setback cooling mode (<code>SBC</code>), and setback heating mode (<code>SBH</code>).
The supply air temperature sequence outputs the active supply air temperature set point (<code>ySATset</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet\">
Buildings.Controls.OBC.FDE.PackagedRTUs.TSupSet</a>
for more details.
</p>
<h4>Down Duct Static Pressure Set Point</h4>
<p>
The down duct static pressure sequence monitors the most open terminal unit primary air damper position (<code>mostOpenDam</code>).
The down duct static pressure sequence outputs the active down duct static pressure set point (<code>yDDSPset</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset</a>
for more details.
</p>
<h4>Minimum Outside Air Flow</h4>
<p>
The minimum outside air sequence monitors the unit occupied mode (<code>Occ</code>).
The minimum outside air sequence outputs the active outside air flow set point (<code>yMinOAflowSet</code>).

See
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset</a>
for more details.
</p>
</html>"));
end BAScontroller;
