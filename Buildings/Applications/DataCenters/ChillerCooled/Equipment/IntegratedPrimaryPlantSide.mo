within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model IntegratedPrimaryPlantSide
  "Integrated waterside economizer on the plant side in a primary-only chilled water System"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialIntegratedPrimary(
    final m_flow_nominal={m1_flow_chi_nominal,m2_flow_chi_nominal,m1_flow_chi_nominal,
      m2_flow_chi_nominal,numChi*m2_flow_chi_nominal,m2_flow_chi_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});

  Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={numChi*m2_flow_chi_nominal,-numChi*m2_flow_chi_nominal,
        m2_flow_wse_nominal},
    dp_nominal={0,0,0}) "Junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,-30}})));
equation
  connect(val5.port_b, jun3.port_1)
    annotation (Line(points={{40,-20},{10,-20}}, color={0,127,255}));
  connect(senTem.port_b, jun3.port_3)
    annotation (Line(points={{8,24},{0,24},{0,-10}},
        color={0,127,255}));
  connect(jun3.port_2, val6.port_a)
    annotation (Line(points={{-10,-20},{-30,-20}}, color={0,127,255}));
  connect(chiPar.port_a2, val6.port_a) annotation (Line(points={{-40,24},{-20,
          24},{-20,-20},{-30,-20}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model implements an integrated water-side economizer (WSE)
on the plant side of the primary-only chilled water system, as shown in the following figure.
In the configuration, users can model multiple chillers with only one integrated WSE.
</p>
<p align=\"center\">
 <img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Equipment/IntegratedPrimaryPlantSide.png\"/>
</p>
<h4>Implementation</h4>
<p>
 The WSE located on the load side can see the warmest return chilled water,
 and hence can maximize the use time of the heat exchanger.
 This system have three operation modes:
 free cooling (FC) mode, partial mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode.
</p>
<p>
 There are 6 valves for on/off use only,
 which can be controlled in order to switch among FC, PMC and FMC mode.
</p>
<ul>
 <li>V1 and V2 are associated with the chiller.
 When the chiller is commanded to run, V1 and V2 will be open, and vice versa.
 Note that when the number of chillers are larger than 1,
 V1 and V2 are vectored models with the same dimension as the chillers.
 </li>
 <li>V2 and V3 are associated with the WSE.
  When the WSE is commanded to run, V3 and V4 will be open, and vice versa.
 </li>
 <li>V5 is for FMC only. When FMC is on, V5 is commanded to on.
 Otherwise, V5 is off.
 </li>
 <li>V6 is for FC only. When FC is on, V6 is commanded to on.
 Otherwise, V6 is off.
 </li>
</ul>
<p>
The details about how to switch among different cooling modes are shown as:
</p>
<p style=\"margin-left: 30px;\">For Free Cooling (FC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are closed, and V3 and V4 are open; </li>
<li style=\"margin-left: 45px;\">V5 is closed; </li>
<li style=\"margin-left: 45px;\">V6 is open; </li>
</ul>
<p style=\"margin-left: 30px;\">For Partially Mechanical Cooling (PMC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are open; </li>
<li style=\"margin-left: 45px;\">V5 is closed; </li>
<li style=\"margin-left: 45px;\">V6 is closed; </li>
</ul>
<p style=\"margin-left: 30px;\">For fully Mechanical Cooling (FMC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are closed; </li>
<li style=\"margin-left: 45px;\">V5 is open; </li>
<li style=\"margin-left: 45px;\">V6 is closed; </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 13, 2021, by Kathryn Hinkelman:<br/>
Added junctions.
</li>
<li>
July 1, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Line(points={{12,-44},{-18,-44}}, color={0,128,255})}));
end IntegratedPrimaryPlantSide;
