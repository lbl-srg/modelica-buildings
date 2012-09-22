within Buildings.Fluid.HeatExchangers.DXCoils;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
This package contains models for direct evaporation cooling coils 
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
      <td>Coil with multiple operating stages, each stage having a constant speed.
          Each stage has its own performance curve, which may represent
          the coil performance at different compressor speed, or the
          coil performance as it switches between cooling only, cooling
          with hot gas reheat, or heating only.</td>
      <td>Integer; <i>0</i> for off, 
                   <i>1</i> for first stage, 
                   <i>2</i> for second stage, etc.</td>
    </tr>
    <tr>
      <td>Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</td>
      <td>Single stage coil with constant compressor speed</td>
      <td>Boolean signal; <code>true</code> if coil is on.</td>
    </tr>
    <tr>
      <td>Buildings.Fluid.HeatExchangers.DXCoils.VariableSpeed</td>
      <td>Coil with variable speed compressor with lower speed limit.
          If the control signal is below the lower limit, the
          coil switches off. It switches on if the control signal
          is above the lower limit plus a hysteresis.
          By default, the minimum speed ratio is <code>minSpeRat</code>
          and obtained from the coil data record <code>datCoi.minSpeRat</code>.
          The hysteresis is by default <code>speDeaBanRat=0.05</code>.</td>
      <td>Real number; <i>0</i> for coil off, <i>1</i> for coil at full speed.</td>
    </tr>
  </table>
</p>
<h4>Coil performance</h4>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity</a>.
Fixme.
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
