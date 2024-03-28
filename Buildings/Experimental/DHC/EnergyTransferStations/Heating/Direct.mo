within Buildings.Experimental.DHC.EnergyTransferStations.Heating;
model Direct "Direct heating ETS model for district energy systems with in-building
  pumping and deltaT control"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialDirect(
      final typ=DHC.Types.DistrictSystemType.HeatingGeneration2to4,
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
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Direct.png\" alt=\"DC ETS Direct\"/>
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
</html>"));
end Direct;
