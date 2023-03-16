within Buildings.Experimental.DHC.EnergyTransferStations.Cooling;
model Indirect
  "Indirect cooling energy transfer station for district energy systems"
  extends
    Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.PartialIndirect(
      QChiWat_flow_nominal=Q_flow_nominal,
      final typ=DHC.Types.DistrictSystemType.Cooling,
      final have_chiWat=true,
      final have_heaWat=false,
      Q_flow_nominal(max=0),
      nPorts_aChiWat=1,
      nPorts_bChiWat=1,
    con(reverseActing=false));
equation
  connect(ports_aChiWat[1], senTBuiRet.port_a)
    annotation (Line(points={{-300,200},{-218,200}}, color={0,127,255}));
  connect(port_aSerCoo, senTDisSup.port_a)
    annotation (Line(points={{-300,-280},{-220,-280}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_bSerCoo)
    annotation (Line(points={{200,-280},{300,-280}}, color={0,127,255}));
  connect(senTBuiSup.port_b, ports_bChiWat[1]) annotation (Line(points={{-36,
          -204},{-60,-204},{-60,180},{240,180},{240,200},{300,200}}, color={0,
          127,255}));
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
</html>"));
end Indirect;
