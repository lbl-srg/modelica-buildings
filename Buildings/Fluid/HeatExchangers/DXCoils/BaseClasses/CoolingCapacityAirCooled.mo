﻿within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoolingCapacityAirCooled
  "Calculates cooling capacity at given temperature and flow fraction for air-cooled coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity(
  redeclare replaceable Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage sta[nSta],
  use_mCon_flow=false);

equation
 if stage > 0 then
    for iSta in 1:nSta loop

    Q_flow[iSta] = corFac[iSta]*cap_T[iSta]*cap_FF[iSta]*sta[iSta].nomVal.Q_flow_nominal;
    EIR[iSta]    = corFac[iSta]*EIR_T[iSta]*EIR_FF[iSta]/sta[iSta].nomVal.COP_nominal;
    end for;
 else //cooling coil off
   Q_flow = fill(0, nSta);
   EIR    = fill(0, nSta);
  end if;
   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<p>
This model calculates cooling capacity and EIR for air-cooled DX coils in off-designed conditions based on
performance modifers calculated in partial model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity\">Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity</a>.
</p>
<h4>Cooling capacity</h4>
<p>
The cooling capacity modifiers are multiplied with nominal cooling capacity to obtain
the cooling capacity of the coil at given inlet temperatures and mass flow rate as
</p>
<p align=\"center\" style=\"font-style:italic;\">
      Q̇(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>, ff) = cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) cap<sub>FF</sub>(ff) Q̇<sub>nom</sub>,
</p>
<p>
  where <i>&theta;<sub>e,in</sub></i> is the evaporator inlet temperature
  and <i>&theta;<sub>c,in</sub></i> is the condenser inlet temperature in degrees Celsius.
  <i>&theta;<sub>e,in</sub></i> is the dry-bulb temperature if the coil is dry,
  or the wet-bulb temperature if the coil is wet.
  <i>cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub></i>) is
  cooling capacity modifier as a function of temperature.
  cap<sub>FF</sub>(ff) is cooling capacity modifier as a function of
  nomalized mass flowrate at the evaporator.
</p>
<h4>Energy Input Ratio (EIR)</h4>
<p>
  The Energy Input Ratio (<i>EIR</i>) is the inverse of the Coefficient of Performance (<i>COP</i>).
  Similar to the cooling rate, the EIR of the coil is the product of a function that
  takes into account changes in condenser and evaporator inlet temperatures,
  and changes in mass flow rate. The EIR is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
     EIR(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>, ff) = EIR<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) EIR<sub>FF</sub>(ff) &frasl; COP<sub>nominal</sub>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>

</html>"));
end CoolingCapacityAirCooled;
