within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves;
record DXHeating_Curve_I "Performance curve DX heating coil I"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.5120426675,0.0227700422,0.0000806439,-0.0023934427,-0.0000165785,
        -0.0000886025},
    capFunFF={1,0,0,0},
    EIRFunT={0.7969361175,-0.006662416,0.0005931581,0.012575857,0.0003214811,-0.0006690053},
    EIRFunFF={1,0,0,0},
    TConInMin=17.78+273.15,
    TConInMax=23.33+273.15,
    TEvaInMin=-30.56+273.15,
    TEvaInMax=17.22+273.15,
    ffMin=0.5,
    ffMax=1.5);

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares performance curves for the heating capacity and the EIR for use in
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.SingleSpeedHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.SingleSpeedHeating</a>.
It has been obtained from the EnergyPlus 9.6 example file
<code>PackagedTerminalHeatPump.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 08, 2023 by Xing Lu and Karthik Devaprasad:<br/>
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
