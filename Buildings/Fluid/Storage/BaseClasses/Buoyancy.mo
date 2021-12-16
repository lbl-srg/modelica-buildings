within Buildings.Fluid.Storage.BaseClasses;
model Buoyancy
  "Model to add buoyancy if there is a temperature inversion in the tank"
  extends Modelica.Blocks.Icons.Block;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium model"  annotation (
      choicesAllMatching = true);
  parameter Modelica.Units.SI.Volume V "Volume";
  parameter Integer nSeg(min=2) = 2 "Number of volume segments";
  parameter Modelica.Units.SI.Time tau(min=0) "Time constant for mixing";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heatPort
    "Heat input into the volumes"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.HeatFlowRate[nSeg - 1] Q_flow
    "Heat flow rate from segment i+1 to i";
protected
   parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(T=Medium.T_default,
         p=Medium.p_default, X=Medium.X_default[1:Medium.nXi])
    "Medium state at default properties";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid mass";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(sta_default) "Specific heat capacity";
   parameter Real k(unit="W/K") = V*rho_default*cp_default/tau/nSeg
    "Proportionality constant, since we use dT instead of dH";
  Modelica.Units.SI.TemperatureDifference dT[nSeg - 1]
    "Temperature difference between adjoining volumes";
equation
  for i in 1:nSeg-1 loop
    dT[i] = heatPort[i+1].T-heatPort[i].T;
    Q_flow[i] = k*noEvent(smooth(1, if dT[i]>0 then dT[i]^2 else 0));
  end for;

  heatPort[1].Q_flow = -Q_flow[1];
  for i in 2:nSeg-1 loop
       heatPort[i].Q_flow = -Q_flow[i]+Q_flow[i-1];
  end for;
  heatPort[nSeg].Q_flow = Q_flow[nSeg-1];
  annotation (Documentation(info="<html>
<p>
This model outputs a heat flow rate that can be added to fluid volumes
in order to emulate buoyancy during a temperature inversion.
For simplicity, this model does not compute a buoyancy induced mass flow rate,
but rather a heat flow that has the same magnitude as the enthalpy flow
associated with the buoyancy induced mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2018 by Filip Jorissen:<br/>
Copied model from Buildings and update the model accordingly.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/314\">#314</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with naming convention.
</li>
<li>
October 8, 2011 by Michael Wetter:<br/>
Added <code>noEvent(...)</code> to
<code>Q_flow[i] = k*smooth(1, if dT[i]>0 then dT[i]^2 else 0);</code>
since the equation returns the same value to the left and right of
<code>dT[i]>0</code>.
</li>
<li>
September 16, 2011 by Michael Wetter:<br/>
Changed the implementation from <code>Q_flow[i] = k*max(heatPort[i+1].T-heatPort[i].T, 0);</code> to
<code>Q_flow[i] = k*smooth(1, if dT[i]>0 then dT[i]^2 else 0);</code>.
The previous implementation was not differentiable. In modeling a solar system, this
change reduced the computing time by a factor of 20 during the time when the pumps
were almost switched off and colder temperature was fed from the collector to the tank.
</li>
<li>
October 28, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-44,68},{36,28}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,-26},{38,-66}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,10},{32,-22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{28,22},{22,10},{36,10},{36,10},{28,22}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,22},{-26,-10}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-18},{-36,-6},{-22,-6},{-22,-6},{-28,-18}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}));
end Buoyancy;
