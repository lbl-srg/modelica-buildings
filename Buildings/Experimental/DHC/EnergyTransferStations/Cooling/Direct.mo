within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model Direct "Direct cooling ETS model for district energy systems with in-building
  pumping and deltaT control"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialDirect(
      final typ=DHC.Types.DistrictSystemType.Cooling,
      final have_chiWat=true,
      final have_heaWat=false,
      con(reverseActing=false),
      nPorts_aChiWat=1,
      nPorts_bChiWat=1);
equation
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-180,-280}}, color={0,127,255}));
  connect(ports_aChiWat[1], senTBuiRet.port_a)
    annotation (Line(points={{-300,200},{-220,200}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo) annotation (Line(points={{50,200},{160,
          200},{160,-240},{260,-240},{260,-280},{300,-280}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1])
    annotation (Line(points={{250,200},{300,200}}, color={0,127,255}));
 annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model with in-building pumping and
deltaT control. The design is based on a typical district cooling ETS described
in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>.
As shown in the figure below, the district and building piping are hydronically
coupled. The control valve ensures that the return temperature to the district
cooling network is at or above the minimum specified value. This configuration
naturally results in a fluctuating building supply tempearture.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Direct.png\" alt=\"DC ETS Direct\"/>
</p>
<h4>
Reference
</h4>
<p>American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019).
Chapter 5: End User Interface. In <i>District Cooling Guide</i>, Second Edition and
<i>Owner's Guide for Buildings Served by District Cooling</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 27, 2024, by David Blum:<br/>
Update icon and fix port orientation to align with convention.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3606\">issue #3606</a>.
</li>
<li>
May 5, 2023, by David Blum:<br/>
Removed assignment of check valve <code>allowFlowReversal=false</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3389\">#3389</a>.
</li>
<li>
April 7, 2023, by David Blum:<br/>
Change to extend from <code>Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialDirect</code>.
</li>
<li>
January 11, 2023, by Michael Wetter:<br/>
Changed controls to use CDL. Changed PID to PI as default for controller.
</li>
<li>
January 2, 2023, by Kathryn Hinkelman:<br/>
Set pressure drops at junctions to 0 and removed parameter <code>dp_nominal</code>
</li>
<li>
December 28, 2022, by Kathryn Hinkelman:<br/>
Simplified the control implementation for the district return stream. Improved default control parameters.
</li>
<li>
December 23, 2022, by Kathryn Hinkelman:<br/>
Removed extraneous <code>m*_flow_nominal</code> parameters because
<code>mBui_flow_nominal</code> can be used across all components.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912\">#2912</a>.
</li>
<li>
November 11, 2022, by Michael Wetter:<br/>
Changed check valve to use version of <code>Buildings</code> library, and hence no outer <code>system</code> is needed.
</li>
<li>March 20, 2022, by Chengnan Shi:<br/>Update with base class partial model and standard PI control.</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>First implementation. </li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-71,-8},{71,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-30,-73},
          rotation=90),
        Rectangle(
          extent={{-8,30},{8,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-82,112},
          rotation=90),
        Rectangle(
          extent={{-52,-8},{52,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={28,-90},
          rotation=90),
        Rectangle(
          extent={{7,106},{-7,-106}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-4,5},
          rotation=90),
        Rectangle(
          extent={{-71,-8},{71,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={104,69},
          rotation=90),
        Rectangle(
          extent={{-37,-7},{37,7}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={29,83},
          rotation=90),
        Rectangle(
          extent={{-32,-8},{32,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-104,108},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-22,112},
          rotation=360),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-42,112},
          rotation=180),
        Rectangle(
          extent={{-8,24},{8,-24}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={12,112},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-104,66},
          rotation=90),
        Rectangle(
          extent={{-29,-8},{29,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-104,27},
          rotation=90)}));
end Direct;
