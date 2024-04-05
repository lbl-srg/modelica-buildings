within Buildings.DHC.EnergyTransferStations.Heating;
model Direct "Direct heating ETS model for district energy systems with in-building
  pumping and deltaT control"
  extends
    Buildings.DHC.EnergyTransferStations.BaseClasses.PartialDirect(
      final typ=Buildings.DHC.Types.DistrictSystemType.HeatingGeneration2to4,
      final have_chiWat=false,
      final have_heaWat=true,
      nPorts_aHeaWat=1,
      nPorts_bHeaWat=1);
equation
  connect(senTDisRet.port_b, port_bSerHea) annotation (Line(points={{50,200},{160,
          200},{160,-240},{300,-240}}, color={0,127,255}));
  connect(port_aSerHea, senTDisSup.port_a) annotation (Line(points={{-300,-240},
          {-220,-240},{-220,-280},{-180,-280}}, color={0,127,255}));
  connect(ports_aHeaWat[1], senTBuiRet.port_a) annotation (Line(points={{-300,260},
          {-240,260},{-240,200},{-220,200}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bHeaWat[1]) annotation (Line(points={{250,200},
          {260,200},{260,260},{300,260}}, color={0,127,255}));
 annotation (
    defaultComponentName="etsCoo",
    Documentation(info="<html>
<p>
Direct heating energy transfer station (ETS) model with in-building pumping and
deltaT control. The design is based on a typical district heating ETS described
in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Heating Guide</a>.
As shown in the figure below, the district and building piping are hydronically
coupled. The control valve ensures that the return temperature to the district
heating network is at or below the maximum specified value. This configuration
naturally results in a fluctuating building supply tempearture.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/DHC/EnergyTransferStations/Cooling/Direct.png\" alt=\"DC ETS Direct\"/>
</p>
<h4>
Reference
</h4>
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
          extent={{-27,-8},{27,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-66,71},
          rotation=90),
        Rectangle(
          extent={{-8,67},{8,-67}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={3,-28},
          rotation=90),
        Rectangle(
          extent={{-41,-8},{41,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={30,57},
          rotation=90),
        Rectangle(
          extent={{-88,8},{88,-8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={66,52},
          rotation=90),
        Rectangle(
          extent={{-8,26},{8,-26}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-48,90},
          rotation=90),
        Rectangle(
          extent={{-21,-9},{21,9}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-49,119},
          rotation=90),
        Rectangle(
          extent={{-12,-8},{12,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={30,-84},
          rotation=90),
        Rectangle(
          extent={{-7,21},{7,-21}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={43,-99},
          rotation=90),
        Rectangle(
          extent={{-25,8},{25,-8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={66,-117},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-18,90},
          rotation=180),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={2,90},
          rotation=360),
        Rectangle(
          extent={{-8,8},{8,-8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={20,90},
          rotation=90),
        Rectangle(
          extent={{-8,16},{8,-16}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={56,132},
          rotation=90),
        Polygon(
          points={{10,-14},{10,14},{-10,0},{10,-14}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          origin={-66,34},
          rotation=90),
        Rectangle(
          extent={{-83,-8},{83,8}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-66,-59},
          rotation=90)}));
end Direct;
