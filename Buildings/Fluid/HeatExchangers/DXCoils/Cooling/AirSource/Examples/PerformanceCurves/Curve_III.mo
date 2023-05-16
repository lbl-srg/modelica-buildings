within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Examples.PerformanceCurves;
record Curve_III "DX cooling coil performance curve III"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.476428,0.0401147000,0.0002264110,-0.0008271360,-0.0000073224,
        -0.0004462780},
    capFunFF={0.47278589,1.2433415,-1.0387055,0.32257813},
    EIRFunT={0.632475,-0.0121321000,0.0005077730,0.0155377000,0.0002728400,
        -0.0006792010},
    EIRFunFF={1.0079484,0.34544129,-0.6922891,0.33889943},
    TConInMin=297.03889,
    TConInMax=319.26111,
    TEvaInMin=285.92778,
    TEvaInMax=297.03889,
    ffMin=0.5,
    ffMax=1.5);
  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares performance curves for the cooling capacity and the EIR.
It has been obtained from the EnergyPlus 7.1 example file
<code>5ZoneAutoDXVAV.idf</code>.
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
end Curve_III;
