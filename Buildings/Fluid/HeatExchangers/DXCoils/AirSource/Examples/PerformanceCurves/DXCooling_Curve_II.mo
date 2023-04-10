within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves;
record DXCooling_Curve_II "DX cooling coil performance curve II"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.766956,0.0107756,-0.0000414703,0.00134961,-0.000261144,
        0.000457488},
    capFunFF={0.8,0.2,0,0},
    EIRFunT={0.297145,0.0430933,-0.000748766,0.00597727,0.000482112,-0.000956448},
    EIRFunFF={1.1552,-0.1808,0.0256,0},
    TConInMin=291.15,
    TConInMax=319.26111,
    TEvaInMin=285.92778,
    TEvaInMax=297.03889,
    ffMin=0.5,
    ffMax=1.5);

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares performance curves for the cooling capacity and the EIR.
It has been obtained from the EnergyPlus 7.1 example file
<code>DXCoilSystemAuto.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2023, by Karthik Devaprasad:<br/>
Added prefix <code>DXCooling_</code> to record class name.
</li>
<li>
April 9, 2021, by Michael Wetter:<br/>
Corrected placement of <code>each</code> keyword.<br/>
See <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/2440\">Buildings, PR #2440</a>.
</li>
<li>
September 25, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
August 15, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          textColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          textColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          textColor={0,0,255},
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          textColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          textColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          textColor={0,0,255},
          textString="%EIRFunT")}));
end DXCooling_Curve_II;
