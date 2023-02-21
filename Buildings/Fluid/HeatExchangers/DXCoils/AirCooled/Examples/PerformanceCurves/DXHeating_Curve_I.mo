within Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Examples.PerformanceCurves;
record DXHeating_Curve_I "Performance curve DX heating coil I"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.8720426675,-0.0023934427,-0.0000165785,0.0227700422,0.0001686439,
        -0.0000886025},
    capFunFF={1,0,0,0},
    EIRFunT={0.6969361175,0.012575857,0.0003214811,-0.006662416,0.0005931581,-0.0006690053},
    EIRFunFF={1,0,0,0},
    TConInMin=17.78+273.15,
    TConInMax=23.33+273.15,
    TEvaInMin=-30.56+273.15,
    TEvaInMax=17.22+273.15,
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
end DXHeating_Curve_I;
