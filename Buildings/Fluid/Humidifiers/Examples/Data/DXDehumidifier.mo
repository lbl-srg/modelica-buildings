within Buildings.Fluid.Humidifiers.Examples.Data;
record DXDehumidifier "Example data record for DX dehumidifier model"

  extends Buildings.Fluid.Humidifiers.Data.Generic(
    nWatRem = 6,
    nEneFac = 6,
    watRem = {-2.72487866408,0.100711983591,-9.90538285E-04,0.050053043874,
      -2.03629282E-04,-3.41750531E-04},
    eneFac = {-2.38831907E+00,0.093047739452,-1.36970033E-03,0.066533716758,
      -3.43198063E-04,-5.62490295E-04});

  annotation (preferredView="info",
  Documentation(info="<html>
  <p>This is an example data record for the DX dehumidifier. </p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-91,1},{-8,-54}},
          textColor={0,0,255},
          fontSize=16,
          textString="watRem"),
        Text(
          extent={{2,-16},{94,-38}},
          textColor={0,0,255},
          textString="eneFac",
          fontSize=16)}));
end DXDehumidifier;
