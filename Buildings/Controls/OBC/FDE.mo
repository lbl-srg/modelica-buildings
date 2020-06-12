within Buildings.Controls.OBC;
package FDE "Facility Dynamics Engineering"
  package PackagedRTUs "Standard packaged RTU sequences"
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
      "minimum supply air temperature reset value"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

      parameter Real maxSATset(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=19
      "maximum supply air temperature reset value"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

      parameter Real HeatSet(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=35
      "setback heating supply air temperature set point"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

      parameter Real maxDDSPset(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=5e-3
      "maximum down duct static pressure reset value"
      annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

      parameter Real minDDSPset(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=1.25e-3
      "minimum down duct static pressure reset value"
      annotation (Dialog(tab="Supply fan", group="Down duct pressure limits"));

      TSupSet tSupSet
        annotation (Placement(transformation(extent={{28,-2},{46,28}})));
      OperatingMode operatingMode
        annotation (Placement(transformation(extent={{-26,36},{-6,56}})));
      MinOAset minOAset
        annotation (Placement(transformation(extent={{28,82},{40,92}})));
      DDSPset dDSPset
        annotation (Placement(transformation(extent={{-8,-142},{6,-126}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput Occ
        "true when occupied mode is active"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT
        "highest space temperature reported from all terminal units"
        annotation (Placement(transformation(extent={{-140,-124},{-100,-84}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
        "most open damper position of all terminal units" annotation (
          Placement(transformation(extent={{-140,-156},{-100,-116}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOAflowSet
        "active outside air flow set point sent to factory controller"
        annotation (Placement(transformation(extent={{104,56},{144,96}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySATset
        "calculated supply air temperature set point"
        annotation (Placement(transformation(extent={{104,-74},{144,-34}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPset
        "calculated down duct static pressure set point" annotation (
          Placement(transformation(extent={{104,-154},{144,-114}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant BldgSPset(k=
            pBldgSPset) "Building static pressure set point"
        annotation (Placement(transformation(extent={{30,-102},{50,-82}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yBldgSPset
        "Connector of Real output signal"
        annotation (Placement(transformation(extent={{104,-112},{144,-72}})));
      output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
        "true when occupied mode is active"
        annotation (Placement(transformation(extent={{104,28},{144,68}})));
      output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
        "true when setback cooling mode is active"
        annotation (Placement(transformation(extent={{104,-2},{144,38}})));
      output Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
        "true when setback heating mode is active"
        annotation (Placement(transformation(extent={{104,-36},{144,4}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput SBCreq
        "terminal unit setback cooling requests"
        annotation (Placement(transformation(extent={{-140,-28},{-100,12}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput SBHreq
        "terminal unit setback heating requests" annotation (Placement(
            transformation(extent={{-140,-58},{-100,-18}})));
      Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=pTotalTU)
        annotation (Placement(transformation(extent={{-96,12},{-76,32}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput OccReq
        "terminal unit occupancy requests"
        annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totCoolReqs
        "total terminal unit cooling requests" annotation (Placement(
            transformation(extent={{-140,-88},{-100,-48}})));
    equation
      connect(operatingMode.yOcc, minOAset.Occ) annotation (Line(points={{
              -4.15385,52.8},{14,52.8},{14,88},{26,88}},
                                                color={255,0,255}));
      connect(operatingMode.ySBC, tSupSet.SBC) annotation (Line(points={{
              -4.15385,44.6},{12,44.6},{12,12.4},{26.2,12.4}},
                                                      color={255,0,255}));
      connect(operatingMode.ySBH, tSupSet.SBH) annotation (Line(points={{
              -4.15385,40.4},{8,40.4},{8,3.6},{26.2,3.6}},
                                                  color={255,0,255}));
      connect(operatingMode.Occ, Occ) annotation (Line(points={{-27.5385,54.2},
              {-64,54.2},{-64,80},{-120,80}},
                                         color={255,0,255}));
      connect(tSupSet.highSpaceT, highSpaceT) annotation (Line(points={{26.2,
              6.6},{-20,6.6},{-20,-104},{-120,-104}}, color={0,0,127}));
      connect(dDSPset.mostOpenDam, mostOpenDam) annotation (Line(points={{-9.8,
              -135.6},{-54.9,-135.6},{-54.9,-136},{-120,-136}}, color={0,0,127}));
      connect(minOAset.yminOAflowStpt, yMinOAflowSet) annotation (Line(points={{42,88},
              {82,88},{82,76},{124,76}}, color={0,0,127}));
      connect(tSupSet.ySATsetpoint, ySATset) annotation (Line(points={{47.8,
              14.8},{55.1,14.8},{55.1,-54},{124,-54}},
                                           color={0,0,127}));
      connect(dDSPset.yDDSPstpt, yDDSPset) annotation (Line(points={{8,-133.6},{58,-133.6},
              {58,-134},{124,-134}}, color={0,0,127}));
      connect(BldgSPset.y, yBldgSPset)
        annotation (Line(points={{52,-92},{124,-92}}, color={0,0,127}));
      connect(operatingMode.ySBC, ySBC) annotation (Line(points={{-4.15385,44.6},
              {82,44.6},{82,18},{124,18}},
                                 color={255,0,255}));
      connect(operatingMode.ySBH, ySBH) annotation (Line(points={{-4.15385,40.4},
              {8,40.4},{8,36},{76,36},{76,-16},{124,-16}},
                                                  color={255,0,255}));
      connect(operatingMode.yOcc, yOcc) annotation (Line(points={{-4.15385,52.8},
              {12,52.8},{12,52},{92,52},{92,48},{124,48}},
                                                 color={255,0,255}));
      connect(operatingMode.SBCreq, SBCreq) annotation (Line(points={{-27.5385,
              43.8},{-60,43.8},{-60,-8},{-120,-8}}, color={255,127,0}));
      connect(operatingMode.SBHreq, SBHreq) annotation (Line(points={{-27.5385,
              39.6},{-50,39.6},{-50,-38},{-120,-38}}, color={255,127,0}));
      connect(operatingMode.TotalTU, conInt.y) annotation (Line(points={{
              -27.5385,48.2},{-68,48.2},{-68,22},{-74,22}}, color={255,127,0}));
      connect(operatingMode.OccReq, OccReq) annotation (Line(
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
                lineColor={162,29,33},
              radius=10),                Text(
              extent={{-90,40},{90,-64}},
              lineColor={162,29,33},
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

    block OperatingMode "Determine occupied or setback operating mode"

      parameter Real TUpcntM(
      min=0.1,
      max=0.9)=0.15
      "minimum decimal percentage of terminal unit requests required for mode change";

      Buildings.Controls.OBC.CDL.Logical.Or or2
        annotation (Placement(transformation(extent={{42,58},{62,78}})));
      input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput Occ
        "true when occupied mode is active"
        annotation (Placement(transformation(extent={{-140,62},{-100,102}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yOcc
        "true when occupied mode is active"
        annotation (Placement(transformation(extent={{164,48},{204,88}})));
      Buildings.Controls.OBC.CDL.Logical.And and2
        annotation (Placement(transformation(extent={{114,-24},{134,-4}})));
      Buildings.Controls.OBC.CDL.Logical.Not not1
        annotation (Placement(transformation(extent={{78,26},{98,46}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBC
        "true when setback cooling mode is active"
        annotation (Placement(transformation(extent={{164,-34},{204,6}})));
      Buildings.Controls.OBC.CDL.Logical.And and1
        annotation (Placement(transformation(extent={{114,-66},{134,-46}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySBH
        "true when setback heating mode is active"
        annotation (Placement(transformation(extent={{164,-76},{204,-36}})));
      Buildings.Controls.OBC.CDL.Integers.Greater intGre
        annotation (Placement(transformation(extent={{6,42},{26,62}})));
      Buildings.Controls.OBC.CDL.Integers.Greater intGre1
        annotation (Placement(transformation(extent={{8,-32},{28,-12}})));
      Buildings.Controls.OBC.CDL.Integers.Greater intGre2
        annotation (Placement(transformation(extent={{8,-74},{28,-54}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput OccReq
        "terminal unit occupancy requests"
        annotation (Placement(transformation(extent={{-140,32},{-100,72}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TotalTU
        "total number of terminal units"
        annotation (Placement(transformation(extent={{-140,2},{-100,42}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput SBCreq
        "terminal unit setback cooling requests"
        annotation (Placement(transformation(extent={{-140,-42},{-100,-2}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput SBHreq
        "terminal unit setback heating requests" annotation (Placement(
            transformation(extent={{-140,-84},{-100,-44}})));
      Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
        annotation (Placement(transformation(extent={{-94,12},{-74,32}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=TUpcntM)
        annotation (Placement(transformation(extent={{-66,12},{-46,32}})));
      Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
        annotation (Placement(transformation(extent={{-38,12},{-18,32}})));
    equation
      connect(or2.u1, Occ) annotation (Line(points={{40,68},{34,68},{34,82},{-120,82}},
                          color={255,0,255}));
      connect(or2.y, yOcc)
        annotation (Line(points={{64,68},{184,68}},color={255,0,255}));
      connect(not1.y, and2.u1) annotation (Line(points={{100,36},{106,36},{106,
              -14},{112,-14}},
                         color={255,0,255}));
      connect(not1.u, yOcc) annotation (Line(points={{76,36},{70,36},{70,68},{
              184,68}}, color={255,0,255}));
      connect(and2.y, ySBC) annotation (Line(points={{136,-14},{184,-14}},
                               color={255,0,255}));
      connect(and1.u1, and2.u1) annotation (Line(points={{112,-56},{106,-56},{106,-14},
              {112,-14}},     color={255,0,255}));
      connect(and1.y, ySBH)
        annotation (Line(points={{136,-56},{184,-56}},color={255,0,255}));
      connect(intGre.u1, OccReq)
        annotation (Line(points={{4,52},{-120,52}},   color={255,127,0}));
      connect(intGre.y, or2.u2) annotation (Line(points={{28,52},{34,52},{34,60},{40,
              60}}, color={255,0,255}));
      connect(and2.u2, intGre1.y)
        annotation (Line(points={{112,-22},{30,-22}}, color={255,0,255}));
      connect(and1.u2, intGre2.y)
        annotation (Line(points={{112,-64},{30,-64}}, color={255,0,255}));
      connect(intGre1.u1, SBCreq)
        annotation (Line(points={{6,-22},{-120,-22}},   color={255,127,0}));
      connect(intGre2.u1, SBHreq)
        annotation (Line(points={{6,-64},{-120,-64}},   color={255,127,0}));
      connect(TotalTU, intToRea.u)
        annotation (Line(points={{-120,22},{-96,22}}, color={255,127,0}));
      connect(intToRea.y, gai.u)
        annotation (Line(points={{-72,22},{-68,22}}, color={0,0,127}));
      connect(gai.y, reaToInt.u)
        annotation (Line(points={{-44,22},{-40,22}}, color={0,0,127}));
      connect(intGre.u2, reaToInt.y) annotation (Line(points={{4,44},{-8,44},{-8,22},
              {-16,22}}, color={255,127,0}));
      connect(intGre1.u2, reaToInt.y) annotation (Line(points={{6,-30},{-8,-30},{-8,
              22},{-16,22}}, color={255,127,0}));
      connect(intGre2.u2, reaToInt.y) annotation (Line(points={{6,-72},{-8,-72},{-8,
              22},{-16,22}}, color={255,127,0}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {160,100}}),                                        graphics={
              Rectangle(extent={{-98,100},{160,-104}},lineColor={162,29,33},
              radius=20),
            Text(
              extent={{-32,-38},{90,-94}},
              lineColor={162,29,33},
              textString="Mode",
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-154,90},{-124,74}},
              lineColor={217,67,180},
              textString="Occ"),
            Text(
              extent={{-154,60},{-124,44}},
              lineColor={0,0,255},
              textString="OccReq"),
            Text(
              extent={{-154,30},{-124,14}},
              lineColor={0,0,255},
              textString="TotalTU"),
            Text(
              extent={{-154,-14},{-124,-30}},
              lineColor={0,0,255},
              textString="SBCreq"),
            Text(
              extent={{-154,-56},{-124,-72}},
              lineColor={0,0,255},
              textString="SBHreq"),
            Text(
              extent={{186,76},{216,60}},
              lineColor={217,67,180},
              textString="yOcc"),
            Text(
              extent={{186,-6},{216,-22}},
              lineColor={217,67,180},
              textString="ySBC"),
            Text(
              extent={{186,-48},{216,-64}},
              lineColor={217,67,180},
              textString="ySBH"),
            Ellipse(extent={{-18,54},{58,-20}}, lineColor={162,29,33},
              fillPattern=FillPattern.Sphere,
              fillColor={162,29,33}),
            Line(
              points={{20,52},{20,38}},
              color={162,29,33},
              smooth=Smooth.Bezier),
            Line(
              points={{20,-4},{20,-18}},
              color={162,29,33},
              smooth=Smooth.Bezier),
            Line(
              points={{0,7},{0,-7}},
              color={162,29,33},
              smooth=Smooth.Bezier,
              origin={-8,17},
              rotation=90),
            Line(
              points={{0,7},{0,-7}},
              color={162,29,33},
              smooth=Smooth.Bezier,
              origin={48,19},
              rotation=90),
            Ellipse(extent={{18,20},{22,16}}, lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{20,20},{44,52},{46,50},{22,18},{22,20},{20,20}},
              lineColor={162,29,33},
              smooth=Smooth.Bezier,
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{102,76},{114,-64}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder),
            Rectangle(
              extent={{64,20},{96,16}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-54,18},{-22,14}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{110,68},{160,66}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-70,86},{-58,-72}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder),
            Rectangle(
              extent={{-98,82},{-66,80}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-98,52},{-66,50}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-98,22},{-66,20}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-98,-22},{-66,-24}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-98,-64},{-66,-66}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{110,-12},{160,-14}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{110,-54},{160,-56}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder)}),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{160,
                100}})),
        Documentation(info="<html>
<p>Selection of the operating mode performed by the BAS and transmitted to the factory controller. </p>
<h4>Occupied Mode</h4>
<p>The normal occupied mode (<code>yOcc</code>) is selected when indicated by the RTU occupancy schedule (<code>Occ</code>) or when occupancy overrides from the terminal units (<code>OccReq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
<h4>Setback Cooling Mode</h4>
<p>The setback cooling mode (<code>ySBC</code>) is selected when occupied mode is not active and setback cooling requests from the terminal units (<code>SBCreq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
<h4>Setback Heating Mode</h4>
<p>The setback heating mode (<code>ySBH</code>) is selected when occupied mode is not active and setback heating requests from the terminal units (<code>SBHreq</code>) exceed a percentage (<code>TUpcnt</code> default 15%) of the total number of terminal units (<code>TotalTU</code>).</p>
</html>", revisions="<html>
<ul>
<li>June 4, 2020, by Henry Nickels:<br>Changed Real inputs to Integer type. </li>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>"));
    end OperatingMode;

    block TSupSet
      "Calculates supply air temperature set point for packaged RTU factory controller serving terminal units"
      Buildings.Controls.OBC.CDL.Continuous.LimPID conPI(
        controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        k=3,
        Ti=300,
        yMax=1,
        yMin=0,
        wp=1.5,
        reverseAction=true,
        reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
        "Cooling requests PI calculation"
        annotation (Placement(transformation(extent={{-42,22},{-22,42}})));
      Buildings.Controls.OBC.CDL.Continuous.Line Treset(limitBelow=true,
          limitAbove=true) "linear supply temperature set point reset"
        annotation (Placement(transformation(extent={{22,22},{42,42}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
        "linear conversion constant"
        annotation (Placement(transformation(extent={{-16,74},{4,94}})));

        Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=1)
        "linear conversion constant"
        annotation (Placement(transformation(extent={{-16,2},{4,22}})));
                input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput SBC
        "true when setback cooling mode active" annotation (Placement(
            transformation(extent={{-142,-76},{-102,-36}})));
      Buildings.Controls.OBC.CDL.Logical.Switch swi
        annotation (Placement(transformation(extent={{60,-18},{80,2}})));
      Buildings.Controls.OBC.CDL.Continuous.Add subtract(k1=-1, k2=+1)
        "subtract offset from input"
        annotation (Placement(transformation(extent={{-32,-102},{-12,-82}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fixedOffset(k=10)
        "fixed 10 degree offset from highest space temperature"
        annotation (Placement(transformation(extent={{-72,-96},{-52,-76}})));
      input Buildings.Controls.OBC.CDL.Interfaces.RealInput highSpaceT(
        final unit="K",
        final displayUnit="degC",
        final quantity="ThermodynamicTemperature")
        "highest space temperature reported from all terminal units"
        annotation (Placement(transformation(extent={{-142,-134},{-102,-94}})));
      Buildings.Controls.OBC.CDL.Logical.Switch swi1
        annotation (Placement(transformation(extent={{96,-42},{116,-22}})));
      input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput SBH
        "true when setback heating mode active" annotation (Placement(
            transformation(extent={{-142,-164},{-102,-124}})));
      final Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySATsetpoint(
        final unit="K",
        final displayUnit="degC",
        final quantity="ThermodynamicTemperature")
        "calculated supply air temperature set point"
        annotation (Placement(transformation(extent={{122,-52},{162,-12}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minPAR(k=
            minSATset) "minimum supply air temperature set point"
        annotation (Placement(transformation(extent={{-16,-32},{4,-12}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heatPAR(k=HeatSet)
        "unoccupied mode supply air temperature heating set point"
        annotation (Placement(transformation(extent={{-72,-174},{-52,-154}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxPAR(k=
            maxSATset) "maximum supply air temperature set point"
        annotation (Placement(transformation(extent={{-16,42},{4,62}})));
      parameter Real minSATset(
       final unit="K",
       final displayUnit="degC",
       final quantity="ThermodynamicTemperature")=273.15+14
       "minimum supply air temperature reset value";
      parameter Real maxSATset(
       final unit="K",
       final displayUnit="degC",
       final quantity="ThermodynamicTemperature")=273.15+19
       "maximum supply air temperature reset value";
      parameter Real HeatSet(
       final unit="K",
       final displayUnit="degC",
       final quantity="ThermodynamicTemperature")=273.15+35
      "setback heating supply air temperature set point";
      parameter Real TUpcntT(
      min=0.1,
      max=0.9)=0.15
      "minimum decimal percentage of terminal unit requests required for cool request reset";
      Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
        annotation (Placement(transformation(extent={{-98,22},{-78,42}})));
      Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=TUpcntT)
        annotation (Placement(transformation(extent={{-72,22},{-52,42}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TotalTU
        "total number of terminal units"
        annotation (Placement(transformation(extent={{-142,12},{-102,52}})));
      Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
        annotation (Placement(transformation(extent={{-72,-14},{-52,6}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerInput totCoolReqs
        "total terminal unit cooling requests"
        annotation (Placement(transformation(extent={{-142,-24},{-102,16}})));
      Buildings.Controls.OBC.CDL.Logical.Not not1
        annotation (Placement(transformation(extent={{-16,-66},{4,-46}})));
      Buildings.Controls.OBC.CDL.Logical.Not not2
        annotation (Placement(transformation(extent={{-16,-154},{4,-134}})));
    equation
      connect(conPI.y, Treset.u)
        annotation (Line(points={{-20,32},{20,32}},  color={0,0,127}));
      connect(X1.y, Treset.x1) annotation (Line(points={{6,84},{14,84},{14,40},{20,40}},
                        color={0,0,127}));
      connect(X2.y, Treset.x2) annotation (Line(points={{6,12},{10,12},{10,28},{20,28}},
                    color={0,0,127}));
      connect(Treset.y, swi.u1)
        annotation (Line(points={{44,32},{52,32},{52,0},{58,0}},color={0,0,127}));
      connect(fixedOffset.y, subtract.u1)
        annotation (Line(points={{-50,-86},{-34,-86}}, color={0,0,127}));
      connect(subtract.u2, highSpaceT) annotation (Line(points={{-34,-98},{-46,
              -98},{-46,-114},{-122,-114}}, color={0,0,127}));
      connect(swi.u3, subtract.y) annotation (Line(points={{58,-16},{52,-16},{52,-92},
              {-10,-92}},          color={0,0,127}));
      connect(swi.y, swi1.u1)
        annotation (Line(points={{82,-8},{82,-24},{94,-24}},
                                                   color={0,0,127}));
      connect(swi1.y, ySATsetpoint)
        annotation (Line(points={{118,-32},{142,-32}},
                                                    color={0,0,127}));
      connect(Treset.f2, minPAR.y) annotation (Line(points={{20,24},{14,24},{14,-22},
              {6,-22}},   color={0,0,127}));
      connect(swi1.u3, heatPAR.y) annotation (Line(points={{94,-40},{88,-40},{88,-164},
              {-50,-164}}, color={0,0,127}));
      connect(maxPAR.y, Treset.f1) annotation (Line(points={{6,52},{10,52},{10,36},{
              20,36}},   color={0,0,127}));
      connect(TotalTU, intToRea.u)
        annotation (Line(points={{-122,32},{-100,32}},color={255,127,0}));
      connect(intToRea.y,gai. u)
        annotation (Line(points={{-76,32},{-74,32}}, color={0,0,127}));
      connect(conPI.u_s, gai.y)
        annotation (Line(points={{-44,32},{-50,32}}, color={0,0,127}));
      connect(intToRea1.u, totCoolReqs)
        annotation (Line(points={{-74,-4},{-122,-4}}, color={255,127,0}));
      connect(conPI.u_m, intToRea1.y) annotation (Line(points={{-32,20},{-32,-4},
              {-50,-4}}, color={0,0,127}));
      connect(SBC, not1.u)
        annotation (Line(points={{-122,-56},{-18,-56}}, color={255,0,255}));
      connect(swi.u2, not1.y) annotation (Line(points={{58,-8},{32,-8},{32,-56},
              {6,-56}}, color={255,0,255}));
      connect(SBH, not2.u)
        annotation (Line(points={{-122,-144},{-18,-144}}, color={255,0,255}));
      connect(swi1.u2, not2.y) annotation (Line(points={{94,-32},{70,-32},{70,
              -144},{6,-144}}, color={255,0,255}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
                {120,100}}),           graphics={
            Rectangle(extent={{-94,94},{114,-194}},lineColor={162,29,33},
              radius=30),
            Text(
              extent={{-34,-156},{50,-200}},
              lineColor={162,29,33},
              textString="TSupSet",
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{70,54},{74,-142}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder),
            Rectangle(
              extent={{34,52},{70,50}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,44},{70,42}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,34},{70,32}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,24},{70,22}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{34,16},{70,14}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,8},{70,6}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-2},{70,-4}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-12},{70,-14}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{34,-22},{70,-24}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-30},{70,-32}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-40},{70,-42}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-50},{70,-52}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{34,-62},{70,-64}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-70},{70,-72}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-80},{70,-82}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-90},{70,-92}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{34,-100},{70,-102}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-108},{70,-110}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-118},{70,-120}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{52,-128},{70,-130}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{34,-138},{70,-140}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Rectangle(
              extent={{-50,-10},{16,-14}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder),
            Line(points={{16,-10},{-16,2},{-16,-10}}, color={162,29,33},
              thickness=0.5)}),                                      Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{120,100}})),
        Documentation(revisions="<html>
<ul>
<li>June 11, 2020, by Henry Nickels:<br>Reversed logic to logical switches.</li>
<li>May 29, 2020, by Henry Nickels:<br>Internalize min, max, and heat setpoints as parameters.</li>
<li>May 28, 2020, by Henry Nickels:<br>Removed CDN and WUP inputs as they were redundant to SBC and SBH. Changed cooling reset set point to percentage of total terminal units. </li>
<li>May 22, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>Calculation of the supply air temperature set point performed by the BAS and transmitted to the factory controller. </p>
<h4>Cooling Requests Reset</h4>
<p>During normal occupied mode operation, the supply air temperature set point is reset between minimum (<span style=\"font-family: Courier New;\">minSATsp</span>) and maximum (<span style=\"font-family: Courier New;\">maxSATsp</span>) values based on terminal unit cooling requests. </p>
<p>The total number of terminal unit cooling requests (<span style=\"font-family: Courier New;\">totCoolReqs</span>) is a network input that totalizes all requests from terminal units. The cooling request set point is calculated as a percentage of the total number of terminal units (<span style=\"font-family: Courier New;\">TotalTU</span>) served by the RTU (e.g. 15&percnt; of 80 terminal units = 12 cool request set point). The set point and requests are evaluated by a PI loop which outputs a value that increases from 0-1 as cooling requests increase.</p>
<p>The PI loop output is input to a linear converter that outputs the reset set point (<span style=\"font-family: Courier New;\">ySATsetpoint</span>).</p>
<h4>Setback Cooling</h4>
<p>During setback cooling mode (<span style=\"font-family: Courier New;\">SBC</span>) the supply air temperature set point is calculated from the highest space temperature (<span style=\"font-family: Courier New;\">highSpaceT</span>) less a fixed offset of ten degrees. (e.g. highest reported space temperature of (25 degC + 273.15K) &ndash; 10 = (15 degC + 273.15K) supply temperature set point). The fixed value offset should be based on the unit cooling capacity per hour. </p>
<h4>Setback Heating</h4>
<p>During setback heating mode (<span style=\"font-family: Courier New;\">SBH</span>) the supply air temperature set point is commanded to a fixed value (<span style=\"font-family: Courier New;\">UnOcHtSetpt</span>), usually around (35 degC + 273.15K) depending on the unit heating capacity. </p>
</html>"),
        experiment(
          StopTime=1200,
          Interval=1200,
          __Dymola_Algorithm="Dassl"));
    end TSupSet;

    block DDSPset
      "Down duct static pressure set point calculation based on terminal unit damper position"
      Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
        controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
        yMax=100,
        yMin=0,
        reset=Buildings.Controls.OBC.CDL.Types.Reset.Disabled)
        "calculate reset value based on most open terminal unit damper position "
        annotation (Placement(transformation(extent={{-50,14},{-30,34}})));
                Buildings.Controls.OBC.CDL.Interfaces.RealInput mostOpenDam
        "most open damper position of all terminal units"
        annotation (Placement(transformation(extent={{-138,-16},{-98,24}})));
      Buildings.Controls.OBC.CDL.Continuous.Line lin
        annotation (Placement(transformation(extent={{-4,14},{16,34}})));
               Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X1(k=0)
        "linear conversion constant (min)"
        annotation (Placement(transformation(extent={{-50,72},{-30,92}})));
               Buildings.Controls.OBC.CDL.Continuous.Sources.Constant X2(k=100)
        "linear conversion constant (max)"
        annotation (Placement(transformation(extent={{-50,-28},{-30,-8}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDDSPstpt(
        final unit="Pa",
        final displayUnit="bar",
        final quantity="Pressure")
        "calculated down duct static pressure set point"
        annotation (Placement(transformation(extent={{40,4},{80,44}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant DamSetpt(k=90)
        "terminal unit damper set point 90 percent open"
        annotation (Placement(transformation(extent={{-88,14},{-68,34}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxDDSPsetpt(k=
            maxDDSPset) "maximum allowable set point reset value"
        annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minDDSPsetpt(k=
            minDDSPset) "minimum reset value"
        annotation (Placement(transformation(extent={{-88,46},{-68,66}})));
      parameter Real maxDDSPset=5e-3
      "maximum down duct static pressure reset value";
      parameter Real minDDSPset=1.25e-3
      "minimum down duct static pressure reset value";
    equation
      connect(conPID.u_m, mostOpenDam)
        annotation (Line(points={{-40,12},{-40,4},{-118,4}}, color={0,0,127}));
      connect(conPID.y, lin.u)
        annotation (Line(points={{-28,24},{-6,24}}, color={0,0,127}));
      connect(X1.y, lin.x1) annotation (Line(points={{-28,82},{-12,82},{-12,32},
              {-6,32}}, color={0,0,127}));
      connect(X2.y, lin.x2) annotation (Line(points={{-28,-18},{-20,-18},{-20,
              20},{-6,20}}, color={0,0,127}));
      connect(lin.y, yDDSPstpt)
        annotation (Line(points={{18,24},{60,24}}, color={0,0,127}));
      connect(conPID.u_s, DamSetpt.y)
        annotation (Line(points={{-52,24},{-66,24}}, color={0,0,127}));
      connect(lin.f2, maxDDSPsetpt.y) annotation (Line(points={{-6,16},{-12,16},
              {-12,-40},{-64,-40}}, color={0,0,127}));
      connect(minDDSPsetpt.y, lin.f1) annotation (Line(points={{-66,56},{-20,56},
              {-20,28},{-6,28}}, color={0,0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{40,
                100}}), graphics={
            Rectangle(extent={{-94,98},{32,-58}}, lineColor={162,29,33},
              radius=20),                                                  Text(
              extent={{-48,-30},{-2,-58}},
              lineColor={162,29,33},
              textString="DDSPset"),
            Line(points={{-36,20},{-26,10}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-36,4},{-26,-6}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-26,10},{-36,4}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-26,-6},{-36,-12}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-36,20},{-20,20},{6,20}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-36,-12},{-20,-12},{6,-12}}, color={162,29,33},
              thickness=0.5),
            Line(points={{6,20},{8,18},{20,4}}, color={162,29,33},
              thickness=0.5),
            Line(points={{6,-12},{20,4}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-46,20},{-36,10}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-46,4},{-36,-6}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-36,10},{-46,4}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-36,-6},{-46,-12}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-46,20},{-74,20},{-80,20}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-46,-12},{-74,-12},{-80,-12}}, color={162,29,33},
              thickness=0.5),
            Rectangle(extent={{-24,30},{-2,22}}, lineColor={162,29,33},
              lineThickness=0.5),
            Line(points={{-18,22},{-18,12}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-2,28},{4,28}}, color={162,29,33},
              thickness=0.5),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-69.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-63.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-57.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-51.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-45.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-39.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-33.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-27.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-21.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-15.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-9.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-3.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={2.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={8.5,79.5},
              rotation=90),
            Rectangle(
              extent={{-1,42},{1,-42}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder,
              origin={-30,87},
              rotation=90),
            Rectangle(
              extent={{-18,1},{18,-1}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-47,50},
              rotation=90),
            Line(points={{22,-8},{1.95996e-38,-3.20085e-22},{4,-8}},
                                                      color={162,29,33},
              origin={-56,46},
              rotation=90,
              thickness=0.5)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},
                {40,100}})),
        Documentation(info="<html>
<p>Calculation of the down duct static pressure set point performed by the BAS and transmitted to the factory controller. </p>
<h4>Down Duct Static Pressure Set Point Reset</h4>
<p>This algorithm is intended to reset the down duct static pressure set point (<code>yDDSPstpt</code>) to maintain the most open terminal unit damper position (<code>mostOpenDam</code>) at 90&percnt; open (i.e. The terminal unit air flow set point is satisfied with its primary air damper 90&percnt; open). The down duct static pressure set point is reset between minimum (<code>minDDSPset</code>) and maximum (<code>maxDDSPset</code>) values determined by TAB. </p>
</html>",     revisions="<html>
<ul>
<li>May 29, 2020, by Henry Nickels:<br>Internalize min and max setpoints as parameters.</li>
<li>May 27, 2020, by Henry Nickels:<br>First implementation.</li>
</ul>
</html>"));
    end DDSPset;

    block MinOAset "minimum outside air flow set point"
      Buildings.Controls.OBC.CDL.Logical.Switch swi
        annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
      input Buildings.Controls.OBC.CDL.Interfaces.BooleanInput Occ
        "true when RTU mode is occupied"
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0)
        "set outside air flow set point to zero when not occupied mode"
        annotation (Placement(transformation(extent={{-86,6},{-66,26}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yminOAflowStpt(unit=
            "m3/s", quantity="VolumeFlowRate")
        "active outside air flow set point sent to factory controller"
        annotation (Placement(transformation(extent={{20,-20},{60,20}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOAsetpoint(k=
            minOAset)
        annotation (Placement(transformation(extent={{-86,-36},{-66,-16}})));
      parameter Real minOAset(
      final unit="m3/s",
      final quantity="VolumeFlowRate")=0.8
      "minimum outside air flow set point";
    equation
      connect(swi.u2, Occ)
        annotation (Line(points={{-38,0},{-120,0}}, color={255,0,255}));
      connect(swi.u1, con.y) annotation (Line(points={{-38,8},{-52,8},{-52,16},
              {-64,16}}, color={0,0,127}));
      connect(swi.y, yminOAflowStpt)
        annotation (Line(points={{-14,0},{40,0}}, color={0,0,127}));
      connect(minOAsetpoint.y, swi.u3) annotation (Line(points={{-64,-26},{-52,-26},
              {-52,-8},{-38,-8}}, color={0,0,127}));
      annotation (
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{20,
                40}}), graphics={Rectangle(extent={{-100,40},{20,-60}},
                lineColor={162,29,33},
              radius=20),                Text(
              extent={{-60,-38},{-16,-66}},
              lineColor={162,29,33},
              textString="minOAset",
              lineThickness=0.5,
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Line(points={{-76,-12},{-60,-12},{-4,-12}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-76,-44},{-60,-44},{-4,-44}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-76,-12},{-74,-14},{-62,-28}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-76,-44},{-62,-28}}, color={162,29,33},
              thickness=0.5),
            Ellipse(extent={{-18,-26},{-14,-30}}, lineColor={162,29,33},
              lineThickness=0.5,
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Line(points={{-14,-26},{-6,-16}}, color={162,29,33},
              thickness=0.5),
            Line(points={{-26,-40},{-18,-30}}, color={162,29,33},
              thickness=0.5),
            Rectangle(extent={{-50,-14},{-46,-42}}, lineColor={162,29,33},
              lineThickness=0.5,
              fillColor={162,29,33},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-79.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-73.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-67.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-61.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-55.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-49.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-43.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-37.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-31.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-25.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-19.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-13.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-7.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-7.5,0.5},{7.5,-0.5}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-1.5,27.5},
              rotation=90),
            Rectangle(
              extent={{-1,42},{1,-42}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.HorizontalCylinder,
              origin={-40,35},
              rotation=90),
            Rectangle(
              extent={{-11,1},{11,-1}},
              lineColor={162,29,33},
              fillColor={162,29,33},
              fillPattern=FillPattern.VerticalCylinder,
              origin={-29,7},
              rotation=90),
            Line(points={{-30,18},{-34,8},{-30,8}}, color={162,29,33},
              thickness=0.5)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},
                {20,40}})),
        Documentation(revisions="<html>
<ul>
<li>May 28, 2020, by Henry Nickels:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>If operating mode is occupied (<code>Occ</code>) select minimum outside air flow set point (<code>minOAflowStpt</code>), otherwise select zero flow set point. Decision made by the BAS and transmitted to the factory controller (<code>yminOAflowStpt</code>). </p>
</html>"));
    end MinOAset;

    package Validation
      "This package contains models that simulate the blocks in Buildings.Controls.OBC.FDE.PackagedRTUs"
      model ControllerSimulation
        "Simulates operation of packaged RTU controller."
        BAScontroller bAScontroller(
          pBldgSPset=0.005,
          pTotalTU=30,
          minSATset=285.15,
          maxSATset=297.15,
          HeatSet=308.15,
          maxDDSPset=0.012056,
          minDDSPset=0.003014)
          annotation (Placement(transformation(extent={{46,-2},{66,24}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Pulse OccGen(width=0.5,
            period=2880)
          annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
        Buildings.Controls.OBC.CDL.Integers.OnCounter OccReqGen(y_start=0)
          annotation (Placement(transformation(extent={{-60,44},{-48,56}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
          width=0.125,
          period=1440,
          startTime=1220)
          annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
          width=0.875,
          period=1440,
          startTime=2160)
          annotation (Placement(transformation(extent={{-90,6},{-70,26}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
          width=0.275,
          period=1440,
          startTime=440)
          annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
        Buildings.Controls.OBC.CDL.Integers.OnCounter SBCreqGen(y_start=0)
          annotation (Placement(transformation(extent={{-60,10},{-48,22}})));
        Buildings.Controls.OBC.CDL.Integers.OnCounter SBHreqGen(y_start=0)
          annotation (Placement(transformation(extent={{-60,-22},{-48,-10}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
          width=0.25,
          period=680,
          startTime=1000) annotation (Placement(transformation(extent={{-90,-58},
                  {-70,-38}})));
        Buildings.Controls.OBC.CDL.Integers.OnCounter totCoolReqsGen(y_start=0)
          annotation (Placement(transformation(extent={{-60,-54},{-48,-42}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine highSpaceTGen(
          amplitude=5,
          freqHz=1/3600,
          offset=27 + 273.15) annotation (Placement(transformation(extent={{-90,
                  -88},{-70,-68}})));
        Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
          amplitude=10,
          freqHz=1/4120,
          offset=90) annotation (Placement(transformation(extent={{-90,-120},
                  {-70,-100}})));
        Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=false)
          annotation (Placement(transformation(extent={{-128,-72},{-108,-52}})));
      equation
        connect(bAScontroller.Occ, OccGen.y) annotation (Line(points={{44,22},{
                -12,22},{-12,82},{-68,82}}, color={255,0,255}));
        connect(OccReqGen.trigger, booPul.y)
          annotation (Line(points={{-61.2,50},{-68,50}}, color={255,0,255}));
        connect(bAScontroller.OccReq, OccReqGen.y) annotation (Line(points={{44,
                19},{-16,19},{-16,50},{-46.8,50}}, color={255,127,0}));
        connect(booPul1.y, SBCreqGen.trigger)
          annotation (Line(points={{-68,16},{-61.2,16}}, color={255,0,255}));
        connect(booPul2.y, SBHreqGen.trigger)
          annotation (Line(points={{-68,-16},{-61.2,-16}}, color={255,0,255}));
        connect(SBCreqGen.y, bAScontroller.SBCreq) annotation (Line(points={{
                -46.8,16},{-12,16},{-12,13.2},{44,13.2}}, color={255,127,0}));
        connect(SBHreqGen.y, bAScontroller.SBHreq) annotation (Line(points={{
                -46.8,-16},{-16,-16},{-16,10.2},{44,10.2}}, color={255,127,0}));
        connect(booPul3.y, totCoolReqsGen.trigger)
          annotation (Line(points={{-68,-48},{-61.2,-48}}, color={255,0,255}));
        connect(bAScontroller.totCoolReqs, totCoolReqsGen.y) annotation (Line(
              points={{44,7.2},{-12,7.2},{-12,-48},{-46.8,-48}}, color={255,127,
                0}));
        connect(bAScontroller.highSpaceT, highSpaceTGen.y) annotation (Line(
              points={{44,3.6},{-8,3.6},{-8,-78},{-68,-78}}, color={0,0,127}));
        connect(bAScontroller.mostOpenDam, mostOpenDamGen.y) annotation (Line(
              points={{44,0.4},{-4,0.4},{-4,-110},{-68,-110}}, color={0,0,127}));
        connect(OccReqGen.reset, OccGen.y) annotation (Line(points={{-54,42.8},
                {-42,42.8},{-42,82},{-68,82}}, color={255,0,255}));
        connect(SBHreqGen.reset, SBCreqGen.reset) annotation (Line(points={{-54,
                -23.2},{-54,-28},{-42,-28},{-42,4},{-54,4},{-54,8.8}}, color={
                255,0,255}));
        connect(SBHreqGen.reset, OccGen.y) annotation (Line(points={{-54,-23.2},
                {-54,-28},{-42,-28},{-42,82},{-68,82}}, color={255,0,255}));
        connect(con.y, totCoolReqsGen.reset) annotation (Line(points={{-106,-62},
                {-54,-62},{-54,-55.2}}, color={255,0,255}));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Ellipse(lineColor = {75,138,73},
                      fillColor={255,255,255},
                      fillPattern = FillPattern.Solid,
                      extent={{-100,-100},{100,100}}),
              Polygon(lineColor = {0,0,255},
                      fillColor = {75,138,73},
                      pattern = LinePattern.None,
                      fillPattern = FillPattern.Solid,
                      points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
              coordinateSystem(preserveAspectRatio=false)),
          experiment(StopTime=5760, __Dymola_Algorithm="Dassl"),
          Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller\">
Buildings.Controls.OBC.FDE.PackagedRTUs.BAScontroller</a>.
</p>
</html>"));
      end ControllerSimulation;
      annotation (Icon(graphics={
            Rectangle(
              lineColor={200,200,200},
              fillColor={248,248,248},
              fillPattern=FillPattern.HorizontalCylinder,
              extent={{-100,-100},{100,100}},
              radius=25.0),
            Rectangle(
              lineColor={128,128,128},
              extent={{-100,-100},{100,100}},
              radius=25.0),
            Polygon(
              origin={8,14},
              lineColor={78,138,73},
              fillColor={78,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}));
    end Validation;
    annotation (Documentation(info="<html>
<p>This package contains BAS interface controls for packaged factory controledl sequences. </p>
</html>"), Icon(graphics={Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            radius=30), Text(
            extent={{-98,42},{106,-46}},
            lineColor={0,0,0},
            textString="RTU")}));
  end PackagedRTUs;
  annotation (Documentation(info="<html>
<p>
This package contains control sequences from Facility Dynamics Engineering's standard library.
</p>
</html>"), Icon(graphics={Bitmap(
          extent={{-94,-94},{96,94}},
          imageSource=
              "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",
          fileName=
              "modelica://Buildings/../../../../Current Jobs/FDE small block logo only.jpg")}));

end FDE;
