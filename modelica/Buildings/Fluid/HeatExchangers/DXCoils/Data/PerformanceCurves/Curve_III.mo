within Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves;
record Curve_III "Curve_III"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.Data.PerformanceCurves.BaseClasses.Generic(
    each capFunT={0.476428,0.0401147000,0.0002264110,-0.0008271360,-0.0000073224,
        -0.0004462780},
    each capFunFF={0.47278589,1.2433415,-1.0387055,0.32257813},
    each EIRFunT={0.632475,-0.0121321000,0.0005077730,0.0155377000,0.0002728400,
        -0.0006792010},
    each EIRFunFF={1.0079484,0.34544129,-.6922891,0.33889943},
    each TConInRanCap={297.03889,319.26111},
    each TWetBulInRanCap={285.92778,297.03889},
    each ffRanCap={0.5,1.5},
    each TConInRanEIR={297.03889,319.26111},
    each TWetBulInRanEIR={285.92778,297.03889},
    each ffRanEIR={0.5,1.5});
  annotation (defaultComponentName="per", Documentation(info="<html>
This record has default performance curves coefficents with min-max range 
for cooling capacity and EIR curve-fits obtained from ExampleFiles of EnergyPlus 7.1 
(5ZoneAutoDXVAV.idf). 
</html>",
revisions="<html>
<ul>
<li>
August 15, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-95,53},{-12,-2}},
          lineColor={0,0,255},
          textString="capFunT"),
        Text(
          extent={{7,55},{90,0}},
          lineColor={0,0,255},
          textString="%capFunT"),
        Text(
          extent={{-105,-9},{-48,-48}},
          lineColor={0,0,255},
          textString="capFunFF"),
        Text(
          extent={{2,-16},{94,-38}},
          lineColor={0,0,255},
          textString="%capFunFF"),
        Text(
          extent={{-95,-49},{-12,-104}},
          lineColor={0,0,255},
          textString="EIRFunT"),
        Text(
          extent={{7,-53},{84,-94}},
          lineColor={0,0,255},
          textString="%EIRFunT")}));
end Curve_III;
