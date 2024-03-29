within Buildings.Fluid.DXSystems.Cooling;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models for direct evaporation (DX) cooling coils.
</p>
<p>
The following six DX coil models are available:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>DX coil condenser</th>
      <th>DX coil model</th>
      <th>Properties</th>
      <th>Control signal</th>
  </tr>
  <tr valign=\"top\">
    <td>Air source</td>
    <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage\">
                             Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage</a></td>
    <td>Coil with multiple operating stages, each stage having a constant speed.
        Each stage has its own performance curve, which may represent
        the coil performance at different compressor speed, or the
        coil performance as it switches between cooling only,
        cooling with hot gas reheat, or heating only.</td>
    <td>Integer; <i>0</i> for off,
                 <i>1</i> for first stage,
                 <i>2</i> for second stage, etc.</td>
  </tr>
  <tr valign=\"top\">
      <td>Air source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed\">
                               Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed</a></td>
      <td>Single stage coil with constant compressor speed</td>
      <td>Boolean signal; <code>true</code> if coil is on.</td>
  </tr>
  <tr valign=\"top\">
      <td>Air source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
                               Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a></td>
      <td>Coil with variable speed compressor with lower speed limit. If the control signal
          is below the lower limit, the coil switches off. It switches on if the control
          signal is above the lower limit plus a hysteresis. By default, the minimum speed
          ratio is <code>minSpeRat</code> and obtained from the coil data
          record <code>datCoi.minSpeRat</code>. The hysteresis is by default <code>speDeaBanRat=0.05</code>.</td>
      <td>Real number; <i>0</i> for coil off, <i>1</i> for coil at full speed.</td>
  </tr>
  <tr valign=\"top\">
      <td>Water source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.WaterSource.MultiStage\">
                               Buildings.Fluid.DXSystems.Cooling.WaterSource.MultiStage</a></td>
      <td>Coil with multiple operating stages, each stage having a constant speed.
      Each stage has its own performance curve, which may represent the coil
      performance at different compressor speed, or the coil performance as
      it switches between cooling only, cooling with hot gas reheat, or heating only.</td>
      <td>Integer; <i>0</i> for off, <i>1</i> for first stage, <i>2</i> for second stage, etc.</td>
  </tr>
   <tr valign=\"top\">
      <td>Water source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed\">
                               Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed</a></td>
      <td>Single stage coil with constant compressor speed</td>
      <td>Boolean signal; <code>true</code> if coil is on.</td>
   </tr>
   <tr valign=\"top\">
      <td>Water source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.WaterSource.VariableSpeed\">
                               Buildings.Fluid.DXSystems.Cooling.WaterSource.VariableSpeed</a></td>
      <td>Coil with variable speed compressor with lower speed limit.
      If the control signal is below the lower limit, the coil switches off.
      It switches on if the control signal is above the lower limit plus a hysteresis.
      By default, the minimum speed ratio is <code>minSpeRat</code> and obtained
      from the coil data record <code>datCoi.minSpeRat</code>.
      The hysteresis is by default <code>speDeaBanRat=0.05</code>.</td>
      <td>Real number; <i>0</i> for coil off, <i>1</i> for coil at full speed.</td>
   </tr>
</table>
<h4>Control of the coils</h4>
<p>
The DX cooling coil models take as a control input the stage of operation, an on/off signal,
or the speed of the compressor. Because the thermal response of the coil is very fast,
it is important to use as the controlled variable the room air temperature,
as the room air temperature has a much slower response compare to the supply air temperature.
If the supply air temperature is used, then the control algorithm should be such that short-cycling is avoided.
</p>
<h4>Coil performance</h4>
<p>
For air source DX cooling coils, the steady-state total rate of cooling and the Energy Input Ratio (EIR)
are computed using polynomials in the air mass flow fraction (relative to the nominal mass flow rate),
the evaporator air inlet temperature and the outdoor air temperature. These polynomials are explained at
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource\">
Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource</a>.
</p>
<p>
For water source DX coils, the steady-state total rate of cooling and the EIR
are computed using polynomials in the air mass flow fraction (relative to the nominal mass flow rate),
the water mass flow fraction (relative to the nominal water mass flow rate),
the evaporator air inlet temperature and the condenser water inlet temperature.
These polynomials are explained at
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled</a>.
</p>
<h4>Evaporation of accumulated water vapor</h4>
<p>
If a coil dehumidifies air, a water film builds up on the evaporator.
When the compressor is off, this water film evaporates into the air stream.
For coils that short-cycle, this significantly decreases the dehumidification 
capacity of the coil.
The accumulation and reevaporation of water on the evaporator coil is explained at
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation</a>.
</p>
<h4>Coil dynamics</h4>
<p>Two dynamic effects are modeled: The accumulation and reevaporation of water at the evaporator,
and the thermal response of the evaporator. The dynamics of the evaporation is described at
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation</a>.
The dynamics of the evaporator is approximated by a first order response
where the time constant is a model parameter.
Hence, the dynamic response is similar to other models of the <code>Buildings.Fluid</code> package and described at
<a href=\"modelica://Buildings.Fluid.UsersGuide\">Buildings.Fluid.UsersGuide</a>.
</p>
<h4>Sensible heat ratio</h4>
<p>
The coils model two separate performances, one assuming a dry coil, and one assuming a wet coil.
The dry coil is modeled using <a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a>
and the wet coil is modeled using <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.WetCoil\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.WetCoil</a>.
Both use the same model
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource\">
Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource</a>
to compute the cooling capacity, but the wet coil uses the wet-bulb temperature
of the air inlet instead of the dry bulb temperature to compute the coil performance.
The wet coil model computes the humidity of the leaving air <i>X<sub>w,o</sub></i>, using the bypass factor model.<br/>
In the cooling coil model, this humidity is compared to the humidity at the evaporator inlet <i>X<sub>i</sub></i>.
If <i>X<sub>w,o</sub>-X<sub>i</sub> &gt; 0</i> the coil is assumed to be dry, otherwise it is wet.
This test is implemented in <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector</a>
in such a way that the transition between wet and dry coil is differentiable.<br/>
In the heating coil model, the coil is assumed to be acting as a dry coil at all times.
</p>
<p>
The split between sensible and latent heat ratio is computed using the apparatus dew point.
This calculation is implemented in
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint</a>.
Once the apparatus dew point is known, the sensible to latent heat ratio can be determined as shown in the figure below.
</p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Fluid/DXSystems/Cooling/BaseClasses/ApparatusDewPoint.png\" alt=\"image\"/> </p>
<p>
The method used is the bypass factor method, which assumes that of the leaving air,
a fraction is at the same condition as the entering air, and the other fraction is at the apparatus dew point.
This computation requires the ratio <i>UA &frasl; c<sub>p</sub></i>, which is computed in
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.UACp\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.UACp</a>.
</p>
<p>
Once the ratio <i>UA &frasl; c<sub>p</sub></i> is known,
the bypass factor is a function of the current mass flow rate only.
(Under the assumption that the velocity dependence of <i>UA</i> can be neglected.)
</p>
<h4>Limitations</h4>
<p>This model has the following limitations: </p>
<ul>
  <li>For air source DX coil models, they do not account for fan in the evaporator or in the condenser air stream.
   Fans can be modeled separately using models from the package <a href=\"modelica://Buildings.Fluid.Movers\">Buildings.Fluid.Movers</a>.
   However, if the performance curve for the energy input ratio contains electricity use for a condenser fan, then this is of course reflected by the model output.
  </li>
  <li>
  The air must flow from <code>port_a</code> to <code>port_b</code>.
  If there is reverse flow, then no cooling is provided and no power is consumed.
  </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Moved User's Guide to separate subpackage for DX cooling coils, and updated all 
filepaths in links.
</li>
<li>
February 28, 2017 by Yangyang Fu:<br/>
Added desciption about water source DX coil models.
</li>
<li>
September 24, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end UsersGuide;
