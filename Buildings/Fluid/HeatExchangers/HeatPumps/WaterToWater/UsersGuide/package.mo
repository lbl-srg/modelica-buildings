within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;


  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
This package contains models for water to water heat pumps.
</p>
<p>
The following three water to water heat pump models are available:
</p>
<p>
  <table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr>
      <th>Water to water heat pump model</th>
      <th>Properties</th>
      <th>Control signal</th>
    </tr>
    <tr>
      <td><a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.MultiStage\"> 
            Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.MultiStage</a></td>
      <td>Heat pump with multiple operating stages, each stage having a constant speed.
          Each stage has its own performance curve, which may represent
          the heat pump performance at different compressor speed.</td>
      <td>Two integer inputs, <code>heaSta</code> and <code>cooSta</code> representing 
          stage inputs for heating and cooling operation. At a time only one stage 
          input can be nonzero. Operation stage input convention;
                   <i>0</i> for off, 
                   <i>1</i> for first stage, 
                   <i>2</i> for second stage, etc.</td>
    </tr>
    <tr>
      <td><a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.SingleSpeed\"> 
            Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.SingleSpeed</a></td>
      <td>Single speed water to water heat pump (constant compressor speed for a perticular mode of operation).
          Heating and cooling mode can have different compressor speed with different performance curves.</td>
      <td>Single integer input, <code>mode</code>;                    
                   <i>0</i> for off, 
                   <i>1</i> for heating mode, 
                   <i>2</i> for cooling mode.</td>
    </tr>
    <tr>
      <td><a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed\"> 
            Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.VariableSpeed</a></td>
      <td>Heat pump with variable speed compressor with lower speed limit.
          If the control signal is below the lower limit, the
          compressor switches off. It switches on if the control signal
          is above the lower limit plus a hysteresis.
          By default, the minimum speed ratio and the hysteresis for both mode of operation is <i>0.2</i> and <i>0.05</i>.</td>
      <td>Two real number inputs, <code>heaSpeRat</code> and <code>cooSpeRat</code> representing 
          speed ratio inputs for heating and cooling operation. At a time only one speed ratio 
          input can be nonzero. Speed ratio input convention; 
                    <i>0</i> for compressor off, 
                    <i>1</i> for compressor at full speed.</td>
    </tr>
  </table>
</p>

<h4>Heat pump performance</h4>
<p>
The steady-state total rate of heating or cooling and the power consumed by the compressor are
computed using polynomials in the non-dimensional supply temperatures and mass flow rates.
These polynomials are explained at
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.CoolingCapacity</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.HeatingCapacity</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 15, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end UsersGuide;
