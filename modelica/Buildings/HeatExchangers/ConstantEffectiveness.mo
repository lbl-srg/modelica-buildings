model ConstantEffectiveness "Heat exchanger with constant effectiveness" 
  extends Fluids.Interfaces.PartialStaticFourPortHeatMassTransfer;
  extends Buildings.BaseClasses.BaseIcon;
  annotation (Icon(
      Rectangle(extent=[-70,80; 70,-80], style(
          pattern=0,
          fillColor=10,
          rgbfillColor={95,95,95})),
      Text(
        extent=[-56,-12; 54,-72],
        string="eps=%eps",
        style(color=7, rgbcolor={255,255,255})),
      Rectangle(extent=[-100,61; -70,58], style(
          color=3,
          rgbcolor={0,0,255},
          pattern=0,
          fillColor=74,
          rgbfillColor={0,0,127},
          fillPattern=1)),
      Text(
        extent=[-122,106; -78,78],
        style(color=3, rgbcolor={0,0,255}),
        string="u")),
Documentation(info="<html>
<p>
Model for a heat exchanger with constant effectiveness.
</p>
<p>
This model transfers heat in the amount of 
<pre>
  Q = Q_max * eps,
</pre>
where <tt>eps</tt> is a constant effectiveness and 
<tt>Q_max</tt> is the maximum heat that can be transferred.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"Modelica:Buildings.MassExchangers.ConstantEffectiveness\">
Buildings.MassExchangers.ConstantEffectiveness</a>
instead of this model.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Real eps(min=0, max=1) = 0.8 "Heat exchanger effectiveness";
  
  Modelica.SIunits.Temperature T_in1 "Inlet temperature medium 1";
  Modelica.SIunits.Temperature T_in2 "Inlet temperature medium 2";
  Modelica.SIunits.ThermalConductance C_flow_1 
    "Heat capacity flow rate medium 1";
  Modelica.SIunits.ThermalConductance C_flow_2 
    "Heat capacity flow rate medium 2";
  Modelica.SIunits.ThermalConductance CMin_flow(min=0) 
    "Minimum heat capacity flow rate";
  Modelica.SIunits.HeatFlowRate QMax_flow "Maximum heat flow rate";
  
equation 
  // definitions for heat transfer effectiveness model
  T_in1 = if m_flow_1 >= 0 then medium_a1.T else medium_b1.T;
  T_in2 = if m_flow_2 >= 0 then medium_a2.T else medium_b2.T;
  C_flow_1 = abs(m_flow_1)
          * Medium_1.specificHeatCapacityCp(Medium_1.setState_pTX(medium_a1.p,
                medium_a1.T, medium_a1.X));
  C_flow_2 = abs(m_flow_2)
          * Medium_2.specificHeatCapacityCp(Medium_2.setState_pTX(medium_a2.p,
                medium_a2.T, medium_a2.X));
  
  CMin_flow = min( C_flow_1, C_flow_2);
  QMax_flow = CMin_flow * (T_in2 - T_in1);
  
  // transferred heat
  Q_flow_1 = eps * QMax_flow;
  0 = Q_flow_1 + Q_flow_2;
  
  // no mass exchange
  mXi_flow_1 = zeros(Medium_1.nXi);
  mXi_flow_2 = zeros(Medium_2.nXi);
  
  // no pressure drop
  dp_1 = 0;
  dp_2 = 0;
end ConstantEffectiveness;
