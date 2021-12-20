within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoolingCapacityWaterCooled
  "Calculates cooling capacity at given temperature and flow fraction for water-cooled DX coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity(
  final use_mCon_flow=true,
  redeclare Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled.Data.Generic.BaseClasses.Stage sta[nSta]);

protected
  Real[nSta] ffCon(each min=0)
    "Water flow fraction: ratio of actual water flow rate by rated mass flow rate at the condenser";

   Real cap_FFCon[nSta](each min=0, each nominal=1, each start=1)
    "Cooling capacity modification factor as a function of water flow fraction at the condenser";

  Real EIR_FFCon[nSta](each min=0, each nominal=1, each start=1)
    "EIR modification factor as a function of water flow fraction at the condenser";
  Real corFacCon[nSta](each min=0, each max=1, each nominal=1, each start=1)
    "Correction factor that is one inside the valid water flow fraction, and attains zero below the valid water flow fraction at the condenser";
  Modelica.Blocks.Interfaces.RealInput mCon_flow_internal
    "Internal connector, needed as mCon_flow can be conditionally removed";
initial algorithm
  // Verify correctness of performance curves, and write warning if error is bigger than 10%
   for iSta in 1:nSta loop

     Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
       Buildings.Fluid.Utilities.extendedPolynomial(
         x=1,
         c=sta[iSta].perCur.capFunFFCon,
         xMin=sta[iSta].perCur.ffConMin,
         xMax=sta[iSta].perCur.ffConMin),
         msg="Capacity as a function of normalized water mass flow rate at the condenser",
         curveName="sta[" + String(iSta) + "].perCur.capFunFFCon");

     Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.warnIfPerformanceOutOfBounds(
       Buildings.Fluid.Utilities.extendedPolynomial(
         x=1,
         c=sta[iSta].perCur.EIRFunFF,
         xMin=sta[iSta].perCur.ffConMin,
         xMax=sta[iSta].perCur.ffConMin),
         msg="EIR as a function of normalized water mass flow rate at the condenser",
         curveName="sta[" + String(iSta) + "].perCur.EIRFunFFCon");
   end for;

equation

   if use_mCon_flow then
     connect(mCon_flow_internal, mCon_flow);
   else
     mCon_flow_internal = 0;
   end if;

    // Modelica requires to evaluate the when() block for each element in iSta=1...nSta.
    // But we only want to check the stage that is currently running.
    // Hence, the test starts with stage == iSta.

if stage > 0 then
    for iSta in 1:nSta loop

    // Compute performance
    ffCon[iSta]=Buildings.Utilities.Math.Functions.smoothMax(
      x1=mCon_flow_internal,
      x2=m_flow_small,
      deltaX=m_flow_small/10)/sta[iSta].nomVal.mCon_flow_nominal;
  //-------------------------Cooling capacity modifiers----------------------------//

    cap_FFCon[iSta] = Buildings.Fluid.Utilities.extendedPolynomial(
      x=ff[iSta],
      c=sta[iSta].perCur.capFunFFCon,
      xMin=sta[iSta].perCur.ffConMin,
      xMax=sta[iSta].perCur.ffConMin);
    //-----------------------Energy Input Ratio modifiers--------------------------//
    EIR_FFCon[iSta] = Buildings.Fluid.Utilities.extendedPolynomial(
       x=ff[iSta],
       c=sta[iSta].perCur.EIRFunFFCon,
       xMin=sta[iSta].perCur.ffConMin,
       xMax=sta[iSta].perCur.ffConMin)
        "Cooling capacity modification factor as function of flow fraction";
    //------------ Correction factor for flow rate outside of validity of data ---//
    corFacCon[iSta] =Buildings.Utilities.Math.Functions.smoothHeaviside(
       x=ffCon[iSta] - sta[iSta].perCur.ffConMin/4,
       delta=max(Modelica.Constants.eps, sta[iSta].perCur.ffConMin/4));

    Q_flow[iSta] = corFac[iSta]*corFacCon[iSta]*cap_T[iSta]*cap_FF[iSta]*cap_FFCon[iSta]*sta[iSta].nomVal.Q_flow_nominal;
    EIR[iSta]    = corFac[iSta]*corFacCon[iSta]*EIR_T[iSta]*EIR_FF[iSta]*EIR_FFCon[iSta]/sta[iSta].nomVal.COP_nominal;
    end for;
  else //cooling coil off
   ffCon     = fill(0, nSta);
   cap_FFCon = fill(0, nSta);
   EIR_FFCon = fill(0, nSta);
   corFacCon = fill(0, nSta);
   Q_flow = fill(0, nSta);
   EIR    = fill(0, nSta);
  end if;
   annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(T,m)")}),
          Documentation(info="<html>
<p>
  This model calculates cooling capacity and EIR at off-designed conditions for water-cooled DX coils.
  The difference between air-cooled and water-cooled DX coils is that water-cooled DX coils require
  two additional modifer curves for total cooling capacity and EIR
  as a function of water mass flowrate at the condensers.
</p>
<h4>Total Cooling Capacity</h4>
<p>
  The total cooling capacity at off-designed conditions for water-cooled DX coils is calculated as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
     Q̇(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>, ff) = cap<sub>&theta;</sub>(&theta;<sub>e,in</sub>, &theta;<sub>c,in</sub>) cap<sub>FF</sub>(ff) cap<sub>FFCon</sub>(ffCon) Q̇<sub>nom</sub>
</p>
<p>
  where <i>cap<sub>FFCon</sub>(ffCon)</i> is the additional modifier for cooling capacity, and calculated as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
     capCon<sub>FFCon</sub>(ffCon) = b<sub>1</sub> + b<sub>2</sub> ffCon + b<sub>3</sub> ffCon<sup>2</sup> + b<sub>4</sub>ffCon<sup>3</sup> + ...
</p>
<p>
   where the variable <i>ffCon</i> is the nomalized mass flow rate at the condenser, and calculated as:
</p>
<p align=\"center\" style=\"font-style:italic;\">
     ffCon = ṁCon &frasl; ṁCon<sub>nom</sub>
</p>
<p>
  where <i>ṁCon</i> is the mass flow rate at the condenser and <i>ṁCon<sub>nom</sub></i>
  is the nominal mass flow rate at the condenser.
</p>
<h4>Energy Input Ratio (EIR)</h4>
<p>
  The Energy Input Ratio (<i>EIR</i>) is the inverse of the Coefficient of Performance (<i>COP</i>).
  Similar to the cooling capacity modifiers, the change in EIR due to change in water mass flow rate at the condenser is
</p>
<p align=\"center\" style=\"font-style:italic;\">
     EIR<sub>FFCon</sub>(ffCon) = b<sub>1</sub> + b<sub>2</sub> ffCon + b<sub>3</sub> ffCon<sup>2</sup> + b<sub>4</sub>ffCon<sup>3</sup> + ...
</p>
<p>
  where the six coefficients are obtained from the coil performance data record.
  See <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity\">Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoolingCapacity</a> for more information.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 17, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
<li>
October 21, 2019, by Michael Wetter:<br/>
Ensured that transition interval for computation of <code>corFac</code> is non-zero.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">issue 1202</a>.
</li>
</ul>

</html>"));
end CoolingCapacityWaterCooled;
