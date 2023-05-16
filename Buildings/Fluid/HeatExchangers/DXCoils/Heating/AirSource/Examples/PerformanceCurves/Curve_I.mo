within Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Examples.PerformanceCurves;
record Curve_I "DX heating coil performance curve I"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.9135970355,0.0127860478,0.0000527533,-0.0005917719,0.000136017,
        -0.0000894155},
    capFunFF={0.84,0.16,0,0},
    EIRFunT={0.6019839404,-0.0053765594,0.000773762,0.0186496391,0.0002225627,-0.0008182042},
    EIRFunFF={1.3824,-0.4336,0.0512},
    TConInMin=17.78+273.15,
    TConInMax=23.33+273.15,
    TEvaInMin=-30.56+273.15,
    TEvaInMax=17.22+273.15,
    ffMin=0.5,
    ffMax=1.5);

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares performance curves for the heating capacity and the EIR for use in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Examples.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Examples.SingleSpeed</a>.
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
end Curve_I;
