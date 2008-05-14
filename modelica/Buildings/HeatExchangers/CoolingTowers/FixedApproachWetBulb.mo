model FixedApproachWetBulb 
  "Cooling tower with fixed approach temperature based on wet bulb temperature" 
  extends 
    Buildings.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticFourPortCoolingTower;
  annotation (Icon(
      Text(
        extent=[-62,40; 60,-84],
        style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=58,
          rgbfillColor={0,127,0},
          fillPattern=1),
        string="dry-bulb")),
                          Diagram,
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with constant approach temperature.
</p>
<p>
This model uses the wet bulb temperature in computing the approach temperature.
For an equivalent model that uses the dry bulb temperature,
use <a href=\"Modelica:FixedApproachDryBulb.mo\">
FixedApproachWetBulb.mo</a>.
Since the approach temperature is constant, a large enough air mass flow rate
need to be specified to avoid that the air outlet temperature is higher
than the water inlet temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Modelica.SIunits.Temperature TApp = 2 "Approach temperature";
  Modelica.SIunits.Temperature TAirInWB(start=273.15+20) 
    "Air wet-bulb inlet temperature";
  Modelica.SIunits.CelsiusTemperature TAirInWB_degC 
    "Air wet-bulb inlet temperature";
protected 
  Utilities.Psychrometrics.WetBulbTemperature wetBulMod(redeclare package 
      Medium = Medium_2, p(start=101325)) 
    "Model to compute wet bulb temperature" 
    annotation (extent=[-56,50; -36,70]);
  
equation 
  // compute wet bulb temperature
  wetBulMod.dryBul.h  = medium_a2.h;
  wetBulMod.dryBul.p  = medium_a2.p;
  wetBulMod.dryBul.Xi = medium_a2.Xi;
  TAirInWB = wetBulMod.TWetBul;
  TAirInWB_degC = Modelica.SIunits.Conversions.to_degC(TAirInWB);
  TWatOut_degC = TApp + TAirInWB_degC;
  
  assert(TAirOut_degC < TWatIn_degC, "Cooling tower violates second law.\n"
          + "  Try to increase the air flow rate.\n"
          + "  TWatIn_degC  = " + realString(TWatIn_degC) + "\n"
          + "  TWatOut_degC = " + realString(TWatOut_degC) + "\n"
          + "  TAirIn_degC  = " + realString(TAirIn_degC) + "\n"
          + "  TAirOut_degC = " + realString(TAirOut_degC) + "\n"
          + "  mAir_flow    = " + realString(m_flow_2) + "\n"
          + "  mWat_flow    = " + realString(m_flow_1) + "\n"
          + "  CAir_flow    = "
          + realString(Medium_2.specificHeatCapacityCp(medium_a2)*m_flow_1) + "\n"
          + "  CWat_flow    = "
          + realString(Medium_1.specificHeatCapacityCp(medium_a1)*m_flow_1));
  
end FixedApproachWetBulb;
