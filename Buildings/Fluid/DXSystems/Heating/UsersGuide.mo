within Buildings.Fluid.DXSystems.Heating;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package contains models for direct evaporation (DX) system heating coils.
</p>
<p>
The following DX coil model is available:
</p>
  <table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
  <tr>
      <th>DX coil evaporator</th>
      <th>DX coil model</th>
      <th>Properties</th>
      <th>Control signal</th>
  </tr>
  <tr valign=\"top\">
      <td>Air source</td>
      <td><a href=\"modelica://Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed\">
                               Buildings.Fluid.DXSystems.Heating.AirSource.SingleSpeed</a></td>
      <td>Single stage coil with constant compressor speed</td>
      <td>Boolean signal; <code>true</code> if coil is on.</td>
  </tr>
</table>
<h4>Control of the coils</h4>
<p>
The DX coil model takes an on/off signal as a control input. Because the thermal
response of the coil is very fast, it is important to use the room air temperature
as the controlled variable, as it has a much slower response compared to the supply
air temperature. If the supply air temperature is used, then the control algorithm
should be designed to avoid short-cycling.
</p>
<h4>Coil performance</h4>
<p>
The steady-state total rate of heating and the Energy Input Ratio (EIR)
are computed using polynomials in the air mass flow fraction, condenser air inlet
temperature, and outdoor air temperature, as explained at
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityAirSource\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityAirSource</a>.
</p>
<h4>Defrost operation</h4>
<p>
The coil model calculates the defrost operation of the outdoor evaporator coil
analytically using the blocks <a href=\"modelica://Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations\">
Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations</a>
(which calculates the time duration fraction for which the coil is assumed to be
in defrost mode)and <a href=\"modelica://Buildings.Fluid.DXSystems.Heating.BaseClasses.DefrostCapacity\">
Buildings.Fluid.DXSystems.Heating.BaseClasses.DefrostCapacity</a> (which calculates
the heat transferred from the indoor airstream to the outdoor coil for defrost).
The user needs to keep in mind that there is no actual defrost mode operation. The
model only calculates a theoretical time fraction (of a constant, assumed timestep)
that the coil enters defrost mode, and calculates heat transfer for it.
</p>
<h4>Coil dynamics</h4>
<p>
The dynamics of the condenser is approximated by a first order response
where the time constant is a model parameter.
Hence, the dynamic response is similar to other models of the <code>Buildings.Fluid</code> package and described at
<a href=\"modelica://Buildings.Fluid.UsersGuide\">Buildings.Fluid.UsersGuide</a>.
</p>
<h4>Limitations</h4>
<p>This model has the following limitations: </p>
<ul>
<li>The coil model does not account for fan in the condenser air stream.
   Fans can be modeled separately using models from the package <a href=\"modelica://Buildings.Fluid.Movers\">Buildings.Fluid.Movers</a>.
   However, if the performance curve for the energy input ratio contains electricity
   use for a fan, then this is of course reflected by the model output.
  </li>
  <li>
  The air must flow from <code>port_a</code> to <code>port_b</code>. If there is reverse flow, then no
  heating is provided and no power is consumed.
  </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end UsersGuide;
