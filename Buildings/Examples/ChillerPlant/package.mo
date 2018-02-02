within Buildings.Examples;
package ChillerPlant "Chiller plant with water side economizer for data center"


extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with water-side economizer (WSE) to cool a data center.
The system schematics is as shown below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/ChillerPlant/chillerSchematics.png\" border=\"1\"/>
</p>
<p>
The system is a primary-only chiller plant with integrated WSE.
The objective was to improve the energy efficiency of the chilled water plant by optimizing the control setpoints.
The room of the data center was modeled using a mixed air volume with a heat source.
Heat conduction and air infiltration through the building envelope were neglected since the heat exchange between the room and the ambient environment was small compared to the heat released by the computers.
</p>
<p>
The control objective was to maintain the temperature of the supply air to the room, while reducing energy consumption of the chilled water plant.
The control was based on the control sequence proposed by Stein (2009).
To simplify the implementation, we only applied the controls for the differential pressure of the chilled water loop, the setpoint temperature of the chilled water leaving the chiller, and the chiller and WSE on/off control.
</p>
<h4>Enabling/Disabling the WSE</h4>
<p>
The WSE is enabled when
</p>
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li>
<i>
  T<sub>ws</sub> &gt; 0.9 T<sub>wet</sub> + &Delta;T<sub>t</sub> + &Delta;T<sub>w</sub>
</i>
</li>
</ol>
<p>
where <i>T<sub>ws</sub></i> is the temperature of chilled water leaving the cooling coil,
<i>T<sub>wet</sub></i> is the wet bulb temperature,
<i>&Delta;T<sub>t</sub></i> is the temperature difference between the water leaving the cooling tower and the air entering the cooling tower,
<i>&Delta;T<sub>w</sub></i> is the temperature difference between the chilled water leaving the WSE and the condenser water entering the WSE.
</p>
<p>
The WSE is disabled when
</p>
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li><i>
  T<sub>ws</sub> &lt; T<sub>wc</sub> + &Delta;T<sub>wse,off</sub>
</i>
</li>
</ol>
<p>
where <i>T<sub>wc</sub></i> is the temperature of condenser water leaving the cooling tower,  <i>&Delta;T<sub>wse,off</sub> = 0.6 K</i> is the offset temperature.
</p>
<h4>Enabling/Disabling the Chiller</h4>
<p>
The control strategy is as follows:
</p>
<ul>
<li>The chiller is enabled when
<i>
  T<sub>chw,ent</sub> &gt; T<sub>chi,set</sub> + &Delta;T<sub>chi,ban</sub> </i>
<li>The chiller is disabled when
<i>
  T<sub>chw,ent</sub> &le; T<sub>chi,set</sub></i>
</li>
</ul>
<p>
where <i>T<sub>chw,ent</sub></i> is the tempearture of chilled water entering the chiller, <i>T<sub>chi,set</sub></i> is the setpoint temperature of the chilled water leaving the chiller, and <i>&Delta;T<sub>chi,ban</sub></i> is the dead-band to prevent short cycling.
</p>
<h4>Setpoint Reset</h4>
<p>
The setpoint reset strategy is to first increase the different pressure, <i>&Delta;p</i>, of the chilled water loop to increase the mass flow rate.
If <i>&Delta;p</i> reaches the maximum value and further cooling is still needed, the chiller remperature setpoint, <i>T<sub>chi,set</sub></i>, is reduced.
If there is too much cooling, the <i>T<sub>chi,set</sub></i> and <i>&Delta;p</i>  will be changed in the reverse direction.
</p>
<p>
There are two implementations for the setpoint reset.
</p>
<p>
The model
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</a>
implements a discrete time trim and respond logic as follows:
</p>
<ul>
<li>A cooling request is triggered if the input signal, <i>y</i>, is larger than 0.
<i>y</i> is the difference between the actual and set temperature of the suppuly air to the data center room.</li>
<li>The request is sampled every 2 minutes. If there is a cooling request, the control signal <i>u</i> is increased by <i>0.03</i>, where <i>0 &le; u &le; 1</i>.
If there is no cooling request,  <i>u</i> is decreased by <i>0.03</i>. </li>
</ul>
<p>
The model
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a> uses a PI-controller to
approximate the above trim and respond logic. This significantly reduces computing time.
</p>
<p>
For both models, the control signal <i>u</i> is converted to setpoints for <i>&Delta;p</i> and <i>T<sub>chi,set</sub></i> as follows:
</p>
<ul>
<li>
If <i>0 &le; u &le; x</i> then <i>&Delta;p = &Delta;p<sub>min</sub> + u &nbsp;(&Delta;p<sub>max</sub>-&Delta;p<sub>min</sub>)/x</i>
and <i>T = T<sub>max</sub></i></li>
<li>
If <i> x &lt; u &le; 1</i> then <i>&Delta;p = &Delta;p<sub>max</sub></i>
and
<i>T = T<sub>max</sub> - (u-x)&nbsp;(T<sub>max</sub>-T<sub>min</sub>)/(1-x)
</i></li>
</ul>
<p>
where <i>&Delta;p<sub>min</sub></i> and <i>&Delta;p<sub>max</sub></i> are minimum and maximum values for <i>&Delta;p</i>,
and <i>T<sub>min</sub></i> and <i>T<sub>max</sub></i> are the minimum and maximum values for <i>T<sub>chi,set</sub></i>.
</p>
<h4>Reference</h4>
<p>
Stein, J. (2009). Waterside Economizing in Data Centers: Design and Control Considerations. ASHRAE Transactions, 115(2), 192-200.<br/>
Taylor, S.T. (2007). Increasing Efficiency with VAV System Static Pressure Setpoint Reset. ASHRAE Journal, June, 24-32.
</p>
</html>"));
end ChillerPlant;
