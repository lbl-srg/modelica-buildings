model VAVBoxExponential 
  "VAV box with a fixed resistance plus a damper model withe exponential characteristics" 
  extends Buildings.Fluids.Actuators.BaseClasses.PartialDamperExponential;
  import SI = Modelica.SIunits;
  
   annotation (Documentation(info="<html>
VAV box plus an air damper with a flow coefficient that is an exponential function of the opening angle.
</html>", revisions="<html>
<ul>
<li>
September 11, 2007 by Michael Wetter:<br>
Redefined <code>kRes</code>, now the pressure drop of the fully open damper is subtracted from the fixed resistance.
<li>
July 27, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(Rectangle(extent=[-78,-40; -46,40], style(
          color=7,
          rgbcolor={255,255,255},
          fillColor=7,
          rgbfillColor={255,255,255})), Rectangle(extent=[-78,2; -46,-4], style(
          pattern=0,
          fillColor=70,
          rgbfillColor={66,105,203},
          fillPattern=1))),
    Diagram);
  parameter SI.MassFlowRate m0_flow "Mass flow rate" annotation(Dialog(group = "Nominal Condition"));
  parameter SI.Pressure dp0(min=0) "Pressure drop, including fully open damper"
                                              annotation(Dialog(group = "Nominal Condition"));
  parameter Real C(min=0)=0.3 
    "Loss coefficient for fully open damper (=total pressure drop over velocity pressure)";
protected 
  parameter SI.Pressure dpDamOpe0 = C*m0_flow^2/2/Medium.density(sta0)/A^2 
    "Pressure drop of fully open damper at nominal flow rate";
  parameter Real kRes(unit="(kg*m)^(1/2)") = m0_flow / sqrt(dp0-dpDamOpe0) 
    "Resistance coefficient for fixed resistance element";
equation 
   kInv = 1/kRes/kRes + 1/kDam/kDam 
    "flow coefficient for resistance base model";
end VAVBoxExponential;
