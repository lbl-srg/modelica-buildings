within Buildings.Fluid.HeatExchangers.DXCoils;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
This package contains models direct evaporation cooling coils 
(DX coils).
</p>
<p>
The following three DX coil models are available:
</p>
<p>
  <table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr>
      <th>DX coil model</th>
      <th>Properties</th>
      <th>Control signal</th>
    </tr>
    <tr>
      <td>Buildings.Fluid.HeatExchangers.DXCoils.MultiStage</td>
      <td>Coil with multiple operating stages, each with constant speed.
          Each stage has its own performance curve, which may represent
          the coil performance at different compressor speed, or the
          coil performance as it switches between cooling only, cooling
          with hot gas reheat, or heating only.</td>
      <td>Integer; 0 for off, 1 for first stage, 2 for second stage, etc.</td>
    </tr>
    <tr>
      <td>Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</td>
      <td>Single stage compressor with constant speed</td>
      <td>Boolean signal; <code>true</code> if coil is on.</td>
    </tr>
    <tr>
      <td>Buildings.Fluid.HeatExchangers.DXCoils.VariableSpeed</td>
      <td>Variable speed compressor with lower speed limit.
          If the control signal is below the lower limit, the
          coil switches off. It switches on if the control signal
          is above the lower limit plus a hysteresis.</td>
      <td>Real number; 0 for coil off, 1 for coil at full speed.</td>
    </tr>
  </table>
</p>
<h4>Coil performance</h4>
<p>
fixme
</p>
<h4>Evaporation of accumulated water vapor</h4>
<p>
fixme
</p>
<h4>Coil dynamics</h4>
<p>
fixme
</p>
</html>"));
end UsersGuide;
