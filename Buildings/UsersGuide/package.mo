within Buildings;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free open-source library for modeling of building energy and control systems.
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>.
We welcome contributions from different users to further advance this library,
whether it is through collaborative model development, through model use and testing
or through requirements definition or by providing feedback regarding the model applicability
to solve specific problems.
</p>
<p>
The library has the following <i>User's Guides</i>:
</p>
<ol>
<li>
General information about the use of the <code>Buildings</code> library
is available at
<a href=\"http://simulationresearch.lbl.gov/modelica/userGuide\">
http://simulationresearch.lbl.gov/modelica/userGuide</a>.
This web site covers general information that is not specific to the
use of individual packages or models.
Discussed topics include
how to get started, best practices, how to post-process results using Python,
work-around for problems and how to develop models.<br/>
</li>
<li>
Some packages have their own
User's Guides that can be accessed by the links below.
These User's Guides are explaining items that are specific to the
particular package.<br/>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Airflow.Multizone.UsersGuide\">Airflow.Multizone</a>
   </td>
   <td valign=\"top\">Package for multizone airflow and contaminant transport.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">BoundaryConditions</a>
   </td>
   <td valign=\"top\">Package for computing boundary conditions, such as solar irradiation.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Controls.OBC\">Controls.OBC</a>
   </td>
   <td valign=\"top\">Package with the Control Description Language (CDL) and with control sequences that are implemented using CDL.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.DHC\">DHC</a>
   </td>
   <td valign=\"top\">Package with models for district heating and cooling systems.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Package for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
   </td>
   <td valign=\"top\">Package with valves and air dampers.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling\">Fluid.DXSystems.Cooling</a>
   </td>
   <td valign=\"top\">Package with components for DX systems for cooling.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.DXSystems.Heating\">Fluid.DXSystems.Heating</a>
   </td>
   <td valign=\"top\">Package with components for DX systems for heating.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">Fluid.FMI</a>
   </td>
   <td valign=\"top\">Package with blocks to export thermofluid flow models as Functional Mockup Units.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Geothermal.Borefields\">Fluid.Geothermal.Borefields</a>
   </td>
   <td valign=\"top\">Package with models for geothermal borefields.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Geothermal.ZonedBorefields\">Fluid.Geothermal.ZonedBorefields</a>
   </td>
   <td valign=\"top\">Package with models for zoned geothermal borefields in which individual zones of the borefield can be
   operated independently of other zones of the borefield.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.ActiveBeams.UsersGuide\">Fluid.HeatExchangers.ActiveBeams</a>
   </td>
   <td valign=\"top\">Package with active beams.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide\">Fluid.HydronicConfigurations.UsersGuide</a>
   </td>
   <td valign=\"top\">Package with all major hydronic configurations of heating and cooling systems.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.UsersGuide\">Fluid.HeatExchangers.DXSystems.Cooling</a>
   </td>
   <td valign=\"top\">Package with direct evaporative cooling coils.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.DXSystems.Heating.UsersGuide\">Fluid.HeatExchangers.DXSystems.Heating</a>
   </td>
   <td valign=\"top\">Package with air source DX heating coils.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">Fluid.HeatExchangers.RadiantSlabs</a>
   </td>
   <td valign=\"top\">Package with radiant slabs.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Package with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
   </td>
   <td valign=\"top\">Package with sensors.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">Fluid.Storage</a>
   </td>
   <td valign=\"top\">Package with storage tanks and an expansion vessel.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.SolarCollectors.UsersGuide\">Fluid.SolarCollectors</a>
   </td>
   <td valign=\"top\">Package with solar collectors.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Interfaces.UsersGuide\">Fluid.Interfaces</a>
   </td>
   <td valign=\"top\">Base models that can be used by developers to implement new models.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.HeatTransfer.UsersGuide\">HeatTransfer</a>
   </td>
   <td valign=\"top\">Package for heat transfer in building constructions.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Templates\">Templates</a>
   </td>
   <td valign=\"top\">Package with pre-configured templates of HVAC systems and their control sequences.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.MixedAir\">ThermalZones.Detailed.UsersGuide.MixedAir</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using the mixed air assumption.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">ThermalZones.Detailed.UsersGuide.CFD</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.FFD.UsersGuide\">ThermalZones.Detailed.Examples.FFD.UsersGuide</a>
   </td>
   <td valign=\"top\">Package with examples that use the Fast Fluid Dynamics program for
                    the computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide\">ThermalZones.EnergyPlus.UsersGuide</a>
   </td>
   <td valign=\"top\">Package for Spawn of EnergyPlus with models that use EnergyPlus to simulate
                    one or several building envelope models.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Utilities.IO.Python_3_8.UsersGuide\">Utilities.IO.Python_3_8</a>
   </td>
   <td valign=\"top\">Package to call Python functions from Modelica.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Utilities.Plotters.UsersGuide\">Utilities.Plotters</a>
   </td>
   <td valign=\"top\">Package that allow writing time series and scatter plots to an html output file.</td>
</tr>

</table><br/>
</li>
<li>
There are also tutorials available at
<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>.
These tutorials contain step by step instructions for how to build system models.
</li>
</ol>
</html>"));
end UsersGuide;
