within Buildings.Experimental.DHC.EnergyTransferStations.Heating;
model Indirect
  "Indirect heating energy transfer station for district energy systems"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialIndirect(
      QHeaWat_flow_nominal=Q_flow_nominal,
      final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.HeatingGeneration2to4,
      final have_chiWat=false,
      final have_heaWat=true,
      Q_flow_nominal(min=0),
      nPorts_aHeaWat=1,
      nPorts_bHeaWat=1);
equation
  connect(ports_aHeaWat[1], senTBuiRet.port_a) annotation (Line(points={{-300,260},
          {-240,260},{-240,200},{-218,200}}, color={0,127,255}));
  connect(port_aSerHea, senTDisSup.port_a) annotation (Line(points={{-300,-240},
          {-260,-240},{-260,-280},{-220,-280}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bHeaWat[1]) annotation (Line(points={{-36,-204},
          {-60,-204},{-60,180},{220,180},{220,260},{300,260}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerHea) annotation (Line(points={{200,-280},
          {242,-280},{242,-240},{300,-240}}, color={0,127,255}));
  annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Indirect heating energy transfer station (ETS) model that controls the
building chilled water supply temperature by modulating a primary control valve
on the district supply side. The design is based on a typical district heating
ETS described in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Heating Guide</a>.
As shown in the figure below, the building pumping design (constant/variable)
is specified on the building side and not within the ETS.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Indirect.png\" alt=\"DHC.ETS.Indirect\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2013).
Chapter 5: Consumer Interconnection. In <i>District Heating Guide</i>.
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
January 8, 2024, by David Blum:<br/>
Correct documentation to describe heating.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3628\">
issue 3628</a>.
</li>
<li>
April 7, 2023, by David Blum:<br/>
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
          fillColor={162,29,33},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-12,42},{-2,-26}},
          fillColor={162,29,33},
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
          fillColor={162,29,33},
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
          fillColor={162,29,33},
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
          extent={{-52,-9},{52,9}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-49,88},
          rotation=90),
        Rectangle(
          extent={{-8,-15},{8,15}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={49,-24},
          rotation=90),
        Rectangle(
          extent={{-8,-12},{8,12}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-46,40},
          rotation=90),
        Rectangle(
          extent={{-8,-12},{8,12}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={46,40},
          rotation=90),
        Rectangle(
          extent={{-52,-9},{52,9}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={49,88},
          rotation=90),
        Rectangle(
          extent={{-22,-8},{22,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-66,-120},
          rotation=90),
        Rectangle(
          extent={{-63,-8},{63,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={66,-79},
          rotation=90),
        Rectangle(
          extent={{-8,-15},{8,15}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-51,-24},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-66,-88},
          rotation=270),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-66,-68},
          rotation=90),
        Rectangle(
          extent={{-21,-8},{21,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-66,-37},
          rotation=90)}));
end Indirect;
