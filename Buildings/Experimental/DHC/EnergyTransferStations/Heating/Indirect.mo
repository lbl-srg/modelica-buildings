within Buildings.Experimental.DHC.EnergyTransferStations.Heating;
model Indirect
  "Indirect cooling energy transfer station for district energy systems"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialIndirect(
      QHeaWat_flow_nominal=Q_flow_nominal,
      final typ=DHC.Types.DistrictSystemType.HeatingGeneration2to4,
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
Indirect cooling energy transfer station (ETS) model that controls the
building chilled water supply temperature by modulating a primary control valve 
on the district supply side. The design is based on a typical district cooling 
ETS described in ASHRAE's <a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">District Cooling Guide</a>. 
As shown in the figure below, the building pumping design (constant/variable) 
is specified on the building side and not within the ETS. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Cooling/Indirect.png\" alt=\"DHC.ETS.Indirect\"/>
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
April 7, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Indirect;
