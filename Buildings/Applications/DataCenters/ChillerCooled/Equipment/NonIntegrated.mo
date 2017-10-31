within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model NonIntegrated
  "Non-integrated waterside economizer in chilled water system"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE(
    final numVal=4,
    final m_flow_nominal={m1_flow_chi_nominal,m2_flow_chi_nominal,m1_flow_wse_nominal,
      m2_flow_wse_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});

equation
  connect(port_a2, wse.port_a2)
    annotation (Line(points={{100,-60},{80,-60},{80,
          24},{60,24}},color={0,127,255}));
  connect(port_a2, chiPar.port_a2)
    annotation (Line(points={{100,-60},{-8,-60},
          {-8,24},{-40,24}},color={0,127,255}));
  connect(chiPar.port_b2, port_b2)
    annotation (Line(points={{-60,24},{-72,24},{
          -72,-60},{-100,-60}},color={0,127,255}));
  connect(senTem.port_b, port_b2)
    annotation (Line(points={{8,24},{0,24},{0,-40},
          {-72,-40},{-72,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(points={{64,0},{74,0},{74,-60},{90,-60}}, color={0,128,255}),
        Line(points={{-72,0},{-76,0},{-76,-60},{-92,-60}}, color={0,128,255}),
        Line(points={{90,-60},{90,-60},{-14,-60},{-14,0},{-24,0}}, color={0,128,
              255}),
        Line(points={{12,0},{12,-40},{12,-40},{-76,-40}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This model implements a non-integrated water-side economizer (WSE)
in the chilled water system, as shown in the following figure.
In the configuration, users can model multiple chillers with only one integrated WSE.
This model can be used in both primary-only and primary-secondary pumping system.
</p>
<p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Equipment/Nonintegrated.png\" alt=\"image\"/>
</p>
<h4>Implementation</h4>
<p>
The WSE is in parallel with chillers on both the condenser and chilled water sides.
If the economizer cannot meet the entire load then it must be shut off.
Otherwise, the relatively warm economier leaving water will be mixed with the cold chiller leaving water
and hence the plant leaving water temperature will be above setpoint.
For this configuration, there are only two cooling modes:
free cooling (FC) mode and fully mechanical cooling (FMC) mode.
</p>
<p>
There are 4 valves for on/off use only,
which can be controlled in order to switch between FC and FMC mode.
</p>
<ul>
 <li>V1 and V2 are associated with the chiller.
 When the chiller is commanded to run, V1 and V2 will be open, and vice versa.
 Note that when the number of chillers are larger than 1,
 V1 and V2 are vectored models with the same dimension as the chillers.
 </li>
 <li>V3 and V4 are associated with the WSE.
 When the WSE is commanded to run, V3 and V4 will be open, and vice versa.
 </li>
</ul>
<p>
The details about how to switch among different cooling modes are shown as:
</p>
<p style=\"margin-left: 30px;\">
For Free Cooling (FC) Mode:
</p>
<ul>
 <li style=\"margin-left: 45px;\">V1 and V2 are closed, and V3 and V4 are open;</li>
</ul>
<p style=\"margin-left: 30px;\">
For Fully Mechanical Cooling (FMC) Mode:
</p>
<ul>
 <li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are closed;</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 1, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NonIntegrated;
