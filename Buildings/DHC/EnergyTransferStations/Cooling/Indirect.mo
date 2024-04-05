within Buildings.DHC.EnergyTransferStations.Cooling;
model Indirect
  "Indirect cooling energy transfer station for district energy systems"
  extends
    Buildings.DHC.EnergyTransferStations.BaseClasses.PartialIndirect(
      QChiWat_flow_nominal=-Q_flow_nominal,
      final typ=Buildings.DHC.Types.DistrictSystemType.Cooling,
      final have_chiWat=true,
      final have_heaWat=false,
      Q_flow_nominal(max=0),
      nPorts_aChiWat=1,
      nPorts_bChiWat=1,
      con(reverseActing=false));
equation
  connect(senTBuiRet.port_a, ports_aChiWat[1])
    annotation (Line(points={{-218,200},{-300,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1]) annotation (Line(points={{-36,
          -204},{-80,-204},{-80,160},{180,160},{180,200},{300,200}}, color={0,
          127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{200,-280},{300,-280}}, color={0,127,255}));
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-220,-280}}, color={0,127,255}));
  annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Indirect cooling energy transfer station (ETS) model that controls the
building chilled water supply temperature by modulating a primary control valve
on the district supply side. The design is based on a typical district cooling
ETS described in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>.
As shown in the figure below, the building pumping design (constant/variable)
is specified on the building side and not within the ETS.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/DHC/EnergyTransferStations/Cooling/Indirect.png\" alt=\"DHC.ETS.Indirect\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2019).
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
May 30, 2023, by David Blum:<br/>
Change to extend from <code>Buildings.DHC.EnergyTransferStations.BaseClasses.PartialDirect</code>.
</li>
<li>
March 16, 2023, by David Blum:<br/>
Fixed building supply temperature controller parameter <code>reverseActing</code>
by changing from <code>true</code> to <code>false</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3299\">
issue 3299</a>.
</li>
<li>
January 11, 2023, by Michael Wetter:<br/>
Changed controls to use CDL. Changed PID to PI as default for controller.
</li>
<li>
March 21, 2022, by Chengnan Shi:<br/>
Update with base class partial model.
</li>
<li>Novermber 13, 2019, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-36,48},{34,-32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,42},{-24,-26}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-24,42},{-16,-26}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-12,42},{-2,-26}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-16,42},{-12,-26}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{2,42},{10,-26}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-2,42},{2,-26}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{14,42},{22,-26}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{10,42},{14,-26}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{22,42},{26,-26}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-54,-8},{54,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-104,86},
          rotation=90),
        Rectangle(
          extent={{-22,8},{22,-8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={28,-128},
          rotation=90),
        Rectangle(
          extent={{-8,-35},{8,35}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-71,40},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-108,-66},
          rotation=90),
        Rectangle(
          extent={{-18,-8},{18,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-30,-124},
          rotation=90),
        Rectangle(
          extent={{-8,-35},{8,35}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={69,40},
          rotation=90),
        Rectangle(
          extent={{-54,-8},{54,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={104,86},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-108,-86},
          rotation=270),
        Rectangle(
          extent={{-8,-40},{8,40}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-76,-24},
          rotation=90),
        Rectangle(
          extent={{-8,-35},{8,35}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={69,-24},
          rotation=90),
        Rectangle(
          extent={{-8,-39},{8,39}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-77,-114},
          rotation=90),
        Rectangle(
          extent={{-13,-8},{13,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-108,-109},
          rotation=90),
        Rectangle(
          extent={{-13,-8},{13,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-108,-43},
          rotation=90),
        Rectangle(
          extent={{-8,-39},{8,39}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={59,-114},
          rotation=90),
        Rectangle(
          extent={{-53,-8},{53,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={106,-69},
          rotation=90)}));
end Indirect;
